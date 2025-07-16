/*
===============================================================================
Part-to-Whole Contribution Analysis
===============================================================================
Purpose:
    - To understand how individual components contribute to the overall total.
    - To evaluate the share of categories, products, or regions within the whole.
    - Supports A/B testing, regional breakdowns, and proportional analysis.

Concepts Applied:
    - Percentage contribution using window functions.
    - Dimensional aggregation and ranking for comparative insights.
    - Effective for Pareto analysis and 80/20 evaluations.

SQL Functions Used:
    - Aggregate Functions: SUM(), AVG()
    - Window Functions: SUM() OVER()
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which Categories contribute the most to overall sales

WITH cat AS 
(
	SELECT 
	p.category,
	SUM(s.sales_amount) AS sales
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
	GROUP BY p.category
)
SELECT 
	category,
	sales,
	SUM(sales) OVER() AS overall_sales,
	CONCAT(ROUND(CAST(sales AS FLOAT)/(SUM(sales) OVER())*100,2),'%') AS contribution
FROM cat 
ORDER BY contribution DESC
