/*
===============================================================================
Exploratory Script: Database Metadata Overview
===============================================================================
Purpose:
    - To explore the database structure by retrieving metadata from system views.
    - To list all tables and inspect their respective columns, data types, and schemas.

System Views Used:
    - INFORMATION_SCHEMA.TABLES   : Lists all tables and views in the current database.
    - INFORMATION_SCHEMA.COLUMNS  : Provides column-level metadata for all tables.

Usage Notes:
    - Use this script for initial exploration before diving into table-level analysis.
===============================================================================
*/
-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore All columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
