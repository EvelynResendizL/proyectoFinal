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


Correcciones manuales con Buscar y Reemplazar en Excel:
Incluso después de guardar en UTF-8, algunos caracteres seguían mostrándose de forma incorrecta (letras cortadas, signos extraños).
Se usó la herramienta de Buscar y reemplazar en Excel para corregir manualmente.

Conversión del archivo a formato UTF-8
El archivo original estaba en un formato que causaba errores al cargarlo en PostgreSQL (WIN1252), como caracteres ilegibles o símbolos extraños.
Se abrió el archivo en Excel y se guardó como CSV UTF-8 (delimitado por comas).

Creación de columnas adicionales
Mediante un script en Python (ver scripts/nuevas_tables.py) se agregaron columnas útiles para el análisis:

dia_semana: Día textual derivado de la fecha.

tipo_dia: Laboral o fin de semana.

semana_del_anio: Semana contada desde el 1 de enero.

zona: Clasificación por estación (norte, sur, centro, oriente, poniente).



Corrección de nombres de estaciones:
Encontramos varios errores en los nombres de las estaciones (a pesar de la limpieza previa). Había palabras con letras faltantes, acentos mal codificados, o inconsistencias, por ello, actualizamos cada una con UPDATE, hasta que todas quedaron con el mismo estilo y sin acentos, para facilitar las consultas.

Homogeneización de los nombres de estaciones:
Para evitar inconsistencias en agrupaciones y facilitar las búsquedas, todos los nombres de las estaciones fueron estandarizados con mayúscula inicial, sin tildes ni caracteres especiales.

Enriquecimiento de la columna *zona*

Clasificación manual de cada estación según su ubicación geográfica (norte, sur, centro, oriente o poniente).

Esta clasificación fue construida estación por estación, con base en su ubicación en el mapa del metro.



Todo el conjunto de consultas utilizadas para este análisis está documentado en el archivo *limpieza_datos.sql* dentro del repositorio.
