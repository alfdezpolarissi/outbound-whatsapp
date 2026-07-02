-- Corrección COMPRA TELÉFONO: elimina P02 y P05 (marcadas en rojo en el excel de
-- ponderaciones), reordena las preguntas supervivientes y recalcula su ponderación
-- individual. Ejecutar contra la BD donde ya se cargó maestro-datos-iniciales.sql.

BEGIN;

-- 1. Borrar opciones de las preguntas eliminadas
DELETE FROM maestro.opciones_maestro
WHERE id_pregunta IN (
  SELECT id_pregunta FROM maestro.preguntas_maestro
  WHERE codigo_pregunta IN ('COMPRA_TELFONO_P02', 'COMPRA_TELFONO_P05')
);

-- 2. Borrar su ponderación de versión
DELETE FROM maestro.ponderaciones_versiones
WHERE id_pregunta IN (
  SELECT id_pregunta FROM maestro.preguntas_maestro
  WHERE codigo_pregunta IN ('COMPRA_TELFONO_P02', 'COMPRA_TELFONO_P05')
);

-- 3. Borrar las preguntas
DELETE FROM maestro.preguntas_maestro
WHERE codigo_pregunta IN ('COMPRA_TELFONO_P02', 'COMPRA_TELFONO_P05');

-- 4. Reordenar las supervivientes (orden secuencial 1-4)
UPDATE maestro.preguntas_maestro SET orden = 1 WHERE codigo_pregunta = 'COMPRA_TELFONO_P01';
UPDATE maestro.preguntas_maestro SET orden = 2 WHERE codigo_pregunta = 'COMPRA_TELFONO_P03';
UPDATE maestro.preguntas_maestro SET orden = 3 WHERE codigo_pregunta = 'COMPRA_TELFONO_P04';
UPDATE maestro.preguntas_maestro SET orden = 4 WHERE codigo_pregunta = 'COMPRA_TELFONO_P06';

-- 5. Recalcular ponderación individual de las 3 CSAT restantes: 0.06 / 3 = 0.02
--    (antes 0.06 / 5 = 0.012). La NPS (P06) no cambia, sigue sola con 0.15.
UPDATE maestro.ponderaciones_versiones
SET peso_final_calculado = 0.020000
WHERE id_pregunta IN (
  SELECT id_pregunta FROM maestro.preguntas_maestro
  WHERE codigo_pregunta IN ('COMPRA_TELFONO_P01', 'COMPRA_TELFONO_P03', 'COMPRA_TELFONO_P04')
);

COMMIT;
