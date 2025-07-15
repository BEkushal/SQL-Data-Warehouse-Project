/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script defines SQL views for the Gold layer of the data warehouse.

    The Gold layer serves as the final, business-friendly presentation layer, 
    structured in a star schema format with dimension and fact views.

    Each view performs necessary joins and transformations on Silver layer data 
    to deliver cleansed, enriched, and analysis-ready datasets.

Usage Instructions:
    - Run this script after the Silver layer has been loaded.
    - Use these views for downstream analytics, dashboards, and reports.
===============================================================================
*/
-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
      ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key, -- -------->>>>>> Surrogate key
      ci.cst_id AS customer_id,
      ci.cst_key AS customer_number,
      ci.cst_firstname AS first_name,
      ci.cst_lastname  AS last_name,
      cl.CNTRY AS country,
      ci.cst_marital_status AS marital_status,
      CASE WHEN ci.cst_gndr <> 'unknown' THEN ci.cst_gndr -- ---------->>>>>> CRM is primary source of truth for gender
	   ELSE COALESCE(cb.GEN,'unknown') -- --------------------------->>>>>> ERP is secondary source 
      END AS gender,
      cb.BDATE AS birth_date,
      ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS cb
      ON ci.cst_key = cb.CID
LEFT JOIN silver.erp_loc_a101 AS cl
      ON cl.CID = ci.cst_key;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
      ROW_NUMBER() OVER(ORDER BY pc.prd_start_dt,pc.prd_key) AS product_key, 
      pc.prd_id AS product_id, 
      pc.prd_key AS product_number,
      pc.prd_nm AS product_name,
      pc.cat_id AS category_id,
      pe.CAT AS category,
      pe.SUBCAT AS subcategory,
      pe.MAINTENANCE AS maintenance,
      pc.prd_cost AS cost,
      pc.prd_line AS product_line,
      pc.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pc
LEFT JOIN silver.erp_px_cat_g1v2 AS pe
      ON pc.cat_id = pe.ID
WHERE pc.prd_end_dt IS NULL;
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
      sc.sls_ord_num AS order_number,
      pr.product_key,
      cu.customer_key,
      sc.sls_order_dt AS order_date,
      sc.sls_ship_dt AS ship_date,
      sc.sls_due_dt AS due_date,
      sc.sls_sales AS sales_amount,
      sc.sls_quantity AS quantity,
      sc.sls_price AS price
FROM silver.crm_sales_details AS sc
LEFT JOIN gold.dim_customers AS cu
      ON sc.sls_cust_id = cu.customer_id
LEFT JOIN gold.dim_products AS pr
      ON sc.sls_prd_key = pr.product_number
GO
