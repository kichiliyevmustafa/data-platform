select now()  as load_date,
    city,
    count(*) as customer_count
from {{ ref('stg_customers') }}
group by city
