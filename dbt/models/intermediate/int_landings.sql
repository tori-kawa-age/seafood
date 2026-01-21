select
  extracted_at,
  year,
  state,
  species,
  lbs,
  value_usd
from {{ ref('stg_noaa_landings') }}
where year is not null
  and state is not null
  and species is not null
