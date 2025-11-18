select *
from {{ ref('date_dim') }}
where year(to_date(pickup_datetime)) != 2025 
   or year(to_date(dropoff_datetime)) != 2025
