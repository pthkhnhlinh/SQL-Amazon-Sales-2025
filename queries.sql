-- 1. TOP PRODUCTS AND CATEGORIES
-- 1.1. Total sales by product
SELECT
    product,
    SUM(total_sales) AS total_sales_by_product,
    100.0 * SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS percentage_of_total_sales_by_product
FROM amazon_sales_2025
WHERE status = 'Completed'
GROUP BY product
ORDER BY total_sales_by_product DESC;
-- 1.2. Total sales by category
SELECT
    category,
    SUM(total_sales) AS total_sales_by_category,
    100.0 * SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS percentage_of_total_sales_by_category
FROM amazon_sales_2025
WHERE status = 'Completed'
GROUP BY category
ORDER BY total_sales_by_category DESC;

-- 2. SALES BY DAY OF THE WEEK
SET DATEFIRST 1; -- Set Monday as the first day of the week
SELECT
    DATENAME(WEEKDAY, date) AS day_of_week,
    SUM(total_sales) AS total_sales_by_day_of_week,
    100.0 * SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS percentage_of_total_sales_by_day_of_week
FROM amazon_sales_2025
GROUP BY DATENAME(WEEKDAY, date)
ORDER BY MIN(DATEPART(WEEKDAY, date));

-- 3. LOCATION INSIGHTS
-- 3.1. Total sales by location
SELECT
    customer_location,
    SUM(total_sales) AS total_sales_by_location,
    100.0 * SUM(total_sales) / SUM(SUM(total_sales)) OVER () AS percentage_of_total_sales_by_location
FROM amazon_sales_2025
WHERE status = 'Completed'
GROUP BY customer_location
ORDER BY total_sales_by_location DESC;
-- 3.2. Cancellation rate by location
SELECT
    customer_location,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancellation_count,
    100.0 * COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) / COUNT(*) AS cancellation_rate_percentage
FROM amazon_sales_2025
GROUP BY customer_location
ORDER BY cancellation_rate_percentage DESC;

-- 4. ORDER STATUS INSIGHTS
-- 4.1. Order status distribution
SELECT
    status,
    COUNT(*) AS order_count,
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS order_status_percentage
FROM amazon_sales_2025
GROUP BY status
ORDER BY order_count DESC;
-- 4.2. Cancellation rate by product
SELECT
    product,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancellation_count,
    100.0 * COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) / COUNT(*) AS cancellation_rate_percentage
FROM amazon_sales_2025
GROUP BY product
ORDER BY cancellation_rate_percentage DESC;
-- 4.3. Cancellation rate by category
SELECT
    category,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancellation_count,
    100.0 * COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) / COUNT(*) AS cancellation_rate_percentage
FROM amazon_sales_2025
GROUP BY category
ORDER BY cancellation_rate_percentage DESC;

-- 5. PAYMENT METHOD INSIGHTS
-- 5.1. Payment method distribution and sales
SELECT
    payment_method,
    COUNT(*) AS payment_method_count,
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS payment_method_percentage,
    SUM(CASE WHEN status = 'Completed' THEN total_sales ELSE 0 END) AS total_sales_by_payment_method,
    100.0 * SUM(CASE WHEN status = 'Completed' THEN total_sales ELSE 0 END) / SUM(SUM(total_sales)) OVER () AS percentage_of_total_sales_by_payment_method
FROM amazon_sales_2025
GROUP BY payment_method
ORDER BY payment_method_count DESC;
-- 5.2. Order status by payment method
SELECT
    payment_method,
    status,
    COUNT(*) AS order_count,
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY payment_method) AS percentage_within_payment_method
FROM amazon_sales_2025
GROUP BY payment_method, status
ORDER BY payment_method, percentage_within_payment_method DESC;

-- 6. CUSTOMER INSIGHTS
SELECT 
    customer_name,
    SUM(total_sales) AS total_sales_by_customer,
    AVG(total_sales) AS average_order_value,
    100.0 * COUNT(DISTINCT CASE WHEN status = 'Completed' THEN order_id END) / COUNT(DISTINCT order_id) AS customer_retention_rate_percentage
FROM amazon_sales_2025
GROUP BY customer_name
ORDER BY total_sales_by_customer DESC;

