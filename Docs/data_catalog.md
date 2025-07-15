# Data Catalog for Gold Layer

## Overview
The Gold Layer represents business-level curated data designed for analytics and reporting. It consists of **dimension tables and fact tables** supporting specific business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Contains enriched customer details including demographic and geographic information.
- **Columns:**

| Column Name      | Data Type   | Description                                                        |
| ---------------- | ----------- | ------------------------------------------------------------------ |
| customer\_key    | INT         | Surrogate key uniquely identifying each customer in the dimension. |
| customer\_id     | INT         | Unique numerical identifier assigned to each customer.             |
| customer\_number | VARCHAR(50) | Alphanumeric customer code used for tracking and referencing.      |
| first\_name      | VARCHAR(50) | Customer's first name.                                             |
| last\_name       | VARCHAR(50) | Customer's last name or family name.                               |
| country          | VARCHAR(50) | Country of residence (e.g., 'Australia').                          |
| marital\_status  | VARCHAR(50) | Marital status (e.g., 'Married', 'Single').                        |
| gender           | VARCHAR(50) | Gender (e.g., 'Male', 'Female', 'unknown').                            |
| birthdate        | DATE        | Customer's date of birth in YYYY-MM-DD format (e.g., 1982-04-16).  |
| create\_date     | DATE        | Record creation date.                                              |

---

### 2. **gold.dim_products**
- **Purpose:** Holds product information including category, cost, and availability.
- **Columns:**

| Column Name           | Data Type   | Description                                                 |
| --------------------- | ----------- | ----------------------------------------------------------- |
| product\_key          | INT         | Surrogate key uniquely identifying each product.            |
| product\_id           | INT         | Internal product identifier.                                |
| product\_number       | VARCHAR(50) | Alphanumeric code used to categorize or inventory products. |
| product\_name         | VARCHAR(50) | Descriptive product name (e.g., type, size, color).         |
| category\_id          | VARCHAR(50) | Identifier linking the product to its high-level category.  |
| category              | VARCHAR(50) | High-level classification (e.g., Bikes, Components).        |
| subcategory           | VARCHAR(50) | Detailed classification within a category.                  |
| maintenance\_required | VARCHAR(50) | Indicates if product requires maintenance ('Yes'/'No').     |
| cost                  | INT         | Base cost of the product.                                   |
| product\_line         | VARCHAR(50) | Product line (e.g., Road, Mountain).                        |
| start\_date           | DATE        | Date when product became available.                         |

---

### 3. **gold.fact_sales**
- **Purpose:** Captures transactional sales data for analysis.
- **Columns:**

| Column Name    | Data Type   | Description                                                            |
| -------------- | ----------- | ---------------------------------------------------------------------- |
| order\_number  | VARCHAR(50) | Unique alphanumeric identifier for each sales order (e.g., 'SO54496'). |
| product\_key   | INT         | Foreign key linking to the product dimension.                          |
| customer\_key  | INT         | Foreign key linking to the customer dimension.                         |
| order\_date    | DATE        | Date the order was placed.                                             |
| shipping\_date | DATE        | Date the order was shipped.                                            |
| due\_date      | DATE        | Due date for payment.                                                  |
| sales\_amount  | INT         | Total sales value in whole currency units (e.g., 25).                  |
| quantity       | INT         | Number of units sold in the transaction.                               |
| price          | INT         | Unit price of the product in the transaction.                          |

    
