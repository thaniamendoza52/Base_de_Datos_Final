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
-- brewery_addresses - Direcciones de las cervecerías
-- brewery_contacts - Contactos de las cervecerías
-- log_audit - Bitácora de auditoría

/*
-- DROP TABLES
DROP TABLE IF EXISTS log_audit_brewery_contacts;
DROP TABLE IF EXISTS log_audit_brewery_addresses;
DROP TABLE IF EXISTS log_audit_breweries;
DROP TABLE IF EXISTS log_audit_brewery_types;
DROP TABLE IF EXISTS log_audit_cities;
DROP TABLE IF EXISTS log_audit_states_provinces;
DROP TABLE IF EXISTS log_audit_countries;
DROP TABLE IF EXISTS brewery_contacts;
DROP TABLE IF EXISTS brewery_addresses;
DROP TABLE IF EXISTS breweries;
DROP TABLE IF EXISTS brewery_types;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS states_provinces;
DROP TABLE IF EXISTS countries;
*/


-- 1. TABLA: COUNTRIES
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE
);

-- 2. TABLA: STATES_PROVINCES
CREATE TABLE states_provinces (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(100),
    country_id INT,
    UNIQUE (state_name, country_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- 3. TABLA: CITIES
CREATE TABLE cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100),
    state_id INT,
    UNIQUE (city_name, state_id),
    FOREIGN KEY (state_id) REFERENCES states_provinces(state_id)
);

-- 4. TABLA: BREWERY_TYPES
CREATE TABLE brewery_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE
);

-- 5. TABLA: BREWERIES
CREATE TABLE breweries (
    brewery_id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES brewery_types(type_id)
);

-- 6. TABLA: BREWERY_ADDRESSES
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
CREATE TABLE brewery_contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,
    brewery_id VARCHAR(36) UNIQUE,
    phone VARCHAR(30),
    website_url VARCHAR(255),
    FOREIGN KEY (brewery_id) REFERENCES breweries(brewery_id)
);


----- TABLAS DE AUDITORIAS

-- 8. TABLA: LOG_AUDIT_COUNTRIES
CREATE TABLE log_audit_countries (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20),
date_time DATETIME,
user VARCHAR(100)
);

-- 9. TABLA: LOG_AUDIT_STATES_PROVINCES
CREATE TABLE log_audit_states_provinces (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20),
date_time DATETIME,
user VARCHAR(100)
);

-- 10. TABLA: LOG_AUDIT_CITIES
CREATE TABLE log_audit_cities (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20),
date_time DATETIME,
user VARCHAR(100)
);

-- 11. TABLA: LOG_AUDIT_BREWERY_TYPES
CREATE TABLE log_audit_brewery_types (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20),
date_time DATETIME,
user VARCHAR(100)
);

-- 12. TABLA: LOG_AUDIT_BREWERIES
CREATE TABLE log_audit_breweries (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20),
date_time DATETIME,
user VARCHAR(100)
);

-- 13. TABLA: LOG_AUDIT_BREWERY_ADDRESSES
CREATE TABLE log_audit_brewery_addresses (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20),
date_time DATETIME ,
user VARCHAR(100)
);

-- 14. TABLA: LOG_AUDIT_BREWERY_CONTACTS
CREATE TABLE log_audit_brewery_contacts (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
entity VARCHAR(50),
action VARCHAR(20) ,
date_time DATETIME,
user VARCHAR(100)
);

SET FOREIGN_KEY_CHECKS = 1;

SELECT * FROM  brewery_addresses;

/*
-- DROP TRIGGERS
-- countries
DROP TRIGGER IF EXISTS log_insert_countries;
DROP TRIGGER IF EXISTS log_update_countries;
DROP TRIGGER IF EXISTS log_delete_countries;
-- states_provinces
DROP TRIGGER IF EXISTS log_insert_states_provinces;
DROP TRIGGER IF EXISTS log_update_states_provinces;
DROP TRIGGER IF EXISTS log_delete_states_provinces;
-- cities
DROP TRIGGER IF EXISTS log_insert_cities;
DROP TRIGGER IF EXISTS log_update_cities;
DROP TRIGGER IF EXISTS log_delete_cities;
-- brewery_types
DROP TRIGGER IF EXISTS log_insert_brewery_types;
DROP TRIGGER IF EXISTS log_update_brewery_types;
DROP TRIGGER IF EXISTS log_delete_brewery_types;
-- breweries
DROP TRIGGER IF EXISTS log_insert_breweries;
DROP TRIGGER IF EXISTS log_update_breweries;
DROP TRIGGER IF EXISTS log_delete_breweries;
-- brewery_addresses
DROP TRIGGER IF EXISTS log_insert_brewery_addresses;
DROP TRIGGER IF EXISTS log_update_brewery_addresses;
DROP TRIGGER IF EXISTS log_delete_brewery_addresses;
-- brewery_contacts
DROP TRIGGER IF EXISTS log_insert_brewery_contacts;
DROP TRIGGER IF EXISTS log_update_brewery_contacts;
DROP TRIGGER IF EXISTS log_delete_brewery_contacts;
*/


-- TRIGGERS

--  ENTIDAD: countries 
-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_countries
AFTER INSERT ON countries
FOR EACH ROW
BEGIN
INSERT INTO log_audit_countries (entity, action, date_time, user)
VALUES ('countries','INSERT',  NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_countries
AFTER UPDATE ON countries
FOR EACH ROW
BEGIN
INSERT INTO log_audit_countries (entity,action, date_time, user)
VALUES ('countries',  'UPDATE', NOW(), USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_countries
AFTER DELETE ON countries
FOR EACH ROW
BEGIN
INSERT INTO log_audit_countries (entity,action, date_time, user)
VALUES ('countries', 'DELETE',NOW(), USER());
END //
DELIMITER ;


-- ENTIDAD: states_provinces 
-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_states_provinces
AFTER INSERT ON states_provinces
FOR EACH ROW
BEGIN
INSERT INTO log_audit_states_provinces (entity, action, date_time, user)
VALUES ('states_provinces', 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_states_provinces
AFTER UPDATE ON states_provinces
FOR EACH ROW
BEGIN
INSERT INTO log_audit_states_provinces (entity, action, date_time, user)
VALUES ('states_provinces', 'UPDATE', NOW(), USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_states_provinces
AFTER DELETE ON states_provinces
FOR EACH ROW
BEGIN
INSERT INTO log_audit_states_provinces (entity, action, date_time, user)
VALUES ('states_provinces', 'DELETE', NOW(), USER());
END //
DELIMITER ;


-- ENTIDAD: cities
-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_cities
AFTER INSERT ON cities
FOR EACH ROW
BEGIN
INSERT INTO log_audit_cities(entity, action, date_time, user)
VALUES ('cities','INSERT',NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_cities
AFTER UPDATE ON cities
FOR EACH ROW
BEGIN
INSERT INTO log_audit_cities (entity, action, date_time, user)
VALUES ('cities','UPDATE',NOW(),USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_cities
AFTER DELETE ON cities
FOR EACH ROW
BEGIN
INSERT INTO log_audit_cities (entity,action, date_time, user)
VALUES ('cities', 'DELETE', NOW(), USER());
END //
DELIMITER ;


-- ENTIDAD: brewery_types
-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_brewery_types
AFTER INSERT ON brewery_types
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_types (entity, action, date_time, user)
VALUES ('brewery_types', 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_brewery_types
AFTER UPDATE ON brewery_types
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_types (entity, action, date_time, user)
VALUES ('brewery_types', 'UPDATE', NOW(), USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_brewery_types
AFTER DELETE ON brewery_types
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_types (entity, action, date_time, user)
VALUES ('brewery_types', 'DELETE', NOW(), USER());
END //
DELIMITER ;


-- ENTIDAD: breweries
-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_breweries
AFTER INSERT ON breweries
FOR EACH ROW
BEGIN
INSERT INTO log_audit_breweries (entity, action, date_time, user)
VALUES ('breweries', 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_breweries
AFTER UPDATE ON breweries
FOR EACH ROW
BEGIN
INSERT INTO log_audit_breweries (entity, action, date_time, user)
VALUES ('breweries', 'UPDATE', NOW(), USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_breweries
AFTER DELETE ON breweries
FOR EACH ROW
BEGIN
INSERT INTO log_audit_breweries (entity, action, date_time, user)
VALUES ('breweries', 'DELETE', NOW(), USER());
END //
DELIMITER ;


-- ENTIDAD: brewery_addresses
-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_brewery_addresses
AFTER INSERT ON brewery_addresses
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_addresses (entity, action, date_time, user)
VALUES ('brewery_addresses', 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_brewery_addresses
AFTER UPDATE ON brewery_addresses
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_addresses (entity, action, date_time, user)
VALUES ('brewery_addresses', 'UPDATE', NOW(), USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_brewery_addresses
AFTER DELETE ON brewery_addresses
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_addresses (entity, action, date_time, user)
VALUES ('brewery_addresses', 'DELETE', NOW(), USER());
END //
DELIMITER ;


-- ENTIDAD: brewery_contacts

-- INSERT
DELIMITER //
CREATE TRIGGER log_insert_brewery_contacts
AFTER INSERT ON brewery_contacts
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_contacts (entity, action, date_time, user)
VALUES ('brewery_contacts', 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER log_update_brewery_contacts
AFTER UPDATE ON brewery_contacts
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_contacts (entity, action, date_time, user)
VALUES ('brewery_contacts', 'UPDATE', NOW(), USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER log_delete_brewery_contacts
AFTER DELETE ON brewery_contacts
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_contacts (entity, action, date_time, user)
VALUES ('brewery_contacts', 'DELETE', NOW(), USER());
END //
DELIMITER ;


/*
-- DROP STORED PROCEDURES
-- COUNTRIES
DROP PROCEDURE IF EXISTS SP_GET_ALL_COUNTRIES;
DROP PROCEDURE IF EXISTS SP_GET_BY_COUNTRY_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_COUNTRIES;
DROP PROCEDURE IF EXISTS SP_UPDATE_COUNTRIES;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_COUNTRIES;
DROP PROCEDURE IF EXISTS SP_DELETE_COUNTRIES;
-- STATES_PROVINCES
DROP PROCEDURE IF EXISTS SP_GET_ALL_STATES_PROVINCES;
DROP PROCEDURE IF EXISTS SP_GET_BY_STATE_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_STATES_PROVINCES;
DROP PROCEDURE IF EXISTS SP_UPDATE_STATES_PROVINCES;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_STATES_PROVINCES;
DROP PROCEDURE IF EXISTS SP_DELETE_STATES_PROVINCES;
-- CITIES
DROP PROCEDURE IF EXISTS SP_GET_ALL_CITIES;
DROP PROCEDURE IF EXISTS SP_GET_BY_CITIES_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_CITIES;
DROP PROCEDURE IF EXISTS SP_UPDATE_CITIES;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_CITIES;
DROP PROCEDURE IF EXISTS SP_DELETE_CITIES;
-- BREWERY_TYPES
DROP PROCEDURE IF EXISTS SP_GET_ALL_BREWERY_TYPES;
DROP PROCEDURE IF EXISTS SP_GET_BY_TYPE_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_BREWERY_TYPES;
DROP PROCEDURE IF EXISTS SP_UPDATE_BREWERY_TYPES;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_BREWERY_TYPES;
DROP PROCEDURE IF EXISTS SP_DELETE_BREWERY_TYPES;
-- BREWERIES
DROP PROCEDURE IF EXISTS SP_GET_ALL_BREWERIES;
DROP PROCEDURE IF EXISTS SP_GET_BY_BREWERY_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_BREWERIES;
DROP PROCEDURE IF EXISTS SP_UPDATE_BREWERIES;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_BREWERIES;
DROP PROCEDURE IF EXISTS SP_DELETE_BREWERIES;
-- BREWERY_ADDRESSES
DROP PROCEDURE IF EXISTS SP_GET_ALL_BREWERY_ADDRESSES;
DROP PROCEDURE IF EXISTS SP_GET_BY_ADDRESS_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_BREWERY_ADDRESSES;
DROP PROCEDURE IF EXISTS SP_UPDATE_BREWERY_ADDRESSES;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_BREWERY_ADDRESSES;
DROP PROCEDURE IF EXISTS SP_DELETE_BREWERY_ADDRESSES;
-- BREWERY_CONTACTS
DROP PROCEDURE IF EXISTS SP_GET_ALL_BREWERY_CONTACTS;
DROP PROCEDURE IF EXISTS SP_GET_BY_CONTACT_ID;
DROP PROCEDURE IF EXISTS SP_INSERT_BREWERY_CONTACTS;
DROP PROCEDURE IF EXISTS SP_UPDATE_BREWERY_CONTACTS;
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_BREWERY_CONTACTS;
DROP PROCEDURE IF EXISTS SP_DELETE_BREWERY_CONTACTS;
*/



-- STORED PROCEDURE

--  ENTIDAD: countries
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_COUNTRIES()
BEGIN
SELECT * FROM countries;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_COUNTRY_ID(
IN p_country_id INT
)
BEGIN
SELECT * FROM countries WHERE country_id = p_country_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_COUNTRIES(
IN p_country_name VARCHAR(100)
)
BEGIN
INSERT INTO countries(country_name)
VALUES (p_country_name);
END //
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_COUNTRIES(
IN p_country_id INT,
IN p_country_name VARCHAR(100)
)
BEGIN
UPDATE countries
SET country_name = p_country_name
WHERE country_id = p_country_id;
END //
DELIMITER ;

-- Delete all 
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_COUNTRIES()
BEGIN
DELETE FROM countries;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_COUNTRIES(
IN p_country_id INT
)
BEGIN
DELETE FROM countries
WHERE country_id = p_country_id;
END //
DELIMITER ;


--  ENTIDAD: states_provinces 
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_STATES_PROVINCES()
BEGIN
SELECT* FROM states_provinces;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_STATE_ID(
IN p_state_id INT
)
BEGIN
SELECT * FROM states_provinces WHERE state_id= p_state_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_STATES_PROVINCES(
IN p_state_name VARCHAR(100),
IN p_country_id INT
)
BEGIN
INSERT INTO states_provinces(state_name, country_id)
VALUES(p_state_name, p_country_id);
END//
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_STATES_PROVINCES (
IN p_state_id INT,
IN p_state_name VARCHAR(100),
IN p_country_id INT
)
BEGIN
UPDATE states_provinces
SET state_name = p_state_name, country_id = p_country_id
WHERE state_id = p_state_id;
END//
DELIMITER ;

-- Delete all
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_STATES_PROVINCES()
BEGIN
DELETE FROM states_provinces;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_STATES_PROVINCES(
IN p_state_id INT
)
BEGIN
DELETE FROM states_provinces
WHERE state_id = p_state_id;
END//
DELIMITER ;


--   ENTIDAD: cities
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_CITIES ()
BEGIN
SELECT * FROM cities;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_CITIES_ID(
IN p_city_id INT
)
BEGIN
SELECT * FROM cities WHERE city_id = p_city_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_CITIES(
IN p_city_name VARCHAR(100),
IN p_state_id INT
)
BEGIN
INSERT INTO cities(city_name, state_id)
VALUES (p_city_name, p_state_id);
END //
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_CITIES(
IN p_city_id INT,
IN p_city_name VARCHAR (100),
IN p_state_id INT
)
BEGIN
UPDATE cities
SET city_name = p_city_name, state_id = p_state_id
WHERE city_id = p_city_id;
END //
DELIMITER ;

-- Delete all
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_CITIES()
BEGIN
DELETE FROM cities;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_CITIES(
IN p_city_id INT
)
BEGIN
DELETE FROM cities
WHERE city_id = p_city_id;
END //
DELIMITER ;


--  ENTIDAD: brewery_types
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_BREWERY_TYPES()
BEGIN
SELECT * FROM brewery_types;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_TYPE_ID(
IN p_type_id INT
)
BEGIN
SELECT * FROM brewery_types WHERE type_id = p_type_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_BREWERY_TYPES(
IN p_type_name VARCHAR(50)
)
BEGIN
INSERT INTO brewery_types(type_name)
VALUES (p_type_name);
END //
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_BREWERY_TYPES(
IN p_type_id INT,
IN p_type_name VARCHAR(50)
)
BEGIN
UPDATE brewery_types
SET type_name = p_type_name
WHERE type_id = p_type_id;
END //
DELIMITER ;

-- Delete all
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_BREWERY_TYPES()
BEGIN
DELETE FROM brewery_types;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_BREWERY_TYPES(
IN p_type_id INT
)
BEGIN
DELETE FROM brewery_types
WHERE type_id = p_type_id;
END //
DELIMITER ;


--  ENTIDAD: breweries
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_BREWERIES()
BEGIN
SELECT * FROM breweries;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_BREWERY_ID(
IN p_brewery_id VARCHAR(36)
)
BEGIN
SELECT * FROM breweries WHERE brewery_id = p_brewery_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_BREWERIES(
IN p_brewery_id VARCHAR(36),
IN p_name VARCHAR(200),
IN p_type_id INT
)
BEGIN
INSERT INTO breweries(brewery_id, name, type_id)
VALUES (p_brewery_id, p_name, p_type_id);
END //
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_BREWERIES(
IN p_brewery_id VARCHAR(36),
IN p_name VARCHAR(200),
IN p_type_id INT
)
BEGIN
UPDATE breweries
SET name = p_name, type_id = p_type_id
WHERE brewery_id = p_brewery_id;
END //
DELIMITER ;

-- Delete all
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_BREWERIES()
BEGIN
DELETE FROM breweries;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_BREWERIES(
IN p_brewery_id VARCHAR(36)
)
BEGIN
DELETE FROM breweries
WHERE brewery_id = p_brewery_id;
END //
DELIMITER ;


--  ENTIDAD: brewery_addresses
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_BREWERY_ADDRESSES()
BEGIN
SELECT * FROM brewery_addresses;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_ADDRESS_ID(
IN p_address_id INT
)
BEGIN
SELECT * FROM brewery_addresses WHERE address_id = p_address_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_BREWERY_ADDRESSES(
IN p_brewery_id VARCHAR(36),
IN p_city_id INT,
IN p_street VARCHAR(200),
IN p_postal_code VARCHAR(20),
IN p_latitude DECIMAL(10, 7),
IN p_longitude DECIMAL(10, 7)
)
BEGIN
INSERT INTO brewery_addresses(brewery_id, city_id, street, postal_code, latitude, longitude)
VALUES (p_brewery_id, p_city_id, p_street, p_postal_code, p_latitude, p_longitude);
END //
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_BREWERY_ADDRESSES(
IN p_address_id INT,
IN p_brewery_id VARCHAR(36),
IN p_city_id INT,
IN p_street VARCHAR(200),
IN p_postal_code VARCHAR(20),
IN p_latitude DECIMAL(10, 7),
IN p_longitude DECIMAL(10, 7)
)
BEGIN
UPDATE brewery_addresses
SET brewery_id = p_brewery_id, city_id = p_city_id, street = p_street,
    postal_code = p_postal_code, latitude = p_latitude, longitude = p_longitude
WHERE address_id = p_address_id;
END //
DELIMITER ;

-- Delete all
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_BREWERY_ADDRESSES()
BEGIN
DELETE FROM brewery_addresses;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_BREWERY_ADDRESSES(
IN p_address_id INT
)
BEGIN
DELETE FROM brewery_addresses
WHERE address_id = p_address_id;
END //
DELIMITER ;


--  ENTIDAD: brewery_contacts
-- Get all
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_BREWERY_CONTACTS()
BEGIN
SELECT * FROM brewery_contacts;
END //
DELIMITER ;

-- Get by id
DELIMITER //
CREATE PROCEDURE SP_GET_BY_CONTACT_ID(
IN p_contact_id INT
)
BEGIN
SELECT * FROM brewery_contacts WHERE contact_id = p_contact_id;
END //
DELIMITER ;

-- Insert
DELIMITER //
CREATE PROCEDURE SP_INSERT_BREWERY_CONTACTS(
IN p_brewery_id VARCHAR(36),
IN p_phone VARCHAR(30),
IN p_website_url VARCHAR(255)
)
BEGIN
INSERT INTO brewery_contacts(brewery_id, phone, website_url)
VALUES (p_brewery_id, p_phone, p_website_url);
END //
DELIMITER ;

-- Update
DELIMITER //
CREATE PROCEDURE SP_UPDATE_BREWERY_CONTACTS(
IN p_contact_id INT,
IN p_brewery_id VARCHAR(36),
IN p_phone VARCHAR(30),
IN p_website_url VARCHAR(255)
)
BEGIN
UPDATE brewery_contacts
SET brewery_id = p_brewery_id, phone = p_phone, website_url = p_website_url
WHERE contact_id = p_contact_id;
END //
DELIMITER ;

-- Delete all
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_BREWERY_CONTACTS()
BEGIN
DELETE FROM brewery_contacts;
END //
DELIMITER ;

-- Delete by id
DELIMITER //
CREATE PROCEDURE SP_DELETE_BREWERY_CONTACTS(
IN p_contact_id INT
)
BEGIN
DELETE FROM brewery_contacts
WHERE contact_id = p_contact_id;
END //
DELIMITER ;



/*
-- DROP VIEWS 
DROP VIEW IF EXISTS view_brewery_details;
DROP VIEW IF EXISTS view_brewery_ranking_by_country;
*/

/* 
# 1 DESCRIPCION: Vista encargada de juntar el detalle completo de cada cerveceria 
su nombre, categoria, ubicacion geografica completa y medios de contacto para su lectura en reportes.
*/

CREATE VIEW view_brewery_details AS
SELECT 
b.brewery_id AS id,
b.name AS brewery_name,
bt.type_name AS brewery_type,
ba.street AS street,
ba.postal_code AS postal_code,
c.city_name AS city,
sp.state_name AS state_province,
co.country_name AS country,
bc.phone AS phone,
bc.website_url AS website_url
FROM breweries b
JOIN brewery_types bt ON b.type_id = bt.type_id
JOIN brewery_addresses ba ON b.brewery_id = ba.brewery_id
JOIN cities c ON ba.city_id = c.city_id
JOIN states_provinces sp ON c.state_id = sp.state_id
JOIN countries co ON sp.country_id = co.country_id
LEFT JOIN brewery_contacts bc ON b.brewery_id = bc.brewery_id;



/* 
#2  DESCRIPCION: Vista encargada de contabilizar y ordenar de mayor a menor el total de 
cervecerias registradas por pais para poder encontrar las zonas con mayor concentracion de cervecerias.
*/

CREATE VIEW view_brewery_ranking_by_country AS
SELECT 
co.country_name AS country,
COUNT(b.brewery_id) AS total_breweries
FROM countries co
JOIN states_provinces sp ON co.country_id = sp.country_id
JOIN cities c ON sp.state_id = c.state_id
JOIN brewery_addresses ba ON c.city_id = ba.city_id
JOIN breweries b ON ba.brewery_id = b.brewery_id
GROUP BY co.country_id, co.country_name
ORDER BY total_breweries DESC;



/*
-- DROP USERS 
DROP USER IF EXISTS 'administrador'@'localhost';
DROP USER IF EXISTS 'analista'@'localhost';
DROP USER IF EXISTS 'usuario'@'localhost';

REVOKE DELETE ON bd_cervecerias.* FROM 'analista'@'localhost';
REVOKE DELETE ON bd_cervecerias.* FROM 'administrador'@'localhost';
REVOKE DELETE ON bd_cervecerias.* FROM 'usuario'@'localhost';
*/

CREATE USER IF NOT EXISTS 'administrador'@'localhost' IDENTIFIED BY '123456';
CREATE USER IF NOT EXISTS 'analista'@'localhost' IDENTIFIED BY '123456';
CREATE USER IF NOT EXISTS 'usuario'@'localhost' IDENTIFIED BY '123456';


-- GRANT - PERMISOS

-- Administrador - acceso total a toda la base de datos
GRANT ALL PRIVILEGES ON bd_cervecerias.* TO 'administrador'@'localhost';

-- Analista - acceso a toda la base  (SELECT, INSERT, UPDATE, DELETE)
GRANT SELECT, INSERT, UPDATE, DELETE ON bd_cervecerias.* TO 'analista'@'localhost';

-- Usuario - solo consulta
GRANT SELECT ON bd_cervecerias.* TO 'usuario'@'localhost';


-- ver permisos
SHOW GRANTS FOR 'administrador'@'localhost';
SHOW GRANTS FOR 'analista'@'localhost';
SHOW GRANTS FOR 'usuario'@'localhost';


-- CALL DE PRUEBAS
-- INSERT
CALL SP_INSERT_COUNTRIES('United States');
CALL SP_INSERT_STATES_PROVINCES('California', 1);
CALL SP_INSERT_CITIES('San Diego', 1);
CALL SP_INSERT_BREWERY_TYPES('micro');
CALL SP_INSERT_BREWERIES('b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0', 'Stone Brewing', 1);
CALL SP_INSERT_BREWERY_ADDRESSES('b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0', 1, '1999 Citracado feffd', '92029', 33.116000, 117.1195000);
CALL SP_INSERT_BREWERY_CONTACTS('b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0', '7OO-OO4-7866', 'https://ww.stonebrewing.com');


-- GET ALL
CALL SP_GET_ALL_COUNTRIES();
CALL SP_GET_ALL_STATES_PROVINCES();
CALL SP_GET_ALL_CITIES();
CALL SP_GET_ALL_BREWERY_TYPES();
CALL SP_GET_ALL_BREWERIES();
CALL SP_GET_ALL_BREWERY_ADDRESSES();
CALL SP_GET_ALL_BREWERY_CONTACTS();

-- GET BY ID
CALL SP_GET_BY_COUNTRY_ID(1);
CALL SP_GET_BY_STATE_ID(1);
CALL SP_GET_BY_CITIES_ID(1);
CALL SP_GET_BY_TYPE_ID(1);
CALL SP_GET_BY_BREWERY_ID('b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0');
CALL SP_GET_BY_ADDRESS_ID(1);
CALL SP_GET_BY_CONTACT_ID(1);

-- UPDATE
CALL SP_UPDATE_COUNTRIES(1, 'Estados Unidos');
CALL SP_UPDATE_STATES_PROVINCES(1, 'California', 1);
CALL SP_UPDATE_CITIES(1, 'Escondido', 1);
CALL SP_UPDATE_BREWERY_TYPES(1, 'regional');
CALL SP_UPDATE_BREWERIES('b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0', 'Stone Brewing Co.', 1);
CALL SP_UPDATE_BREWERY_ADDRESSES(1, 'b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0', 1, '1999 Citracado Pkwy', '92029', 33.1156000, -117.1195000);
CALL SP_UPDATE_BREWERY_CONTACTS(1, 'b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0', '7999-294-7899', 'https://www.stonebrewing.com');

/*
-- DELETE BY ID 
CALL SP_DELETE_BREWERY_CONTACTS(1);
CALL SP_DELETE_BREWERY_ADDRESSES(1);
CALL SP_DELETE_BREWERIES('b54b16e1-ac3b-4bff-a11f-f7ae9ddc27e0');
CALL SP_DELETE_BREWERY_TYPES(1);
CALL SP_DELETE_CITIES(1);
CALL SP_DELETE_STATES_PROVINCES(1);
CALL SP_DELETE_COUNTRIES(1);

-- DELETE ALL 
CALL SP_DELETE_ALL_BREWERY_CONTACTS();
CALL SP_DELETE_ALL_BREWERY_ADDRESSES();
CALL SP_DELETE_ALL_BREWERIES();
CALL SP_DELETE_ALL_BREWERY_TYPES();
CALL SP_DELETE_ALL_CITIES();
CALL SP_DELETE_ALL_STATES_PROVINCES();
CALL SP_DELETE_ALL_COUNTRIES();
*/


-- TRIGGER
SELECT * FROM log_audit_countries;
SELECT * FROM log_audit_states_provinces;
SELECT * FROM log_audit_cities;
SELECT * FROM log_audit_brewery_types;
SELECT * FROM log_audit_breweries;
SELECT * FROM log_audit_brewery_addresses;
SELECT * FROM log_audit_brewery_contacts;

-- VISTAS
SELECT * FROM view_brewery_details;
SELECT * FROM view_brewery_ranking_by_country;

