/*
===============================================================================
                     GOLD LAYER | QUALITY CHECKS
===============================================================================

Purpose:
    Validate the integrity and consistency of the Gold-layer star schema.

Checks:
    - Validate standardized dimension values.
    - Confirm surrogate key uniqueness.
    - Verify fact-to-dimension relationships.

Expected Result:
    Integrity checks should return no rows unless stated otherwise.

===============================================================================
*/


-- =============================================================================
-- 1. CUSTOMER DIMENSION CHECKS
-- =============================================================================

-- Review standardized gender values.
-- Expected values: Male, Female, n/a


SELECT DISTINCT gender 
FROM gold.dim_customer;

-- Verify uniqueness of the customer surrogate key.
-- Expected result: no rows.

SELECT 
    customer_key, COUNT(*) AS duplicate_counts
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- =============================================================================
-- 2. PRODUCT DIMENSION CHECKS
-- =============================================================================

-- Verify uniqueness of the product surrogate key.
-- Expected result: no rows.

SELECT 
    product_key,COUNT(*) AS duplicate_counts
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- =============================================================================
-- 3. FACT TABLE REFERENTIAL INTEGRITY
-- =============================================================================

-- Identify sales records without a matching customer dimension record.
-- Expected result: no rows.

SELECT * 
FROM gold.fact_sales as f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- Identify sales records without a matching product dimension record.
-- Expected result: no rows.

SELECT * 
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE p.product_key IS NULL;
