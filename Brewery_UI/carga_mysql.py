import pandas as pd
from mysql.connector import connect
from getpass import getpass

def conectar():
    conexion = connect(
        host="localhost",
        user="root",
        port=3306,
        password=getpass("Contraseña de MySQL: "),
        database="bd_cervecerias"
    )
    return conexion

def obtener_o_crear_id(cursor, sql_select, sql_insert, valores):
    cursor.execute(sql_select, valores)
    resultado = cursor.fetchone()
    if resultado:
        return resultado[0]
    cursor.execute(sql_insert, valores)
    return cursor.lastrowid


def cargar_datos():
    # Leer el CSV limpio y convertir cualquier NaN (numérico o texto) a None real
    df = pd.read_csv("cervecerias_limpio.csv")
    df = df.astype(object).where(pd.notnull(df), None)

    conexion = conectar()
    cursor = conexion.cursor()

    # Diccionarios en memoria para no repetir consultas de catálogos ya insertados
    cache_countries = {}
    cache_states = {}
    cache_cities = {}
    cache_types = {}

    sql_brewery = """
        INSERT IGNORE INTO breweries (brewery_id, name, type_id)
        VALUES (%s, %s, %s);
    """
    sql_address = """
        INSERT IGNORE INTO brewery_addresses (brewery_id, city_id, street, postal_code, latitude, longitude)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    sql_contact = """
        INSERT IGNORE INTO brewery_contacts (brewery_id, phone, website_url)
        VALUES (%s, %s, %s);
    """

    for _, row in df.iterrows():

        # COUNTRIES
        country_name = row["country"]
        if country_name not in cache_countries:
            cache_countries[country_name] = obtener_o_crear_id(
                cursor,
                "SELECT country_id FROM countries WHERE country_name = %s;",
                "INSERT INTO countries (country_name) VALUES (%s);",
                (country_name,)
            )
        country_id = cache_countries[country_name]

        # STATES_PROVINCES
        state_name = row["state_province"]
        llave_state = (state_name, country_id)
        if llave_state not in cache_states:
            cache_states[llave_state] = obtener_o_crear_id(
                cursor,
                "SELECT state_id FROM states_provinces WHERE state_name = %s AND country_id = %s;",
                "INSERT INTO states_provinces (state_name, country_id) VALUES (%s, %s);",
                (state_name, country_id)
            )
        state_id = cache_states[llave_state]

        # CITIES
        city_name = row["city"]
        llave_city = (city_name, state_id)
        if llave_city not in cache_cities:
            cache_cities[llave_city] = obtener_o_crear_id(
                cursor,
                "SELECT city_id FROM cities WHERE city_name = %s AND state_id = %s;",
                "INSERT INTO cities (city_name, state_id) VALUES (%s, %s);",
                (city_name, state_id)
            )
        city_id = cache_cities[llave_city]

        # BREWERY_TYPES
        type_name = row["brewery_type"]
        if type_name not in cache_types:
            cache_types[type_name] = obtener_o_crear_id(
                cursor,
                "SELECT type_id FROM brewery_types WHERE type_name = %s;",
                "INSERT INTO brewery_types (type_name) VALUES (%s);",
                (type_name,)
            )
        type_id = cache_types[type_name]

        # BREWERIES
        brewery_id = row["id"]
        cursor.execute(sql_brewery, (brewery_id, row["name"], type_id))

        # BREWERY_ADDRESSES
        cursor.execute(sql_address, (
            brewery_id,
            city_id,
            row["street"] if pd.notna(row["street"]) else None,
            str(row["postal_code"]) if pd.notna(row["postal_code"]) else None,
            float(row["latitude"]) if pd.notna(row["latitude"]) else None,
            float(row["longitude"]) if pd.notna(row["longitude"]) else None
        ))

        # BREWERY_CONTACTS
        # Solo insertamos contacto si tiene al menos teléfono o sitio web
        if pd.notna(row["phone"]) or pd.notna(row["website_url"]):
            cursor.execute(sql_contact, (
                brewery_id,
                str(row["phone"]) if pd.notna(row["phone"]) else None,
                row["website_url"] if pd.notna(row["website_url"]) else None
            ))

    conexion.commit()
    print("Carga completada con exito en bd_cervecerias MySQL")

    cursor.close()
    conexion.close()


def consultar_resumen():
    conexion = conectar()
    cursor = conexion.cursor()

    tablas = [
        "countries", "states_provinces", "cities",
        "brewery_types", "breweries", "brewery_addresses", "brewery_contacts"
    ]

    print("CONTEO DE REGISTROS EN MYSQL")

    for tabla in tablas:
        cursor.execute(f"SELECT COUNT(*) FROM {tabla};")
        total = cursor.fetchone()[0]
        print(f"{tabla}: {total} registros")

    cursor.close()
    conexion.close()


if __name__ == "__main__":
    cargar_datos()
    consultar_resumen()