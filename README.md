
# Brazilian E-Commerce Data Engineering Pipeline (Olist Dataset)

An end-to-end modern data engineering project processing the public Olist Brazilian E-Commerce dataset using **Python**, **Pandas**, and **Google BigQuery**, structured around the **Medallion Architecture**.

---

## 🏗️ Project Architecture (Medallion Architecture)
This project follows a multi-layered data architecture to ensure data quality, traceability, and performance:

1. **Bronze Layer (Raw):** Ingestion of raw CSV files directly into Google BigQuery without structural changes, preserving the original data format.
2. **Silver Layer (Cleaned & Conformed):** Data cleaning, handling missing values, standardizing column names, removing duplicates, and transforming data types using Python/Pandas.
3. **Gold Layer (Aggregated / Business-Ready):** Optimized SQL queries and aggregated tables designed for analytics, business intelligence, and reporting.

---

## 🛠️ Tech Stack
* **Language:** Python
* **Data Manipulation & Processing:** Pandas, Glob, OS
* **Cloud Data Warehouse:** Google BigQuery (`pandas_gbq`)
* **Version Control:** Git & GitHub

---

## 📂 Project Structure
```text
├── bronze_layer.py        # Script for ingesting raw CSVs to BigQuery Bronze dataset
├── silver_layer.sql       # SQL script for cleaning and transforming data to Silver layer
├── gold_queries.sql       # SQL scripts for final business aggregations
└── README.md              # Project documentation