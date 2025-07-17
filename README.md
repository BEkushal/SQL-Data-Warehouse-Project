# Data Warehouse and Analytics Project

Welcome to a complete **Retail Data Warehouse and Analytics Project** 🚀
The project was designed and developed to simulate real-world data processes as expected in professional data analyst roles. 
It covers both data engineering (**ETL**) and analytics tasks: from creating a scalable data warehouse to performing advanced analytical techniques that yield actionable insights.

---

## Overview

The project is structured into two major components:

1. **Data Warehouse (DW) Design & Development**
2. **Advanced Data Analysis (ADA)** using SQL

Together, they form a complete data backbone for business insights and decision-making.

## 🏗️ Data Architecture

This project follows the **Medallion Architecture**- a structured approach using **Bronze**, **Silver**, and **Gold** layers to design scalable and maintainable data solutions.

![Data Architecture](https://github.com/user-attachments/assets/90562c9a-e28c-40e6-a3da-ca77dc4528a3)

1. **Bronze Layer**: Ingests raw data from CSV files into SQL Server (ERP and CRM datasets).
2. **Silver Layer**: Cleanses, standardizes, and transforms the data for quality and consistency.
3. **Gold Layer**: Constructs business-ready analytical views using a star schema model - the foundation for analytics and reporting.

---

## 📖 What This Project Covers

Key Focus Areas:

1. **Data Architecture Design** using the **Medallion approach**.
2. **ETL Pipeline** Creation to extract, transform, and load data using SQL.
3. **Data Modeling** with fact and dimension tables suitable for analytics.
4. **SQL-Based Analysis & Reporting** to extract actionable business insights.

🎯 This journey enhances my skills in:
- SQL Development
- Data Warehousing
- ETL Pipeline Design
- Dimensional Modeling
- Data Analytics
- Git & Project Documentation

---

🛠️ Tools & Resources I Used

All the tools I used are open source or free to use:
- **📂 [Datasets](Datasets/):** Access to the project dataset (csv files).
- **🖥️ [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/install/install?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **🔧 [GitHub](https://github.com/):** for version control and project documentation.
- **🎨 [DrawIO](https://www.drawio.com/):** to design data flows and architecture.
- **🧠 [Notion](https://www.notion.com/):** for organizing project steps
- **📋 [Step-by-Step Project Tasks](https://www.notion.so/Data-Warehouse-Analytics-Project-22c3e2a31005806b8e59c3510c87dde9?source=copy_link):** Access to All Project Phases and Tasks.

---

## 🚀 Project Distribution 

### 📂 Repository Structure

```
data-warehouse-project/
│
├── Datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── Data-Integration.png            # Draw.io file shows the ERP and CRM integration with lablings (customer, product & sales) 
│   ├── Data-Model.png                  # Draw.io file for data models (star schema)
│   ├── Data-lineage.png                # Draw.io file for the data flow diagram
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│
├── scripts/                            # SQL scripts for ETL (database & schemas DDL), transformations and advanced data analytics 
│   ├── ADA/                            # Scripts involving advanced data analysis (part-to-whole, data segmentation etc)
|   ├── EDA/                            # Scripts involving inital explorations for advanced analysis (dimensions, measures etc)
|   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── gold/                           # Scripts for creating analytical models
│   ├── silver/                         # Scripts for cleaning and transforming data
│
├── tests/                              # Test scripts and quality files (silver & gold)
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
```

### ✅ 1. Data Engineering – Data Warehouse Build

#### Goal:
Build a SQL Server-based data warehouse using ERP and CRM data to consolidate and analyze sales data enabling data driven decision making.

#### My Key Takeaways:
- **Data Source(s):** Imported and explored raw data from two systems (CSV format).
- **Data Quality:** Addressed data quality and performed necessary transformations.
- **Data Integration:** Created a clean analytical data model, combining both sources into one.
- **Scope:** Focused on the latest available dataset (no historization).
- **Documentation:** Documented the process for clarity and reproducibility.

---

### 📊 2. Data Analytics (EDA + ADA) – Making Sense of the Data

#### Goal:
Building upon the Gold Layer views, develop SQL scripts to uncover insights into:
- **Customer Behavior**
- **Product-level Performance**
- **Sales Trends and KPIs**

#### 🔍 Exploratory Data Analysis (EDA)

* **Dimension Exploration:** Product categories, subcategories, customer age, and region.
* **Measure Exploration:** Sales amount, quantity, discounts, and pricing.
* **Date Analysis:** Sales by order date, monthly trends, seasonal patterns.
* **Ranking Analysis:** Identifying top customers, products, and high-volume order channels.

### 📈 Advanced Data Analysis (ADA)

* **Cumulative KPIs:** Moving averages, running totals for sales, quantity, and revenue.
* **Part-to-Whole Analysis:**

  * Example: The "Bikes" category dominates with ``96.46%`` of total sales.
  * "Clothing" and "Accessories" contribute just ``1.16%`` and ``2.39%`` respectively.
* **Performance Over Time:** Evaluates Year On Year (YoY) or Month On Month (MoM) sales to product performance trends and analysis.
* **Customer Segmentation:**
  * Based on customer lifecycle (association span) and monetary spend:
    *  **Association Span**: Time between their first and last order.
    *  **Spending Behavior**: Total revenue generated.
    *  Using these two metrics:

      | Segment   | Criteria                                       | Count  |
      |-----------|------------------------------------------------|--------|
      | New       | Span < 12 months                               | 14631  |
      | Regular   | Span ≥ 12 months AND Spending ≤ 5000 units     | 2198   |
      | VIP       | Span ≥ 12 months AND Spending > 5000 units     | 1655   |
    
---

### 📝 Business Reporting

Two reports are built to provide a holistic understanding of business performance:

* **Customer Report:**

  * Total orders, total revenue, customer segmentation, order recency, average spend, and customer lifetime value.

* **Product Report:**

  * Sales distribution by category/subcategory, quantity sold, revenue KPIs, and product segmentation by performance.

These reports are modeled as SQL views to support further dashboarding and BI consumption.

---


## 🔮 Future Scope

The next logical step is integrating this solution with a BI tool (e.g., **Power BI**, **Tableau**) using the gold-layer SQL views as the data source. This enables:

* **Interactive Dashboards** for executive reporting.
* **Real-time Monitoring** through scheduled view refreshes.
* **Forecasting Models** using historical trends from ADA scripts.

This foundation is BI-ready and designed for seamless visualization and storytelling.

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). Feel free to reuse or build on it with proper attribution!

---

## 🌟 Acknowledgement

🙏 A huge shoutout to **Baraa Khatib Salkini** **[Youtube](https://www.youtube.com/@DataWithBaraa)**, **[LinkedIn](https://www.linkedin.com/in/baraa-khatib-salkini-845b1b55/)** and **[Website](https://www.datawithbaraa.com/)**. The original project structure, datasets, and methodology are his creation. I’ve followed the guided steps to build this as a personal learning exercise and do not claim authorship of the core project design.
