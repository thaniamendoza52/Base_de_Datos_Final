USE bd_cervecerias;

/*
-- DROP USERS 
DROP USER IF EXISTS 'administrador'@'localhost';
DROP USER IF EXISTS 'analista'@'localhost';
DROP USER IF EXISTS 'usuario'@'localhost';

REVOKE DELETE ON bd_cervecerias.* FROM 'analista'@'localhost';
REVOKE DELETE ON bd_cervecerias.* FROM 'administrador'@'localhost';
REVOKE DELETE ON bd_cervecerias.* FROM 'usuario'@'localhost';
*/

CREATE USER 'administrador'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'analista'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'usuario'@'localhost' IDENTIFIED BY '123456';


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

