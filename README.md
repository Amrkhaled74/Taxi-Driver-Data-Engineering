End-to-End Data Engineering Pipeline for NYC Taxi Data 

A fully automated ELT (Extract -> Load -> Transform) data pipeline built using Airflow, Snowflake, dbt, and Python, designed to transform raw NYC Taxi trip data into an analytics-ready Star Schema and Power BI dashboards.

----------------------------------------------------------------------------------

Table of Contents
1. Project Description
2. Use Cases
3. Technologies Used
4. Pipeline Workflow
5. Setup & Installation
6. Usage
7. Data Schema
8. Monitoring & Logging

----------------------------------------------------------------------------------


1. Project Description

This project implements a complete automated ELT data pipeline for NYC LPEP (Green Taxi) trip records.

Raw CSV files are ingested, stored, transformed, and modeled into a clean and performant star schema inside Snowflake.
The cleaned tables are then used in BI dashboards such as Power BI.

This pipeline addresses challenges such as:

* Raw taxi data is messy, inconsistent, and difficult to query.
* Manual ingestion and transformation is inefficient.
* BI dashboards require structured, optimized datasets.

The final system provides fully automated ingestion -> transformation -> testing -> analytics.

----------------------------------------------------------------------------------

2.  Use Cases

2.1 Automated Data Ingestion

Load raw CSV files directly into a Snowflake internal stage and staging table.

2.2 Data Transformation & Modeling

Run dbt models to clean and transform raw data into a Star Schema.

2.3 Business Intelligence & Analytics

Connect Power BI to the transformed fact and dimension tables.

2.4 Pipeline Orchestration

Airflow schedules and executes the pipeline end-to-end.

2.5 Data Quality Assurance

dbt tests automatically validate data accuracy and consistency.

----------------------------------------------------------------------------------

3.  Technologies Used

-------------------------------------------------
| Layer          | Technology                   |
| -------------- | ---------------------------- |
| Orchestration  | Apache Airflow               |
| Data Warehouse | Snowflake                    |
| Transformation | dbt (Data Build Tool)        |
| Language       | Python                       |
| Visualization  | Power BI                     |
| Data Source    | NYC TLC Green Taxi CSV Files |
-------------------------------------------------





----------------------------------------------------------------------------------


4. Pipeline Workflow

This project uses a modern ELT batch architecture , orchestrated entirely by Apache Airflow.

4.1 Extract

Raw '.csv' files are stored in a local directory:

/home/khaled/taxi_data/

4.2 Load

Airflow uploads the files into a Snowflake internal stage ('@taxi_stage') and then into a raw staging table using 'COPY INTO'.

4.3 Transform

Airflow triggers dbt commands:

* Clean raw data
* Apply business logic
* Generate fact & dimension tables
* Run data tests

4.4 Consumption

Power BI connects to Snowflake to build dashboards such as:

* Overview
* Operations


DAG Structure 


snowflake_stage -> dbt_transformation -> dbt_testing

----------------------------------------------------------------------------------

5. Setup & Installation

To run this project, configure Snowflake , dbt, and Airflow.



5.1 Prerequisites

* Snowflake Account
* Apache Airflow
* Python 3.8+
* dbt Core (`dbt-snowflake`)
* Airflow Snowflake Provider:

pip install apache-airflow-providers-snowflake dbt-snowflake



5.2 Snowflake Setup

Create your environment:

```sql
CREATE WAREHOUSE TAXI_DRIVER_WH;
CREATE DATABASE TAXI_DRIVER_DB;
CREATE SCHEMA TAXI;

CREATE STAGE taxi_stage;
```


5.3 dbt Setup

1. Clone the project:

/home/khaled/taxi_driver_project


2. Configure 'profiles.yml' with Snowflake credentials.


5.4 Airflow Setup

1. Copy Automation_Dag.py  into your Airflow dags/ directory.
2. Create an Airflow Connection:

* conn_id: 'snowflake'
* Enter your Snowflake credentials

3. Update hardcoded path variables in the DAG:
--------------------------------------------------
| Variable          | Description                 |
| ----------------- | --------------------------- |
| 'LOCAL_DATA_PATH' | Folder containing CSV files |
| 'DBT_PROJECT_DIR' | Your dbt project path       |
| 'DBT_VENV'        | Virtual environment for dbt |
| 'LOG_DIR'         | Folder for dbt log output   |
---------------------------------------------------


----------------------------------------------------------------------------------


6. Usage

6.1 Add Data

Place any NYC LPEP `.csv` files into:

LOCAL_DATA_PATH



6.2 Run the Pipeline

In Airflow UI:

* Select DAG:  snowflake_test_dag
* Switch ON
* Trigger Manual Run

6.3 Analyze

After the DAG finishes:

* Fact and dimensions are updated in Snowflake
* Power BI dashboards refresh automatically or manually

Output Includes:

* A populated Star Schema
* Clean, analytics-ready tables
* Business dashboards and insights

----------------------------------------------------------------------------------

7. Data Schema

The final model is a Star Schema optimized for analytics.

Fact Table
----------------------------------------------------------------------------------
| Table                 | Description                                            |
| --------------------- | ------------------------------------------------------ |
| Taxi_Driver_Table | Contains measures like fare, tips, tolls, total amount     |
----------------------------------------------------------------------------------


7.1 Dimension Tables

* `Vendor_Dim'
* `Date_Dim'
* 'Location_Dim'
* 'Payment_Type_Dim'
* 'Rate_Code_Dim'
* 'Trip_Distance_Dim'
* 'Passenger_Count_Dim'
* 'Trip_Type_Dim'

This structure enables fast filtering, slicing, and drill-down in BI dashboards.

----------------------------------------------------------------------------------

8  Monitoring & Logging

8.1 Airflow UI

* View DAG runs
* Check task success/failure
* Inspect logs

8.2 File-Based Logs

dbt output logs are stored in:

LOG_DIR


Example logs:

* 'dimensions.log'
* 'taxi_fact.log'
* 'dbt_test.log'

These help debug transformation issues.

