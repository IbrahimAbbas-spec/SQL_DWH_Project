# 📒 Data Catalog — Gold Layer

> **Sales Data Mart** · Star Schema · `gold` schema

---

## 🧭 Overview

The **Gold Layer** is the business-level data representation, structured to
support **analytical and reporting** use cases. It consists of **dimension
tables** and **fact tables** modeling specific business metrics, all exposed
as **SQL views** under the `gold` schema.

| Object | Type | Grain | Sources |
| --- | --- | --- | --- |
| `gold.dim_customers` | 🔵 Dimension | One row per customer | `silver.crm_cust_info` ⊕ `erp_cust_az12` ⊕ `erp_loc_a101` |
| `gold.dim_products` | 🔵 Dimension | One row per **current** product | `silver.crm_prd_info` ⊕ `erp_px_cat_g1v2` |
| `gold.fact_sales` | 🟠 Fact | One row per sales order line | `silver.crm_sales_details` + lookups |

**Relationships** (Star Schema, all 1 : N):

- `dim_customers` 1 ──< `fact_sales` (via `customer_key`)
- `dim_products` 1 ──< `fact_sales` (via `product_key`)

---

## 1. 🔵 `gold.dim_customers`

**Purpose:** Customer dimension enriched with demographic and geographic data,
integrated from CRM (master) + ERP (extras).

**Sources:** `silver.crm_cust_info` ⊕ `silver.erp_cust_az12` ⊕ `silver.erp_loc_a101`

| # | Column | Type | Description |
| - | --- | --- | --- |
| 1 | `customer_key` | INT | 🔑 Surrogate key uniquely identifying each customer record (generated via `ROW_NUMBER()`). |
| 2 | `customer_id` | INT | Unique numerical identifier assigned to each customer (business key from CRM). |
| 3 | `customer_number` | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| 4 | `first_name` | NVARCHAR(50) | The customer's first name, as recorded in the system. |
| 5 | `last_name` | NVARCHAR(50) | The customer's last name (family name). |
| 6 | `country` | NVARCHAR(50) | Country of residence (e.g., `Australia`). Sourced from ERP. |
| 7 | `marital_status` | NVARCHAR(50) | Marital status (e.g., `Married`, `Single`). |
| 8 | `gender` | NVARCHAR(50) | Gender (e.g., `Male`, `Female`, `n/a`). CRM master, ERP fills blanks via `COALESCE`. |
| 9 | `birthdate` | DATE | Date of birth, format `YYYY-MM-DD` (e.g., `1971-10-06`). Sourced from ERP. |
| 10 | `create_date` | DATE | Date when the customer record was created in the source system. |

---

## 2. 🔵 `gold.dim_products`

**Purpose:** Product dimension with category attributes. **Current products
only** (`prd_end_dt IS NULL` filter).

**Sources:** `silver.crm_prd_info` ⊕ `silver.erp_px_cat_g1v2`

| # | Column | Type | Description |
| - | --- | --- | --- |
| 1 | `product_key` | INT | 🔑 Surrogate key uniquely identifying each product record (generated via `ROW_NUMBER()`). |
| 2 | `product_id` | INT | Internal product identifier from the source system. |
| 3 | `product_number` | NVARCHAR(50) | Structured alphanumeric product code, used for categorization and inventory. |
| 4 | `product_name` | NVARCHAR(50) | Descriptive product name including type, color, and size details. |
| 5 | `category_id` | NVARCHAR(50) | Identifier linking the product to its high-level category. |
| 6 | `category` | NVARCHAR(50) | Broad classification (e.g., `Bikes`, `Components`). |
| 7 | `subcategory` | NVARCHAR(50) | More detailed classification within the category. |
| 8 | `maintenance` | NVARCHAR(50) | Whether the product requires maintenance (`Yes` / `No`). |
| 9 | `cost` | INT | Base price of the product (monetary units). |
| 10 | `product_line` | NVARCHAR(50) | Product line / series (e.g., `Road`, `Mountain`). |
| 11 | `start_date` | DATE | Date when the product became available for sale. |

---

## 3. 🟠 `gold.fact_sales`

**Purpose:** Transactional sales data for analytical reporting. One row per
order line.

**Sources:** `silver.crm_sales_details` + lookups to `gold.dim_customers` and `gold.dim_products` for surrogate keys.

| # | Column | Type | Description |
| - | --- | --- | --- |
| 1 | `order_number` | NVARCHAR(50) | Unique alphanumeric identifier for each sales order (e.g., `SO54496`). |
| 2 | `product_key` | INT | 🔗 FK → `dim_products.product_key`. |
| 3 | `customer_key` | INT | 🔗 FK → `dim_customers.customer_key`. |
| 4 | `order_date` | DATE | Date when the order was placed. |
| 5 | `shipping_date` | DATE | Date when the order was shipped to the customer. |
| 6 | `due_date` | DATE | Date when the order payment was due. |
| 7 | `sales_amount` | INT | Total monetary value of the line item (e.g., `25`). Calculated: `quantity × price`. |
| 8 | `quantity` | INT | Number of units of the product ordered for the line item (e.g., `1`). |
| 9 | `price` | INT | Price per unit of the product for the line item (e.g., `25`). |

---

## 🔗 Related artifacts

- 📜 DDL: [`scripts/gold/ddl_gold.sql`](../scripts/gold/ddl_gold.sql)
- 🌀 Data flow: [`docs/data_flow.png`](./data_flow.png)
- 🗜️ Data model: [`docs/data_model.png`](./data_model.png)

---

_Last updated: 2026-06-09 · Owner: Ibrahim Abbas_
