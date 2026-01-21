with src as (
    select
        extracted_at,
        payload
    from {{ source('raw_fda', 'enforcement_raw') }}
)

select
    extracted_at,
    payload,

    nullif(payload ->> 'recall_number', '') as recall_number,
    nullif(payload ->> 'classification', '') as classification,
    nullif(payload ->> 'product_description', '') as product_description,
    nullif(payload ->> 'recalling_firm', '') as recalling_firm,
    nullif(payload ->> 'state', '') as state,

    case
      when (payload ->> 'report_date') ~ '^\d{8}$'
        then to_date(payload ->> 'report_date', 'YYYYMMDD')
      else null
    end as report_date

from src
