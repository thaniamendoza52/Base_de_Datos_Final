DROP DATABASE IF EXISTS bd_cervecerias;
CREATE DATABASE bd_cervecerias;
USE bd_cervecerias;

SET FOREIGN_KEY_CHECKS = 0;

-- ENTIDADES
-- countries - Países
-- states_provinces - Estados o provincias
-- cities - Ciudades
-- brewery_types - Tipos de cervecería
-- breweries - Cervecerías (entidad principal)
-- brewery_addresses - Direcciones de las cerveceríasbreweries
-- brewery_contacts - Contactos de las cervecerías
-- log_audit - Bitácora de auditoría


-- 1. TABLA: COUNTRIES
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE
);

-- 2. TABLA: STATES_PROVINCES
DROP TABLE IF EXISTS states_provinces;
CREATE TABLE states_provinces (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(100),
    country_id INT,
    UNIQUE (state_name, country_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- 3. TABLA: CITIES
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100),
    state_id INT,
    UNIQUE (city_name, state_id),
    FOREIGN KEY (state_id) REFERENCES states_provinces(state_id)
);

-- 4. TABLA: BREWERY_TYPES
DROP TABLE IF EXISTS brewery_types;
CREATE TABLE brewery_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE
);

-- 5. TABLA: BREWERIES
DROP TABLE IF EXISTS breweries;
CREATE TABLE breweries (
    brewery_id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES brewery_types(type_id)
);

-- 6. TABLA: BREWERY_ADDRESSES
DROP TABLE IF EXISTS brewery_addresses;
CREATE TABLE brewery_addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    brewery_id VARCHAR(36) UNIQUE,
    city_id INT,
    street VARCHAR(200),
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- 7. TABLA: BREWERY_CONTACTS
DROP TABLE IF EXISTS brewery_contacts;
CREATE TABLE brewery_contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    brewery_id VARCHAR(36) UNIQUE,
    phone VARCHAR(30),
    website_url VARCHAR(255),
    FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id)
);

-- 8. TABLA: LOG_AUDIT
DROP TABLE IF EXISTS log_audit;
CREATE TABLE log_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(50),
    action VARCHAR(20),
    date_time DATETIME,
    user VARCHAR(100)
);


SET FOREIGN_KEY_CHECKS = 1;



