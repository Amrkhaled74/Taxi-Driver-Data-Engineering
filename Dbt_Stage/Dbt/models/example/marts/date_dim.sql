{{ config(materialized='table') }}

with base as(
    select distinct pickup_datetime,dropoff_datetime
    from {{ ref('stage_table') }}
)
,
middle as (select  row_number() over(order by pickup_datetime,dropoff_datetime) as datetime_id_sk,
   pickup_datetime   as   original_pickup_datetime,
   dropoff_datetime  as  original_dropoff_datetime  ,
   
   -- pickup_datetime
  case 
    when pickup_datetime is null
         and dropoff_datetime is not null
         and year(to_date(dropoff_datetime)) = 2025
    then to_char(
             dateadd(
                 minute, 
                 -1 * uniform(40, 300, random()),  -- 10–60 mins before dropoff
                 to_timestamp(dropoff_datetime)
             ),
             'YYYY-MM-DD HH24:MI:SS'
         )

    when pickup_datetime is not null
         and year(to_date(pickup_datetime)) = 2025 
    then to_char(
             to_timestamp(pickup_datetime),
             'YYYY-MM-DD HH24:MI:SS'
         )

    else to_char(
             dateadd(
                 day,
                 uniform(0, 31, random()),         -- 0–30 days in July
                 to_timestamp('2025-07-01 00:00:00')
             ),
             'YYYY-MM-DD HH24:MI:SS'
         )  
  end as pickup_datetime,
from base
)
  -- dropoff_datetime
,
final as (select datetime_id_sk,original_pickup_datetime,original_dropoff_datetime,pickup_datetime,
  case 
   

    when original_dropoff_datetime is not null
         and year(to_date(original_dropoff_datetime)) = 2025 
         and datediff(hour, to_timestamp(pickup_datetime), to_timestamp(original_dropoff_datetime)) <= 12
    then to_char(
             to_timestamp(original_dropoff_datetime),
             'YYYY-MM-DD HH24:MI:SS'
         )
    else to_char(
              dateadd(
                 minute, 
                 uniform(40, 300, random()),        -- 10–60 mins after pickup
                 to_timestamp(pickup_datetime)
             ),
             'YYYY-MM-DD HH24:MI:SS'
         )  
  end as dropoff_datetime
  ,
from middle )

select datetime_id_sk,pickup_datetime,dropoff_datetime,{{get_date_part('dropoff_datetime')}}
,original_pickup_datetime,original_dropoff_datetime,

 from final
