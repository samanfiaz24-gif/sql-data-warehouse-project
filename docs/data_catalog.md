# Gold Layer Data Dictionary

## Overview

The Gold Layer contains business-ready data designed for reporting and analytical use cases.

It follows a **Star Schema** and consists of:

- **Dimension Views** - descriptive information that provides business context.
- **Fact View** — transactional data containing measurable business metrics.

### Gold Layer Objects

| Object | Type | Description |
|---|---|---|
| `gold.dim_customers` | Dimension View | Contains customer demographic and geographic information. |
| `gold.dim_products` | Dimension View | Contains current product and product-category information. |
| `gold.fact_sales` | Fact View | Contains sales transactions and measurable sales metrics. |

---

# 1. `gold.dim_customers`

**Purpose:**  
Stores customer information enriched with demographic and geographic data from CRM and ERP sources.

| Column Name | Data Type | Description |
|---|---|---|
| `customer_key` | INT | Surrogate key generated in the Gold Layer to uniquely identify each customer record in the dimension view. |
| `customer_id` | INT | Unique numerical identifier assigned to the customer in the CRM source system. |
| `customer_number` | VARCHAR(50) | Alphanumeric business identifier used to track and reference the customer across source systems. |
| `firstname` | VARCHAR(50) | Customer's first name as recorded in the CRM system after Silver-layer cleaning. |
| `lastname` | VARCHAR(50) | Customer's last name or family name as recorded in the CRM system. |
| `country` | VARCHAR(50) | Standardized country associated with the customer, sourced from ERP location data. |
| `marital_status` | VARCHAR(50) | Standardized marital status of the customer, such as `Married`, `Single`, or `n/a`. |
| `gender` | VARCHAR(50) | Integrated gender value, using CRM as the preferred source and ERP as a fallback when CRM contains `n/a`. |
| `birthdate` | DATE | Customer's date of birth sourced from ERP customer data and stored in `YYYY-MM-DD` format. |
| `create_date` | DATE | Date when the customer record was originally created in the CRM source system. |

---

# 2. `gold.dim_products`

**Purpose:**  
Stores descriptive information about currently active products enriched with ERP category data.

| Column Name | Data Type | Description |
|---|---|---|
| `product_key` | INT | Surrogate key generated in the Gold Layer to uniquely identify each product record in the dimension view. |
| `product_id` | INT | Unique numerical identifier assigned to the product in the CRM source system. |
| `product_number` | VARCHAR(50) | Alphanumeric business identifier used to reference the product and link it to sales transactions. |
| `product_name` | VARCHAR(50) | Descriptive name of the product as recorded in the CRM product data. |
| `category_id` | VARCHAR(50) | Standardized category identifier derived from the original CRM product key during Silver-layer transformation. |
| `category` | VARCHAR(50) | High-level product classification obtained from ERP category data, such as `Bikes` or `Components`. |
| `subcategory` | VARCHAR(50) | More detailed product classification within the main product category. |
| `maintenance` | VARCHAR(50) | Attribute indicating the maintenance classification associated with the product category. |
| `cost` | INT | Product cost recorded in the CRM source and standardized during Silver-layer processing. |
| `product_line` | VARCHAR(50) | Standardized product-line description such as `Road`, `Mountain`, `Touring`, or `Other Sales`. |
| `start_date` | DATE | Effective start date of the current product record, indicating when the product version became active. |

**Business Rule:**  
Only current product records where `prd_end_dt IS NULL` are included.

---

# 3. `gold.fact_sales`

**Purpose:**  
Stores sales transactions and measurable business values for analytical use.

| Column Name | Data Type | Description |
|---|---|---|
| `order_number` | VARCHAR(50) | Alphanumeric sales-order identifier used to track and reference each business transaction. |
| `product_key` | INT | Surrogate key that associates the sales transaction with the corresponding product record in `gold.dim_products`. |
| `customer_key` | INT | Surrogate key that associates the sales transaction with the corresponding customer record in `gold.dim_customers`. |
| `order_date` | DATE | Date when the customer placed the sales order, stored in `YYYY-MM-DD` format. |
| `shipping_date` | DATE | Date when the ordered product was shipped to the customer. |
| `due_date` | DATE | Date by which the sales order was expected to be completed or fulfilled. |
| `sales_amount` | INT | Total monetary value of the sales transaction, validated against quantity and unit price during Silver-layer processing. |
| `quantity` | INT | Number of units sold for the product in the sales transaction. |
| `price` | INT | Unit selling price of the product used to calculate the sales amount. |
