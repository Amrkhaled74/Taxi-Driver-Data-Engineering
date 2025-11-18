❄️ Snowflake Data Warehouse Setup

This directory contains the scripts required to initialize the Snowflake environment used for the NYC Taxi Data Pipeline. It sets up the Warehouse, Database, Schema, and Internal Stages required for data ingestion and transformation.

🏗️ Infrastructure Overview

The pipeline follows a Raw → Stage → Mart architecture:

Warehouse (TAXI_DRIVER_WH): Compute resource for loading and transformations.

Database (TAXI_DRIVER_DB): Central storage for all project tables.

Schema (TAXI): Holds raw ingestion tables and stages.

Internal Stage (@taxi_stage): Temporary location for raw CSV uploads from Airflow.

📜 Purpose of SQL Scripts

Environment Setup Script

Creates the Snowflake warehouse, database, schema, and internal stage.

Configures permissions and basic environment settings.

Raw Tables Script

Defines the structure for raw data landing tables.

Ensures proper data types and storage layout for ingestion.

🚀 How to Apply

Option 1: Snowflake Web UI

Log in to Snowflake and open a new Worksheet.

Run the setup and raw tables scripts to create the environment.

Option 2: SnowSQL CLI

Use SnowSQL to execute the setup scripts from your local machine.

📦 Data Loading Strategy

Ingestion: Airflow uploads raw CSV files to @taxi_stage.

Loading: Data is moved from the stage to the raw tables.

Format: Stage is configured to handle CSV files with proper formatting for reliable ingestion.