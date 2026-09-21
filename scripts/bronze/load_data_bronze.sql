/*
===============================================================================
                        BRONZE LAYER DATA LOAD
===============================================================================

Purpose:
    This script performs a full load of source data into the Bronze layer.

    Data is loaded from CSV files belonging to two source systems:
        - CRM
        - ERP

Load Strategy:
    A full-load approach is used for the Bronze layer.

    Before loading each source file:
        1. The existing table data is removed using TRUNCATE TABLE.
        2. The source CSV file is loaded using LOAD DATA LOCAL INFILE.
        3. The number of loaded rows is recorded.
        4. The execution time for each table load is calculated.

    TRUNCATE TABLE prevents duplicate records when the script is executed
    multiple times.

Timing:
    NOW(6) is used to capture timestamps with microsecond precision.

    TIMESTAMPDIFF is used to calculate:
        - The loading duration of each individual table.
        - The total duration of the complete Bronze layer load.

Prerequisite:
    LOAD DATA LOCAL INFILE requires local file loading to be enabled on
    both the MySQL Server and the MySQL Workbench client connection.

    The server setting can be checked using:

        SHOW GLOBAL VARIABLES LIKE 'local_infile';

    If required, it can be enabled using:

        SET GLOBAL local_infile = ON;

Parameters
None
This file does not accept any procedures or return any value

===============================================================================
*/


-- =============================================================================
-- LOCAL INFILE CONFIGURATION CHECK
-- =============================================================================
-- Run these statements when troubleshooting local file access.
-- They do not need to be executed every time the Bronze layer is loaded.

-- SHOW GLOBAL VARIABLES LIKE 'local_infile';
-- SET GLOBAL local_infile = ON;


-- =============================================================================
-- START BRONZE LAYER LOAD TIMER
-- =============================================================================
-- Capture the starting time of the complete Bronze layer load.

SET @bronze_start_time = NOW(6);


-- =============================================================================
-- CRM SOURCE TABLES
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Load CRM Customer Information
-- -----------------------------------------------------------------------------
-- Capture the table load start time.

SET @start_time = NOW(6);

-- Remove previously loaded records to prevent duplication.

TRUNCATE TABLE bronze.crm_cust_info;

-- Load the CRM customer source file into the Bronze table.

LOAD DATA LOCAL INFILE 'data/source.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Capture the table load completion time.

SET @end_time = NOW(6);

-- Display load statistics:
-- table name, start time, end time, number of loaded rows, and load duration.

SELECT
    'bronze.crm_cust_info' AS table_name,
    @start_time AS start_time,
    @end_time AS end_time,
    COUNT(*) AS rows_loaded,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000, 3) AS duration_seconds
FROM bronze.crm_cust_info;


-- -----------------------------------------------------------------------------
-- Load CRM Product Information
-- -----------------------------------------------------------------------------
-- Capture the table load start time.

SET @start_time = NOW(6);

-- Remove previously loaded records.

TRUNCATE TABLE bronze.crm_prd_info;

-- Load the CRM product source file into the Bronze table.

LOAD DATA LOCAL INFILE 'data/source.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Capture the table load completion time.

SET @end_time = NOW(6);

-- Display load statistics for the CRM product table.

SELECT
    'bronze.crm_prd_info' AS table_name,
    @start_time AS start_time,
    @end_time AS end_time,
    COUNT(*) AS rows_loaded,
    ROUND (TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000, 3) AS duration_seconds
FROM bronze.crm_prd_info;


-- -----------------------------------------------------------------------------
-- Load CRM Sales Details
-- -----------------------------------------------------------------------------
-- Capture the table load start time.

SET @start_time = NOW(6);

-- Remove previously loaded records.

TRUNCATE TABLE bronze.crm_sales_details;

-- Load the CRM sales source file into the Bronze table.

LOAD DATA LOCAL INFILE 'data/source.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Capture the table load completion time.

SET @end_time = NOW(6);

-- Display load statistics for the CRM sales table.

SELECT
    'bronze.crm_sales_details' AS table_name,
    @start_time AS start_time,
    @end_time AS end_time,
    COUNT(*) AS rows_loaded,
    ROUND (TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000, 3) AS duration_seconds
FROM bronze.crm_sales_details;


-- =============================================================================
-- ERP SOURCE TABLES
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Load ERP Customer Information
-- -----------------------------------------------------------------------------
-- Capture the table load start time.

SET @start_time = NOW(6);

-- Remove previously loaded records.

TRUNCATE TABLE bronze.erp_cust_az12;

-- Load the ERP customer source file into the Bronze table.

LOAD DATA LOCAL INFILE 'data/source.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Capture the table load completion time.

SET @end_time = NOW(6);

-- Display load statistics for the ERP customer table.

SELECT 
    'bronze.erp_cust_az12' AS table_name,
    @start_time AS start_time, 
    @end_time AS end_time,
    COUNT(*) AS row_loaded,
    ROUND (TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000, 3) AS duration_seconds
FROM bronze.erp_cust_az12;


-- -----------------------------------------------------------------------------
-- Load ERP Location Information
-- -----------------------------------------------------------------------------
-- Capture the table load start time.

SET @start_time = NOW(6);

-- Remove previously loaded records.

TRUNCATE TABLE bronze.erp_loc_a101;

-- Load the ERP location source file into the Bronze table.

LOAD DATA LOCAL INFILE 'data/source.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Capture the table load completion time.

SET @end_time = NOW(6);

-- Display load statistics for the ERP location table.

SELECT 
    'bronze.erp_loc_a101' AS table_name,
    @start_time AS start_time, 
    @end_time AS end_time,
    COUNT(*) AS row_loaded,
    ROUND (TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000, 3) AS duration_seconds
FROM bronze.erp_loc_a101;


-- -----------------------------------------------------------------------------
-- Load ERP Product Category Information
-- -----------------------------------------------------------------------------
-- Capture the table load start time.

SET @start_time = NOW(6);

-- Remove previously loaded records.

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

-- Load the ERP product category source file into the Bronze table.

LOAD DATA LOCAL INFILE 'data/source.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Capture the table load completion time.

SET @end_time = NOW(6);

-- Display load statistics for the ERP product category table.

SELECT 
    'bronze.erp_px_cat_g1v2' AS table_name,
    @start_time AS start_time, 
    @end_time AS end_time,
    COUNT(*) AS row_loaded,
    ROUND (TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000,3) AS duration_seconds
FROM bronze.erp_px_cat_g1v2;


-- =============================================================================
-- COMPLETE BRONZE LAYER LOAD
-- =============================================================================
-- Capture the completion time of the entire Bronze layer load.

SET @bronze_end_time = NOW(6);

-- Display the overall Bronze layer execution time.
-- The duration includes truncation, file loading, and validation for all tables.

SELECT
    @bronze_start_time AS bronze_start_time,
    @bronze_end_time AS bronze_end_time,
    ROUND(TIMESTAMPDIFF(MICROSECOND, @bronze_start_time, @bronze_end_time) / 1000000,3) 
    AS total_duration_seconds;
