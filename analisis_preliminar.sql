
--ANÁLISIS PREELIMINAR 

-- 1. ¿Existen columnas con valores únicos? 
--NOTA: Esta pregunta fue considerada teniendo en cuenta la siguiente definición: Valores únicos se refiere a la cantidad de valores distintos que tiene una columna

--Por definición, todos los id´s son distintos 


--Cantidad de líneas distintas y cuáles son:
SELECT COUNT(DISTINCT linea) AS lineas_distintas FROM afluencia_metro;
SELECT DISTINCT linea FROM afluencia_metro ORDER BY linea;

--Cantidad de fechas distintas existentes en la base de datos:
SELECT COUNT(DISTINCT fecha) AS fechas_distintas FROM afluencia_metro;

--Cantidad de años ditintos y cuáles son:
SELECT COUNT(DISTINCT anio) AS anios_distintos FROM afluencia_metro;
SELECT DISTINCT anio FROM afluencia_metro ORDER BY anio;

--Cantidad de meses distintos y cuáles son:
SELECT COUNT(DISTINCT mes) AS meses_distintos FROM afluencia_metro;
SELECT DISTINCT mes FROM afluencia_metro ORDER BY mes;

--Cantidad de estaciones y cuáles son:
SELECT COUNT(DISTINCT estacion) AS estaciones_distintas FROM afluencia_metro;
SELECT DISTINCT estacion FROM afluencia_metro ORDER BY estacion;

--Distintas afluencias:
SELECT COUNT(DISTINCT afluencia) AS afluencias_distintas FROM afluencia_metro;




-- 2.- MÍNIMOS Y MÁXIMOS DE LAS FECHAS:
SELECT MIN(fecha) AS fecha_minima, MAX(fecha) AS fecha_maxima FROM afluencia_metro;

SELECT
    MIN(afluencia) AS min_afluencia,
    MAX(afluencia) AS max_afluencia,
    ROUND(AVG(afluencia), 2) AS promedio_afluencia
FROM afluencia_metro;


-- 3.- Duplicados en atributos categóricos
SELECT fecha, linea, estacion, COUNT(*) AS repeticiones
FROM afluencia_metro
GROUP BY fecha, linea, estacion
HAVING COUNT(*) > 1
ORDER BY repeticiones DESC;

-- 4.- Posibles columnas redundantes:
-- Comparar el valor textual del mes con el número de mes extraído de la fecha.
SELECT DISTINCT mes, EXTRACT(MONTH FROM fecha) AS mes_numerico
FROM afluencia_metro
ORDER BY mes;

-- 5.- Conteo de tuplas por línea del metro
SELECT linea, COUNT(*) AS total_registros
FROM afluencia_metro
GROUP BY linea
ORDER BY total_registros DESC;

-- 6.- Conteo de valores nulos por columna
SELECT
    COUNT(*) FILTER (WHERE id IS NULL) AS nulos_id,
    COUNT(*) FILTER (WHERE fecha IS NULL) AS nulos_fecha,
    COUNT(*) FILTER (WHERE anio IS NULL) AS nulos_anio,
    COUNT(*) FILTER (WHERE mes IS NULL) AS nulos_mes,
    COUNT(*) FILTER (WHERE linea IS NULL) AS nulos_linea,
    COUNT(*) FILTER (WHERE estacion IS NULL) AS nulos_estacion,
    COUNT(*) FILTER (WHERE afluencia IS NULL) AS nulos_afluencia
FROM afluencia_metro;

-- 8.- Detección de inconsistencias:
-- Valores negativos de afluencia, años fuera de rango, o desacuerdo entre la columna 'anio' y la fecha real
SELECT *
FROM afluencia_metro
WHERE afluencia < 0
   OR anio < 2000
   OR anio > 2025
   OR anio != EXTRACT(YEAR FROM fecha)
;
