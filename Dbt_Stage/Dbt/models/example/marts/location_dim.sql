{{ config(materialized='table') }}

with base as (
    select distinct pickup_location_id,dropoff_location_id
   
    from {{ ref('stage_table') }}
),
middle as (select distinct
    -- surrogate key
  

    -- adjusted pickup location id logic
    case
        when (pickup_location_id >= 9999 or  pickup_location_id < 0  or pickup_location_id is null)  and dropoff_location_id > 100 then
            -- subtract random integer between 20 and 60
            dropoff_location_id - uniform(20,60,random())

        when (pickup_location_id >= 9999  or pickup_location_id < 0  or pickup_location_id is null) and dropoff_location_id <= 100 then
            -- add random integer between 20 and 50
            dropoff_location_id + uniform(20,50,random())
        
        when  pickup_location_id is null and dropoff_location_id is null then
              uniform(50,150,random())            
        else
            pickup_location_id
    end as pickup_location_id,

    -- keep original ids for reference
    pickup_location_id     as original_pickup_location_id,
    dropoff_location_id    as original_dropoff_location_id

from base
),

final  as (
select 
        pickup_location_id,
       original_pickup_location_id,
       original_dropoff_location_id, 
        case
        when   pickup_location_id >= original_dropoff_location_id or original_dropoff_location_id is null 
        or original_dropoff_location_id < 0  then
               pickup_location_id + uniform(40,80,random())
        else
            original_dropoff_location_id
    end as dropoff_location_id,
 from middle
 )
 select row_number() over (order by pickup_location_id,dropoff_location_id) as location_id_sk , pickup_location_id,dropoff_location_id, original_pickup_location_id,
       original_dropoff_location_id,  from final