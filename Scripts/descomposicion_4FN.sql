-- SCRIPT SQL con tabla 'linea' para representar formalmente la relación muchos a muchos

-- Eliminar tablas anteriores si existen
DROP TABLE IF EXISTS afluencia;
DROP TABLE IF EXISTS estacion_linea;
DROP TABLE IF EXISTS linea;
DROP TABLE IF EXISTS estacion_info;
DROP TABLE IF EXISTS fecha_metro;
DROP TABLE IF EXISTS tipo_pago;

-- Crear tabla fecha_metro
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

-- Crear tabla estacion_info
CREATE TABLE estacion_info (
    id_estacion BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona VARCHAR(30),
    CONSTRAINT unique_nombre_zona UNIQUE(nombre, zona)
);

INSERT INTO estacion_info (nombre, zona)
SELECT DISTINCT estacion, zona
FROM afluencia_metro;

-- Crear tabla linea (nueva entidad)
CREATE TABLE linea (
    id_linea BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO linea (nombre)
SELECT DISTINCT linea
FROM afluencia_metro;

-- Crear tabla estacion_linea (tabla intermedia)
CREATE TABLE estacion_linea (
    id_estacion_linea BIGSERIAL PRIMARY KEY,
    id_estacion INTEGER NOT NULL REFERENCES estacion_info(id_estacion),
    id_linea INTEGER NOT NULL REFERENCES linea(id_linea)
);

INSERT INTO estacion_linea (id_estacion, id_linea)
SELECT DISTINCT e.id_estacion, l.id_linea
FROM afluencia_metro a
JOIN estacion_info e ON a.estacion = e.nombre AND a.zona = e.zona
JOIN linea l ON a.linea = l.nombre;

-- Crear tabla tipo_pago
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
    id_fecha INTEGER NOT NULL REFERENCES fecha_metro(id_fecha),
    id_estacion INTEGER NOT NULL REFERENCES estacion_info(id_estacion),
    id_pago INTEGER NOT NULL REFERENCES tipo_pago(id_pago),
    afluencia INTEGER NOT NULL
);

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
