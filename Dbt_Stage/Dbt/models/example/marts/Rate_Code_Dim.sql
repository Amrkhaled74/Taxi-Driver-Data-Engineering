{{ config(materialized='table') }}
with base as(
    select distinct   
    case   when ratecode_id is null or ratecode_id < 1 or ratecode_id > 6  or ratecode_id = 99
           then  0
           else  ratecode_id 
           end as  ratecode_id
    from {{ ref('stage_table') }}
)

select 
    row_number() over(order by ratecode_id) as ratecode_id_sk,
    ratecode_id ,
    case 
        when ratecode_id = 1 then 'Standard rate'
        when ratecode_id = 2 then 'JFK'
        when ratecode_id = 3 then 'Newark'
        when ratecode_id = 4 then 'Nassau or Westchester'
        when ratecode_id = 5 then 'Negotiated fare'
        when ratecode_id = 6 then 'Group ride'
        else 'unknown'
    end as ratecode_id_name
from base
