USE bd_cervecerias;


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

SELECT * FROM view_brewery_details;


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


SELECT * FROM view_brewery_ranking_by_country;
