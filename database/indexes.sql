/**
 * @file indexes.sql
 * @description Índices optimizados para la base de datos v2 del proyecto SEPOMEX.
 */

/**
 * @index idx_codigos_postales_nombre_asentamiento_lower
 * @description Índice para búsquedas por nombre de asentamiento con ILIKE.
 */
CREATE INDEX idx_codigos_postales_nombre_asentamiento_lower
ON codigos_postales (LOWER(nombre_asentamiento));

/**
 * @index idx_codigos_postales_codigo_postal
 * @description Índice para búsquedas exactas por código postal.
 */
CREATE INDEX idx_codigos_postales_codigo_postal
ON codigos_postales (codigo_postal);

/**
 * @index idx_codigos_postales_codigo_estado
 * @description Índice para filtros y joins por código de estado.
 */
CREATE INDEX idx_codigos_postales_codigo_estado
ON codigos_postales (fk_codigo_estado);

/**
 * @index idx_codigos_postales_codigo_municipio_not_null
 * @description Índice parcial para consultas por municipio cuando no es NULL.
 */
CREATE INDEX idx_codigos_postales_codigo_municipio_not_null
ON codigos_postales (fk_codigo_municipio, fk_codigo_estado)
WHERE fk_codigo_municipio IS NOT NULL;

/**
 * @index idx_codigos_postales_codigo_ciudad_not_null
 * @description Índice parcial para consultas por ciudad cuando no es NULL.
 */
CREATE INDEX idx_codigos_postales_codigo_ciudad_not_null
ON codigos_postales (fk_codigo_ciudad, fk_codigo_estado)
WHERE fk_codigo_ciudad IS NOT NULL;

/**
 * @index idx_codigos_postales_codigo_tipo_asentamiento
 * @description Índice para filtros por tipo de asentamiento.
 */
CREATE INDEX idx_codigos_postales_codigo_tipo_asentamiento
ON codigos_postales (fk_codigo_tipo_asentamiento);

/**
 * @index idx_codigos_postales_id_zona
 * @description Índice para filtros por zona.
 */
CREATE INDEX idx_codigos_postales_id_zona
ON codigos_postales (fk_id_zona);

/**
 * @index idx_municipios_codigo_estado
 * @description Índice para buscar municipios por estado.
 */
CREATE INDEX idx_municipios_codigo_estado
ON municipios (fk_codigo_estado);

/**
 * @index idx_ciudades_codigo_estado
 * @description Índice para buscar ciudades por estado.
 */
CREATE INDEX idx_ciudades_codigo_estado
ON ciudades (fk_codigo_estado);

/**
 * @index idx_vm_codigos_postales_nombre_asentamiento_lower
 * @description Índice para búsquedas por nombre de asentamiento en la vista materializada.
 */
CREATE INDEX idx_vm_codigos_postales_nombre_asentamiento_lower
ON vm_codigos_postales (LOWER(nombre_asentamiento));

/**
 * @index idx_vm_codigos_postales_codigo_postal
 * @description Índice para búsquedas por código postal en la vista materializada.
 */
CREATE INDEX idx_vm_codigos_postales_codigo_postal
ON vm_codigos_postales (codigo_postal);

/**
 * @index idx_vm_codigos_postales_codigo_estado
 * @description Índice para filtros por estado en la vista materializada.
 */
CREATE INDEX idx_vm_codigos_postales_codigo_estado
ON vm_codigos_postales (codigo_estado);
