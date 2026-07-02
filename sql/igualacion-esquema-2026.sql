-- Iguala cualquier BD viva con lo que hay hoy en sql/tablas/ (fuente de verdad).
-- Idempotente: seguro de ejecutar aunque la BD ya tenga parte de estos cambios,
-- o ninguno. v2: revierte template_name/wa_media_id_cache de maestro.encuestas_maestro
-- (tabla de TI, no se toca) y los mueve a encuestas.encuestas_wa_config (propiedad WA).

BEGIN;

-- ── maestro.encuestas_maestro — SOLO fix de tipo, nada más ────────────────
-- id_externo_encuesta estaba mal tipada (varchar) pese a que WF-SMK ya la
-- consulta como JSONB (->>'smk_survey_id') y el modelo de datos de TI
-- (v.8.12.0) la documenta como JSONB. Corregimos el tipo, no el contenido.

DO $$
BEGIN
  IF (
    SELECT data_type FROM information_schema.columns
    WHERE table_schema = 'maestro' AND table_name = 'encuestas_maestro'
      AND column_name = 'id_externo_encuesta'
  ) <> 'jsonb' THEN
    ALTER TABLE maestro.encuestas_maestro
      ALTER COLUMN id_externo_encuesta TYPE jsonb
      USING CASE
        WHEN id_externo_encuesta IS NULL OR id_externo_encuesta = '' THEN NULL
        ELSE jsonb_build_object('smk_survey_id', id_externo_encuesta)
      END;
  END IF;
END $$;

-- Rollback: la versión anterior de este script añadió estas 2 columnas a
-- maestro.encuestas_maestro por error (tabla de TI). Las quitamos si existen.
ALTER TABLE maestro.encuestas_maestro
  DROP COLUMN IF EXISTS template_name,
  DROP COLUMN IF EXISTS wa_media_id_cache;

-- ── encuestas.encuestas_wa_config (NUEVA, propiedad WA) ─────────────────────
-- flow_id/template_name/wa_media_id_cache por encuesta, fuera de maestro.
-- Referencia codigo_encuesta por clave de negocio, sin FK a maestro (mismo
-- principio que encuestas.campanas_wa: si TI migra/cambia, esto no se rompe).

CREATE TABLE IF NOT EXISTS encuestas.encuestas_wa_config
(
    id serial NOT NULL,
    codigo_encuesta text NOT NULL,
    flow_id text,
    template_name text,
    wa_media_id_cache text,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT encuestas_wa_config_pkey PRIMARY KEY (id),
    CONSTRAINT encuestas_wa_config_codigo_encuesta_key UNIQUE (codigo_encuesta)
);

-- ── contactos.contactos ─────────────────────────────────────────────────────
ALTER TABLE contactos.contactos
  ADD COLUMN IF NOT EXISTS segmentos_mailjet text;

-- ── contactos.mailjet_listas / contactos.mailjet_segmentos ─────────────────
CREATE TABLE IF NOT EXISTS contactos.mailjet_listas
(
    id_lista bigserial NOT NULL,
    id_externo_mailjet bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    activo boolean NOT NULL DEFAULT true,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT mailjet_listas_pkey PRIMARY KEY (id_lista),
    CONSTRAINT mailjet_listas_id_externo_key UNIQUE (id_externo_mailjet)
);

CREATE TABLE IF NOT EXISTS contactos.mailjet_segmentos
(
    id_segmento bigserial NOT NULL,
    id_externo_mailjet bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    activo boolean NOT NULL DEFAULT true,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT mailjet_segmentos_pkey PRIMARY KEY (id_segmento),
    CONSTRAINT mailjet_segmentos_id_externo_key UNIQUE (id_externo_mailjet)
);

COMMIT;
