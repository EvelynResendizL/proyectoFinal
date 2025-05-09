# -*- coding: utf-8 -*-
"""


@author: evely
"""
import pandas as pd

# Cargar archivo limpio
file_path = "C:/Users/evely/Downloads/ProyectoFinalBD/afluencia_final_corregida.csv" --Aquí va tu ruta
df = pd.read_csv(file_path)

# Corregir columna con BOM si aplica
df.columns = [col.strip().replace('ï»¿', '') for col in df.columns]

# Convertir fecha a datetime
df['fecha'] = pd.to_datetime(df['fecha'], dayfirst=True, errors='coerce')

# Añadir columnas derivadas
df['dia_semana'] = df['fecha'].dt.day_name()
df['tipo_dia'] = df['dia_semana'].apply(lambda d: 'Fin de semana' if d in ['Saturday', 'Sunday'] else 'Laboral')
df['semana_del_anio'] = ((df['fecha'] - pd.to_datetime(df['fecha'].dt.year.astype(str) + '-01-01')).dt.days // 7) + 1

# Crear columna vacía (temporal) para zona
df['zona'] = 'otra'

# Guardar el archivo enriquecido
output_path ="C:/Users/evely/Downloads/ProyectoFinalBD/afluencia_final_corregida.csv" --Aquí va tu ruta
df.to_csv(output_path, index=False)

print(f"Archivo enriquecido guardado en: {output_path}")

