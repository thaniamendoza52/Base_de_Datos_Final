import os
import pandas as pd
import requests


# Extraccion de los detos del API de las cervecerias
def extraer_cervecerias():
    url = "https://api.openbrewerydb.org/v1/breweries?per_page=200&page=1"
    response = requests.get(url)


    # Se define cada columan del api
    data = {
        "api_id":[],
        "nombre":[],
        "tipo":[],
        "calle":[],
        "ciudad":[],
        "estado":[],
        "codigo_postal":[],
        "pais":[],
        "latitud":[],
        "longitud":[],
        "telefono":[],
        "sitio_web":[],
    }


    if response.status_code == 200:
        resultado = response.json()


        # A cada columana le agregamos sus datos correspondientes
        for item in resultado:
            data["api_id"].append(item.get("id"))
            data["nombre"].append(item.get("name"))
            data["tipo"].append(item.get("brewery_type"))
            data["calle"].append(item.get("address_1"))
            data["ciudad"].append(item.get("city"))
            data["estado"].append(item.get("state_province"))
            data["codigo_postal"].append(item.get("postal_code"))
            data["pais"].append(item.get("country"))
            data["latitud"].append(item.get("latitude"))
            data["longitud"].append(item.get("longitude"))
            data["telefono"].append(item.get("phone"))
            data["sitio_web"].append(item.get("website_url"))

        os.makedirs("datasets", exist_ok=True)
        df = pd.DataFrame(data)
        df.to_csv("datasets/cervecerias.csv", index=False, encoding="utf-8")

        print("Los datos se descargaron y guardaron exitosamente en el: datasets/cervecerias.csv")
    else:
        print("Error al conectar con la API ", response.status_code)


# Cargar el CSV 
def leer_datos():
    df = pd.read_csv("datasets/cervecerias.csv")
    return df


# Analizar el DataFrame 

def explorar(df: pd.DataFrame):
    print("Mostrar los datos")
    print(df)

    print("Mostrar las primeras 5 filas")
    print(df.head())

    print("Mostrar las ultimas 5 filas")
    print(df.tail())

    print("Mostrar las dimenciones (Filas-Columnas)")
    print(df.shape)

    print("Mostrar las columnas")
    print(df.columns)

    print("Tipo de datos")
    print(df.dtypes)

    print("Informacion del data")
    df.info()


if __name__ == "__main__":
    extraer_cervecerias()
    df_cervecerias = leer_datos()
    explorar(df_cervecerias)