{{ config(materialized='table') }}

with base as(

    select distinct  
    case when  trip_distance is null or trip_distance < 1 or trip_distance > 250 
    then  uniform(10.90, 250.90, random())
    else 
    trip_distance
    end  as trip_distance
    from {{ ref('stage_table') }} t
)


select
    row_number() over(order by trip_distance) as trip_distance_id_sk,
    trip_distance,
from base
