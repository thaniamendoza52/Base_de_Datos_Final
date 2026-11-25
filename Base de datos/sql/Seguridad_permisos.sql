-- CONFIGURACION DE SEGURIDAD
USE bd_cervecerias;

-- Restringir la escritura directa del analista
REVOKE INSERT, UPDATE, DELETE
ON bd_cervecerias.*
FROM 'analista'@'localhost';

-- Verificar los permisos asignados
SHOW GRANTS FOR 'administrador'@'localhost';

SHOW GRANTS FOR 'analista'@'localhost';

SHOW GRANTS FOR 'usuario'@'localhost';
