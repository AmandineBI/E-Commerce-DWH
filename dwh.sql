/*Customer dimension*/
DROP TABLE IF EXISTS bec.dwh.d_customer; CREATE TABLE bec.dwh.d_customer (d_customer bigint identity(0,1) not null DISTKEY PRIMARY KEY, customer_id varchar(40) NOT NULL, zip_code_prefix varchar(10), city varchar(40), state varchar(40), latitud decimal(18,15), longitud decimal(18,15), valid_from date, valid_to date, valid_flag varchar(1));
INSERT INTO bec.dwh.d_customer (customer_id, zip_code_prefix , city, state, latitud, longitud, valid_from, valid_to, valid_flag)
SELECT 'Undefined', 'Undefined', 'Undefined', 'NA', NULL, NULL, CAST('20000101' AS date), CAST('99991231' AS date), 'Y';
INSERT INTO bec.dwh.d_customer (customer_id, zip_code_prefix , city, state, latitud, longitud, valid_from, valid_to, valid_flag)
SELECT c1.customer_id, ISNULL(RIGHT('0' + CAST(c1.zip_code_prefix AS varchar(5)), 5), 'Unknown'), ISNULL(c1.city, 'Unknown'), ISNULL(c1.state, 'UN'), c1.latitud, c1.longitud, CAST(c1.purchase_time AS date), ISNULL(CAST(c2.purchase_time AS date), CAST('99991231' AS date)), CASE WHEN c2.purchase_time IS NULL THEN 'Y' ELSE 'N' END
FROM bec.ods.customer c1
LEFT OUTER JOIN bec.ods.customer c2 ON c1.customer_id = c2.customer_id AND c1.serie = c2.serie - 1;


/*Seller dimension*/
DROP TABLE IF EXISTS bec.dwh.d_seller; CREATE TABLE bec.dwh.d_seller (d_seller bigint identity(0,1) NOT NULL SORTKEY PRIMARY KEY, seller_id varchar(40) NOT NULL, zip_code_prefix varchar(10), city varchar(40), state varchar(2), latitud decimal(18,15), longitud decimal(18,15));
INSERT INTO bec.dwh.d_seller (seller_id, zip_code_prefix, city, state, latitud, longitud)
SELECT 'Undefined', 'Undefined', 'Undefined', 'NA', NULL, NULL;
INSERT INTO bec.dwh.d_seller (seller_id, zip_code_prefix, city, state, latitud, longitud)
SELECT seller_id, ISNULL(RIGHT('0' + CAST(zip_code_prefix AS varchar(5)), 5), 'Unknown'), ISNULL(city, 'Unknown'), ISNULL(state, 'UN'), latitud, longitud
FROM bec.ods.seller;