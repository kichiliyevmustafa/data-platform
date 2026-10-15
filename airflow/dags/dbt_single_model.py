"""
dbt_single_model: SADECE TEK BİR dbt modelini (ve testlerini) çalıştırır.

- Zamanlanmış değil (schedule=None): sadece elle tetiklenir.
- Tetiklerken "model" alanına tek bir model adı yazılmalı, örn: stg_users
- Boş, birden fazla model, "+" / klasör gibi seçiciler veya olmayan bir model adı
  girilirse DAG hiçbir şey çalıştırmadan hata verir.
"""
import pendulum
from airflow import DAG
from airflow.models.param import Param
from airflow.operators.bash import BashOperator

DBT = "/home/airflow/dbt_venv/bin/dbt"
DBT_DIR = "/opt/airflow/dbt"

with DAG(
    dag_id="dbt_single_model",
    description="Tek bir dbt modelini elle çalıştırır (dbt build --select <model>)",
    start_date=pendulum.datetime(2026, 10, 1, tz="Asia/Baku"),
    schedule=None,
    catchup=False,
    max_active_runs=1,
    params={
        "model": Param(
            "",
            type="string",
            title="Model adı",
            description="Çalıştırılacak TEK model. Örnek: stg_users",
        ),
    },
    tags=["dbt", "manual"],
) as dag:

    # 1) Girilen değeri kontrol et: boş olmamalı, tek kelime olmalı, model gerçekten var olmalı
    check_model = BashOperator(
        task_id="check_model",
        cwd=DBT_DIR,
        env={"MODEL": "{{ params.model }}"},
        append_env=True,
        bash_command=f"""
set -e
if [[ ! "$MODEL" =~ ^[A-Za-z0-9_]+$ ]]; then
  echo "HATA: Tek bir model adı girin (örn: stg_users). Girilen: '$MODEL'"
  exit 1
fi
FOUND=$({DBT} --quiet ls --resource-type model --select "$MODEL" --output name)
if [ -z "$FOUND" ]; then
  echo "HATA: '$MODEL' adında bir dbt modeli yok."
  exit 1
fi
echo "Model bulundu: $FOUND"
""",
    )

    # 2) Sadece o modeli çalıştır + o modelin testlerini çalıştır
    dbt_build_model = BashOperator(
        task_id="dbt_build_model",
        cwd=DBT_DIR,
        env={"MODEL": "{{ params.model }}"},
        append_env=True,
        bash_command=f'{DBT} build --select "$MODEL"',
    )

    check_model >> dbt_build_model