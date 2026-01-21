with src as (
    select
        extracted_at,
        payload
    from {{ source('raw_fda', 'enforcement_raw') }}
)

select
    extracted_at,
    payload,

    payload ->> 'recall_number' as recall_number,
    payload ->> 'classification' as classification,
    payload ->> 'product_description' as product_description,
    payload ->> 'recalling_firm' as recalling_firm,
    payload ->> 'state' as state,

    -- FDA often uses YYYYMMDD; this handles that format
    to_date(payload ->> 'report_date', 'YYYYMMDD') as report_date

from src

