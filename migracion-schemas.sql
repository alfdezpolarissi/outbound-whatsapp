-- =============================================================================
-- MIGRACIÓN COMPLETA DE SCHEMAS — Grupo Vemare
-- Ejecutar en este orden exacto. Leer los comentarios antes de cada bloque.
-- =============================================================================


-- =============================================================================
-- PASO 1: Crear schemas nuevos
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS contactos;
CREATE SCHEMA IF NOT EXISTS inbound;


-- =============================================================================
-- PASO 2: Eliminar FKs que apuntan a public.contactos
-- Se recrearán en el paso 4 apuntando al schema nuevo.
-- =============================================================================

ALTER TABLE IF EXISTS public.leads     DROP CONSTRAINT IF EXISTS leads_id_mailjet_fkey;
ALTER TABLE IF EXISTS public.sesiones  DROP CONSTRAINT IF EXISTS sesiones_id_mailjet_fkey;
ALTER TABLE IF EXISTS public.telefonos DROP CONSTRAINT IF EXISTS telefonos_id_mailjet_fkey;


-- =============================================================================
-- PASO 3: Mover tablas a sus schemas definitivos
-- =============================================================================

ALTER TABLE public.contactos  SET SCHEMA contactos;
ALTER TABLE public.leads      SET SCHEMA inbound;
ALTER TABLE public.sesiones   SET SCHEMA inbound;
ALTER TABLE public.telefonos  SET SCHEMA inbound;


-- =============================================================================
-- PASO 4: Recrear FKs apuntando al schema correcto
-- =============================================================================

ALTER TABLE inbound.leads
    ADD CONSTRAINT leads_id_mailjet_fkey
    FOREIGN KEY (id_mailjet)
    REFERENCES contactos.contactos (id_mailjet)
    ON UPDATE NO ACTION
    ON DELETE SET NULL;

ALTER TABLE inbound.sesiones
    ADD CONSTRAINT sesiones_id_mailjet_fkey
    FOREIGN KEY (id_mailjet)
    REFERENCES contactos.contactos (id_mailjet)
    ON UPDATE NO ACTION
    ON DELETE SET NULL;

ALTER TABLE inbound.telefonos
    ADD CONSTRAINT telefonos_id_mailjet_fkey
    FOREIGN KEY (id_mailjet)
    REFERENCES contactos.contactos (id_mailjet)
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


-- =============================================================================
-- PASO 5: Eliminar schemas antiguos
-- CASCADE elimina todas sus tablas, funciones e índices.
-- ⚠️ Asegúrate de que no hay datos importantes antes de ejecutar esto.
-- =============================================================================

DROP SCHEMA IF EXISTS maestro   CASCADE;
DROP SCHEMA IF EXISTS encuestas CASCADE;


-- =============================================================================
-- PASO 6: Ejecutar script IT
-- Archivo: script_inicial_experiencia_cliente.txt
-- Crea:
--   maestro.fases_experiencia
--   maestro.tipos_interaccion
--   maestro.origenes_encuesta
--   maestro.empresas_distribuidoras
--   maestro.lista_metricas
--   maestro.encuestas_maestro
--   maestro.encuestas_metricas_config
--   maestro.preguntas_maestro
--   maestro.opciones_maestro
--   maestro.encuestas_versiones
--   maestro.ponderaciones_versiones
--   public.ejecuciones_encuesta
--   public.encuestas_envios
--   public.respuestas
--   Datos iniciales: ENRUTA, empresas, métricas, encuesta ENC_ENRUTA
-- =============================================================================

-- → Abrir script_inicial_experiencia_cliente.txt y ejecutarlo aquí


-- =============================================================================
-- PASO 7: Ejecutar schema WA
-- Archivo: encuestas-wa-schema.sql
-- Crea:
--   encuestas.empresas_wa  (con phone_number_id por empresa)
--   encuestas.campanas_wa  (una por campaña monday)
--   encuestas.envios_wa    (un contacto por campaña, con wa_flow_token UUID)
--   encuestas.respuestas_wa (una fila por pregunta respondida)
-- =============================================================================

-- → Abrir encuestas-wa-schema.sql y ejecutarlo aquí
-- → Después: rellenar phone_number_id en encuestas.empresas_wa


-- =============================================================================
-- PASO 8: Verificación final
-- Ejecutar después de completar los pasos 6 y 7.
-- =============================================================================

-- Schemas existentes
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('contactos', 'inbound', 'maestro', 'encuestas', 'public')
ORDER BY schema_name;

-- Tablas por schema
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('contactos', 'inbound', 'maestro', 'encuestas', 'public')
  AND table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;

-- FKs del schema inbound (deben apuntar a contactos.contactos)
SELECT
    tc.table_schema,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_schema,
    ccu.table_name   AS foreign_table
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema   = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'inbound'
ORDER BY tc.table_name;

-- Empresas WA (phone_number_id debe estar relleno)
SELECT id, codigo_empresa, phone_number_id, activo
FROM encuestas.empresas_wa
ORDER BY codigo_empresa;

-- Contactos (fuente de verdad, no debe haber cambiado)
SELECT COUNT(*) AS total_contactos FROM contactos.contactos;
