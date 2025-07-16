/*
===============================================================================
Performance Analysis (YoY & MoM Trends)
===============================================================================
Purpose:
    - To measure performance across different time frames (year-over-year, month-over-month).
    - To benchmark products or customers against historical averages and trends.
    - To highlight growth, stagnation, or decline in sales over time.

Concepts Applied:
    - Time-based trend analysis using window functions.
    - Historical comparison using LAG for previous period analysis.
    - Benchmarking against average performance using windowed AVG.
    - Conditional logic for dynamic insights using CASE statements.

SQL Functions Used:
    - Window Functions: LAG(), AVG() OVER()
    - Aggregate Functions: SUM()
    - Date Functions: DATETRUNC(), YEAR()
    - Conditional Logic: CASE
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_performance AS
(
	SELECT
		YEAR(s.order_date) AS order_year,
		p.product_name,
		SUM(s.sales_amount) AS current_year_sales
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
	WHERE s.order_date IS NOT NULL
	GROUP BY YEAR(s.order_date),p.product_name
)
SELECT
	order_year,
	product_name,
	current_year_sales,
	AVG(current_year_sales) OVER(PARTITION BY product_name) AS avg_sales,
	current_year_sales - AVG(current_year_sales) OVER(PARTITION BY product_name) AS curr_to_avg_sales_change,
	CASE WHEN current_year_sales - AVG(current_year_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		 WHEN current_year_sales - AVG(current_year_sales) OVER(PARTITION BY product_name) = 0 THEN 'Avg'
		 ELSE 'Above Avg'
	END AS avg_to_sales_performance,
	LAG(current_year_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS prev_sales,
	current_year_sales - LAG(current_year_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) AS prev_curr_sales_diff,
	CASE WHEN current_year_sales - LAG(current_year_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decrease'
		 WHEN current_year_sales - LAG(current_year_sales) OVER(PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increase'
		 ELSE 'No Change'
	END AS prev_curr_sales_chng
FROM yearly_product_performance;
