import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

DBT = "/home/airflow/dbt_venv/bin/dbt"
DBT_DIR = "/opt/airflow/dbt"

with DAG(
    dag_id="dbt_daily",
    description="dbt seed -> run -> test, her gün saat 06:00 (Bakü)",
    start_date=pendulum.datetime(2026, 10, 1, tz="Asia/Baku"),
    schedule="0 6 * * *",
    catchup=False,
    max_active_runs=1,
    default_args={"retries": 1, "retry_delay": pendulum.duration(minutes=5)},
    tags=["dbt"],
) as dag:
    dbt_debug = BashOperator(task_id="dbt_debug", bash_command=f"{DBT} debug", cwd=DBT_DIR)
    dbt_seed = BashOperator(task_id="dbt_seed", bash_command=f"{DBT} seed", cwd=DBT_DIR)
    dbt_run = BashOperator(task_id="dbt_run", bash_command=f"{DBT} run", cwd=DBT_DIR)
    dbt_test = BashOperator(task_id="dbt_test", bash_command=f"{DBT} test", cwd=DBT_DIR)

    dbt_debug >> dbt_seed >> dbt_run >> dbt_test
