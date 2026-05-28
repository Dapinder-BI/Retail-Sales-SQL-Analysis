-- ============================================================
-- INTERMEDIATE LEVEL - JOINs, Subqueries & Aggregations
-- Topics: INNER/LEFT JOIN, Subqueries, CASE, HAVING,
--         Date Functions, GROUP BY with multiple tables
-- Database: SQL Server (T-SQL)
-- ============================================================


-- ============================================================
-- QUESTION 9
-- Find total revenue and total orders by product category
-- for Completed orders only. Sort by revenue descending.
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id)                                        AS total_orders,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount))             AS total_revenue
FROM order_items oi
JOIN orders   o ON oi.order_id  = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ============================================================
-- QUESTION 10
-- Find the top 10 customers by total spending on Completed
-- orders. Include their city, state, and order count.
-- ============================================================

SELECT TOP 10
    c.customer_id,
    c.first_name + ' ' + c.last_name                                 AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id)                                        AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2)   AS total_spent
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.state
ORDER BY total_spent DESC;


-- ============================================================
-- QUESTION 11
-- Calculate monthly revenue for each year (2023 & 2024).
-- Show year, month number, month name, and revenue.
-- ============================================================

SELECT
    YEAR(o.order_date)              AS year,
    MONTH(o.order_date)             AS month_num,
    DATENAME(MONTH, o.order_date)   AS month_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY YEAR(o.order_date), MONTH(o.order_date), DATENAME(MONTH, o.order_date)
ORDER BY year, month_num;


-- ============================================================
-- QUESTION 12
-- Find products that have NEVER been ordered.
-- (Use a LEFT JOIN or NOT EXISTS)
-- ============================================================

-- Method 1: LEFT JOIN
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Method 2: NOT EXISTS (more efficient for large datasets)
SELECT
    product_id,
    product_name,
    category,
    unit_price
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);


-- ============================================================
-- QUESTION 13
-- Calculate the average order value (AOV) by region
-- for Completed orders.
-- ============================================================

SELECT
    o.region,
    COUNT(DISTINCT o.order_id)  AS total_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) /
        COUNT(DISTINCT o.order_id),
    2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.region
ORDER BY avg_order_value DESC;


-- ============================================================
-- QUESTION 14
-- Find customers who have placed more than 3 Completed orders.
-- Show their name, email, and purchase count.
-- ============================================================

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.email,
    c.region,
    COUNT(o.order_id) AS completed_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.region
HAVING COUNT(o.order_id) > 3
ORDER BY completed_orders DESC;


-- ============================================================
-- QUESTION 15
-- Calculate total revenue, total cost, and profit margin %
-- by product category for Completed orders.
-- ============================================================

SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2)  AS total_revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2)                        AS total_cost,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) -
        SUM(oi.quantity * p.cost_price),
    2) AS gross_profit,
    ROUND(
        (SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) -
         SUM(oi.quantity * p.cost_price)) /
         SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) * 100,
    2) AS profit_margin_pct
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders      o  ON oi.order_id  = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY gross_profit DESC;


-- ============================================================
-- QUESTION 16
-- Segment customers into age groups and count orders
-- and total revenue per group.
-- Age groups: Under 30 | 30-40 | 41-50 | Over 50
-- ============================================================

SELECT
    CASE
        WHEN c.age < 30          THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 40 THEN '30 - 40'
        WHEN c.age BETWEEN 41 AND 50 THEN '41 - 50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(DISTINCT c.customer_id)                                     AS customer_count,
    COUNT(DISTINCT o.order_id)                                        AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2)   AS total_revenue
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.status = 'Completed'
GROUP BY
    CASE
        WHEN c.age < 30          THEN 'Under 30'
        WHEN c.age BETWEEN 30 AND 40 THEN '30 - 40'
        WHEN c.age BETWEEN 41 AND 50 THEN '41 - 50'
        ELSE 'Over 50'
    END
ORDER BY total_revenue DESC;
