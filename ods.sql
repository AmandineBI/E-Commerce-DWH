/*Orders*/
DROP TABLE IF EXISTS bec.ods.order_details; CREATE TABLE bec.ods.order_details (customer_id varchar(40) NOT NULL, seller_id varchar(40) NOT NULL, order_id varchar(40) NOT NULL, order_item_id int NOT NULL, product_id varchar(40) NOT NULL, order_status varchar(15), purchase_time datetime, approval_time datetime, shipping_time datetime, shipping_limit_time datetime, delivery_time datetime, estimated_delivery_date date, price decimal(10,2), freight_value decimal(10,2))
COMPOUND SORTKEY(customer_id, seller_id, order_id, order_item_id, product_id);
INSERT INTO bec.ods.order_details
SELECT COALESCE(c.customer_unique_id, o.customer_id, ''), ISNULL(seller_id, ''), o.order_id, ISNULL(order_item_id, 0), ISNULL(product_id, ''), order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, shipping_limit_date, order_delivered_customer_date, CAST(order_estimated_delivery_date AS date), price, freight_value
FROM bec.stg.olist_orders_dataset o 
LEFT OUTER JOIN bec.stg.olist_order_items_dataset i ON o.order_id = i.order_id 
LEFT OUTER JOIN bec.stg.olist_customers_dataset c ON o.customer_id = c.customer_id;

/*Geolocation */
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

/*Customers changing*/
DROP TABLE IF EXISTS bec.ods.customer; CREATE TABLE bec.ods.customer (customer_id varchar(40) NOT NULL, zip_code_prefix int, city varchar(40), state varchar(40), latitud decimal(18,15), longitud decimal(18,15), purchase_time datetime) COMPOUND SORTKEY (customer_id, purchase_time);
INSERT INTO bec.ods.customer
SELECT customer_id, customer_zip_code_prefix, g.city, g.state, g.latitud, g.longitud, purchase_time FROM (
SELECT ISNULL(c.customer_unique_id, c.customer_id) AS customer_id, customer_zip_code_prefix, CAST(MIN(o.order_purchase_timestamp) AS datetime) AS purchase_time
FROM bec.stg.olist_customers_dataset c
LEFT OUTER JOIN bec.stg.olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY ISNULL(c.customer_unique_id, c.customer_id), customer_zip_code_prefix) sub
LEFT OUTER JOIN bec.ods.geolocation g ON g.zip_code_prefix = sub.customer_zip_code_prefix;

/*Seller fixed*/
DROP TABLE IF EXISTS bec.ods.seller; CREATE TABLE bec.ods.seller (seller_id varchar(40) NOT NULL SORTKEY, zip_code_prefix int, city varchar(40), state varchar(2), latitud decimal(18,15), longitud decimal(18,15));
INSERT INTO bec.ods.seller
SELECT DISTINCT seller_id, seller_zip_code_prefix, geolocation_city, geolocation_state, geolocation_lat, geolocation_lng
FROM bec.stg.olist_sellers_dataset s
LEFT OUTER JOIN bec.stg.olist_geolocation_dataset g ON g.geolocation_zip_code_prefix = s.seller_zip_code_prefix;