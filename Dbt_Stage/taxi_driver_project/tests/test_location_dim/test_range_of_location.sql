select *
from {{ ref('location_dim') }}
where pickup_location_id < 0
   or dropoff_location_id < 0
   or pickup_location_id > 300
   or dropoff_location_id > 400
