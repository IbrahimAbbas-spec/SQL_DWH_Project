/*
===============================================================================
Quality Checks: Silver Layer
===============================================================================
Purpose:
    Re-runs all data quality checks against the SILVER tables AFTER load.
    Verifies that the cleansing applied in silver.load_silver actually worked.

    Expectation:
      - For filter queries: NO ROWS returned.
      - For DISTINCT queries: only the expected standard values.

    Run AFTER:  EXEC silver.load_silver;
Usage:
    Run each section independently. Investigate any row that comes back.
===============================================================================
*/

USE DataWarehouse;
GO

-- =========================================================
-- 1. silver.crm_cust_info
-- =========================================================

-- 1.1 Nulls or duplicates in primary key (cst_id)
-- Expectation: No Results
SELECT
    cst_id,
    COUNT(*) AS dup_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 1.2 Unwanted spaces in string columns
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- 1.3 Standardization of low-cardinality columns
-- Expectation: Only 'Female', 'Male', 'n/a'
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;

-- Expectation: Only 'Single', 'Married', 'n/a'
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;


-- =========================================================
-- 2. silver.crm_prd_info
-- =========================================================

-- 2.1 Nulls or duplicates in primary key (prd_id)
-- Expectation: No Results
SELECT
    prd_id,
    COUNT(*) AS dup_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2.2 Unwanted spaces in product name
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 2.3 Negative or NULL prd_cost
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 2.4 Standardization of prd_line
-- Expectation: Only 'Mountain', 'Road', 'Other Sales', 'Touring', 'n/a'
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- 2.5 Invalid date order (end before start)
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- =========================================================
-- 3. silver.crm_sales_details
-- =========================================================

-- 3.1 Invalid date order (order must be earlier than ship and due)
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- 3.2 Business rule: Sales = Quantity * Price
-- Also: no negatives, zeros, or nulls allowed in any of the 3 columns
-- Expectation: No Results
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales   IS NULL
   OR sls_quantity IS NULL
   OR sls_price   IS NULL
   OR sls_sales   <= 0
   OR sls_quantity <= 0
   OR sls_price   <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


-- =========================================================
-- 4. silver.erp_cust_az12
-- =========================================================

-- 4.1 Out-of-range birth dates (very old customers or future birthdays)
-- Expectation: Birthdates between 1924-01-01 and today only
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- 4.2 Standardization of gen
-- Expectation: Only 'Female', 'Male', 'n/a'
SELECT DISTINCT gen FROM silver.erp_cust_az12;


-- =========================================================
-- 5. silver.erp_loc_a101
-- =========================================================

-- 5.1 Standardization of cntry
-- Expectation: Only readable country names, no codes ('DE','US'), no blanks
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- =========================================================
-- 6. silver.erp_px_cat_g1v2
-- =========================================================

-- 6.1 Unwanted spaces
-- Expectation: No Results
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat         != TRIM(cat)
   OR subcat      != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- 6.2 Standardization of maintenance
-- Expectation: Only standard values (e.g. 'Yes', 'No')
SELECT DISTINCT maintenance FROM silver.erp_px_cat_g1v2;
