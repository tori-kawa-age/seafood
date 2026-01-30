CREATE OR REPLACE VIEW sms.customer_last_two_orders AS
SELECT
  c.customercode,
  o.invoicedate,
  DENSE_RANK() OVER (
  -- RANK() OVER (
  -- ROW_NUMBER () OVER (
    PARTITION BY c.customercode
    ORDER BY o.invoicedate DESC
  ) AS rn
FROM sms.sales_orders o
JOIN sms.customers c
  ON TRIM(o.customerkey) = TRIM(c.customerkey);
