# Plan Técnico: Comunicaciones Masivas por WhatsApp

**Proyecto:** Encuestas y Notificaciones WA — Grupo Vemare  
**Versión:** 7.0.0 · Junio 2026  
**Stack:** n8n · WhatsApp Business Cloud API (Flows) · monday.com · Mailjet · PostgreSQL · Power BI  
**Modelo de datos encuestas:** v8.12.0 (diccionario agnóstico de canal)

---

## 0. Decisiones de arquitectura

### 0.1 Fuente de datos de contactos

`public.contactos` (PK `id_mailjet bigint`) es la tabla de contactos del sistema inbound/chatbot existente y la fuente para las campañas WA. No se modifica.

Campos relevantes para WA:

| Campo | Uso |
|---|---|
| `telefono_wa` | Número de envío WA |
| `activo` | Filtro opt-in (`'1'` = activo) |
| `listas_mailjet` | Segmentación de campañas (filtro ILIKE) |
| `razon_social` | Nombre de la empresa del contacto |
| `codigo_isi_vemare` / `_transcose` / `_dieseliberia` / `_paher` | ISI del cliente por empresa emisora |
| `distribuidor_vemare` / `_transcose` / `_dieseliberia` / `_paher` | Pertenencia del contacto a cada empresa (vacío = no pertenece) |

**La query de contactos es empresa-dependiente.** Para cada empresa emisora se filtra por `distribuidor_{empresa}` y se extrae `codigo_isi_{empresa}`. Ver §6.2.

**Nota EDI/DIESELIBERIA:** en `public.contactos` las columnas son `_dieseliberia`, pero en IT y en el board de monday el código de empresa es `EDI`. El mapeo es: `EDI → distribuidor_dieseliberia / codigo_isi_dieseliberia`.

### 0.2 flow_token = id_envio

El UUID de `public.encuestas_envios.id_envio` se pasa como `flow_token` a Meta al enviar el WA Flow. Cuando llega el `nfm_reply`, n8n hace lookup por PK: `WHERE id_envio = flow_token::uuid`. Sin columna extra, deduplicación determinista.

### 0.3 maestro y public en el mismo cluster PostgreSQL

El schema `maestro` y el schema `public` deben residir en el **mismo servidor PostgreSQL**. Las referencias cross-schema en n8n usan la misma credencial de conexión, con privilegios de escritura en `public` y solo lectura en `maestro`.

### 0.4 generar_version_ponderaciones — función invocable, no trigger

Las ponderaciones se generan llamando explícitamente a `maestro.generar_version_ponderaciones(:id_encuesta)`. Esto evita versiones intermedias sucias al cargar preguntas de golpe. Marketing decide cuándo dar una versión por cerrada.

---

## 1. Estado actual del proyecto

| Componente | Estado | Versión | Notas |
|---|---|---|---|
| WF-SYNC-CONTACTOS | ✅ Operativo | v6 | Sync Mailjet → `public.contactos`. Sin cambios necesarios. |
| Flujo Inbound WA | ✅ Operativo | TEST | Chatbot existente. No se modifica salvo adición de rama `nfm_reply`. |
| Schema `public` existente | ✅ Operativo | — | `contactos` (fuente de verdad), `leads`, `sesiones`, `telefonos`. No se toca. |
| Tablas WA schema `encuestas` | 🔲 Pendiente | v7.0 | `encuestas.empresas_wa`, `encuestas.campanas_wa`, `encuestas.envios_wa`, `encuestas.respuestas_wa`. Ejecutar `encuestas-wa-schema.sql`. |
| Schema `maestro` IT | ✅ Ejecutado por IT | v1.0 | Diccionario de encuestas. Solo lectura para n8n. |
| WF-01-OUTBOUND-WA | 🔲 Pendiente | v7.0 | Modos EQUIPO / REAL Lista / REAL Manual. |
| WF-02-INBOUND-RESPUESTA | 🔲 Pendiente | v7.0 | Captura `nfm_reply`, llama SWF-NORMALIZAR. |
| WF-03-STATUS-TRACKER | 🔲 Pendiente | v7.0 | Callbacks delivery Meta. |
| WF-04-REPORTE | 🔲 Pendiente | v7.0 | Reporte diario 8:00 AM → contadores monday. |
| Board monday Comunicaciones WA | 🔲 Pendiente | v7.0 | Un board con dos vistas. |
| Templates Meta (×3) | 🔲 Pendiente | — | `encuesta_wa`, `notificacion_con_url`, `notificacion_sin_url`. Revisar Meta (24-72h). |
| WA Flow publicado | 🔲 Pendiente | — | Flow de encuesta en Meta Flow Builder. |
| Tier Meta confirmado | ⚠️ Verificar | — | 22.500 contactos → requiere Tier 3. Confirmar antes de Fase 7. |

---

## 2. Arquitectura del sistema

### 2.1 Niveles

- **Generador:** Canal de origen — WhatsApp, Email, QR, Físico, Teléfono, App/Web.
- **Planificador:** Herramienta que orquesta — **n8n** (este proyecto), SurveyMonkey, BLIP, Enruta, Finesse.
- **Recolector:** PostgreSQL WA (inmediato) → Extranet IT (destino futuro, mismo modelo exacto).
- **Analítico:** Power BI filtrando `ejecuciones_encuesta.es_prueba = false`.

n8n accede al schema `maestro` **solo en modo lectura**. El diccionario define preguntas, métricas, versiones y pesos; n8n los consume para normalizar respuestas.

### 2.2 Canales soportados (v8.12.0)

| Canal (Planificador) | Origen (Generador) | Quién normaliza | Identidad cliente |
|---|---|---|---|
| **N8N / BLIP** | WHATSAPP | n8n: SWF-NORMALIZAR | `flow_token` → `wa_flow_token` → `codigo_isi_{empresa} + razon_social` |
| **SURVEY MONKEY** | EMAIL, FÍSICAS, QRS | n8n: SWF-NORMALIZAR | Custom Var `id_mj` |
| **ENRUTA** | REPARTOS | Manual / Diccionario | `codigo_isi` |
| FINESSE / BACK OLE / QUICK | TELÉFONO / APP / AD360 | Pendiente IT | — |

### 2.3 Diagrama de flujo (canal WhatsApp)

```
[MAILJET]
│  Cron 3:00 AM  →  WF-SYNC-CONTACTOS v6
▼
[public.contactos]  ◄── FUENTE DE VERDAD (~22.500 contactos, PK id_mailjet)
                         Campos clave WA: telefono_wa, activo, listas_mailjet,
                         razon_social, distribuidor_*, codigo_isi_*

[MONDAY.COM — Board "Comunicaciones WA"]
│  Webhook → status_wa cambia a ENVIAR_WA (condición: checkbox_lock = false)
▼
[WF-01-OUTBOUND-WA]
│  Valida id_encuesta_maestro en maestro.encuestas_maestro (solo ENCUESTA)
│  Obtiene version_num activa de maestro.encuestas_versiones (solo ENCUESTA)
│  Crea/reutiliza encuestas.ejecuciones_encuesta (id_externo_collector UNIQUE)
│  Obtiene contactos según Modo de Envío
│  Sube imagen → cachea wa_media_id en ejecuciones + monday
│  Envía template WA en lotes de 50 con flow_token = id_envio::text
▼
[WhatsApp Cloud API]
│
├── Callbacks (sent / delivered / read / failed)
│   └── [WF-03-STATUS-TRACKER] → UPDATE public.encuestas_envios (estado_entrega + timestamps)
│
└── Usuario responde (nfm_reply — WA Flow nativo)
    └── [WF-02-INBOUND-RESPUESTA]
        │  Valida firma X-Hub-Signature-256
        │  Lookup: encuestas.encuestas_envios WHERE id_envio = flow_token::uuid
        │  [SWF-NORMALIZAR-RESPUESTAS]
        │    Consulta maestro por version_num guardado en ejecucion
        │    INSERT encuestas.respuestas (1 fila por pregunta)
        └── UPDATE contadores monday + estado_entrega = 'respondido'
```

---

## 3. Base de datos — Schema v8.12.0 + extensiones WA

---

### 3.1 Schema maestro — DDL exacto v8.12.0

```sql
CREATE SCHEMA IF NOT EXISTS maestro;

-- Catálogo de métricas y sus rangos
CREATE TABLE maestro.lista_metricas (
  id_metrica    TEXT PRIMARY KEY,     -- 'NPS', 'CSAT', 'CES', 'COMENTARIO'
  valores_escala TEXT                  -- '[1;10]', '[1;5]', 'TEXTO'
);

-- Cabecera funcional de encuesta (agnóstica al canal)
CREATE TABLE maestro.encuestas_maestro (
  id_encuesta         TEXT PRIMARY KEY,
  fase_experiencia    TEXT NOT NULL,   -- DESCUBRIMIENTO / COMPRA / POSTVENTA / EVENTOS
  tipo_interaccion    TEXT NOT NULL,   -- APERTURA_CLIENTE, CN_CLUB, MOVISTAR_ARENA...
  interaccion_activa  BOOLEAN DEFAULT true,
  id_externo_encuesta JSONB,           -- {"wa_flow_id": "xxx", "smk_survey_id": "yyy"}
  fecha_creacion      TIMESTAMPTZ DEFAULT NOW(),
  fecha_actualizacion TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_maestro_enc_tipo_interaccion
  ON maestro.encuestas_maestro(tipo_interaccion);

-- Versiones congeladas por encuesta
CREATE TABLE maestro.encuestas_versiones (
  id_encuesta     TEXT NOT NULL
    CONSTRAINT fk_versiones_encuesta
    REFERENCES maestro.encuestas_maestro(id_encuesta) ON DELETE RESTRICT,
  version_num     INT  NOT NULL,
  version_encuesta VARCHAR(10) NOT NULL,  -- 'v1.0', 'v2.0'
  version_activa  BOOLEAN DEFAULT false,
  fecha_creacion  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (id_encuesta, version_num),
  CONSTRAINT uq_encuesta_version_txt UNIQUE (id_encuesta, version_encuesta)
);

-- Pesos globales de Marketing por encuesta y métrica
CREATE TABLE maestro.encuestas_metricas_config (
  id_encuesta           TEXT NOT NULL,
  id_metrica            TEXT NOT NULL,
  peso_global_marketing NUMERIC(6,4) NOT NULL,
  PRIMARY KEY (id_encuesta, id_metrica),
  CONSTRAINT fk_emc_encuesta FOREIGN KEY (id_encuesta)
    REFERENCES maestro.encuestas_maestro(id_encuesta) ON DELETE RESTRICT,
  CONSTRAINT fk_emc_metrica FOREIGN KEY (id_metrica)
    REFERENCES maestro.lista_metricas(id_metrica) ON DELETE RESTRICT,
  CONSTRAINT chk_emc_peso_global CHECK (peso_global_marketing >= 0 AND peso_global_marketing <= 1)
);

-- Preguntas del diccionario (baja lógica — no se borran, se desactivan)
CREATE TABLE maestro.preguntas_maestro (
  id_pregunta         TEXT PRIMARY KEY,
  id_encuesta         TEXT NOT NULL,
  id_metrica          TEXT NOT NULL,
  orden               INT  NOT NULL,
  texto_pregunta      TEXT NOT NULL,
  pregunta_activa     BOOLEAN NOT NULL DEFAULT true,
  id_externo_pregunta TEXT NOT NULL,  -- component_id WA Flow / question_id SurveyMonkey
  fecha_creacion      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fecha_actualizacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_pregunta_metrica_config
    FOREIGN KEY (id_encuesta, id_metrica)
    REFERENCES maestro.encuestas_metricas_config(id_encuesta, id_metrica) ON DELETE RESTRICT,
  CONSTRAINT uq_pregunta_encuesta_orden UNIQUE (id_encuesta, orden)
);
CREATE INDEX IF NOT EXISTS idx_maestro_preg_externo
  ON maestro.preguntas_maestro(id_externo_pregunta);

-- Opciones de respuesta (mapeo ID externo → valor numérico analítico)
CREATE TABLE maestro.opciones_maestro (
  id_opcion         TEXT PRIMARY KEY,
  id_pregunta       TEXT NOT NULL
    CONSTRAINT fk_opcion_pregunta
    REFERENCES maestro.preguntas_maestro(id_pregunta) ON DELETE RESTRICT,
  texto_opcion      TEXT NOT NULL,
  valor_numerico    NUMERIC,           -- NULL para COMENTARIO
  id_externo_opcion TEXT NOT NULL,     -- option_id WA / choice_id SurveyMonkey
  CONSTRAINT uq_opcion_pregunta_externa UNIQUE (id_pregunta, id_externo_opcion)
);
CREATE INDEX IF NOT EXISTS idx_maestro_opc_externo
  ON maestro.opciones_maestro(id_externo_opcion);

-- Ponderaciones congeladas por versión y pregunta
-- Generadas por maestro.generar_version_ponderaciones() — nunca manualmente
-- peso_final_calculado = 0 para métricas COMENTARIO (texto libre, no puntúan)
CREATE TABLE maestro.ponderaciones_versiones (
  id_config             SERIAL PRIMARY KEY,
  id_encuesta           TEXT NOT NULL,
  version_num           INT  NOT NULL,
  id_pregunta           TEXT NOT NULL
    CONSTRAINT fk_pond_pregunta
    REFERENCES maestro.preguntas_maestro(id_pregunta) ON DELETE RESTRICT,
  id_metrica            TEXT NOT NULL,
  peso_interno_metrica  NUMERIC(6,4)  NOT NULL,
  peso_global_marketing NUMERIC(6,4)  NOT NULL,
  peso_final_calculado  NUMERIC(10,6) NOT NULL,  -- peso_interno × peso_global
  fecha_creacion        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_pond_version_maestra
    FOREIGN KEY (id_encuesta, version_num)
    REFERENCES maestro.encuestas_versiones(id_encuesta, version_num) ON DELETE RESTRICT,
  CONSTRAINT uq_pond_version_pregunta UNIQUE (id_encuesta, version_num, id_pregunta),
  CONSTRAINT chk_pond_peso_interno  CHECK (peso_interno_metrica  >= 0 AND peso_interno_metrica  <= 1),
  CONSTRAINT chk_pond_peso_global   CHECK (peso_global_marketing >= 0 AND peso_global_marketing <= 1),
  CONSTRAINT chk_pond_peso_final    CHECK (peso_final_calculado  >= 0 AND peso_final_calculado  <= 1)
);

-- Trigger de auditoría de fechas
CREATE OR REPLACE FUNCTION maestro.fn_set_fecha_actualizacion()
RETURNS TRIGGER AS $$
BEGIN
  NEW.fecha_actualizacion := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_encuestas_maestro_fecha ON maestro.encuestas_maestro;
CREATE TRIGGER trg_encuestas_maestro_fecha
  BEFORE UPDATE ON maestro.encuestas_maestro
  FOR EACH ROW EXECUTE FUNCTION maestro.fn_set_fecha_actualizacion();

DROP TRIGGER IF EXISTS trg_preguntas_maestro_fecha ON maestro.preguntas_maestro;
CREATE TRIGGER trg_preguntas_maestro_fecha
  BEFORE UPDATE ON maestro.preguntas_maestro
  FOR EACH ROW EXECUTE FUNCTION maestro.fn_set_fecha_actualizacion();
```

---

### 3.2 encuestas.empresas

Empresa del grupo para la que se crea la campaña. Incluye `phone_number_id` — es el ID público del número WA en Meta, no un secreto (no otorga acceso por sí solo). El access token de Meta sí va en Credentials de n8n.

```sql
CREATE TABLE IF NOT EXISTS encuestas.empresas (
  id              SERIAL  PRIMARY KEY,
  nombre          TEXT    UNIQUE NOT NULL,   -- 'VEMARE', 'TRANSCOSE', 'DIESELIBERIA', 'PAHER'
  phone_number_id TEXT,                      -- ID del número en Meta Business Manager
  activo          BOOLEAN DEFAULT true
);

-- Rellenar phone_number_id con los valores reales de Meta antes de ejecutar
INSERT INTO encuestas.empresas (nombre, phone_number_id) VALUES
  ('VEMARE',       '<PHONE_NUMBER_ID_VEMARE>'),
  ('TRANSCOSE',    '<PHONE_NUMBER_ID_TRANSCOSE>'),
  ('DIESELIBERIA', '<PHONE_NUMBER_ID_DIESELIBERIA>'),
  ('PAHER',        '<PHONE_NUMBER_ID_PAHER>')
ON CONFLICT (nombre) DO NOTHING;
```

En WF-01, la query de empresa devuelve `phone_number_id` directamente:
```sql
SELECT id, phone_number_id FROM encuestas.empresas WHERE nombre = $1 AND activo = true
```
El `phone_number_id` resultante se usa en la URL de Meta: `POST /v20.0/{phone_number_id}/messages`.

---

### 3.3–3.6 Tablas WA — ver `encuestas-wa-schema.sql`

El DDL completo de las tablas WA está en **`encuestas-wa-schema.sql`**. Resumen de tablas:

| Tabla | Rol |
|---|---|
| `encuestas.empresas_wa` | Config WA por empresa: `codigo_empresa` + `phone_number_id` |
| `encuestas.campanas_wa` | Una fila por ítem monday disparado como encuesta WA |
| `encuestas.envios_wa` | Una fila por contacto: tracking delivery + `wa_flow_token UUID` |
| `encuestas.respuestas_wa` | Una fila por pregunta respondida, con valores analíticos |

Referencias clave del schema WA con `public.contactos`:

| Campo en `envios_wa` | Origen en `public.contactos` | Mapeo por empresa |
|---|---|---|
| `codigo_isi` | `codigo_isi_{empresa}` | VEMARE→`_vemare`, TRANSCOSE→`_transcose`, EDI→`_dieseliberia`, PAHER→`_paher` |
| `razon_social` | `razon_social` | Igual en todas las empresas |
| `telefono_wa` | `telefono_wa` | Igual |

> El campo `nombre_empresa` **no existe** en `public.contactos`. Usar `razon_social` en todos los nodos n8n y en las tablas WA.

---

### 3.7-OLD (eliminado) — Tablas antiguas

Las tablas `encuestas.ejecuciones_encuesta`, `encuestas.encuestas_envios`, `encuestas.respuestas` del plan anterior han sido reemplazadas por las tablas WA del `encuestas-wa-schema.sql`. No ejecutar el antiguo `encuestas-schema.sql`.

---

### 3.3–3.6 (continuación) — solo para referencia histórica

> **⚠️ OBSOLETO** — Las secciones DDL antiguas (§3.3 ejecuciones_encuesta, §3.4 encuestas_envios, §3.5 respuestas) ya no aplican. El schema WA actual está en `encuestas-wa-schema.sql`.

---

### 3.7 Política de retención RGPD

```sql
-- Ejecutar el primer día de cada mes (cron n8n, 2:00 AM)
-- Orden obligatorio: respuestas primero (FK ON DELETE RESTRICT)
DELETE FROM encuestas.respuestas_wa  WHERE fecha_respuesta < NOW() - INTERVAL '12 months';
DELETE FROM encuestas.envios_wa
  WHERE created_at < NOW() - INTERVAL '12 months'
    AND id NOT IN (SELECT DISTINCT id_envio FROM encuestas.respuestas_wa WHERE id_envio IS NOT NULL);
```

---

### 3.8 ELIMINADO — (antigua §3.3)

**Las campañas NOTIFICACION no insertan en esta tabla ni en `encuestas.encuestas_envios`.** El schema `encuestas` es exclusivamente para encuestas con captura analítica de respuestas. Las notificaciones se gestionan íntegramente desde n8n y monday sin persistencia en BD (ver §6.2).

- `id_encuesta_maestro TEXT NOT NULL` — siempre requerido; solo llegan aquí campañas tipo encuesta.
- `id_externo_collector UNIQUE` — permite `ON CONFLICT` limpio sin índice parcial.
- `empresa_id` referencia `encuestas.empresas`.

```sql
CREATE TABLE IF NOT EXISTS encuestas.ejecuciones_encuesta (
  id_ejecucion          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  id_encuesta_maestro   TEXT        NOT NULL,           -- Siempre requerido (solo ENCUESTA usa esta tabla)
  canal                 TEXT        NOT NULL,           -- 'N8N', 'SURVEYMONKEY', 'ENRUTA'
  origen                TEXT,                           -- 'WHATSAPP', 'EMAIL', 'QR'
  id_externo_collector  TEXT        UNIQUE,             -- WA: monday_item_id / SMK: collector_id
  titulo_ejecucion      TEXT        NOT NULL,
  es_prueba             BOOLEAN     NOT NULL DEFAULT false,
  fecha_creacion        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fecha_inicio_envio    TIMESTAMPTZ,
  -- Extensiones WA
  empresa_id            INTEGER     REFERENCES encuestas.empresas(id),
  modo_envio            TEXT,       -- 'EQUIPO' / 'REAL_LISTA' / 'REAL_MANUAL'
  segmento_filtro       TEXT,
  wa_media_id           TEXT,       -- Media ID cacheado en Meta
  template_name         TEXT,
  flow_id               TEXT,       -- ID del WA Flow en Meta
  version_num           INT,        -- version_num activo al lanzar
  estado                TEXT,
  CONSTRAINT fk_ejecucion_encuesta_maestro
    FOREIGN KEY (id_encuesta_maestro)
    REFERENCES maestro.encuestas_maestro(id_encuesta) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_ejecuciones_prueba   ON encuestas.ejecuciones_encuesta(es_prueba);
CREATE INDEX IF NOT EXISTS idx_ejecuciones_maestro  ON encuestas.ejecuciones_encuesta(id_encuesta_maestro);
CREATE INDEX IF NOT EXISTS idx_ejecuciones_estado   ON encuestas.ejecuciones_encuesta(estado);
```

---

### 3.4–3.5 — DDL en `encuestas-wa-schema.sql`

> Las tablas `encuestas.envios_wa` y `encuestas.respuestas_wa` están definidas en **`encuestas-wa-schema.sql`**. No duplicar DDL aquí.
> Campos clave: `razon_social` (no `nombre_empresa`), `wa_flow_token UUID`, `codigo_isi` por empresa.

---

### 3.6 Función maestro.generar_version_ponderaciones()

Llamar **una vez** al terminar de configurar preguntas y pesos de una encuesta, y **cada vez** que se modifique su estructura. Congela los pesos matemáticamente.

```sql
SELECT maestro.generar_version_ponderaciones('ID_DE_TU_ENCUESTA');
-- Devuelve: 'v1.0' (o la versión generada)
-- Efecto:   INSERT en encuestas_versiones (version_activa = true)
--           UPDATE versiones previas → version_activa = false
--           INSERT en ponderaciones_versiones (1 fila por pregunta activa)
```

La función calcula:
- `peso_interno_metrica` = 1 / nº de preguntas activas de esa métrica
- `peso_final_calculado` = `peso_interno_metrica` × `peso_global_marketing` de `encuestas_metricas_config`
- Para preguntas tipo COMENTARIO: `peso_final_calculado = 0` (texto libre, no puntúa)

---

### 3.7 Política de retención RGPD

```sql
-- Ejecutar el primer día de cada mes (cron en n8n, 2:00 AM)
-- Orden obligatorio: respuestas primero, luego envíos (FK ON DELETE RESTRICT)
-- Los envíos solo se purgan si ya no tienen respuestas asociadas.

DELETE FROM encuestas.respuestas
  WHERE fecha_respuesta < NOW() - INTERVAL '12 months';

DELETE FROM encuestas.encuestas_envios
  WHERE fecha_intento < NOW() - INTERVAL '12 months'
    AND id_envio NOT IN (
      SELECT DISTINCT id_envio FROM encuestas.respuestas WHERE id_envio IS NOT NULL
    );
```

---

## 4. Consulta base de normalización (n8n — solo lectura)

SWF-NORMALIZAR ejecuta esta query al procesar cada `nfm_reply`. **Usa el `version_num` almacenado en `encuestas.ejecuciones_encuesta` al momento del envío**, no la versión actualmente activa — así los pesos son siempre los correctos aunque se publique una nueva versión entre el envío y la respuesta.

```sql
SELECT
  p.id_pregunta,
  p.orden,
  p.id_metrica,
  p.id_externo_pregunta,
  pv.version_num,
  pv.peso_final_calculado
FROM maestro.preguntas_maestro p
JOIN maestro.ponderaciones_versiones pv
  ON pv.id_encuesta = p.id_encuesta
  AND pv.version_num = $2          -- version_num de encuestas.ejecuciones_encuesta
  AND pv.id_pregunta = p.id_pregunta
WHERE p.id_encuesta = $1           -- id_encuesta_maestro de ejecuciones_encuesta
  AND p.pregunta_activa = true
ORDER BY p.orden;
-- $1 = id_encuesta_maestro, $2 = version_num (ambos de encuestas.ejecuciones_encuesta)
```

Para resolver opciones (`id_externo_opcion` → `valor_numerico`):

```sql
SELECT o.id_externo_opcion, o.valor_numerico, o.id_opcion
FROM maestro.opciones_maestro o
JOIN maestro.preguntas_maestro p ON p.id_pregunta = o.id_pregunta
WHERE p.id_encuesta = $1
  AND p.pregunta_activa = true;
-- $1 = id_encuesta_maestro
```

---

## 5. Board monday.com — Comunicaciones WA

Un único board con **dos vistas** que ocultan columnas no aplicables (monday soporta column hiding por vista).

- **Vista ENCUESTA:** oculta URL destino, CSV manual.
- **Vista NOTIFICACION:** oculta Flow ID, id encuesta maestro.

### 5.1 Columnas del board

| Columna | ID sugerido | Tipo | Rellena | Descripción |
|---|---|---|---|---|
| Nombre campaña | `name` | text | Usuario | Título de la ejecución |
| Tipo | `tipo_comunicacion` | status | Usuario | ENCUESTA / NOTIFICACION |
| Modo de Envío | `modo_envio` | status | Usuario | EQUIPO · REAL Lista · REAL Manual |
| Status | `status_wa` | status | Usuario/n8n | Ver §5.2 |
| Empresa WA | `text_empresa` | text | Usuario | TRANSCOSE / VEMARE |
| Segmento filtro | `text_segmento` | text | Usuario | Modo REAL Lista — valor ILIKE sobre `listas_mailjet` |
| CSV manual | `file_csv` | file | Usuario | Modo REAL Manual — cols mínimas: `telefono_wa` |
| id encuesta maestro | `text_encuesta_id` | text | Usuario | ID en `maestro.encuestas_maestro` (solo ENCUESTA) |
| Flow ID | `text_flow_id` | text | Usuario | ID del WA Flow publicado en Meta (solo ENCUESTA) |
| Template WA | `text_template` | text | Usuario | Nombre exacto del template aprobado |
| Texto cuerpo | `long_text_cuerpo` | long text | Usuario | Body del template. Variables: `{{1}}` nombre, `{{2}}` texto |
| URL destino | `text_url` | text | Usuario | Solo NOTIFICACION con botón URL |
| Imagen | `file_imagen` | file | Usuario | Header image — n8n sube a Meta y cachea media_id |
| Caché Media ID | `text_media_id` | text | n8n | `wa_media_id` cacheado (auto, no editar) |
| Total enviados | `num_enviados` | number | n8n | Actualizado por WF-01 |
| Total entregados | `num_delivered` | number | n8n | Actualizado por WF-03 |
| Total respondidos | `num_respondidos` | number | n8n | Solo ENCUESTA — actualizado por WF-02 |
| % Respuesta | `formula_respuesta` | formula | — | `{Total respondidos} / {Total enviados} * 100` |
| Fecha envío | `date_envio` | date | n8n | Timestamp de disparo WF-01 |
| Dispatch lock | `checkbox_lock` | checkbox | n8n | Anti-loop monday↔n8n |
| Es prueba | `checkbox_prueba` | checkbox | n8n | true si Modo EQUIPO; controla `es_prueba` en PG |

### 5.2 Estados del board

| Status | Color | Significado |
|---|---|---|
| BORRADOR | Gris | En preparación |
| ENVIAR_WA | Amarillo | Trigger de WF-01 |
| ENVIANDO | Azul | WF-01 procesando |
| ENVIADA | Verde claro | Todos los mensajes lanzados a Meta |
| COMPLETADA | Verde | Ventana cerrada o respondido al 100% |
| ERROR | Rojo | Fallo — ver update del ítem |

### 5.3 Anti-loop monday ↔ n8n

1. Webhook dispara cuando `status_wa` cambia a `ENVIAR_WA`.
2. WF-01 activa `checkbox_lock = true` como primera acción.
3. Condición en webhook: `IF checkbox_lock = false → procesar`.
4. Al terminar, WF-01 cambia a `ENVIANDO` y desactiva `checkbox_lock`.

---

## 6. WF-01-OUTBOUND-WA: Envío masivo

### 6.1 Modos de envío

| Modo | Fuente | es_prueba | Filtro opt-in |
|---|---|---|---|
| EQUIPO (Prueba) | Array hardcodeado de teléfonos del equipo | `true` | No aplica |
| REAL (Lista) | `public.contactos` filtrada por segmento | `false` | `activo = '1' AND telefono_wa IS NOT NULL` |
| REAL (Manual) | CSV subido en `file_csv` de monday | `false` | Solo filas presentes en `public.contactos` por `telefono_wa`; el resto se omite y se loguea |

**Procesamiento CSV (Modo REAL Manual):**
1. n8n descarga el archivo via API Assets de monday (`GET /api/v2/assets/{asset_id}/files`).
2. Parsea CSV. Columna mínima requerida: `telefono_wa`. Opcionales: `nombre`, `codigo_isi`.
3. Por cada fila: cruzar con `public.contactos WHERE telefono_wa = $1` para obtener `codigo_isi_{empresa}` y `razon_social`. Si no existe → omitir fila, registrar en log.
4. Deduplicación por `UNIQUE(id_campana, telefono_wa)` en `encuestas.envios_wa`.

### 6.2 Pseudoflujo completo

Las dos ramas del Switch son **completamente independientes** — no hay nodo Merge. La rama ENCUESTA usa el schema `encuestas.*` para persistencia analítica. La rama NOTIFICACION opera íntegramente desde n8n y monday sin insertar en BD.

```
[Webhook monday: status_wa → ENVIAR_WA (checkbox_lock = false)]
│
[HTTP: monday SET checkbox_lock = true]
│
[HTTP: monday GraphQL GetComunicacion]
  Extrae: tipo, modo_envio, text_empresa, text_segmento, text_encuesta_id,
          text_flow_id, text_template, long_text_cuerpo, text_url,
          text_media_id, assets[].public_url
│
[Edit Fields: Normalizar campos del board]
│
[Switch: tipo]
│
├── 'encuesta' ──────────────────────────────────────────────────────────────►
│   │  ← Única rama que accede a maestro y al schema encuestas.*
│   │
│   [PG: Validar id_encuesta_maestro]
│   SELECT 1 FROM maestro.encuestas_maestro
│   WHERE id_encuesta = $1 AND interaccion_activa = true
│   │
│   [IF: ¿Devuelve fila?]
│   ├── NO → Mutation monday: status=ERROR + update detalle → ABORT
│   └── SÍ →
│   │
│   [PG: Versión activa]
│   SELECT version_num FROM maestro.encuestas_versiones
│   WHERE id_encuesta = $1 AND version_activa = true
│   │
│   [PG: Empresa → empresa_id + phone_number_id]
│   SELECT id, phone_number_id FROM encuestas.empresas
│   WHERE nombre = $1 AND activo = true
│   │
│   [IF: wa_media_id vacío en monday?]
│   ├── NO → usar campo text_media_id de monday
│   └── SÍ → POST /media a Meta → PG UPDATE wa_media_id en ejecucion
│              Mutation monday: text_media_id = :media_id
│   │
│   [PG: UPSERT encuestas.campanas_wa]
│   INSERT INTO encuestas.campanas_wa
│     (codigo_encuesta, version_num, codigo_empresa,
│      id_externo_collector, titulo_campana,
│      es_prueba, modo_envio, segmento_filtro,
│      wa_media_id, template_name, flow_id, estado)
│   VALUES (...)
│   ON CONFLICT (id_externo_collector) DO UPDATE
│     SET estado = 'ENVIANDO', wa_media_id = EXCLUDED.wa_media_id
│   RETURNING id   ← id_campana (INTEGER)
│   │
│   [Mutation monday: status=ENVIANDO, date_envio=NOW()]
│   │
│   [Switch: codigo_empresa → query de contactos REAL Lista]
│   -- Cada rama usa la columna distribuidor_* y codigo_isi_* correcta
│   -- Se conecta al mismo nodo de procesamiento posterior (Merge Append, wait=OFF)
│   │
│   EQUIPO      → Array teléfonos internos fijos
│   │
│   REAL Lista VEMARE →
│     SELECT codigo_isi_vemare AS codigo_isi, razon_social, telefono_wa, nombre
│     FROM public.contactos
│     WHERE activo = '1' AND telefono_wa IS NOT NULL AND telefono_wa <> ''
│       AND distribuidor_vemare IS NOT NULL AND distribuidor_vemare <> ''
│       AND ($1 = '' OR listas_mailjet ILIKE '%' || $1 || '%')
│   │
│   REAL Lista TRANSCOSE →
│     SELECT codigo_isi_transcose AS codigo_isi, razon_social, telefono_wa, nombre
│     FROM public.contactos
│     WHERE activo = '1' AND telefono_wa IS NOT NULL AND telefono_wa <> ''
│       AND distribuidor_transcose IS NOT NULL AND distribuidor_transcose <> ''
│       AND ($1 = '' OR listas_mailjet ILIKE '%' || $1 || '%')
│   │
│   REAL Lista EDI →
│     SELECT codigo_isi_dieseliberia AS codigo_isi, razon_social, telefono_wa, nombre
│     FROM public.contactos          -- columna es _dieseliberia aunque empresa sea EDI
│     WHERE activo = '1' AND telefono_wa IS NOT NULL AND telefono_wa <> ''
│       AND distribuidor_dieseliberia IS NOT NULL AND distribuidor_dieseliberia <> ''
│       AND ($1 = '' OR listas_mailjet ILIKE '%' || $1 || '%')
│   │
│   REAL Lista PAHER →
│     SELECT codigo_isi_paher AS codigo_isi, razon_social, telefono_wa, nombre
│     FROM public.contactos
│     WHERE activo = '1' AND telefono_wa IS NOT NULL AND telefono_wa <> ''
│       AND distribuidor_paher IS NOT NULL AND distribuidor_paher <> ''
│       AND ($1 = '' OR listas_mailjet ILIKE '%' || $1 || '%')
│   │
│   REAL Manual → Descargar CSV → parsear → cruzar por telefono_wa con query de empresa
│   │
│   [Loop Over Items: lotes de 50]
│   │
│     [PG: Check idempotencia]
│     SELECT id, estado_envio FROM encuestas.envios_wa
│     WHERE id_campana = $1 AND telefono_wa = $2
│     │
│     [Filter: Si estado_envio = 'ENVIADO' → descartar]
│     │
│     [PG: UPSERT encuestas.envios_wa]
│     INSERT INTO encuestas.envios_wa
│       (id_campana, codigo_isi, razon_social, telefono_wa, email, estado_envio)
│     VALUES ($1, $2, $3, $4, $5, 'PROCESANDO')
│     ON CONFLICT (id_campana, telefono_wa)
│     DO UPDATE SET estado_envio = 'PROCESANDO'
│     RETURNING id, wa_flow_token   ← wa_flow_token UUID es el flow_token para Meta
│     │
│     [HTTP: POST /messages — payload §6.3 con flow_token = wa_flow_token]
│     │
│     [IF: HTTP 200?]
│     ├── OK  → PG UPDATE encuestas.envios_wa:
│     │           estado_envio='ENVIADO', wa_message_id=:wamid, ts_envio=NOW()
│     └── ERR → IF intentos < 3 → Wait 30s → retry
│                ELSE → UPDATE ERROR_DEFINITIVO + Mutation monday error
│   │
│   [Fin lote: Mutation monday num_enviados += N]
│   │
│   [Fin loop]
│   [PG UPDATE encuestas.campanas_wa SET estado='ENVIADA', fecha_inicio_envio=NOW()]
│   [Mutation monday: status=ENVIADA, checkbox_lock=false]
│
└── 'notificacion' ──────────────────────────────────────────────────────────►
    │  ← No accede a maestro. No inserta en encuestas.*. Solo n8n + monday.
    │
    [PG: Empresa → phone_number_id]
    SELECT phone_number_id FROM encuestas.empresas
    WHERE nombre = $1 AND activo = true
    (sin empresa_id — NOTIFICACION no inserta en ejecuciones_encuesta)
    │
    [IF: wa_media_id vacío en monday?]
    ├── NO → usar campo text_media_id de monday
    └── SÍ → POST /media a Meta → Mutation monday: text_media_id = :media_id
               (sin UPDATE en BD — NOTIFICACION no tiene fila en ejecuciones_encuesta)
    │
    [Mutation monday: status=ENVIANDO, date_envio=NOW()]
    │
    [PG/Array: Obtener contactos según modo_envio]
    (mismo que rama ENCUESTA)
    │
    [Loop Over Items: lotes de 50]
    │
      [IF: url_destino tiene valor?]
      ├── SÍ → payload notificacion_con_url (§6.4)
      └── NO → payload notificacion_sin_url (§6.5)
      │
      [HTTP: POST /messages a Meta]
      │
      [IF: HTTP 200?]
      ├── OK  → continuar (sin INSERT en BD)
      └── ERR → IF intentos < 3 → Wait 30s → retry
                 ELSE → Mutation monday update con detalle del fallo
    │
    [Fin lote: Mutation monday num_enviados += N]
    │
    [Fin loop]
    [Mutation monday: status=ENVIADA, checkbox_lock=false]
```

**Resumen de la separación por tipo:**

| | ENCUESTA | NOTIFICACION |
|---|---|---|
| Valida maestro | ✅ Aborta si no existe | ❌ No toca maestro |
| Inserta en `encuestas.*` | ✅ ejecuciones + envios + respuestas | ❌ Ninguna tabla de BD |
| wa_media_id cacheado en | BD + campo monday | Solo campo monday |
| Payload Meta | Template con botón WA Flow | Template simple (con o sin URL) |
| flow_token | ✅ = id_envio (para WF-02) | ❌ No existe |
| WF-02 procesa respuesta | ✅ Captura nfm_reply | ❌ No aplica |
| WF-03 tracking delivery | ✅ UPDATE por wamid en BD | ❌ No hay fila (0 rows updated, silencioso) |
| Tracking individual por contacto | ✅ encuestas_envios | ❌ Solo contador total en monday |

### 6.3 Payload — Encuesta (WA Flow)

```json
{
  "messaging_product": "whatsapp",
  "recipient_type": "individual",
  "to": "{{telefono_wa}}",
  "type": "template",
  "template": {
    "name": "{{template_name}}",
    "language": { "code": "es" },
    "components": [
      {
        "type": "header",
        "parameters": [{ "type": "image", "image": { "id": "{{wa_media_id}}" } }]
      },
      {
        "type": "body",
        "parameters": [
          { "type": "text", "text": "{{nombre}}" },
          { "type": "text", "text": "{{titulo_ejecucion}}" }
        ]
      },
      {
        "type": "button",
        "sub_type": "flow",
        "index": "0",
        "parameters": [{
          "type": "action",
          "action": {
            "flow_token": "{{id_envio}}",
            "flow_action_data": {
              "id_ejecucion": "{{id_ejecucion}}",
              "id_encuesta_maestro": "{{id_encuesta_maestro}}"
            }
          }
        }]
      }
    ]
  }
}
```

> `flow_token = id_envio` (UUID en texto). Al recibir el `nfm_reply` en WF-02, n8n busca `WHERE id_envio = flow_token::uuid` para reconstruir la identidad del respondente y el contexto de la encuesta. Este mecanismo **solo existe en campañas ENCUESTA**; las campañas NOTIFICACION no incluyen botón de Flow y WF-02 no tiene nada que procesar de ellas.

### 6.4 Payload — Notificación CON URL

```json
{
  "messaging_product": "whatsapp",
  "to": "{{telefono_wa}}",
  "type": "template",
  "template": {
    "name": "notificacion_con_url",
    "language": { "code": "es" },
    "components": [
      { "type": "header", "parameters": [{ "type": "image", "image": { "id": "{{wa_media_id}}" } }] },
      { "type": "body",   "parameters": [
          { "type": "text", "text": "{{nombre}}" },
          { "type": "text", "text": "{{texto_cuerpo}}" }
      ]},
      { "type": "button", "sub_type": "url", "index": "0",
        "parameters": [{ "type": "text", "text": "{{url_destino}}" }] }
    ]
  }
}
```

### 6.5 Payload — Notificación SIN URL

```json
{
  "messaging_product": "whatsapp",
  "to": "{{telefono_wa}}",
  "type": "template",
  "template": {
    "name": "notificacion_sin_url",
    "language": { "code": "es" },
    "components": [
      { "type": "header", "parameters": [{ "type": "image", "image": { "id": "{{wa_media_id}}" } }] },
      { "type": "body",   "parameters": [
          { "type": "text", "text": "{{nombre}}" },
          { "type": "text", "text": "{{texto_cuerpo}}" }
      ]}
    ]
  }
}
```

---

## 7. WF-02-INBOUND-RESPUESTA + SWF-NORMALIZAR

### 7.1 Integración con flujo inbound existente (sin cambios al chatbot)

```
[WhatsApp Trigger] (nodo existente)
│
[IF: ¿Es mensaje nuevo?] (nodo existente)
│
[Validar X-Hub-Signature-256]  ← NUEVO
│
[Normalizar datos] (nodo existente + detección nfm_reply añadida)
│
[IF: is_flow_response = true]
├── SÍ ──► [SWF-NORMALIZAR-RESPUESTAS]
│            Procesa respuestas. No toca sesiones conversacionales.
└── NO ──► [Lógica inbound existente — SIN MODIFICACIONES]
```

### 7.2 Código de normalización (añadir al nodo existente)

```javascript
const msg = $json.messages?.[0];
const tipo = msg?.type;
let text_content = '', flow_response = null, flow_token = '', is_flow_response = false;

if (tipo === 'interactive') {
  const ia = msg.interactive;
  if (ia.type === 'button_reply') {
    text_content = ia.button_reply.id;
  } else if (ia.type === 'nfm_reply') {
    flow_response  = JSON.parse(ia.nfm_reply.response_json);
    flow_token     = flow_response.flow_token ?? '';
    text_content   = 'nfm_reply';
    is_flow_response = true;
  }
} else if (tipo === 'text') {
  text_content = msg.text.body.toLowerCase().trim();
}

return { json: { waid: msg?.from, db_phone: msg?.from, text_content,
                 flow_response, flow_token, is_flow_response } };
```

### 7.3 SWF-NORMALIZAR-RESPUESTAS

```
INPUT: { db_phone, flow_response, flow_token }

│
[PG: Lookup por wa_flow_token — trae todo el contexto necesario]
  SELECT ew.id, ew.id_campana, ew.codigo_isi, ew.razon_social, ew.telefono_wa,
         cw.codigo_encuesta, cw.version_num, cw.codigo_empresa
  FROM encuestas.envios_wa ew
  JOIN encuestas.campanas_wa cw ON cw.id = ew.id_campana
  WHERE ew.wa_flow_token = $1::uuid
  -- $1 = flow_token recibido en el nfm_reply
│
[IF: no encontrado]
└── Log error n8n: "flow_token no encontrado en encuestas_envios"
    RETURN { json: { status: 'error', reason: 'flow_token_not_found' } }
    ABORT
│
[PG: Mapa preguntas + pesos — versión congelada al envío (§4)]
  -- Usa codigo_encuesta (TEXT) para el JOIN con maestro IT (BIGINT PK resuelto internamente)
  SELECT p.codigo_pregunta, p.id_pregunta, p.orden, p.id_metrica, p.id_externo_pregunta,
         pv.version_num, pv.peso_final_calculado
  FROM maestro.encuestas_maestro em
  JOIN maestro.preguntas_maestro p  ON p.id_encuesta = em.id_encuesta AND p.pregunta_activa = TRUE
  JOIN maestro.ponderaciones_versiones pv
    ON pv.id_encuesta = p.id_encuesta
   AND pv.version_num = $2           -- version_num de campanas_wa
   AND pv.id_pregunta = p.id_pregunta
  WHERE em.codigo_encuesta = $1      -- codigo_encuesta de campanas_wa
  ORDER BY p.orden
  -- $1 = codigo_encuesta (TEXT), $2 = version_num (INTEGER)
│
[PG: Mapa opciones]
  SELECT o.id_externo_opcion, o.valor_numerico, o.codigo_opcion, o.id_pregunta
  FROM maestro.encuestas_maestro em
  JOIN maestro.preguntas_maestro p ON p.id_encuesta = em.id_encuesta AND p.pregunta_activa = TRUE
  JOIN maestro.opciones_maestro o  ON o.id_pregunta = p.id_pregunta
  WHERE em.codigo_encuesta = $1
  -- $1 = codigo_encuesta (TEXT)
│
[Code Node: descomponer flow_response]
  Por cada pregunta del mapa:
    valor_raw = flow_response[pregunta.id_externo_pregunta]
    opcion = opcionesMap.get(valor_raw)          // lookup por id_externo_opcion
    valor_numerico = opcion?.valor_numerico ?? null
    valor_calculado = valor_numerico !== null && peso > 0
                      ? parseFloat((valor_numerico * peso).toFixed(6))
                      : null
    respuesta_comentario = id_metrica === 'COMENTARIO' ? valor_raw : null
    → return { json: { id_pregunta_maestro, id_metrica, peso_final_calculado,
                        valor_numerico, valor_calculado, respuesta_comentario,
                        atributos_adicionales: JSON.stringify({component_id, raw_value}) } }
│
[PG: INSERT INTO encuestas.respuestas — un nodo que se ejecuta N veces (1 por pregunta)]
  INSERT INTO encuestas.respuestas (
    id_campana, id_envio, codigo_encuesta, version_num,
    codigo_pregunta, id_grupo_respuesta,
    codigo_isi, razon_social,
    codigo_metrica, peso_final_calculado, valor_numerico, valor_calculado,
    respuesta_comentario, atributos_adicionales
  ) VALUES ($1::uuid, $2::uuid, $3, $4, $5, $6::uuid, $7, $8, $9, $10,
            $11, $12, $13, $14, $15, $16::jsonb)
  ON CONFLICT (id_grupo_respuesta, id_pregunta_maestro) DO NOTHING
  -- Meta puede reenviar el mismo nfm_reply; el UNIQUE bloquea duplicados
  -- id_grupo_respuesta = flow_token::uuid = id_envio (determinista)
│
[PG: UPDATE encuestas.envios_wa]
  SET estado_entrega = 'respondido'
  WHERE wa_flow_token = $1::uuid
│
[Mutation monday: incrementar num_respondidos del ítem]
[Mutation monday: crear update en el ítem con resumen de respuestas]
│
[IF: error en cualquier paso → On Error: Continue (using error output)]
└── PG UPDATE encuestas.envios_wa SET estado_entrega = 'error_normalizacion' WHERE wa_flow_token = :flow_token::uuid
    Mutation monday: update ítem con descripción del error
    RETURN { json: { status: 'error', reason: $json.error.message } }

RETURN { json: { status: 'success', rows_inserted: N, id_grupo_respuesta: flow_token } }
```

---

## 8. WF-03-STATUS-TRACKER: Callbacks de delivery

```
[WhatsApp Trigger — suscrito a message_status]
│
[IF: ¿Es evento statuses?]
├── NO → descartar (Filter o NoOp)
└── SÍ →
│
[Edit Fields: Extraer campos del payload]
  message_id → ={{ $json.body.entry[0].changes[0].value.statuses[0].id }}
  status     → ={{ $json.body.entry[0].changes[0].value.statuses[0].status }}
  ts         → ={{ $json.body.entry[0].changes[0].value.statuses[0].timestamp }}
  error_msg  → ={{ $json.body.entry[0].changes[0].value.statuses[0].errors?.[0]?.title ?? null }}
│
[PG: UPDATE encuestas.encuestas_envios]
  UPDATE encuestas.encuestas_envios
  SET estado_entrega = $1,
      ts_delivered = CASE WHEN $1 = 'delivered' THEN to_timestamp($2::bigint) ELSE ts_delivered END,
      ts_read      = CASE WHEN $1 = 'read'      THEN to_timestamp($2::bigint) ELSE ts_read      END
  WHERE id_externo_envio = $3
  -- $1 = status, $2 = ts, $3 = message_id
│
[IF: status = 'failed']
├── intentos < 3 →
│   PG UPDATE encuestas.encuestas_envios
│     SET estado_envio = 'REINTENTO', intentos = intentos + 1, error_msg = $1
│     WHERE id_externo_envio = $2
└── intentos >= 3 →
    PG UPDATE encuestas.encuestas_envios
      SET estado_envio = 'ERROR_DEFINITIVO', error_msg = $1
      WHERE id_externo_envio = $2
    Mutation monday: update ítem con detalle del fallo
```

---

## 9. WF-04-REPORTE: Actualización diaria de contadores

```
[Schedule Trigger: 8:00 AM]
│
[HTTP: monday GraphQL — items con status ENVIADA o ENVIANDO]
  query { boards(ids: [BOARD_ID]) {
    items_page(limit: 100, query_params: {
      rules: [{ column_id: "status_wa", compare_value: ["ENVIADA","ENVIANDO"] }]
    }) { items { id column_values { id text } } }
  } }
│
[Loop Over Items: lotes de 10 items]
│
  [PG: Obtener id_ejecucion desde monday_item_id]
  SELECT id_ejecucion, tipo, fecha_inicio_envio
  FROM encuestas.ejecuciones_encuesta
  WHERE id_externo_collector = $1
  -- $1 = monday item id (del webhook)
  │
  [PG: Contadores por ejecución]
  SELECT
    COUNT(*) FILTER (WHERE estado_envio   = 'ENVIADO')    AS total_enviados,
    COUNT(*) FILTER (WHERE estado_entrega = 'ENTREGADO')  AS total_delivered,
    COUNT(*) FILTER (WHERE estado_entrega = 'LEIDO')      AS total_read,
    COUNT(*) FILTER (WHERE estado_entrega = 'respondido') AS total_respondidos
  FROM encuestas.encuestas_envios
  WHERE id_ejecucion = $1
  -- $1 = id_ejecucion del nodo anterior
  │
  [HTTP: Mutation monday — actualizar num_enviados, num_delivered, num_respondidos]
  │
  [IF: total_respondidos = total_enviados AND total_enviados > 0]
  └── Mutation monday: status → COMPLETADA
  │
  [IF: tipo = 'notificacion' AND fecha_inicio_envio < NOW() - INTERVAL '48h']
  └── Mutation monday: status → COMPLETADA  (ventana de respuesta cerrada)
```

---

## 10. Sincronización WA Flow ↔ Diccionario maestro

Cada vez que se crea o modifica un WA Flow en Meta Flow Builder:

1. Exportar el JSON del Flow desde Meta Developer Console.
2. Identificar el `component_id` de cada componente de pregunta.
3. Actualizar `maestro.preguntas_maestro.id_externo_pregunta` con ese `component_id`.
4. Si cambian opciones: actualizar `maestro.opciones_maestro.id_externo_opcion` con el `option_id` de Meta.
5. Si la estructura cambia (preguntas añadidas/eliminadas/reordenadas): llamar a `maestro.generar_version_ponderaciones()`. La nueva versión queda activa. La anterior queda congelada — sus respuestas ya registradas no se ven afectadas.

> Regla crítica: nunca modificar `id_externo_pregunta` de una versión que ya tiene respuestas en `public.respuestas`. Siempre crear versión nueva.

---

## 11. Restricciones críticas Meta

| Restricción | Detalle | Mitigación |
|---|---|---|
| Templates aprobados | Envíos fuera de ventana 24h requieren template | Iniciar aprobación en Fase 2 (24-72h revisión Meta). Tener template UTILITY neutro como backup. |
| WA Flow publicado | El Flow debe estar publicado antes de usarlo | Publicar y vincularlo al template en Meta Business Manager antes de Fase 3. |
| Tres templates | `encuesta_wa`, `notificacion_con_url`, `notificacion_sin_url` | Todos aprobados antes del go-live. |
| Imagen por media_id | Subir a `/media` antes del envío masivo. `public_url` de monday es temporal. | WF-01 sube en el primer envío y cachea `wa_media_id` en PG + campo monday. |
| **Tier de envío** | Tier 1: 1.000/día · Tier 2: 10.000/día · Tier 3: 100.000/día | **⚠️ 22.500 contactos requieren Tier 3. Verificar en Meta Business Manager antes de Fase 7.** |
| Opt-in documentado | Solo enviar a usuarios con consentimiento | Filtro `activo = '1'` en Modo REAL Lista. CSV Manual: solo contactos verificados en BD. |

---

## 12. Seguridad y compliance

### Credenciales y secretos

- **Tokens Meta/WA (access token):** en Credentials de n8n (tipo HTTP Header Auth: `Authorization: Bearer TOKEN`). Nunca en campos de datos ni logs.
- **App Secret:** almacenado como Credential adicional en n8n o en variable de entorno del servidor (`N8N_CUSTOM_ENV_WA_APP_SECRET` → acceso via `$env.WA_APP_SECRET`). Usado solo para validar X-Hub-Signature-256 en WF-02.
- **`phone_number_id`:** en `encuestas.empresas.phone_number_id` (PG). No es un secreto — es el ID público del número en Meta. WF-01 lo obtiene con un SELECT. No hardcodear en nodos.
- **API keys Mailjet:** Credencial `Mailjet - Grupo Vemare` (ID: `LTSvuIs0V4F6ScZE`). Sin hardcodear.
- **PostgreSQL:** acceso restringido. Puerto no expuesto públicamente.
- **n8n Community Edition:** sin acceso a Variables (`$vars`). Toda la configuración reutilizable va en PostgreSQL. Los secretos van en Credentials.

### RGPD

- Números de teléfono y `codigo_isi` son datos personales (RGPD Art. 4.1).
- Retención máxima: 12 meses. Cron de purga el día 1 de cada mes a las 2:00 AM (§3.7).
- Desactivar `Save Execution Data` en WF-01 y WF-02 para ejecuciones con > 1.000 contactos.
- Power BI **siempre** filtra `ejecuciones_encuesta.es_prueba = false`.

### Validación firma webhook Meta

```javascript
const crypto = require('crypto');
const payload   = JSON.stringify($json.body);
const signature = $json.headers['x-hub-signature-256'];
const expected  = 'sha256=' + crypto.createHmac('sha256', $env.WA_APP_SECRET)
                                     .update(payload).digest('hex');
if (signature !== expected) {
  throw new Error('X-Hub-Signature-256 inválida — request rechazado');
}
```

---

## 13. Plan de implementación

### Fase 0 — Completada ✅
WF-SYNC-CONTACTOS v6 operativo · ~22.500 contactos en PostgreSQL · Flujo Inbound WA operativo · App Meta verificada · Credenciales en n8n.

### Fase 1 — Preparación de base de datos (Días 1-3)
- 🔲 Confirmar que schema IT (`maestro.*`, `public.ejecuciones_encuesta`, etc.) está ejecutado en el servidor
- 🔲 Confirmar que `public.contactos` tiene los campos `distribuidor_*` y `codigo_isi_*` poblados
- 🔲 Ejecutar `encuestas-wa-schema.sql` (crea schema `encuestas` con tablas WA independientes)
- 🔲 Rellenar `phone_number_id` en `encuestas.empresas_wa` con IDs reales de Meta Business Manager
- 🔲 Verificar que `encuestas.empresas_wa` tiene las 4 empresas con `phone_number_id` correcto
- 🔲 Verificar mapeo EDI → `distribuidor_dieseliberia` / `codigo_isi_dieseliberia` en contactos
- 🔲 Poblar `maestro.lista_metricas` (NPS, CSAT, CES, COMENTARIO)
- 🔲 Crear primera encuesta de prueba en `maestro` (mínimo 2 preguntas)
- 🔲 Llamar `maestro.generar_version_ponderaciones('ID_PRUEBA')` y verificar resultado

### Fase 2 — Meta: Flow, templates y tier (Días 2-4)
- 🔲 **Verificar tier** en Meta Business Manager — confirmar Tier 3 o plan de escalada
- 🔲 Crear WA Flow en Meta Flow Builder con preguntas de encuesta de prueba
- 🔲 Anotar `component_id` de cada pregunta → actualizar `id_externo_pregunta` en maestro
- 🔲 Crear y enviar a revisión: `encuesta_wa`, `notificacion_con_url`, `notificacion_sin_url`
- 🔲 Una vez aprobados: verificar `flow_id` y `template_name` coinciden con el diccionario

### Fase 3 — Board monday.com (Días 3-4)
- 🔲 Crear board con todas las columnas de §5.1
- 🔲 Configurar estados de §5.2
- 🔲 Crear vista "ENCUESTA" y vista "NOTIFICACION"
- 🔲 Configurar webhook de monday apuntando a WF-01 (condición `checkbox_lock = false`)
- 🔲 Crear ítems de test para cada tipo y validar que el webhook llega a n8n

### Fase 4 — WF-01 OUTBOUND (Días 4-7)
- 🔲 Nodo GraphQL monday: GetComunicacion + assets
- 🔲 Validación `id_encuesta_maestro` contra maestro (con aborto visible en monday)
- 🔲 Lookup versión activa de `maestro.encuestas_versiones` (solo rama ENCUESTA)
- 🔲 Query empresa: `SELECT id, phone_number_id FROM encuestas.empresas WHERE nombre = $1`
- 🔲 Lógica `wa_media_id`: subir a Meta si vacío, cachear en PG y monday
- 🔲 UPSERT `ejecuciones_encuesta` con todos los campos WA
- 🔲 Modo EQUIPO: array interno
- 🔲 Modo REAL Lista: filtro contactos por segmento
- 🔲 Modo REAL Manual: descarga CSV → parseo → cruce con contactos por `telefono_wa`
- 🔲 Loop Over Items (50) + check idempotencia por `telefono_wa`
- 🔲 UPSERT encuestas_envios con `DO UPDATE RETURNING id_envio` (no DO NOTHING)
- 🔲 Rama ENCUESTA con `flow_token = id_envio`
- 🔲 Rama NOTIFICACION: IF `text_url` → con URL / ELSE sin URL
- 🔲 Test Modo EQUIPO (5 números internos) → verificar `id_envio` guardado
- 🔲 Test idempotencia: relanzar → 0 duplicados
- 🔲 Test Modo REAL Lista (10 contactos reales)
- 🔲 Test Modo REAL Manual (CSV de 5 filas)

### Fase 5 — WF-03 STATUS-TRACKER (Días 7-8)
- 🔲 Suscribir webhook Meta a `message_status`
- 🔲 UPDATE `encuestas_envios` con `estado_entrega` y timestamps
- 🔲 Lógica REINTENTO / ERROR_DEFINITIVO
- 🔲 Test: enviar a teléfono propio → verificar `delivered` y `read` registrados

### Fase 6 — WF-02 INBOUND RESPUESTA (Días 8-10)
- 🔲 Añadir validación `X-Hub-Signature-256` al flujo inbound existente
- 🔲 Añadir detección `nfm_reply` al nodo Normalizar datos
- 🔲 Insertar rama IF nfm_reply antes del flujo conversacional
- 🔲 Construir SWF-NORMALIZAR-RESPUESTAS (§7.3)
- 🔲 Test completo: enviar encuesta → responder Flow → verificar en `public.respuestas`
- 🔲 Test: mensaje normal → flujo inbound habitual sin cambios
- 🔲 Test: Meta reenvía mismo `nfm_reply` → 0 duplicados en `respuestas` (ON CONFLICT DO NOTHING)

### Fase 7 — WF-04 REPORTE (Días 10-11)
- 🔲 Schedule Trigger 8:00 AM
- 🔲 Queries de conteo en PG por `id_ejecucion`
- 🔲 Mutations GraphQL para actualizar contadores en monday
- 🔲 Lógica de cierre a COMPLETADA

### Fase 8 — Prueba end-to-end (Días 11-12)
- 🔲 Encuesta Modo EQUIPO completa (5 internos) → responder → verificar PG + monday + Power BI
- 🔲 Notificación CON URL Modo EQUIPO
- 🔲 Notificación SIN URL Modo EQUIPO
- 🔲 Verificar `es_prueba = true` → Power BI las filtra
- 🔲 Test idempotencia: relanzar campaña → 0 duplicados
- 🔲 Verificar chatbot existente no interrumpido

### Fase 9 — Hardening y go-live (Día 13)
- 🔲 Confirmar Tier Meta ≥ Tier 2 (Tier 3 para volumen completo)
- 🔲 Configurar `errorWorkflow` en WF-01, WF-02, WF-03
- 🔲 Desactivar `Save Execution Data` en WF-01 y WF-02
- 🔲 Primer envío real Modo REAL Lista (~100 contactos, `es_prueba = false`)
- 🔲 Monitorizar 24h: callbacks delivery, respuestas, contadores monday
- 🔲 Verificar cron de retención activo
- 🔲 Escalar a volumen completo

---

## 14. Tabla de riesgos y mitigaciones

| Riesgo | Prob. | Impacto | Mitigación |
|---|---|---|---|
| Template o Flow rechazado por Meta | Media | Alto | Iniciar Fase 2 antes de Fase 3. Tener template UTILITY neutro de backup. |
| Loop monday ↔ n8n | Media | Alto | `checkbox_lock` + condición en webhook. |
| Duplicados en envío | Baja | Alto | `UNIQUE(id_ejecucion, telefono_wa)` + estado `PROCESANDO` antes del API call. |
| `public_url` imagen monday expirada | Media | Alto | WF-01 sube a `/media` inmediatamente y cachea `wa_media_id` en PG y monday. |
| `id_encuesta_maestro` incorrecto | Media | Alto | WF-01 valida contra `maestro.encuestas_maestro` antes de proceder. Aborta con update visible en monday. |
| `id_externo_pregunta` desincronizado del WA Flow | Media | Alto | Proceso documentado en §10. No editar un Flow sin actualizar maestro y llamar `generar_version_ponderaciones`. |
| Tier Meta insuficiente | Media | Alto | Verificar Tier 3 en Fase 2. Sin Tier 3, limitar campaña inicial a 10.000/día. |
| maestro y public en instancias distintas | Alta | Crítico | Confirmar mismo servidor en Fase 1. Si son instancias distintas: eliminar FKs cross-schema y gestionar integridad en n8n. |
| `distribuidor_*` vacío para contactos de una empresa | Media | Medio | Verificar en Fase 1 que los filtros devuelven resultados con un SELECT de prueba por empresa. |
| CSV Manual con contactos no en BD | Media | Bajo | Fila omitida y logueada en n8n. No bloquea el proceso. Documentar en checklist de campaña. |
| Meta reenvía mismo `nfm_reply` | Baja | Bajo | `ON CONFLICT DO NOTHING` en INSERT `respuestas` (UNIQUE por `id_grupo_respuesta + id_pregunta_maestro`). |
| Datos personales en logs n8n | Media | Medio | Desactivar `Save Execution Data` en WF-01 y WF-02 en producción. |
| Cambios de pesos en versiones ya respondidas | Media | Alto | `ponderaciones_versiones` es inmutable. `generar_version_ponderaciones` siempre crea versión nueva. |
| Webhook Meta caído / retrasado | Baja | Bajo | WF-04 diario sincroniza desde PG, independiente de callbacks en tiempo real. |
| Flujo inbound interrumpido | Baja | Alto | Rama `nfm_reply` comprueba tipo ANTES del flujo conversacional. Aislamiento total. |
