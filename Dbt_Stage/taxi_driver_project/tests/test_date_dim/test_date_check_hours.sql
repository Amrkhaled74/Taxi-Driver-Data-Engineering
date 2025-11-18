select *
from {{ ref('date_dim') }}
where datediff('hour', pickup_datetime, dropoff_datetime) >12
