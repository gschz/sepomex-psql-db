/**
 * @file views.sql
 * @description Vistas materializadas para la base de datos v2 del proyecto SEPOMEX.
 */

/**
 * @view vm_codigos_postales
 * @description Vista materializada que precomputa los joins más comunes para consultas de códigos postales.
 */
CREATE MATERIALIZED VIEW vm_codigos_postales
WITH (FILLFACTOR = 90)
AS
SELECT
    cp.codigo_postal,
    cp.nombre_asentamiento,
    ta.nombre_tipo_asentamiento,
    z.nombre_zona,
    e.pk_codigo_estado AS codigo_estado,
    e.nombre_estado,
    m.pk_codigo_municipio AS codigo_municipio,
    m.nombre_municipio,
    c.pk_codigo_ciudad AS codigo_ciudad,
    c.nombre_ciudad
FROM codigos_postales cp
JOIN estados e ON cp.fk_codigo_estado = e.pk_codigo_estado
JOIN tipos_asentamiento ta ON cp.fk_codigo_tipo_asentamiento = ta.pk_codigo_tipo_asentamiento
JOIN zonas z ON cp.fk_id_zona = z.pk_id_zona
LEFT JOIN municipios m ON cp.fk_codigo_municipio = m.pk_codigo_municipio AND cp.fk_codigo_estado = m.fk_codigo_estado
LEFT JOIN ciudades c ON cp.fk_codigo_ciudad = c.pk_codigo_ciudad AND cp.fk_codigo_estado = c.fk_codigo_estado;

-- Refrescar la vista materializada
REFRESH MATERIALIZED VIEW vm_codigos_postales;
