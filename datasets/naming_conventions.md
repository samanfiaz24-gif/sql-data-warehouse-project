# Naming Conventions

## Overview

This document defines the naming standards used across the data warehouse to maintain consistency and readability.

---

## General Principles

- Use `snake_case` with lowercase letters and underscores.
- Use English for all database object names.
- Use clear and descriptive names.
- Avoid SQL reserved words where possible.
- Maintain consistent naming across Bronze, Silver, and Gold layers.

---

## Schema Naming

The warehouse follows the Medallion Architecture:

| Schema | Purpose |
|---|---|
| `bronze` | Raw source data |
| `silver` | Cleaned and standardized data |
| `gold` | Business-ready analytical data |

---

## Table Naming Conventions

### Bronze Layer

Bronze tables preserve the source-system naming structure.

**Pattern:**

```text
<source_system>_<entity>
```

Examples:

- `crm_cust_info`
- `crm_prd_info`
- `crm_sales_details`
- `erp_cust_az12`
- `erp_loc_a101`

---

### Silver Layer

Silver tables retain the same source-oriented names as the Bronze layer.

**Pattern:**

```text
<source_system>_<entity>
```

Examples:

- `silver.crm_cust_info`
- `silver.crm_prd_info`
- `silver.erp_cust_az12`

This maintains clear traceability between Bronze and Silver data.

---

## Gold View Naming

Gold objects use business-friendly names based on their role in the Star Schema.

**Pattern:**

```text
<category>_<entity>
```

| Prefix | Meaning | Example |
|---|---|---|
| `dim_` | Dimension view | `dim_customers` |
| `fact_` | Fact view | `fact_sales` |

Current Gold views:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

---

## Column Naming Conventions

Column names use lowercase `snake_case` and should clearly describe the data they contain.

Examples:

```text
customer_id
customer_number
product_name
order_date
sales_amount
```

### Surrogate Keys

Dimension surrogate keys use the `_key` suffix.

**Pattern:**

```text
<entity>_key
```

Examples:

- `customer_key`
- `product_key`

These keys are generated for use within the Gold analytical model.

---

### Technical Columns

Warehouse-generated metadata columns use the `dwh_` prefix.

**Pattern:**

```text
dwh_<column_name>
```

Example:

```text
dwh_create_date
```

`dwh_create_date` records when a row is loaded into the Silver layer.

---

## Stored Procedure Naming

Stored procedures used for warehouse loading follow:

```text
load_<layer>
```

Example:

```text
silver.load_silver
```

The Silver layer is loaded using:

```sql
CALL silver.load_silver();
```

The Bronze layer uses a SQL loading script rather than a stored procedure because MySQL does not allow `LOAD DATA LOCAL INFILE` inside stored procedures.

---

## SQL Script Naming

SQL scripts use descriptive lowercase names with underscores.

Examples:

```text
create_bronze_tables.sql
load_bronze.sql
create_silver_tables.sql
load_silver.sql
quality_checks.sql
create_gold_views.sql
```

---

## Summary

The project follows consistent naming standards to ensure:

- Clear source-system traceability
- Easy identification of warehouse layers
- Consistent analytical object naming
- Readable and maintainable SQL
