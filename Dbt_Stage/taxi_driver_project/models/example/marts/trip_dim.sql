{{ config(materialized='table') }}
with base as(
    select distinct trip_type
    from {{ ref('stage_table') }}
)

select 
    row_number() over(order by trip_type) as trip_type_sk,
    coalesce(trip_type, 0) as trip_type,
    case 
        when trip_type = 1 then 'Street-hail'
        when trip_type = 2 then 'Dispatch'
        else 'Unknown'
    end as trip_type_name
from base
