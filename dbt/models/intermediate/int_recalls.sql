select
  extracted_at,
  recall_number,
  classification,
  recalling_firm,
  state,
  report_date,
  product_description
from {{ ref('stg_fda_enforcement') }}
where recall_number is not null
