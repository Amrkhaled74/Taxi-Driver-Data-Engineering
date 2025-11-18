Table of Contents
1. [Apache Airflow Orchestration](#Apache-Airflow-Orchestration)
2. [Pipeline Workflow](#-pipeline-workflow)
3. [Configuration & Setup](#%EF%B8%8F-configuration--setup)
4. [How to Run](#-how-to-run)
5. [Task Details](#-task-details)


## 🌬️ Apache Airflow Orchestration

This directory contains the DAGs (Directed Acyclic Graphs) responsible for orchestrating the **entire ELT pipeline**. Airflow manages scheduling, dependency resolution, and execution of tasks from raw data ingestion to final dbt transformation.

---

### 🔄 Pipeline Workflow

The `automation_dag.py` executes the following logical flow:

```mermaid
graph LR
    A[Start] --> B(Upload CSV to Stage)
    B --> C(Copy to Snowflake Raw)
    C --> D(dbt Run - Transform)
    D --> E(dbt Test - Validate)
    E --> F[End]
```

1. **Upload to Stage**: Python task that uploads local CSV files to a Snowflake internal stage (`@taxi_stage`).
2. **Copy into Table**: SnowflakeOperator task that executes `COPY INTO` to load raw data into the staging table.
3. **dbt Run**: Executes the transformation models using `dbt run`.
4. **dbt Test**: Runs data integrity tests (`dbt test`) to ensure quality before the pipeline completes.

---

### ⚙️ Configuration & Setup

#### 1. Prerequisites

* Apache Airflow 2.x (locally or in Docker)
* Snowflake Provider:

```bash
pip install apache-airflow-providers-snowflake
```

* dbt Core installed in the same environment or a virtualenv accessible by Airflow

#### 2. Airflow Connections

Configure a connection in the Airflow UI (**Admin → Connections**) with the ID `snowflake_conn`:
----------------------------------------
| Field     | Value                    |
| --------- | ------------------------ |
| Conn Id   | snowflake_conn           |
| Conn Type | Snowflake                |
| Schema    | TAXI                     |
| Warehouse | TAXI_DRIVER_WH           |
| Database  | TAXI_DRIVER_DB           |
----------------------------------------
#### 3. Environment Variables (DAG Configuration)

Update the constants at the top of `automation_dag.py` to match your local paths:

```python
# Path where your raw CSV files are located
LOCAL_DATA_PATH = '/home/khaled/taxi_data/'

# Path to your dbt project folder
DBT_PROJECT_DIR = '/home/khaled/taxi_driver_project'

# Path to your dbt virtual environment executable
DBT_EXECUTABLE = '/home/khaled/dbt_env/bin/dbt'
```

---

### 🚀 How to Run

1. **Deploy the DAG**: Move `automation_dag.py` to your `$AIRFLOW_HOME/dags/` folder.
2. **Start Airflow**:

```bash
airflow scheduler
airflow webserver
```

3. **Trigger the Pipeline**:

* Open `localhost:8080` in your browser
* Find `snowflake_elt_pipeline`
* Toggle the DAG **ON**
* Click the **Play Button** to run manually

---

### 📝 Task Details
--------------------------------------------------------------------------------------------------
| Task Name                | Description                                                         |
| ------------------------ | ------------------------------------------------------------------- |
| `upload_files_to_stage`  | Uses `SnowflakeHook` to PUT files. Auto-compresses files on upload  |
| `load_data_to_snowflake` | Executes raw SQL to move data from the stage layer to the raw table |
| `run_dbt_models`         | Uses `BashOperator` to execute the dbt transformation logic         |
--------------------------------------------------------------------------------------------------
---
