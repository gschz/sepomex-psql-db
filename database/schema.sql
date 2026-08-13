/**
 * @file schema.sql
 * @description Esquema optimizado de tablas para la base de datos v2 del proyecto SEPOMEX.
 */

/**
 * @table estados
 * @description Catálogo de estados de México.
 */
CREATE TABLE estados (
    pk_codigo_estado CHAR(2) PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL,
    CONSTRAINT chk_codigo_estado CHECK (pk_codigo_estado ~ '^[0-9]{2}$')
) WITH (FILLFACTOR = 90);

/**
 * @table municipios
 * @description Catálogo de municipios con relación a estados.
 */
CREATE TABLE municipios (
    pk_codigo_municipio CHAR(3),
    fk_codigo_estado CHAR(2),
    nombre_municipio VARCHAR(50) NOT NULL,
    PRIMARY KEY (pk_codigo_municipio, fk_codigo_estado),
    FOREIGN KEY (fk_codigo_estado) REFERENCES estados(pk_codigo_estado) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_codigo_municipio CHECK (pk_codigo_municipio ~ '^[0-9]{3}$')
) WITH (FILLFACTOR = 90);

/**
 * @table ciudades
 * @description Ciudades importantes con relación a estados.
 */
CREATE TABLE ciudades (
    pk_codigo_ciudad CHAR(2),
    fk_codigo_estado CHAR(2),
    nombre_ciudad VARCHAR(50) NOT NULL,
    PRIMARY KEY (pk_codigo_ciudad, fk_codigo_estado),
    FOREIGN KEY (fk_codigo_estado) REFERENCES estados(pk_codigo_estado) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_codigo_ciudad CHECK (pk_codigo_ciudad ~ '^[0-9]{2}$')
) WITH (FILLFACTOR = 90);

/**
 * @table tipos_asentamiento
 * @description Catálogo de tipos de asentamiento (colonia, barrio, etc.).
 */
CREATE TABLE tipos_asentamiento (
    pk_codigo_tipo_asentamiento CHAR(2) PRIMARY KEY,
    nombre_tipo_asentamiento VARCHAR(50) NOT NULL,
    CONSTRAINT chk_codigo_tipo_asentamiento CHECK (pk_codigo_tipo_asentamiento ~ '^[0-9]{2}$')
) WITH (FILLFACTOR = 90);

/**
 * @table zonas
 * @description Clasificación de zonas (Urbana, Rural, Semiurbana).
 */
CREATE TABLE zonas (
    pk_id_zona SMALLINT PRIMARY KEY,
    nombre_zona VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT chk_nombre_zona CHECK (nombre_zona IN ('Urbano', 'Rural', 'Semiurbano'))
) WITH (FILLFACTOR = 90);

/**
 * @table codigos_postales
 * @description Tabla principal con códigos postales y sus relaciones.
 */
CREATE TABLE codigos_postales (
    pk_id_codigo_postal SERIAL PRIMARY KEY,
    codigo_postal CHAR(5) NOT NULL,
    nombre_asentamiento VARCHAR(100) NOT NULL,
    fk_codigo_estado CHAR(2) NOT NULL,
    fk_codigo_municipio CHAR(3),
    fk_codigo_ciudad CHAR(2),
    fk_codigo_tipo_asentamiento CHAR(2) NOT NULL,
    fk_id_zona SMALLINT NOT NULL,
    FOREIGN KEY (fk_codigo_estado) REFERENCES estados(pk_codigo_estado) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (fk_codigo_municipio, fk_codigo_estado) REFERENCES municipios(pk_codigo_municipio, fk_codigo_estado) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (fk_codigo_ciudad, fk_codigo_estado) REFERENCES ciudades(pk_codigo_ciudad, fk_codigo_estado) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (fk_codigo_tipo_asentamiento) REFERENCES tipos_asentamiento(pk_codigo_tipo_asentamiento) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (fk_id_zona) REFERENCES zonas(pk_id_zona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_codigo_postal CHECK (codigo_postal ~ '^[0-9]{5}$')
) WITH (FILLFACTOR = 90);
