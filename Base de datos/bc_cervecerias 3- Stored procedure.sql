USE bd_cervecerias;


-- STORED PROCEDURE

--  ENTIDAD: brewery_addresses
-- Get all
DROP PROCEDURE IF EXISTS SP_GET_ALL_BREWERY_ADDRESSES;
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_BREWERY_ADDRESSES()
BEGIN
SELECT * FROM brewery_addresses;
END //
DELIMITER ;

-- Get by id
DROP PROCEDURE IF EXISTS SP_GET_BY_ADDRESS_ID;
DELIMITER //
CREATE PROCEDURE SP_GET_BY_ADDRESS_ID(
IN p_address_id INT
)
BEGIN
SELECT * FROM brewery_addresses WHERE address_id = p_address_id;
END //
DELIMITER ;

-- Insert
DROP PROCEDURE IF EXISTS SP_INSERT_BREWERY_ADDRESSES;
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
DROP PROCEDURE IF EXISTS SP_UPDATE_BREWERY_ADDRESSES;
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
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_BREWERY_ADDRESSES;
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_BREWERY_ADDRESSES()
BEGIN
DELETE FROM brewery_addresses;
END //
DELIMITER ;

-- Delete by id
DROP PROCEDURE IF EXISTS SP_DELETE_BREWERY_ADDRESSES;
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
DROP PROCEDURE IF EXISTS SP_GET_ALL_BREWERY_CONTACTS;
DELIMITER //
CREATE PROCEDURE SP_GET_ALL_BREWERY_CONTACTS()
BEGIN
SELECT * FROM brewery_contacts;
END //
DELIMITER ;

-- Get by id
DROP PROCEDURE IF EXISTS SP_GET_BY_CONTACT_ID;
DELIMITER //
CREATE PROCEDURE SP_GET_BY_CONTACT_ID(
IN p_contact_id INT
)
BEGIN
SELECT * FROM brewery_contacts WHERE contact_id = p_contact_id;
END //
DELIMITER ;

-- Insert
DROP PROCEDURE IF EXISTS SP_INSERT_BREWERY_CONTACTS;
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
DROP PROCEDURE IF EXISTS SP_UPDATE_BREWERY_CONTACTS;
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
DROP PROCEDURE IF EXISTS SP_DELETE_ALL_BREWERY_CONTACTS;
DELIMITER //
CREATE PROCEDURE SP_DELETE_ALL_BREWERY_CONTACTS()
BEGIN
DELETE FROM brewery_contacts;
END //
DELIMITER ;

-- Delete by id
DROP PROCEDURE IF EXISTS SP_DELETE_BREWERY_CONTACTS;
DELIMITER //
CREATE PROCEDURE SP_DELETE_BREWERY_CONTACTS(
IN p_contact_id INT
)
BEGIN
DELETE FROM brewery_contacts
WHERE contact_id = p_contact_id;
END //
DELIMITER ;
