"""
dbt_weekly / dbt_monthly: dbt'de tag ile işaretlenmiş modelleri belirli aralıklarla çalıştırır.

- dbt_weekly  : her Pazartesi 07:00 (Bakü)  -> tag:weekly  modelleri
- dbt_monthly : her ayın 1'i  08:00 (Bakü)  -> tag:monthly modelleri

Bir modeli bu gruplara almak için dbt_project.yml'de +tags veya
modelin içinde {{ config(tags=['weekly']) }} kullanın.
"""
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

DBT = "/home/airflow/dbt_venv/bin/dbt"
DBT_DIR = "/opt/airflow/dbt"

SCHEDULES = {
    # dag_id        : (cron,          dbt tag)
    "dbt_weekly":  ("0 7 * * 1", "weekly"),   # Pazartesi 07:00
    "dbt_monthly": ("0 8 1 * *", "monthly"),  # Her ayın 1'i 08:00
}

for dag_id, (cron, tag) in SCHEDULES.items():
    with DAG(
        dag_id=dag_id,
        description=f"dbt build --select tag:{tag}  ({cron}, Bakü)",
        start_date=pendulum.datetime(2026, 10, 1, tz="Asia/Baku"),
        schedule=cron,
        catchup=False,
        max_active_runs=1,
        default_args={"retries": 1, "retry_delay": pendulum.duration(minutes=5)},
        tags=["dbt", tag],
    ) as dag:
        BashOperator(
            task_id=f"dbt_build_{tag}",
            cwd=DBT_DIR,
            bash_command=f"{DBT} build --select tag:{tag}",
        )

    globals()[dag_id] = dag
