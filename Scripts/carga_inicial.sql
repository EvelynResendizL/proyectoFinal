--Parte B)
--Este Script es para crear la tabla original 'afluencia_metro' y cargar los datos desde el archivo CSV 
--Es importante que este comando se ejecute desde la terminal de PostgreSQL (psql)

--Código para crear la tabla con la información que viene del CSV
DROP TABLE IF EXISTS afluencia_metro;

CREATE TABLE afluencia_metro (
    id SERIAL PRIMARY KEY,           
    fecha DATE NOT NULL,             
    anio INTEGER NOT NULL,          
    mes VARCHAR(15) NOT NULL,        
    linea VARCHAR(50) NOT NULL,      
    estacion VARCHAR(100) NOT NULL,  
    afluencia INTEGER NOT NULL       
);

--Código para cargar los datos desde el CSV 
--Es importante que el archivo se encuntre en UTF-8
\copy afluencia_metro(fecha, anio, mes, linea, estacion, afluencia) FROM 'C:/Users/evely/Downloads/ProyectoFinalBD/afluencia_utf8_limpio.csv' DELIMITER ',' CSV HEADER;

-- En donde dice *'C:/Users/evely/Downloads/ProyectoFinalBD/afluencia_utf8_limpio.csv'* debe de usted poner su ruta correspondiente
