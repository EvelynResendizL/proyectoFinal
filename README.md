# proyectoFinal
**A) Introducción al conjunto de datos y al problema a estudiar considerando aspectos éticos del conjunto de datos empleado**

Descripción general de los datos

El conjunto de datos recolectado contiene la información sobre la afluencia diaria registrada en las distintas estaciones del metro de la Ciudad de México. Cada registro indica el número total de personas que ingresaron a una estación en un día específico, asociado a una línea del sistema. Los datos abarcan un periodo que va desde el año 2010 hasta el 2025.
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
  El dataset contiene aproximadamente 1,048,575 registros y 6 atributos, los cuales son :
  
  1.-fecha
  
  2.- anio
  
  3.- mes
  
  4.- linea
  
  5.- estacion

  6.- tipo_pago
  
  7.- afluencia

  Al integrar las columnas, obtenemos de igual forma los siguiente atributos (explicada en la parte B):

  8.- dia_semana

  9.- tipo_dia

  10.-semana_del_anio

  11.-zona 

  
  (la calidad y consistencia de los datos se analizan a detalle en la sección C) Y D))
  
- ¿Qué significa cada atributo del set?
  
  fecha: Día exacto del registro.
  
  anio: Año (de la fecha recolectada).
  
  mes: Mes (de la fecha recolectada).
  
  linea: Línea del metro correspondiente.
  
  estacion: Nombre de la estación.
  
  fecha_pago: forma en la que se paga para ingresar a las instalaciones del metro
  
  afluencia: Número de personas que ingresaron al metro ese día.

  
  dia_semana: día de la semana.
  
  tipo_dia: si el día es Laboral o Fin de semana.
  
  semana_del_anio: número de semana natural (no ISO), calculado a partir del 1 de enero de cada año.
  
  zona: Determina si la estación está en el norte, sur, oriente, poniente o centro 
  
- ¿Qué atributos son numéricos?
  anio, afluencia, semana_del_anio
  
- ¿Qué atributos son categóricos?
  mes, linea, tipo_pago, dia_semana, tipo_dia, zona
  
- ¿Qué atributos son de tipo texto?
  mes, linea, estacion, tipo_pago, dia_semana, tipo_dia, zona
  
- ¿Qué atributos son de tipo temporal y/o fecha?
  fecha
  
- ¿Cuál es el objetivo buscado con el set de datos? ¿Para qué se usará por el
equipo? Desarrollar un modelo de datos limpio y normalizado que permita analizar, visualizar y predecir la afluencia diaria del metro de la Ciudad de México, para de esta forma mejorar las condiciones del mismo. 


- ¿Qué consideraciones éticas conlleva el análisis y explotación de dichos datos?

  1.- Toda la explotación de datos se realiza con fines académicos
  2.-El proyecto parte del reconocimiento de que el transporte público es una herramienta de equidad social, que puede no respetar la dignidad de los usuarios.


**B) Carga inicial y análisis preliminar**


1.- Carga inicial

*Paso 1:* Desde la terminal psql, creamos la base de datos y nos conectamos:
```sql
CREATE DATABASE proyecto_metro;
\c proyecto_metro
```

*Paso 2:* Una vez conectados a la base de datos *proyecto_metro*, 
creamos la tabla que usaremos en el proyecto (continuamos en la consola psql)

```sql
DROP TABLE IF EXISTS afluencia_metro;

CREATE TABLE afluencia_metro (
    id SERIAL PRIMARY KEY,
    fecha DATE,
    mes VARCHAR(15),
    anio INTEGER,
    linea VARCHAR(50),
    estacion VARCHAR(100),
    tipo_pago VARCHAR(50),
    afluencia INTEGER,
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
- En el campo "Tipo" hay que seleccionar **CSV UTF-8 (delimitado por comas)(.csv)**. Le asignas un nombre y lo guardas, en nuestro caso fue: afluencia_final_corregida.csv

NOTA: En algunos casos, aunque el archivo esté en formato UTF-8, los caracteres aún se muestran de forma incorrecta. Por ello, realizamos una corrección manual utilizando la función Buscar y reemplazar en Excel, sustituyendo todos los caracteres afectados, en específico, estos fueron los cambios:

ÃƒÂ	--> i

ÃƒÂ© --> e


i³ --> o


i¡-	a


i© -->	e


i± -->	ñ


Ã	--> A


iº -->	u

Una vez corregidos, guardamos el archivo como: **CSV UTF-8 (delimitado por comas) (.csv)**.
Para mayor comodidad del usuario, dejamos el archivo listo para los pasos posteriores en:
Scripts/afluencia_final_corregida.zip (se encuentra en un zip porque era muy pesada)

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
  
**-- Nota: Asegúrese de ajustar la ruta al archivo de acuerdo con la ubicación real en su computadora.**


2.- Análisis preliminar




Para comprender mejor la estructura del conjunto de datos, se realizó un análisis preliminar utilizando consultas SQL. Este análisis nos ayudó a detectar problemas potenciales como duplicados, inconsistencias, y a entender de una mejor forma de los datos. A continuación se resumen los puntos más relevantes:

Valores únicos:
Se verificó si algunas columnas tienen valores únicos o repetidos.

Mínimos y máximos de fechas:
 Se identificó el rango de fechas del dataset, desde el año 2010 hasta el 2025. 

 
Análisis de columnas numéricas:
 Se calcularon mínimos, máximos y promedios de la variable afluencia.

 
Duplicados en columnas categóricas:
 Se detectaron combinaciones repetidas de línea y estación para una misma fecha, lo cual sugiere posibles duplicados en la captura de datos.


Columnas redundantes:
 Se comparó la columna mes con el mes extraído de la columna fecha para evaluar si realmente aporta valor o se puede derivar de la fecha.


Conteo de valores nulos:
 Se hizo un conteo de valores nulos por columna.

Distribución de datos por categoría:
Se hizo un conteo de registros por cada categoría en variables como tipo de pago, línea, estación, mes, día de la semana, tipo de día y zona. Esto permitió detectar patrones en la densidad de datos.

Verificación de consistencia general:
Se validaron reglas lógicas como que la afluencia no puede ser negativa, que los años estén dentro de un rango razonable (2000–2025), que no existan semanas mayores a 53 y que los valores de tipo de día y día de la semana correspondan a los esperados. No se encontraron inconsistencias.




**NOTA 1**: Antes de comenzar con el análisis exploratorio, fue necesario hacer una limpieza general de los datos (ver Parte C), ya que había errores de escritura y registros duplicados que podían alterar los resultados.

**NOTA 2**: El script en donde se relizó el análisis preeliminar se encuentra en: Scripts/analisis_preliminar.sql


**C) Limpieza de datos**

Para trabajar bien con el dataset, primero hubo que revisarlo y limpiarlo. A lo largo de esta etapa, se encontraron varios detalles que podrían causar problemas en el analisis de datos, así que realizamos los ajustes correspondientes. Todo el código realizado para llevar acabo esta tarea está guardado en el archivo: Scripts/limpieza_datos.sql

Las limpiezas realizadas fueron las siguientes:


1.Correcciones manuales con Buscar y Reemplazar en Excel:
Incluso después de guardar en UTF-8, algunos caracteres seguían mostrándose de forma incorrecta (letras cortadas, signos extraños).
Se usó la herramienta de Buscar y reemplazar en Excel para corregir manualmente los siguientes caracteres:

ÃƒÂ	--> i

ÃƒÂ© --> e


i³ --> o


i¡-	a


i© -->	e


i± -->	ñ


Ã	--> A


iº -->	u


2.Conversión del archivo a formato UTF-8
El archivo original estaba en un formato que causaba errores al cargarlo en PostgreSQL (WIN1252), como caracteres ilegibles o símbolos extraños.
Se abrió el archivo en Excel y se guardó como CSV UTF-8 (delimitado por comas).

3.Creación de columnas adicionales
Mediante un script en Python (ver scripts/nuevas_tablas.py) se agregaron columnas útiles para el análisis:

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



Todo el conjunto de consultas utilizadas para este análisis está documentado en el archivo **limpieza_datos.sql** dentro del repositorio.





**D) – Normalización hasta Cuarta Forma Normal (4FN)**


1. Propuesta de descomposición Intuitiva
   
A partir del conjunto de datos, se identificaron atributos que podían clasificarse en cuatro entidades:fecha, estación, tipo de pago y afluencia. Con base en esta clasificación, se propuso una descomposición inicial compuesta por las siguientes entidades:

fecha_metro

estacion_info

tipo_pago

afluencia

Se incluye el diagrama entidad-relación correspondiente al diseño intuitivo en el archivo:
*ERD_intuitivo.pdf*

2. Dependencias Funcionales y Multivaluadas y Normalización hasta Cuarta Forma Normal (4FN)

La explicación a detalle se encentra en el archivo:
*Normalizacion.pdf

Nota importante: En la implementación final, se optó por crear una entidad formal llamada linea, y una tabla intermedia estacion_linea que relaciona id_estacion con id_linea, lo cual representa explícitamente la relación many to many entre estaciones y líneas, y mantiene el modelo en cuarta forma normal.

3. Scripts SQL de descomposición
El script que contiene las instrucciones SQL para realizar la descomposición del modelo original hasta alcanzar la cuarta forma normal se encuentra en:
Scripts/descomposicion_4FN.sql

Este archivo incluye:

La creación de las entidades resultantes,

La asignación de identificadores artificiales como llaves primarias,

Las relaciones mediante claves foráneas,

Cuidados para evitar la generación de tuplas duplicadas.

4. Diagrama ER final
El diagrama entidad-relación correspondiente al modelo en cuarta forma normal (4FN) se encuentra en el archivo:
ERD_4FN.pdf

Este modelo refleja la separación adecuada de dependencias multivaluadas y funcionales.




** E) Análisis de datos a través de consultas SQL y creación de atributos analíticos**

En esta sección se presentan los principales hallazgos obtenidos a partir de consultas SQL sobre los datos normalizados. El análisis incluye estadísticas descriptivas, agrupaciones por categorías clave y la creación de atributos analíticos para responder preguntas relevantes. Los resultados se presentan en forma tabular y son interpretados para darles sentido dentro del contexto del proyecto.


### 1. Afluencia promedio por tipo de día

| tipo_dia       | promedio_afluencia |
|----------------|--------------------|
| Fin de semana  | 3667.93            |
| Laboral        | 5334.43            |

---

### 2. Total acumulado de afluencia por tipo de día

| tipo_dia       | total_afluencia |
|----------------|-----------------|
| Fin de semana  | 95,270,952      |
| Laboral        | 345,454,837     |

---

### 3. Zona con mayor afluencia acumulada

| zona     | total_afluencia |
|----------|-----------------|
| oriente  | 1,523,618,911   |
| centro   | 1,074,434,339   |
| poniente |   913,588,189   |
| norte    |   455,264,529   |
| sur      |   440,351,456   |

---

### 4. Afluencia total por año

| anio | total_anual    |
|------|----------------|
| 2024 | 11,718,591,113 |
| 2023 | 11,152,992,291 |
| 2022 | 10,301,082,951 |
| 2021 | 794,299,549    |
| 2025 | 295,691,176    |

---

### 5. Afluencia mensual promedio

| mes        | promedio_mensual |
|------------|------------------|
| Octubre    | 5245.95          |
| Noviembre  | 5233.66          |
| Septiembre | 5045.77          |
| Diciembre  | 5016.50          |
| Marzo      | 4948.86          |
| Agosto     | 4916.25          |
| Mayo       | 4844.74          |
| Junio      | 4831.51          |
| Febrero    | 4798.78          |
| Abril      | 4686.51          |
| Julio      | 4640.34          |
| Enero      | 4232.71          |

---

### 6. Tipo de pago más utilizado

| nombre_tipo_pago | total_afluencia |
|------------------|-----------------|
| Prepago          | 3,055,225,264   |
| Boleto           |   770,301,660   |
| Gratuidad        |    58,173,050   |

---

### 7. Días con mayor afluencia (Top 10)

| fecha       | total_dia |
|-------------|-----------|
| 2024-10-25  | 4,190,895 |
| 2024-11-15  | 4,168,429 |
| 2025-02-28  | 4,135,013 |
| 2024-10-30  | 4,114,782 |
| 2024-11-29  | 4,098,064 |
| 2025-03-28  | 4,097,951 |
| 2025-03-21  | 4,074,166 |
| 2024-09-20  | 4,069,158 |
| 2025-02-27  | 4,067,336 |
| 2024-11-08  | 4,066,787 |

---

### 8. Días con menor afluencia (Top 10)

| fecha       | total_dia |
|-------------|-----------|
| 2021-01-10  |   524,758 |
| 2021-01-17  |   632,192 |
| 2021-01-24  |   636,673 |
| 2021-01-01  |   723,937 |
| 2021-01-31  |   789,161 |
| 2021-02-07  |   859,507 |
| 2021-01-09  |   940,652 |
| 2024-01-01  |   987,685 |
| 2025-01-01  | 1,010,058 |
| 2022-12-25  | 1,022,377 |

---

### 9. Afluencia promedio por época del año

| epoca_anio        | afluencia_promedio |
|-------------------|--------------------|
| fin de año        | 5167               |
| vacaciones/verano | 4832               |
| primer semestre   | 4813               |
| inicio de año     | 4590               |

---

### 10. Afluencia promedio por condición de estación terminal

| es_estacion_terminal | afluencia_promedio |
|----------------------|--------------------|
| FALSE                | 4077               |
| TRUE                 | 10163              |

---

### 11. Afluencia promedio en días de quincena

| es_quincena | afluencia_promedio |
|-------------|---------------------|
| FALSE       | 4856                |
| TRUE        | 4865                |

---

### 12. Estaciones con mayor variabilidad (desviación estándar)

| estacion                 | desviacion |
|--------------------------|------------|
| Constitucion de 1917     | 30,973     |
| Cuatro Caminos           | 29,434     |
| Indios Verdes            | 26,775     |
| Tasquena                 | 17,452     |
| Universidad              | 17,308     |
| Buenavista               | 16,451     |
| Chilpancingo             | 14,150     |
| Tlahuac                  | 13,158     |
| Zocalo/Tenochititlan     | 13,025     |
| Pantitlan                | 12,487     |


NOTA: El Script se encuentra en: Scripts/E_consultas_atributos_analiticos.sql

**Hallazgos y relevancia**
Los días laborales tienen más afluencia (5,334 vs. 3,667), lo que confirma que el uso del Metro es clave en la rutina diaria. Esto ayuda a enfocar recursos en estos días.

La zona oriente es la más transitada, con más de 1.5 mil millones de usuarios. Debería ser prioritaria en mejoras y mantenimiento.

La afluencia crece cada año, lo que muestra una recuperación postpandemia. Sirve para proyectar demanda futura.

Octubre y noviembre son los meses con más uso. Saber esto permite anticipar periodos de alta demanda y ajustar la operación.

El prepago es el método de pago más usado.

Las estaciones terminales tienen mucha más afluencia que las intermedias. Sabiendo esto, sabemos que requieren más atención operativa.

Algunas estaciones tienen alta variabilidad, lo que indica flujos irregulares y necesidad de monitoreo constante.

Los días de quincena y fechas clave tienen picos pequeños, lo que ayuda a prevenir aglomeraciones si se gestiona de forma adecuada.

Estos resultados aportan información valiosa para tomar decisiones sobre operación, mantenimiento y planeación en el Metro CDMX, con el fin de que los usuarios viajen cómodos.
