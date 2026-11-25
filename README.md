# Base de Datos Relacional de Cervecerías (`bd_cervecerias`)

Proyecto de diseño, implementación y automatización de una base de datos relacional normalizada en **MySQL**, alimentada mediante un pipeline de extracción, transformación y carga (ETL) en **Python** a partir de datos limpios provenientes de una API externa de cervecerías.

---

### Arquitectura de la base de datos (MySQL)

El esquema relacional está normalizado (3FN) y se compone de 14 tablas en total:
1. **Entidades principales**
- countries: Catálogo de países (country_id, country_name).
- states_provinces: Estados o provincias asociados a su país (state_id, state_name, country_id).
- cities: Ciudades asociadas a su estado o provincia (city_id, city_name, state_id).
- brewery_types: Catálogo de categorías de cervecería (micro, brewpub, regional, contract, taproom, large, etc.).
- breweries: Entidad central con identificador UUID original y nombre (brewery_id, name, type_id).
- brewery_addresses: Ubicación física y coordenadas geográficas (street, postal_code, latitude, longitude).
- brewery_contacts: Información de contacto y sitio web (phone, website_url).

---

2. **Auditoría, programación SQL y seguridad**

7 Tablas de Auditoría + 21 Triggers: Registran de forma automática la entidad que se le realizo la operación (INSERT, UPDATE, DELETE) ademas registra la fecha y hora (NOW()) y el usuario (USER()) ante cualquier cambio en las tablas principales.

42 Procedimientos Almacenados: Estan las operaciones CRUD completas (GET_ALL, GET_BY_ID, INSERT, UPDATE, DELETE, DELETE_ALL) para cada una de las 7 entidades.

2 Vistas/Reportes:
- view_brewery_details: Consolida el perfil completo de cada cervecería (nombre, tipo, dirección completa, país, teléfono y sitio web).
- view_brewery_ranking_by_country: Ranking descendente con el conteo total de cervecerías por país.

3 Roles de seguridad:
- administrador: Control total (ALL PRIVILEGES) sobre la base de datos bd_cervecerias.
- analista: Permisos de consulta y manipulación de registros (SELECT, INSERT, UPDATE, DELETE).
- usuario: Solo acceso a realizar consultas (SELECT).


## Guía de instalación y ejecución
**Requisitos previos**
- MySQL Server 8.0+ y MySQL Workbench
- Python 3.10+ con las siguientes dependencias instaladas:

```bash
pip install pandas mysql-connector-python
```

**Paso 1: Desplegar la base de datos en MySQL**
Abre el archivo Base de datos/bd_cervecerias.sql en MySQL Workbench.

Ejecuta el script completo (Ctrl + Shift + Enter) para crear la base de datos, tablas, triggers, procedimientos almacenados, vistas, roles de usuario y correr las pruebas iniciales.

Limpiar datos de prueba antes de la carga masiva: Como MySQL Workbench bloquea borrados masivos por defecto (Error 1175: Safe Update Mode), ejecuta SET SQL_SAFE_UPDATES = 0; antes de llamar a los procedimientos CALL SP_DELETE_ALL_*() comentados al final del script (y vuelve a activarlo con SET SQL_SAFE_UPDATES = 1; al terminar la limpieza).

**Paso 2: Ejecutar la carga masiva con Python**
Verifica que las credenciales de conexión (host, user, password, database) en Base de datos/carga_mysql.py coincidan con tu servidor local de MySQL.

Desde la terminal, ubícate dentro de la carpeta Base de datos y ejecuta el script:

```bash
cd "Base de datos"
python carga_mysql.py
```

Al finalizar, el proceso poblará la base de datos con los registros normalizados (14 países, 62 estados/provincias, 185 ciudades, 10 tipos de cervecería, 200 cervecerías, 200 direcciones y 196 contactos).


## Interfaz gráfica de migración

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
cd Brewery_UI
python -m pip install -r requirements.txt
```

Contar con MySQL y MongoDB instalados y en ejecución.

Crear la base de datos bd_cervecerias utilizando los scripts SQL del proyecto y configurar los usuarios correspondientes.

## Ejecución del sistema

```bash
cd Brewery_UI
python -m streamlit run app.py
```

## Migración a MongoDB

```bash
cd Brewery_UI
python migracion_mongodb.py
```

## Validación de datos

```bash
cd Brewery_UI
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