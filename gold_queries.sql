-- GOLD LAYER: Monthly Revenue, Order Volume & Unique Customers Summary
-- Purpose: Aggregates delivered orders by month to calculate total revenue, 
--total order volume, and active unique customer count for business insights.



CREATE OR REPLACE TABLE `my-project-17182-514115.gold_dataset_Brazilian_ecommerce.monthly_revenue_order_volume_summary` AS
SELECT

FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp))as order_month ,
COUNT(DISTINCT(o.order_id)) as total_order,
ROUND(SUM(p.payment_value),2)as total_value,
COUNT(DISTINCT(c.customer_unique_id)) as unique_customer


FROM `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_order_payments_dataset` as p
JOIN
`my-project-17182-514115.silver_dataset_Brazilian_ecommerce.cleaned_orders_dataset` as o
ON p.order_id=o.order_id


JOIN `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.cleaned_customer_dataset` as c
ON o.customer_id=c.customer_id

WHERE o.order_status='delivered'

GROUP BY order_month;


/*GOLD LAYER: Top Selling Product Categories Performance
Purpose: Analyzes total revenue (price + freight) and average 
review scores across different product categories.
Logic:
- Aggregate item revenue by order and product category
- Aggregate reviews by order before joining
- This prevents join fanout and revenue inflation
*/

CREATE OR REPLACE TABLE
`my-project-17182-514115.gold_dataset_Brazilian_ecommerce.top_selling_product_categories` AS

WITH order_category_revenue AS (
SELECT
i.order_id,
c.product_category_name_english,
SUM(i.price + i.freight_value) AS total_revenue

FROM `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_order_items_dataset` AS i

LEFT JOIN `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_products_dataset` AS p
ON i.product_id = p.product_id

LEFT JOIN `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_product_category_name_translation` AS c
ON p.product_category_name = c.product_category_name

GROUP BY
i.order_id,
c.product_category_name_english
),

order_review AS (
SELECT
order_id,
AVG(review_score) AS avg_review_score

FROM `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_order_reviews_dataset`

GROUP BY order_id
)

SELECT
COALESCE(
ocr.product_category_name_english,
'Unknown Category'
) AS product_category_name_english,

ROUND(SUM(ocr.total_revenue), 2) AS total_revenue,

ROUND(AVG(orv.avg_review_score), 2) AS avg_review_score

FROM order_category_revenue AS ocr

LEFT JOIN order_review AS orv
ON ocr.order_id = orv.order_id

GROUP BY
product_category_name_english;


-- GOLD LAYER: State-Wise Performance & Delivery Metrics
-- Purpose: Analyzes total orders and calculates the average 
-- delivery time (in days) from purchase to customer delivery per state.

CREATE OR REPLACE TABLE `my-project-17182-514115.gold_dataset_Brazilian_ecommerce.state_wise_performance_delivery_metrics` AS

SELECT

c.customer_state,

COUNT(o.order_id) as total_order,

ROUND(AVG(TIMESTAMP_DIFF(o.order_delivered_customer_date,o.order_purchase_timestamp ,DAY)),2) as avg_delivery_days



FROM `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.cleaned_customer_dataset` as c

JOIN `my-project-17182-514115.silver_dataset_Brazilian_ecommerce.cleaned_orders_dataset` as o

ON c.customer_id=o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL



GROUP BY c.customer_state;


/*
GOLD LAYER: Seller Geolocation Analysis

Purpose:
Combines seller information with geographical coordinates.

Logic:
- Uses seller ZIP code prefix to match geolocation data.
- Uses LEFT JOIN to retain all sellers.
- Keeps missing geographical coordinates as NULL.
*/

CREATE OR REPLACE TABLE
`my-project-17182-514115.gold_dataset_Brazilian_ecommerce.seller_geolocation_analysis` AS

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    s.seller_zip_code_prefix,
    g.avg_geolocation_lat,
    g.avg_geolocation_lng

FROM
`my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_sellers_dataset` AS s

LEFT JOIN
`my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_geolocation_dataset` AS g

ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;



/*
GOLD LAYER: Revenue by Seller State

Purpose:
Analyzes business performance across seller states.

Logic:
- Joins order items with seller information using seller_id.
- Uses LEFT JOIN to retain order items even when seller information is missing.
- Handles missing or blank seller states as 'Unknown'.
- Calculates unique orders and unique sellers per state.
- Calculates total revenue using item price and freight value.
- Sorts seller states by total revenue in descending order.
*/

CREATE OR REPLACE TABLE
`my-project-17182-514115.gold_dataset_Brazilian_ecommerce.revenue_by_seller_state` AS

SELECT
    COALESCE(NULLIF(TRIM(s.seller_state), ''), 'Unknown') AS seller_state,

    COUNT(DISTINCT i.order_id) AS total_orders,

    COUNT(DISTINCT i.seller_id) AS total_sellers,

    ROUND(SUM(i.price + i.freight_value), 2) AS total_revenue

FROM
`my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_order_items_dataset` AS i

LEFT JOIN
`my-project-17182-514115.silver_dataset_Brazilian_ecommerce.clean_sellers_dataset` AS s

ON i.seller_id = s.seller_id

GROUP BY seller_state

ORDER BY total_revenue DESC;