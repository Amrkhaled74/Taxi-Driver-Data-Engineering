select *
from {{ ref('payment_type_dim') }}
where (payment_type = 0 and payment_type_name != 'Flex Fare trip')
   or (payment_type = 1 and payment_type_name != 'Credit card')
   or (payment_type = 2 and payment_type_name != 'Cash')
   or (payment_type = 3 and payment_type_name != 'No charge')
   or (payment_type = 4 and payment_type_name != 'Dispute')
   or (payment_type = 5 and payment_type_name != 'Unknown')
   or (payment_type = 6 and payment_type_name != 'Voided trip')
