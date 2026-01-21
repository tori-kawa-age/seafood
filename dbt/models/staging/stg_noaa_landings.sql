with src as (
    select
        extracted_at,
        payload
    from {{ source('raw_noaa', 'landings_raw') }}
)

select
    extracted_at,
    payload,

    payload ->> 'species' as species,
    (payload ->> 'year')::int as year,
    payload ->> 'state' as state,
    (payload ->> 'lbs')::numeric as lbs,
    (payload ->> 'value_usd')::numeric as value_usd

from src

