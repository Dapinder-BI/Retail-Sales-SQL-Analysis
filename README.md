# Retail Sales Analysis — SQL Portfolio Project

Analyzed a multi-store retail sales dataset using **SQL Server (T-SQL)** — uncovering revenue trends, customer behavior, and business performance insights through structured querying and advanced analytics.

---

## Database Schema

```
stores          customers
--------        ---------
store_id  PK    customer_id  PK
store_name      first_name
city            last_name
state           email
region          city
open_date       state
                region
                gender
                age
                join_date

products              orders                    order_items
--------              ------                    -----------
product_id  PK        order_id    PK            order_item_id  PK
product_name          customer_id FK→customers  order_id       FK→orders
category              store_id    FK→stores     product_id     FK→products
subcategory           order_date                quantity
unit_price            ship_date                 unit_price
cost_price            status                    discount
                      region
```

**Dataset size:** 10 stores | 50 products | 500 customers | 3,000 orders | ~9,000 order items

---

## Getting Started

1. Open **SQL Server Management Studio (SSMS)** or **Azure Data Studio**
2. Create a new database: `CREATE DATABASE RetailSalesDB;`
3. Run [`dataset/01_create_schema.sql`](dataset/01_create_schema.sql) — creates all tables
4. Run [`dataset/02_insert_data.sql`](dataset/02_insert_data.sql) — loads ~13,500 rows of sample data
5. Open any question file and run the queries

> The dataset was generated with [`dataset/generate_data.py`](dataset/generate_data.py) — a Python script
> that produces realistic, reproducible retail data at scale (500 customers, 3,000 orders, ~9,000 items).

---

## Analysis Breakdown

### Exploratory & Sales Analysis — [`questions_and_solutions/beginner/01_basic_queries.sql`](questions_and_solutions/beginner/01_basic_queries.sql)

| # | Question | Key Concept |
|---|----------|-------------|
| Q1 | List all customers sorted alphabetically | SELECT, ORDER BY |
| Q2 | Electronics products priced above $50 | WHERE with multiple conditions |
| Q3 | Order count by status | GROUP BY, COUNT |
| Q4 | Top 5 most expensive products | TOP N, ORDER BY |
| Q5 | All orders placed in 2024 | YEAR() date function |
| Q6 | Total revenue from Completed orders | SUM with JOIN |
| Q7 | Customer count per state (>1 customer) | GROUP BY, HAVING |
| Q8 | Products with profit margin above 50% | Calculated columns, WHERE |

---

### Customer & Revenue Analysis — [`questions_and_solutions/intermediate/02_joins_subqueries_and_aggregations.sql`](questions_and_solutions/intermediate/02_joins_subqueries_and_aggregations.sql)

| # | Question | Key Concept |
|---|----------|-------------|
| Q9  | Total revenue by product category | Multi-table JOIN, GROUP BY |
| Q10 | Top 10 customers by total spending | JOIN, aggregation, TOP N |
| Q11 | Monthly revenue for 2023 & 2024 | DATENAME, GROUP BY date parts |
| Q12 | Products never ordered | LEFT JOIN, NOT EXISTS |
| Q13 | Average order value by region | Subquery, division aggregation |
| Q14 | Customers with more than 3 orders | HAVING clause |
| Q15 | Revenue, cost & profit margin by category | Multi-metric aggregation |
| Q16 | Revenue by customer age group | CASE WHEN segmentation |

---

### Advanced Analytics & Business Intelligence — [`questions_and_solutions/advanced/03_window_functions_ctes_and_analytics.sql`](questions_and_solutions/advanced/03_window_functions_ctes_and_analytics.sql)

| # | Question | Key Concept |
|---|----------|-------------|
| Q17 | Running total of monthly revenue (YTD) | SUM OVER, ROWS UNBOUNDED PRECEDING |
| Q18 | Customer rank globally and by region | DENSE_RANK, PARTITION BY |
| Q19 | Month-over-Month revenue growth % | LAG(), percentage change |
| Q20 | Top 3 products per category by revenue | ROW_NUMBER, PARTITION BY |
| Q21 | 3-month moving average of sales | AVG OVER, ROWS BETWEEN |
| Q22 | RFM customer segmentation | NTILE, multi-CTE, CASE WHEN |
| Q23 | Identify churned customers (90+ days) | DATEDIFF, CTE, business logic |
| Q24 | Year-over-Year revenue by category | PIVOT, YoY growth % |

---

## Skills Demonstrated

- **Joins:** INNER JOIN, LEFT JOIN across 3+ tables
- **Aggregations:** SUM, COUNT, AVG with GROUP BY and HAVING
- **Subqueries:** Correlated subqueries and derived tables
- **Window Functions:** ROW_NUMBER, RANK, DENSE_RANK, LAG, SUM OVER, AVG OVER
- **CTEs:** Multi-step CTEs for complex analysis
- **Date Functions:** YEAR(), MONTH(), DATENAME(), DATEDIFF()
- **PIVOT:** Transforming rows into columns for YoY comparison
- **Business Analytics:** RFM segmentation, churn detection, moving averages, MoM/YoY growth

---

## Tools Used

- **SQL Server (T-SQL)** — SQL dialect
- **SSMS / Azure Data Studio** — Query execution
