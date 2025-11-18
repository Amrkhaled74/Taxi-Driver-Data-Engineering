{{ config(materialized='table') }}
with base as(
    select distinct   
    case   when payment_type is null or payment_type < 0 or payment_type > 6  
           then  0
           else  payment_type 
        end as  payment_type
    from {{ ref('stage_table') }}
)

select 
    row_number() over(order by payment_type) as payment_type_sk,
      payment_type ,
    case 
        when payment_type = 0 then 'Flex Fare trip'
        when payment_type = 1 then 'Credit card'
        when payment_type = 2 then 'Cash'
        when payment_type = 3 then 'No charge'
        when payment_type = 4 then 'Dispute'
        when payment_type = 5 then 'Unknown'
        else 'Voided trip'
    end as payment_type_name
from base
