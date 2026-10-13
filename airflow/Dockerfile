FROM apache/airflow:2.10.5

# dbt'yi Airflow'un paketleriyle çakışmasın diye ayrı bir sanal ortama kur
RUN python -m venv /home/airflow/dbt_venv \
 && /home/airflow/dbt_venv/bin/pip install --no-cache-dir "dbt-core==1.9.*" "dbt-postgres==1.9.*"
