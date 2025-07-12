/*
===============================================================================
🛠️ Stored Procedure – Load Bronze Layer (Source → Bronze)
===============================================================================

🎯 Purpose:
This stored procedure automates the first stage of data ingestion — loading raw CSV data 
into the **bronze** schema. These are untouched, raw tables meant to mirror source systems 
(ERP & CRM) as closely as possible.

📋 What it does:
- Truncates each bronze table before load (ensures fresh load every time).
- Uses `BULK INSERT` to pull in CSV data from local paths into SQL Server tables.
- Captures load duration for each table and prints progress to console.
- Includes basic error handling for debugging.

📎 Parameters:
None — this procedure runs as-is.

▶️ Usage:
    EXEC bronze.load_bronze;

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		
		PRINT '=====================================================================';
		PRINT 'Loading Bronze layer';
		PRINT '=====================================================================';

		PRINT '*********************************************************************';
		PRINT 'Loading tables with CRM as source';
		PRINT '*********************************************************************';

		SET @start_time = GETDATE();
		PRINT '>>>>>>>> Truncating Table: bronze.crm_cust_info <<<<<<<<';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>>>>>>> Inserting into: bronze.crm_cust_info <<<<<<<<';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\kushal_msi\Documents\Portfolio_projects\SQL\Data_with_Baraa_YT\Projects-from-scratch\Data-Warehouse-Build\Datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>>>>>>>>> LOAD TIME: '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>>>>>> Truncating Table: bronze.crm_prd_info <<<<<<<<';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>>>>>>>> Inserting into: bronze.crm_prd_info <<<<<<<<';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\kushal_msi\Documents\Portfolio_projects\SQL\Data_with_Baraa_YT\Projects-from-scratch\Data-Warehouse-Build\Datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>>>>>>>>> LOAD TIME: '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>>>>>> Truncating Table: bronze.crm_sales_details <<<<<<<<';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>>>>>>>> Inserting into: bronze.crm_sales_details <<<<<<<<';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\kushal_msi\Documents\Portfolio_projects\SQL\Data_with_Baraa_YT\Projects-from-scratch\Data-Warehouse-Build\Datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>>>>>>>>> LOAD TIME: '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------------------';

		PRINT '*********************************************************************';
		PRINT 'Loading tables with ERP as source';
		PRINT '*********************************************************************';

		SET @start_time = GETDATE();
		PRINT '>>>>>>>> Truncating Table: bronze.erp_cust_az12 <<<<<<<<';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>>>>>>>> Inserting into: bronze.erp_cust_az12 <<<<<<<<';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\kushal_msi\Documents\Portfolio_projects\SQL\Data_with_Baraa_YT\Projects-from-scratch\Data-Warehouse-Build\Datasets\source_erp\cust_az12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>>>>>>>>> LOAD TIME: '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>>>>>> Truncating Table: bronze.erp_loc_a101 <<<<<<<<';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>>>>>>>> Inserting into: bronze.erp_loc_a101 <<<<<<<<';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\kushal_msi\Documents\Portfolio_projects\SQL\Data_with_Baraa_YT\Projects-from-scratch\Data-Warehouse-Build\Datasets\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>>>>>>>>> LOAD TIME: '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>>>>>> Truncating Table: bronze.erp_px_cat_g1v2 <<<<<<<<';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>>>>>>>> Inserting into: bronze.erp_px_cat_g1v2 <<<<<<<<';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\kushal_msi\Documents\Portfolio_projects\SQL\Data_with_Baraa_YT\Projects-from-scratch\Data-Warehouse-Build\Datasets\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>>>>>>>>>> LOAD TIME: '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' seconds';
		PRINT '------------------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '============================================================================================================';
		PRINT 'Bronze Layer Loading Complete';
		PRINT 'Total Loading Time: ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS VARCHAR) + ' seconds';
		PRINT '============================================================================================================';
	END TRY

	BEGIN CATCH
		PRINT '=================================================================================================================';
		PRINT 'ERROR WHILE LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE(); 
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
		PRINT '=================================================================================================================';
	END CATCH
END
