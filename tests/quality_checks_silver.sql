
/*
===============================================================================
                    SILVER LAYER | QUALITY CHECKS
===============================================================================

Purpose:
    Validate the cleaned and transformed data loaded into the Silver layer.

Checks Performed:
    - Primary-key completeness and uniqueness.
    - Missing or invalid values.
    - Data standardization and consistency.
    - Date validity and chronological order.
    - Sales, quantity, and price consistency.

Usage Notes:
    - Run these checks after loading data in silver layer. 
    - Investigate and Resolve any issues or discrepencies found. 

===============================================================================
*/


-- =============================================================================
-- 1. CRM CUSTOMER DATA
-- =============================================================================

-- Check the total number of customer records and creation-date completeness.

SELECT
    COUNT(*) AS total_customers,
    COUNT(cst_create_date) AS valid_dates,
    SUM(cst_create_date IS NULL) AS missing_dates
FROM silver.crm_cust_info;

-- Verify customer ID uniqueness and completeness.
-- Expected result: no rows.

SELECT cst_id, COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check ofr invalid zero dates 
-- Expected result: 0.

SELECT
    COUNT(*) AS zero_date_count
FROM silver.crm_cust_info
WHERE CAST(cst_create_date AS CHAR(10)) = '0000-00-00';


-- Data standardized & Consistency

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;


SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;


-- =============================================================================
-- 2. CRM PRODUCT DATA
-- =============================================================================

-- Nulls or dupliactes in primary key 
-- Expected result: no rows.

SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for unwanted leading or trailing whitespace.
-- Expected result: no rows.

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Check for missing or negative.
-- Expected result: no rows.

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL ;

-- Data standardized & Consistency

SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- Verify product validity periods.
-- A product start date should not occur after its end date.
-- Expected result: no rows.

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;

-- =============================================================================
-- 3. CRM SALES DATA
-- =============================================================================

-- Verify chronological consistency of sales dates.
--
-- Expected relationship:
--     Order Date <= Shipping Date
--     Order Date <= Due Date
--
-- Expected result: no rows.

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt;


-- Validate the relationship between sales, quantity, and price.
--
-- Business rule:
--     Sales = Quantity × Price
--
-- Also check for NULL, zero, or negative values.
-- Expected result: no rows.

SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;


-- =============================================================================
-- 4. ERP CUSTOMER DATA
-- =============================================================================

-- Check for invalid future birth dates.
-- Expected result: no rows.

SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate > CURRENT_DATE();


-- Data standardized & Consistency

SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;


-- =============================================================================
-- 5. ERP LOCATION DATA
-- =============================================================================

-- Review standardized country values.
-- This confirms that abbreviations and missing values were handled
-- according to the Silver transformation rules.

SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- =============================================================================
-- 6. ERP PRODUCT CATEGORY DATA
-- =============================================================================

-- Check category-related columns for unwanted whitespace.
-- Expected result: no rows.

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);


-- Review maintenance values for consistency.

SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;

