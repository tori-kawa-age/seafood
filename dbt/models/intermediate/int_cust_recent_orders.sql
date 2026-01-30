-- models/intermediate/int_cust_recent_orders.sql
select distinct
  c.customercode,
  c.name,
  o.invoicedate,
--   rank() over (
--   row_number () over (
  dense_rank() over (
    partition by c.customercode
    order by o.invoicedate desc
  ) as order_rank
from {{ ref('stg_sms_sales_orders') }} o
join {{ ref('stg_sms_customers') }} c
  on trim(o.customerkey) = trim(c.customerkey)
