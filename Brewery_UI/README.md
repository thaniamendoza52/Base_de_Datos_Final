# Brewery Management System

## Descripción del proyecto

Sistema de gestión y consulta de bases de datos de cervecerías, desarrollado como proyecto final de la materia de Base de Datos.

El sistema permite administrar información mediante una interfaz gráfica desarrollada en Python y Streamlit, utilizando MySQL como base de datos relacional y MongoDB como base de datos NoSQL.

## Tecnologías utilizadas

- Python
- MySQL
- MongoDB
- Streamlit
- Pandas
- Plotly
- PyCharm
- GitHub

## Funcionalidades

- Inicio y cierre de sesión.
- Control de acceso mediante usuarios y permisos.
- Operaciones CRUD.
- Procedimientos almacenados.
- Vistas y triggers.
- Bitácoras de auditoría.
- Reportes y gráficas.
- Migración de MySQL a MongoDB.
- Validación de datos migrados.
- Consulta de colecciones NoSQL.

## Instalación

Instalar las dependencias mediante el comando:

```bash
python -m pip install -r requirements.txt
```

Contar con MySQL y MongoDB instalados y en ejecución.

Crear la base de datos bd_cervecerias utilizando los scripts SQL del proyecto y configurar los usuarios correspondientes.

## Ejecución del sistema

```bash
python -m streamlit run app.py
```

## Migración a MongoDB

```bash
python migracion_mongodb.py
```

## Validación de datos

```bash
python validacion_mongodb.py
```

## Estructura del proyecto

- app.py: interfaz gráfica principal.
- conexion.py: conexión a MySQL.
- conexion_mongodb.py: conexión a MongoDB.
- carga_mysql.py: carga inicial de datos.
- migracion_mongodb.py: migración de datos a NoSQL.
- validacion_mongodb.py: comparación de datos.
- requirements.txt: dependencias del sistema.
- .gitignore: exclusión de archivos privados y temporales.

## Seguridad

El sistema cuenta con tres perfiles de acceso:

- Administrador.
- Analista.
- Usuario de solo consulta.

## Alcance y limitaciones

MySQL permite administrar los registros del sistema, mientras que MongoDB funciona como una base de datos de consulta.

La sincronización entre ambas bases de datos no es automática. La migración debe ejecutarse nuevamente para actualizar los registros nuevos o modificados. Los registros eliminados requieren una revisión adicional.

## Proyecto académico

Licenciatura en Inteligencia de Negocios.

Universidad Autónoma de Baja California.

2026.