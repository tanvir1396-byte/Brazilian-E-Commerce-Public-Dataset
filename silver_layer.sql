/*SILVER LAYER: Cleaning and Transforming Customer Dataset
 Purpose: Extracts unique customer records from the raw bronze dataset 
to remove duplicates and standardize the customer table.*/


CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_customer_dataset` AS
SELECT DISTINCT
customer_id,
customer_unique_id,
customer_zip_code_prefix,
customer_city,
customer_state
FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_customers_dataset`;



/*SILVER LAYER: Cleaning and Transforming Orders Dataset
Purpose: Removes duplicate orders, casts timestamp fields accurately, 
and filters out records with null purchase dates or invalid delivery dates.*/


CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_orders_dataset` AS
SELECT DISTINCT
order_id,
customer_id,
order_status,
TIMESTAMP(order_purchase_timestamp) as order_purchase_timestamp,
TIMESTAMP(order_approved_at) as order_approved_at,
TIMESTAMP(order_delivered_carrier_date) as order_delivered_carrier_date,
TIMESTAMP (order_delivered_customer_date) as order_delivered_customer_date,
TIMESTAMP (order_estimated_delivery_date) as order_estimated_delivery_date
FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_orders_dataset`
WHERE order_purchase_timestamp IS NOT NULL
AND (order_delivered_customer_date IS NULL OR order_delivered_customer_date>=order_purchase_timestamp);


/*SILVER LAYER: Cleaning and Transforming Order Items Dataset
Purpose: Removes duplicates, standardizes shipping limit dates as timestamps, 
and filters out records with negative or null prices and freight values.*/

CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_items_dataset`
AS
SELECT DISTINCT
order_id,
order_item_id,
product_id,
seller_id,
TIMESTAMP(shipping_limit_date) as shipping_limit_date,
price,
freight_value
FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_order_items_dataset`

WHERE price>=0 AND
freight_value>=0 AND
price IS NOT NULL AND
freight_value IS NOT NULL;

/*SILVER LAYER: Cleaning and Transforming Order Payments Dataset
Purpose: Removes duplicate payment records and filters out 
invalid or null payment values (keeping only positive amounts).*/


CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_payments_dataset` AS

SELECT DISTINCT
order_id,
payment_sequential,
payment_type,
payment_installments,
payment_value

FROM`elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_order_payments_dataset`
WHERE payment_value>0 AND
payment_value IS NOT NULL;

/* SILVER LAYER: Cleaning and Transforming Order Reviews Dataset
Purpose: Standardizes review timestamps, handles missing text fields 
using COALESCE ('No Title' / 'No comment'), and filters valid review scores (1 to 5)*/


CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_reviews_dataset` AS
SELECT
review_id,
order_id,
review_score,
COALESCE(review_comment_title, 'No Title') as review_comment_title,
COALESCE(review_comment_message,'No comment') as review_comment_message,
TIMESTAMP(review_creation_date) as review_creation_date,
TIMESTAMP(review_answer_timestamp) as review_answer_timestamp
FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_order_reviews_dataset`
WHERE review_score  BETWEEN 1 AND 5;



/*SILVER LAYER: Cleaning and Transforming Products Dataset
Purpose: Removes duplicate products, standardizes category names to lowercase, 
and filters out records with null product IDs or invalid/zero physical dimensions and weight.*/

CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_products_dataset` AS
SELECT DISTINCT
product_id,
LOWER(TRIM(product_category_name)) as product_category_name ,
product_name_lenght,
product_description_lenght,
product_photos_qty,
product_weight_g,
product_height_cm,
product_length_cm,
product_width_cm
FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_products_dataset`
WHERE product_id IS NOT NULL
AND
product_length_cm>0 AND
product_height_cm>0 AND
product_weight_g>0 AND
product_width_cm>0;

/* SILVER LAYER: Cleaning and Transforming Sellers Dataset
Purpose: Removes duplicate sellers, trims whitespace from city names, 
standardizes seller state abbreviations to uppercase, and filters out null seller IDs or invalid zip codes.*/

CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_sellers_dataset` AS
SELECT DISTINCT
seller_id,
TRIM(seller_city) as seller_city ,
UPPER(TRIM(seller_state)) as seller_state ,
seller_zip_code_prefix

FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_sellers_dataset`
WHERE seller_id IS NOT NULL AND
seller_zip_code_prefix>0;

/*SILVER LAYER: Cleaning and Transforming Geolocation Dataset
Purpose: Removes duplicates and aggregates GPS coordinates by zip code 
prefix using averages for latitude/longitude and ANY_VALUE for standardized city and state.*/

CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_geolocation_dataset` AS
SELECT DISTINCT
geolocation_zip_code_prefix,
AVG (geolocation_lat) as avg_geolocation_lat,
AVG(geolocation_lng)as avg_geolocation_lng ,
ANY_VALUE(UPPER(TRIM(geolocation_state))) as geolocation_state ,
ANY_VALUE(TRIM(geolocation_city)) as geolocation_city
FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_olist_geolocation_dataset`
WHERE geolocation_zip_code_prefix>0
GROUP BY geolocation_zip_code_prefix;


/* SILVER LAYER: Cleaning and Transforming Product Category Name Translation Dataset
Purpose: Standardizes category names, trims whitespaces, 
converts English names to lowercase, and handles missing translations using COALESCE.*/

CREATE OR REPLACE TABLE `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_product_category_name_translation` AS
SELECT DISTINCT
product_category_name,
COALESCE(LOWER(TRIM(product_category_name_english)),'No Translation') as product_category_name_english

FROM `elite-vista-474514-t0.Bronze_dataset_Brazilian_ecommerce.extracted_product_category_name_translation`;




