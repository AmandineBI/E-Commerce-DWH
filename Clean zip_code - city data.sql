/*Geolocation*/
/*Logic: we take the city with the highest representation. Zip Codes per 50 inside of same city.*/
DROP TABLE IF EXISTS bec.ods.geolocation; CREATE TABLE bec.ods.geolocation (zip_code_prefix int SORTKEY, city varchar(40), state varchar(2), latitud decimal(18,15), longitud decimal(18,15));
INSERT INTO bec.ods.geolocation
SELECT geo.geolocation_zip_code_prefix, query.city, geo.state, geo.latitud, geo.longitud 
FROM (SELECT geolocation_zip_code_prefix, MAX(geolocation_state) AS state, MIN(geolocation_lat) AS latitud, MIN(geolocation_lng) AS longitud FROM bec.stg.olist_geolocation_dataset GROUP BY geolocation_zip_code_prefix) geo 
INNER JOIN (
SELECT zip_code_prefix50, city, weight, ROW_NUMBER() OVER(PARTITION BY zip_code_prefix50 ORDER BY weight DESC, city DESC) AS ranking FROM (
SELECT FLOOR(a.geolocation_zip_code_prefix/50) AS zip_code_prefix50, LTRIM(INITCAP(a.geolocation_city)) AS city, CAST(COUNT(a.geolocation_city) AS decimal(10,3))/CAST(MAX(b.count) AS decimal(10,3)) AS weight
FROM (SELECT DISTINCT geolocation_zip_code_prefix, REPLACE(geolocation_city, 'sao ', 'são ') AS geolocation_city FROM bec.stg.olist_geolocation_dataset) a
INNER JOIN (SELECT geolocation_zip_code_prefix/50 AS geolocation_zip_code_prefix50, COUNT(geolocation_zip_code_prefix) as Count FROM (SELECT DISTINCT geolocation_zip_code_prefix, REPLACE(geolocation_city, 'sao ', 'são ') AS geolocation_city FROM bec.stg.olist_geolocation_dataset) d GROUP BY geolocation_zip_code_prefix/50) b ON a.geolocation_zip_code_prefix/50 = b.geolocation_zip_code_prefix50
GROUP BY FLOOR(a.geolocation_zip_code_prefix/50), LTRIM(INITCAP(a.geolocation_city))
) sub) query ON geo.geolocation_zip_code_prefix >= (query.zip_code_prefix50 - 1) * 50 AND geo.geolocation_zip_code_prefix < query.zip_code_prefix50 * 50 WHERE ranking = 1
