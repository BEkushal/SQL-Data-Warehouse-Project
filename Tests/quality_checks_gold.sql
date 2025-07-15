/*
===============================================================================
Gold Layer Quality Checks
===============================================================================
Script Purpose:
    This script performs quality validation for the Gold Layer to ensure 
    reliable and analysis-ready data. Checks include:

    - Surrogate key uniqueness in dimension views.
    - Referential integrity between fact and dimension views.
    - Logical correctness of relationships used in analytical models.

Usage Guidelines:
    - Run this script after Gold Layer views are created.
    - Investigate and address any issues found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check foreign key integrity (dimensions) with fact(s)
-- Expectation: No results 
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
