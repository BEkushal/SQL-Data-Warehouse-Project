/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================

Purpose:
    This stored procedure performs the ETL process to populate the Silver Layer 
    from the Bronze Layer. Data from Bronze tables is transformed, cleansed, and 
    standardized before being inserted into Silver schema tables.

Process Steps:
    - Truncate existing Silver tables to ensure clean loads.
    - Apply data transformations such as:
        • Removing nulls and invalid values
        • Standardizing codes (e.g., gender, marital status)
        • Formatting dates and IDs
        • De-duplicating records
    - Insert transformed records into corresponding Silver tables.

Assumptions:
    - The Bronze tables contain raw ingested data with minimal preprocessing.
    - This procedure does not accept any parameters or return any output.

Usage:
    EXEC silver.load_silver;

Note:
    Use this procedure when refreshing the Silver Layer as part of an ETL pipeline.
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

    		PRINT '****************************************************';
    		PRINT 'Loading tables with CRM as source';
    		PRINT '****************************************************';

-- ********************************************************************** crm_cust_info ******************************************************************** --

		    -- Loading silver.crm_cust_info
        SET @start_time = GETDATE();
    		PRINT '>>>>>>>> Truncating Table: silver.crm_cust_info <<<<<<<<';
    		TRUNCATE TABLE silver.crm_cust_info;

    		PRINT '>>>>>>>> Inserting Data Into: silver.crm_cust_info <<<<<<<<';
    		INSERT INTO silver.crm_cust_info
        (
        	cst_id, 
        	cst_key, 
        	cst_firstname, 
        	cst_lastname, 
        	cst_marital_status, 
        	cst_gndr,
        	cst_create_date
        )
        SELECT
        	cst_id,
        	cst_key,
        	TRIM(cst_firstname) AS cst_firstname,
        	TRIM(cst_lastname) AS cst_lastname,
        	CASE 
        		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' -- --------->>>> lower case and unwanted spaces proof (via UPPER & TRIM)
        		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' -- --------->>>> lower case and unwanted spaces proof (via UPPER & TRIM)
        		ELSE 'unknown'
        	END AS cst_marital_status, -- -------------------->>>>>>>>>>> Normalized or Standardized data
        	CASE 
        		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' -- --------->>>> lower case and unwanted spaces proof (via UPPER & TRIM)
        		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- --------->>>> lower case and unwanted spaces proof (via UPPER & TRIM)
        		ELSE 'unknown'
        	END AS cst_gndr, -- -------------------->>>>>>>>>>> Normalized or Standardized data
        	cst_create_date
        FROM
        (	
        	SELECT 
        		*,
        		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_latest
        	FROM bronze.crm_cust_info
        	WHERE cst_id IS NOT NULL
        )t
        WHERE flag_latest = 1; -- Select the most recent record per customer avoiding primary key duplicates
  		  SET @end_time = GETDATE();
        PRINT '>>>>>>>>>>> Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '------------------------------------------------------------------------';

-- ********************************************************************** crm_prd_info ******************************************************************** --
  		  
        -- Loading silver.crm_prd_info
        SET @start_time = GETDATE();
    		PRINT '>>>>>>>> Truncating Table: silver.crm_prd_info <<<<<<<<';  
    		TRUNCATE TABLE silver.crm_prd_info;

    		PRINT '>>>>>>>> Inserting Data Into: silver.crm_prd_info <<<<<<<<';
    		INSERT INTO silver.crm_prd_info
        (
        	prd_id,
        	cat_id,
        	prd_key,
        	prd_nm,
        	prd_cost,
        	prd_line,
        	prd_start_dt,
        	prd_end_dt
        )
        SELECT 
        	prd_id,
        	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- ---------------------->>>>>>> similar to id(category) from erp_px_cat_g1v2
        	TRIM(SUBSTRING(prd_key,7,LEN(prd_key))) AS prd_key, -- ---------------------->>>>>>> similar to sls_prd_key(product key) from crm_sales_details
        	prd_nm,
        	ISNULL(prd_cost,0) AS prd_cost,
        	CASE UPPER(TRIM(prd_line))
        		WHEN 'R' THEN 'Road'
        		WHEN 'M' THEN 'Mountain'
        		WHEN 'S' THEN 'Other Sales'
        		WHEN 'T' THEN 'Touring'
        		ELSE 'unknown'
        	END AS prd_line,
        	CAST(prd_start_dt AS DATE) AS prd_start_dt,
        	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>>>>>>>>>>> Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '------------------------------------------------------------------------';

-- ********************************************************************** crm_sales_details ******************************************************************** --

        -- Loading crm_sales_details
        SET @start_time = GETDATE();
    		PRINT '>>>>>>>> Truncating Table: silver.crm_sales_details <<<<<<<<';
    		TRUNCATE TABLE silver.crm_sales_details;

    		PRINT '>>>>>>>> Inserting Data Into: silver.crm_sales_details <<<<<<<<';
    		INSERT INTO silver.crm_sales_details (
    			sls_ord_num,
    			sls_prd_key,
    			sls_cust_id,
    			sls_order_dt,
    			sls_ship_dt,
    			sls_due_dt,
    			sls_sales,
    			sls_quantity,
    			sls_price
    		)
    		SELECT 
    			sls_ord_num,
    			sls_prd_key,
    			sls_cust_id,
    			CASE 
    				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
    				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) -- ----------------->>>>>>> Converted INT to DATE
    			END AS sls_order_dt,
    			CASE 
    				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
    				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) -- ----------------->>>>>>> Converted INT to DATE
    			END AS sls_ship_dt,
    			CASE 
    				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
    				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) -- ----------------->>>>>>> Converted INT to DATE
    			END AS sls_due_dt,
    			CASE 
    				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) -- ---->> sales = quantity * price
    				ELSE sls_sales
    			END AS sls_sales, 
    			sls_quantity,
    			CASE 
    				WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0) -- --->> price = sales/quantity
    				ELSE sls_price  
    			END AS sls_price
    		FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>>>>>>>>>>> Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '------------------------------------------------------------------------';

-- ********************************************************************** erp_cust_az12 ******************************************************************* --
  
        PRINT '*********************************************************************';
        PRINT 'Loading tables with ERP as source';
        PRINT '*********************************************************************';
      
      -- Loading erp_cust_az12
      SET @start_time = GETDATE();
  		PRINT '>>>>>>>> Truncating Table: silver.erp_cust_az12 <<<<<<<<';
  		TRUNCATE TABLE silver.erp_cust_az12;

  		PRINT '>>>>>>>> Inserting Data Into: silver.erp_cust_az12 <<<<<<<<';
  		INSERT INTO silver.erp_cust_az12 (
  			cid,
  			bdate,
  			gen
  		)
  		SELECT
  			CASE
  				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- ------------->>>>>>>>> Remove 'NAS' prefix if present
  				ELSE cid
  			END AS cid, 
  			CASE
  				WHEN bdate > GETDATE() THEN NULL -- ----------------->>>>>>>>>>>>>>> Set future birthdates to NULL
  				ELSE bdate
  			END AS bdate, 
  			CASE
  				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
  				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
  				ELSE 'unknown'
  			END AS gen -- ------------------------------------------>>>>>>>>>>>>>>>>>>>>> Normalize gender values and handle unknown cases
  		FROM bronze.erp_cust_az12;
  	  SET @end_time = GETDATE();
      PRINT '>>>>>>>>>>> Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
      PRINT '------------------------------------------------------------------------';

-- ********************************************************************** erp_loc_a101 ******************************************************************* --

      -- Loading erp_loc_a101
      SET @start_time = GETDATE();
  		PRINT '>>>>>>>> Truncating Table: silver.erp_loc_a101 <<<<<<<<';
  		TRUNCATE TABLE silver.erp_loc_a101;

  		PRINT '>>>>>>>> Inserting Data Into: silver.erp_loc_a101 <<<<<<<<';
  		INSERT INTO silver.erp_loc_a101 (
  			cid,
  			cntry
  		)
  		SELECT
  			REPLACE(cid, '-', '') AS cid, 
  			CASE
  				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
  				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
  				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'unknown'
  				ELSE TRIM(cntry)
  			END AS cntry -- ------------------------------------>>>>>>>>>>>>>> Normalize and Handle missing or blank or null country codes
  		FROM bronze.erp_loc_a101;
  	  SET @end_time = GETDATE();
      PRINT '>>>>>>>>>>> Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
      PRINT '------------------------------------------------------------------------';

-- ********************************************************************** erp_px_cat_g1v2 ******************************************************************* --

  		-- Loading erp_px_cat_g1v2
  		SET @start_time = GETDATE();
  		PRINT '>>>>>>>> Truncating Table: silver.erp_px_cat_g1v2 <<<<<<<<';
  		TRUNCATE TABLE silver.erp_px_cat_g1v2;

  		PRINT '>>>>>>>> Inserting Data Into: silver.erp_px_cat_g1v2 <<<<<<<<';
  		INSERT INTO silver.erp_px_cat_g1v2 (
  			id,
  			cat,
  			subcat,
  			maintenance
  		)
  		SELECT
  			id,
  			cat,
  			subcat,
  			maintenance
  		FROM bronze.erp_px_cat_g1v2;
  		SET @end_time = GETDATE();
  		PRINT '>>>>>>>>>>> Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
          PRINT '------------------------------------------------------------------------';
  
  		SET @batch_end_time = GETDATE();
  		PRINT '============================================================================================================';
  		PRINT 'Silver Layer Loading Complete';
  		PRINT 'Total Loading Time: ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS VARCHAR) + ' seconds';
  		PRINT '============================================================================================================'
		
	END TRY
	BEGIN CATCH
		PRINT '=================================================================================================================';
		PRINT 'ERROR WHILE LOADING SILVER LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE(); 
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
		PRINT '=================================================================================================================';
	END CATCH
END
