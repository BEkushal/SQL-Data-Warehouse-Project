/*
====================================================================
📦 Step 1: Create the DataWarehouse Database and Necessary Schemas
====================================================================

🧠 Purpose:
As part of this project, we need a clean database setup to follow the Medallion Architecture:
- Bronze Layer: Raw data
- Silver Layer: Cleaned & transformed data
- Gold Layer: Business-ready analytics data

This script:
1. Checks if the 'DataWarehouse' DB already exists.
2. If it does, drops it (to start fresh).
3. Creates a new 'DataWarehouse' DB.
4. Creates three schemas inside it: bronze, silver, and gold.

⚠️ WARNING:
Running this script will completely remove the 'DataWarehouse' database if it exists.
All its data will be lost. Ensure you have backups or exports before proceeding.

👨‍💻 Note:
This is useful during development or iterative testing phases, not for production environments.
*/

-- Switch to the system database to perform admin-level changes
USE master;
GO

-- 🔄 Check if 'DataWarehouse' exists and drop it if so (with rollback)
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    -- Force single-user mode to disconnect any active sessions
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- 🆕 Create a fresh 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the new database
USE DataWarehouse;
GO

-- 🏗️ Create schemas representing each Medallion layer
CREATE SCHEMA bronze;  -- For raw, unprocessed data
GO

CREATE SCHEMA silver;  -- For cleaned, transformed data
GO

CREATE SCHEMA gold;    -- For final, business-level analytical tables
GO
