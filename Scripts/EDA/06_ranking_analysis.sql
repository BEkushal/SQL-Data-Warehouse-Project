/*
===============================================================================
Exploratory Script: Ranking Analysis
===============================================================================
Purpose:
    - To rank entities (products, customers) based on key performance metrics such as revenue or order volume.
    - To identify top performers (e.g., best-selling products, high-value customers) and underperformers.
    - To support prioritization decisions in sales, marketing, and inventory.

Analytical Objectives:
    - Determine highest and lowest performing products by total sales revenue.
    - Identify top-spending customers.
    - Find customers with the fewest interactions (orders placed).

SQL Concepts Applied:
    - Aggregate Functions: SUM(), COUNT()
    - Window Functions: ROW_NUMBER(), RANK(), DENSE_RANK()
    - TOP clause for limiting results
    - GROUP BY and ORDER BY for segmentation and sorting
    - JOINs between fact and dimension tables (star schema logic)
    - Use of subqueries and Common Table Expressions (CTEs) for flexible ranking

Usage Notes:
    - This script aids in creating leaderboards, performance dashboards, and targeting strategies.
    - Results can be used as base layers for KPIs or further segmentation in BI tools.
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking

SELECT TOP 5
	  p.product_name,
	  SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- What are the 5 worst-performing products in terms of sales?
-- Complex but Flexibly Ranking Using Window Functions in sub-query

SELECT
	*
FROM
	(
		SELECT 
			  ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) ASC) AS rank_order,
  			p.product_name,
  			SUM(s.sales_amount) AS total_revenue
		FROM gold.fact_sales AS s
		LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
		GROUP BY p.product_name
	)t
WHERE rank_order <=5

-- Complex but Flexibly Ranking Using Window Functions in sub-query

WITH cte AS (
	SELECT 
  		p.product_name,
  		SUM(s.sales_amount) AS total_revenue,
  		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) ASC) AS rank_order
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
	GROUP BY p.product_name
	)
SELECT 
	rank_order,
	product_name,
	total_revenue
FROM cte
WHERE rank_order <=5

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;
