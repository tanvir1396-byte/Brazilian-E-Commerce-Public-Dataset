CREATE OR REPLACE TABLE `elite-vista-474514-t0.gold_dataset_Brazilian_ecommerce.monthly_revenue_order_volume_summary` AS
SELECT

FORMAT_DATE('%Y-%m', o.order_purchase_timestamp)as order_month ,
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


CREATE OR REPLACE TABLE `elite-vista-474514-t0.gold_dataset_Brazilian_ecommerce.top_selling_product_categories`AS
SELECT
c.product_category_name_english,
ROUND(SUM(i.price + i.freight_value),2)as total_revenue,
ROUND(AVG(r.review_score),2)as avg_review
FROM `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_items_dataset` as i
JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_order_reviews_dataset` as r
ON i.order_id=r.order_id
LEFT JOIN`elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_products_dataset` as p
on i.product_id=p.product_id
LEFT JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.clean_product_category_name_translation` as c
on c.product_category_name=p.product_category_name

GROUP BY product_category_name_english


CREATE OR REPLACE TABLE `elite-vista-474514-t0.gold_dataset_Brazilian_ecommerce.state_wise_performance_delivery_metrics` AS

SELECT

c.customer_state,

COUNT(o.order_id) as total_order,

ROUND(AVG(TIMESTAMP_DIFF(o.order_delivered_customer_date,o.order_purchase_timestamp ,DAY)),2) as avg_delivery_date



FROM `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_customer_dataset` as c

JOIN `elite-vista-474514-t0.silver_dataset_Brazilian_ecommerce.cleaned_orders_dataset` as o

ON c.customer_id=o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL



GROUP BY c.customer_state
