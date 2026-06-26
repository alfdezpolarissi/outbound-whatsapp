# Mapeo de datos: SurveyMonkey API ↔ maestro ↔ encuestas

**Proyecto:** Encuestas y Notificaciones — Grupo Vemare  
**Versión:** 1.0 · Junio 2026  
**Canal:** SURVEYMONKEY · Orígenes: EMAIL, QR, FÍSICAS, WEB

---

## 1. Diferencias fundamentales respecto al canal WA

| Aspecto | WhatsApp (WF-01/02) | SurveyMonkey |
|---|---|---|
| Quién envía | n8n controla el envío | SurveyMonkey gestiona la distribución |
| `encuestas_envios` | Se crea **antes** de enviar | Se crea **al recibir** la respuesta |
| `id_grupo_respuesta` | `id_envio` (preexiste) | `id_envio` generado al ingestar |
| Identidad del respondente | `flow_token` → `encuestas_envios` | `custom_variables.cod` + `custom_variables.dis` |
| Trigger de ingesta | Webhook Meta (push) | Polling SurveyMonkey API o webhook SMK (pull/push) |
| `id_externo_collector` | `monday_item_id` | `collector_id` de SurveyMonkey |
| `valor_numerico` | Resuelto via `opciones_maestro` | Disponible directamente en `choice_metadata.weight` (backup: lookup maestro) |

---

## 2. Visión general del flujo de datos

```
CONFIGURACIÓN (una vez por encuesta)
──────────────────────────────────────────────────────────────────────────────
SurveyMonkey /surveys/{id}/details
  └─ survey.id            ────────────► maestro.encuestas_maestro.id_externo_encuesta
                                         JSONB: {"smk_survey_id": "527096856"}
  └─ question.id          ────────────► maestro.preguntas_maestro.id_externo_pregunta
  └─ choice.id            ────────────► maestro.opciones_maestro.id_externo_opcion
  └─ choice.weight        ────────────► maestro.opciones_maestro.valor_numerico


INGESTA DE RESPUESTAS (polling o webhook)
──────────────────────────────────────────────────────────────────────────────
SurveyMonkey /surveys/{id}/responses/{id}/details
  └─ collector_id         ────────────► encuestas.ejecuciones_encuesta (lookup/create)
  └─ custom_variables.cod ────────────► encuestas.encuestas_envios.codigo_isi
  └─ custom_variables.dis ────────────► encuestas.encuestas_envios.nombre_empresa
  └─ custom_variables.email ──────────► encuestas.encuestas_envios.email
  └─ id (response_id)     ────────────► atributos_adicionales
  └─ pages[].questions[].id ──────────► maestro.preguntas_maestro.id_externo_pregunta
  └─ answers[].choice_id  ────────────► maestro.opciones_maestro.id_externo_opcion
  └─ answers[].choice_metadata.weight ► valor_numerico (directo, sin lookup extra)
                                  │
                                  ▼
                         encuestas.respuestas (1 fila por pregunta)
```

---

## 3. Estructura real de la API SurveyMonkey

### 3.1 Survey details — campos relevantes

Basado en la encuesta `527096856` (Movistar Arena):

```
survey.id              = "527096856"         → id_externo_encuesta JSONB
survey.title           = "Movistar Arena"
survey.custom_variables = {
  "cod": "codigoCliente",   → parámetro URL que transporta codigo_isi del respondente
  "email": "email",          → parámetro URL con email
  "dis": "distribuidor"      → parámetro URL con nombre_empresa (VEMARE, TRANSCOSE…)
}

pages[].questions[]  →  solo las de family ≠ "presentation"
  question.id          = "285739945"         → id_externo_pregunta en maestro
  question.family      = "matrix"            → tipo de pregunta
  question.subtype     = "rating"            → CSAT / CES
  question.headings[0].heading = "¿Cómo valora…" → texto_pregunta en maestro

  answers.choices[]
    choice.id          = "1998675999"        → id_externo_opcion en maestro
    choice.text        = "Muy insatisfecho"  → texto_opcion en maestro
    choice.weight      = 1                   → valor_numerico en maestro
```

**Tipos de pregunta y métrica asignada:**

| `family` | `subtype` | Métrica | Ignorar |
|---|---|---|---|
| `presentation` | `image` | — | **Sí** — son bloques imagen, no preguntas |
| `matrix` | `rating` | CSAT / CES | No |
| `open_ended` | `essay` | COMENTARIO | No |
| `single_choice` / `multiple_choice` | — | CSAT / NPS | No |
| `rating` | `star` | CSAT | No |

### 3.2 Response details — campos relevantes

Basado en la respuesta `119102885822`:

```
response.id             = "119102885822"     → atributos_adicionales.smk_response_id
response.collector_id   = "464375331"        → lookup ejecuciones_encuesta por id_externo_collector
response.survey_id      = "527096856"        → cruzar con maestro por id_externo_encuesta
response.custom_variables = {
  "cod": "12345",       → codigo_isi del respondente (vacío = respuesta anónima)
  "email": "x@x.com",  → email
  "dis": "VEMARE"       → nombre_empresa
}
response.date_created   = "2026-04-20T13:59:19+00:00"  → fecha_respuesta

pages[].questions[].id              = "285739945"    → question_id para cruzar con maestro
pages[].questions[].answers[].choice_id = "1998675999" → choice_id para lookup opciones
pages[].questions[].answers[].choice_metadata.weight = "1" → valor_numerico directo (STRING → NUMERIC)
```

> `custom_variables` aparece vacío `{}` en respuestas anónimas (link no personalizado). En producción con links personalizados por contacto, llega relleno. Ver §6 para manejo de respuestas anónimas.

---

## 4. Configuración inicial: SMK → maestro

Este proceso se ejecuta **una sola vez** al dar de alta una encuesta nueva en el sistema, y se repite si cambia la estructura de la encuesta en SurveyMonkey.

### 4.1 Registrar la encuesta en maestro.encuestas_maestro

```sql
-- El id_externo_encuesta guarda el survey_id de SMK en el JSONB
INSERT INTO maestro.encuestas_maestro
  (id_encuesta, fase_experiencia, tipo_interaccion, interaccion_activa, id_externo_encuesta)
VALUES
  ('MOVISTAR_ARENA_CSAT', 'EVENTOS', 'MOVISTAR_ARENA', true,
   '{"smk_survey_id": "527096856"}')
ON CONFLICT (id_encuesta) DO UPDATE
  SET id_externo_encuesta = EXCLUDED.id_externo_encuesta;
```

**Lookup inverso** (de survey_id a id_encuesta):
```sql
SELECT id_encuesta
FROM maestro.encuestas_maestro
WHERE id_externo_encuesta->>'smk_survey_id' = '527096856'
  AND interaccion_activa = true;
```

### 4.2 Registrar preguntas en maestro.preguntas_maestro

Ignorar preguntas con `family = 'presentation'`. Solo las preguntas con respuestas reales:

Del JSON real:
| question.id | heading | family/subtype | Métrica | orden |
|---|---|---|---|---|
| `285739943` | (imagen) | presentation/image | **IGNORAR** | — |
| `285739945` | ¿Cómo valora la iniciativa…? | matrix/rating | CSAT | 1 |
| `285739944` | (imagen) | presentation/image | **IGNORAR** | — |
| `285739947` | ¿Cómo valora la comunicación previa…? | matrix/rating | CSAT | 2 |
| `286656693` | (imagen) | presentation/image | **IGNORAR** | — |
| `285739948` | ¿Cómo valora la atención recibida…? | matrix/rating | CSAT | 3 |
| `286656745` | (imagen) | presentation/image | **IGNORAR** | — |
| `285739950` | ¿Tiene alguna observación? | open_ended/essay | COMENTARIO | 4 |

```sql
INSERT INTO maestro.preguntas_maestro
  (id_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, id_externo_pregunta)
VALUES
  ('MOVISTAR_ARENA_Q1', 'MOVISTAR_ARENA_CSAT', 'CSAT', 1,
   '¿Cómo valora la iniciativa de compartir tiempo fuera de su negocio con nosotros?',
   '285739945'),
  ('MOVISTAR_ARENA_Q2', 'MOVISTAR_ARENA_CSAT', 'CSAT', 2,
   '¿Cómo valora la comunicación previa al evento?',
   '285739947'),
  ('MOVISTAR_ARENA_Q3', 'MOVISTAR_ARENA_CSAT', 'CSAT', 3,
   '¿Cómo valora la atención recibida por parte del personal de Grupo Vemare?',
   '285739948'),
  ('MOVISTAR_ARENA_Q4', 'MOVISTAR_ARENA_CSAT', 'COMENTARIO', 4,
   '¿Tiene alguna observación?',
   '285739950')
ON CONFLICT (id_pregunta) DO NOTHING;
```

### 4.3 Registrar opciones en maestro.opciones_maestro

Las opciones vienen de los `choices` de las preguntas. `choice.weight` = `valor_numerico`.  
Las preguntas COMENTARIO (`open_ended`) no tienen choices — no generan filas en opciones_maestro.

```sql
-- Para la pregunta 285739945 (MOVISTAR_ARENA_Q1)
INSERT INTO maestro.opciones_maestro
  (id_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
VALUES
  ('MA_Q1_OPC1', 'MOVISTAR_ARENA_Q1', 'Muy insatisfecho', 1, '1998675999'),
  ('MA_Q1_OPC2', 'MOVISTAR_ARENA_Q1', 'Insatisfecho',     2, '1998676000'),
  ('MA_Q1_OPC3', 'MOVISTAR_ARENA_Q1', 'Neutral',          3, '1998676001'),
  ('MA_Q1_OPC4', 'MOVISTAR_ARENA_Q1', 'Satisfecho',       4, '1998676002'),
  ('MA_Q1_OPC5', 'MOVISTAR_ARENA_Q1', 'Muy satisfecho',   5, '1998676003')
ON CONFLICT (id_pregunta, id_externo_opcion) DO NOTHING;

-- Repetir para Q2 (285739947) y Q3 (285739948) con sus choice.ids respectivos
-- Q4 (285739950) es COMENTARIO — sin opciones
```

### 4.4 Configurar pesos y generar versión

```sql
-- Configurar peso global de Marketing para CSAT en esta encuesta
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
VALUES
  ('MOVISTAR_ARENA_CSAT', 'CSAT',       0.0500),  -- 5% (ejemplo)
  ('MOVISTAR_ARENA_CSAT', 'COMENTARIO', 0.0000)   -- 0% (texto libre, no puntúa)
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;

-- Generar versión congelada de ponderaciones
SELECT maestro.generar_version_ponderaciones('MOVISTAR_ARENA_CSAT');
-- Devuelve 'v1.0'
-- Calcula: peso_interno = 1/3 por pregunta CSAT (hay 3 preguntas CSAT)
-- peso_final = (1/3) × 0.05 = 0.016667 por pregunta CSAT
-- peso_final = 0 para COMENTARIO
```

---

## 5. Ingesta de respuestas: SMK Response → encuestas

### 5.1 Resolución de ejecución (collector_id → ejecuciones_encuesta)

```sql
-- Buscar ejecución existente por collector_id
SELECT id_ejecucion, id_encuesta_maestro, version_num
FROM encuestas.ejecuciones_encuesta
WHERE id_externo_collector = '464375331'  -- collector_id de la response
  AND canal = 'SURVEYMONKEY';
```

Si no existe → crearla:

```sql
-- Primero resolver id_encuesta_maestro desde survey_id
SELECT id_encuesta
FROM maestro.encuestas_maestro
WHERE id_externo_encuesta->>'smk_survey_id' = '527096856';
-- → 'MOVISTAR_ARENA_CSAT'

-- Resolver version_num activa
SELECT version_num
FROM maestro.encuestas_versiones
WHERE id_encuesta = 'MOVISTAR_ARENA_CSAT' AND version_activa = true;

-- Crear ejecución
INSERT INTO encuestas.ejecuciones_encuesta
  (id_encuesta_maestro, canal, origen, id_externo_collector,
   titulo_ejecucion, es_prueba, version_num, estado)
VALUES
  ('MOVISTAR_ARENA_CSAT', 'SURVEYMONKEY', 'EMAIL',
   '464375331',                         -- collector_id SMK
   '18/04 Festival Electrolatino',       -- collector.name de la API
   false,
   1,                                   -- version_num activa
   'ACTIVA')
RETURNING id_ejecucion;
```

**Mapeo `origen` desde tipo de collector:**

| `collector.type` (API SMK) | `origen` en encuestas |
|---|---|
| `email` | `'EMAIL'` |
| `weblink` (con QR) | `'QR'` |
| `weblink` (link web) | `'WEB'` |
| `ios` / `android` | `'APP'` |
| `offline` / `paper` | `'FISICO'` |

### 5.2 Resolución de identidad del respondente

```
response.custom_variables = {
  "cod": "12345",    → codigo_isi
  "dis": "VEMARE",   → nombre_empresa
  "email": "x@x.com" → email
}
```

**Si `custom_variables` tiene valor:**
```sql
-- Verificar que el contacto existe en la base de datos
SELECT codigo_isi, nombre AS nombre_empresa, email, telefono_wa
FROM public.contactos
WHERE codigo_isi = :cod
  AND (razon_social = :dis OR nombre_empresa = :dis);
```

**Si `custom_variables` está vacío `{}` (respuesta anónima o link sin personalizar):**
- `codigo_isi = NULL`, `nombre_empresa = NULL`
- Se registra la respuesta con identidad parcial
- `atributos_adicionales` guarda el contexto disponible (IP, user_agent, etc.)

### 5.3 Upsert de encuestas_envios

A diferencia de WA, el `encuestas_envios` se crea al recibir la respuesta, no antes.

```sql
INSERT INTO encuestas.encuestas_envios
  (id_ejecucion, codigo_isi, nombre_empresa, email,
   estado_entrega, estado_envio)
VALUES
  (:id_ejecucion, :codigo_isi, :nombre_empresa, :email,
   'ENTREGADO',   -- SurveyMonkey ya confirmó que se completó
   'ENVIADO')
ON CONFLICT (id_ejecucion, codigo_isi, nombre_empresa) DO UPDATE
  SET estado_entrega = 'ENTREGADO'
RETURNING id_envio;
-- id_envio → será el id_grupo_respuesta para todas las respuestas de esta sesión
```

> Para respuestas anónimas (`codigo_isi = NULL`): usar el UNIQUE `(id_ejecucion, telefono_wa)` si hay teléfono, o generar un UUID como key temporal guardado en `atributos_adicionales`.

---

## 6. Procesamiento de respuestas: SMK answers → encuestas.respuestas

### 6.1 Cargar mapa de preguntas + pesos (igual que WA — una sola query)

```sql
SELECT
  p.id_pregunta,
  p.id_metrica,
  p.id_externo_pregunta,   -- question_id de SurveyMonkey
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

### 6.2 Cargar mapa de opciones

```sql
SELECT
  o.id_pregunta,
  o.id_externo_opcion,    -- choice_id de SurveyMonkey
  o.valor_numerico,
  o.id_opcion
FROM maestro.opciones_maestro o
JOIN maestro.preguntas_maestro p ON p.id_pregunta = o.id_pregunta
WHERE p.id_encuesta = :id_encuesta_maestro
  AND p.pregunta_activa = true;
```

### 6.3 Code Node n8n: SMK response → array de filas

```javascript
// preguntasMap: Map<id_externo_pregunta, { id_pregunta, id_metrica, peso_final_calculado }>
// opcionesMap:  Map<id_externo_opcion, { valor_numerico, id_opcion, id_pregunta }>
// smkResponse:  el objeto pages[] de la response de SMK

const filas = [];

for (const page of smkResponse.pages) {
  for (const preguntaSmk of page.questions) {
    const preguntaMaestro = preguntasMap.get(preguntaSmk.id);

    // Ignorar si no está en el diccionario (preguntas presentation ya filtradas en config)
    if (!preguntaMaestro) continue;

    const esComentario = preguntaMaestro.id_metrica === 'COMENTARIO';
    let valor_numerico        = null;
    let valor_calculado       = null;
    let respuesta_comentario  = null;
    let smk_choice_id         = null;

    if (esComentario) {
      // open_ended: la respuesta está en answers[0].text
      respuesta_comentario = preguntaSmk.answers?.[0]?.text ?? null;

    } else {
      // matrix/rating: la respuesta está en answers[0].choice_id
      const answer = preguntaSmk.answers?.[0];
      if (answer) {
        smk_choice_id = answer.choice_id;

        // Opción 1: valor directo desde choice_metadata.weight (más rápido)
        const weightStr = answer.choice_metadata?.weight;
        valor_numerico = weightStr !== undefined ? parseFloat(weightStr) : null;

        // Opción 2 (backup): lookup en opciones_maestro por choice_id
        if (valor_numerico === null) {
          const opcion = opcionesMap.get(smk_choice_id);
          valor_numerico = opcion?.valor_numerico ?? null;
        }

        valor_calculado = (valor_numerico !== null && preguntaMaestro.peso_final_calculado > 0)
          ? valor_numerico * preguntaMaestro.peso_final_calculado
          : null;
      }
    }

    filas.push({
      id_ejecucion:         id_ejecucion,
      id_envio:             id_envio,              // del INSERT de encuestas_envios
      id_encuesta_maestro:  id_encuesta_maestro,
      version_num:          version_num,
      id_pregunta_maestro:  preguntaMaestro.id_pregunta,
      id_grupo_respuesta:   id_envio,              // = id_envio (mismo patrón que WA)
      codigo_isi:           codigo_isi,
      nombre_empresa:       nombre_empresa,
      canal:                'SURVEYMONKEY',
      origen:               origen,                // EMAIL / QR / WEB / FISICO
      id_metrica:           preguntaMaestro.id_metrica,
      peso_final_calculado: preguntaMaestro.peso_final_calculado,
      valor_numerico,
      valor_calculado,
      respuesta_comentario,
      atributos_adicionales: JSON.stringify({
        smk_response_id:  smkResponseId,          // response.id de SMK
        smk_question_id:  preguntaSmk.id,
        smk_choice_id:    smk_choice_id,
        smk_collector_id: smkCollectorId
      })
    });
  }
}

return filas; // Un item por pregunta → SplitInBatches → INSERT
```

### 6.4 INSERT en encuestas.respuestas

Idéntico al canal WA. La clave de deduplicación `(id_grupo_respuesta, id_pregunta_maestro)` protege contra reprocesados:

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
  :codigo_isi, :nombre_empresa, 'SURVEYMONKEY', :origen,
  :id_metrica, :peso_final_calculado,
  :valor_numerico, :valor_calculado, :respuesta_comentario,
  :atributos_adicionales::jsonb
)
ON CONFLICT (id_grupo_respuesta, id_pregunta_maestro) DO NOTHING;
```

---

## 7. Mapeo completo campo a campo

### 7.1 SMK Survey → maestro

| Campo SMK (`/surveys/{id}/details`) | Transformación | Destino en maestro |
|---|---|---|
| `survey.id` | Guardar como `{"smk_survey_id": "..."}` | `encuestas_maestro.id_externo_encuesta` (JSONB) |
| `survey.title` | Texto descriptivo | `encuestas_maestro.tipo_interaccion` (manual) |
| `question.id` (family ≠ presentation) | Sin transformar | `preguntas_maestro.id_externo_pregunta` |
| `question.headings[0].heading` | Limpiar HTML si procede | `preguntas_maestro.texto_pregunta` |
| `question.family = 'matrix'` + `subtype = 'rating'` | → métrica CSAT o CES (decisión de Marketing) | `preguntas_maestro.id_metrica` |
| `question.family = 'open_ended'` | → métrica COMENTARIO | `preguntas_maestro.id_metrica` |
| `choice.id` | Sin transformar | `opciones_maestro.id_externo_opcion` |
| `choice.text` | Sin transformar | `opciones_maestro.texto_opcion` |
| `choice.weight` | CAST a NUMERIC | `opciones_maestro.valor_numerico` |

### 7.2 SMK Collector → encuestas.ejecuciones_encuesta

| Campo SMK (`/collectors/{id}`) | Transformación | Destino |
|---|---|---|
| `collector.id` | Sin transformar | `id_externo_collector` |
| `collector.name` | Sin transformar | `titulo_ejecucion` |
| `collector.type` | Ver tabla §5.1 | `origen` |
| `collector.survey_id` | Lookup `maestro.encuestas_maestro` por `smk_survey_id` | `id_encuesta_maestro` |
| — | Fijo: `'SURVEYMONKEY'` | `canal` |
| — | `version_activa = true` en maestro | `version_num` |
| — | Fijo: `false` (salvo indicación) | `es_prueba` |

### 7.3 SMK Response → encuestas.encuestas_envios

| Campo SMK (`/responses/{id}/details`) | Transformación | Destino |
|---|---|---|
| `response.custom_variables.cod` | Buscar en `public.contactos.codigo_isi` | `codigo_isi` |
| `response.custom_variables.dis` | Buscar en `public.contactos.razon_social` | `nombre_empresa` |
| `response.custom_variables.email` | Sin transformar | `email` |
| — | Fijo: `'ENTREGADO'` | `estado_entrega` |
| — | Fijo: `'ENVIADO'` | `estado_envio` |
| `response.id` | Guardar en `atributos_adicionales` | — |

### 7.4 SMK Response answers → encuestas.respuestas

| Campo SMK | Transformación | Destino |
|---|---|---|
| `pages[].questions[].id` | Lookup `preguntas_maestro.id_externo_pregunta` | `id_pregunta_maestro` |
| `answers[].choice_id` | Lookup `opciones_maestro.id_externo_opcion` (o weight directo) | `id_metrica`, `valor_numerico` |
| `answers[].choice_metadata.weight` | `parseFloat()` — fuente primaria de `valor_numerico` | `valor_numerico` |
| `answers[].text` | Solo para preguntas `open_ended` | `respuesta_comentario` |
| `valor_numerico × peso_final_calculado` | Calculado en n8n; 0 si COMENTARIO | `valor_calculado` |
| `id_envio` (del RETURNING) | Reutilizar como agrupador | `id_grupo_respuesta` |
| `response.id`, `question.id`, `choice.id`, `collector.id` | JSON | `atributos_adicionales` |

---

## 8. Ejemplo concreto con los datos reales

Respuesta `119102885822` del collector `464375331` (Movistar Arena):

**Paso 1 — Lookup ejecución:**
```
collector_id = "464375331"
→ ejecuciones_encuesta WHERE id_externo_collector = '464375331'
→ id_ejecucion = <UUID>, id_encuesta_maestro = 'MOVISTAR_ARENA_CSAT', version_num = 1
```

**Paso 2 — Identidad:**
```
custom_variables = {} (respuesta anónima en este caso)
→ codigo_isi = NULL, nombre_empresa = NULL
```

**Paso 3 — Upsert encuestas_envios:**
```
→ id_envio = <nuevo UUID> (usado como id_grupo_respuesta)
```

**Paso 4 — Procesar preguntas** (ignorando preguntas de imagen):

| page | question.id | answers[0].choice_id | weight | texto_opcion | valor_numerico | peso_final | valor_calculado |
|---|---|---|---|---|---|---|---|
| 75065487 | `285739945` | `1998675999` | `"1"` | Muy insatisfecho | 1 | 0.016667 | 0.016667 |
| 75065488 | `285739947` | `1998676012` | `"5"` | Muy satisfecho | 5 | 0.016667 | 0.083333 |
| 75065489 | `285739948` | `1998676018` | `"5"` | Muy satisfecho | 5 | 0.016667 | 0.083333 |
| 75065490 | `285739950` | — (vacío) | — | — | NULL | 0 | NULL |

**Paso 5 — INSERT respuestas:** 3 filas insertadas (la pregunta de comentario con `respuesta_comentario = NULL` porque el respondente no escribió nada).

---

## 9. Queries n8n ordenadas por workflow

### Workflow SurveyMonkey (polling o webhook)

1. **Obtener nuevas responses:** `GET /v3/surveys/{survey_id}/responses/bulk?start_modified_at={ultima_ejecucion}`
2. **Resolver ejecución:** `SELECT ... FROM encuestas.ejecuciones_encuesta WHERE id_externo_collector = ?`
3. **Si no existe ejecución:** `SELECT ... FROM maestro.encuestas_maestro WHERE id_externo_encuesta->>'smk_survey_id' = ?` → INSERT ejecución
4. **Resolver identidad:** lookup en `public.contactos WHERE codigo_isi = custom_variables.cod`
5. **Upsert envío:** `INSERT INTO encuestas.encuestas_envios ... ON CONFLICT DO UPDATE RETURNING id_envio`
6. **Cargar mapa preguntas+pesos:** query §6.1
7. **Cargar mapa opciones:** query §6.2
8. **Code Node:** construir array de filas (§6.3)
9. **INSERT respuestas:** `INSERT INTO encuestas.respuestas ... ON CONFLICT DO NOTHING` (§6.4)
10. **Marcar como procesada:** guardar `response.date_modified` para próximo polling

---

## 10. Diferencias en atributos_adicionales por canal

| Campo | WhatsApp | SurveyMonkey |
|---|---|---|
| Identificador externo de sesión | `flow_token` (= id_envio) | `smk_response_id` |
| Identificador externo de pregunta | `component_id` | `smk_question_id` |
| Identificador externo de opción | `option_id` (WA) | `smk_choice_id` |
| Identificador del recopilador | — | `smk_collector_id` |

En ambos canales, `atributos_adicionales` es JSONB extensible y nunca afecta la lógica analítica de Power BI, que solo lee las columnas tipadas (`valor_numerico`, `valor_calculado`, `id_metrica`, etc.).
