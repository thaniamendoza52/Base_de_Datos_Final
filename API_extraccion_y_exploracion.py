import os
import pandas as pd
import requests


# Extraer datos

def extraer_cervecerias():

    url = "https://api.openbrewerydb.org/v1/breweries?per_page=200&page=1"
    respuesta = requests.get(url)
    return pd.DataFrame(respuesta.json())


#  Seleccionar las 12 columnas 

def guardar_inicial(df):

    columnas = [
        "id",
        "name",
        "brewery_type",
        "street",
        "city",
        "state_province",
        "postal_code",
        "country",
        "longitude",
        "latitude",
        "phone",
        "website_url"
    ]

    df_inicial = df[columnas]

# Guardar CSV
    os.makedirs("datasets", exist_ok=True)
    df_inicial.to_csv("datasets/cervecerias_inicial.csv", index=False, encoding="utf-8")
    return df_inicial



# Exploración 
def explorar(df):

    print("Primeras 5 filas")
    print(df.head())

    print("Dimensiones (filas - columnas)")
    print(df.shape)

    print("Tipo de datos")
    print(df.dtypes)
    
    
if __name__ == "__main__":
    
    df_crudo = extraer_cervecerias()
    explorar(df_crudo)

    df_inicial = guardar_inicial(df_crudo)
    explorar(df_inicial)