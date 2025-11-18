
    select
    VendorID AS vendor_id,
    PULocationID AS pickup_location_id,
    DOLocationID AS  dropoff_location_id,
    lpep_pickup_datetime   AS pickup_datetime,
    lpep_dropoff_datetime  AS dropoff_datetime,
    RatecodeID AS ratecode_id,
    store_and_fwd_flag,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    ehail_fee,
    total_amount,
    payment_type,
    trip_type,
    congestion_surcharge,
    cbd_congestion_fee
    from {{ source('SOURCE', 'SOURCE_DATA') }}
