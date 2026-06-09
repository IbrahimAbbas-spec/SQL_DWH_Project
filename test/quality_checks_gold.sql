/*
===============================================================================
Quality Checks: Gold Layer
===============================================================================
Purpose:
    Validates the Gold views AFTER deploying ddl_gold.sql.
    Confirms that the Star Schema is loaded correctly:
      - Surrogate keys are unique in dimensions.
      - Every fact row resolves to a real dim row (no orphans).
      - Measures obey: sales_amount = quantity * price.
      - Dates obey:    order_date <= shipping_date <= due_date.
      - Totals reconcile to Silver.

    Expectation:
      - For filter queries:    NO ROWS returned.
      - For DISTINCT queries:  only the expected standard values.
      - For reconciliation:    Gold == Silver counts/totals.

    Run AFTER:  ddl_gold.sql
Usage:
    Run each section independently. Investigate any row that comes back.
===============================================================================
*/

USE DataWarehouse;
GO

-- =========================================================
-- 1. gold.dim_customers
-- =========================================================

-- 1.1 Surrogate-key uniqueness
-- Expectation: No Results
SELECT
    customer_key,
    COUNT(*) AS dup_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- 1.2 Business-key uniqueness (customer_id)
-- Expectation: No Results
SELECT
    customer_id,
    COUNT(*) AS dup_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 1.3 Nulls in mandatory columns
-- Expectation: No Results
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL
   OR customer_id  IS NULL;

-- 1.4 Standardization checks (low-cardinality dim attributes)
-- Expectation: only expected standard values
SELECT DISTINCT gender         FROM gold.dim_customers;   -- Female, Male, n/a
SELECT DISTINCT marital_status FROM gold.dim_customers;   -- Single, Married, n/a
SELECT DISTINCT country        FROM gold.dim_customers;   -- full names only


-- =========================================================
-- 2. gold.dim_products
-- =========================================================

-- 2.1 Surrogate-key uniqueness
-- Expectation: No Results
SELECT
    product_key,
    COUNT(*) AS dup_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- 2.2 Business-key uniqueness (product_number)
-- Expectation: No Results
SELECT
    product_number,
    COUNT(*) AS dup_count
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;

-- 2.3 Current rows only — sanity row count
-- Expectation: gold count == silver count of current products (prd_end_dt IS NULL)
SELECT
    (SELECT COUNT(*) FROM gold.dim_products)                                    AS gold_dim_products_count,
    (SELECT COUNT(*) FROM silver.crm_prd_info WHERE prd_end_dt IS NULL)          AS expected_current_count;

-- 2.4 Category resolution after LEFT JOIN with erp_px_cat_g1v2
-- Investigate any product without category/subcategory
SELECT product_key, product_number, category_id, category, subcategory
FROM gold.dim_products
WHERE category    IS NULL
   OR subcategory IS NULL;

-- 2.5 Standardization checks
-- Expectation: only expected standard values
SELECT DISTINCT category     FROM gold.dim_products;
SELECT DISTINCT product_line FROM gold.dim_products;   -- Mountain, Road, Other Sales, Touring, n/a
SELECT DISTINCT maintenance  FROM gold.dim_products;   -- Yes, No

-- 2.6 Negative or NULL cost
-- Expectation: No Results
SELECT product_key, product_number, cost
FROM gold.dim_products
WHERE cost < 0
   OR cost IS NULL;


-- =========================================================
-- 3. gold.fact_sales
-- =========================================================

-- 3.1 Fact → dim_customers FK integrity (no orphans)
-- Expectation: No Results
SELECT f.*
FROM      gold.fact_sales    f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- 3.2 Fact → dim_products FK integrity (no orphans)
-- Expectation: No Results
SELECT f.*
FROM      gold.fact_sales   f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
WHERE p.product_key IS NULL;

-- 3.3 Nulls in mandatory keys / dates
-- Expectation: No Results
SELECT *
FROM gold.fact_sales
WHERE order_number IS NULL
   OR customer_key IS NULL
   OR product_key  IS NULL
   OR order_date   IS NULL;

-- 3.4 Measure rule: sales_amount = quantity * price
-- Also: no negatives, zeros, or nulls in any of the 3 measures
-- Expectation: No Results
SELECT DISTINCT
    sales_amount,
    quantity,
    price,
    quantity * price AS expected_sales_amount
FROM gold.fact_sales
WHERE sales_amount <> quantity * price
   OR sales_amount IS NULL
   OR quantity     IS NULL
   OR price        IS NULL
   OR sales_amount <= 0
   OR quantity     <= 0
   OR price        <= 0
ORDER BY sales_amount, quantity, price;

-- 3.5 Date logic: order_date <= shipping_date <= due_date
-- Expectation: No Results
SELECT
    order_number,
    order_date,
    shipping_date,
    due_date
FROM gold.fact_sales
WHERE order_date    > shipping_date
   OR shipping_date > due_date
   OR order_date    > due_date;

-- 3.6 Row count reconciliation: fact_sales vs silver.crm_sales_details
-- Expectation: counts should match (1 fact row per source row)
SELECT
    (SELECT COUNT(*) FROM gold.fact_sales)            AS gold_fact_sales_count,
    (SELECT COUNT(*) FROM silver.crm_sales_details)   AS silver_sales_count;

-- 3.7 Total reconciliation: SUM(sales_amount) Gold vs Silver
-- Expectation: totals should match
SELECT
    (SELECT SUM(sales_amount) FROM gold.fact_sales)         AS gold_total_sales,
    (SELECT SUM(sls_sales)    FROM silver.crm_sales_details) AS silver_total_sales;
