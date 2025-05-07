--1.-Limpieza para que el nombre de las líneas sea correcta:
-- Corregir errores tipográficos
UPDATE afluencia_metro SET linea = 'Línea 1' WHERE linea ILIKE 'lnea 1';
UPDATE afluencia_metro SET linea = 'Línea 2' WHERE linea ILIKE 'lnea 2';
UPDATE afluencia_metro SET linea = 'Línea 3' WHERE linea ILIKE 'lnea 3';
UPDATE afluencia_metro SET linea = 'Línea 4' WHERE linea ILIKE 'lnea 4';
UPDATE afluencia_metro SET linea = 'Línea 5' WHERE linea ILIKE 'lnea 5';
UPDATE afluencia_metro SET linea = 'Línea 6' WHERE linea ILIKE 'lnea 6';
UPDATE afluencia_metro SET linea = 'Línea 7' WHERE linea ILIKE 'lnea 7';
UPDATE afluencia_metro SET linea = 'Línea 8' WHERE linea ILIKE 'lnea 8';
UPDATE afluencia_metro SET linea = 'Línea 9' WHERE linea ILIKE 'lnea 9';
UPDATE afluencia_metro SET linea = 'Línea A' WHERE linea ILIKE 'lnea A';
UPDATE afluencia_metro SET linea = 'Línea B' WHERE linea ILIKE 'lnea B';
UPDATE afluencia_metro SET linea = 'Línea 12' WHERE linea ILIKE 'lnea 12';

-- Unificar formato con mayúscula para mayor facilidad de consulta 
UPDATE afluencia_metro SET linea = 'Línea 1' WHERE linea ILIKE 'linea 1';
UPDATE afluencia_metro SET linea = 'Línea 2' WHERE linea ILIKE 'linea 2';
UPDATE afluencia_metro SET linea = 'Línea 3' WHERE linea ILIKE 'linea 3';
UPDATE afluencia_metro SET linea = 'Línea 4' WHERE linea ILIKE 'linea 4';
UPDATE afluencia_metro SET linea = 'Línea 5' WHERE linea ILIKE 'linea 5';
UPDATE afluencia_metro SET linea = 'Línea 6' WHERE linea ILIKE 'linea 6';
UPDATE afluencia_metro SET linea = 'Línea 7' WHERE linea ILIKE 'linea 7';
UPDATE afluencia_metro SET linea = 'Línea 8' WHERE linea ILIKE 'linea 8';
UPDATE afluencia_metro SET linea = 'Línea 9' WHERE linea ILIKE 'linea 9';
UPDATE afluencia_metro SET linea = 'Línea 12' WHERE linea ILIKE 'linea 12';
UPDATE afluencia_metro SET linea = 'Línea A' WHERE linea ILIKE 'linea a';
UPDATE afluencia_metro SET linea = 'Línea B' WHERE linea ILIKE 'linea b';


-- 2. Eliminación de duplicados exactos
DELETE FROM afluencia_metro a
USING (
  SELECT MIN(id) AS id_valido
  FROM afluencia_metro
  GROUP BY fecha, linea, estacion, afluencia
  HAVING COUNT(*) > 1
) b
WHERE a.fecha = (SELECT fecha FROM afluencia_metro WHERE id = b.id_valido)
  AND a.linea = (SELECT linea FROM afluencia_metro WHERE id = b.id_valido)
  AND a.estacion = (SELECT estacion FROM afluencia_metro WHERE id = b.id_valido)
  AND a.afluencia = (SELECT afluencia FROM afluencia_metro WHERE id = b.id_valido)
  AND a.id <> b.id_valido;


-- 3. Validaciones de consistencia

-- Verificación de que todos los años y meses coincidan con la fecha correspondiente
SELECT *
FROM afluencia_metro
WHERE anio != EXTRACT(YEAR FROM fecha)
   OR TO_CHAR(fecha, 'Month') ILIKE mes || '%';

-- Verificación de que no hay valores de afluencia negativos
SELECT * FROM afluencia_metro WHERE afluencia < 0;

-- Verificación de que no hay años fuera del rango esperado
SELECT * FROM afluencia_metro WHERE anio < 2000 OR anio > 2025;


--4.-Limpieza para que el nombre de las estaciones sea correcta y sin incosistencias:

-- Script de limpieza para nombres de estaciones mal escritos (sin acentos para facilitar consulta)

UPDATE afluencia_metro SET estacion = 'Agricola Oriental' WHERE estacion = 'Agrcola Oriental';
UPDATE afluencia_metro SET estacion = 'Aquiles Serdan' WHERE estacion = 'Aquiles Serdn';
UPDATE afluencia_metro SET estacion = 'Aragon' WHERE estacion = 'Aragn';
UPDATE afluencia_metro SET estacion = 'Bosque de Aragon' WHERE estacion = 'Bosque de Aragn';
UPDATE afluencia_metro SET estacion = 'Boulevard Puerto Aereo' WHERE estacion = 'Boulevard Puerto Areo';
UPDATE afluencia_metro SET estacion = 'Centro Medico' WHERE estacion = 'Centro Mdico';
UPDATE afluencia_metro SET estacion = 'Cuauhtemoc' WHERE estacion = 'Cuauhtmoc';
UPDATE afluencia_metro SET estacion = 'Culhuacan' WHERE estacion = 'Culhuacn';
UPDATE afluencia_metro SET estacion = 'Deportivo Oceania' WHERE estacion = 'Deportivo Oceana';
UPDATE afluencia_metro SET estacion = 'Division del Norte' WHERE estacion = 'Divisin del Norte';
UPDATE afluencia_metro SET estacion = 'Escuadron 201' WHERE estacion = 'Escuadrn 201';
UPDATE afluencia_metro SET estacion = 'Etiopia/Plaza de la Transparencia' WHERE estacion = 'Etiopa/Plaza de la Transparencia';
UPDATE afluencia_metro SET estacion = 'Ferreria/Arena Ciudad de Mexico' WHERE estacion = 'Ferrera/Arena Ciudad de Mxico';
UPDATE afluencia_metro SET estacion = 'Gomez Farias' WHERE estacion = 'Gmez Faras';
UPDATE afluencia_metro SET estacion = 'Gomez Farias' WHERE estacion = 'Gmez Farias';
UPDATE afluencia_metro SET estacion = 'Lazaro Cardenas' WHERE estacion = 'Lzaro Crdenas';
UPDATE afluencia_metro SET estacion = 'Miguel Angel de Quevedo' WHERE estacion = 'Miguel ngel de Quevedo';
UPDATE afluencia_metro SET estacion = 'Muzquiz' WHERE estacion = 'Mzquiz';
UPDATE afluencia_metro SET estacion = 'Ninos Heroes' WHERE estacion = 'Nios Hroes';
UPDATE afluencia_metro SET estacion = 'Oceania' WHERE estacion = 'Oceana';
UPDATE afluencia_metro SET estacion = 'Penon Viejo' WHERE estacion = 'Pen viejo';
UPDATE afluencia_metro SET estacion = 'Refineria' WHERE estacion = 'Refinera';
UPDATE afluencia_metro SET estacion = 'Revolucion' WHERE estacion = 'Revolucin';
UPDATE afluencia_metro SET estacion = 'Ricardo Flores Magon' WHERE estacion = 'Ricardo Flores Magn';
UPDATE afluencia_metro SET estacion = 'Rio de los Remedios' WHERE estacion = 'Ro de los Remedios';
UPDATE afluencia_metro SET estacion = 'San Juan de Letran' WHERE estacion = 'San Juan de Letrn';
UPDATE afluencia_metro SET estacion = 'San Lazaro' WHERE estacion = 'San Lzaro';
UPDATE afluencia_metro SET estacion = 'Talisman' WHERE estacion = 'Talismn';
UPDATE afluencia_metro SET estacion = 'Tlahuac' WHERE estacion = 'Tlhuac';
UPDATE afluencia_metro SET estacion = 'Valle Gomez' WHERE estacion = 'Valle Gmez';
UPDATE afluencia_metro SET estacion = 'Velodromo' WHERE estacion = 'Veldromo';
UPDATE afluencia_metro SET estacion = 'Constitucion de 1917' WHERE estacion = 'Constitucin de 1917';
UPDATE afluencia_metro SET estacion = 'Coyoacan' WHERE estacion = 'Coyoacn';
UPDATE afluencia_metro SET estacion = 'Instituto del Petroleo' WHERE estacion = 'Instituto del Petrleo';
UPDATE afluencia_metro SET estacion = 'Isabel la Catolica' WHERE estacion = 'Isabel la Catlica';
UPDATE afluencia_metro SET estacion = 'Juanacatlan' WHERE estacion = 'Juanacatln';
UPDATE afluencia_metro SET estacion = 'Juarez' WHERE estacion = 'Jurez';
UPDATE afluencia_metro SET estacion = 'La Villa/Basilica' WHERE estacion = 'La Villa/Baslica';
UPDATE afluencia_metro SET estacion = 'Martin Carrera' WHERE estacion = 'Martn Carrera';
UPDATE afluencia_metro SET estacion = 'Nezahualcoyotl' WHERE estacion = 'Nezahualcyotl';
UPDATE afluencia_metro SET estacion = 'Olimpica' WHERE estacion = 'Olmpica';
UPDATE afluencia_metro SET estacion = 'Pantitlan' WHERE estacion = 'Pantitln';
UPDATE afluencia_metro SET estacion = 'Plaza Aragon' WHERE estacion = 'Plaza Aragn';
UPDATE afluencia_metro SET estacion = 'Politecnico' WHERE estacion = 'Politcnico';
UPDATE afluencia_metro SET estacion = 'San Andres Tomatlan' WHERE estacion = 'San Andrs Tomatln';
UPDATE afluencia_metro SET estacion = 'San Joaquin' WHERE estacion = 'San Joaqun';
UPDATE afluencia_metro SET estacion = 'Villa de Aragon' WHERE estacion = 'Villa de Aragn';
UPDATE afluencia_metro SET estacion = 'Villa de Cortes' WHERE estacion = 'Villa de Corts';
UPDATE afluencia_metro SET estacion = 'Zapotitlan' WHERE estacion = 'Zapotitln';
UPDATE afluencia_metro SET estacion = 'Zocalo/Tenochtitlan' WHERE estacion = 'Zcalo/Tenochtitlan';
