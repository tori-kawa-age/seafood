set search_path to seafood;

select c.*, o.* 
from sms.customers c
left join sms.sales_orders o
  on c.customerkey = o.customerkey
-- where c.customercode = '249001'
where c.customercode = '101539'
;

SELECT
  c.customercode,
  COUNT(*) AS order_count,
  COUNT(DISTINCT o.invoicedate) AS distinct_invoice_dates,
  MIN(o.invoicedate) AS first_invoice_date,
  MAX(o.invoicedate) AS last_invoice_date
FROM sms.sales_orders o
JOIN sms.customers c
  ON TRIM(o.customerkey) = TRIM(c.customerkey)
GROUP BY c.customercode
HAVING COUNT(DISTINCT o.invoicedate) >= 2
ORDER BY distinct_invoice_dates DESC, order_count DESC
;

/*
"customercode"	"order_count"	"distinct_invoice_dates"	"first_invoice_date"	"last_invoice_date"
"101539"		23				19							"2025-12-01 00:00:00"	"2025-12-30 00:00:00"
"101557"		17				15							"2025-12-01 00:00:00"	"2025-12-29 00:00:00"
"214544"		14				14							"2025-12-01 00:00:00"	"2025-12-31 00:00:00"
"214423"		13				13							"2025-12-01 00:00:00"	"2025-12-31 00:00:00"
"124143"		13				12							"2025-12-04 00:00:00"	"2025-12-30 00:00:00"
"214300"		12				12							"2025-12-03 00:00:00"	"2025-12-31 00:00:00"
"300176"		7				7							"2025-12-03 00:00:00"	"2025-12-27 00:00:00"
"300187"		7				7							"2025-12-01 00:00:00"	"2025-12-28 00:00:00"
"101568"		6				4							"2025-12-02 00:00:00"	"2025-12-22 00:00:00"
"213880"		3				3							"2025-12-01 00:00:00"	"2025-12-26 00:00:00"
*/

 SELECT c.customercode,
    o.invoicedate,
    dense_rank() OVER (PARTITION BY c.customercode ORDER BY o.invoicedate DESC) AS rn
   FROM sms.sales_orders o
     JOIN sms.customers c ON o.customerkey = c.customerkey;

select * from sms.customer_last_two_orders;


-- (A)
WITH rn AS (
  SELECT
    c.customercode, o.invoicedate,
    RANK () OVER
	(PARTITION BY c.customercode ORDER BY o.invoicedate DESC) AS rn
  FROM sms.customers c
  LEFT OUTER JOIN sms.sales_orders o on c.customerkey = o.customerkey
)
SELECT 
  DISTINCT
    rn.* 
FROM rn
-- WHERE rn <= 2
ORDER BY 1, 3;

 SELECT 
    distinct 
	c.customercode,
    o.invoicedate,
    dense_rank() OVER (PARTITION BY c.customercode ORDER BY o.invoicedate DESC) AS rn
   FROM sms.sales_orders o
     JOIN sms.customers c ON o.customerkey = c.customerkey
 ORDER BY customercode, rn
;

SELECT 
  DISTINCT 
  o.invoicedate AS order_date,
  c.customercode
FROM sms.sales_orders o
JOIN sms.customers c
  ON o.customerkey = c.customerkey
WHERE c.customercode = '101539'
-- WHERE c.customercode = '249001'
ORDER BY order_date DESC
LIMIT 2
;

-- Customer Sales Orders
WITH ranked AS (
  SELECT
    c.customerkey,
    c.customercode,
	c.name,
    o.invoicedate,
    DENSE_RANK() OVER (
    -- RANK() OVER (
	-- ROW_NUMBER() OVER (
      PARTITION BY c.customercode
      ORDER BY o.invoicedate DESC
    ) AS rn
  FROM sms.sales_orders o
  JOIN sms.customers c
    ON o.customerkey = c.customerkey
  WHERE c.customercode = '101539'
  -- WHERE c.customercode = '249001'
)
SELECT 
  -- DISTINCT 
   invoicedate, customerkey, customercode, name, rn
FROM ranked
-- WHERE rn <= 2
ORDER BY customerkey, rn;

select * from sms.customer_last_two_orders;
