USE bd_cervecerias;

-- TRIGGERS
-- ENTIDAD: brewery_addresses

-- INSERT
DROP TRIGGER IF EXISTS log_insert_brewery_addresses;
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
DROP TRIGGER IF EXISTS log_update_brewery_addresses;
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
DROP TRIGGER IF EXISTS log_delete_brewery_addresses;
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
DROP TRIGGER IF EXISTS log_insert_brewery_contacts;
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
DROP TRIGGER IF EXISTS log_update_brewery_contacts;
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
DROP TRIGGER IF EXISTS log_delete_brewery_contacts;
DELIMITER //
CREATE TRIGGER log_delete_brewery_contacts
AFTER DELETE ON brewery_contacts
FOR EACH ROW
BEGIN
INSERT INTO log_audit_brewery_contacts (entity, action, date_time, user)
VALUES ('brewery_contacts', 'DELETE', NOW(), USER());
END //
DELIMITER ;
