-- ================================================================
-- MAESTRO DATOS INICIALES v1.0 — Grupo Vemare
-- Generado desde PROYECTO_EXPERIENCIA_CLIENTE_2026_ponderaciones.xlsx
-- ================================================================
BEGIN;

-- ── 1. FASES ─────────────────────────────────────────────────────
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('DESCUBRIMIENTO', 'DESCUBRIMIENTO', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('PEDIDO_CONSULTA', 'PEDIDO CONSULTA', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('PROCESO_COMPRA', 'PROCESO DE COMPRA', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('SERVICIOS', 'SERVICIOS', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('POSTVENTA', 'POSTVENTA', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('EVENTOS', 'EVENTOS', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;
INSERT INTO maestro.fases_experiencia (codigo_fase, descripcion, activa)
VALUES ('SIEMPRE_ACTIVAS', 'SIEMPRE ACTIVAS', TRUE)
ON CONFLICT (codigo_fase) DO UPDATE SET descripcion = EXCLUDED.descripcion;

-- ── 2. TIPOS INTERACCIÓN (canales planificadores) ────────────────
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('SURVEYMONKEY', 'SurveyMonkey', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('FINESSE', 'Centralita telefónica Finesse', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('BLIP', 'WhatsApp vía BLIP', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('ENRUTA', 'Tablet conductores ENRUTA', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('AD360', 'Plataforma AD360', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('WHATSAPP_N8N', 'WhatsApp automatizado con n8n', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
INSERT INTO maestro.tipos_interaccion (codigo_tipo_interaccion, descripcion, activo)
VALUES ('BACK_OLE', 'App/Web Back Ole', TRUE)
ON CONFLICT (codigo_tipo_interaccion) DO NOTHING;
-- ── 3. ORÍGENES ───────────────────────────────────────────────────
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('EMAIL', 'Email', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('WHATSAPP', 'WhatsApp', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('QR', 'Código QR', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('TABLET', 'Tablet presencial', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('POP_UP', 'Pop-up en plataforma', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('LLAMADA', 'Llamada telefónica', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('LINK_FOOTER', 'Link en footer', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('EVENTO', 'Evento presencial', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;
INSERT INTO maestro.origenes_encuesta (codigo_origen, descripcion, activo)
VALUES ('PASIVA', 'Reseña pasiva', TRUE)
ON CONFLICT (codigo_origen) DO NOTHING;

-- ── 4. MÉTRICA COMENTARIO (complementa las del script IT) ────────
INSERT INTO maestro.lista_metricas (codigo_metrica, descripcion, valores_escala, activa)
VALUES ('COMENTARIO', 'Comentario libre / Verbatim', 'TEXTO', TRUE)
ON CONFLICT (codigo_metrica) DO NOTHING;

-- ── 5. ENCUESTAS MAESTRO ─────────────────────────────────────────
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'APERTURA_DE_CLIENTE', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'DESCUBRIMIENTO'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- APERTURA DE CLIENTE
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'SEGUIMIENTO_APERTURA', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'DESCUBRIMIENTO'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- SEGUIMIENTO APERTURA
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'VISITA_COMERCIAL', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'DESCUBRIMIENTO'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- VISITA COMERCIAL
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'LLAMADA', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PEDIDO_CONSULTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- LLAMADA
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'WHATS_APP', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PEDIDO_CONSULTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- WHATS APP
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'ENTREGAS', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PROCESO_COMPRA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- ENTREGAS
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'REPARTOS_ENTREGAS', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PROCESO_COMPRA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- REPARTOS / ENTREGAS
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'COMPRA_WHATSAPP', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PROCESO_COMPRA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- COMPRA WHATSAPP
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'COMPRA_TELFONO', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PROCESO_COMPRA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- COMPRA TELÉFONO
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'AD360', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PROCESO_COMPRA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- AD360
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'AD360', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'PROCESO_COMPRA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- AD360
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'SERVICIOS_MILLENNIUM', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'SERVICIOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- SERVICIOS MILLENNIUM
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'WEB_APP', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'SERVICIOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- WEB / APP
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'FORMACIN', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'SERVICIOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- FORMACIÓN
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'GARANTAS', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'POSTVENTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- GARANTÍAS
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'DEVOLUCIONES', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'POSTVENTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- DEVOLUCIONES
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'FACTURACIN', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'POSTVENTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- FACTURACIÓN
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'SAT_EQUIPAMIENTO', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'POSTVENTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- S.A.T. EQUIPAMIENTO
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'REPARACIN', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'POSTVENTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- REPARACIÓN
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'SAT_SERVICIOS_DIGITALES', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'POSTVENTA'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- S.A.T. SERVICIOS DIGITALES
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'CN_MILLENIUM', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- CN MILLENIUM
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'MADRING_F1', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- MADRING F1
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'CN_PARTNER', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- CN PARTNER
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'CN_CLUB', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- CN CLUB
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'BERNABEU', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- BERNABEU
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'ENCUENTROS_CLIENTES', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- ENCUENTROS CLIENTES
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'ENCUENTROS_TALLERES_AD_PRE', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- ENCUENTROS TALLERES AD/PRE
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'CN_ESC', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- CN ESC
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'MOVISTAR_ARENA', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'EVENTOS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- MOVISTAR ARENA
INSERT INTO maestro.encuestas_maestro (codigo_encuesta, id_fase_experiencia, interaccion_activa)
SELECT 'FOOTER_COMUNICACIONES', id_fase_experiencia, TRUE
FROM maestro.fases_experiencia WHERE codigo_fase = 'SIEMPRE_ACTIVAS'
ON CONFLICT (codigo_encuesta) DO NOTHING;  -- FOOTER COMUNICACIONES
-- ── 6. ENCUESTAS_METRICAS_CONFIG ─────────────────────────────────
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0600
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.1500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0600
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.1500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0600
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENTREGAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0600
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.1500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0600
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.1500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0600
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.1500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.1000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FORMACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FORMACIN' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.2000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0400
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.2000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FACTURACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.2000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0400
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0400
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.2000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'CES'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0400
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_MILLENIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_MILLENIUM' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MADRING_F1' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MADRING_F1' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_PARTNER' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_PARTNER' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_CLUB' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_CLUB' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'BERNABEU' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'BERNABEU' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0300
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0200
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0500
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES' AND m.codigo_metrica = 'NPS'
ON CONFLICT (id_encuesta, id_metrica) DO UPDATE SET peso_global_marketing = EXCLUDED.peso_global_marketing;
INSERT INTO maestro.encuestas_metricas_config (id_encuesta, id_metrica, peso_global_marketing)
SELECT e.id_encuesta, m.id_metrica, 0.0000
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (id_encuesta, id_metrica) DO NOTHING;

-- ── 7. PREGUNTAS MAESTRO ─────────────────────────────────────────
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'APERTURA_DE_CLIENTE_P01', e.id_encuesta, m.id_metrica, 1, '¿Qué tan fácil le ha resultado abrir una cuenta con nosotros?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'APERTURA_DE_CLIENTE_P02', e.id_encuesta, m.id_metrica, 2, '¿Qué tan clara le resultó la información sobre los requisitos, documentación y pasos necesarios para abrir la cuenta?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'APERTURA_DE_CLIENTE_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valoraría la rapidez con la que se gestionó la apertura de su cuenta?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SEGUIMIENTO_APERTURA_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valorarías tu experiencia con nuestro servicio de reparto en cuanto a puntualidad, cuidado de la entrega y profesionalidad del repartidor?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SEGUIMIENTO_APERTURA_P02', e.id_encuesta, m.id_metrica, 2, '¿Qué tan satisfecho estás con la rapidez, claridad y eficacia en la gestión y seguimiento de tus pedidos?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SEGUIMIENTO_APERTURA_P03', e.id_encuesta, m.id_metrica, 3, '¿Consideras que ofrecemos precios competitivos y suficientes alternativas de marcas para elegir según tus necesidades?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SEGUIMIENTO_APERTURA_P04', e.id_encuesta, m.id_metrica, 4, '¿Con qué frecuencia encuentras disponibles los productos que necesitas y cómo valoras la información sobre stock y alternativas?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'VISITA_COMERCIAL_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valorarías tu experiencia con nuestro servicio de reparto en cuanto a puntualidad, cuidado de la entrega y profesionalidad del repartidor?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'VISITA_COMERCIAL_P02', e.id_encuesta, m.id_metrica, 2, '¿Qué tan satisfecho estás con la rapidez, claridad y eficacia en la gestión y seguimiento de tus pedidos?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'VISITA_COMERCIAL_P03', e.id_encuesta, m.id_metrica, 3, '¿Consideras que ofrecemos precios competitivos y suficientes alternativas de marcas para elegir según tus necesidades?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'VISITA_COMERCIAL_P04', e.id_encuesta, m.id_metrica, 4, '¿Con qué frecuencia encuentras disponibles los productos que necesitas y cómo valoras la información sobre stock y alternativas?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'VISITA_COMERCIAL_P05', e.id_encuesta, m.id_metrica, 5, 'En una escala del 0 al 10, ¿qué probabilidad hay de que recomiendes Vemare a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'LLAMADA_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valorarías el tiempo de espera hasta que te atendieron?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'LLAMADA_P02', e.id_encuesta, m.id_metrica, 2, '¿Qué tan satisfecho estás con la claridad, profesionalidad y eficacia del equipo que te atendió?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'LLAMADA_P03', e.id_encuesta, m.id_metrica, 3, '¿Consideras que dispones de suficientes opciones de precio y marcas para elegir la que mejor se adapta a tus necesidades?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'LLAMADA_P04', e.id_encuesta, m.id_metrica, 4, '¿Con qué frecuencia encuentras disponible el producto que necesitas, y cómo valoras la gestión cuando no hay stock?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'LLAMADA_P05', e.id_encuesta, m.id_metrica, 5, 'En una escala del 0 al 10, ¿qué probabilidad hay de que recomiendes Vemare a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'LLAMADA' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WHATS_APP_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valorarías el tiempo de espera hasta que te atendieron?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WHATS_APP_P02', e.id_encuesta, m.id_metrica, 2, '¿Qué tan satisfecho estás con la claridad, profesionalidad y eficacia del equipo que te atendió?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WHATS_APP_P03', e.id_encuesta, m.id_metrica, 3, '¿Consideras que dispones de suficientes opciones de precio y marcas para elegir la que mejor se adapta a tus necesidades?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WHATS_APP_P04', e.id_encuesta, m.id_metrica, 4, '¿Con qué frecuencia encuentras disponible el producto que necesitas, y cómo valoras la gestión cuando no hay stock?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WHATS_APP_P05', e.id_encuesta, m.id_metrica, 5, 'En una escala del 0 al 10, ¿qué probabilidad hay de que recomiendes Vemare a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WHATS_APP' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENTREGAS_P01', e.id_encuesta, m.id_metrica, 1, '¿Quieres valorar la entrega? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENTREGAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARTOS_ENTREGAS_P01', e.id_encuesta, m.id_metrica, 1, '¿El número de repartos que realizamos al día/semanalmente se ajusta a las necesidades de tu taller?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARTOS_ENTREGAS_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valorarías el tiempo que transcurre desde que realizas el pedido hasta que recibes la entrega?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARTOS_ENTREGAS_P03', e.id_encuesta, m.id_metrica, 3, '¿Qué tan eficiente consideras nuestro servicio de urgencias cuando necesitas un envío rápido o prioritario?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARTOS_ENTREGAS_P04', e.id_encuesta, m.id_metrica, 4, 'En una escala del 0 al 10, ¿qué probabilidad hay de que recomiendes nuestro servicio de reparto a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_WHATSAPP_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valoras el tiempo de espera desde que realizas tu pedido hasta que te recibes la contestación? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_WHATSAPP_P02', e.id_encuesta, m.id_metrica, 2, '¿La información que recibes sobre productos, disponibilidad y entregas es clara, fiable y suficiente para tomar decisiones? Nada adecuada, poco adecuada, aceptable, adecuada, muy adecuada.', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_WHATSAPP_P03', e.id_encuesta, m.id_metrica, 3, '¿Consideras que ofrecemos suficientes alternativas de precios y marcas para elegir la opción que mejor se ajusta a tus necesidades? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy Satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_WHATSAPP_P04', e.id_encuesta, m.id_metrica, 4, '¿Con qué frecuencia encuentras disponible el producto que necesitas o se te ofrecen alternativas adecuadas cuando no hay stock?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_WHATSAPP_P05', e.id_encuesta, m.id_metrica, 5, '¿Cómo valorarías el precio final que pagas en relación con el valor percibido del producto y del servicio que recibes? Muy mal, Mal, Normal, Bien, Muy bien', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_WHATSAPP_P06', e.id_encuesta, m.id_metrica, 6, 'En una escala del 0 al 10, ¿Qué probabilidad hay de que recomiendes nuestro servicio a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_TELFONO_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora el tiempo de espera desde que llama hasta que le atienden al teléfono? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_TELFONO_P02', e.id_encuesta, m.id_metrica, 2, '¿Considera que ofrecemos suficientes alternativas de precios y marcas para elegir la opción que mejor se ajusta a tus necesidades?Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_TELFONO_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo de satisfecho está con la disponibilidad de producto que necesitas? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_TELFONO_P04', e.id_encuesta, m.id_metrica, 4, '¿Le ofrecen alternativas adecuadas cuando no hay stock? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_TELFONO_P05', e.id_encuesta, m.id_metrica, 5, '¿Cómo valora el precio final que pagas en relación con el valor percibido del producto y del servicio que recibes?Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'COMPRA_TELFONO_P06', e.id_encuesta, m.id_metrica, 6, 'En una escala del 0 al 10, ¿qué probabilidad hay de que recomiendes nuestro servicio a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'COMPRA_TELFONO' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'AD360_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la disponibilidad de los productos que necesita? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'AD360_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valora la claridad de la información facilitada sobre stock? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'AD360_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la oferta de marcas disponibles? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'AD360_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo de fácil le resulta utilizar AD360 para consultar, pedir o gestionar productos? Muy Dificil, Dificil, Neutral, Fácil, Muy Fácil', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'AD360_P01', e.id_encuesta, m.id_metrica, 1, 'Muy mala, Mala, Normal, Buena, Excelente', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'AD360_P02', e.id_encuesta, m.id_metrica, 2, '¿Qué es lo que más te ha gustado?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'AD360' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SERVICIOS_MILLENNIUM_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la calidad de los servicios que tiene contratados actualmente con nosotros? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SERVICIOS_MILLENNIUM_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valora la variedad de servicios y formaciones que están disponibles en el programa Millennium? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SERVICIOS_MILLENNIUM_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo de satisfecho está en términos generales con los servicios contratados del Millennium? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SERVICIOS_MILLENNIUM_P03', e.id_encuesta, m.id_metrica, 3, '¿Qué otros servicios te gustaría que ofreciéramos o considerarías contratar para mejorar el rendimiento y eficiencia de tu taller/negocio?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WEB_APP_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la información disponible en la APP/Web?Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WEB_APP_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo de fácil te resulta usar la APP? Muy Dificil, Difícil, Neutral, Fácil, Muy fácil', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WEB_APP_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo de satisfecho está en términos generales con la APP ? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'WEB_APP_P03', e.id_encuesta, m.id_metrica, 3, '¿Qué otros servicios o información te gustaría que ofreciéramos en nuestra APP?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'WEB_APP' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FORMACIN_P01', e.id_encuesta, m.id_metrica, 1, '¿El formador ha transmitido los conocimientos de manera correcta y profesional? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FORMACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FORMACIN_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valora la Comunicación previa y organización del curso? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FORMACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FORMACIN_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo de satisfecho está con la formación recibida? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FORMACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FORMACIN_P04', e.id_encuesta, m.id_metrica, 4, '¿Qué otros cursos de formación le gustaría recibir?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FORMACIN' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'GARANTAS_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la gestión del proceso de garantías? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'GARANTAS_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo de fácil le resulta comunicar una garantía? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'GARANTAS_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la Información que tiene de garantías pendientes? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'GARANTAS_P04', e.id_encuesta, m.id_metrica, 4, '¿Le abonan correctamente en tiempo y forma las garantías? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'GARANTAS_P05', e.id_encuesta, m.id_metrica, 5, '¿Cómo de satisfecho está con el procedimiento en general de gestión de garantías ? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'GARANTAS_P06', e.id_encuesta, m.id_metrica, 6, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'GARANTAS' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P01', e.id_encuesta, m.id_metrica, 1, '¿Cuál es el principal motivo de las devoluciones que realizan? Error Vemare no es la correcta, Error nuestro al pedirla, Me ha tardado más de la cuenta en llegar, La pieza viene mal', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valora la gestión del las devoluciones? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo de fácil le resulta devolver algúna pieza? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P04', e.id_encuesta, m.id_metrica, 4, 'Información de devoluciones pendientes Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P05', e.id_encuesta, m.id_metrica, 5, '¿Le abonan o envian la pieza correcta, correctamente en tiempo y forma las decoluciones? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P06', e.id_encuesta, m.id_metrica, 6, '¿Cómo de satisfecho está con el procedimiento en general de gestión de garantías ?Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'DEVOLUCIONES_P07', e.id_encuesta, m.id_metrica, 7, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'DEVOLUCIONES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FACTURACIN_P01', e.id_encuesta, m.id_metrica, 1, '¿Cuál es su canal preferido para recibir las facturas? Email, App, Web Vemare, Ad 360', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FACTURACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FACTURACIN_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valora la puntualidad en el envío de las facturas? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FACTURACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FACTURACIN_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la claridad y el detalle de las facturas? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FACTURACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FACTURACIN_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo de satisfecho está con lal fiabilidad del proceso de facturación ? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FACTURACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_EQUIPAMIENTO_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valoraría la atención del SAT de equipamiento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_EQUIPAMIENTO_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo de fácil le resulta comunicar con el SAT? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_EQUIPAMIENTO_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo de satisfecho está con el tiempo que tardan en atender su avería o mantenimeinto? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_EQUIPAMIENTO_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo valoraría la calidad de las reparaciones? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_EQUIPAMIENTO_P05', e.id_encuesta, m.id_metrica, 5, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARACIN_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo de satisfecho está con el tiempo que han tardado en atender su avería o mantenimeinto? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARACIN_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo valora la atención del técnico que le ha antendido? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARACIN_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la calidad de las reparación? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARACIN_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo valora la atención del SAT de equipamiento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'REPARACIN_P05', e.id_encuesta, m.id_metrica, 5, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'REPARACIN' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_SERVICIOS_DIGITALES_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valoraría la atención del SAT de Servicios Digitales? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_SERVICIOS_DIGITALES_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo de fácil le resulta comunicar con el SAT? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'CES'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_SERVICIOS_DIGITALES_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo de satisfecho está con el tiempo que tardan en atender su incidencia? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_SERVICIOS_DIGITALES_P04', e.id_encuesta, m.id_metrica, 4, '¿Cómo valoraría la calidad de la atención recibida? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'SAT_SERVICIOS_DIGITALES_P05', e.id_encuesta, m.id_metrica, 5, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_MILLENIUM_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la propuesta de este año? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_MILLENIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_MILLENIUM_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valora la organización del evento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_MILLENIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_MILLENIUM_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la atención recibida por parte del personal de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_MILLENIUM' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_MILLENIUM_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_MILLENIUM' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MADRING_F1_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la iniciativa de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MADRING_F1' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MADRING_F1_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valora la comunicación previa al evento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MADRING_F1' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MADRING_F1_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la atención recibida por parte del personal de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MADRING_F1' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MADRING_F1_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MADRING_F1' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_PARTNER_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la propuesta de este año? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_PARTNER' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_PARTNER_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valora la organización del evento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_PARTNER' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_PARTNER_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la atención recibida por parte del personal de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_PARTNER' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_PARTNER_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_PARTNER' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_CLUB_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la propuesta de este año? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_CLUB' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_CLUB_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valora la organización del evento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_CLUB' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_CLUB_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la atención recibida pro parte del personal de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_CLUB' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_CLUB_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_CLUB' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'BERNABEU_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la iniciativa de compartir tiempo fuera de su negocio con nosotros? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'BERNABEU' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'BERNABEU_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valora la comunicación previa al evento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'BERNABEU' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'BERNABEU_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valora la atención recibida por parte del personal de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'BERNABEU' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'BERNABEU_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'BERNABEU' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_CLIENTES_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la iniciativa de compartir tiempo fuera de su negocio con nosotros? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_CLIENTES_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valora formar parte de estas reuniones para compartir ideas y mejoras de negocio? Muy poco interesado, Poco Interesado, Neutral, Interensado, Muy Interesado', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_CLIENTES_P03', e.id_encuesta, m.id_metrica, 3, 'En una escala del 0 al 10, ¿Qué probabilidad hay de que recomiendes nuestra empresa a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_CLIENTES_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P01', e.id_encuesta, m.id_metrica, 1, 'Cómo valora formar parte de estas reuniones para compartir ideas y mejoras de negocio? Muy poco interesado, Poco Interesado, Neutral, Interensado, Muy Interesado', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo se identifica con la Red de Taller AD? Muy Poco identificado, Poco Identificado, Neutral, Identificado, Muy Identificado', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03', e.id_encuesta, m.id_metrica, 3, 'En una escala del 0 al 10, ¿Qué probabilidad hay de que recomiendes nuestra empresa a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_ESC_P01', e.id_encuesta, m.id_metrica, 1, 'Cómo valora formar parte de estas reuniones para compartir ideas y mejoras de negocio? Muy poco interesado, Poco Interesado, Neutral, Interensado, Muy Interesado', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_ESC_P02', e.id_encuesta, m.id_metrica, 2, '¿Cómo se identifica con la Red de Taller Expert Service Car? Muy Poco identificado, Poco Identificado, Neutral, Identificado, Muy Identificado', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_ESC_P03', e.id_encuesta, m.id_metrica, 3, 'En una escala del 0 al 10, ¿Qué probabilidad hay de que recomiendes nuestra empresa a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'CN_ESC_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'CN_ESC' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MOVISTAR_ARENA_P01', e.id_encuesta, m.id_metrica, 1, '¿Cómo valora la iniciativa de compartir tiempo fuera de su negocio con nosotros? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MOVISTAR_ARENA_P02', e.id_encuesta, m.id_metrica, 2, 'Cómo valoraría la comunicación previa al evento? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MOVISTAR_ARENA_P03', e.id_encuesta, m.id_metrica, 3, '¿Cómo valoraría la atención recibida por parte del personal de Grupo Vemare? Muy insatisfecho, Insatisfecho, Neutral, Satisfecho, Muy satisfecho', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA' AND m.codigo_metrica = 'CSAT'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'MOVISTAR_ARENA_P04', e.id_encuesta, m.id_metrica, 4, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FOOTER_COMUNICACIONES_P01', e.id_encuesta, m.id_metrica, 1, 'En una escala del 0 al 10, ¿Qué probabilidad hay de que recomiendes nuestra empresa a un compañero o amigo?', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES' AND m.codigo_metrica = 'NPS'
ON CONFLICT (codigo_pregunta) DO NOTHING;
INSERT INTO maestro.preguntas_maestro (codigo_pregunta, id_encuesta, id_metrica, orden, texto_pregunta, pregunta_activa)
SELECT 'FOOTER_COMUNICACIONES_P02', e.id_encuesta, m.id_metrica, 2, 'Observaciones', TRUE
FROM maestro.encuestas_maestro e, maestro.lista_metricas m
WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES' AND m.codigo_metrica = 'COMENTARIO'
ON CONFLICT (codigo_pregunta) DO NOTHING;

-- ── 8. OPCIONES MAESTRO ──────────────────────────────────────────
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P01_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P01_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P01_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P01_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'APERTURA_DE_CLIENTE_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SEGUIMIENTO_APERTURA_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'VISITA_COMERCIAL_P05_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'LLAMADA_P05_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'LLAMADA_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WHATS_APP_P05_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WHATS_APP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENTREGAS_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENTREGAS_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENTREGAS_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENTREGAS_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENTREGAS_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARTOS_ENTREGAS_P04_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P05_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P05_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P05_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P05_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P05_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_WHATSAPP_P06_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P05_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P05_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P05_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P05_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P05_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'COMPRA_TELFONO_P06_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P04_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P04_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P04_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P04_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'AD360_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'AD360_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SERVICIOS_MILLENNIUM_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P02_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P02_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P02_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P02_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'WEB_APP_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'WEB_APP_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FORMACIN_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FORMACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P02_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P02_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P02_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P02_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P05_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P05_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P05_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P05_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'GARANTAS_P05_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'GARANTAS_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P02_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P02_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P02_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P02_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P05_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P05_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P05_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P05_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P05_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P05'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P06_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P06_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P06_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P06_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'DEVOLUCIONES_P06_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'DEVOLUCIONES_P06'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FACTURACIN_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FACTURACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P02_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P02_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P02_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P02_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_EQUIPAMIENTO_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'REPARACIN_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'REPARACIN_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P02_O01', pr.id_pregunta, 'Muy difícil', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P02_O02', pr.id_pregunta, 'Difícil', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P02_O04', pr.id_pregunta, 'Fácil', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P02_O05', pr.id_pregunta, 'Muy fácil', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P04_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P04_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P04_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P04_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'SAT_SERVICIOS_DIGITALES_P04_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P04'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_MILLENIUM_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_MILLENIUM_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MADRING_F1_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MADRING_F1_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_PARTNER_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_PARTNER_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_CLUB_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_CLUB_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'BERNABEU_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'BERNABEU_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_CLIENTES_P03_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'ENCUENTROS_TALLERES_AD_PRE_P03_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'CN_ESC_P03_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'CN_ESC_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P01_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P01_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P01_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P01_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P01_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P02_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P02_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P02_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P02_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P02_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P02'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P03_O01', pr.id_pregunta, 'Muy insatisfecho', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P03_O02', pr.id_pregunta, 'Insatisfecho', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P03_O03', pr.id_pregunta, 'Neutral', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P03_O04', pr.id_pregunta, 'Satisfecho', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'MOVISTAR_ARENA_P03_O05', pr.id_pregunta, 'Muy satisfecho', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'MOVISTAR_ARENA_P03'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O00', pr.id_pregunta, '0', 0, 'PENDIENTE_0'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O01', pr.id_pregunta, '1', 1, 'PENDIENTE_1'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O02', pr.id_pregunta, '2', 2, 'PENDIENTE_2'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O03', pr.id_pregunta, '3', 3, 'PENDIENTE_3'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O04', pr.id_pregunta, '4', 4, 'PENDIENTE_4'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O05', pr.id_pregunta, '5', 5, 'PENDIENTE_5'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O06', pr.id_pregunta, '6', 6, 'PENDIENTE_6'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O07', pr.id_pregunta, '7', 7, 'PENDIENTE_7'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O08', pr.id_pregunta, '8', 8, 'PENDIENTE_8'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O09', pr.id_pregunta, '9', 9, 'PENDIENTE_9'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;
INSERT INTO maestro.opciones_maestro (codigo_opcion, id_pregunta, texto_opcion, valor_numerico, id_externo_opcion)
SELECT 'FOOTER_COMUNICACIONES_P01_O10', pr.id_pregunta, '10', 10, 'PENDIENTE_10'
FROM maestro.preguntas_maestro pr WHERE pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
ON CONFLICT (codigo_opcion) DO NOTHING;

-- ── 9. VERSIONES v1.0 y PONDERACIONES ───────────────────────────
-- APERTURA DE CLIENTE
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'APERTURA_DE_CLIENTE_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'APERTURA_DE_CLIENTE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- SEGUIMIENTO APERTURA
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SEGUIMIENTO_APERTURA_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SEGUIMIENTO_APERTURA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- VISITA COMERCIAL
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'VISITA_COMERCIAL'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'VISITA_COMERCIAL_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'VISITA_COMERCIAL_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'VISITA_COMERCIAL_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'VISITA_COMERCIAL_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'VISITA_COMERCIAL_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'VISITA_COMERCIAL'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- LLAMADA
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'LLAMADA'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'LLAMADA_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'LLAMADA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'LLAMADA_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'LLAMADA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'LLAMADA_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'LLAMADA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'LLAMADA_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'LLAMADA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.1500, 0.150000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'LLAMADA_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'LLAMADA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- WHATS APP
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'WHATS_APP'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WHATS_APP_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'WHATS_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WHATS_APP_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'WHATS_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WHATS_APP_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'WHATS_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WHATS_APP_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'WHATS_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.1500, 0.150000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WHATS_APP_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'WHATS_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- ENTREGAS
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'ENTREGAS'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.060000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENTREGAS_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'ENTREGAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- REPARTOS / ENTREGAS
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.020000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.020000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.020000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.1500, 0.150000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARTOS_ENTREGAS_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'REPARTOS_ENTREGAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- COMPRA WHATSAPP
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_WHATSAPP_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_WHATSAPP_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_WHATSAPP_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_WHATSAPP_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_WHATSAPP_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.1500, 0.150000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_WHATSAPP_P06'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'COMPRA_WHATSAPP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- COMPRA TELÉFONO
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_TELFONO_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_TELFONO_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_TELFONO_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_TELFONO_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0600, 0.012000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_TELFONO_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.1500, 0.150000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'COMPRA_TELFONO_P06'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'COMPRA_TELFONO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- AD360
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'AD360_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'AD360_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'AD360_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'AD360_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- AD360
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.020000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'AD360_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'AD360_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'AD360'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- SERVICIOS MILLENNIUM
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SERVICIOS_MILLENNIUM_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'SERVICIOS_MILLENNIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- WEB / APP
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'WEB_APP'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WEB_APP_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'WEB_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.1000, 0.100000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WEB_APP_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'WEB_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WEB_APP_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'WEB_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'WEB_APP_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'WEB_APP'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- FORMACIÓN
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'FORMACIN'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FORMACIN_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FORMACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FORMACIN_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FORMACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FORMACIN_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FORMACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FORMACIN_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'FORMACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- GARANTÍAS
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'GARANTAS_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.2000, 0.200000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'GARANTAS_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'GARANTAS_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'GARANTAS_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'GARANTAS_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'GARANTAS_P06'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'GARANTAS'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- DEVOLUCIONES
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.006000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.2000, 0.200000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.006000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.006000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.006000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.006000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P06'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'DEVOLUCIONES_P07'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'DEVOLUCIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- FACTURACIÓN
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'FACTURACIN'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FACTURACIN_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FACTURACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FACTURACIN_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FACTURACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FACTURACIN_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FACTURACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.007500
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FACTURACIN_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'FACTURACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- S.A.T. EQUIPAMIENTO
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.013330
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.2000, 0.200000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.013330
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.013330
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_EQUIPAMIENTO_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'SAT_EQUIPAMIENTO'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- REPARACIÓN
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'REPARACIN'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARACIN_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARACIN_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARACIN_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARACIN_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'REPARACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'REPARACIN_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'REPARACIN'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- S.A.T. SERVICIOS DIGITALES
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.013330
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.2000, 0.200000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CES'
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.013330
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0400, 0.013330
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'SAT_SERVICIOS_DIGITALES_P05'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'SAT_SERVICIOS_DIGITALES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- CN MILLENIUM
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'CN_MILLENIUM'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_MILLENIUM_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_MILLENIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_MILLENIUM_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_MILLENIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_MILLENIUM_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_MILLENIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_MILLENIUM_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'CN_MILLENIUM'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- MADRING F1
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'MADRING_F1'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MADRING_F1_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'MADRING_F1'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MADRING_F1_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'MADRING_F1'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MADRING_F1_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'MADRING_F1'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MADRING_F1_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'MADRING_F1'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- CN PARTNER
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'CN_PARTNER'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_PARTNER_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_PARTNER'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_PARTNER_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_PARTNER'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_PARTNER_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_PARTNER'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_PARTNER_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'CN_PARTNER'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- CN CLUB
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'CN_CLUB'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_CLUB_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_CLUB'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_CLUB_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_CLUB'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_CLUB_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_CLUB'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_CLUB_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'CN_CLUB'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- BERNABEU
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'BERNABEU'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'BERNABEU_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'BERNABEU'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'BERNABEU_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'BERNABEU'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'BERNABEU_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'BERNABEU'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'BERNABEU_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'BERNABEU'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- ENCUENTROS CLIENTES
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_CLIENTES_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'ENCUENTROS_CLIENTES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- ENCUENTROS TALLERES AD/PRE
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0300, 0.015000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'ENCUENTROS_TALLERES_AD_PRE_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'ENCUENTROS_TALLERES_AD_PRE'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- CN ESC
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'CN_ESC'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_ESC_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_ESC'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.010000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_ESC_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'CN_ESC'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_ESC_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'CN_ESC'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'CN_ESC_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'CN_ESC'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- MOVISTAR ARENA
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'MOVISTAR_ARENA'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MOVISTAR_ARENA_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MOVISTAR_ARENA_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0200, 0.006670
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MOVISTAR_ARENA_P03'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'CSAT'
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'MOVISTAR_ARENA_P04'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'MOVISTAR_ARENA'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

-- FOOTER COMUNICACIONES
INSERT INTO maestro.encuestas_versiones (id_encuesta, version_num, version_encuesta, version_activa)
SELECT e.id_encuesta, 1, 'v1.0', TRUE FROM maestro.encuestas_maestro e WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES'
ON CONFLICT (id_encuesta, version_num) DO NOTHING;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0500, 0.050000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P01'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'NPS'
WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;
INSERT INTO maestro.ponderaciones_versiones (id_encuesta, version_num, id_pregunta, id_metrica, peso_global_marketing, peso_final_calculado)
SELECT e.id_encuesta, 1, pr.id_pregunta, m.id_metrica, 0.0000, 0.000000
FROM maestro.encuestas_maestro e
JOIN maestro.preguntas_maestro pr ON pr.codigo_pregunta = 'FOOTER_COMUNICACIONES_P02'
JOIN maestro.lista_metricas m ON m.codigo_metrica = 'COMENTARIO'
WHERE e.codigo_encuesta = 'FOOTER_COMUNICACIONES'
ON CONFLICT (id_encuesta, version_num, id_pregunta) DO UPDATE SET peso_final_calculado = EXCLUDED.peso_final_calculado;

COMMIT;

-- ── VERIFICACIÓN ─────────────────────────────────────────────────
SELECT e.codigo_encuesta, f.codigo_fase, COUNT(p.id_pregunta) AS n_preguntas,
       ROUND(SUM(pv.peso_final_calculado)::NUMERIC, 4) AS suma_pesos
FROM maestro.encuestas_maestro e
JOIN maestro.fases_experiencia f ON f.id_fase_experiencia = e.id_fase_experiencia
JOIN maestro.preguntas_maestro p ON p.id_encuesta = e.id_encuesta AND p.pregunta_activa
JOIN maestro.ponderaciones_versiones pv ON pv.id_encuesta = e.id_encuesta AND pv.version_num = 1 AND pv.id_pregunta = p.id_pregunta
GROUP BY e.codigo_encuesta, f.codigo_fase ORDER BY f.codigo_fase, e.codigo_encuesta;