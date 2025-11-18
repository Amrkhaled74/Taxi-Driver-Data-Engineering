{{ config(materialized='table') }}
with base as(
    select distinct   
    case   when passenger_count is null or passenger_count <= 0 or passenger_count > 9
           then  uniform(1,9,random())
           else  passenger_count 
        end as  passenger_count
    from {{ ref('stage_table') }}
)

select 
    row_number() over(order by passenger_count) as passenger_count_sk,
     passenger_count ,
from base
