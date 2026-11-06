-- GOLD LAYER: Monthly Revenue, Order Volume & Unique Customers Summary
-- Purpose: Aggregates delivered orders by month to calculate total revenue, 
--total order volume, and active unique customer count for business insights.



CREATE OR REPLACE TABLE `elite-vista-474514-t0.gold_dataset_Brazilian_ecommerce.monthly_revenue_order_volume_summary` AS
SELECT

FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp))as order_month ,
COUNT(DISTINCT(o.order_id)) as total_order,
ROUND(SUM(p.payment_value),2)as total_value,
COUNT(DISTINCT(c.customer_unique_id)) as unique_customer


FROM `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_payments_dataset` as p
JOIN
`elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_orders_dataset` as o
ON p.order_id=o.order_id


JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_customer_dataset` as c
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
`elite-vista-474514-t0.gold_dataset_Brazilian_ecommerce.top_selling_product_categories` AS

WITH order_category_revenue AS (
SELECT
i.order_id,
c.product_category_name_english,
SUM(i.price + i.freight_value) AS total_revenue

FROM `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_items_dataset` AS i

LEFT JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_products_dataset` AS p
ON i.product_id = p.product_id

LEFT JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_product_category_name_translation` AS c
ON p.product_category_name = c.product_category_name

GROUP BY
i.order_id,
c.product_category_name_english
),

order_review AS (
SELECT
order_id,
AVG(review_score) AS avg_review_score

FROM `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_reviews_dataset`

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

CREATE OR REPLACE TABLE `elite-vista-474514-t0.gold_dataset_Brazilian_ecommerce.state_wise_performance_delivery_metrics` AS

SELECT

c.customer_state,

COUNT(o.order_id) as total_order,

ROUND(AVG(TIMESTAMP_DIFF(o.order_delivered_customer_date,o.order_purchase_timestamp ,DAY)),2) as avg_delivery_date



FROM `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_customer_dataset` as c

JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_orders_dataset` as o

ON c.customer_id=o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL



GROUP BY c.customer_state;
