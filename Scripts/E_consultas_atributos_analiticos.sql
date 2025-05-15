--Análisis sin atributos nuevos

--Promedio de afluencia por tipo de día

SELECT f.tipo_dia, ROUND(AVG(a.afluencia), 2) AS promedio_afluencia
FROM afluencia a
JOIN fecha_metro f ON a.id_fecha = f.id_fecha
GROUP BY f.tipo_dia;

--Total acumulado de afluencia por tipo de día
SELECT f.tipo_dia, SUM(a.afluencia) AS total_afluencia
FROM afluencia a
JOIN fecha_metro f ON a.id_fecha = f.id_fecha
GROUP BY f.tipo_dia;

--Zona con mayor afluencia acumulada

SELECT ei.zona, SUM(a.afluencia) AS total_afluencia
FROM afluencia a
JOIN estacion_info ei ON a.id_estacion = ei.id_estacion
GROUP BY ei.zona
ORDER BY total_afluencia DESC;

--Años y sus afluencias totales proemdio

SELECT f.anio, SUM(a.afluencia) AS total_anual
FROM afluencia a
JOIN fecha_metro f ON a.id_fecha = f.id_fecha
GROUP BY f.anio
ORDER BY total_anual DESC;

--Afluencia mensual promedio

SELECT f.mes, ROUND(AVG(a.afluencia), 2) AS promedio_mensual
FROM afluencia a
JOIN fecha_metro f ON a.id_fecha = f.id_fecha
GROUP BY f.mes
ORDER BY promedio_mensual DESC;

--Tipo de pago más utilizado

SELECT tp.nombre_tipo_pago, SUM(a.afluencia) AS total_afluencia
FROM afluencia a
JOIN tipo_pago tp ON a.id_pago = tp.id_pago
GROUP BY tp.nombre_tipo_pago
ORDER BY total_afluencia DESC;


-- Días con mayor fluencia (Top 10)

SELECT f.fecha, SUM(a.afluencia) AS total_dia
FROM afluencia a
JOIN fecha_metro f ON a.id_fecha = f.id_fecha
GROUP BY f.fecha
ORDER BY total_dia DESC
LIMIT 10;

-- Días con menor fluencia (Top 10)

SELECT f.fecha, SUM(a.afluencia) AS total_dia
FROM afluencia a
JOIN fecha_metro f ON a.id_fecha = f.id_fecha
GROUP BY f.fecha
ORDER BY total_dia ASC
LIMIT 10;

-- Nuevos atributos

--epoca_anio


SELECT *,
  CASE 
    WHEN semana_del_anio BETWEEN 1 AND 10 THEN 'inicio de año'
    WHEN semana_del_anio BETWEEN 11 AND 25 THEN 'primer semestre'
    WHEN semana_del_anio BETWEEN 26 AND 38 THEN 'vacaciones/verano'
    ELSE 'fin de año'
  END AS epoca_anio
FROM afluencia_metro;

--¿Qué época del año tiene mayor afluencia promedio?

SELECT epoca_anio, ROUND(AVG(afluencia)) AS afluencia_promedio
FROM (
  SELECT *,
    CASE 
      WHEN semana_del_anio BETWEEN 1 AND 10 THEN 'inicio de año'
      WHEN semana_del_anio BETWEEN 11 AND 25 THEN 'primer semestre'
      WHEN semana_del_anio BETWEEN 26 AND 38 THEN 'vacaciones/verano'
      ELSE 'fin de año'
    END AS epoca_anio
  FROM afluencia_metro
) sub
GROUP BY epoca_anio
ORDER BY afluencia_promedio DESC;


--es_estacion_terminal

SELECT *,
  CASE 
    WHEN estacion IN (
      'Cuatro Caminos',         -- L2
      'Tasquena',               -- L2
      'Indios Verdes',          -- L3
      'Universidad',            -- L3
      'El Rosario',             -- L6 y L7
      'Martin Carrera',         -- L4 y L6
      'Constitucion de 1917',   -- L8
      'Garibaldi/Lagunilla',    -- L8
      'Pantitlan',              -- L1, L5, L9, A
      'Observatorio',           -- L1
      'Politecnico',            -- L5
      'Tlatelolco',             -- L3 (solo si lo consideras como nodo intermedio)
      'Barranca del Muerto',    -- L7
      'Tacuba',                 -- L2 y L7 (aunque es intermedia)
      'Villa de Aragon',        -- B
      'Buenavista',             -- B
      'La Paz',                 -- A
      'Tlahuac'                 -- L12
    ) THEN TRUE
    ELSE FALSE
  END AS es_estacion_terminal
FROM afluencia_metro;

--¿Las estaciones terminales tienen mayor afluencia promedio que las no terminales?
SELECT es_estacion_terminal, ROUND(AVG(afluencia)) AS afluencia_promedio
FROM (
  SELECT *,
    CASE 
      WHEN estacion IN (
      'Cuatro Caminos',         -- L2
      'Tasquena',               -- L2
      'Indios Verdes',          -- L3
      'Universidad',            -- L3
      'El Rosario',             -- L6 y L7
      'Martin Carrera',         -- L4 y L6
      'Constitucion de 1917',   -- L8
      'Garibaldi/Lagunilla',    -- L8
      'Pantitlan',              -- L1, L5, L9, A
      'Observatorio',           -- L1
      'Politecnico',            -- L5
      'Tlatelolco',             -- L3 (solo si lo consideras como nodo intermedio)
      'Barranca del Muerto',    -- L7
      'Tacuba',                 -- L2 y L7 (aunque es intermedia)
      'Villa de Aragon',        -- B
      'Buenavista',             -- B
      'La Paz',                 -- A
      'Tlahuac' 
      ) THEN TRUE
      ELSE FALSE
    END AS es_estacion_terminal
  FROM afluencia_metro
) sub
GROUP BY es_estacion_terminal;



--es_quincena

SELECT *,
  CASE 
    WHEN EXTRACT(DAY FROM fecha) IN (14, 15, 30, 31) THEN TRUE
    ELSE FALSE
  END AS es_quincena
FROM afluencia_metro;

--¿Hay mayor afleuncia en quincena?

SELECT es_quincena, ROUND(AVG(afluencia)) AS afluencia_promedio
FROM (
  SELECT *,
    CASE 
      WHEN EXTRACT(DAY FROM fecha) IN (14, 15, 30, 31) THEN TRUE
      ELSE FALSE
    END AS es_quincena
  FROM afluencia_metro
) sub
GROUP BY es_quincena;

--desviacion_estandar

WITH desv AS (
  SELECT estacion, STDDEV(afluencia) AS desviacion
  FROM afluencia_metro
  GROUP BY estacion
)
SELECT a.*, ROUND(d.desviacion, 0) AS desviacion_estandar_estacion
FROM afluencia_metro a
JOIN desv d USING(estacion);

-- Estaciones con más variabilidad de afluencia
WITH desv AS (
  SELECT estacion, ROUND(STDDEV(afluencia), 0) AS desviacion
  FROM afluencia_metro
  GROUP BY estacion
)
SELECT estacion, desviacion
FROM desv
ORDER BY desviacion DESC
LIMIT 10;






