import mysql.connector
from pymongo import MongoClient
from bson.decimal128 import Decimal128
from decimal import Decimal
from getpass import getpass

# CONEXION MYSQL
mysql_db = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="usuario",
    password=getpass("Contraseña de MySQL: "),
    database="bd_cervecerias"
)

cursor = mysql_db.cursor(dictionary=True)

# CONEXION MONGODB
cliente = MongoClient("mongodb://localhost:27017/")
mongo_db = cliente["bd_cervecerias"]

tablas = {
    "countries": "country_id",
    "states_provinces": "state_id",
    "cities": "city_id",
    "brewery_types": "type_id",
    "breweries": "brewery_id",
    "brewery_addresses": "address_id",
    "brewery_contacts": "contact_id",
    "log_audit_countries": "audit_id",
    "log_audit_states_provinces": "audit_id",
    "log_audit_cities": "audit_id",
    "log_audit_brewery_types": "audit_id",
    "log_audit_breweries": "audit_id",
    "log_audit_brewery_addresses": "audit_id",
    "log_audit_brewery_contacts": "audit_id"
}

total_correctos = 0
total_errores = 0

print("\nVALIDACION MYSQL VS MONGODB")
print("-" * 60)

try:

    for tabla, llave in tablas.items():

        cursor.execute(f"SELECT * FROM {tabla}")
        registros = cursor.fetchall()

        coleccion = mongo_db[tabla]

        correctos = 0
        errores = 0

        for registro in registros:

            documento = coleccion.find_one(
                {"_id": registro[llave]}
            )

            if documento is None:
                errores += 1
                continue

            documento.pop("_id")

            for campo, valor in registro.items():

                if isinstance(valor, Decimal):
                    registro[campo] = Decimal128(valor)

            if registro == documento:
                correctos += 1
            else:
                errores += 1

        ids_mysql = {registro[llave] for registro in registros}
        ids_mongo = set(coleccion.distinct("_id"))

        sobrantes = len(ids_mongo - ids_mysql)
        errores += sobrantes

        print(
            f"{tabla}: "
            f"Correctos = {correctos} | "
            f"Errores = {errores}"
        )

        total_correctos += correctos
        total_errores += errores

    print("-" * 60)
    print(f"Documentos correctos: {total_correctos}")
    print(f"Errores encontrados: {total_errores}")

    if total_errores == 0:
        print("VALIDACION EXITOSA")
    else:
        print("SE ENCONTRARON DIFERENCIAS")

finally:

    cursor.close()
    mysql_db.close()
    cliente.close()