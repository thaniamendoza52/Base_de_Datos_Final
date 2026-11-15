-- =====================================================
-- 01_estructura_tablas.sql
-- Proyecto Final de Base de Datos: bd_cervecerias
-- Crea la base de datos y las 8 tablas VACIAS
-- (7 tablas normalizadas + 1 tabla de auditoria)
-- =====================================================

CREATE DATABASE IF NOT EXISTS bd_cervecerias
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bd_cervecerias;

-- 1. paises
CREATE TABLE paises (
    id_pais     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL UNIQUE
);

-- 2. estados (1:N desde paises)
CREATE TABLE estados (
    id_estado     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(100) NOT NULL,
    id_pais       INT NOT NULL,
    CONSTRAINT fk_estados_pais
        FOREIGN KEY (id_pais) REFERENCES paises (id_pais)
);

-- 3. ciudades (1:N desde estados)
CREATE TABLE ciudades (
    id_ciudad     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    id_estado     INT NOT NULL,
    CONSTRAINT fk_ciudades_estado
        FOREIGN KEY (id_estado) REFERENCES estados (id_estado)
);

-- 4. tipos_cerveceria
CREATE TABLE tipos_cerveceria (
    id_tipo     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE
);

-- 5. empresas (1:N desde tipos_cerveceria)
CREATE TABLE empresas (
    id_empresa     INT AUTO_INCREMENT PRIMARY KEY,
    api_id         VARCHAR(100) NOT NULL UNIQUE,
    nombre         VARCHAR(255) NOT NULL,
    id_tipo        INT NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_empresas_tipo
        FOREIGN KEY (id_tipo) REFERENCES tipos_cerveceria (id_tipo)
);

-- 6. direcciones (1:N desde ciudades, 1:1 con empresas)
-- calle, codigo_postal, latitud y longitud aceptan NULL
CREATE TABLE direcciones (
    id_direccion  INT AUTO_INCREMENT PRIMARY KEY,
    calle         VARCHAR(255) NULL,
    codigo_postal VARCHAR(20)  NULL,
    latitud       DECIMAL(10,7) NULL,
    longitud      DECIMAL(10,7) NULL,
    id_ciudad     INT NOT NULL,
    id_empresa    INT NOT NULL UNIQUE,
    CONSTRAINT fk_direcciones_ciudad
        FOREIGN KEY (id_ciudad) REFERENCES ciudades (id_ciudad),
    CONSTRAINT fk_direcciones_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresas (id_empresa)
);

-- 7. contactos (1:1 con empresas)
-- telefono y sitio_web aceptan NULL
CREATE TABLE contactos (
    id_contacto INT AUTO_INCREMENT PRIMARY KEY,
    telefono    VARCHAR(30)  NULL,
    sitio_web   VARCHAR(255) NULL,
    id_empresa  INT NOT NULL UNIQUE,
    CONSTRAINT fk_contactos_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresas (id_empresa)
);

-- 8. audit_empresas (tabla de auditoria)
-- Sin FOREIGN KEY a proposito: asi el historial se conserva
-- aunque se elimine una empresa.
CREATE TABLE audit_empresas (
    id_audit        INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa      INT NOT NULL,
    accion          VARCHAR(20) NOT NULL,
    nombre_anterior VARCHAR(255) NULL,
    nombre_nuevo    VARCHAR(255) NULL,
    usuario         VARCHAR(100) NULL,
    fecha_cambio    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
