/*
===============================================================================
Exploratory Script: Magnitude Analysis by Key Dimensions
===============================================================================
Purpose:
    - To quantify and aggregate key measures across various business dimensions.
    - To identify top-performing segments by revenue, volume, or customer count.
    - To highlight concentration of value and potential outliers in the dataset.

Analytical Objectives:
    - Distribution of customers across countries and genders
    - Product counts and cost averages by category
    - Revenue contribution per category and customer
    - Quantity sold segmented by geography

SQL Concepts Applied:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY for segmentation
    - ORDER BY for ranking insights
    - JOINs to associate fact and dimension tables (star schema navigation)

Usage Notes:
    - These insights help prioritize marketing efforts, inventory planning, and customer targeting.
    - Consider combining this with visualizations for more compelling business communication.
===============================================================================
*/

-- Find total customers by countries
SELECT 
			country,
			COUNT(customer_key) AS customers
FROM gold.dim_customers
GROUP BY country
ORDER BY customers DESC;

-- Find the total number of customers by gender
SELECT 
			gender,
			COUNT(customer_key) AS customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY customers DESC;

-- Find total products by category
SELECT
			category,
			COUNT(product_key) AS products
FROM gold.dim_products
GROUP BY category
ORDER BY products DESC;

-- What is the average cost in each category
SELECT
			category,
			AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;

-- What is the total revenue generated for each category
SELECT
			p.category,
			SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- What is the total revenue generated for each customer
SELECT
			c.first_name,
			c.last_name,
			s.customer_key,
			SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.first_name, c.last_name, s.customer_key
ORDER BY total_revenue DESC;

-- how many items are sold across each country
SELECT 
			c.country,
			SUM(s.quantity) AS items_sold
FROM gold.fact_sales AS s
JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY items_sold DESC;
