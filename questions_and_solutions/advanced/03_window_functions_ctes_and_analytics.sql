-- ============================================================
-- ADVANCED LEVEL - Window Functions, CTEs & Analytics
-- Topics: ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD,
--         Running Totals, Moving Averages, RFM Analysis,
--         PIVOT, YoY Growth, Churn Detection
-- Database: SQL Server (T-SQL)
-- ============================================================


-- ============================================================
-- QUESTION 17
-- Calculate the running total of monthly revenue within
-- each year using window functions.
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_date)            AS year,
        MONTH(o.order_date)           AS month_num,
        DATENAME(MONTH, o.order_date) AS month_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY YEAR(o.order_date), MONTH(o.order_date), DATENAME(MONTH, o.order_date)
)
SELECT
    year,
    month_name,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (
            PARTITION BY year
            ORDER BY month_num
            ROWS UNBOUNDED PRECEDING
        ), 2
    ) AS running_total_ytd
FROM monthly_revenue
ORDER BY year, month_num;


-- ============================================================
-- QUESTION 18
-- Rank customers by total spending using DENSE_RANK —
-- both globally and within each region.
-- ============================================================

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name                             AS customer_name,
        c.region,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_spent
    FROM customers c
    JOIN orders      o  ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.region
)
SELECT
    customer_name,
    region,
    total_spent,
    DENSE_RANK() OVER (ORDER BY total_spent DESC)                    AS global_rank,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS regional_rank
FROM customer_spending
ORDER BY global_rank;


-- ============================================================
-- QUESTION 19
-- Calculate Month-over-Month (MoM) revenue growth %.
-- Use LAG() to compare current month vs previous month.
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_date)  AS year,
        MONTH(o.order_date) AS month_num,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    year,
    month_num,
    ROUND(revenue, 2)                                        AS current_revenue,
    ROUND(LAG(revenue) OVER (ORDER BY year, month_num), 2)  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, month_num)) /
         LAG(revenue) OVER (ORDER BY year, month_num) * 100,
    2) AS mom_growth_pct
FROM monthly_revenue
ORDER BY year, month_num;


-- ============================================================
-- QUESTION 20
-- Find the Top 3 products per category by total revenue,
-- using ROW_NUMBER() window function.
-- ============================================================

WITH product_revenue AS (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_revenue,
        SUM(oi.quantity)                                       AS total_units_sold,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) DESC
        ) AS revenue_rank
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders      o  ON oi.order_id  = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.category, p.product_name
)
SELECT
    category,
    revenue_rank,
    product_name,
    ROUND(total_revenue, 2) AS total_revenue,
    total_units_sold
FROM product_revenue
WHERE revenue_rank <= 3
ORDER BY category, revenue_rank;


-- ============================================================
-- QUESTION 21
-- Calculate a 3-month moving average of monthly sales
-- to smooth out seasonal fluctuations.
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date)  AS year,
        MONTH(o.order_date) AS month_num,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    year,
    month_num,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY year, month_num
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3_months
FROM monthly_sales
ORDER BY year, month_num;


-- ============================================================
-- QUESTION 22
-- RFM Customer Segmentation
-- Recency:  Days since last order (lower = better)
-- Frequency: Number of Completed orders (higher = better)
-- Monetary:  Total amount spent (higher = better)
-- Score each metric 1-5 using NTILE(5), then classify.
-- ============================================================

WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name                              AS customer_name,
        DATEDIFF(DAY, MAX(o.order_date), '2025-01-01')                AS recency_days,
        COUNT(DISTINCT o.order_id)                                     AS frequency,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS monetary
    FROM customers c
    JOIN orders      o  ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name
),
rfm_scores AS (
    SELECT
        customer_id,
        customer_name,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days ASC)  AS r_score,  -- lower recency = higher score
        NTILE(5) OVER (ORDER BY frequency    DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary     DESC) AS m_score
    FROM customer_rfm
)
SELECT
    customer_id,
    customer_name,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    r_score + f_score + m_score AS rfm_total_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3                  THEN 'Loyal Customers'
        WHEN r_score >= 4                                   THEN 'Recent Customers'
        WHEN f_score >= 4                                   THEN 'Frequent Buyers'
        WHEN m_score >= 4                                   THEN 'High Spenders'
        WHEN r_score <= 2 AND f_score <= 2                  THEN 'At Risk'
        ELSE                                                     'Regular Customers'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total_score DESC;


-- ============================================================
-- QUESTION 23
-- Identify churned customers — those who completed at least
-- one order but have NOT purchased in the last 90 days
-- (relative to 2025-01-01).
-- ============================================================

WITH last_purchase AS (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name                              AS customer_name,
        c.email,
        c.region,
        MAX(o.order_date)                                              AS last_order_date,
        COUNT(DISTINCT o.order_id)                                     AS total_orders,
        ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_spent
    FROM customers c
    JOIN orders      o  ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.region
)
SELECT
    customer_id,
    customer_name,
    email,
    region,
    last_order_date,
    DATEDIFF(DAY, last_order_date, '2025-01-01') AS days_since_last_order,
    total_orders,
    total_spent
FROM last_purchase
WHERE DATEDIFF(DAY, last_order_date, '2025-01-01') > 90
ORDER BY days_since_last_order DESC;


-- ============================================================
-- QUESTION 24
-- Year-over-Year (YoY) Revenue Comparison by Category
-- using PIVOT to show 2023 vs 2024 side by side.
-- ============================================================

WITH yearly_category_revenue AS (
    SELECT
        YEAR(o.order_date) AS yr,
        p.category,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id    = oi.order_id
    JOIN products    p  ON oi.product_id = p.product_id
    WHERE o.status = 'Completed'
    GROUP BY YEAR(o.order_date), p.category
)
SELECT
    category,
    ROUND([2023], 2) AS revenue_2023,
    ROUND([2024], 2) AS revenue_2024,
    ROUND(([2024] - [2023]) / [2023] * 100, 2) AS yoy_growth_pct
FROM yearly_category_revenue
PIVOT (
    SUM(revenue)
    FOR yr IN ([2023], [2024])
) AS pivot_table
ORDER BY yoy_growth_pct DESC;
