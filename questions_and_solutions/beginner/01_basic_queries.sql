-- ============================================================
-- BEGINNER LEVEL - Basic Queries
-- Topics: SELECT, WHERE, ORDER BY, GROUP BY, Aggregations
-- Database: SQL Server (T-SQL)
-- ============================================================


-- ============================================================
-- QUESTION 1
-- List all customers with their full name, email, city, and
-- state, sorted alphabetically by last name.
-- ============================================================

SELECT
    first_name,
    last_name,
    email,
    city,
    state,
    region
FROM customers
ORDER BY last_name, first_name;


-- ============================================================
-- QUESTION 2
-- Find all products in the 'Electronics' category
-- with a unit price greater than $50. Sort by price descending.
-- ============================================================

SELECT
    product_id,
    product_name,
    subcategory,
    unit_price
FROM products
WHERE category = 'Electronics'
  AND unit_price > 50
ORDER BY unit_price DESC;


-- ============================================================
-- QUESTION 3
-- Count the total number of orders for each order status.
-- ============================================================

SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- ============================================================
-- QUESTION 4
-- Find the top 5 most expensive products across all categories.
-- ============================================================

SELECT TOP 5
    product_name,
    category,
    unit_price
FROM products
ORDER BY unit_price DESC;


-- ============================================================
-- QUESTION 5
-- Retrieve all orders placed in the year 2024, showing
-- order ID, customer ID, order date, and status.
-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    ship_date,
    status,
    region
FROM orders
WHERE YEAR(order_date) = 2024
ORDER BY order_date;


-- ============================================================
-- QUESTION 6
-- Calculate the total revenue generated from all
-- 'Completed' orders.
-- Revenue = quantity * unit_price * (1 - discount)
-- ============================================================

SELECT
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed';


-- ============================================================
-- QUESTION 7
-- Count how many customers exist in each state.
-- Show only states with more than 1 customer.
-- ============================================================

SELECT
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
HAVING COUNT(*) > 1
ORDER BY customer_count DESC;


-- ============================================================
-- QUESTION 8
-- Find all products where the profit margin is above 50%.
-- Profit Margin % = (unit_price - cost_price) / unit_price * 100
-- ============================================================

SELECT
    product_name,
    category,
    unit_price,
    cost_price,
    ROUND((unit_price - cost_price) / unit_price * 100, 2) AS profit_margin_pct
FROM products
WHERE (unit_price - cost_price) / unit_price > 0.50
ORDER BY profit_margin_pct DESC;
