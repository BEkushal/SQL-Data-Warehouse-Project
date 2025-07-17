/*
===============================================================================
Segmentation Analysis
===============================================================================
Purpose:
    - To divide data into strategic segments based on business-defined rules.
    - This enables personalized insights and targeted decision-making.

Segmentation Performed:
    1. **Product Segmentation**: Based on product cost ranges to identify distribution across pricing tiers.
    2. **Customer Segmentation**: Based on total spend and engagement duration, classifying customers into:
        - VIP: Loyal, high-spending customers.
        - Regular: Loyal but moderate-spending customers.
        - New: Recent or infrequent customers.

Concepts Applied:
    - Conditional logic using CASE expressions.
    - Time-based customer lifespan calculation.
    - CTEs (Common Table Expressions) for stepwise logic building.
    - Aggregation and grouping for summarization.

SQL Functions Used:
    - CASE: Custom segment logic.
    - DATEDIFF(): To calculate lifespan.
    - Aggregate Functions: SUM(), COUNT(), MIN(), MAX()
    - CTEs: For modular, readable subqueries.
===============================================================================
*/


/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH prod_segments AS
(
	SELECT
		product_key,
		cost,
		product_name,
		CASE WHEN cost < 100 THEN 'Below 100'
			 WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
			 WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
			 ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)
SELECT 
	cost_range,
	COUNT(product_name) AS product_count
FROM prod_segments
GROUP BY cost_range
ORDER BY product_count DESC

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

-- Single CTE with Sub-Query Approach
WITH customer_spending AS --------------------------------------- The customer spending and lifespan is computed (1)
(
	SELECT
  		c.customer_key,
  		SUM(s.sales_amount) AS total_spending,
  		MIN(s.order_date) AS first_order_date,
  		MAX(s.order_date) AS last_order_date,
  		DATEDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) AS lifespan
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
	GROUP BY c.customer_key
)
SELECT
  	customer_segment,
  	COUNT(customer_key) AS customers
FROM -------------------------------------------------- Customers counted from the segmented_customers (3)
(
  	SELECT
  		customer_key,
  		total_spending,
  		lifespan,
  		CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
  			 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
  			 ELSE 'New'
  		END AS customer_segment
  	FROM customer_spending
) AS segmented_customers ----------------------------------------------- Customers are segmeted based spending and lifespan from the CTE customer_spending (2)
GROUP BY customer_segment
ORDER BY customers DESC


-- Multiple CTE's approach
WITH customer_spending AS ----------------------------------- The customer spending and lifespan is computed (1)
(
	SELECT
		c.customer_key,
		SUM(s.sales_amount) AS total_spending,
		MIN(s.order_date) AS first_order_date,
		MAX(s.order_date) AS last_order_date,
		DATEDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) AS lifespan
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
	GROUP BY c.customer_key
),
segmented_customers AS ---------------------------------------- Customers are segmeted based spending and lifespan from the CTE customer_spending (2)
(
	SELECT
		customer_key,
		total_spending,
		lifespan,
		CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			 ELSE 'New'
		END AS customer_segment
	FROM customer_spending
)
SELECT
	customer_segment,
	COUNT(customer_key) AS customers
FROM segmented_customers ----------------------------------------------- Customers counted from the segmented_customers CTE (3)
GROUP BY customer_segment
ORDER BY customers DESC
