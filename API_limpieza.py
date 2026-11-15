import pandas as pd

def cargar_datos():

    return pd.read_csv(
        "datasets/cervecerias_inicial.csv",

        # postal_code y phone a formato texto - string
        dtype={"postal_code": "string", "phone": "string"}
    )

def analizar(df):
 
    print("Dimensiones (filas - columnas)")
    print(df.shape)

    print("Valores nulos por columna")
    print(df.isnull().sum())

    print("Duplicados por id")
    print(df.duplicated(subset=["id"]).sum())

    print("Duplicados por nombre")
    print(df.duplicated(subset=["name"]).sum())

    print("Tipos de cervecería - brewery_type")
    print(df["brewery_type"].value_counts(dropna=False))

    print("Países - country")
    print(df["country"].value_counts(dropna=False))

    print("Los primeros 10 nombres")
    print(df["name"].head(10).tolist())

#NOTA
#Eliminar los duplicados de ID si es que hay
#espacios sobrantes
#postal_code y phone a formato texto - strig
#Dejar los valores nulos 

def limpiar(df):

    df_limpio = df.copy()


    # Eliminar duplicados por ID si por si acaso
    df_limpio = df_limpio.drop_duplicates(subset=["id"])


    # quitar espacio extra y convertir los vacíos en nulos reales - NA
    
    columnas_texto = [
        "id", "name", "brewery_type", "street", "city",
        "state_province", "postal_code", "country", "phone", "website_url"
    ]
    
    for col in columnas_texto:
        df_limpio[col] = df_limpio[col].astype("string").str.strip()
        df_limpio[col] = df_limpio[col].replace("", pd.NA)

    
    # Guardar el CSV limpio 

    df_limpio.to_csv("datasets/cervecerias_limpio.csv", index=False, encoding="utf-8")
    return df_limpio


if __name__ == "__main__":
    df_inicial = cargar_datos()
    analizar(df_inicial)
    df_limpio = limpiar(df_inicial)
