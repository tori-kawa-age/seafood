with recalls as (
  select
    state,
    report_date,
    classification,
    case
      when lower(classification) like '%class i%' then 3
      when lower(classification) like '%class ii%' then 2
      when lower(classification) like '%class iii%' then 1
      else 1
    end as severity_score
  from {{ ref('int_recalls') }}
),

landings as (
  select
    state,
    sum(lbs) as lbs_landed
  from {{ ref('int_landings') }}
  group by 1
),

recall_score as (
  select
    state,
    max(report_date) as latest_recall_date,
    sum(severity_score) as total_severity_score
  from recalls
  group by 1
)

select
  coalesce(r.state, l.state) as state,
  r.latest_recall_date,
  coalesce(r.total_severity_score, 0) as total_severity_score,
  coalesce(l.lbs_landed, 0) as lbs_landed,

  -- heuristic index: severity * log(1 + volume)
  (coalesce(r.total_severity_score, 0) * ln(1 + coalesce(l.lbs_landed, 0))) as risk_index

from recall_score r
full outer join landings l
  on r.state = l.state

order by risk_index desc nulls last
