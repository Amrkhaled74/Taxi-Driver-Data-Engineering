select *
from {{ ref('Rate_Code_Dim') }}
where (ratecode_id = 1 and ratecode_id_name != 'Standard rate')
   or (ratecode_id = 2 and ratecode_id_name != 'JFK')
   or (ratecode_id = 3 and ratecode_id_name != 'Newark')
   or (ratecode_id = 4 and ratecode_id_name != 'Nassau or Westchester')
   or (ratecode_id = 5 and ratecode_id_name != 'Negotiated fare')
   or (ratecode_id = 6 and ratecode_id_name != 'Group ride')
   or (ratecode_id = 0 and ratecode_id_name != 'unknown')
