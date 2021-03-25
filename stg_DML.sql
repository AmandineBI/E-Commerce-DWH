COPY stg.olist_customers_dataset FROM 's3://brazilian-ecommerce-data/olist_customers_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_geolocation_dataset FROM 's3://brazilian-ecommerce-data/olist_geolocation_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_order_items_dataset FROM 's3://brazilian-ecommerce-data/olist_order_items_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_order_payments_dataset FROM 's3://brazilian-ecommerce-data/olist_order_payments_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_order_reviews_dataset FROM 's3://brazilian-ecommerce-data/olist_order_reviews_dataset2.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_orders_dataset FROM 's3://brazilian-ecommerce-data/olist_orders_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_products_dataset FROM 's3://brazilian-ecommerce-data/olist_products_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.olist_sellers_dataset FROM 's3://brazilian-ecommerce-data/olist_sellers_dataset.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;
COPY stg.product_category_name_translation FROM 's3://brazilian-ecommerce-data/product_category_name_translation.csv'
credentials 'aws_access_key_id=AKIATB6ADSHKZSAQEDME;aws_secret_access_key=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'
delimiter ',' IGNOREHEADER 1 REMOVEQUOTES ESCAPE;

