USE bd_cervecerias;


/*
-- DROP TRIGGERS
DROP TRIGGER IF EXISTS log_insert_brewery_addresses;
DROP TRIGGER IF EXISTS log_update_brewery_addresses;
DROP TRIGGER IF EXISTS log_delete_brewery_addresses;
DROP TRIGGER IF EXISTS log_insert_brewery_contacts;
DROP TRIGGER IF EXISTS log_update_brewery_contacts;
DROP TRIGGER IF EXISTS log_delete_brewery_contacts;
*/

-- TRIGGERS

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
