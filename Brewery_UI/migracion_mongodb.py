import mysql.connector
from pymongo import MongoClient, ReplaceOne
from bson.decimal128 import Decimal128
from decimal import Decimal
from getpass import getpass

# CONEXION A MYSQL
mysql_db = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="usuario",
    password="123456",
    database="bd_cervecerias"
)

cursor = mysql_db.cursor(dictionary=True)

# CONEXION A MONGODB
cliente = MongoClient(
    "mongodb://localhost:27017/",
    serverSelectionTimeoutMS=5000
)

cliente.admin.command("ping")

mongo_db = cliente["bd_cervecerias"]

# TABLAS Y LLAVES PRIMARIAS
tablas = {
    "countries": "country_id",
    "states_provinces": "state_id",
    "cities": "city_id",
    "brewery_types": "type_id",
    "breweries": "brewery_id",
    "brewery_addresses": "address_id",
    "brewery_contacts": "contact_id",

    # TABLAS DE AUDITORIA
    "log_audit_countries": "audit_id",
    "log_audit_states_provinces": "audit_id",
    "log_audit_cities": "audit_id",
    "log_audit_brewery_types": "audit_id",
    "log_audit_breweries": "audit_id",
    "log_audit_brewery_addresses": "audit_id",
    "log_audit_brewery_contacts": "audit_id"
}
total = 0

print("\nINICIANDO MIGRACION")
print("-" * 50)

try:

    for tabla, llave in tablas.items():

        # EXTRAER DATOS DE MYSQL
        cursor.execute(f"SELECT * FROM {tabla}")
        registros = cursor.fetchall()

        documentos = []

        # TRANSFORMAR DATOS
        for registro in registros:

            documento = {}

            for campo, valor in registro.items():

                if isinstance(valor, Decimal):
                    valor = Decimal128(valor)

                documento[campo] = valor

            documento["_id"] = documento[llave]

            documentos.append(documento)

        # CARGAR DATOS EN MONGODB
        if tabla not in mongo_db.list_collection_names():
            mongo_db.create_collection(tabla)

        coleccion = mongo_db[tabla]

        if documentos:

            operaciones = [
                ReplaceOne(
                    {"_id": documento["_id"]},
                    documento,
                    upsert=True
                )
                for documento in documentos
            ]

            coleccion.bulk_write(operaciones)

        cantidad = coleccion.count_documents({})

        print(
            f"{tabla}: MySQL = {len(registros)} "
            f"| MongoDB = {cantidad}"
        )

        total += cantidad

    print("-" * 50)
    print(f"Total de documentos en MongoDB: {total}")
    print("MIGRACION FINALIZADA")

finally:

    cursor.close()
    mysql_db.close()
    cliente.close()