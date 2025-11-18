{{ config(materialized='table') }}
with base as(
    select distinct vendor_id
    from {{ ref('stage_table') }}
) 

select 
    row_number() over(order by vendor_id) as vendor_id_sk,
    coalesce(vendor_id, 0) as vendor_id,
      case 
        when vendor_id = 1 then 'Creative Mobile Technologies, LLC'
        when vendor_id = 2 then 'Curb Mobility, LLC'
        when vendor_id = 6 then 'Myle Technologies Inc'
        else 'unknow '
    end as vendor_name

from base   