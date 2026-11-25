import mysql.connector
import streamlit as st


# CONEXION A MYSQL
def conectar(usuario=None, contrasena=None):

    if usuario is None:
        usuario = st.session_state.get("usuario")

    if contrasena is None:
        contrasena = st.session_state.get("contrasena")

    if not usuario or contrasena is None:
        raise ValueError("Debes iniciar sesion primero")

    conexion = mysql.connector.connect(
        host="localhost",
        port=3306,
        user=usuario,
        password=contrasena,
        database="bd_cervecerias"
    )

    return conexion


# VALIDAR CREDENCIALES
def validar_usuario(usuario, contrasena):

    try:
        conexion = conectar(usuario, contrasena)
        conexion.close()
        return True

    except mysql.connector.Error:
        return False