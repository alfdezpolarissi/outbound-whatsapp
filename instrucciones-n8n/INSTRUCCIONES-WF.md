# Instrucciones de implementación — Workflows n8n
**Proyecto:** Encuestas y Notificaciones WA — Grupo Vemare  
**Última actualización:** Junio 2026

Documento de referencia para crear, configurar e importar todos los workflows de n8n del proyecto. Leer en orden antes de tocar nada en n8n.

---

## Índice

1. [Prerequisitos antes de abrir n8n](#1-prerequisitos-antes-de-abrir-n8n)
2. [Credenciales a configurar en n8n](#2-credenciales-a-configurar-en-n8n)
3. [Orden de implementación](#3-orden-de-implementación)
4. [WF-SMK-INGEST-RESPUESTAS (SurveyMonkey)](#4-wf-smk-ingest-respuestas)
5. [WF-01-OUTBOUND-WA (Envío masivo WhatsApp)](#5-wf-01-outbound-wa)
6. [WF-02-INBOUND-RESPUESTA (Captura nfm_reply)](#6-wf-02-inbound-respuesta)
7. [WF-03-STATUS-TRACKER (Callbacks delivery)](#7-wf-03-status-tracker)
8. [WF-04-REPORTE (Reporte diario)](#8-wf-04-reporte)
9. [Patrones n8n recurrentes](#9-patrones-n8n-recurrentes)
10. [Errores comunes y soluciones](#10-errores-comunes-y-soluciones)

---

## 1. Prerequisitos antes de abrir n8n

Verificar que esto está hecho antes de crear ningún workflow:

### Base de datos
- [ ] Schema `maestro` creado → ejecutar `encuestas-schema.sql`
- [ ] Schema `encuestas` creado → mismo archivo
- [ ] `public.contactos` tiene columna `nombre_empresa` → ejecutar la migración del §3.0 del plan técnico
- [ ] `encuestas.empresas` poblada con VEMARE, TRANSCOSE, DIESELIBERIA, PAHER
- [ ] Al menos una encuesta registrada en `maestro.encuestas_maestro` con `smk_survey_id` en el JSONB
- [ ] `maestro.generar_version_ponderaciones('ID')` ejecutada → debe devolver 'v1.0'
- [ ] Índices creados → verificar con `\d encuestas.respuestas` en psql

### SurveyMonkey
- [ ] Acceso a la cuenta API de SurveyMonkey con token de acceso
- [ ] Surveyes activas con `custom_variables` configuradas: `cod`, `dis`, `email`
- [ ] Los `survey_id` y `question_id` de SMK copiados al maestro (`id_externo_encuesta`, `id_externo_pregunta`)

### WhatsApp / Meta (para WF-01/02/03)
- [ ] App Meta verificada con webhook configurado
- [ ] Templates aprobados: `encuesta_wa`, `notificacion_con_url`, `notificacion_sin_url`
- [ ] WA Flow publicado en Meta Flow Builder con `component_id`s mapeados al maestro
- [ ] `phone_number_id` de cada número WA disponible (se configura en n8n Credentials, NO en BD)
- [ ] App Secret disponible para la validación X-Hub-Signature-256
- [ ] Tier de envío verificado en Meta Business Manager (22.500 contactos → Tier 3)

### monday.com (para WF-01)
- [ ] Board "Comunicaciones WA" creado con todas las columnas del §5.1 del plan técnico
- [ ] Webhook de monday apuntando a la URL de n8n del WF-01 (con `status_wa = ENVIAR_WA`)
- [ ] API key de monday disponible

---

## 2. Credenciales a configurar en n8n

Ir a **Settings → Credentials → Add credential** para cada una.

### 2.1 PostgreSQL — `PostgreSQL Vemare`
```
Type:     Postgres
Host:     <IP o hostname del servidor PG>
Port:     5432
Database: <nombre de la base de datos>
User:     <usuario n8n>
Password: <contraseña>
SSL:      según configuración del servidor
```
Tras crear: anotar el **ID** que aparece en la URL (`/credentials/XXXXX/edit`). Se usará para sustituir `PG_CREDENTIAL_ID` en los JSON importados.

### 2.2 SurveyMonkey API — `SurveyMonkey API`
```
Type:          HTTP Header Auth
Name:          Authorization
Value:         Bearer TU_TOKEN_AQUI
```
Token de SurveyMonkey: disponible en la cuenta de SMK → Developer → My Apps → Access Token.  
Tras crear: anotar el **ID** para sustituir `SMK_CREDENTIAL_ID`.

### 2.3 WhatsApp / Meta — `Meta WA Token`
```
Type:          HTTP Header Auth
Name:          Authorization
Value:         Bearer TU_WA_ACCESS_TOKEN
```
Access Token disponible en Meta Business Manager → Sistema → Tokens de acceso.

### 2.4 WhatsApp App Secret — variable de entorno en n8n
En el servidor n8n, añadir al `.env` o a la configuración de entorno:
```
N8N_CUSTOM_ENV_WA_APP_SECRET=tu_app_secret_de_meta
```
En los nodos Code se accede como `$env.WA_APP_SECRET`.

### 2.5 monday.com — `monday.com API`
```
Type:  Monday.com API
API Key: tu_api_key_monday
```

> **n8n Community Edition**: las Variables (`$vars`) no están disponibles en la versión Community. Toda la configuración reutilizable (como `phone_number_id` por empresa) se almacena en PostgreSQL y se lee con un SELECT. Los secretos van en Credentials.

---

## 3. Orden de implementación

Respetar este orden. Cada paso depende del anterior.

```
Fase 1 → BD + prerequisitos (ver plan-tecnico-wa-v7.0.md §13 Fase 1 y 2)
Fase 2 → Configurar credenciales en n8n (§2 de este doc)
Fase 3 → Importar y configurar WF-SMK-INGEST-RESPUESTAS
Fase 4 → Importar y configurar WF-01-OUTBOUND-WA
Fase 5 → Importar y configurar WF-02-INBOUND-RESPUESTA
Fase 6 → Importar y configurar WF-03-STATUS-TRACKER
Fase 7 → Importar y configurar WF-04-REPORTE
Fase 8 → Pruebas end-to-end (ver plan técnico §13 Fase 8 y 9)
```

---

## 4. WF-SMK-INGEST-RESPUESTAS

**Archivo:** `WF-SMK-INGEST-RESPUESTAS.json`  
**Propósito:** Polling de nuevas respuestas de SurveyMonkey → normalización → INSERT en `encuestas.respuestas`

### 4.1 Importar el workflow

1. En n8n: menú lateral → **Workflows → Import from file**
2. Seleccionar `WF-SMK-INGEST-RESPUESTAS.json`
3. El workflow se importa en estado **inactivo** (correcto, no activar todavía)

### 4.2 Sustituir IDs de credenciales

Tras importar, n8n mostrará errores en los nodos con credenciales no encontradas. Para cada nodo afectado:

| Nodo | Credencial a asignar |
|---|---|
| `PG: Surveys activas` | PostgreSQL Vemare |
| `PG: Maestro lookup` | PostgreSQL Vemare |
| `PG: Upsert ejecucion` | PostgreSQL Vemare |
| `PG: Identidad contacto` | PostgreSQL Vemare |
| `PG: Upsert envio` | PostgreSQL Vemare |
| `PG: Mapa preguntas` | PostgreSQL Vemare |
| `PG: Mapa opciones` | PostgreSQL Vemare |
| `PG: Insert respuesta` | PostgreSQL Vemare |
| `HTTP: SMK Bulk responses` | SurveyMonkey API |
| `HTTP: SMK Response detail` | SurveyMonkey API |

### 4.3 Verificar nodos clave

**`Code: Init timestamp`**  
Primera ejecución: procesa las últimas 25h (fallback automático). Las siguientes: usa el timestamp guardado en `staticData`. No tocar.

**`PG: Surveys activas`**  
Query: lee `maestro.encuestas_maestro WHERE id_externo_encuesta->>'smk_survey_id' IS NOT NULL`. Si devuelve 0 filas → las encuestas no están correctamente registradas en maestro. Ver mapeo §4.1 del documento `mapeo-surveymonkey-maestro-encuestas.md`.

**`PG: Upsert ejecucion`**  
Maneja ambas tipologías automáticamente:
- **Con collector ya registrado** (Tipología A): `ON CONFLICT` → devuelve la fila existente
- **Collector nuevo** (Tipología B): `INSERT` → crea la ejecución con título `SMK Collector {id}`

Si el título por defecto no es suficiente, actualizar manualmente en BD:
```sql
UPDATE encuestas.ejecuciones_encuesta
SET titulo_ejecucion = '18/04 Festival Electrolatino'
WHERE id_externo_collector = '464375331';
```

**`Code: Construir respuestas`**  
Este es el nodo más complejo. Accede a datos de 4 nodos anteriores usando `$('NombreNodo').all()`. Si falla, revisar:
1. Que `PG: Mapa preguntas` devuelve filas (la encuesta tiene preguntas activas en maestro)
2. Que `id_externo_pregunta` en maestro coincide con el `question.id` de SMK
3. Que `PG: Upsert envio` devolvió `id_envio` en el `RETURNING`

**`Code: Update timestamp`**  
Guarda en `staticData` el timestamp de inicio de la ejecución actual. Solo se dispara cuando el `Loop: Por pregunta` termina con su output "done" (1). Si el workflow falla antes de este punto, el timestamp NO se actualiza → el próximo polling volverá a procesar las mismas responses (comportamiento correcto, hay `ON CONFLICT DO NOTHING`).

### 4.4 Test del workflow

1. En un collector de SMK, asegurarse de que hay al menos 1 respuesta completada
2. Ejecutar el workflow **manualmente** (botón "Execute workflow" en n8n)
3. Verificar en BD:
```sql
-- ¿Se creó la ejecucion?
SELECT * FROM encuestas.ejecuciones_encuesta WHERE canal = 'SURVEYMONKEY' ORDER BY fecha_creacion DESC LIMIT 5;

-- ¿Se creó el envio?
SELECT * FROM encuestas.encuestas_envios ORDER BY fecha_intento DESC LIMIT 5;

-- ¿Se insertaron las respuestas?
SELECT r.*, p.texto_pregunta
FROM encuestas.respuestas r
JOIN maestro.preguntas_maestro p ON p.id_pregunta = r.id_pregunta_maestro
ORDER BY r.fecha_respuesta DESC LIMIT 20;
```
4. Si todo está bien → activar el workflow (toggle en la esquina superior derecha)

### 4.5 Consideraciones sobre collectors sin custom_variables

Si `custom_variables = {}` (link no personalizado), `codigo_isi` y `nombre_empresa` llegarán como `NULL`. Las respuestas se insertan igualmente en `encuestas.respuestas` con esos campos en NULL. Power BI los puede filtrar o mostrar como "Anónimo".

Para evitar esto en producción: siempre distribuir encuestas con links personalizados que incluyan `?cod=CODIGO_ISI&dis=NOMBRE_EMPRESA&email=EMAIL`.

---

## 5. WF-01-OUTBOUND-WA

**Propósito:** Envío masivo de encuestas y notificaciones por WhatsApp  
**Trigger:** Webhook de monday.com cuando `status_wa = ENVIAR_WA`

### 5.1 Crear el workflow desde cero

Este workflow NO tiene JSON de importación (más complejo de mantener como JSON). Crear los nodos en este orden:

#### Nodos en orden

**1. Webhook de monday**
```
Type:        Webhook
HTTP Method: POST
Path:        wf-01-outbound-wa   ← copiar esta URL para el webhook de monday
```

**2. SET: dispatch_lock = true**
```
Type: HTTP Request (monday GraphQL)
URL:  https://api.monday.com/v2
Body (JSON):
{
  "query": "mutation { change_column_value(board_id: BOARD_ID, item_id: \"{{ $json.body.event.pulseId }}\", column_id: \"checkbox_lock\", value: \"{\\\"checked\\\":\\\"true\\\"}\") { id } }"
}
```

**3. HTTP: monday GetComunicacion**
```
URL: https://api.monday.com/v2
Body:
{
  "query": "query { items(ids: [{{ $json.body.event.pulseId }}]) { id name column_values { id text value } assets { public_url file_extension name } } }"
}
```

**4. Code: Extraer campos del board**
```javascript
const item = $input.first().json.data.items[0];
const cols = {};
item.column_values.forEach(c => { cols[c.id] = c.text; });
const asset = item.assets?.[0];

return [{
  json: {
    monday_item_id:     item.id,
    titulo:             item.name,
    tipo:               cols.tipo_comunicacion,
    modo_envio:         cols.modo_envio,
    empresa:            cols.text_empresa,
    segmento:           cols.text_segmento,
    id_encuesta_maestro: cols.text_encuesta_id,
    flow_id:            cols.text_flow_id,
    template_name:      cols.text_template,
    texto_cuerpo:       cols.long_text_cuerpo,
    url_destino:        cols.text_url,
    text_media_id:      cols.text_media_id,
    public_url_imagen:  asset?.public_url || null
  }
}];
```

**5. PG: Validar id_encuesta_maestro** ← CRÍTICO, no saltarse
```sql
SELECT id_encuesta FROM maestro.encuestas_maestro
WHERE id_encuesta = $1 AND interaccion_activa = true
```
- Si devuelve 0 filas → IF node → UPDATE monday status=ERROR + ABORT

**6. PG: Version activa + empresa**
```sql
SELECT ev.version_num,
       e.id AS empresa_id
FROM maestro.encuestas_versiones ev,
     encuestas.empresas e
WHERE ev.id_encuesta = $1 AND ev.version_activa = true
  AND e.nombre = $2
```

**7. IF: ¿wa_media_id ya existe en monday?**  
- SÍ → usar el existente  
- NO → POST a `https://graph.facebook.com/v20.0/{PHONE_NUMBER_ID}/media` con la imagen → guardar en BD y monday

> El `phone_number_id` se obtiene de las Credentials de n8n (Meta WA Token). NO está en BD.

**8. PG: Upsert ejecucion**
```sql
INSERT INTO encuestas.ejecuciones_encuesta
  (id_encuesta_maestro, canal, origen, id_externo_collector,
   titulo_ejecucion, es_prueba, empresa_id, tipo, modo_envio,
   segmento_filtro, wa_media_id, template_name, flow_id,
   url_destino, version_num, estado)
VALUES ($1,'N8N','WHATSAPP',$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,'ENVIANDO')
ON CONFLICT (id_externo_collector) DO UPDATE
  SET estado = 'ENVIANDO', wa_media_id = EXCLUDED.wa_media_id
RETURNING id_ejecucion
```

**9. UPDATE monday: status = ENVIANDO**

**10. PG: Obtener contactos** (según `modo_envio`)

Modo REAL_LISTA:
```sql
SELECT codigo_isi, razon_social AS nombre_empresa, telefono_wa, nombre
FROM public.contactos
WHERE activo = '1'
  AND telefono_wa IS NOT NULL AND telefono_wa <> ''
  AND listas_mailjet ILIKE '%' || $1 || '%'
```

Modo REAL_MANUAL: descargar CSV del asset de monday → parsear → cruzar por `telefono_wa`.

Modo EQUIPO: array hardcodeado de teléfonos del equipo en un Set node.

**11. SplitInBatches: lotes de 50**

**12. PG: Check idempotencia**
```sql
SELECT id_envio, estado_envio FROM encuestas.encuestas_envios
WHERE id_ejecucion = $1 AND telefono_wa = $2
```
- Si `estado_envio = 'ENVIADO'` → IF → NoOp (saltar)

**13. PG: INSERT encuestas_envios**
```sql
INSERT INTO encuestas.encuestas_envios
  (id_ejecucion, codigo_isi, nombre_empresa, telefono_wa,
   estado_entrega, estado_envio)
VALUES ($1,$2,$3,$4,'PENDIENTE','PROCESANDO')
ON CONFLICT (id_ejecucion, telefono_wa) DO NOTHING
RETURNING id_envio
```

**14. HTTP: POST /messages a Meta**  
URL: `https://graph.facebook.com/v20.0/{PHONE_NUMBER_ID}/messages`  
Ver payloads exactos en `plan-tecnico-wa-v7.0.md` §6.3 / §6.4 / §6.5  
**El `flow_token` del payload = `id_envio` del INSERT anterior**

**15. IF: ¿HTTP 200?**
- OK → PG UPDATE estado_envio='ENVIADO', id_externo_envio=wamid, ts_envio=NOW()
- ERR → IF intentos < 3 → Wait 30s → retry / ELSE → UPDATE ERROR_DEFINITIVO + update monday

**16. mutation monday: num_enviados += lote**

**17. Al terminar todos los lotes:**
- PG UPDATE ejecucion estado='ENVIADA'
- mutation monday: status=ENVIADA, checkbox_lock=false

### 5.2 Configuración del webhook en monday.com

1. monday → Board "Comunicaciones WA" → Integrations → Webhooks
2. Crear webhook:
   - Event: `change_column_values`
   - Column: `status_wa`
   - URL: URL del webhook de n8n (paso 1 del §5.1)
3. Añadir condición: `checkbox_lock = false` (para el anti-loop)

---

## 6. WF-02-INBOUND-RESPUESTA

**Propósito:** Capturar `nfm_reply` de WA Flow y normalizar respuestas  
**Trigger:** WhatsApp Webhook (el mismo trigger del flujo inbound existente)

### 6.1 Integración con el flujo inbound existente

NO crear un workflow nuevo. **Modificar el flujo inbound existente** añadiendo nodos antes del nodo "Buscar sesión activa":

```
[WhatsApp Trigger] (existente)
       ↓
[Validar X-Hub-Signature-256]  ← NUEVO — ver código en §6.2
       ↓
[Normalizar datos] (existente — añadir detección nfm_reply, ver §6.3)
       ↓
[IF: is_flow_response?]  ← NUEVO
    ├── SÍ → [SWF-ENCUESTA-RESPUESTA-HANDLER]  ← Sub-workflow
    └── NO → [Lógica inbound existente SIN cambios]
```

### 6.2 Nodo: Validar X-Hub-Signature-256

```javascript
// Añadir como primer nodo después del WhatsApp Trigger
const crypto    = require('crypto');
const payload   = JSON.stringify($json.body);
const signature = $json.headers['x-hub-signature-256'];
const expected  = 'sha256=' + crypto
  .createHmac('sha256', $env.WA_APP_SECRET)
  .update(payload)
  .digest('hex');

if (!signature || signature !== expected) {
  throw new Error('X-Hub-Signature-256 inválida — request rechazado');
}

return $input.all();
```

### 6.3 Modificar nodo "Normalizar datos" (añadir al final del código existente)

```javascript
// AÑADIR al código existente de normalización:
let flow_response = null;
let flow_token    = '';
let is_flow_response = false;

if (tipo === 'interactive' && msg.interactive?.type === 'nfm_reply') {
  flow_response    = JSON.parse(msg.interactive.nfm_reply.response_json);
  flow_token       = flow_response.flow_token ?? '';
  text_content     = 'nfm_reply';
  is_flow_response = true;
}

// Añadir al return existente:
return {
  // ...campos existentes...,
  flow_response,
  flow_token,
  is_flow_response
};
```

### 6.4 Sub-workflow: SWF-ENCUESTA-RESPUESTA-HANDLER

Crear como workflow separado en n8n (tipo "Execute Workflow" → llamado desde el IF).

Nodos del sub-workflow:

**1. Execute Workflow Trigger** (recibe `{ db_phone, flow_response, flow_token }`)

**2. PG: Lookup por flow_token**
```sql
SELECT ee.id_envio, ee.id_ejecucion, ee.codigo_isi, ee.nombre_empresa,
       e.id_encuesta_maestro, e.version_num, e.canal, e.origen
FROM encuestas.encuestas_envios ee
JOIN encuestas.ejecuciones_encuesta e ON e.id_ejecucion = ee.id_ejecucion
WHERE ee.id_envio = $1::uuid
```
Parámetro: `flow_token`

**3. IF: ¿Encontrado?**  
- NO → Log error + RETURN `{ status: 'error', reason: 'flow_token_not_found' }`

**4. PG: Mapa preguntas** (ver query en §6.1 del mapeo WA)

**5. PG: Mapa opciones** (ver query en §6.2 del mapeo WA)

**6. Code: Construir respuestas** (ver §3.5 del mapeo WA)  
`id_grupo_respuesta = flow_token::uuid = id_envio` (determinista)

**7. Loop: Por pregunta + PG: INSERT respuesta**
```sql
INSERT INTO encuestas.respuestas (...) VALUES (...)
ON CONFLICT (id_grupo_respuesta, id_pregunta_maestro) DO NOTHING
```

**8. PG: Marcar como respondido**
```sql
UPDATE encuestas.encuestas_envios
SET estado_entrega = 'respondido'
WHERE id_envio = $1::uuid
```

**9. mutation monday: incrementar num_respondidos**

**En caso de error en cualquier paso:**
```sql
UPDATE encuestas.encuestas_envios
SET estado_entrega = 'error_normalizacion'
WHERE id_envio = $1::uuid
```
+ mutation monday: update ítem con descripción del error.

---

## 7. WF-03-STATUS-TRACKER

**Propósito:** Actualizar estado de delivery en `encuestas_envios` a partir de callbacks de Meta  
**Trigger:** WhatsApp Webhook (suscrito a `message_status`)

### 7.1 Nodos

**1. WhatsApp Trigger** (suscrito a `statuses` events — puede ser el mismo trigger del WF-02 con un IF inicial)

**2. IF: ¿Es evento statuses?**
```javascript
// Condición: $json.body.entry[0].changes[0].value.statuses existe
```

**3. Code: Extraer status**
```javascript
const statuses   = $json.body.entry[0].changes[0].value.statuses[0];
const message_id = statuses.id;
const status     = statuses.status;       // sent | delivered | read | failed
const ts         = statuses.timestamp;
const error_msg  = statuses.errors?.[0]?.title || null;

return [{ json: { message_id, status, ts, error_msg } }];
```

**4. PG: UPDATE delivery**
```sql
UPDATE encuestas.encuestas_envios
SET estado_entrega = $1,
    ts_delivered   = CASE WHEN $1 = 'delivered' THEN to_timestamp($2::bigint) END,
    ts_read        = CASE WHEN $1 = 'read'      THEN to_timestamp($2::bigint) END
WHERE id_externo_envio = $3
```
Parámetros: `[status, ts, message_id]`

**5. IF: ¿status = 'failed'?**
- SÍ → PG: `UPDATE SET estado_envio = CASE WHEN intentos < 3 THEN 'REINTENTO' ELSE 'ERROR_DEFINITIVO' END, intentos = intentos + 1, error_msg = $1`
  - Si ERROR_DEFINITIVO → mutation monday: update ítem con detalle

---

## 8. WF-04-REPORTE

**Propósito:** Actualizar contadores en monday cada mañana desde PostgreSQL  
**Trigger:** Schedule (8:00 AM)

### 8.1 Nodos

**1. Schedule Trigger**
```
Cron: 0 8 * * *
```

**2. HTTP: monday — items ENVIADA/ENVIANDO**
```graphql
query {
  boards(ids: [BOARD_ID]) {
    items_page(limit: 100, query_params: {
      rules: [{ column_id: "status_wa", compare_value: ["ENVIADA","ENVIANDO"] }]
    }) {
      items { id column_values { id text } }
    }
  }
}
```

**3. SplitInBatches: lotes de 10 items**

**4. Code: Extraer id_ejecucion del item**
```javascript
// Buscar el campo text_encuesta_id que tiene el id_ejecucion almacenado
// O hacer lookup por id_externo_collector = monday_item_id
```

**5. PG: Contadores**
```sql
SELECT
  COUNT(*) FILTER (WHERE estado_envio   = 'ENVIADO')   AS total_enviados,
  COUNT(*) FILTER (WHERE estado_entrega = 'ENTREGADO') AS total_delivered,
  COUNT(*) FILTER (WHERE estado_entrega = 'respondido') AS total_respondidos
FROM encuestas.encuestas_envios
WHERE id_ejecucion = $1
```

**6. mutation monday: actualizar num_enviados, num_delivered, num_respondidos**

**7. IF: ¿total_respondidos = total_enviados?**  
→ mutation monday: status = COMPLETADA

---

## 9. Patrones n8n recurrentes

### 9.1 Referencia a nodos anteriores en Code nodes

```javascript
// Un solo item de un nodo anterior
const dato = $('Nombre del Nodo').first().json.campo;

// Todos los items de un nodo anterior (para arrays, ej: preguntas)
const filas = $('PG: Mapa preguntas').all().map(i => i.json);

// Item actual del loop
const actual = $input.first().json;
```

### 9.2 Queries PostgreSQL con parámetros en n8n

Usar siempre la opción **"Query Parameters"** del nodo PostgreSQL en lugar de string interpolation en la query. Esto previene SQL injection y problemas con caracteres especiales:

```
Query:              SELECT * FROM tabla WHERE campo = $1 AND otro = $2
Query Parameters:   ={{ [$json.valor1, $json.valor2].join(',') }}
```

Para UUIDs: añadir `::uuid` en la query: `WHERE id = $1::uuid`

### 9.3 Patrón SplitInBatches con "done"

```
SplitInBatches
  ├── Output 0 (loop) → nodos de procesamiento → ... → (vuelve implícitamente a SplitInBatches)
  └── Output 1 (done) → lo que pasa después del loop
```

El output 0 NO necesita conectarse de vuelta al SplitInBatches. n8n lo gestiona internamente.

### 9.4 Mutations GraphQL en monday

```javascript
// Template para mutation de monday en HTTP Request
// URL: https://api.monday.com/v2
// Headers: Authorization: APIKEY
// Body (JSON):
{
  "query": "mutation UpdateItem($boardId: ID!, $itemId: ID!, $colVals: JSON!) { change_multiple_column_values(board_id: $boardId, item_id: $itemId, column_values: $colVals) { id } }",
  "variables": {
    "boardId": "BOARD_ID",
    "itemId": "={{ $json.monday_item_id }}",
    "colVals": "={{ JSON.stringify({ status_wa: { label: 'ENVIADA' }, num_enviados: { number: $json.total } }) }}"
  }
}
```

### 9.5 staticData para persistencia entre ejecuciones

```javascript
// Leer
const sd = $getWorkflowStaticData('global');
const ultimo = sd.ultimo_timestamp || 'valor_por_defecto';

// Escribir (persiste entre ejecuciones del mismo workflow)
sd.ultimo_timestamp = new Date().toISOString();
```

---

## 10. Errores comunes y soluciones

| Error | Causa probable | Solución |
|---|---|---|
| `flow_token_not_found` en WF-02 | El `id_envio` pasado como `flow_token` no existe en `encuestas_envios` | Verificar que WF-01 insertó el envío correctamente antes de enviar el mensaje |
| PG: `null value in column "id_encuesta_maestro"` | `PG: Maestro lookup` devuelve 0 filas | El `smk_survey_id` en el JSON del maestro no coincide con el survey_id de SMK |
| PG: `duplicate key value violates unique constraint` en respuestas | Meta reenvió el mismo `nfm_reply` | Normal — el `ON CONFLICT DO NOTHING` lo absorbe sin error |
| `ON CONFLICT DO UPDATE` no devuelve nada en upsert ejecucion | `id_externo_collector` tiene UNIQUE INDEX pero la columna es nullable con múltiples NULLs | Verificar que `id_externo_collector` no sea NULL; si el survey no tiene collector, usar `survey_id` como fallback |
| WF-01 se dispara en bucle | `checkbox_lock` no se activa a tiempo | Verificar que el webhook de monday incluye la condición `checkbox_lock = false` |
| `X-Hub-Signature-256 inválida` | `WA_APP_SECRET` no está configurado en el entorno de n8n | Añadir `N8N_CUSTOM_ENV_WA_APP_SECRET` al `.env` de n8n y reiniciar |
| monday mutation falla con `403` | Token de API expirado o sin permisos | Regenerar API key en monday y actualizar credencial en n8n |
| `PG: Mapa preguntas` devuelve 0 filas | No se ejecutó `generar_version_ponderaciones()` | Ejecutar `SELECT maestro.generar_version_ponderaciones('ID_ENCUESTA')` en psql |
| Respuestas con `valor_numerico = null` en preguntas no-COMENTARIO | `id_externo_opcion` en maestro no coincide con `choice_id` de SMK | Verificar sincronización opciones maestro vs SMK API (ver §10 del mapeo SMK) |
| Timeout en HTTP: SMK Bulk responses | Demasiadas responses en el rango de tiempo | Reducir `minutesInterval` del scheduler para procesar en ventanas más pequeñas |

---

## Referencias rápidas

| Documento | Contenido |
|---|---|
| `plan-tecnico-wa-v7.0.md` | Arquitectura completa, DDL, fases de implementación, riesgos |
| `encuestas-schema.sql` | SQL completo para crear schemas maestro y encuestas |
| `mapeo-flows-wa-maestro-encuestas.md` | Mapeo campo a campo WA Flow → BD |
| `mapeo-surveymonkey-maestro-encuestas.md` | Mapeo campo a campo SMK API → BD |
| `WF-SMK-INGEST-RESPUESTAS.json` | Workflow importable para SurveyMonkey |
