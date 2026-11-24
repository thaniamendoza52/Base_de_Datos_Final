USE bd_cervecerias;

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
