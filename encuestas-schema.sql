-- =============================================================================
-- Schema de encuestas v8.12.0 — Grupo Vemare
-- Generado: Junio 2026
--
-- Schemas creados:
--   maestro   → Diccionario de encuestas (solo lectura para n8n)
--   encuestas → Tablas operativas (ejecuciones, envíos, respuestas)
--
-- Dependencias externas:
--   public.contactos  → tabla existente del sistema inbound (no se modifica)
--                       La integridad con (codigo_isi, nombre_empresa) se
--                       gestiona por lógica de aplicación en n8n.
-- =============================================================================

BEGIN;

-- =============================================================================
-- SCHEMA MAESTRO — Diccionario de encuestas
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS maestro;

-- -----------------------------------------------------------------------------
-- maestro.lista_metricas
-- Catálogo global de métricas y sus rangos de valores válidos.
-- Ejemplos: NPS [1;10], CSAT [1;5], CES [1;5], COMENTARIO TEXTO
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.lista_metricas (
    id_metrica      TEXT PRIMARY KEY,   -- 'NPS', 'CSAT', 'CES', 'COMENTARIO'
    valores_escala  TEXT                -- '[1;10]', '[1;5]', 'TEXTO'
);

-- -----------------------------------------------------------------------------
-- maestro.encuestas_maestro
-- Cabecera funcional de la encuesta. Agnóstica al canal y a las ejecuciones.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.encuestas_maestro (
    id_encuesta          TEXT PRIMARY KEY,
    fase_experiencia     TEXT NOT NULL,             -- DESCUBRIMIENTO / COMPRA / POSTVENTA / EVENTOS
    tipo_interaccion     TEXT NOT NULL,             -- APERTURA_CLIENTE, CN_CLUB, MOVISTAR_ARENA...
    interaccion_activa   BOOLEAN DEFAULT true,
    id_externo_encuesta  JSONB,                     -- {"wa_flow_id": "xxx", "smk_survey_id": "yyy"}
    fecha_creacion       TIMESTAMPTZ DEFAULT NOW(),
    fecha_actualizacion  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_maestro_enc_tipo_interaccion
    ON maestro.encuestas_maestro(tipo_interaccion);

-- -----------------------------------------------------------------------------
-- maestro.encuestas_versiones
-- Control de versiones de cada encuesta. Solo una versión puede estar activa.
-- El flag version_activa lo gestiona la función generar_version_ponderaciones().
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.encuestas_versiones (
    id_encuesta      TEXT         NOT NULL,
    version_num      INT          NOT NULL,         -- Incremental: 1, 2, 3...
    version_encuesta VARCHAR(10)  NOT NULL,         -- Literal: 'v1.0', 'v2.0'
    version_activa   BOOLEAN      DEFAULT false,
    fecha_creacion   TIMESTAMPTZ  DEFAULT NOW(),
    PRIMARY KEY (id_encuesta, version_num),
    CONSTRAINT uq_encuesta_version_txt
        UNIQUE (id_encuesta, version_encuesta),
    CONSTRAINT fk_versiones_encuesta
        FOREIGN KEY (id_encuesta)
        REFERENCES maestro.encuestas_maestro(id_encuesta)
        ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- maestro.encuestas_metricas_config
-- "El Excel de Marketing". Peso global de cada métrica para cada encuesta.
-- Ejemplo: Encuesta Apertura + CSAT = 5% (0.0500)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.encuestas_metricas_config (
    id_encuesta           TEXT         NOT NULL,
    id_metrica            TEXT         NOT NULL,
    peso_global_marketing NUMERIC(6,4) NOT NULL,    -- 0.0500 = 5%
    PRIMARY KEY (id_encuesta, id_metrica),
    CONSTRAINT fk_emc_encuesta
        FOREIGN KEY (id_encuesta)
        REFERENCES maestro.encuestas_maestro(id_encuesta)
        ON DELETE RESTRICT,
    CONSTRAINT fk_emc_metrica
        FOREIGN KEY (id_metrica)
        REFERENCES maestro.lista_metricas(id_metrica)
        ON DELETE RESTRICT,
    CONSTRAINT chk_emc_peso_global
        CHECK (peso_global_marketing >= 0 AND peso_global_marketing <= 1)
);

-- -----------------------------------------------------------------------------
-- maestro.preguntas_maestro
-- Banco de preguntas. Las preguntas se desactivan, nunca se borran.
-- id_externo_pregunta: component_id del WA Flow / question_id de SurveyMonkey.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.preguntas_maestro (
    id_pregunta          TEXT        PRIMARY KEY,
    id_encuesta          TEXT        NOT NULL,
    id_metrica           TEXT        NOT NULL,
    orden                INT         NOT NULL,
    texto_pregunta       TEXT        NOT NULL,
    pregunta_activa      BOOLEAN     NOT NULL DEFAULT true,
    id_externo_pregunta  TEXT        NOT NULL,      -- component_id WA / question_id SMK
    fecha_creacion       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_actualizacion  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_pregunta_metrica_config
        FOREIGN KEY (id_encuesta, id_metrica)
        REFERENCES maestro.encuestas_metricas_config(id_encuesta, id_metrica)
        ON DELETE RESTRICT,
    CONSTRAINT uq_pregunta_encuesta_orden
        UNIQUE (id_encuesta, orden)
);

CREATE INDEX IF NOT EXISTS idx_maestro_preg_externo
    ON maestro.preguntas_maestro(id_externo_pregunta);

-- -----------------------------------------------------------------------------
-- maestro.opciones_maestro
-- Diccionario: traduce IDs técnicos de WA/SurveyMonkey a valores numéricos.
-- id_externo_opcion: option_id WA / choice_id SurveyMonkey.
-- valor_numerico: NULL para preguntas tipo COMENTARIO.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.opciones_maestro (
    id_opcion         TEXT    PRIMARY KEY,
    id_pregunta       TEXT    NOT NULL,
    texto_opcion      TEXT    NOT NULL,
    valor_numerico    NUMERIC,                      -- NULL para COMENTARIO
    id_externo_opcion TEXT    NOT NULL,             -- option_id WA / choice_id SMK
    CONSTRAINT fk_opcion_pregunta
        FOREIGN KEY (id_pregunta)
        REFERENCES maestro.preguntas_maestro(id_pregunta)
        ON DELETE RESTRICT,
    CONSTRAINT uq_opcion_pregunta_externa
        UNIQUE (id_pregunta, id_externo_opcion)
);

CREATE INDEX IF NOT EXISTS idx_maestro_opc_externo
    ON maestro.opciones_maestro(id_externo_opcion);

-- -----------------------------------------------------------------------------
-- maestro.ponderaciones_versiones
-- Foto congelada de los pesos por versión y pregunta.
-- NUNCA se edita manualmente. Solo la genera generar_version_ponderaciones().
-- peso_final_calculado = peso_interno_metrica × peso_global_marketing
-- Para métricas COMENTARIO: peso_final_calculado = 0
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maestro.ponderaciones_versiones (
    id_config             SERIAL       PRIMARY KEY,
    id_encuesta           TEXT         NOT NULL,
    version_num           INT          NOT NULL,
    id_pregunta           TEXT         NOT NULL,
    id_metrica            TEXT         NOT NULL,
    peso_interno_metrica  NUMERIC(6,4)  NOT NULL,   -- 1 / nº preguntas activas de esa métrica
    peso_global_marketing NUMERIC(6,4)  NOT NULL,   -- Extraído de encuestas_metricas_config
    peso_final_calculado  NUMERIC(10,6) NOT NULL,   -- peso_interno × peso_global
    fecha_creacion        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_pond_version_maestra
        FOREIGN KEY (id_encuesta, version_num)
        REFERENCES maestro.encuestas_versiones(id_encuesta, version_num)
        ON DELETE RESTRICT,
    CONSTRAINT fk_pond_pregunta
        FOREIGN KEY (id_pregunta)
        REFERENCES maestro.preguntas_maestro(id_pregunta)
        ON DELETE RESTRICT,
    CONSTRAINT uq_pond_version_pregunta
        UNIQUE (id_encuesta, version_num, id_pregunta),
    CONSTRAINT chk_pond_peso_interno
        CHECK (peso_interno_metrica  >= 0 AND peso_interno_metrica  <= 1),
    CONSTRAINT chk_pond_peso_global
        CHECK (peso_global_marketing >= 0 AND peso_global_marketing <= 1),
    CONSTRAINT chk_pond_peso_final
        CHECK (peso_final_calculado  >= 0 AND peso_final_calculado  <= 1)
);

-- -----------------------------------------------------------------------------
-- Trigger de auditoría: actualiza fecha_actualizacion automáticamente
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- maestro.generar_version_ponderaciones(p_id_encuesta)
-- Genera una nueva versión congelada de ponderaciones.
-- Llamar una vez al cerrar la configuración de preguntas/pesos.
-- Retorna el literal de versión creado: 'v1.0', 'v2.0', etc.
--
-- Uso:
--   SELECT maestro.generar_version_ponderaciones('APERTURA_CLIENTE_2026');
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION maestro.generar_version_ponderaciones(
    p_id_encuesta TEXT
)
RETURNS TEXT AS $$
DECLARE
    v_version_num  INT;
    v_version_txt  VARCHAR(10);
    v_registro     RECORD;
    v_peso_interno NUMERIC(10,6);
BEGIN
    -- Validar que existe la encuesta
    IF NOT EXISTS (
        SELECT 1 FROM maestro.encuestas_maestro WHERE id_encuesta = p_id_encuesta
    ) THEN
        RAISE EXCEPTION 'No existe la encuesta maestra con id %', p_id_encuesta;
    END IF;

    -- Validar que tiene preguntas activas
    IF NOT EXISTS (
        SELECT 1 FROM maestro.preguntas_maestro
        WHERE id_encuesta = p_id_encuesta AND pregunta_activa = true
    ) THEN
        RAISE EXCEPTION 'La encuesta % no tiene preguntas activas', p_id_encuesta;
    END IF;

    -- Calcular siguiente version_num
    SELECT COALESCE(MAX(version_num), 0) + 1
    INTO v_version_num
    FROM maestro.encuestas_versiones
    WHERE id_encuesta = p_id_encuesta;

    v_version_txt := 'v' || v_version_num || '.0';

    -- Insertar nueva versión y marcarla activa
    INSERT INTO maestro.encuestas_versiones
        (id_encuesta, version_num, version_encuesta, version_activa)
    VALUES
        (p_id_encuesta, v_version_num, v_version_txt, true);

    -- Desactivar versiones anteriores
    UPDATE maestro.encuestas_versiones
    SET version_activa = false
    WHERE id_encuesta = p_id_encuesta AND version_num <> v_version_num;

    -- Calcular y congelar ponderaciones (window function O(1) por fila)
    FOR v_registro IN
        SELECT
            p.id_pregunta,
            p.id_metrica,
            c.peso_global_marketing,
            COUNT(*) OVER (PARTITION BY p.id_metrica) AS total_por_metrica
        FROM maestro.preguntas_maestro p
        JOIN maestro.encuestas_metricas_config c
            ON p.id_encuesta = c.id_encuesta AND p.id_metrica = c.id_metrica
        WHERE p.id_encuesta = p_id_encuesta AND p.pregunta_activa = true
        ORDER BY p.id_metrica, p.orden
    LOOP
        IF v_registro.total_por_metrica = 0 THEN
            RAISE EXCEPTION 'Métrica % sin preguntas activas en encuesta %',
                v_registro.id_metrica, p_id_encuesta;
        END IF;

        v_peso_interno := 1.000000 / v_registro.total_por_metrica;

        INSERT INTO maestro.ponderaciones_versiones (
            id_encuesta, version_num, id_pregunta, id_metrica,
            peso_interno_metrica, peso_global_marketing, peso_final_calculado
        ) VALUES (
            p_id_encuesta,
            v_version_num,
            v_registro.id_pregunta,
            v_registro.id_metrica,
            v_peso_interno,
            v_registro.peso_global_marketing,
            v_peso_interno * v_registro.peso_global_marketing
        );
    END LOOP;

    RETURN v_version_txt;
END;
$$ LANGUAGE plpgsql;


-- =============================================================================
-- SCHEMA ENCUESTAS — Tablas operativas
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS encuestas;

-- -----------------------------------------------------------------------------
-- encuestas.empresas
-- Empresas del grupo para las que se crean encuestas.
-- phone_number_id: ID público del número WA en Meta (no es un secreto —
-- no otorga acceso). El access token de Meta sí va en Credentials de n8n.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encuestas.empresas (
    id              SERIAL  PRIMARY KEY,
    nombre          TEXT    UNIQUE NOT NULL,   -- 'VEMARE', 'TRANSCOSE', 'DIESELIBERIA', 'PAHER'
    phone_number_id TEXT,                      -- ID del número en Meta Business Manager
    activo          BOOLEAN DEFAULT true
);

-- -----------------------------------------------------------------------------
-- encuestas.ejecuciones_encuesta
-- Representa cada lanzamiento físico de una encuesta (una ejecución por campaña).
-- Una encuesta maestra puede tener N ejecuciones (WA Mayo, Email Junio, etc.).
--
-- Campos base:    multicanal, válidos para cualquier planificador.
-- Campos _wa:     específicos de WhatsApp, NULL para otros canales.
-- es_prueba:      true → Modo EQUIPO (prueba interna), excluido de Power BI.
-- id_externo_collector: para WA = monday_item_id; para SMK = collector_id.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encuestas.ejecuciones_encuesta (
    -- Base multicanal
    id_ejecucion          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    id_encuesta_maestro   TEXT        NOT NULL,           -- Siempre requerido (solo campañas ENCUESTA usan esta tabla)
    canal                 TEXT        NOT NULL,         -- 'N8N', 'SURVEYMONKEY', 'ENRUTA'
    origen                TEXT,                         -- 'WHATSAPP', 'EMAIL', 'QR'
    id_externo_collector  TEXT        UNIQUE,            -- monday_item_id (WA) / collector_id (SMK); UNIQUE para ON CONFLICT
    titulo_ejecucion      TEXT        NOT NULL,
    es_prueba             BOOLEAN     NOT NULL DEFAULT false,
    fecha_creacion        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_inicio_envio    TIMESTAMPTZ,
    -- Extensiones WA (solo campañas ENCUESTA usan esta tabla)
    empresa_id            INTEGER     REFERENCES encuestas.empresas(id),
    modo_envio            TEXT,       -- 'EQUIPO' / 'REAL_LISTA' / 'REAL_MANUAL'
    segmento_filtro       TEXT,       -- Valor ILIKE sobre listas_mailjet
    wa_media_id           TEXT,       -- Media ID cacheado en Meta
    template_name         TEXT,       -- Nombre exacto del template aprobado
    flow_id               TEXT,       -- ID del WA Flow en Meta
    version_num           INT,        -- version_num activo al lanzar
    estado                TEXT,       -- Espejo del status del board monday
    -- FK al diccionario (cross-schema, mismo cluster PG)
    CONSTRAINT fk_ejecucion_encuesta_maestro
        FOREIGN KEY (id_encuesta_maestro)
        REFERENCES maestro.encuestas_maestro(id_encuesta)
        ON DELETE RESTRICT
);

-- id_externo_collector ya tiene UNIQUE CONSTRAINT en la columna
-- No se necesita índice adicional; el constraint crea su propio índice.

CREATE INDEX IF NOT EXISTS idx_ejecuciones_encuesta_maestro
    ON encuestas.ejecuciones_encuesta(id_encuesta_maestro);

CREATE INDEX IF NOT EXISTS idx_ejecuciones_prueba
    ON encuestas.ejecuciones_encuesta(es_prueba);

CREATE INDEX IF NOT EXISTS idx_ejecuciones_estado
    ON encuestas.ejecuciones_encuesta(estado);

-- -----------------------------------------------------------------------------
-- encuestas.encuestas_envios
-- Log idempotente de cada mensaje enviado.
-- flow_token = id_envio::text — se pasa a Meta en el botón WA Flow.
-- Al recibir nfm_reply, n8n busca: WHERE id_envio = flow_token::uuid
--
-- Deduplicación:
--   UNIQUE(id_ejecucion, codigo_isi, nombre_empresa) → por identity de negocio
--   UNIQUE(id_ejecucion, telefono_wa)                → por teléfono (CSV mode)
--
-- FK a public.contactos: gestionada por aplicación (n8n), no por BD.
-- Razón: public.contactos usa PK id_mailjet, sin UNIQUE enforced en (codigo_isi, nombre_empresa).
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encuestas.encuestas_envios (
    -- Base multicanal
    id_envio          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    id_ejecucion      UUID        NOT NULL,
    codigo_isi        TEXT,                             -- NULL si CSV no cruzado con contactos
    nombre_empresa    TEXT,                             -- NULL si CSV no cruzado con contactos
    telefono_wa       TEXT,
    email             TEXT,
    estado_entrega    TEXT        NOT NULL DEFAULT 'PENDIENTE',
                                                        -- PENDIENTE/ENVIADO/ENTREGADO/LEIDO/FALLIDO/respondido
    fecha_intento     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    id_externo_envio  TEXT,                             -- wamid.XXX devuelto por Meta
    -- Extensiones WhatsApp
    estado_envio      TEXT        NOT NULL DEFAULT 'PENDIENTE',
                                                        -- PENDIENTE/PROCESANDO/ENVIADO/REINTENTO/ERROR_DEFINITIVO
    ts_envio          TIMESTAMPTZ,
    ts_delivered      TIMESTAMPTZ,
    ts_read           TIMESTAMPTZ,
    intentos          INT         NOT NULL DEFAULT 0,
    error_msg         TEXT,
    -- FK
    CONSTRAINT fk_envio_ejecucion
        FOREIGN KEY (id_ejecucion)
        REFERENCES encuestas.ejecuciones_encuesta(id_ejecucion)
        ON DELETE RESTRICT,
    -- Deduplicación
    CONSTRAINT uq_envio_ejecucion_contacto
        UNIQUE (id_ejecucion, codigo_isi, nombre_empresa),
    CONSTRAINT uq_envio_ejecucion_telefono
        UNIQUE (id_ejecucion, telefono_wa)
);

CREATE INDEX IF NOT EXISTS idx_envios_ejecucion
    ON encuestas.encuestas_envios(id_ejecucion);

CREATE INDEX IF NOT EXISTS idx_envios_wa_message_id
    ON encuestas.encuestas_envios(id_externo_envio);

CREATE INDEX IF NOT EXISTS idx_envios_estado_envio
    ON encuestas.encuestas_envios(estado_envio);

CREATE INDEX IF NOT EXISTS idx_envios_telefono_wa
    ON encuestas.encuestas_envios(telefono_wa);

-- -----------------------------------------------------------------------------
-- encuestas.respuestas
-- Tabla analítica definitiva. 1 fila por pregunta respondida.
--
-- id_grupo_respuesta = id_envio del respondente (determinista).
-- Deduplicación: UNIQUE(id_grupo_respuesta, id_pregunta_maestro)
--   → Meta puede reenviar el mismo nfm_reply; ON CONFLICT DO NOTHING lo absorbe.
--
-- peso_final_calculado y valor_calculado se calculan en n8n al ingestar y se
-- persisten aquí para que Power BI no necesite recalcular ni hacer JOINs.
-- Para preguntas COMENTARIO: valor_numerico = NULL, valor_calculado = NULL,
-- peso_final_calculado = 0.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encuestas.respuestas (
    id_respuesta          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    id_ejecucion          UUID         NOT NULL,
    id_envio              UUID,
    id_encuesta_maestro   TEXT         NOT NULL,
    version_num           INT          NOT NULL,
    id_pregunta_maestro   TEXT         NOT NULL,
    id_grupo_respuesta    UUID         NOT NULL,        -- = id_envio (ver comentario arriba)
    codigo_isi            TEXT,
    nombre_empresa        TEXT,
    canal                 TEXT         NOT NULL,
    origen                TEXT,
    id_metrica            TEXT         NOT NULL,
    peso_final_calculado  NUMERIC(10,6) NOT NULL DEFAULT 0,
    valor_numerico        NUMERIC,                      -- Nota directa del cliente; NULL para COMENTARIO
    valor_calculado       NUMERIC(10,6),                -- valor_numerico × peso_final_calculado
    respuesta_comentario  TEXT,                         -- Verbatim para preguntas COMENTARIO
    atributos_adicionales JSONB,                        -- Metadatos extensibles
    fecha_respuesta       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    -- FK intra-schema
    CONSTRAINT fk_respuesta_ejecucion
        FOREIGN KEY (id_ejecucion)
        REFERENCES encuestas.ejecuciones_encuesta(id_ejecucion)
        ON DELETE RESTRICT,
    CONSTRAINT fk_respuesta_envio
        FOREIGN KEY (id_envio)
        REFERENCES encuestas.encuestas_envios(id_envio)
        ON DELETE RESTRICT,
    -- FK cross-schema al diccionario congelado (mismo cluster PG)
    CONSTRAINT fk_respuesta_version_congelada
        FOREIGN KEY (id_encuesta_maestro, version_num, id_pregunta_maestro)
        REFERENCES maestro.ponderaciones_versiones(id_encuesta, version_num, id_pregunta)
        ON DELETE RESTRICT,
    -- Deduplicación de respuestas
    CONSTRAINT uq_respuesta_grupo_pregunta
        UNIQUE (id_grupo_respuesta, id_pregunta_maestro)
);

-- Índice compuesto optimizado para Power BI
CREATE INDEX IF NOT EXISTS idx_respuestas_analitica
    ON encuestas.respuestas(id_encuesta_maestro, version_num, fecha_respuesta);

CREATE INDEX IF NOT EXISTS idx_respuestas_cliente
    ON encuestas.respuestas(codigo_isi, nombre_empresa);

CREATE INDEX IF NOT EXISTS idx_respuestas_envio
    ON encuestas.respuestas(id_envio);

CREATE INDEX IF NOT EXISTS idx_respuestas_grupo
    ON encuestas.respuestas(id_grupo_respuesta);


-- =============================================================================
-- DATOS INICIALES
-- =============================================================================

-- Métricas base
INSERT INTO maestro.lista_metricas (id_metrica, valores_escala) VALUES
    ('NPS',         '[1;10]'),
    ('CSAT',        '[1;5]'),
    ('CES',         '[1;5]'),
    ('COMENTARIO',  'TEXTO')
ON CONFLICT (id_metrica) DO NOTHING;

-- Empresas del grupo — rellenar phone_number_id con los IDs reales de Meta
INSERT INTO encuestas.empresas (nombre, phone_number_id) VALUES
    ('VEMARE',       '<PHONE_NUMBER_ID_VEMARE>'),
    ('TRANSCOSE',    '<PHONE_NUMBER_ID_TRANSCOSE>'),
    ('DIESELIBERIA', '<PHONE_NUMBER_ID_DIESELIBERIA>'),
    ('PAHER',        '<PHONE_NUMBER_ID_PAHER>')
ON CONFLICT (nombre) DO NOTHING;


COMMIT;

-- =============================================================================
-- VERIFICACIÓN (ejecutar tras el commit para confirmar la creación)
-- =============================================================================
-- SELECT table_schema, table_name
-- FROM information_schema.tables
-- WHERE table_schema IN ('maestro', 'encuestas')
-- ORDER BY table_schema, table_name;
