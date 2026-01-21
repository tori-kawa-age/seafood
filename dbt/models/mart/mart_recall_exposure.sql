with recalls as (
  select *
  from {{ ref('int_recalls') }}
),

landings as (
  select *
  from {{ ref('int_landings') }}
)

select
  coalesce(r.state, l.state) as state,

  -- recall metrics
  count(distinct r.recall_number) as recalls_count,
  max(r.report_date) as latest_recall_date,

  -- landings metrics
  sum(l.lbs) as total_lbs_landed,
  sum(l.value_usd) as total_value_usd

from recalls r
full outer join landings l
  on r.state = l.state

group by 1
order by recalls_count desc nulls last, total_lbs_landed desc nulls last
