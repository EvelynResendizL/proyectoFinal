-- Descomposición de afluencia_metro en 4FN con claves artificiales

-- Eliminar tablas anteriores si existen
DROP TABLE IF EXISTS afluencia;
DROP TABLE IF EXISTS nombre_linea;
DROP TABLE IF EXISTS estacion_info;
DROP TABLE IF EXISTS fecha_metro;
DROP TABLE IF EXISTS tipo_pago;

-- Crear tabla fecha_metro, derivada de la columna fecha
CREATE TABLE fecha_metro (
    id_fecha BIGSERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    anio INTEGER,
    mes VARCHAR(15),
    dia_semana VARCHAR(15),
    tipo_dia VARCHAR(15),
    semana_del_anio INTEGER
);

INSERT INTO fecha_metro (fecha, anio, mes, dia_semana, tipo_dia, semana_del_anio)
SELECT DISTINCT fecha, anio, mes, dia_semana, tipo_dia, semana_del_anio
FROM afluencia_metro;

-- Crear tabla estacion_info (una fila por estación física)
CREATE TABLE estacion_info (
    id_estacion BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona VARCHAR(30)
);

INSERT INTO estacion_info (nombre, zona)
SELECT DISTINCT estacion, zona
FROM afluencia_metro;

-- Crear tabla nombre_linea (relación multivaluada estación ↔ línea)
CREATE TABLE nombre_linea (
    id_nombre_linea BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    linea VARCHAR(30) NOT NULL
);

INSERT INTO nombre_linea (nombre, linea)
SELECT DISTINCT estacion, linea
FROM afluencia_metro;

-- Crear tabla tipo_pago (catálogo)
CREATE TABLE tipo_pago (
    id_pago BIGSERIAL PRIMARY KEY,
    nombre_tipo_pago VARCHAR(30) NOT NULL
);

INSERT INTO tipo_pago (nombre_tipo_pago)
SELECT DISTINCT tipo_pago
FROM afluencia_metro;

-- Crear tabla afluencia (tabla de hechos)
CREATE TABLE afluencia (
    id_afluencia BIGSERIAL PRIMARY KEY,
    id_fecha INTEGER REFERENCES fecha_metro(id_fecha),
    id_estacion INTEGER REFERENCES estacion_info(id_estacion),
    id_pago INTEGER REFERENCES tipo_pago(id_pago),
    afluencia INTEGER NOT NULL
);

-- Insertar registros en afluencia
INSERT INTO afluencia (id_fecha, id_estacion, id_pago, afluencia)
SELECT
    f.id_fecha,
    e.id_estacion,
    p.id_pago,
    a.afluencia
FROM afluencia_metro a
JOIN fecha_metro f ON a.fecha = f.fecha
JOIN estacion_info e ON a.estacion = e.nombre AND a.zona = e.zona
JOIN tipo_pago p ON a.tipo_pago = p.nombre_tipo_pago;


-- RESTRICCIONES ADICIONALES


-- 1. Asegurar unicidad del nombre de estación
ALTER TABLE estacion_info
ADD CONSTRAINT unique_nombre UNIQUE(nombre);

-- 2. Relacionar formalmente nombre_linea con estacion_info por nombre
ALTER TABLE nombre_linea
ADD CONSTRAINT fk_nombre FOREIGN KEY (nombre)
REFERENCES estacion_info(nombre);


SELECT DISTINCT estacion
FROM afluencia_metro
WHERE estacion NOT IN (
  SELECT nombre FROM estacion_info
);
