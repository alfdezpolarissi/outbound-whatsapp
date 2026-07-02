# Resumen ejecutivo - Modelo de datos de encuestas

**Versión 8.12.0 · Mayo 2026**

Modelo agnóstico de canal y proveedor. El diccionario de encuestas (fases, interacciones, preguntas, métricas, ponderaciones) se crea inicialmente en PostgreSQL WA para uso operativo inmediato y se migrará posteriormente a la base de datos de la extranet IT con el mismo modelo exacto. La herramienta de automatización (**n8n**) accede al diccionario siempre en modo **solo lectura**.

La clave de negocio del cliente es **(codigo_isi, nombre_empresa)** en todas las tablas y canales. El campo tipo_metrica reside en el diccionario dinámico de preguntas y se obtiene siempre mediante JOIN.

### Arquitectura de Pesos de Encuestas Mixtas (Resolución \[NCB1\] definitiva)

- **lista_metricas**: Catálogo puro. Define qué es un CSAT, un CES, etc., y sus escalas numéricas.
- **encuestas_metricas_config**: **(Nueva Tabla)** Vincula una encuesta con una métrica y le asigna su peso global de Marketing (ej: Encuesta Apertura + CSAT = 5%; Encuesta Apertura + CES = 3%).
- **preguntas_maestro**: Contiene las preguntas asociadas a una encuesta y mapeadas a su tipo de métrica.
- **ponderaciones_versiones**: El motor calcula cuántas preguntas activas compiten por la misma métrica en esa encuesta, extrae el peso global de la tabla de configuración y congela el porcentaje final neto.

## 1\. Tablas del dominio

⚠️ **Nota de despliegue:** Las tablas maestras/diccionario se instancian inicialmente en el schema maestro (o diccionario en entornos de staging temporal) de PostgreSQL WA. Las tablas operativas e históricas viven en el schema public. El flujo de n8n solo modificará la credencial de conexión tras la migración definitiva a la Extranet de IT.

| **Tabla**             | **Schema / BBDD** | **Rol**                           | **Notas clave**                                                                              |
| --------------------- | ----------------- | --------------------------------- | -------------------------------------------------------------------------------------------- |
| **lista_metricas**    | maestro/ Extranet | Catálogo global de métricas       | Almacena los tipos (NPS, CSAT, CES) y sus rangos de valores válidos (ej: \[1;5\], \[1;10\]). |
| **encuestas_maestro** | maestro/Extranet  | Definición funcional de encuestas | fase_experiencia + tipo_interaccion. id Campo id_externo_encuesta estructurado como JSONB.   |

| **encuestas_versiones** | maestro/Extranet | Control versiones | Controla qué versión está activa (v1.0, v2.0) e historiza los estados. |
| ----------------------- | ---------------- | ----------------- | ---------------------------------------------------------------------- |

| **encuestas_metricas_config** | maestro/Extranet   | Configuración de MKT            | Asigna el peso global de una métrica para una encuesta específica (Ej: CSAT vale 5% en Apertura).    |
| ----------------------------- | ------------------ | ------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **preguntas_maestro**         | maestro / Extranet | Preguntas de la encuesta        | id_externo_pregunta: Vincula question_id de SurveyMonkey o component_id de WhatsApp. **OBLIGATORIO** |
| **ponderaciones_versiones**   | maestro/ Extranet  | Histórico estático de versiones | Foto calculada de pesos dinámicos para consumo de Power BI.                                          |
| **opciones_maestro**          | maestro/ Extranet  | Opciones de respuesta           | id_externo: choice_id SMK / option_id WA.                                                            |
| **ejecuciones_encuesta**      | public (PG WA)     | **Campaña / Lanzamiento**       | Puente multicanal. Incluye flag es_prueba para Sandbox.                                              |
| **encuestas_envios**          | public (PG WA)     | Log de envíos (N8N)             | UNIQUE (id_ejecucion, telefono_wa). Control de entrega WA.                                           |
| **respuestas**                | public (PG WA)     | Resultados unificados           | 1 fila por pregunta. Vinculada a id_ejecucion. id_grupo_respuesta UNIQUE.                            |
| **contactos**                 | public (PG WA)     | Base sincronizada               | Fuente: Mailjet (3:00 AM). telefono_wa calculado por n8n.                                            |

## 2\. Canales válidos (Jerarquía de Niveles)

Basado en el **Esquema de Flujos de Experiencia Cliente**. La identidad del cliente siempre se resuelve a (codigo_isi, nombre_empresa) usando la tabla contactos en PostgreSQL WA.

| **Canal (Nivel Planificador)** | **Origen (Nivel Generador)** | **Quién normaliza**  | **Fuente de contactos** | **Mecanismo de Identidad** |
| ------------------------------ | ---------------------------- | -------------------- | ----------------------- | -------------------------- |
| **ENRUTA**                     | REPARTOS                     | Manual / Diccionario | contactos PG            | codigo_isi                 |
| **SURVEY MONKEY**              | EMAIL, FÍSICAS, QRS          | n8n: SWF-NORMALIZAR  | contactos PG            | Custom Var id_mj           |
| **N8N / BLIP**                 | WHATSAPP                     | n8n: SWF-NORMALIZAR  | contactos PG            | flow_token (Stateless)     |
| **FINESSE**                    | TELÉFONO                     | Pendiente (IT)       | \---                    | Pendiente                  |
| **BACK OLE**                   | APP / WEB                    | Pendiente (IT)       | \---                    | Pendiente                  |
| **QUICK**                      | AD 360                       | Pendiente (IT)       | \---                    | Pendiente                  |

_Nivel Recolector:_ **EXTRANET** (PostgreSQL / IT).

_Nivel Analítico:_ **POWER BI** (Consumo de datos unificados filtrando es_prueba).

## 3\. Capa Maestro Encuestas (IT / Extranet Staging)

### 3.1 Catálogo de Métricas (maestro.lista_metricas)

**Descripción:** Define la naturaleza técnica de las métricas y sus rangos válidos.

CREATE SCHEMA IF NOT EXISTS maestro;

CREATE TABLE maestro.lista_metricas (

id_metrica TEXT PRIMARY KEY, -- Ej: 'CSAT', 'CES', 'NPS', 'COMENTARIO'

valores_escala TEXT -- Descripción del rango: '\[1;5\]', '\[1;10\]', 'TEXTO'

);

### 3.2 Cabecera de Encuestas (maestro.encuestas_maestro)

**Descripción:** Define la "idea" de la encuesta. Es agnóstica a canales y ejecuciones físicas.

CREATE TABLE maestro.encuestas_maestro (

id_encuesta TEXT PRIMARY KEY, -- ID Único de control de negocio

fase_experiencia TEXT NOT NULL, -- DESCUBRIMIENTO / COMPRA / POSTVENTA / EVENTOS

tipo_interaccion TEXT NOT NULL, -- APERTURA_CLIENTE, CN_CLUB, MOVISTAR_ARENA...

interaccion_activa BOOLEAN DEFAULT true,

id_externo_encuesta JSONB, -- Mapeos y metadatos de plataformas externas

fecha_creacion TIMESTAMPTZ DEFAULT NOW(),

fecha_actualizacion TIMESTAMPTZ DEFAULT NOW()

);

CREATE INDEX IF NOT EXISTS idx_maestro_enc_tipo_interaccion ON maestro.encuestas_maestro(tipo_interaccion);

### 3.3 Maestro de Versiones de Encuesta (maestro.encuestas_versiones)

**Descripción:** Centraliza el listado maestro de versiones generadas para cada encuesta, permitiendo controlar mediante un flag cuál es la estructura activa que n8n debe utilizar para las nuevas respuestas.

SQL

CREATE TABLE maestro.encuestas_versiones (

id_encuesta TEXT NOT NULL,

version_num INT NOT NULL, -- Formato numérico secuencial incremental: 1, 2, 3

version_encuesta VARCHAR(10) NOT NULL, -- Formato literal: 'v1.0', 'v2.0'

version_activa BOOLEAN DEFAULT false, -- Flag que determina si es la versión vigente de la encuesta

fecha_creacion TIMESTAMPTZ DEFAULT NOW(),

PRIMARY KEY (id_encuesta, version_num),

CONSTRAINT uq_encuesta_version_txt UNIQUE (id_encuesta, version_encuesta),

CONSTRAINT fk_versiones_encuesta FOREIGN KEY (id_encuesta)

REFERENCES maestro.encuestas_maestro(id_encuesta) ON DELETE RESTRICT

);

### 3.4 Configuración de Pesos (maestro.encuestas_metricas_config)

**Descripción:** El "Excel de Marketing". Define qué peso global tiene una métrica en una encuesta específica.

CREATE TABLE maestro.encuestas_metricas_config (

id_encuesta TEXT NOT NULL,

id_metrica TEXT NOT NULL,

peso_global_marketing NUMERIC(6,4) NOT NULL, -- El peso del Excel (ej: 0.0500 para un 5%)

PRIMARY KEY (id_encuesta, id_metrica),

CONSTRAINT fk_emc_encuesta

FOREIGN KEY (id_encuesta) REFERENCES maestro.encuestas_maestro(id_encuesta) ON DELETE RESTRICT,

CONSTRAINT fk_emc_metrica

FOREIGN KEY (id_metrica) REFERENCES maestro.lista_metricas(id_metrica) ON DELETE RESTRICT,

CONSTRAINT chk_emc_peso_global

CHECK (peso_global_marketing >= 0 AND peso_global_marketing <= 1)

);

### 3.5 Batería de Preguntas (maestro.preguntas_maestro)

**Descripción:** Vinculadas a una encuesta y a un tipo de métrica. Se desactivan, no se borran.

CREATE TABLE maestro.preguntas_maestro (

id_pregunta TEXT PRIMARY KEY,

id_encuesta TEXT NOT NULL,

id_metrica TEXT NOT NULL,

orden INT NOT NULL,

texto_pregunta TEXT NOT NULL,

pregunta_activa BOOLEAN NOT NULL DEFAULT true, -- Baja lógica estructural

id_externo_pregunta TEXT NOT NULL, -- question_id SMK / component_id WA

fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),

fecha_actualizacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_pregunta_metrica_config FOREIGN KEY (id_encuesta, id_metrica) REFERENCES maestro.encuestas_metricas_config(id_encuesta, id_metrica) ON DELETE RESTRICT, CONSTRAINT uq_pregunta_encuesta_orden UNIQUE (id_encuesta, orden) ); CREATE INDEX IF NOT EXISTS idx_maestro_preg_externo ON maestro.preguntas_maestro(id_externo_pregunta);

### 3.6 Opciones de Respuesta (maestro.opciones_maestro)

**Descripción:** Diccionario para traducir IDs técnicos de SurveyMonkey/WA a valores numéricos reales para analítica.

CREATE TABLE maestro.opciones_maestro (

id_opcion TEXT PRIMARY KEY,

id_pregunta TEXT NOT NULL,

texto_opcion TEXT NOT NULL,

valor_numerico NUMERIC, -- Nota escalar analítica (ej: 5.00)

id_externo_opcion TEXT NOT NULL, -- choice_id SMK / option_id WA

CONSTRAINT fk_opcion_pregunta

FOREIGN KEY (id_pregunta) REFERENCES maestro.preguntas_maestro(id_pregunta) ON DELETE RESTRICT,

CONSTRAINT uq_opcion_pregunta_externa

UNIQUE (id_pregunta, id_externo_opcion)

);

CREATE INDEX IF NOT EXISTS idx_maestro_opc_externo ON maestro.opciones_maestro(id_externo_opcion);

## 4\. Capa de Reglas de Negocio y Versionado (IT / Extranet)

Esta capa actúa como el motor inteligente. Congela las configuraciones matemáticas en el tiempo para que n8n pueda leerlas y Power BI no sufra desajustes si cambian las preguntas en el futuro.

### 4.1 Historial Calculado (maestro.ponderaciones_versiones)

**Descripción:** La tabla de consumo. El motor cruza las preguntas vivas con el "Excel de Marketing" y plasma aquí el peso neto de cada pregunta por versión.

CREATE TABLE maestro.ponderaciones_versiones (

id_config SERIAL PRIMARY KEY,

id_encuesta TEXT NOT NULL,

version_num INT NOT NULL, -- Vinculación directa al maestro de versiones

id_pregunta TEXT NOT NULL,

id_metrica TEXT NOT NULL,

peso_interno_metrica NUMERIC(6,4) NOT NULL, -- Distribución equitativa intra-métrica (ej: 0.5000)

peso_global_marketing NUMERIC(6,4) NOT NULL, -- Extraído de encuestas_metricas_config

peso_final_calculado NUMERIC(10,6) NOT NULL, -- peso_interno \* peso_global (ej: 0.015000)

fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_pond_version_maestra FOREIGN KEY (id_encuesta, version_num) REFERENCES maestro.encuestas_versiones(id_encuesta, version_num) ON DELETE RESTRICT, CONSTRAINT fk_pond_pregunta FOREIGN KEY (id_pregunta) REFERENCES maestro.preguntas_maestro(id_pregunta) ON DELETE RESTRICT, CONSTRAINT uq_pond_version_pregunta UNIQUE (id_encuesta, version_num, id_pregunta), CONSTRAINT chk_pond_peso_interno CHECK (peso_interno_metrica >= 0 AND peso_interno_metrica &lt;= 1), CONSTRAINT chk_pond_peso_global CHECK (peso_global_marketing &gt;= 0 AND peso_global_marketing &lt;= 1), CONSTRAINT chk_pond_peso_final CHECK (peso_final_calculado &gt;= 0 AND peso_final_calculado <= 1) );

## 5\. Capa Operativa (PostgreSQL WA - Schema Public)

### 5.1 Base de Clientes (public.contactos)

**Descripción:** Cruza los envíos unificando correos, teléfonos y clientes.

CREATE TABLE public.contactos (

codigo_isi TEXT NOT NULL,

nombre_empresa TEXT NOT NULL,

id_mj TEXT UNIQUE, -- ID de sincronización con Mailjet

telefono_wa TEXT, -- Teléfono normalizado internacionalmente por n8n

email TEXT,

cif TEXT,

fecha_sincronizacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),

PRIMARY KEY (codigo_isi, nombre_empresa)

);

CREATE INDEX IF NOT EXISTS idx_contactos_tel ON public.contactos(telefono_wa); CREATE INDEX IF NOT EXISTS idx_contactos_email ON public.contactos(email);

### 5.2 Evento / Recopilador (public.ejecuciones_encuesta)

**Descripción:** Representa el evento físico de distribución. Una misma encuesta maestra puede tener 0, 1 o N ejecuciones (ej: Campaña SMS, Link Permanente Web).

CREATE TABLE public.ejecuciones_encuesta (

id_ejecucion UUID PRIMARY KEY DEFAULT gen_random_uuid(),

id_encuesta_maestro TEXT NOT NULL,

canal TEXT NOT NULL, -- N8N, SURVEYMONKEY, ENRUTA, BLIP...

origen TEXT, -- REPARTOS, EMAIL, WHATSAPP, QR...

id_externo_collector TEXT, -- ID del collector en la plataforma origen

titulo_ejecucion TEXT NOT NULL, -- Ej: "Campaña SMS Clientes VIP Mayo 2026"

es_prueba BOOLEAN NOT NULL DEFAULT false, -- Flag de aislamiento para Sandbox analítico

fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),

fecha_inicio_envio TIMESTAMPTZ,

CONSTRAINT fk_ejecucion_encuesta FOREIGN KEY (id_encuesta_maestro) REFERENCES maestro.encuestas_maestro(id_encuesta) ON DELETE RESTRICT ); CREATE INDEX IF NOT EXISTS idx_ejecuciones_prueba ON public.ejecuciones_encuesta(es_prueba);

### 5.3 Control de Envíos (public.encuestas_envios)

**Descripción:** Log para que n8n no envíe 2 veces el mismo mensaje al mismo cliente en la misma ejecución.

CREATE TABLE public.encuestas_envios (

id_envio UUID PRIMARY KEY DEFAULT gen_random_uuid(),

id_ejecucion UUID NOT NULL,

codigo_isi TEXT NOT NULL,

nombre_empresa TEXT NOT NULL,

telefono_wa TEXT,

email TEXT,

estado_entrega TEXT NOT NULL, -- ENVIADO / ENTREGADO / LEIDO / FALLIDO

fecha_intento TIMESTAMPTZ NOT NULL DEFAULT NOW(),

id_externo_envio TEXT, -- MessageID o ID de la plataforma de envío

CONSTRAINT fk_envio_ejecucion FOREIGN KEY (id_ejecucion) REFERENCES public.ejecuciones_encuesta(id_ejecucion) ON DELETE RESTRICT, CONSTRAINT fk_envio_contacto FOREIGN KEY (codigo_isi, nombre_empresa) REFERENCES public.contactos(codigo_isi, nombre_empresa) ON DELETE RESTRICT, CONSTRAINT uq_envio_ejecucion_cliente UNIQUE (id_ejecucion, codigo_isi, nombre_empresa) ); CREATE INDEX IF NOT EXISTS idx_envios_cliente ON public.encuestas_envios(codigo_isi, nombre_empresa);

### 5.4 Resultados y Cálculos (public.respuestas)

**Descripción:** La tabla analítica definitiva. Almacena la nota pura del cliente y el **cálculo matemático final resuelto por n8n** tras consultar la Capa de Versionado.

CREATE TABLE public.respuestas (

id_respuesta UUID PRIMARY KEY DEFAULT gen_random_uuid(),

id_ejecucion UUID NOT NULL,

id_envio UUID,

id_encuesta_maestro TEXT NOT NULL,

version_num INT NOT NULL, -- Control estricto de la versión analítica aplicada

id_pregunta_maestro TEXT NOT NULL,

id_grupo_respuesta UUID NOT NULL, -- Identificador único de sesión del cuestionario completo

codigo_isi TEXT NOT NULL, -- Identificador único del cliente (Código secundario)

nombre_empresa TEXT NOT NULL, -- Componente de la clave única de cliente

canal TEXT NOT NULL,

origen TEXT,

\-- Persistencia directa solicitada de ponderaciones y métricas

id_metrica TEXT NOT NULL, -- Métrica almacenada directamente en la respuesta

peso_final_calculado NUMERIC(10,6) NOT NULL, -- Peso exacto aplicado al momento de responder

valor_numerico NUMERIC, -- Nota directa otorgada por el cliente (ej: 5.00)

valor_calculado NUMERIC(10,6), -- Procesado por n8n en ingesta (valor_numerico \* peso_final_calculado)

respuesta_comentario TEXT, -- Comentario de texto libre (Verbatims)

atributos_adicionales JSONB, -- JSON extensible: (Ej: Blip contact_id, teléfono origen, metadatos vinculación CIF)

fecha_respuesta TIMESTAMPTZ NOT NULL DEFAULT NOW(),

CONSTRAINT fk_respuesta_contacto

FOREIGN KEY (codigo_isi, nombre_empresa) REFERENCES public.contactos(codigo_isi, nombre_empresa) ON DELETE RESTRICT,

CONSTRAINT fk_respuesta_envio

FOREIGN KEY (id_envio) REFERENCES public.encuestas_envios(id_envio) ON DELETE RESTRICT,

CONSTRAINT fk_respuesta_version_congelada

FOREIGN KEY (id_encuesta_maestro, version_num, id_pregunta_maestro)

REFERENCES maestro.ponderaciones_versiones(id_encuesta, version_num, id_pregunta) ON DELETE RESTRICT,

CONSTRAINT uq_respuesta_grupo_pregunta

UNIQUE (id_grupo_respuesta, id_pregunta_maestro)

);

\-- Índice analítico optimizado sin redundancia para filtros masivos en tableros de Power BI

CREATE INDEX idx_respuestas_analitica_compuesto ON public.respuestas(id_encuesta_maestro, version_num, fecha_respuesta);

CREATE INDEX idx_resp_cliente ON public.respuestas(codigo_isi, nombre_empresa);

CREATE INDEX IF NOT EXISTS idx_respuestas_id_envio ON public.respuestas(id_envio);

## 6\. Funciones y Procedimientos Almacenados (Capa Lógica)

### 6.1 Función: Generación de Ponderaciones (maestro.generar_version_ponderaciones)

**Descripción:** Genera una nueva versión congelada de ponderaciones para una encuesta. Calcula matemáticamente de forma automática:

- **peso_interno_metrica**: 1 / número de preguntas activas de esa métrica
- **peso_final_calculado**: peso_interno_metrica \* peso_global_marketing

**Decisión de Arquitectura: ¿Por qué una función invocable y no un Trigger automático?** > Hemos sustituido el trigger fila a fila por esta función explícita por motivos estratégicos y de rendimiento:

- **Evita históricos sucios:** Impide que se creen decenas de versiones intermedias inservibles cuando se cargan varias preguntas de golpe.
- **Control de Negocio:** Permite controlar el momento exacto en el que Marketing da por cerrada y oficial una configuración.
- **Recálculo Global:** Permite regenerar una versión de manera segura si deciden cambiar los pesos globales de la encuesta a posteriori.

**Modo de uso (Llamada):**

### CREATE OR REPLACE FUNCTION maestro.generar_version_ponderaciones(

### p_id_encuesta TEXT

### )

### RETURNS TEXT

### AS \$\$

### DECLARE

### v_version_num INT

### v_version_txt VARCHAR(10)

### v_registro RECORD

### v_peso_interno NUMERIC(10,6); -- Mayor precisión para evitar pérdidas por redondeo (ej. 1/3)

### BEGIN

### \-- 1. Validar existencia de la encuesta

### IF NOT EXISTS (

### SELECT 1 FROM maestro.encuestas_maestro WHERE id_encuesta = p_id_encuesta

### ) THEN

### RAISE EXCEPTION 'No existe la encuesta maestra con ID %', p_id_encuesta

### END IF

### \-- 2. Validar presencia de preguntas activas en el banco maestro

### IF NOT EXISTS (

### SELECT 1 FROM maestro.preguntas_maestro WHERE id_encuesta = p_id_encuesta AND pregunta_activa = true

### ) THEN

### RAISE EXCEPTION 'La encuesta % no tiene preguntas activas en el banco maestro', p_id_encuesta

### END IF

### \-- 3. Calcular secuencialmente el siguiente número incremental de versión

### SELECT COALESCE(MAX(version_num), 0) + 1

### INTO v_version_num

### FROM maestro.encuestas_versiones

### WHERE id_encuesta = p_id_encuesta

### v_version_txt := 'v' || v_version_num || '.0'

### \-- 4. Insertar registro en el maestro oficial de versiones estableciéndolo como activo

### INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)

### VALUES (p_id_encuesta, v_version_num, v_version_txt, true)

### \-- Desactivar el flag estructural de las versiones previas de esta encuesta específica

### UPDATE maestro.encuestas_versiones

### SET version_activa = false

### WHERE id_encuesta = p_id_encuesta AND version_num <> v_version_num

### \-- 5. Bucle Optimizado (O(1) por fila): Extrae preguntas y calcula el total por métrica en una sola pasada indexada

### FOR v_registro IN

### SELECT

### p.id_pregunta

### p.id_metrica

### c.peso_global_marketing

### COUNT(\*) OVER(PARTITION BY p.id_metrica) AS total_por_metrica -- Ventana analítica (Reemplaza el COUNT manual lento)

### FROM maestro.preguntas_maestro p

### JOIN maestro.encuestas_metricas_config c

### ON p.id_encuesta = c.id_encuesta

### AND p.id_metrica = c.id_metrica

### WHERE p.id_encuesta = p_id_encuesta

### AND p.pregunta_activa = true

### ORDER BY p.id_metrica, p.orden

### LOOP

### \-- Validación de seguridad por si acaso una métrica se queda a cero (evita división por cero)

### IF v_registro.total_por_metrica = 0 THEN

### RAISE EXCEPTION 'No hay preguntas activas para la métrica % en la encuesta %'

### v_registro.id_metrica, p_id_encuesta

### END IF

### \-- Reparto matemático equitativo intra-métrica de alta precisión (6 decimales)

### v_peso_interno := 1.000000 / v_registro.total_por_metrica

### \-- Congelar registro inmutable en la tabla de control histórico analítico

### INSERT INTO maestro.ponderaciones_versiones (

### id_encuesta

### version_num

### id_pregunta

### id_metrica

### peso_interno_metrica

### peso_global_marketing

### peso_final_calculado

### )

### VALUES (

### p_id_encuesta

### v_version_num

### v_registro.id_pregunta

### v_registro.id_metrica

### v_peso_interno

### v_registro.peso_global_marketing

### v_peso_interno \* v_registro.peso_global_marketing

### )

### END LOOP

### RETURN v_version_txt

### END

### \$\$ LANGUAGE plpgsql; 6.2 Función: Auditoría de Fechas (maestro.fn_set_fecha_actualizacion)

**Descripción:** Mantiene la trazabilidad y auditoría de la base de datos actualizando automáticamente el campo fecha_actualizacion (al timestamp actual) cada vez que se detecta una modificación (UPDATE) en los registros de las tablas maestras principales.

**Código SQL:**

CREATE OR REPLACE FUNCTION maestro.fn_set_fecha_actualizacion()

RETURNS TRIGGER AS \$\$

BEGIN

NEW.fecha_actualizacion := NOW();

RETURN NEW;

END;

\$\$ LANGUAGE plpgsql;

\-- Vinculación a la cabecera de encuestas

DROP TRIGGER IF EXISTS trg_encuestas_maestro_fecha_actualizacion ON maestro.encuestas_maestro;

CREATE TRIGGER trg_encuestas_maestro_fecha_actualizacion

BEFORE UPDATE ON maestro.encuestas_maestro

FOR EACH ROW EXECUTE FUNCTION maestro.fn_set_fecha_actualizacion();

\-- Vinculación al banco de preguntas

DROP TRIGGER IF EXISTS trg_preguntas_maestro_fecha_actualizacion ON maestro.preguntas_maestro;

CREATE TRIGGER trg_preguntas_maestro_fecha_actualizacion

BEFORE UPDATE ON maestro.preguntas_maestro

FOR EACH ROW EXECUTE FUNCTION maestro.fn_set_fecha_actualizacion();

## 7\. Mapas de Relación Estructural (Dependencias)

### 7.1 Flujo Jerárquico Interno del Schema maestro

Muestra el camino que recorre el motor analítico para validar desde una métrica técnica hasta la definición de sus casillas/opciones de respuesta.

┌──────────────────┐

│ lista_metricas │

└────────┬─────────┘

│

▼

┌────────────────────────────┐

│ encuestas_metricas_config │

└────────┬───────────────────┘

│

▼

┌──────────────────┐

│ preguntas_maestro│

└────────┬─────────┘

│

▼

┌──────────────────┐

│ opciones_maestro │

└──────────────────┘

### 7.2 Entidades Dependientes de la Encuesta Maestra

Estructura conceptual de cómo la cabecera de la encuesta alimenta en paralelo a la estructura de preguntas, la configuración de marketing, las versiones congeladas y las ejecuciones en producción.

┌──────────────────┐

│ encuestas_maestro│

└────────┬─────────┘

│

├──────────────▶ encuestas_versiones ───▶ ponderaciones_versiones

├──────────────▶ preguntas_maestro

├──────────────▶ encuestas_metricas_config

└──────────────▶ ejecuciones_encuesta

### 7.3 Flujo Transaccional Operativo en el Schema public

Flujo dinámico donde **n8n** opera en tiempo real. Cruza los vehículos físicos de envío (ejecuciones_encuesta) y la base maestra de clientes (contactos) para dar como resultado el log de envíos y la tabla final unificada de respuestas.

┌──────────────────────┐

│ ejecuciones_encuesta │

└──────────┬───────────┘

│

├──────────────▶ encuestas_envios

└──────────────▶ respuestas

┌──────────┐

│contactos │

└────┬─────┘

│

├──────────────▶ encuestas_envios

└──────────────▶ respuestas