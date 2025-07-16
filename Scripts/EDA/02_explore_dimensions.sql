/*
===============================================================================
Exploratory Script: Dimension Tables Overview
===============================================================================
Purpose:
    - To analyze and validate unique values within key dimension attributes.
    - Helps assess data coverage, categorical diversity, and readiness for slicing/dicing.

Dimension Exploration Focus:
    - Unique countries in the customer base.
    - Unique combinations of product categories, subcategories, and product names.

SQL Functions Used:
    - DISTINCT: To identify unique values.
    - ORDER BY: To sort the results for readability.

Usage Notes:
    - Run after Gold Layer views are created and populated.
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
