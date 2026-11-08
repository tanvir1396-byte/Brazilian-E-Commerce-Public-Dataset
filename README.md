# Brazilian E-Commerce Data Engineering Pipeline (Olist Dataset)

An end-to-end data engineering project that processes the public Olist Brazilian E-Commerce dataset using **Python, Pandas, SQL, and Google BigQuery**, following the **Medallion Architecture**.

## 🏗️ Project Architecture

This project follows a three-layer data architecture to improve data quality, traceability, and analytical usability.

### 1. Bronze Layer – Raw Data Ingestion

- Ingests CSV files from the `raw_data/` directory into Google BigQuery.
- Preserves source records during ingestion.
- Standardizes column names for BigQuery compatibility by replacing periods (`.`) with underscores (`_`).
- Uses `if_exists='replace'` to replace destination tables during full refreshes, avoiding duplicate data from repeated ingestion of static source files.

### 2. Silver Layer – Data Cleaning and Transformation

- Cleans and standardizes raw data using SQL in BigQuery.
- Handles missing and invalid values.
- Standardizes text fields and column values.
- Removes duplicate records where appropriate.
- Converts timestamp fields into appropriate data types.
- Preserves product records while independently handling invalid or missing measurement values by converting them to NULL.

### 3. Gold Layer – Business-Ready Data

Creates analytical tables for business reporting and insights, including:

- Monthly revenue, order volume, and unique customer summaries.
- Product category revenue and associated order review performance.
- State-wise order volume and delivery performance.
- Seller geolocation enrichment using ZIP code prefixes.
- Revenue and seller performance analysis by seller state.

## 🛠️ Tech Stack

- **Programming Language:** Python 3.14
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
│   └── Olist CSV source files
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
- BigQuery API enabled
- Required BigQuery permissions
- Olist dataset CSV files
- Git

### 1. Clone the Repository

```bash
git clone https://github.com/tanvir1396-byte/Brazilian-E-Commerce-Public-Dataset.git

cd Brazilian-E-Commerce-Public-Dataset
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Prepare the Source Data

Make sure the Olist CSV source files are available inside the `raw_data/` directory.

If the repository already contains the source files, no additional download is required.

### 4. Configure the Project

Update `config.py` with your own settings:

- Google Cloud project ID
- BigQuery dataset name
- Local CSV folder path

Example:

```python
project_name = 'your-google-cloud-project-id'
dataset_name = 'Bronze_dataset_Brazilian_ecommerce'
csv_folder = r'D:\path\to\raw_data'
```

### 5. Authenticate with Google Cloud

The pipeline uses Google authentication through `pandas-gbq`.

Run the Bronze ingestion script:

```bash
python bronze_layer.py
```

On the first run, the authentication process may provide a Google authorization URL. Open the URL in your browser, sign in with the Google account that has the required BigQuery permissions, and authorize access.

After successful authentication, saved credentials can generally be reused for subsequent executions.

**Note:** Google Cloud CLI and Application Default Credentials are alternative authentication options if configured for your environment. They are not mandatory when using the browser authentication flow supported by pandas-gbq.

## 🚀 Pipeline Execution

Run the pipeline in the following order:

1. **Bronze Layer:** Execute `bronze_layer.py` to ingest the source CSV files into BigQuery.
2. **Silver Layer:** Execute `silver_layer.sql` in the BigQuery SQL editor to clean and transform the Bronze tables.
3. **Gold Layer:** Execute `gold_queries.sql` to create business-ready analytical tables.

**Important:** The Bronze ingestion script uses `if_exists='replace'`. Running it again replaces the corresponding destination tables with the source CSV data.

The Silver and Gold SQL scripts use `CREATE OR REPLACE TABLE`, allowing existing tables to be refreshed when the scripts are executed again.

## 🔍 Data Quality Validation

The project includes SQL-based validation checks to verify data integrity, transformation results, and analytical consistency.

Selected validation results:

- **Products:** Retained 32,951 unique product records in the Silver layer.
- **Seller Geolocation:** Successfully matched 3,088 out of 3,095 sellers with geographical coordinates, achieving approximately 99.77% coverage.
- **Revenue Reconciliation:** Gold product category revenue matched the independently calculated source-based total of **R$15,843,553.24**.
- **Monthly Revenue:** Independently recalculated monthly order counts, revenue, and unique customer counts matched the Gold layer results across all 22 months.
- **State-Wise Performance:** Analyzed 96,477 delivered orders across 27 Brazilian states.
- **Seller State Revenue:** Gold revenue by seller state reconciled with the Silver order items revenue, with a difference of **R$0.00**.
- **Seller Records:** All 3,095 unique sellers were retained in the seller geolocation analysis.

## 📊 Project Outcomes

This project demonstrates an end-to-end data engineering workflow using Python, Pandas, SQL, and Google BigQuery.

Key outcomes include:

- Built a three-layer data pipeline using the Medallion Architecture.
- Ingested raw e-commerce CSV datasets into BigQuery.
- Cleaned and transformed data using SQL.
- Created business-ready analytical tables in the Gold layer.
- Implemented data quality checks and revenue reconciliation.
- Enriched seller records with geographical coordinates.
- Developed analytical datasets for revenue, product categories, delivery performance, and seller-state analysis.

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

**Key Finding:** São Paulo had the highest delivered order volume among the Brazilian states.

### 4. Seller Geolocation Coverage

- Enriched seller records with geographical coordinates using ZIP code prefixes.
- Successfully matched 3,088 out of 3,095 sellers.
- Achieved approximately 99.77% geolocation coverage.
- Retained unmatched seller records using a LEFT JOIN.

**Key Finding:** The seller geolocation analysis achieved approximately 99.77% coordinate coverage while preserving all seller records.

### 5. Seller State Revenue Analysis

Revenue was calculated using item price plus freight value and aggregated by seller state.

| Rank | Seller State | Revenue (R$) |
|---:|---|---:|
| 1 | São Paulo (SP) | 10,235,883.88 |
| 2 | Paraná (PR) | 1,458,900.73 |
| 3 | Minas Gerais (MG) | 1,224,159.80 |
| 4 | Rio de Janeiro (RJ) | 937,814.12 |
| 5 | Santa Catarina (SC) | 738,973.13 |

**Key Findings:**

- São Paulo generated the highest seller-state revenue, approximately R$10.24 million.
- Paraná ranked second with approximately R$1.46 million.
- Minas Gerais ranked third with approximately R$1.22 million.
- São Paulo accounted for approximately 64.6% of total seller-state revenue.
- The analysis covered 23 seller-state groups and 3,095 unique sellers.

**Revenue Definition:** Seller-state revenue represents the sum of item prices and freight values. It is different from monthly payment revenue, which is calculated using payment records.

## 🔐 Authentication and Configuration Notes

- Project-specific settings are maintained in `config.py`.
- Google authentication is handled through the authentication flow supported by pandas-gbq.
- Google Cloud CLI with Application Default Credentials can also be used as an alternative authentication method.
- Do not commit credentials, service account keys, access tokens, or other sensitive information to GitHub.
- Update local paths and BigQuery project settings before running the pipeline.
- Ensure the Google account has the required BigQuery permissions and the BigQuery API is enabled.
