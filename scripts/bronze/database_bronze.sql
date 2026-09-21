/*
===============================================================================
                    CREATE BRONZE LAYER TABLES
===============================================================================

Purpose:
    This script creates the tables required for the Bronze layer of the
    Data Warehouse.

Source Systems:
    Data is received from two source systems:

        1. CRM
            - cust_info
            - prd_info
            - sales_details

        2. ERP
            - cust_az12
            - loc_a101
            - px_cat_g1v2

Bronze Layer:
    The Bronze layer stores raw source data with minimal transformation.

Process:
    1. Check whether each table already exists.
    2. Drop the existing table if it exists.
    3. Create a fresh empty table using the structure of the source data.
    4. The tables will later be populated using the Bronze data-load script.

Note:
    DROP TABLE IF EXISTS makes the script reusable by preventing errors
    when the table already exists.

===============================================================================
*/


-- =============================================================================
-- CRM SOURCE TABLES
-- =============================================================================


-- -----------------------------------------------------------------------------
-- CRM Customer Information
-- -----------------------------------------------------------------------------
-- Stores raw customer information received from the CRM source system.

DROP TABLE IF EXISTS  bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT, 
	cst_key NVARCHAR (50),
	cst_firstname NVARCHAR (50),
	cst_lastname NVARCHAR (50),
	cst_marital_status NVARCHAR (50),
	cst_gndr NVARCHAR (50),
	cst_create_date DATE 
);

-- -----------------------------------------------------------------------------
-- CRM Product Information
-- -----------------------------------------------------------------------------
-- Stores raw product information received from the CRM source system.

DROP TABLE IF EXISTS  bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (

	prd_id INT,
	prd_key NVARCHAR (50),
	prd_nm NVARCHAR (50),
	prd_cost INT,
	prd_line NVARCHAR (50),
	prd_start_dt DATE,
	prd_end_dt DATETIME
);

-- -----------------------------------------------------------------------------
-- CRM Sales Details
-- -----------------------------------------------------------------------------
-- Stores raw sales transaction data received from the CRM source system.

DROP TABLE IF EXISTS  bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (

	sls_ord_num NVARCHAR (50),
	sls_prd_key NVARCHAR (50),
	sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT, 
    sls_quantity INT,
    sls_price INT
);

-- =============================================================================
-- ERP SOURCE TABLES
-- =============================================================================


-- -----------------------------------------------------------------------------
-- ERP Customer Information
-- -----------------------------------------------------------------------------
-- Stores additional customer information received from the ERP source system.


DROP TABLE IF EXISTS  bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);
-- -----------------------------------------------------------------------------
-- ERP Location Information
-- -----------------------------------------------------------------------------
-- Stores customer location and country information received from the ERP system.

DROP TABLE IF EXISTS  bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

-- -----------------------------------------------------------------------------
-- ERP Product Category Information
-- -----------------------------------------------------------------------------
-- Stores product category and maintenance information received from the ERP system.

DROP TABLE IF EXISTS  bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
	id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
 );

