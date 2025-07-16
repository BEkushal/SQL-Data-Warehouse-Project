/*
===============================================================================
Exploratory Script: Key Business Metrics Overview
===============================================================================
Purpose:
    - To compute foundational business KPIs from the Gold Layer.
    - To uncover total revenue, sales volume, customer engagement, and product activity.
    - To generate a consolidated report for quick executive-level insights.

Key Metrics Analyzed:
    - Total sales and quantity sold
    - Average selling price
    - Total customers vs. ordering customers
    - Total number of orders and products

SQL Functions Used:
    - COUNT(): To calculate number of records (e.g., orders, customers).
    - SUM(): To aggregate monetary values or units sold.
    - AVG(): To find mean selling price or performance metrics.

Usage Notes:
    - Acts as a health check for data completeness and consistency.
    - Can serve as a baseline for dashboards or trend analysis.
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find total number of customers with atleast a single order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;


-- generate a report to show all the metrics and its values
SELECT 'Total Sales' AS metric, SUM(sales_amount) AS metric_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS metric, SUM(quantity) AS metric_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Selling Price' AS metric, AVG(price) AS metric_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' AS metric, COUNT(DISTINCT order_number) AS metric_value from gold.fact_sales
UNION ALL
SELECT 'Total Products' AS metric, COUNT(product_key) AS metric_value from gold.dim_products
UNION ALL
SELECT 'Total Customers' AS metric, COUNT(customer_key) AS metric_value from gold.dim_customers
UNION ALL
SELECT 'Total ordered Customers' AS metric, COUNT(DISTINCT customer_key) AS metric_value from gold.fact_sales


