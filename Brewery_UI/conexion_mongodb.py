from pymongo import MongoClient


def conectar_mongodb():

    cliente = MongoClient(
        "mongodb://localhost:27017/",
        serverSelectionTimeoutMS=5000
    )

    cliente.admin.command("ping")

    return cliente["bd_cervecerias"]