

--ANÁLISIS PREELIMINAR 

-- ¿Existen columnas con valores únicos? 
--NOTA: Esta pregunta fue considerada teniendo en cuenta la siguiente definición: Valores únicos se refiere a la cantidad de valores distintos que tiene una columna

--Por definición, todos los id´s son distintos 

SELECT 
  COUNT(DISTINCT fecha)       AS fechas_distintas,
  COUNT(DISTINCT mes)         AS meses_distintos,
  COUNT(DISTINCT anio)        AS anios_distintos,
  COUNT(DISTINCT linea)       AS lineas_distintas,
  COUNT(DISTINCT estacion)    AS estaciones_distintas,
  COUNT(DISTINCT dia_semana)  AS dias_semana_distintos,
  COUNT(DISTINCT zona)        AS zonas_distintas
FROM afluencia_metro;



--Verificar que los datos únicos de columas relevantes para dicha exploración:

SELECT DISTINCT fecha FROM afluencia_metro ORDER BY fecha;-- BIEN
SELECT DISTINCT mes FROM afluencia_metro ORDER BY mes;-- BIEN
SELECT DISTINCT anio FROM afluencia_metro ORDER BY anio; --BIEN
SELECT DISTINCT linea FROM afluencia_metro ORDER BY linea;--  BIEN 
SELECT DISTINCT estacion FROM afluencia_metro ORDER BY estacion;
SELECT DISTINCT dia_semana FROM afluencia_metro ORDER BY dia_semana;
SELECT DISTINCT zona FROM afluencia_metro ORDER BY zona;



--Mínimos y máximos de fehas:
SELECT MIN(fecha) AS fecha_minima, MAX(fecha) AS fecha_maxima FROM afluencia_metro;

--Mínimos, máximos y promedios de valores que son númericos:

SELECT 
  MIN(anio) AS anio_minimo, MAX(anio) AS anio_maximo,
  MIN(afluencia) AS afluencia_minima, MAX(afluencia) AS afluencia_maxima, AVG(afluencia) AS afluencia_promedio,
  MIN(semana_del_anio) AS semana_minima, MAX(semana_del_anio) AS semana_maxima, AVG(semana_del_anio) AS semana_promedio
FROM afluencia_metro;

--afluencia:


-- Promedio de afluencia por año

SELECT 
    anio, 
    ROUND(AVG(afluencia)) AS afluencia_promedio
FROM afluencia_metro
GROUP BY anio
ORDER BY anio;

--Afluencia mínima y máxima por año
SELECT 
  anio,
  MIN(afluencia) AS afluencia_minima,
  MAX(afluencia) AS afluencia_maxima
FROM afluencia_metro
GROUP BY anio
ORDER BY anio;



--Promedio de afluencia por estación (sin importar día ni año)

SELECT 
    estacion, 
    ROUND(AVG(afluencia)) AS afluencia_promedio
FROM afluencia_metro
GROUP BY estacion
ORDER BY afluencia_promedio DESC;

-- mínimos y máximos de aafluencia por estación
SELECT 
  estacion,
  MIN(afluencia) AS afluencia_minima,
  MAX(afluencia) AS afluencia_maxima
FROM afluencia_metro
GROUP BY estacion
ORDER BY estacion;

-- Promedio de afluencia dependiendo el día de la semana:
SELECT 
    dia_semana, 
    ROUND(AVG(afluencia)) AS afluencia_promedio
FROM afluencia_metro
GROUP BY dia_semana
ORDER BY 
    CASE 
        WHEN dia_semana = 'Monday' THEN 1
        WHEN dia_semana = 'Tuesday' THEN 2
        WHEN dia_semana = 'Wednesday' THEN 3
        WHEN dia_semana = 'Thursday' THEN 4
        WHEN dia_semana = 'Friday' THEN 5
        WHEN dia_semana = 'Saturday' THEN 6
        WHEN dia_semana = 'Sunday' THEN 7
    END;
   
-- Mínimos y máximos por estación y día de la semana:

SELECT 
  dia_semana,
  MIN(afluencia) AS afluencia_minima,
  MAX(afluencia) AS afluencia_maxima
FROM afluencia_metro
GROUP BY dia_semana
ORDER BY 
  CASE 
    WHEN dia_semana = 'Monday' THEN 1
    WHEN dia_semana = 'Tuesday' THEN 2
    WHEN dia_semana = 'Wednesday' THEN 3
    WHEN dia_semana = 'Thursday' THEN 4
    WHEN dia_semana = 'Friday' THEN 5
    WHEN dia_semana = 'Saturday' THEN 6
    WHEN dia_semana = 'Sunday' THEN 7
  END;
  
-- Promedio por estación y año:

SELECT 
    estacion, 
    anio, 
    ROUND(AVG(afluencia)) AS afluencia_promedio
FROM afluencia_metro
GROUP BY estacion, anio
ORDER BY estacion, anio;


-- Promedio por estación y por día de la semana:
SELECT 
    estacion, 
    dia_semana, 
    ROUND(AVG(afluencia)) AS afluencia_promedio
FROM afluencia_metro
GROUP BY estacion, dia_semana
ORDER BY estacion,
    CASE 
        WHEN dia_semana = 'Monday' THEN 1
        WHEN dia_semana = 'Tuesday' THEN 2
        WHEN dia_semana = 'Wednesday' THEN 3
        WHEN dia_semana = 'Thursday' THEN 4
        WHEN dia_semana = 'Friday' THEN 5
        WHEN dia_semana = 'Saturday' THEN 6
        WHEN dia_semana = 'Sunday' THEN 7
    END;
    
--Columnas redundantes i.e. mes y fecha coiniden?, año y fecha coinciden?:
SELECT DISTINCT mes, TO_CHAR(fecha, 'Month') AS mes_desde_fecha
FROM afluencia_metro
ORDER BY mes; --vemos que coincide

SELECT *
FROM afluencia_metro
WHERE anio != EXTRACT(YEAR FROM fecha); --Vemos que si coincide, porque no nos devuelve ningún valor

--Duplicados

SELECT fecha, linea, estacion, tipo_pago, afluencia, COUNT(*) AS repeticiones
FROM afluencia_metro
GROUP BY fecha, linea, estacion, tipo_pago, afluencia
HAVING COUNT(*) > 1
ORDER BY repeticiones DESC; -- no hay duplicados 


--Conteo de tuplas por cada categoría

-- Por tipo de pago
SELECT tipo_pago, COUNT(*) AS total FROM afluencia_metro GROUP BY tipo_pago ORDER BY total DESC;

-- Por línea
SELECT linea, COUNT(*) AS total FROM afluencia_metro GROUP BY linea ORDER BY total DESC;

-- Por estación
SELECT estacion, COUNT(*) AS total FROM afluencia_metro GROUP BY estacion ORDER BY total DESC;

-- Por mes
SELECT mes, COUNT(*) AS total FROM afluencia_metro GROUP BY mes ORDER BY total DESC;

-- Por día de la semana
SELECT dia_semana, COUNT(*) AS total FROM afluencia_metro GROUP BY dia_semana 
ORDER BY 
  CASE 
    WHEN dia_semana = 'Monday' THEN 1
    WHEN dia_semana = 'Tuesday' THEN 2
    WHEN dia_semana = 'Wednesday' THEN 3
    WHEN dia_semana = 'Thursday' THEN 4
    WHEN dia_semana = 'Friday' THEN 5
    WHEN dia_semana = 'Saturday' THEN 6
    WHEN dia_semana = 'Sunday' THEN 7
  END;

-- Por tipo de día
SELECT tipo_dia, COUNT(*) AS total FROM afluencia_metro GROUP BY tipo_dia ORDER BY total DESC;

-- Por zona
SELECT zona, COUNT(*) AS total FROM afluencia_metro GROUP BY zona ORDER BY total DESC;


SELECT *
FROM afluencia_metro
WHERE afluencia < 0
   OR anio < 2000 OR anio > 2025
   OR tipo_dia NOT IN ('Laboral', 'Fin de semana')
   OR semana_del_anio > 53
   OR dia_semana NOT IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');-- vemos que no hay inconsistencias 





