import streamlit as st
import pandas as pd
import plotly.express as px
from conexion import conectar, validar_usuario
from conexion_mongodb import conectar_mongodb
from getpass import getpass

# CONFIGURACION DE LA PAGINA
st.set_page_config(
    page_title="Brewery Management System",
    page_icon="🍺",
    layout="wide"
)


# ESTILOS
st.markdown("""
<style>

    /* OPCIONES DE RADIO */
    [data-testid="stRadio"] label,
    [data-testid="stRadio"] label p,
    [data-testid="stRadio"] label span {
        color: #FFFFFF !important;
    }

    /* CASILLAS DE CONFIRMACION */
    [data-testid="stCheckbox"] label,
    [data-testid="stCheckbox"] label p {
        color: #FFFFFF !important;
    }

    /* FONDO PRINCIPAL */
    .stApp,
    [data-testid="stAppViewContainer"],
    [data-testid="stMain"] {
        background-color: #171717 !important;
        color: #FFFFFF !important;
    }

    /* ENCABEZADO */
    [data-testid="stHeader"] {
        background-color: #171717 !important;
    }

    /* MENU LATERAL */
    [data-testid="stSidebar"] {
        background-color: #262626 !important;
    }

    [data-testid="stSidebar"] p,
    [data-testid="stSidebar"] label,
    [data-testid="stSidebar"] span {
        color: #FFFFFF !important;
    }

    /* TITULOS */
    h1, h2, h3 {
        color: #E9B44C !important;
    }

    /* TARJETAS DEL DASHBOARD */
    [data-testid="stMetric"] {
        background-color: #292929;
        border: 1px solid #59451F;
        padding: 15px;
        border-radius: 10px;
    }

    [data-testid="stMetricLabel"] p {
        color: #FFFFFF !important;
    }

    [data-testid="stMetricValue"] {
        color: #E9B44C !important;
    }

    /* ETIQUETAS */
    [data-testid="stWidgetLabel"] p {
        color: #FFFFFF !important;
    }

    [data-testid="stCaptionContainer"] p {
        color: #BDBDBD !important;
    }

    /* FORMULARIOS */
    [data-testid="stForm"] {
        background-color: #262626 !important;
        border: 1px solid #59451F !important;
        border-radius: 12px;
        padding: 20px;
    }

    /* BOTONES */
    .stButton button,
    .stFormSubmitButton button {
        background-color: #E9B44C !important;
        color: #171717 !important;
        border: 1px solid #E9B44C !important;
        border-radius: 8px;
        font-weight: bold;
    }

    .stButton button p,
    .stFormSubmitButton button p,
    [data-testid="stSidebar"] button p,
    [data-testid="stSidebar"] button span {
        color: #171717 !important;
    }

    .stButton button:hover,
    .stFormSubmitButton button:hover {
        background-color: #C99A38 !important;
    }
    /* MENSAJE DE CONEXION MYSQL */
    [data-testid="stSidebar"] [data-testid="stAlert"] p {
        color: #16803C !important;
        font-weight: bold;
    }
</style>
""", unsafe_allow_html=True)

# INICIO DE SESION
if "autenticado" not in st.session_state:
    st.session_state.autenticado = False


if not st.session_state.autenticado:

    col1, col2, col3 = st.columns([1, 2, 1])

    with col2:

        st.title("🍺 Brewery Management System")
        st.subheader("Iniciar sesión")

        with st.form("formulario_login"):

            usuario = st.selectbox(
                "Usuario",
                ["administrador", "analista", "usuario"]
            )

            contrasena = st.text_input(
                "Contraseña",
                type="password"
            )

            ingresar = st.form_submit_button(
                "Iniciar sesión",
                use_container_width=True
            )

            if ingresar:

                if validar_usuario(usuario, contrasena):

                    st.session_state.autenticado = True
                    st.session_state.usuario = usuario
                    st.session_state.contrasena = contrasena

                    st.rerun()

                else:
                    st.error("Usuario o contraseña incorrectos")

        st.caption("Proyecto final de Base de Datos")

    st.stop()

# FUNCION PARA REALIZAR CONSULTAS
def consultar(sql, parametros=None):
    conexion = conectar()
    cursor = conexion.cursor(dictionary=True)

    try:
        cursor.execute(sql, parametros or ())
        datos = cursor.fetchall()
        return pd.DataFrame(datos)
    finally:
        cursor.close()
        conexion.close()

# FUNCION PARA EJECUTAR PROCEDIMIENTOS ALMACENADOS
def ejecutar_procedimiento(nombre, parametros=()):

    conexion = conectar()
    cursor = conexion.cursor(dictionary=True)

    try:
        cursor.callproc(nombre, parametros)

        datos = []

        for resultado in cursor.stored_results():
            datos.extend(resultado.fetchall())

        conexion.commit()

        return pd.DataFrame(datos)

    except Exception:
        conexion.rollback()
        raise

    finally:
        cursor.close()
        conexion.close()

# FUNCION PARA CONTAR REGISTROS
def contar(tabla):
    resultado = consultar(
        f"SELECT COUNT(*) AS total FROM {tabla}"
    )
    return int(resultado["total"].iloc[0])


# TITULO PRINCIPAL
st.title("🍺 Brewery Management System")
st.caption("Sistema de gestión de bases de datos de cervecerías")


# MENU LATERAL
st.sidebar.title("🍺 Brewery System")
# USUARIO ACTUAL
st.sidebar.write(
    f"Usuario: {st.session_state.usuario}"
)

roles = {
    "administrador": "Administrador",
    "analista": "Analista",
    "usuario": "Solo consulta"
}

st.sidebar.caption(
    f"Rol: {roles[st.session_state.usuario]}"
)

# CERRAR SESION
if st.sidebar.button(
    "Cerrar sesión",
    use_container_width=True
):
    st.session_state.clear()
    st.rerun()
st.sidebar.markdown("---")

opcion = st.sidebar.radio(
    "Menú principal",
    [
        "Inicio",
        "Cervecerías",
        "Países",
        "Estados y provincias",
        "Ciudades",
        "Tipos de cervecerías",
        "Direcciones",
        "Contactos",
        "Reportes",
        "Auditoría",
        "MongoDB"
    ]
)

st.sidebar.markdown("---")
st.sidebar.caption("Proyecto final de Base de Datos")


try:

    # INICIO
    if opcion == "Inicio":

        st.header("Panel general")

        st.write(
            "Bienvenido al sistema de administración "
            "y consulta de cervecerías."
        )

        col1, col2, col3 = st.columns(3)

        col1.metric("Cervecerías", contar("breweries"))
        col2.metric("Países", contar("countries"))
        col3.metric("Ciudades", contar("cities"))

        col4, col5, col6 = st.columns(3)

        col4.metric("Tipos", contar("brewery_types"))
        col5.metric("Direcciones", contar("brewery_addresses"))
        col6.metric("Contactos", contar("brewery_contacts"))

        st.markdown("---")
        st.subheader("Resumen de registros")

        tablas = {
            "Países": "countries",
            "Estados": "states_provinces",
            "Ciudades": "cities",
            "Tipos": "brewery_types",
            "Cervecerías": "breweries",
            "Direcciones": "brewery_addresses",
            "Contactos": "brewery_contacts"
        }

        resumen = pd.DataFrame({
            "Entidad": list(tablas.keys()),
            "Registros": [
                contar(tabla) for tabla in tablas.values()
            ]
        })

        grafica = px.bar(
            resumen,
            x="Registros",
            y="Entidad",
            orientation="h",
            text="Registros",
            color_discrete_sequence=["#E9B44C"],
            template="plotly_dark"
        )

        st.plotly_chart(grafica, use_container_width=True)


    # CERVECERIAS
    elif opcion == "Cervecerías":

        import uuid

        st.header("Catálogo de cervecerías")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERIES"
        )

        tipos = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERY_TYPES"
        )

        catalogo_tipos = {
            int(fila["type_id"]): fila["type_name"]
            for _, fila in tipos.iterrows()
        }

        # CONSULTAR
        if accion == "Consultar":

            busqueda = st.text_input(
                "Buscar cervecería por nombre"
            )

            resultado = consultar(
                """
                SELECT *
                FROM view_brewery_details
                WHERE brewery_name LIKE %s
                ORDER BY brewery_name
                """,
                (f"%{busqueda}%",)
            )

            st.dataframe(
                resultado,
                use_container_width=True,
                hide_index=True
            )

            st.subheader("Registros de cervecerías")

            st.dataframe(
                datos,
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar cervecería")

            with st.form("agregar_cerveceria"):

                nombre = st.text_input(
                    "Nombre de la cervecería",
                    max_chars=200
                )

                id_tipo = st.selectbox(
                    "Tipo de cervecería",
                    list(catalogo_tipos.keys()),
                    format_func=lambda x: catalogo_tipos[x]
                )

                if st.form_submit_button("Guardar cervecería"):

                    if nombre.strip() and id_tipo is not None:

                        id_cerveceria = str(uuid.uuid4())

                        ejecutar_procedimiento(
                            "SP_INSERT_BREWERIES",
                            (
                                id_cerveceria,
                                nombre.strip(),
                                int(id_tipo)
                            )
                        )

                        st.success(
                            "Cervecería agregada correctamente"
                        )

                        st.info(
                            "Puedes registrar su dirección y contacto "
                            "en los módulos correspondientes."
                        )

                    else:
                        st.warning("Completa los campos requeridos")

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar cervecería")

            if datos.empty:

                st.info("No hay cervecerías registradas")

            else:

                id_cerveceria = st.selectbox(
                    "Selecciona la cervecería",
                    datos["brewery_id"].tolist(),
                    format_func=lambda x: (
                        datos.loc[
                            datos["brewery_id"] == x,
                            "name"
                        ].iloc[0] + f" ({x})"
                    )
                )

                cerveceria = datos.loc[
                    datos["brewery_id"] == id_cerveceria
                ].iloc[0]

                lista_tipos = list(catalogo_tipos.keys())

                with st.form(f"modificar_cerveceria_{id_cerveceria}"):

                    nuevo_nombre = st.text_input(
                        "Nuevo nombre",
                        value=cerveceria["name"],
                        max_chars=200
                    )

                    nuevo_tipo = st.selectbox(
                        "Tipo de cervecería",
                        lista_tipos,
                        index=lista_tipos.index(
                            int(cerveceria["type_id"])
                        ),
                        format_func=lambda x: catalogo_tipos[x]
                    )

                    if st.form_submit_button("Guardar cambios"):

                        if nuevo_nombre.strip():

                            ejecutar_procedimiento(
                                "SP_UPDATE_BREWERIES",
                                (
                                    id_cerveceria,
                                    nuevo_nombre.strip(),
                                    int(nuevo_tipo)
                                )
                            )

                            st.success(
                                "Cervecería modificada correctamente"
                            )

                        else:
                            st.warning("Ingresa un nombre válido")

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar cervecería")

            if datos.empty:

                st.info("No hay cervecerías registradas")

            else:

                id_cerveceria = st.selectbox(
                    "Selecciona la cervecería",
                    datos["brewery_id"].tolist(),
                    format_func=lambda x: (
                        datos.loc[
                            datos["brewery_id"] == x,
                            "name"
                        ].iloc[0] + f" ({x})"
                    )
                )

                st.warning(
                    "La eliminación puede estar restringida "
                    "si existen direcciones o contactos asociados."
                )

                confirmar = st.checkbox(
                    "Confirmo que deseo eliminar esta cervecería",
                    key=f"confirmar_cerveceria_{id_cerveceria}"
                )

                if st.button(
                    "Eliminar cervecería",
                    disabled=not confirmar
                ):

                    ejecutar_procedimiento(
                        "SP_DELETE_BREWERIES",
                        (id_cerveceria,)
                    )

                    st.success(
                        "Cervecería eliminada correctamente"
                    )

    # PAISES
    elif opcion == "Países":

        st.header("Catálogo de países")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento("SP_GET_ALL_COUNTRIES")

        # CONSULTAR
        if accion == "Consultar":

            st.dataframe(
                datos,
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar país")

            with st.form("agregar_pais"):

                nombre = st.text_input("Nombre del país")

                if st.form_submit_button("Guardar país"):

                    if nombre.strip():

                        ejecutar_procedimiento(
                            "SP_INSERT_COUNTRIES",
                            (nombre.strip(),)
                        )

                        st.success("País agregado correctamente")

                    else:
                        st.warning("Ingresa el nombre del país")

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar país")

            pais = st.selectbox(
                "Selecciona el país",
                datos["country_name"].tolist()
            )

            id_pais = int(
                datos.loc[
                    datos["country_name"] == pais,
                    "country_id"
                ].iloc[0]
            )

            with st.form("modificar_pais"):

                nuevo_nombre = st.text_input(
                    "Nuevo nombre",
                    value=pais
                )

                if st.form_submit_button("Guardar cambios"):

                    if nuevo_nombre.strip():

                        ejecutar_procedimiento(
                            "SP_UPDATE_COUNTRIES",
                            (id_pais, nuevo_nombre.strip())
                        )

                        st.success("País modificado correctamente")

                    else:
                        st.warning("Ingresa un nombre válido")

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar país")

            pais = st.selectbox(
                "Selecciona el país",
                datos["country_name"].tolist()
            )

            id_pais = int(
                datos.loc[
                    datos["country_name"] == pais,
                    "country_id"
                ].iloc[0]
            )

            st.warning(
                "Esta operación eliminará el registro seleccionado."
            )

            confirmar = st.checkbox(
                "Confirmo que deseo eliminar este país"
            )

            if st.button("Eliminar país", disabled=not confirmar):
                ejecutar_procedimiento(
                    "SP_DELETE_COUNTRIES",
                    (id_pais,)
                )

                st.success("País eliminado correctamente")

    # ESTADOS Y PROVINCIAS
    elif opcion == "Estados y provincias":

        st.header("Estados y provincias")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento(
            "SP_GET_ALL_STATES_PROVINCES"
        )

        paises = ejecutar_procedimiento(
            "SP_GET_ALL_COUNTRIES"
        )

        catalogo_paises = dict(zip(
            paises["country_name"],
            paises["country_id"]
        ))

        # CONSULTAR
        if accion == "Consultar":

            resultado = datos.merge(
                paises,
                on="country_id",
                how="left"
            )

            st.dataframe(
                resultado[[
                    "state_id",
                    "state_name",
                    "country_name"
                ]],
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar estado o provincia")

            with st.form("agregar_estado"):

                nombre = st.text_input(
                    "Nombre del estado o provincia"
                )

                pais = st.selectbox(
                    "País",
                    list(catalogo_paises.keys())
                )

                if st.form_submit_button("Guardar estado"):

                    if nombre.strip():

                        ejecutar_procedimiento(
                            "SP_INSERT_STATES_PROVINCES",
                            (
                                nombre.strip(),
                                int(catalogo_paises[pais])
                            )
                        )

                        st.success("Estado agregado correctamente")

                    else:
                        st.warning("Ingresa el nombre del estado")

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar estado o provincia")

            id_estado = st.selectbox(
                "Selecciona el estado",
                datos["state_id"].tolist(),
                format_func=lambda x: (
                    datos.loc[
                        datos["state_id"] == x,
                        "state_name"
                    ].iloc[0] + f" (ID: {x})"
                )
            )

            estado = datos.loc[
                datos["state_id"] == id_estado
            ].iloc[0]

            lista_paises = list(catalogo_paises.keys())

            pais_actual = paises.loc[
                paises["country_id"] == estado["country_id"],
                "country_name"
            ].iloc[0]

            with st.form(f"modificar_estado_{id_estado}"):

                nuevo_nombre = st.text_input(
                    "Nuevo nombre",
                    value=estado["state_name"]
                )

                nuevo_pais = st.selectbox(
                    "País",
                    lista_paises,
                    index=lista_paises.index(pais_actual)
                )

                if st.form_submit_button("Guardar cambios"):

                    if nuevo_nombre.strip():

                        ejecutar_procedimiento(
                            "SP_UPDATE_STATES_PROVINCES",
                            (
                                int(id_estado),
                                nuevo_nombre.strip(),
                                int(catalogo_paises[nuevo_pais])
                            )
                        )

                        st.success("Estado modificado correctamente")

                    else:
                        st.warning("Ingresa un nombre válido")

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar estado o provincia")

            id_estado = st.selectbox(
                "Selecciona el estado",
                datos["state_id"].tolist(),
                format_func=lambda x: (
                    datos.loc[
                        datos["state_id"] == x,
                        "state_name"
                    ].iloc[0] + f" (ID: {x})"
                )
            )

            st.warning(
                "Esta operación eliminará el estado seleccionado."
            )

            confirmar = st.checkbox(
                "Confirmo que deseo eliminar este estado",
                key=f"confirmar_estado_{id_estado}"
            )

            if st.button("Eliminar estado", disabled=not confirmar):

                ejecutar_procedimiento(
                    "SP_DELETE_STATES_PROVINCES",
                    (int(id_estado),)
                )

                st.success("Estado eliminado correctamente")


    # CIUDADES
    elif opcion == "Ciudades":

        st.header("Catálogo de ciudades")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento(
            "SP_GET_ALL_CITIES"
        )

        estados = ejecutar_procedimiento(
            "SP_GET_ALL_STATES_PROVINCES"
        )

        paises = ejecutar_procedimiento(
            "SP_GET_ALL_COUNTRIES"
        )

        estados = estados.merge(
            paises,
            on="country_id",
            how="left"
        )

        catalogo_estados = {
            int(fila["state_id"]):
            f'{fila["state_name"]} - {fila["country_name"]}'
            for _, fila in estados.iterrows()
        }

        # CONSULTAR
        if accion == "Consultar":

            resultado = datos.merge(
                estados,
                on="state_id",
                how="left"
            )

            st.dataframe(
                resultado[[
                    "city_id",
                    "city_name",
                    "state_name",
                    "country_name"
                ]],
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar ciudad")

            with st.form("agregar_ciudad"):

                nombre = st.text_input(
                    "Nombre de la ciudad",
                    max_chars=100
                )

                id_estado = st.selectbox(
                    "Estado o provincia",
                    list(catalogo_estados.keys()),
                    format_func=lambda x: catalogo_estados[x]
                )

                if st.form_submit_button("Guardar ciudad"):

                    if nombre.strip():

                        ejecutar_procedimiento(
                            "SP_INSERT_CITIES",
                            (
                                nombre.strip(),
                                int(id_estado)
                            )
                        )

                        st.success("Ciudad agregada correctamente")

                    else:
                        st.warning("Ingresa el nombre de la ciudad")

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar ciudad")

            id_ciudad = st.selectbox(
                "Selecciona la ciudad",
                datos["city_id"].tolist(),
                format_func=lambda x: (
                    datos.loc[
                        datos["city_id"] == x,
                        "city_name"
                    ].iloc[0] + f" (ID: {x})"
                )
            )

            ciudad = datos.loc[
                datos["city_id"] == id_ciudad
            ].iloc[0]

            lista_estados = list(catalogo_estados.keys())

            with st.form(f"modificar_ciudad_{id_ciudad}"):

                nuevo_nombre = st.text_input(
                    "Nuevo nombre",
                    value=ciudad["city_name"],
                    max_chars=100
                )

                nuevo_estado = st.selectbox(
                    "Estado o provincia",
                    lista_estados,
                    index=lista_estados.index(
                        int(ciudad["state_id"])
                    ),
                    format_func=lambda x: catalogo_estados[x]
                )

                if st.form_submit_button("Guardar cambios"):

                    if nuevo_nombre.strip():

                        ejecutar_procedimiento(
                            "SP_UPDATE_CITIES",
                            (
                                int(id_ciudad),
                                nuevo_nombre.strip(),
                                int(nuevo_estado)
                            )
                        )

                        st.success("Ciudad modificada correctamente")

                    else:
                        st.warning("Ingresa un nombre válido")

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar ciudad")

            id_ciudad = st.selectbox(
                "Selecciona la ciudad",
                datos["city_id"].tolist(),
                format_func=lambda x: (
                    datos.loc[
                        datos["city_id"] == x,
                        "city_name"
                    ].iloc[0] + f" (ID: {x})"
                )
            )

            st.warning(
                "Esta operación eliminará la ciudad seleccionada."
            )

            confirmar = st.checkbox(
                "Confirmo que deseo eliminar esta ciudad",
                key=f"confirmar_ciudad_{id_ciudad}"
            )

            if st.button("Eliminar ciudad", disabled=not confirmar):

                ejecutar_procedimiento(
                    "SP_DELETE_CITIES",
                    (int(id_ciudad),)
                )

                st.success("Ciudad eliminada correctamente")


    # TIPOS DE CERVECERIAS
    elif opcion == "Tipos de cervecerías":

        st.header("Catálogo de tipos de cervecerías")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERY_TYPES"
        )

        # CONSULTAR
        if accion == "Consultar":

            st.dataframe(
                datos,
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar tipo de cervecería")

            with st.form("agregar_tipo"):

                nombre = st.text_input(
                    "Nombre del tipo de cervecería",
                    max_chars=50
                )

                if st.form_submit_button("Guardar tipo"):

                    if nombre.strip():

                        ejecutar_procedimiento(
                            "SP_INSERT_BREWERY_TYPES",
                            (nombre.strip(),)
                        )

                        st.success("Tipo agregado correctamente")

                    else:
                        st.warning("Ingresa el nombre del tipo")

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar tipo de cervecería")

            if datos.empty:
                st.info("No hay tipos registrados")

            else:

                tipo = st.selectbox(
                    "Selecciona el tipo",
                    datos["type_name"].tolist()
                )

                id_tipo = int(datos.loc[
                    datos["type_name"] == tipo,
                    "type_id"
                ].iloc[0])

                with st.form(f"modificar_tipo_{id_tipo}"):

                    nuevo_nombre = st.text_input(
                        "Nuevo nombre",
                        value=tipo,
                        max_chars=50
                    )

                    if st.form_submit_button("Guardar cambios"):

                        if nuevo_nombre.strip():

                            ejecutar_procedimiento(
                                "SP_UPDATE_BREWERY_TYPES",
                                (
                                    id_tipo,
                                    nuevo_nombre.strip()
                                )
                            )

                            st.success("Tipo modificado correctamente")

                        else:
                            st.warning("Ingresa un nombre válido")

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar tipo de cervecería")

            if datos.empty:
                st.info("No hay tipos registrados")

            else:

                tipo = st.selectbox(
                    "Selecciona el tipo",
                    datos["type_name"].tolist()
                )

                id_tipo = int(datos.loc[
                    datos["type_name"] == tipo,
                    "type_id"
                ].iloc[0])

                st.warning(
                    "Esta operación eliminará el tipo seleccionado."
                )

                confirmar = st.checkbox(
                    "Confirmo que deseo eliminar este tipo",
                    key=f"confirmar_tipo_{id_tipo}"
                )

                if st.button("Eliminar tipo", disabled=not confirmar):

                    ejecutar_procedimiento(
                        "SP_DELETE_BREWERY_TYPES",
                        (id_tipo,)
                    )

                    st.success("Tipo eliminado correctamente")


    # DIRECCIONES
    elif opcion == "Direcciones":

        st.header("Catálogo de direcciones")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERY_ADDRESSES"
        )

        cervecerias = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERIES"
        )

        ciudades = ejecutar_procedimiento(
            "SP_GET_ALL_CITIES"
        )

        estados = ejecutar_procedimiento(
            "SP_GET_ALL_STATES_PROVINCES"
        )

        paises = ejecutar_procedimiento(
            "SP_GET_ALL_COUNTRIES"
        )

        ubicaciones = ciudades.merge(
            estados, on="state_id", how="left"
        ).merge(
            paises, on="country_id", how="left"
        )

        catalogo_cervecerias = {
            fila["brewery_id"]: fila["name"]
            for _, fila in cervecerias.iterrows()
        }

        catalogo_ciudades = {
            int(fila["city_id"]):
                f'{fila["city_name"]} - {fila["state_name"]} - {fila["country_name"]}'
            for _, fila in ubicaciones.iterrows()
        }

        # CONSULTAR
        if accion == "Consultar":

            resultado = consultar(
                """
                SELECT
                    ba.address_id,
                    b.name AS brewery_name,
                    c.city_name,
                    sp.state_name,
                    co.country_name,
                    ba.street,
                    ba.postal_code,
                    ba.latitude,
                    ba.longitude
                FROM brewery_addresses ba
                JOIN breweries b
                    ON ba.brewery_id = b.brewery_id
                JOIN cities c
                    ON ba.city_id = c.city_id
                JOIN states_provinces sp
                    ON c.state_id = sp.state_id
                JOIN countries co
                    ON sp.country_id = co.country_id
                ORDER BY b.name
                """
            )

            st.dataframe(
                resultado,
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar dirección")

            ocupadas = set(
                datos["brewery_id"].tolist()
            ) if not datos.empty else set()

            disponibles = [
                x for x in catalogo_cervecerias
                if x not in ocupadas
            ]

            if not disponibles:

                st.info(
                    "Todas las cervecerías ya tienen una dirección."
                )

            else:

                with st.form("agregar_direccion"):

                    id_cerveceria = st.selectbox(
                        "Cervecería",
                        disponibles,
                        format_func=lambda x: catalogo_cervecerias[x]
                    )

                    id_ciudad = st.selectbox(
                        "Ciudad",
                        list(catalogo_ciudades.keys()),
                        format_func=lambda x: catalogo_ciudades[x]
                    )

                    calle = st.text_input(
                        "Calle",
                        max_chars=200
                    )

                    codigo_postal = st.text_input(
                        "Código postal",
                        max_chars=20
                    )

                    latitude = st.number_input(
                        "Latitud",
                        min_value=-90.0,
                        max_value=90.0,
                        value=None,
                        format="%.7f"
                    )

                    longitude = st.number_input(
                        "Longitud",
                        min_value=-180.0,
                        max_value=180.0,
                        value=None,
                        format="%.7f"
                    )

                    if st.form_submit_button("Guardar dirección"):
                        ejecutar_procedimiento(
                            "SP_INSERT_BREWERY_ADDRESSES",
                            (
                                id_cerveceria,
                                int(id_ciudad),
                                calle.strip() or None,
                                codigo_postal.strip() or None,
                                latitude,
                                longitude
                            )
                        )

                        st.success("Dirección agregada correctamente")

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar dirección")

            if datos.empty:

                st.info("No hay direcciones registradas")

            else:

                id_direccion = st.selectbox(
                    "Selecciona la dirección",
                    datos["address_id"].tolist(),
                    format_func=lambda x: (
                            catalogo_cervecerias[
                                datos.loc[
                                    datos["address_id"] == x,
                                    "brewery_id"
                                ].iloc[0]
                            ] + f" (ID: {x})"
                    )
                )

                direccion = datos.loc[
                    datos["address_id"] == id_direccion
                    ].iloc[0]

                lista_ciudades = list(catalogo_ciudades.keys())

                with st.form(f"modificar_direccion_{id_direccion}"):

                    st.write(
                        "Cervecería:",
                        catalogo_cervecerias[direccion["brewery_id"]]
                    )

                    nueva_ciudad = st.selectbox(
                        "Ciudad",
                        lista_ciudades,
                        index=lista_ciudades.index(
                            int(direccion["city_id"])
                        ),
                        format_func=lambda x: catalogo_ciudades[x]
                    )

                    nueva_calle = st.text_input(
                        "Calle",
                        value=str(direccion["street"])
                        if pd.notna(direccion["street"]) else "",
                        max_chars=200
                    )

                    nuevo_codigo = st.text_input(
                        "Código postal",
                        value=str(direccion["postal_code"])
                        if pd.notna(direccion["postal_code"]) else "",
                        max_chars=20
                    )

                    nueva_latitud = st.number_input(
                        "Latitud",
                        min_value=-90.0,
                        max_value=90.0,
                        value=float(direccion["latitude"])
                        if pd.notna(direccion["latitude"]) else None,
                        format="%.7f"
                    )

                    nueva_longitud = st.number_input(
                        "Longitud",
                        min_value=-180.0,
                        max_value=180.0,
                        value=float(direccion["longitude"])
                        if pd.notna(direccion["longitude"]) else None,
                        format="%.7f"
                    )

                    if st.form_submit_button("Guardar cambios"):
                        ejecutar_procedimiento(
                            "SP_UPDATE_BREWERY_ADDRESSES",
                            (
                                int(id_direccion),
                                direccion["brewery_id"],
                                int(nueva_ciudad),
                                nueva_calle.strip() or None,
                                nuevo_codigo.strip() or None,
                                nueva_latitud,
                                nueva_longitud
                            )
                        )

                        st.success("Dirección modificada correctamente")

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar dirección")

            if datos.empty:

                st.info("No hay direcciones registradas")

            else:

                id_direccion = st.selectbox(
                    "Selecciona la dirección",
                    datos["address_id"].tolist(),
                    format_func=lambda x: (
                            catalogo_cervecerias[
                                datos.loc[
                                    datos["address_id"] == x,
                                    "brewery_id"
                                ].iloc[0]
                            ] + f" (ID: {x})"
                    )
                )

                st.warning(
                    "Esta operación eliminará la dirección seleccionada."
                )

                confirmar = st.checkbox(
                    "Confirmo que deseo eliminar esta dirección",
                    key=f"confirmar_direccion_{id_direccion}"
                )

                if st.button(
                        "Eliminar dirección",
                        disabled=not confirmar
                ):
                    ejecutar_procedimiento(
                        "SP_DELETE_BREWERY_ADDRESSES",
                        (int(id_direccion),)
                    )

                    st.success("Dirección eliminada correctamente")

    # CONTACTOS
    elif opcion == "Contactos":

        st.header("Catálogo de contactos")

        opciones = ["Consultar"]

        if st.session_state.usuario in ["administrador", "analista"]:
            opciones.extend(["Agregar", "Modificar", "Eliminar"])

        accion = st.radio(
            "Selecciona una operación",
            opciones,
            horizontal=True
        )

        datos = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERY_CONTACTS"
        )

        cervecerias = ejecutar_procedimiento(
            "SP_GET_ALL_BREWERIES"
        )

        catalogo_cervecerias = {
            fila["brewery_id"]: fila["name"]
            for _, fila in cervecerias.iterrows()
        }

        # CONSULTAR
        if accion == "Consultar":

            resultado = consultar(
                """
                SELECT
                    bc.contact_id,
                    b.name AS brewery_name,
                    bc.phone,
                    bc.website_url
                FROM brewery_contacts bc
                JOIN breweries b
                    ON bc.brewery_id = b.brewery_id
                ORDER BY b.name
                """
            )

            st.dataframe(
                resultado,
                use_container_width=True,
                hide_index=True
            )

        # AGREGAR
        elif accion == "Agregar":

            st.subheader("Agregar contacto")

            ocupadas = set(
                datos["brewery_id"].tolist()
            ) if not datos.empty else set()

            disponibles = [
                x for x in catalogo_cervecerias
                if x not in ocupadas
            ]

            if not disponibles:

                st.info(
                    "Todas las cervecerías ya tienen contacto."
                )

            else:

                with st.form("agregar_contacto"):

                    id_cerveceria = st.selectbox(
                        "Cervecería",
                        disponibles,
                        format_func=lambda x: catalogo_cervecerias[x]
                    )

                    telefono = st.text_input(
                        "Teléfono",
                        max_chars=30
                    )

                    sitio_web = st.text_input(
                        "Sitio web",
                        max_chars=255
                    )

                    if st.form_submit_button("Guardar contacto"):

                        if telefono.strip() or sitio_web.strip():

                            ejecutar_procedimiento(
                                "SP_INSERT_BREWERY_CONTACTS",
                                (
                                    id_cerveceria,
                                    telefono.strip() or None,
                                    sitio_web.strip() or None
                                )
                            )

                            st.success(
                                "Contacto agregado correctamente"
                            )

                        else:
                            st.warning(
                                "Ingresa un teléfono o sitio web"
                            )

        # MODIFICAR
        elif accion == "Modificar":

            st.subheader("Modificar contacto")

            if datos.empty:

                st.info("No hay contactos registrados")

            else:

                id_contacto = st.selectbox(
                    "Selecciona el contacto",
                    datos["contact_id"].tolist(),
                    format_func=lambda x: (
                        catalogo_cervecerias[
                            datos.loc[
                                datos["contact_id"] == x,
                                "brewery_id"
                            ].iloc[0]
                        ] + f" (ID: {x})"
                    )
                )

                contacto = datos.loc[
                    datos["contact_id"] == id_contacto
                ].iloc[0]

                with st.form(f"modificar_contacto_{id_contacto}"):

                    st.write(
                        "Cervecería:",
                        catalogo_cervecerias[contacto["brewery_id"]]
                    )

                    nuevo_telefono = st.text_input(
                        "Teléfono",
                        value=str(contacto["phone"])
                        if pd.notna(contacto["phone"]) else "",
                        max_chars=30
                    )

                    nuevo_sitio = st.text_input(
                        "Sitio web",
                        value=str(contacto["website_url"])
                        if pd.notna(contacto["website_url"]) else "",
                        max_chars=255
                    )

                    if st.form_submit_button("Guardar cambios"):

                        if nuevo_telefono.strip() or nuevo_sitio.strip():

                            ejecutar_procedimiento(
                                "SP_UPDATE_BREWERY_CONTACTS",
                                (
                                    int(id_contacto),
                                    contacto["brewery_id"],
                                    nuevo_telefono.strip() or None,
                                    nuevo_sitio.strip() or None
                                )
                            )

                            st.success(
                                "Contacto modificado correctamente"
                            )

                        else:
                            st.warning(
                                "Ingresa un teléfono o sitio web"
                            )

        # ELIMINAR
        elif accion == "Eliminar":

            st.subheader("Eliminar contacto")

            if datos.empty:

                st.info("No hay contactos registrados")

            else:

                id_contacto = st.selectbox(
                    "Selecciona el contacto",
                    datos["contact_id"].tolist(),
                    format_func=lambda x: (
                        catalogo_cervecerias[
                            datos.loc[
                                datos["contact_id"] == x,
                                "brewery_id"
                            ].iloc[0]
                        ] + f" (ID: {x})"
                    )
                )

                st.warning(
                    "Esta operación eliminará el contacto seleccionado."
                )

                confirmar = st.checkbox(
                    "Confirmo que deseo eliminar este contacto",
                    key=f"confirmar_contacto_{id_contacto}"
                )

                if st.button(
                    "Eliminar contacto",
                    disabled=not confirmar
                ):

                    ejecutar_procedimiento(
                        "SP_DELETE_BREWERY_CONTACTS",
                        (int(id_contacto),)
                    )

                    st.success("Contacto eliminado correctamente")

    # REPORTES
    elif opcion == "Reportes":

        st.header("Reportes y estadísticas")

        st.subheader("Cervecerías por tipo")

        datos_tipos = consultar("""
            SELECT
                t.type_name AS tipo,
                COUNT(b.brewery_id) AS total
            FROM brewery_types t
            LEFT JOIN breweries b
                ON t.type_id = b.type_id
            GROUP BY t.type_id, t.type_name
            ORDER BY total DESC
        """)

        grafica_tipos = px.pie(
            datos_tipos,
            names="tipo",
            values="total",
            hole=0.4,
            template="plotly_dark"
        )

        st.plotly_chart(
            grafica_tipos,
            use_container_width=True
        )

        st.subheader("Cervecerías por país")

        datos_paises = consultar("""
            SELECT
                country AS pais,
                total_breweries AS total
            FROM view_brewery_ranking_by_country
            ORDER BY total DESC
        """)

        grafica_paises = px.bar(
            datos_paises,
            x="pais",
            y="total",
            text="total",
            color_discrete_sequence=["#E9B44C"],
            template="plotly_dark"
        )

        st.plotly_chart(
            grafica_paises,
            use_container_width=True
        )


    # AUDITORIA
    elif opcion == "Auditoría":

        st.header("Bitácora de auditoría")

        auditorias = {
            "Países": "log_audit_countries",
            "Estados": "log_audit_states_provinces",
            "Ciudades": "log_audit_cities",
            "Tipos": "log_audit_brewery_types",
            "Cervecerías": "log_audit_breweries",
            "Direcciones": "log_audit_brewery_addresses",
            "Contactos": "log_audit_brewery_contacts"
        }

        entidad = st.selectbox(
            "Selecciona una entidad",
            list(auditorias.keys())
        )

        tabla = auditorias[entidad]

        datos = consultar(
            f"SELECT * FROM {tabla} ORDER BY date_time DESC"
        )

        if datos.empty:
            st.info("No hay registros de auditoría todavía.")
        else:
            st.dataframe(
                datos,
                use_container_width=True,
                hide_index=True
            )


    # MONGODB
    elif opcion == "MongoDB":

        st.header("Base de datos NoSQL - MongoDB")
        st.write("Consulta de las colecciones migradas desde MySQL.")
        st.caption("Solo consulta. Los cambios en MySQL no se sincronizan automáticamente.")

        mongo_db = conectar_mongodb()

        try:
            colecciones = sorted(mongo_db.list_collection_names())
            total_documentos = sum(
                mongo_db[nombre].count_documents({})
                for nombre in colecciones
            )

            col1, col2, col3 = st.columns(3)
            col1.metric("Colecciones", len(colecciones))
            col2.metric("Documentos", total_documentos)
            col3.metric("Motor", "MongoDB")

            st.divider()
            st.subheader("Consultar colecciones")

            if not colecciones:
                st.info("No hay colecciones disponibles.")
            else:
                seleccion = st.selectbox("Selecciona una colección", colecciones)
                documentos = list(mongo_db[seleccion].find())
                st.metric("Documentos de la colección", len(documentos))

                if documentos:
                    tabla = pd.DataFrame([
                        {campo: str(valor) if valor is not None else None
                         for campo, valor in documento.items()}
                        for documento in documentos
                    ])
                    busqueda = st.text_input("Buscar dentro de la colección")

                    if busqueda:
                        filtro = tabla.apply(
                            lambda columna: columna.astype(str).str.contains(
                                busqueda, case=False, regex=False, na=False
                            )
                        ).any(axis=1)
                        tabla = tabla[filtro]

                    st.dataframe(tabla, use_container_width=True, hide_index=True)
                    st.caption(f"Resultados encontrados: {len(tabla)}")
                else:
                    st.info("Esta colección no contiene documentos.")

            st.sidebar.success("MongoDB conectado")

        finally:
            mongo_db.client.close()

    if opcion != "MongoDB":
        st.sidebar.success("MySQL conectado")


except Exception as error:
    st.sidebar.error("Error en la base de datos")
    st.error(f"Se produjo un error: {error}")
