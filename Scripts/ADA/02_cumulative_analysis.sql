/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To compute running totals and moving averages for key business metrics.
    - To observe cumulative growth and progressive performance over time.
    - Essential for identifying long-term upward/downward trends.

Concepts Applied:
    - Time-based aggregation and accumulation of metrics.
    - Use of window functions for cumulative calculations.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
    - Date Functions: DATETRUNC()
    - Aggregate Functions: SUM(), AVG()
===============================================================================
*/

-- Calculate the total sales per month and the running total of sales over time

SELECT
	order_month,
	sales,
	SUM(sales) OVER(ORDER BY order_month) AS running_total
FROM
(
	SELECT 
		DATETRUNC(MONTH,order_date) AS order_month,
		SUM(sales_amount) AS sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)
)t;

-- calculate the average price per year and the moving average over time

SELECT
	order_year,
	average_price,
	AVG(average_price) OVER(ORDER BY order_year) AS moving_average
FROM
(
	SELECT 
		DATETRUNC(YEAR,order_date) AS order_year,
		AVG(price) AS average_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR,order_date)
)t;
