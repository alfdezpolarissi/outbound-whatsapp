# Mapeo de datos: WhatsApp Flows ↔ maestro ↔ encuestas

**Proyecto:** Encuestas y Notificaciones WA — Grupo Vemare  
**Versión:** 1.0 · Junio 2026

Documento de referencia para implementar los nodos de n8n. Define qué campo de entrada (Meta API, monday, CSV) va a qué columna de base de datos, y cómo se resuelven las transformaciones intermedias.

---

## 1. Visión general del flujo de datos

```
ENVÍO (WF-01)
─────────────────────────────────────────────────────────────────────────────
monday.com ──────────────────────────────► encuestas.ejecuciones_encuesta
                                                        │
public.contactos ────────────────────────► encuestas.encuestas_envios
                                                        │
                                          Meta API POST /messages
                                          flow_token = id_envio (UUID)

RESPUESTA (WF-02)
─────────────────────────────────────────────────────────────────────────────
Meta nfm_reply
  └─ flow_token ───────────────────────► encuestas.encuestas_envios (PK lookup)
  └─ response_json
       └─ {component_id: option_id} ──► maestro.preguntas_maestro
                                         maestro.opciones_maestro
                                         maestro.ponderaciones_versiones
                                              │
                                        encuestas.respuestas (1 fila/pregunta)

CALLBACKS DELIVERY (WF-03)
─────────────────────────────────────────────────────────────────────────────
Meta statuses event
  └─ wamid ────────────────────────────► encuestas.encuestas_envios.id_externo_envio
```

---

## 2. WF-01 Outbound — Mapeo de campos

### 2.1 monday.com → encuestas.ejecuciones_encuesta

| Campo monday (ID columna) | Tipo | → Columna en `ejecuciones_encuesta` | Notas |
|---|---|---|---|
| `name` | text | `titulo_ejecucion` | Nombre de la campaña |
| `tipo_comunicacion` (status) | text | `tipo` | 'encuesta' / 'notificacion' |
| `modo_envio` (status) | text | `modo_envio` | 'EQUIPO' / 'REAL_LISTA' / 'REAL_MANUAL' |
| `text_empresa` | text | `empresa_id` | JOIN con `encuestas.empresas WHERE nombre = :valor` → tomar `id` |
| `text_segmento` | text | `segmento_filtro` | Solo Modo REAL_LISTA |
| `text_encuesta_id` | text | `id_encuesta_maestro` | ID en `maestro.encuestas_maestro` — validar existencia antes de continuar |
| `text_flow_id` | text | `flow_id` | ID del WA Flow en Meta — solo ENCUESTA |
| `text_template` | text | `template_name` | Nombre exacto del template aprobado |
| `text_url` | text | `url_destino` | Solo NOTIFICACION con botón URL |
| `checkbox_prueba` | checkbox | `es_prueba` | true si Modo EQUIPO |
| monday_item_id (del webhook) | — | `id_externo_collector` | ID del ítem que disparó la ejecución |
| — | — | `canal` | Fijo: `'N8N'` |
| — | — | `origen` | Fijo: `'WHATSAPP'` |
| Imagen `file_imagen` → POST /media Meta | — | `wa_media_id` | n8n sube la imagen y guarda el media_id devuelto |
| Versión activa de maestro | — | `version_num` | `SELECT version_num FROM maestro.encuestas_versiones WHERE id_encuesta = :id AND version_activa = true` |
| — | — | `estado` | Fijo: `'ENVIANDO'` al iniciar |

**UPSERT:**
```sql
INSERT INTO encuestas.ejecuciones_encuesta (...)
ON CONFLICT (id_externo_collector) DO UPDATE
  SET estado = EXCLUDED.estado,
      wa_media_id = EXCLUDED.wa_media_id;
```

---

### 2.2 public.contactos → encuestas.encuestas_envios

Un INSERT por cada contacto que recibe el mensaje.

| Campo en `public.contactos` | → Columna en `encuestas_envios` | Condición |
|---|---|---|
| `codigo_isi` | `codigo_isi` | Siempre (puede ser NULL en CSV sin cruzar) |
| `razon_social` / `nombre_empresa` | `nombre_empresa` | Siempre |
| `telefono_wa` | `telefono_wa` | Siempre — es la clave de envío WA |
| `email` | `email` | Cuando esté disponible |
| `id_ejecucion` (del paso anterior) | `id_ejecucion` | FK a `ejecuciones_encuesta` |
| — | `estado_entrega` | Fijo: `'PENDIENTE'` |
| — | `estado_envio` | Fijo: `'PROCESANDO'` antes del API call |

**Filtro de contactos (Modo REAL_LISTA):**
```sql
SELECT codigo_isi, razon_social AS nombre_empresa, telefono_wa, email, nombre
FROM public.contactos
WHERE activo = '1'
  AND telefono_wa IS NOT NULL AND telefono_wa <> ''
  AND listas_mailjet ILIKE '%' || :segmento_filtro || '%';
```

**Check idempotencia antes del INSERT:**
```sql
SELECT id_envio, estado_envio
FROM encuestas.encuestas_envios
WHERE id_ejecucion = :id_ejecucion AND telefono_wa = :telefono_wa;
-- Si devuelve fila con estado_envio = 'ENVIADO' → SKIP (no reenviar)
```

**INSERT:**
```sql
INSERT INTO encuestas.encuestas_envios
  (id_ejecucion, codigo_isi, nombre_empresa, telefono_wa, email, estado_entrega, estado_envio)
VALUES
  (:id_ejecucion, :codigo_isi, :nombre_empresa, :telefono_wa, :email, 'PENDIENTE', 'PROCESANDO')
ON CONFLICT (id_ejecucion, telefono_wa) DO NOTHING
RETURNING id_envio;  -- ← Este UUID es el flow_token que se pasa a Meta
```

---

### 2.3 n8n → Meta API (POST /messages)

El `id_envio` devuelto por el INSERT se usa como `flow_token`.

**Para ENCUESTA:**
```json
{
  "type": "button",
  "sub_type": "flow",
  "index": "0",
  "parameters": [{
    "type": "action",
    "action": {
      "flow_token": "{{id_envio}}",
      "flow_action_data": {
        "id_ejecucion":        "{{id_ejecucion}}",
        "id_encuesta_maestro": "{{id_encuesta_maestro}}"
      }
    }
  }]
}
```

**Respuesta Meta → encuestas_envios:**
```json
{ "messages": [{ "id": "wamid.HBgNMzQ..." }] }
```

```sql
UPDATE encuestas.encuestas_envios
SET estado_envio   = 'ENVIADO',
    estado_entrega = 'ENVIADO',
    id_externo_envio = :wamid,
    ts_envio = NOW()
WHERE id_envio = :id_envio;
```

---

## 3. WF-02 Inbound — Mapeo nfm_reply → respuestas

### 3.1 Estructura del nfm_reply (Meta → n8n)

```json
{
  "messages": [{
    "from": "34612345678",
    "type": "interactive",
    "interactive": {
      "type": "nfm_reply",
      "nfm_reply": {
        "response_json": "{
          \"flow_token\": \"550e8400-e29b-41d4-a716-446655440000\",
          \"screen_0_pregunta_nps_0\": \"9\",
          \"screen_0_pregunta_csat_0\": \"muy_satisfecho\",
          \"screen_0_comentario_0\": \"Muy buen servicio\"
        }",
        "body": "Sent",
        "name": "flow"
      }
    }
  }]
}
```

Los campos en `response_json` tienen la forma `{component_id}: {valor_raw}`:
- Para preguntas de opción: `valor_raw` = `option_id` (ej: `"muy_satisfecho"`)
- Para texto libre (COMENTARIO): `valor_raw` = el texto escrito por el usuario

---

### 3.2 Resolución de identidad: flow_token → registros

```
nfm_reply.response_json.flow_token
       │
       ▼
encuestas.encuestas_envios WHERE id_envio = flow_token::uuid
       │
       ├── id_ejecucion  ──► encuestas.ejecuciones_encuesta
       │                          ├── id_encuesta_maestro
       │                          ├── version_num
       │                          ├── canal
       │                          └── origen
       ├── codigo_isi
       └── nombre_empresa
```

**Query de lookup:**
```sql
SELECT
  ee.id_envio,
  ee.id_ejecucion,
  ee.codigo_isi,
  ee.nombre_empresa,
  e.id_encuesta_maestro,
  e.version_num,
  e.canal,
  e.origen
FROM encuestas.encuestas_envios ee
JOIN encuestas.ejecuciones_encuesta e ON e.id_ejecucion = ee.id_ejecucion
WHERE ee.id_envio = :flow_token::uuid;
```

---

### 3.3 Resolución de preguntas: component_id → maestro

```
response_json.{component_id}
       │
       ▼
maestro.preguntas_maestro
  WHERE id_externo_pregunta = :component_id
    AND id_encuesta = :id_encuesta_maestro
       │
       ├── id_pregunta
       ├── id_metrica       ──► maestro.lista_metricas (valores_escala)
       └── orden
```

**Query del mapa completo de preguntas + pesos (una sola consulta al inicio):**
```sql
SELECT
  p.id_pregunta,
  p.id_metrica,
  p.id_externo_pregunta,  -- component_id del WA Flow
  p.orden,
  pv.peso_final_calculado,
  pv.version_num
FROM maestro.encuestas_versiones ev
JOIN maestro.preguntas_maestro p
  ON p.id_encuesta = ev.id_encuesta AND p.pregunta_activa = true
JOIN maestro.ponderaciones_versiones pv
  ON pv.id_encuesta = ev.id_encuesta
 AND pv.version_num = ev.version_num
 AND pv.id_pregunta = p.id_pregunta
WHERE ev.id_encuesta = :id_encuesta_maestro
  AND ev.version_activa = true
ORDER BY p.orden;
```

Resultado: un array de preguntas con su `id_externo_pregunta` listo para cruzar contra el `response_json`.

---

### 3.4 Resolución de opciones: option_id → valor_numerico

```
response_json.{component_id} = {option_id}
       │
       ▼
maestro.opciones_maestro
  WHERE id_externo_opcion = :option_id
    AND id_pregunta = :id_pregunta   -- del paso anterior
       │
       ├── valor_numerico   -- Nota escalar del cliente (ej: 5.00)
       └── id_opcion        -- Referencia interna
```

**Query del mapa de opciones (una sola consulta al inicio):**
```sql
SELECT
  o.id_pregunta,
  o.id_externo_opcion,   -- option_id del WA Flow
  o.valor_numerico,
  o.id_opcion
FROM maestro.opciones_maestro o
JOIN maestro.preguntas_maestro p ON p.id_pregunta = o.id_pregunta
WHERE p.id_encuesta = :id_encuesta_maestro
  AND p.pregunta_activa = true;
```

---

### 3.5 Cálculo y construcción de la fila en respuestas

**Lógica en n8n (Code Node):**

```javascript
// preguntas: array de { id_pregunta, id_metrica, id_externo_pregunta, peso_final_calculado }
// opciones:  array de { id_pregunta, id_externo_opcion, valor_numerico, id_opcion }
// flowResponse: el JSON parseado del nfm_reply

const filas = preguntas.map(pregunta => {
  const valor_raw = flowResponse[pregunta.id_externo_pregunta]; // component_id como clave
  const esComentario = pregunta.id_metrica === 'COMENTARIO';

  let valor_numerico = null;
  let valor_calculado = null;
  let respuesta_comentario = null;

  if (esComentario) {
    // Texto libre: guardar tal cual, sin valor numérico
    respuesta_comentario = valor_raw ?? null;
  } else {
    // Opción: buscar valor_numerico por option_id
    const opcion = opciones.find(
      o => o.id_pregunta === pregunta.id_pregunta && o.id_externo_opcion === valor_raw
    );
    valor_numerico  = opcion?.valor_numerico ?? null;
    valor_calculado = (valor_numerico !== null && pregunta.peso_final_calculado > 0)
                      ? valor_numerico * pregunta.peso_final_calculado
                      : null;
  }

  return {
    id_ejecucion:         id_ejecucion,
    id_envio:             id_envio,             // = flow_token::uuid
    id_encuesta_maestro:  id_encuesta_maestro,
    version_num:          version_num,
    id_pregunta_maestro:  pregunta.id_pregunta,
    id_grupo_respuesta:   id_envio,             // = id_envio (determinista)
    codigo_isi:           codigo_isi,
    nombre_empresa:       nombre_empresa,
    canal:                'WHATSAPP',
    origen:               'N8N',
    id_metrica:           pregunta.id_metrica,
    peso_final_calculado: pregunta.peso_final_calculado,
    valor_numerico,
    valor_calculado,
    respuesta_comentario,
    atributos_adicionales: JSON.stringify({
      component_id: pregunta.id_externo_pregunta,
      raw_value:    valor_raw
    })
  };
});

return filas; // Un item por pregunta → SplitInBatches para INSERT individual
```

**INSERT en encuestas.respuestas:**
```sql
INSERT INTO encuestas.respuestas (
  id_ejecucion, id_envio, id_encuesta_maestro, version_num,
  id_pregunta_maestro, id_grupo_respuesta,
  codigo_isi, nombre_empresa, canal, origen,
  id_metrica, peso_final_calculado,
  valor_numerico, valor_calculado, respuesta_comentario,
  atributos_adicionales
) VALUES (
  :id_ejecucion, :id_envio::uuid, :id_encuesta_maestro, :version_num,
  :id_pregunta_maestro, :id_grupo_respuesta::uuid,
  :codigo_isi, :nombre_empresa, :canal, :origen,
  :id_metrica, :peso_final_calculado,
  :valor_numerico, :valor_calculado, :respuesta_comentario,
  :atributos_adicionales::jsonb
)
ON CONFLICT (id_grupo_respuesta, id_pregunta_maestro) DO NOTHING;
-- ON CONFLICT protege contra reenvíos del mismo nfm_reply por parte de Meta
```

---

### 3.6 Actualización de estado tras la ingesta

```sql
-- Marcar el envío como respondido
UPDATE encuestas.encuestas_envios
SET estado_entrega = 'respondido'
WHERE id_envio = :flow_token::uuid;
```

---

## 4. WF-03 Callbacks — Mapeo statuses → encuestas_envios

### 4.1 Estructura del evento statuses (Meta → n8n)

```json
{
  "statuses": [{
    "id":        "wamid.HBgNMzQ...",
    "status":    "delivered",
    "timestamp": "1718000000",
    "recipient_id": "34612345678",
    "errors": []
  }]
}
```

### 4.2 Mapeo a encuestas.encuestas_envios

| Campo Meta | → Columna en `encuestas_envios` | Condición |
|---|---|---|
| `statuses[0].id` | Lookup: `WHERE id_externo_envio = :wamid` | Identifica el registro |
| `statuses[0].status = 'sent'` | `estado_entrega = 'ENVIADO'` | — |
| `statuses[0].status = 'delivered'` | `estado_entrega = 'ENTREGADO'`, `ts_delivered = to_timestamp(:ts)` | — |
| `statuses[0].status = 'read'` | `estado_entrega = 'LEIDO'`, `ts_read = to_timestamp(:ts)` | — |
| `statuses[0].status = 'failed'` | `estado_entrega = 'FALLIDO'`, `error_msg = statuses[0].errors[0].title` | Ver lógica de reintentos |

**Lógica de reintentos:**
```sql
-- Si falla y quedan intentos disponibles
UPDATE encuestas.encuestas_envios
SET estado_envio = 'REINTENTO',
    intentos = intentos + 1,
    error_msg = :error_msg
WHERE id_externo_envio = :wamid AND intentos < 3;

-- Si ha superado los 3 intentos
UPDATE encuestas.encuestas_envios
SET estado_envio = 'ERROR_DEFINITIVO',
    error_msg = :error_msg
WHERE id_externo_envio = :wamid AND intentos >= 3;
```

---

## 5. Mapeo completo de columnas: WA Flow → maestro → encuestas.respuestas

Tabla de referencia rápida campo a campo:

| Origen | Campo | Transformación | Destino |
|---|---|---|---|
| nfm_reply | `response_json.flow_token` | `::uuid` | `encuestas_envios.id_envio` (lookup PK) |
| nfm_reply | `messages[0].from` | — | Solo para logs, no se guarda en respuestas |
| nfm_reply | `response_json.{component_id}` | Key del JSON | `maestro.preguntas_maestro.id_externo_pregunta` (lookup) |
| nfm_reply | `response_json.{component_id}` = `{option_id}` | Value del JSON | `maestro.opciones_maestro.id_externo_opcion` (lookup) |
| maestro lookup | `preguntas_maestro.id_pregunta` | — | `respuestas.id_pregunta_maestro` |
| maestro lookup | `preguntas_maestro.id_metrica` | — | `respuestas.id_metrica` |
| maestro lookup | `ponderaciones_versiones.peso_final_calculado` | — | `respuestas.peso_final_calculado` |
| maestro lookup | `opciones_maestro.valor_numerico` | `NULL` si COMENTARIO | `respuestas.valor_numerico` |
| cálculo n8n | `valor_numerico × peso_final_calculado` | `NULL` si COMENTARIO o peso=0 | `respuestas.valor_calculado` |
| nfm_reply | `response_json.{component_id}` (texto libre) | Solo si id_metrica = 'COMENTARIO' | `respuestas.respuesta_comentario` |
| encuestas_envios (lookup) | `id_envio` | `::uuid` | `respuestas.id_grupo_respuesta` |
| encuestas_envios (lookup) | `codigo_isi` | — | `respuestas.codigo_isi` |
| encuestas_envios (lookup) | `nombre_empresa` | — | `respuestas.nombre_empresa` |
| ejecuciones (lookup) | `id_ejecucion` | — | `respuestas.id_ejecucion` |
| ejecuciones (lookup) | `id_encuesta_maestro` | — | `respuestas.id_encuesta_maestro` |
| ejecuciones (lookup) | `version_num` | — | `respuestas.version_num` |
| ejecuciones (lookup) | `canal` | — | `respuestas.canal` |
| ejecuciones (lookup) | `origen` | — | `respuestas.origen` |
| n8n (fijo) | `'WHATSAPP'` | — | `respuestas.canal` (si no viene de ejecuciones) |
| n8n (compuesto) | `{component_id, raw_value}` | `::jsonb` | `respuestas.atributos_adicionales` |

---

## 6. Sincronización WA Flow ↔ maestro (checklist de mantenimiento)

Al crear o modificar un WA Flow en Meta Flow Builder:

| Qué cambia en Meta | Acción en maestro | Crear nueva versión |
|---|---|---|
| Se añade una pregunta | INSERT en `preguntas_maestro` con nuevo `id_externo_pregunta` (component_id) | **Sí** — llamar `generar_version_ponderaciones()` |
| Se elimina una pregunta | UPDATE `pregunta_activa = false` en `preguntas_maestro` | **Sí** |
| Se reordena una pregunta | UPDATE `orden` en `preguntas_maestro` | Solo si afecta a cálculos — decisión de Marketing |
| Se añade una opción | INSERT en `opciones_maestro` con nuevo `id_externo_opcion` (option_id) | No (salvo que cambie el valor_numerico) |
| Se modifica texto de pregunta/opción | UPDATE `texto_pregunta` / `texto_opcion` | No (cambio cosmético) |
| Cambian los pesos en Excel de Marketing | UPDATE `encuestas_metricas_config.peso_global_marketing` | **Sí** |

**Para obtener component_id y option_id de un Flow publicado:**

```bash
# Desde Meta Graph API (sustituir {flow_id} y {access_token})
GET https://graph.facebook.com/v20.0/{flow_id}?fields=json_version,preview&access_token={token}
```

El campo `json_version` contiene el JSON del Flow donde cada componente tiene su `id` (= `component_id`) y cada opción tiene su `id` (= `option_id`).

---

## 7. Resumen de queries n8n ordenadas por workflow

### WF-01 — Orden de ejecución

1. **Validar encuesta:** `SELECT 1 FROM maestro.encuestas_maestro WHERE id_encuesta = ? AND interaccion_activa = true`
2. **Obtener versión activa:** `SELECT version_num FROM maestro.encuestas_versiones WHERE id_encuesta = ? AND version_activa = true`
3. **Obtener empresa:** `SELECT id FROM encuestas.empresas WHERE nombre = ?`
4. **Upsert ejecución:** `INSERT INTO encuestas.ejecuciones_encuesta ... ON CONFLICT (id_externo_collector) DO UPDATE`
5. **Obtener contactos:** `SELECT ... FROM public.contactos WHERE activo = '1' AND telefono_wa IS NOT NULL AND listas_mailjet ILIKE ?`
6. **Check idempotencia:** `SELECT id_envio, estado_envio FROM encuestas.encuestas_envios WHERE id_ejecucion = ? AND telefono_wa = ?`
7. **Insertar envío:** `INSERT INTO encuestas.encuestas_envios ... ON CONFLICT DO NOTHING RETURNING id_envio`
8. **Tras API call exitoso:** `UPDATE encuestas.encuestas_envios SET estado_envio='ENVIADO', id_externo_envio=:wamid ...`

### WF-02 — Orden de ejecución

1. **Lookup por flow_token:** `SELECT ee.*, e.* FROM encuestas.encuestas_envios ee JOIN encuestas.ejecuciones_encuesta e ... WHERE ee.id_envio = ?::uuid`
2. **Cargar mapa preguntas+pesos:** Query de §3.3
3. **Cargar mapa opciones:** Query de §3.4
4. **Code Node:** Construir array de filas (§3.5)
5. **Insertar respuestas:** `INSERT INTO encuestas.respuestas ... ON CONFLICT DO NOTHING`
6. **Actualizar estado:** `UPDATE encuestas.encuestas_envios SET estado_entrega = 'respondido' WHERE id_envio = ?::uuid`

### WF-03 — Orden de ejecución

1. **Update delivery:** `UPDATE encuestas.encuestas_envios SET estado_entrega = ?, ts_delivered/ts_read = ... WHERE id_externo_envio = ?`
2. **Si failed:** lógica de reintentos según `intentos` (§4.2)
