# Brazilian E-Commerce Data Engineering Pipeline (Olist Dataset)

An end-to-end data engineering project that processes the public Olist Brazilian E-Commerce dataset using **Python, Pandas, and Google BigQuery**, following the **Medallion Architecture**.

## 🏗️ Project Architecture

This project follows a three-layer data architecture to improve data quality, traceability, and analytical usability.

### 1. Bronze Layer – Raw Data Ingestion

- Ingests CSV files from the `raw_data/` directory into Google BigQuery.
- Preserves the source records during ingestion.
- Standardizes column names for BigQuery compatibility by replacing periods (`.`) with underscores (`_`).
- Uses `if_exists='replace'` to replace destination tables during full refreshes, avoiding duplicate data from repeated ingestion of the static source files.

### 2. Silver Layer – Data Cleaning and Transformation

- Cleans and standardizes raw data using SQL in BigQuery.
- Handles missing and invalid values.
- Standardizes text fields and column values.
- Removes duplicate records where appropriate.
- Preserves product records while independently handling invalid or missing measurement values.

### 3. Gold Layer – Business-Ready Data

- Creates analytical tables using SQL transformations and aggregations.
- Analyzes monthly revenue and order volume.
- Evaluates product category revenue and associated order review performance.
- Analyzes state-wise order volume and delivery duration.
- Enriches seller records with geographical coordinates.
- Prepares datasets for business intelligence and reporting.

## 🛠️ Tech Stack

- **Programming Language:** Python
- **Data Processing:** Pandas
- **Python Libraries:** pandas-gbq
- **Python Standard Libraries:** os, glob
- **Cloud Data Warehouse:** Google BigQuery
- **Query Language:** SQL
- **Version Control:** Git and GitHub

## 📂 Project Structure

```text
Brazilian-E-Commerce-Public-Dataset/
│
├── raw_data/
│   └── CSV source files
│
├── bronze_layer.py
├── silver_layer.sql
├── gold_queries.sql
├── config.py
├── requirements.txt
└── README.md
```

## ⚙️ Setup and Installation

### Prerequisites

- Python 3.14
- A Google Cloud account with a BigQuery project
- Google Cloud CLI for Application Default Credentials
- Access to the Olist dataset CSV files

### 1. Clone the repository

```bash
git clone https://github.com/tanvir1396-byte/Brazilian-E-Commerce-Public-Dataset.git

cd Brazilian-E-Commerce-Public-Dataset
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Prepare the source data

Place the Olist CSV source files inside the `raw_data/` directory.

### 4. Configure the project

Update `config.py` with your own:

- Google Cloud project ID
- BigQuery dataset name
- Local CSV folder path

### 5. Authenticate with Google Cloud

Install Google Cloud CLI and run:

```bash
gcloud auth application-default login
```

Make sure your Google account has the required BigQuery permissions.

## 🚀 Pipeline Execution

Run the pipeline in the following order:

1. **Bronze:** Run `bronze_layer.py` to ingest the source CSV files into BigQuery.
2. **Silver:** Execute `silver_layer.sql` in the BigQuery SQL editor to clean and transform the Bronze tables.
3. **Gold:** Execute `gold_queries.sql` to create business-ready analytical tables.

**Note:** The Bronze ingestion script uses `replace` mode. Running it again replaces the corresponding destination tables with data from the source CSV files.

## 🔍 Data Quality Validation

The project includes SQL-based validation checks to verify data integrity and transformation results.

Selected validation results:

- **Products:** Retained 32,951 unique product records in the Silver layer.
- **Seller Geolocation:** Successfully matched 3,088 out of 3,095 sellers with geographical coordinates, achieving approximately 99.77% coverage.
- **Revenue Reconciliation:** The Gold product category revenue total matches the independently calculated source-based total of **R$15,843,553.24**.
- **Monthly Revenue:** Independently recalculated monthly order counts, revenue, and unique customer counts matched the Gold layer results across all 22 months.
- **State-Wise Performance:** Analyzed 96,477 delivered orders across 27 Brazilian states.

## 📊 Project Outcomes

This project demonstrates an end-to-end data engineering workflow using Python, Pandas, SQL, and Google BigQuery.

Key outcomes include:

- Built a three-layer data pipeline using the Medallion Architecture.
- Ingested raw e-commerce CSV datasets into BigQuery.
- Cleaned and transformed data using SQL.
- Created business-ready analytical tables in the Gold layer.
- Performed data quality validation and revenue reconciliation.
- Enriched seller records with geographical coordinates.
- Developed analytical datasets for revenue, product category, delivery, and seller location analysis.

## 📈 Key Business Insights

### 1. Top 5 Product Categories by Revenue

The following table shows the five highest-revenue product categories based on item price and freight value.

| Rank | Product Category | Revenue (R$) |
|---:|---|---:|
| 1 | Health & Beauty | 1,441,248.07 |
| 2 | Watches & Gifts | 1,305,541.61 |
| 3 | Bed Bath Table | 1,240,555.30 |
| 4 | Sports & Leisure | 1,156,656.48 |
| 5 | Computers & Accessories | 1,059,272.40 |

**Key Finding:** Health & Beauty generated the highest revenue among all product categories, followed by Watches & Gifts and Bed Bath Table.

### 2. Monthly Revenue Trends

Monthly payment revenue analysis covered 22 months.

- **Highest Revenue Month:** November 2017 — **R$1,153,528.05**.
- **Lowest Revenue Month:** December 2016 — **R$19.62**.

**Key Finding:** November 2017 recorded the highest monthly payment revenue, while December 2016 recorded the lowest.

### 3. State-Wise Delivery Performance

- Analyzed delivered orders across 27 Brazilian states.
- São Paulo (SP) recorded the highest delivered order volume with 40,495 orders.
- Rio de Janeiro (RJ) ranked second with 12,353 orders.
- Minas Gerais (MG) ranked third with 11,355 orders.
- Calculated average delivery duration for each state.

### 4. Seller Geolocation Coverage

- Enriched seller records with geographical coordinates using ZIP code prefixes.
- Successfully matched 3,088 out of 3,095 sellers.
- Achieved approximately 99.77% geolocation coverage.
- Retained unmatched seller records using a LEFT JOIN, preserving all seller records in the Gold layer.

## 🔐 Authentication and Configuration Notes

- Project-specific settings are maintained in `config.py`.
- Google Cloud authentication is handled through Application Default Credentials.
- Do not commit credentials, service account keys, or other sensitive information to GitHub.
- Update local paths and BigQuery project settings before running the pipeline.