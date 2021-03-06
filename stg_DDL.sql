/*Replication tables from csv files stored in S3*/
/*Customers*/
DROP TABLE IF EXISTS stg.olist_customers_dataset; 
CREATE TABLE stg.olist_customers_dataset (customer_id varchar(40) NOT NULL DISTKEY, customer_unique_id varchar(40) NOT NULL, customer_zip_code_prefix int NOT NULL SORTKEY, customer_city varchar(40), customer_state varchar(2));
/*Geolocation*/
DROP TABLE IF EXISTS stg.olist_geolocation_dataset; 
CREATE TABLE stg.olist_geolocation_dataset (geolocation_zip_code_prefix int NOT NULL SORTKEY, geolocation_lat decimal(18,15), geolocation_lng decimal(18,15), geolocation_city varchar(40), geolocation_state varchar(2));
/*Orders*/
DROP TABLE IF EXISTS stg.olist_orders_dataset; 
CREATE TABLE stg.olist_orders_dataset (order_id varchar(40) DISTKEY NOT NULL, customer_id varchar(40) SORTKEY NOT NULL, order_status varchar(15), order_purchase_timestamp timestamp, order_approved_at timestamp, order_delivered_carrier_date timestamp, order_delivered_customer_date timestamp, order_estimated_delivery_date timestamp);
/*Order Items*/
DROP TABLE IF EXISTS stg.olist_order_items_dataset; 
CREATE TABLE stg.olist_order_items_dataset (order_id varchar(40) NOT NULL DISTKEY, order_item_id int NOT NULL, product_id varchar(40) NOT NULL, seller_id varchar(40) NOT NULL, shipping_limit_date timestamp, price decimal(10,2), freight_value decimal(10,2)) COMPOUND SORTKEY(order_item_id, product_id, seller_id);
/*Order Payments*/
DROP TABLE IF EXISTS stg.olist_order_payments_dataset; 
CREATE TABLE stg.olist_order_payments_dataset (order_id varchar(40) DISTKEY NOT NULL, payment_sequential int, payment_type varchar(15), payment_installments int, payment_value decimal(10,2));
/*Products*/
DROP TABLE IF EXISTS stg.olist_products_dataset; 
CREATE TABLE stg.olist_products_dataset (product_id varchar(40) SORTKEY NOT NULL, product_category_name varchar(50), product_name_lenght int, product_description_lenght int, product_photos_qty int, product_weight_g int, product_length_cm int, product_height_cm int, product_width_cm int);
/*Sellers*/
DROP TABLE IF EXISTS stg.olist_sellers_dataset; 
CREATE TABLE stg.olist_sellers_dataset (seller_id varchar(40) NOT NULL, seller_zip_code_prefix int NOT NULL, seller_city varchar(40), seller_state varchar(2)) COMPOUND SORTKEY(seller_id, seller_zip_code_prefix);
/*Order Reviews*/
DROP TABLE IF EXISTS stg.olist_order_reviews_dataset; 
CREATE TABLE stg.olist_order_reviews_dataset (review_id varchar(40) NOT NULL, order_id varchar(40) DISTKEY NOT NULL, review_score int, review_comment_title varchar(100), review_comment_message varchar(max), review_creation_date timestamp, review_answer_timestamp timestamp);
/*Product Category Translate*/
DROP TABLE IF EXISTS stg.product_category_name_translation; 
CREATE TABLE stg.product_category_name_translation (product_category_name varchar(50), product_category_name_english varchar(50)) DISTSTYLE ALL;