USE bd_cervecerias;

/*
-- DROP TRIGGERS
DROP TRIGGER IF EXISTS log_insert_brewery_types;
DROP TRIGGER IF EXISTS log_update_brewery_types;
DROP TRIGGER IF EXISTS log_delete_brewery_types;
DROP TRIGGER IF EXISTS log_insert_breweries;
DROP TRIGGER IF EXISTS log_update_breweries;
DROP TRIGGER IF EXISTS log_delete_breweries;
*/


-- TRIGGERS

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