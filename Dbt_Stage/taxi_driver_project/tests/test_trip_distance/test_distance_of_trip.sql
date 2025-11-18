select *
from {{ ref('trip_distance_dim') }}
where trip_distance < 1 or trip_distance > 251
