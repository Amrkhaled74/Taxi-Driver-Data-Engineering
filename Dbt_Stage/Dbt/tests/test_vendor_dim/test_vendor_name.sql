select *
from {{ ref('vendor_dim') }}
where (vendor_id = 1 and vendor_name != 'Creative Mobile Technologies, LLC')
   or (vendor_id = 2 and vendor_name != 'Curb Mobility, LLC')
   or (vendor_id = 6 and vendor_name != 'Myle Technologies Inc')
   or (vendor_id = 0 and vendor_name != 'unknow ')
