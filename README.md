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
  https://datos.cdmx.gob.mx
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
    id SERIAL PRIMARY KEY,           -- ID único por fila
    fecha DATE NOT NULL,             -- Fecha del registro
    anio INTEGER NOT NULL,           -- Año
    mes VARCHAR(15) NOT NULL,        -- Mes 
    linea VARCHAR(50) NOT NULL,      -- Línea del metrO
    estacion VARCHAR(100) NOT NULL,  -- Estación del metro
    afluencia INTEGER NOT NULL       -- Personas que ingresaron ese día
);
```

*Paso 3:* Es fundamental que una vez descargado el CSV, verfiquemos que está en formato UTF-8; 
si no está en dicho formato, debemos hacer lo siguiente: 

- Debemos abrir el .csv en Excel
- Damos click en Archivo--> Guardar como
- En el campo "Tipo" hay que seleccionar **CSV UTF-8 (delimitado por comas)(.csv). Le asisnas un nombre y lo gradas.

*Paso 4:* Cargamos el archivo con el siguiente código: 

```sql
\copy afluencia_metro(fecha, anio, mes, linea, estacion, afluencia) FROM 'C:/Users/evely/Downloads/ProyectoFinalBD/afluencia_utf8_limpio.csv' DELIMITER ',' CSV HEADER;
```
  
-- Nota: Asegúrese de ajustar la ruta al archivo de acuerdo con la ubicación real en su computadora.


2.- Análisis preliminar




