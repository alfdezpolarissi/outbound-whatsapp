-- =============================================================================
-- Schema WA — Tablas independientes para automatización WhatsApp
-- BBDD: encuestas (misma instancia que el schema IT)
-- Motor: PostgreSQL
--
-- Principio: sin FK a tablas IT. Las referencias se hacen por clave de negocio
-- (codigo_encuesta, codigo_empresa) para poder hacer JOINs sin dependencia
-- estructural. Cuando IT migre o cambie, estas tablas no se ven afectadas.
-- =============================================================================

BEGIN;

CREATE SCHEMA IF NOT EXISTS encuestas;


-- =============================================================================
-- 1. EMPRESAS WA
-- Extiende maestro.empresas_distribuidoras con configuración WA.
-- phone_number_id: ID público del número en Meta (no es un secreto).
-- No hay FK a maestro.empresas_distribuidoras — referencia por codigo_empresa.
-- =============================================================================

CREATE TABLE IF NOT EXISTS encuestas.empresas_wa (
    id              SERIAL      PRIMARY KEY,
    codigo_empresa  TEXT        UNIQUE NOT NULL,   -- 'VEMARE', 'TRANSCOSE', 'EDI', 'PAHER'
    phone_number_id TEXT        NOT NULL,          -- ID del número en Meta Business Manager
    activo          BOOLEAN     NOT NULL DEFAULT true,
    created_at      TIMESTAMP   NOT NULL DEFAULT NOW()
);

INSERT INTO encuestas.empresas_wa (codigo_empresa, phone_number_id) VALUES
    ('VEMARE',    '<PHONE_NUMBER_ID_VEMARE>'),
    ('TRANSCOSE', '<PHONE_NUMBER_ID_TRANSCOSE>'),
    ('EDI',       '<PHONE_NUMBER_ID_EDI>'),
    ('PAHER',     '<PHONE_NUMBER_ID_PAHER>')
ON CONFLICT (codigo_empresa) DO NOTHING;


-- =============================================================================
-- 2. CAMPANAS WA
-- Una fila por ítem de monday que se dispara como campaña WA.
-- Equivale a una "ejecución" dentro del sistema WA, independiente de
-- public.ejecuciones_encuesta de IT.
--
-- codigo_encuesta: clave de negocio que existe en maestro.encuestas_maestro
--                  sin FK para independencia estructural.
-- id_externo_collector: monday_item_id — UNIQUE para ON CONFLICT en upsert.
-- Solo campañas tipo ENCUESTA crean fila aquí. NOTIFICACION no.
-- =============================================================================

CREATE TABLE IF NOT EXISTS encuestas.campanas_wa (
    id                    SERIAL      PRIMARY KEY,
    -- Referencia al diccionario IT por clave de negocio (sin FK dura)
    codigo_encuesta       TEXT        NOT NULL,    -- = maestro.encuestas_maestro.codigo_encuesta
    version_num           INTEGER,                 -- version_num activo al lanzar
    -- Identificación de la campaña
    codigo_empresa        TEXT        NOT NULL,    -- = encuestas.empresas_wa.codigo_empresa
    id_externo_collector  TEXT        UNIQUE,      -- monday_item_id
    titulo_campana        TEXT        NOT NULL,
    es_prueba             BOOLEAN     NOT NULL DEFAULT false,
    modo_envio            TEXT,                    -- 'EQUIPO' / 'REAL_LISTA' / 'REAL_MANUAL'
    segmento_filtro       TEXT,
    -- Config WA
    template_name         TEXT,
    flow_id               TEXT,                    -- ID del WA Flow en Meta
    wa_media_id           TEXT,                    -- Media ID cacheado en Meta
    -- Estado
    estado                TEXT        NOT NULL DEFAULT 'BORRADOR',
    total_enviados        INTEGER     NOT NULL DEFAULT 0,
    fecha_inicio_envio    TIMESTAMP,
    created_at            TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMP   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_campanas_codigo_encuesta
    ON encuestas.campanas_wa (codigo_encuesta);
CREATE INDEX IF NOT EXISTS idx_campanas_estado
    ON encuestas.campanas_wa (estado);


-- =============================================================================
-- 3. ENVIOS WA
-- Log por contacto por campaña. Tracking completo de delivery.
-- wa_flow_token: UUID generado al insertar — se pasa a Meta como flow_token
--               en el botón del WA Flow. Permite lookup en WF-02.
-- UNIQUE (id_campana, telefono_wa): deduplicación universal.
-- =============================================================================

CREATE TABLE IF NOT EXISTS encuestas.envios_wa (
    id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    id_campana        INTEGER     NOT NULL
        REFERENCES encuestas.campanas_wa (id) ON DELETE RESTRICT,
    -- Identidad del contacto
    codigo_isi        TEXT,                        -- NULL si CSV sin cruzar con contactos
    razon_social    TEXT,
    telefono_wa       TEXT        NOT NULL,
    email             TEXT,
    -- Flow token: UUID que viaja como flow_token en el botón WA Flow
    -- WF-02 lookup: SELECT * FROM encuestas.envios_wa WHERE wa_flow_token = $1::uuid
    wa_flow_token     UUID        UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    -- Identificador del mensaje en Meta
    wa_message_id     TEXT,                        -- wamid.XXX devuelto por Meta
    -- Estados
    estado_envio      TEXT        NOT NULL DEFAULT 'PENDIENTE',
                                                   -- PENDIENTE/PROCESANDO/ENVIADO/REINTENTO/ERROR_DEFINITIVO
    estado_entrega    TEXT        NOT NULL DEFAULT 'PENDIENTE',
                                                   -- PENDIENTE/ENVIADO/ENTREGADO/LEIDO/FALLIDO/respondido
    -- Timestamps de delivery
    ts_envio          TIMESTAMP,
    ts_delivered      TIMESTAMP,
    ts_read           TIMESTAMP,
    -- Control de reintentos
    intentos          INTEGER     NOT NULL DEFAULT 0,
    error_msg         TEXT,
    -- Auditoría
    created_at        TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP   NOT NULL DEFAULT NOW(),
    -- Deduplicación
    CONSTRAINT uq_envio_campana_telefono
        UNIQUE (id_campana, telefono_wa)
);

CREATE INDEX IF NOT EXISTS idx_envios_campana
    ON encuestas.envios_wa (id_campana);
CREATE INDEX IF NOT EXISTS idx_envios_wa_message_id
    ON encuestas.envios_wa (wa_message_id);
CREATE INDEX IF NOT EXISTS idx_envios_estado_envio
    ON encuestas.envios_wa (estado_envio);
CREATE INDEX IF NOT EXISTS idx_envios_telefono
    ON encuestas.envios_wa (telefono_wa);
-- wa_flow_token ya tiene índice por UNIQUE constraint


-- =============================================================================
-- 4. RESPUESTAS WA
-- Una fila por pregunta respondida.
-- Referencia el diccionario IT por clave de negocio, sin FK dura.
-- id_grupo_respuesta = envios_wa.wa_flow_token (determinista).
-- UNIQUE (id_grupo_respuesta, codigo_pregunta): deduplicación contra reenvíos.
--
-- Cuando IT esté listo para integrar, una migración SELECT→INSERT
-- de esta tabla a public.respuestas es directa por codigo_encuesta/pregunta.
-- =============================================================================

CREATE TABLE IF NOT EXISTS encuestas.respuestas_wa (
    id                    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    -- Contexto de la campaña
    id_campana            INTEGER     NOT NULL
        REFERENCES encuestas.campanas_wa (id) ON DELETE RESTRICT,
    id_envio              UUID        NOT NULL
        REFERENCES encuestas.envios_wa (id) ON DELETE RESTRICT,
    -- Referencias al diccionario IT por clave de negocio (sin FK dura)
    codigo_encuesta       TEXT        NOT NULL,    -- = maestro.encuestas_maestro.codigo_encuesta
    version_num           INTEGER     NOT NULL,
    codigo_pregunta       TEXT        NOT NULL,    -- = maestro.preguntas_maestro.codigo_pregunta
    codigo_metrica        TEXT        NOT NULL,    -- = maestro.lista_metricas.codigo_metrica
    -- Identidad del respondente
    codigo_isi            TEXT,
    razon_social        TEXT,
    -- Agrupador de sesión completa (= wa_flow_token del envio)
    id_grupo_respuesta    UUID        NOT NULL,
    -- Valores analíticos
    peso_final_calculado  NUMERIC(10,4) NOT NULL DEFAULT 0,
    valor_numerico        NUMERIC(10,2),           -- NULL para COMENTARIO
    valor_calculado       NUMERIC(10,4),           -- valor_numerico × peso_final_calculado
    respuesta_comentario  TEXT,                    -- Verbatim para COMENTARIO
    atributos_adicionales JSONB,                   -- component_id, raw_value, etc.
    fecha_respuesta       TIMESTAMP   NOT NULL DEFAULT NOW(),
    created_at            TIMESTAMP   NOT NULL DEFAULT NOW(),
    -- Deduplicación: misma sesión, misma pregunta → una sola fila
    CONSTRAINT uq_respuesta_grupo_pregunta
        UNIQUE (id_grupo_respuesta, codigo_pregunta)
);

CREATE INDEX IF NOT EXISTS idx_respuestas_campana
    ON encuestas.respuestas_wa (id_campana);
CREATE INDEX IF NOT EXISTS idx_respuestas_grupo
    ON encuestas.respuestas_wa (id_grupo_respuesta);
CREATE INDEX IF NOT EXISTS idx_respuestas_analitica
    ON encuestas.respuestas_wa (codigo_encuesta, version_num, fecha_respuesta);
CREATE INDEX IF NOT EXISTS idx_respuestas_isi
    ON encuestas.respuestas_wa (codigo_isi);


-- =============================================================================
-- 5. TRIGGERS updated_at
-- =============================================================================

CREATE OR REPLACE FUNCTION encuestas.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_campanas_wa_updated_at ON encuestas.campanas_wa;
CREATE TRIGGER trg_campanas_wa_updated_at
    BEFORE UPDATE ON encuestas.campanas_wa
    FOR EACH ROW EXECUTE FUNCTION encuestas.set_updated_at();

DROP TRIGGER IF EXISTS trg_envios_wa_updated_at ON encuestas.envios_wa;
CREATE TRIGGER trg_envios_wa_updated_at
    BEFORE UPDATE ON encuestas.envios_wa
    FOR EACH ROW EXECUTE FUNCTION encuestas.set_updated_at();


COMMIT;


-- =============================================================================
-- MAPEO CON TABLAS IT (referencia, no FK)
-- Para JOINs analíticos desde n8n o Power BI:
--
-- campanas_wa ←→ maestro.encuestas_maestro
--   ON cw.codigo_encuesta = em.codigo_encuesta
--
-- envios_wa ←→ maestro.empresas_distribuidoras  (vía campanas_wa)
--   ON cw.codigo_empresa = ed.codigo_empresa
--
-- respuestas_wa ←→ maestro.preguntas_maestro
--   ON rw.codigo_pregunta = pm.codigo_pregunta
--
-- respuestas_wa ←→ maestro.ponderaciones_versiones
--   ON rw.codigo_encuesta = em.codigo_encuesta
--   AND rw.version_num    = pv.version_num
--   AND rw.codigo_pregunta = pm.codigo_pregunta  (via id_pregunta)
-- =============================================================================
