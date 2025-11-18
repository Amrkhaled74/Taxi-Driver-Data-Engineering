-- tests/test_trip_name_match.sql
select *
from {{ ref('trip_dim') }}
where (trip_type = 1 and trip_type_name != 'Street-hail')
   or (trip_type = 2 and trip_type_name != 'Dispatch')
   or (trip_type = 0 and trip_type_name != 'Unknown')
