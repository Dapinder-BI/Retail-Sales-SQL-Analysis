-- ============================================================
-- RETAIL SALES ANALYSIS - DATABASE SCHEMA
-- Database: SQL Server (T-SQL)
-- ============================================================

-- Drop tables in reverse dependency order (safe re-run)
IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('orders',      'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('products',    'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('customers',   'U') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('stores',      'U') IS NOT NULL DROP TABLE stores;

-- ============================================================
-- STORES
-- ============================================================
CREATE TABLE stores (
    store_id    INT           PRIMARY KEY,
    store_name  VARCHAR(100)  NOT NULL,
    city        VARCHAR(50)   NOT NULL,
    state       VARCHAR(50)   NOT NULL,
    region      VARCHAR(20)   NOT NULL,  -- North | South | East | West
    open_date   DATE          NOT NULL
);

-- ============================================================
-- CUSTOMERS
-- ============================================================
CREATE TABLE customers (
    customer_id INT           PRIMARY KEY,
    first_name  VARCHAR(50)   NOT NULL,
    last_name   VARCHAR(50)   NOT NULL,
    email       VARCHAR(100)  NOT NULL UNIQUE,
    city        VARCHAR(50)   NOT NULL,
    state       VARCHAR(50)   NOT NULL,
    region      VARCHAR(20)   NOT NULL,
    gender      VARCHAR(10)   NOT NULL,
    age         INT           NOT NULL,
    join_date   DATE          NOT NULL
);

-- ============================================================
-- PRODUCTS
-- ============================================================
CREATE TABLE products (
    product_id    INT             PRIMARY KEY,
    product_name  VARCHAR(100)    NOT NULL,
    category      VARCHAR(50)     NOT NULL,
    subcategory   VARCHAR(50)     NOT NULL,
    unit_price    DECIMAL(10,2)   NOT NULL,
    cost_price    DECIMAL(10,2)   NOT NULL
);

-- ============================================================
-- ORDERS
-- ============================================================
CREATE TABLE orders (
    order_id    INT          PRIMARY KEY,
    customer_id INT          NOT NULL REFERENCES customers(customer_id),
    store_id    INT          NOT NULL REFERENCES stores(store_id),
    order_date  DATE         NOT NULL,
    ship_date   DATE         NOT NULL,
    status      VARCHAR(20)  NOT NULL,  -- Completed | Pending | Cancelled | Returned
    region      VARCHAR(20)  NOT NULL
);

-- ============================================================
-- ORDER ITEMS
-- ============================================================
CREATE TABLE order_items (
    order_item_id INT            PRIMARY KEY,
    order_id      INT            NOT NULL REFERENCES orders(order_id),
    product_id    INT            NOT NULL REFERENCES products(product_id),
    quantity      INT            NOT NULL,
    unit_price    DECIMAL(10,2)  NOT NULL,
    discount      DECIMAL(5,2)   NOT NULL DEFAULT 0  -- 0.00 to 0.30 (0% to 30%)
);
