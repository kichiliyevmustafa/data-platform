select
    id as customer_id,
    first_name || ' ' || last_name as full_name,
    city
from {{ ref('customers') }}
