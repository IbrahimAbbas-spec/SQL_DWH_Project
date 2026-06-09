# 🏷️ Naming Conventions

> Rules for naming **databases · schemas · tables · views · columns · stored procedures**
> in the SQL Data Warehouse project.

## 📑 Table of Contents

1. [General Principles](#-general-principles)
2. [Table Naming Conventions](#-table-naming-conventions)
   - [🟫 Bronze Rules](#-bronze-rules)
   - [⚪ Silver Rules](#-silver-rules)
   - [🟡 Gold Rules](#-gold-rules)
3. [Column Naming Conventions](#-column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedures](#️-stored-procedures)

---

## 🧱 General Principles

| Rule | Detail |
| --- | --- |
| 🐍 **Case style** | `snake_case` — lowercase letters and underscores (`_`) to separate words |
| 🇬🇧 **Language** | English for all object names |
| 🚫 **Reserved words** | Do not use SQL reserved words (`order`, `date`, `user`, `key`, …) as object names |

---

## 📊 Table Naming Conventions

| Layer | Pattern | Example | Rule |
| --- | --- | --- | --- |
| 🟫 Bronze | `<source>_<entity>` | `crm_customer_info` | Keep the original source-system table name |
| ⚪ Silver | `<source>_<entity>` | `crm_customer_info` | Same as Bronze (raw-clean, source-shaped) |
| 🟡 Gold | `<category>_<entity>` | `dim_customers` · `fact_sales` | Business-aligned name + category prefix |

### 🟫 Bronze Rules

- All names must **start with the source-system name**; table names must **match their original names** without renaming.
- **Pattern:** `<sourcesystem>_<entity>`
  - `<sourcesystem>` — name of the source system (e.g., `crm`, `erp`).
  - `<entity>` — exact table name from the source system.
- **Example:** `crm_customer_info` → customer information from the CRM system.

### ⚪ Silver Rules

- Same rule as Bronze — keep the source-system name and entity name unchanged.
- **Pattern:** `<sourcesystem>_<entity>`
  - `<sourcesystem>` — name of the source system (e.g., `crm`, `erp`).
  - `<entity>` — exact table name from the source system.
- **Example:** `crm_customer_info` → cleansed customer information from CRM, schema-aligned to Bronze.

### 🟡 Gold Rules

- Names must use **meaningful, business-aligned** terms, prefixed by the **category**.
- **Pattern:** `<category>_<entity>`
  - `<category>` — role of the table (`dim`, `fact`, `report`, …).
  - `<entity>` — business name (`customers`, `products`, `sales`, …).
- **Examples:**
  - `dim_customers` → dimension table for customer data.
  - `fact_sales` → fact table containing sales transactions.

#### Glossary of Category Patterns

| Pattern | Meaning | Example(s) |
| --- | --- | --- |
| `dim_` | Dimension table | `dim_customers`, `dim_products` |
| `fact_` | Fact table | `fact_sales` |
| `report_` | Report / data product | `report_customers`, `report_sales_monthly` |

---

## 🔑 Column Naming Conventions

### Surrogate Keys

- All primary keys in **dimension** tables must use the suffix `_key`.
- **Pattern:** `<table_name>_key`
  - `<table_name>` — the table or entity the key belongs to.
  - `_key` — suffix indicating a surrogate key.
- **Example:** `customer_key` → surrogate key in the `dim_customers` table.

### Technical Columns

- All technical / system metadata columns must start with the prefix `dwh_`.
- **Pattern:** `dwh_<column_name>`
  - `dwh` — reserved prefix for system-generated metadata.
  - `<column_name>` — descriptive purpose of the column.
- **Example:** `dwh_create_date` → system-generated column storing the date when the record was loaded.

---

## ⚙️ Stored Procedures

- All stored procedures used for loading data must follow the pattern:
- **Pattern:** `load_<layer>`
  - `<layer>` — the layer being loaded (`bronze`, `silver`, `gold`).
- **Examples:**
  - `bronze.load_bronze` → stored procedure for loading data into the Bronze layer.
  - `silver.load_silver` → stored procedure for loading data into the Silver layer.
  - `gold.load_gold` → (if Gold is materialized) loading dims + facts.

---

## 📌 Quick reference

    -- Bronze (source-shaped, raw)
    bronze.crm_customer_info
    bronze.erp_orders

    -- Silver (source-shaped, cleansed)
    silver.crm_customer_info
    silver.erp_orders

    -- Gold (business-shaped, star schema)
    gold.dim_customers        -- customer_key (PK)
    gold.dim_products         -- product_key  (PK)
    gold.fact_sales           -- customer_key (FK), product_key (FK)
    gold.report_sales_monthly

    -- Technical column
    dwh_create_date

    -- Stored procedures
    EXEC bronze.load_bronze;
    EXEC silver.load_silver;

---

_Last updated: 2026-06-09 · Owner: Ibrahim Abbas_
