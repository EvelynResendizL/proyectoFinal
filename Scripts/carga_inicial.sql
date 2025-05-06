--Parte B)
--Este Script es para crear la tabla original 'afluencia_metro' y cargar los datos desde el archivo CSV 
--Es importante que este comando se ejecute desde la terminal de PostgreSQL (psql)

--Código para crear la tabla con la información que viene del CSV
CREATE TABLE afluencia_metro (
    fecha DATE,            
    anio INTEGER,          
    mes TEXT,              
    linea TEXT,            
    estacion TEXT,         
    afluencia INTEGER      
);

--Código para cargar los datos desde el CSV 
--Es importante que el archivo se encuntre en UTF-8
\copy afluencia_metro
FROM 'C:/Users/evely/Downloads/ProyectoFinalBD/afluencia_utf8_limpio.csv' --Aquí se añade su ruta correspondiente 
DELIMITER ',' CSV HEADER;
