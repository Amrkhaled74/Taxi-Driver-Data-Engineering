{{ config(materialized='table') }}
with base as( 
    
    select

     coalesce(td.trip_type_sk,uniform(0,2,random())) as  trip_type_sk,
     coalesce(vd.vendor_id_sk,uniform(1,3,random())) as  vendor_id_sk,
     coalesce(pt.payment_type_sk,uniform(0,5,random())) as payment_type_sk ,
     coalesce(rc.ratecode_id_sk,uniform(0,7,random())) as ratecode_id_sk ,
     coalesce(pc.passenger_count_sk,uniform(1,9,random())) as passenger_count_sk ,
     coalesce(l.location_id_sk,uniform(1,4440,random())) as location_id_sk,
     coalesce(d.datetime_id_sk,uniform(1,24146,random())) as datetime_id_sk,
     coalesce(trip_dis.trip_distance_id_sk,uniform(1,2113,random())) as trip_distance_id_sk ,
     
    case
            when l.dropoff_location_id is  not null and l.pickup_location_id is  not null
                 and d.pickup_datetime is not null and d.dropoff_datetime is  not null 
                 then 
                round(
                    (   -- base fare + distance + time factors
                        10                                         -- base fare
                        + ( abs ( l.dropoff_location_id  - l.pickup_location_id) * 0.8)   -- distance factor
                        + (datediff('minute', d.pickup_datetime, d.dropoff_datetime) * 0.25) / 60  -- time factor
                    )
                , 2)

                when fare_amount is null or fare_amount <=10
                then uniform(10.1,400.1,random())  
                else fare_amount 
    end as fare_amount,

    
    case when EXTRA is null or EXTRA <0
    then uniform(0,7.5,random())  
    else EXTRA end  as EXTRA ,

    case when MTA_TAX is null or MTA_TAX < 0
    then uniform(0,1.5,random())  
    else MTA_TAX end  as MTA_TAX ,
    
    case when TIP_AMOUNT is null or TIP_AMOUNT < 0
    then uniform(0,300,random())  
    else TIP_AMOUNT end  as TIP_AMOUNT ,
    
    case when TOLLS_AMOUNT is null or TOLLS_AMOUNT < 0
    then uniform(0,30,random())  
    else TOLLS_AMOUNT end  as TOLLS_AMOUNT ,
    
    case when EHAIL_FEE is null and trip_type_name = 'Dispatch'
    then 2 
    else 0 end  as EHAIL_FEE ,
 
     
from {{ ref('stage_table') }} st
left join {{ ref('trip_dim') }} td
    on st.trip_type = td.trip_type
left join {{ ref('vendor_dim') }} vd
    on st.vendor_id = vd.vendor_id
left join {{ ref('payment_type_dim') }} pt
    on st.payment_type = pt.payment_type
left join {{ ref('Rate_Code_Dim') }} rc
    on st.ratecode_id = rc.ratecode_id 
left join {{ ref('Passenger_Count_Dim') }} pc
    on st.passenger_count = pc.passenger_count 
left join {{ ref('location_dim') }} l
   on st.pickup_location_id = l.original_pickup_location_id 
   and st.dropoff_location_id = l.original_dropoff_location_id
left join {{ ref('date_dim') }} d
    on st.dropoff_datetime   = d.original_dropoff_datetime  
    and st.pickup_datetime  = d.original_pickup_datetime  
left join {{ ref('trip_distance_dim') }} trip_dis
    on st.trip_distance = trip_dis.trip_distance  
    )

 select *,(fare_amount+EXTRA+MTA_TAX+TIP_AMOUNT+TOLLS_AMOUNT+EHAIL_FEE) as TOTAL_AMOUNT  from base    