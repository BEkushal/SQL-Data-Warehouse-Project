/*
===============================================================================
Exploratory Script: Date Range Analysis
===============================================================================
Purpose:
    - To identify the earliest and latest dates present in key date fields.
    - To evaluate the historical span of the dataset.
    - To determine age-related insights such as oldest and youngest customers.

Date Checks Include:
    - Order dates, shipping dates, due dates from sales data.
    - Customer birthdates for demographic profiling.

SQL Functions Used:
    - MIN(): Finds the earliest date in a column.
    - MAX(): Finds the most recent date in a column.
    - DATEDIFF(): Measures age or the range between dates.

Usage Notes:
    - Provides temporal context for time-series and age-based analytics.
    - Can inform cohort segmentation and customer lifespan insights.
===============================================================================
*/

-- Determine the first and last order date and the total duration in years,months and days
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR,MIN(order_date), MAX(order_date)) AS order_range_years,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months,
    DATEDIFF(DAY,MIN(order_date), MAX(order_date)) AS order_range_days
FROM gold.fact_sales;

-- Find the youngest and oldest customer age based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
