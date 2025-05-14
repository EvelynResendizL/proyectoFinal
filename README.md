# proyectoFinal
**A) Introducción al conjunto de datos y al problema a estudiar considerando aspectos éticos del conjunto de datos empleado**

Descripción general de los datos

El conjunto de datos recolectado contiene la información sobre la afluencia diaria registrada en las distintas estaciones del metro de la Ciudad de México. Dichos datos están divididos por línea y fecha. Los datos incluyen el número de personas que ingresaron al metro cada día, dividido por estación desde el año 2010 hasta el 2024 
- ¿Quién los recolecta?
  Los datos son recolectados por el Gobierno de la Ciudad de México, a través de la Secretaría de Movilidad (SEMOVI) y el Sistema de Transporte Colectivo (STC Metro)
- ¿Cuál es el propósito de su recolección?
  Monitorear el uso del transporte público
- ¿Dónde se pueden obtener?
  Los datos están disponibles en el siguiente portal (portal oficial de Datos Abiertos de la CDMX):
  https://datos.cdmx.gob.mx --> https://datos.cdmx.gob.mx/dataset/afluencia-diaria-del-metro-cdmx (se descarga el csv: 'Afluencia Diaria del Metro (Desglosada)') 
- ¿Con qué frecuencia se actualizan?
  La base de datos se actualiza de forma mensual o bimestral
- ¿Cuántas tuplas y cuántos atributos tiene el set de datos?
  El dataset contiene aproximadamente 1048575 registros y 6 atributos, los cuales son :
  1.-fecha
  
  2.- anio
  
  3.- mes
  
  4.- linea
  
  5.- estacion
  
  6.- afluencia
  
  (la calidad y consistencia de los datos se analizan a detalle en la sección C) Y D))
- ¿Qué significa cada atributo del set?
  fecha: Día exacto del registro.
  anio: Año (de la fecha recolectada).
  mes: Mes (de la fecha recolectada).
  linea: Línea del metro correspondiente.
  estacion: Nombre de la estación.
  afluencia: Número de personas que ingresaron al metro ese día.
- ¿Qué atributos son numéricos?
  anio, afluencia 
- ¿Qué atributos son categóricos?
  linea, mes
- ¿Qué atributos son de tipo texto?
  linea, mes, estacion
- ¿Qué atributos son de tipo temporal y/o fecha?
  fecha
- ¿Cuál es el objetivo buscado con el set de datos? ¿Para qué se usará por el
equipo?

- ¿Qué consideraciones éticas conlleva el análisis y explotación de dichos datos?


**B) Carga inicial y análisis preliminar**


1.- Carga inicial

*Paso 1:* Desde la terminal psql, creamos la base de datos y nos conctamos:
```sql
CREATE DATABASE proyecto_metro;
\c proyecto_metro
```

*Paso 2:* Una vez conectados a la base de datos *afluencia_metro*, 
creamos la tabla que usaremos en el proyecto (continuamos en la consola psql)

```sql
DROP TABLE IF EXISTS afluencia_metro;

CREATE TABLE afluencia_metro (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    mes VARCHAR(15) NOT NULL,
    anio INTEGER NOT NULL,
    linea VARCHAR(50) NOT NULL,
    estacion VARCHAR(100) NOT NULL,
    tipo_pago VARCHAR(50) NOT NULL,
    afluencia INTEGER NOT NULL,
    dia_semana VARCHAR(15),
    tipo_dia VARCHAR(15),
    semana_del_anio INTEGER,
    zona VARCHAR(20)
);
```

*Paso 3:* Es fundamental que una vez descargado el CSV, verfiquemos que está en formato UTF-8; 
si no está en dicho formato, debemos hacer lo siguiente: 

- Debemos abrir el .csv en Excel
- Damos click en Archivo--> Guardar como
- En el campo "Tipo" hay que seleccionar **CSV UTF-8 (delimitado por comas)(.csv)**. Le asignas un nombre y lo guardas, en nuestro caso fue: afluencia_final_corregida.csv.

NOTA: En algunos casos, aunque el archivo esté en formato UTF-8, los caracteres aún se muestran de forma incorrecta. Por ello, realizamos una corrección manual utilizando la función Buscar y reemplazar en Excel, sustituyendo todos los caracteres afectados. Una vez corregidos, guardamos el archivo como: **CSV UTF-8 (delimitado por comas) (.csv)**.
Para mayor comodidad del usuario, dejamos el archivo listo para los pasos posteriores en:
Scripts/afluencia_final_corregida.csv

*Paso 4*: Al archivo ya en formato UTF-8 hay que añadirle las columnas nuevas (que no estaban en el CSV original). Para eso, usamos el código de Phyton que se encuentra en la parte de Scripts (*Scripts/nuevas_tablas.py*). Al ejecutar, se añadieron las siguientes columnas:

dia_semana: día de la semana derivado de la fecha.

tipo_dia: si el día es Laboral o Fin de semana.

semana_del_anio: número de semana natural (no ISO), calculado a partir del 1 de enero de cada año.

zona: se dejó como 'otra' temporalmente, ya que su valor fue asignado posteriormente directamente en la base de datos (en el inciso C) se detalla a profundidad esa parte).
Una vez ejecutado, se actualizará el CSV usado. 

*Paso 5:* Cargamos el archivo con el siguiente código: 

```sql
 \copy afluencia_metro(fecha, mes, anio, linea, estacion, tipo_pago, afluencia, dia_semana, tipo_dia, semana_del_anio, zona) FROM 'C:\\Users\\evely\\Downloads\\ProyectoFinalBD\\afluencia_final_corregida.csv' DELIMITER ',' CSV HEADER;
```
  
-- Nota: Asegúrese de ajustar la ruta al archivo de acuerdo con la ubicación real en su computadora.


2.- Análisis preliminar




Para comprender mejor la estructura del conjunto de datos, se realizó un análisis preliminar utilizando consultas SQL. Este análisis nos ayudó a detectar problemas potenciales como duplicados, inconsistencias, y a entender de una mejor forma de los datos. A continuación se resumen los puntos más relevantes:

Valores únicos:
 Se verificó si algunas columnas tienen valores únicos o repetidos.


Mínimos y máximos de fechas:
 Se identificó el rango de fechas del dataset, desde el año 2010 hasta el 2024. 
Análisis de columnas numéricas:
 Se calcularon mínimos, máximos y promedios de la variable afluencia.
Duplicados en columnas categóricas:
 Se detectaron combinaciones repetidas de línea y estación para una misma fecha, lo cual sugiere posibles duplicados en la captura de datos.


Columnas redundantes:
 Se comparó la columna mes con el mes extraído de la columna fecha para evaluar si realmente aporta valor o se puede derivar de la fecha.


Conteo de valores nulos:
 Se hizo un conteo de valores nulos por columna.


NOTA: Antes de comenzar con el análisis exploratorio, fue necesario hacer una limpieza general de los datos (ver Parte C), ya que había errores de escritura y registros duplicados que podían alterar los resultados.


**C) Limpieza de datos**

Para trabajar bien con el dataset, primero hubo que revisarlo y limpiarlo. A lo largo de esta etapa, se encontraron varios detalles que podrían causar problemas en el analisis de datos, así que realizamos los ajustes correspondientes. Todo el código que usado está guardado en el archivo Scripts/limpieza_datos.sql.
Las limpiezas realizadas fueron las siguientes:


1.Correcciones manuales con Buscar y Reemplazar en Excel:
Incluso después de guardar en UTF-8, algunos caracteres seguían mostrándose de forma incorrecta (letras cortadas, signos extraños).
Se usó la herramienta de Buscar y reemplazar en Excel para corregir manualmente.

2.Conversión del archivo a formato UTF-8
El archivo original estaba en un formato que causaba errores al cargarlo en PostgreSQL (WIN1252), como caracteres ilegibles o símbolos extraños.
Se abrió el archivo en Excel y se guardó como CSV UTF-8 (delimitado por comas).

3.Creación de columnas adicionales
Mediante un script en Python (ver scripts/nuevas_tables.py) se agregaron columnas útiles para el análisis:

dia_semana: Día textual derivado de la fecha.

tipo_dia: Laboral o fin de semana.

semana_del_anio: Semana contada desde el 1 de enero.

zona: Clasificación por estación (norte, sur, centro, oriente, poniente).



4.Corrección de nombres de estaciones:
Encontramos varios errores en los nombres de las estaciones (a pesar de la limpieza previa). Había palabras con letras faltantes, acentos mal codificados, o inconsistencias, por ello, actualizamos cada una con UPDATE, hasta que todas quedaron con el mismo estilo y sin acentos, para facilitar las consultas.

5.Homogeneización de los nombres de estaciones:
Para evitar inconsistencias en agrupaciones y facilitar las búsquedas, todos los nombres de las estaciones fueron estandarizados con mayúscula inicial, sin tildes ni caracteres especiales.

6.Enriquecimiento de la columna *zona*

7.Clasificación manual de cada estación según su ubicación geográfica (norte, sur, centro, oriente o poniente).

Esta clasificación fue construida estación por estación, con base en su ubicación en el mapa del metro.

8.Eliminación de duplicados:
Se realizaron consultas para que, en caso de que hubiera, eliminar registros que tenían los mismos valores en: fecha, linea, estacion, tipo_pago y afluencia. Esto con el objetivo de no ocasionar distorciones en el análisis.

9.Verificación de que los datos fueran válidos:




Se hicieron consultas para eliminar, en caso de que hubiera, datos con: valores negativos de afluencia, años fuera de rango, o desacuerdo entre la columna 'anio' y 'mes' con la fecha real



Todo el conjunto de consultas utilizadas para este análisis está documentado en el archivo *limpieza_datos.sql* dentro del repositorio.





**Parte D) – Normalización hasta Cuarta Forma Normal (4FN)**

*Diseño intuitivo inicial*

Antes de aplicar una normalización formal, se propuso una descomposición inicial basada en la organización del archivo original `afluencia_metro.csv`. Esta versión inicial consideraba las siguientes entidades:

- Una tabla `afluencia`, con claves foráneas hacia las demás tablas y la cantidad de afluencia.
- Una tabla `fecha`, que incluía tanto la fecha completa como atributos derivados tales como año, mes, día de la semana, tipo de día y semana del año.
- Una tabla `estacion`, donde se agrupaban el nombre de la estación, la línea y la zona geográfica.
- Una tabla `tipo_pago`, con los distintos métodos de acceso al sistema.

Este modelo inicial resultaba funcional, pero presentaba redundancias importantes:

- La fecha se repetía junto con sus atributos derivados, lo que generaba duplicación innecesaria.
- La zona geográfica se repetía cada vez que se registraba una estación.
- Algunas estaciones estaban asociadas a más de una línea, lo cual representa una dependencia multivaluada.

El diagrama entidad-relación correspondiente a este diseño inicial se encuentra enl:

proyectoFinal/ERD_inicial.png



*Dependencias funcionales y multivaluadas detectadas*

Durante el análisis se identificaron las siguientes dependencias:

- La columna `fecha` determinaba funcionalmente a los atributos `anio`, `mes`, `tipo_dia`, `dia_semana` y `semana_del_anio`. Esta dependencia se resolvió proyectando dichos atributos en una nueva entidad denominada `fecha_metro`.

- El nombre de la estación determinaba funcionalmente su zona geográfica. En el conjunto de datos limpio, no se encontró ninguna estación registrada en más de una zona. Esta dependencia se resolvió agrupando ambos atributos en la entidad `estacion_info`.

- La relación entre estación y línea era multivaluada, pues algunas estaciones están asociadas a más de una línea. Esta dependencia se descompuso mediante la creación de la tabla `nombre_linea`, que representa cada combinación única de estación y línea.

- La columna `tipo_pago` corresponde a un catálogo de valores discretos. Por ello, fue separada en una entidad independiente para mantener consistencia y evitar repeticiones.



*Proyecciones realizadas*

Con base en las dependencias anteriores, se realizaron las siguientes proyecciones:

- `fecha_metro`: En el conjunto original, cada registro de afluencia incluía la fecha completa junto con atributos derivados como año, mes, día de la semana, tipo de día y semana del año. Esto generaba duplicación innecesaria. Para resolverlo, se creó la entidad `fecha_metro`, donde cada fecha aparece una sola vez junto con sus atributos asociados. En la tabla`afluencia`, únicamente se conserva la llave foránea `id_fecha`.

- `estacion_info`: De manera similar, se detectó que la zona geográfica de cada estación se repetía múltiples veces. Dado que cada estación tiene asociada una única zona, se proyectaron ambos atributos en una entidad separada llamada `estacion_info`, donde cada estación figura una sola vez. En la tabla `afluencia`, se mantiene únicamente la llave foránea `id_estacion`.

- `nombre_linea`: La relación multivaluada entre estaciones y líneas se descompuso mediante la creación de esta entidad intermedia, que contiene una fila por cada combinación única de estación y línea.

- `tipo_pago`: Este atributo representa un conjunto acotado de valores. Se definió como una tabla independiente para garantizar la integridad de los dato.

- `afluencia`: Se mantiene como tabla, conectando mediante llavesforáneas a las demás entidades y registrando el número de pasajeros diarios.


*Confirmación de cumplimiento de Cuarta Forma Normal (4FN)*

Una vez aplicadas las proyecciones descritas, el modelo resultante elimina todas las dependencias funcionales parciales y transitivas, así como las dependencias multivaluadas. Cada entidad contiene atributos que dependen únicamente de su llave primaria, y no se repiten combinaciones de valores innecesarios. Por tanto, se concluye que el modelo final cumple con los requisitos de la Cuarta Forma Normal (4FN).


### Diagrama entidad-relación final (modelo en 4FN)

*Script SQL de descomposición a 4FN*

El script que implementa la descomposición normalizada completa se encuentra disponible en el siguiente archivo:

Scripts/descomposicion_4FN.sql

