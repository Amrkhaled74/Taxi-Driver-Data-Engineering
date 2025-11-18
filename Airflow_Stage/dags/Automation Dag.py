from datetime import datetime
from airflow import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.operators.bash import BashOperator
from airflow.utils.trigger_rule import TriggerRule
from airflow.utils.task_group import TaskGroup
import glob


# === PATHS ===
LOCAL_DATA_PATH = "/home/khaled/taxi_data/"
DBT_PROJECT_DIR = "/home/khaled/fat/taxi_driver_project"
DBT_VENV = "/home/khaled/dbt-env"
LOG_DIR = "/home/khaled/fat/logs"


# === FUNCTIONS ===
def upload_to_stage_func():
    hook = SnowflakeHook(snowflake_conn_id="snowflake")
    files = glob.glob(f"{LOCAL_DATA_PATH}*.csv")
    if not files:
        raise FileNotFoundError(f"No CSV files found in {LOCAL_DATA_PATH}")
    for file in files:
        hook.run(f"PUT file://{file} @taxi_stage OVERWRITE = TRUE")


def run_dims_or_fact(**kwargs):
    run_dims = True
    return "run_all_dims" if run_dims else "run_fact_only"


# === DAG DEFINITION ===
with DAG(
    dag_id="snowflake_test_dag",
    start_date=datetime(2025, 10, 17),
    schedule=None,
    catchup=False,
    description="Load --> Transform --> Test pipeline using Snowflake + DBT",
) as dag:

    # GROUP 1: Snowflake Stage
    with TaskGroup("snowflake_stage", tooltip="Load CSV files into Snowflake") as snowflake_stage:
        test_conn = SnowflakeOperator(
            task_id="test_connection",
            snowflake_conn_id="snowflake",
            sql="SELECT CURRENT_VERSION();",
        )

        upload_to_stage = PythonOperator(
            task_id="upload_to_stage",
            python_callable=upload_to_stage_func
        )

        load_data_from_stage_to_table = SnowflakeOperator(
            task_id="load_data_from_stage_to_table",
            snowflake_conn_id="snowflake",
            sql="""
                COPY INTO tem_stage_table
                FROM @taxi_stage
                FILE_FORMAT = (
                    TYPE = CSV  
                    FIELD_OPTIONALLY_ENCLOSED_BY='"'
                    SKIP_HEADER=1
                    NULL_IF=('NULL')
                );
            """,
        )

        # Internal order of group
        test_conn >> upload_to_stage >> load_data_from_stage_to_table

    #  GROUP 2: DBT Transformation
    with TaskGroup("dbt_transformation", tooltip="Run DBT dimension and fact models") as dbt_transformation:
        run_all_dims = BashOperator(
            task_id="run_all_dims",
            bash_command=f"""
            set -e
            source {DBT_VENV}/bin/activate && \
            cd {DBT_PROJECT_DIR} && \
            dbt run --select example.marts.date_dim \
                                example.marts.vendor_dim \
                                example.marts.location_dim \
                                example.marts.passenger_count_dim \
                                example.marts.payment_type_dim \
                                example.marts.rate_code_dim \
                                example.marts.trip_distance_dim \
                                example.marts.trip_dim >> {LOG_DIR}/dimensions.log 2>&1
            """,
        )

        run_dbt_taxi_fact = BashOperator(
            task_id="run_taxi_fact_model",
            bash_command=f"""
            set -e
            source {DBT_VENV}/bin/activate && \
            cd {DBT_PROJECT_DIR} && \
            dbt run --select example.marts.taxi_fact >> {LOG_DIR}/taxi_fact.log 2>&1
            """,
            trigger_rule=TriggerRule.ALL_DONE,
        )

        run_all_dims >> run_dbt_taxi_fact

    # GROUP 3: DBT Testing
    with TaskGroup("dbt_testing", tooltip="Test DBT models after transformation") as dbt_testing:
        test_dbt_model = BashOperator(
            task_id="test_dbt_models",
            bash_command=f"""
            set -e
            source {DBT_VENV}/bin/activate && \
            cd {DBT_PROJECT_DIR} && \
            dbt test >> {LOG_DIR}/dbt_test.log 2>&1
            """,
            trigger_rule=TriggerRule.ALL_DONE,
        )

    # === Dependencies Between Groups ===
    snowflake_stage >> dbt_transformation >> dbt_testing
