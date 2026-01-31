# Seafood — BI & Analytics Engineering Demo

## Overview
This project demonstrates a **modern BI workflow** using a realistic sales dataset provided for interview preparation. The goal is to show how raw operational data can be transformed into a **clean analytics layer** and consumed in **Power BI** for business decision-making.

The emphasis is on:
- Data validation
- Clear modeling decisions
- Reusable SQL logic
- Explainable business outcomes

---

## Business Question (Interview Prompt)
> **What were the last two dates that a customer from customer group `249001` placed an order?**

This repository contains:
- The SQL logic used to answer the question
- dbt models that formalize and structure that logic
- A Power BI report that surfaces the answer clearly for business users

---

## Architecture & Data Flow

Excel Dataset
→ PostgreSQL (raw ingestion)
→ dbt (staging + analytics models)
→ Power BI (semantic model + reporting)

**Design rationale**
- Transformations live in dbt for testability and reuse
- Power BI remains a consumption layer, not a transformation engine
- Business logic is centralized and explainable

---

## Data Modeling Approach

### Core Entities
**Customers**  
Grain: one row per customer  
Used for filtering, grouping, and attribution

**Sales Orders**  
Grain: one row per order  
Contains invoice dates and order-level metrics

**Sales Order Lines** (optional extension)  
Grain: one row per product per order  
Enables product and category analysis

---

## Analytics Logic
To determine the *last two order dates per customer*, window functions are used to rank invoice dates by customer.

`DENSE_RANK()` is intentionally chosen so multiple orders on the same date are treated as the same business event rather than arbitrarily split.

This approach ensures the logic reflects **business meaning**, not just technical ordering.

---

## Key dbt Models
- stg_customers
- stg_sales_orders
- int_customer_last_two_order_dates

The intermediate model:
- Ranks invoice dates per customer
- Supports flexible filtering (most recent vs last two)
- Is designed for direct BI consumption

All models are **customer-agnostic** and reusable across reporting use cases.

---

## Power BI Report

### Page 1 — Customer Group 249001
- Slicer: Customer Group
- Table: Customers with ranked invoice dates
- Cards:
  - Most recent order date
  - Second most recent order date

This page directly answers the interview question.

### Page 2 — Sales Overview (Extension)
- Orders over time
- Sales by customer or product category
- Top customers by revenue

This page demonstrates how the same modeled data can be extended into operational KPIs.

---

## Notes on Data Validation
During validation, customer group `249001` was found to contain limited order history in the provided dataset.

To demonstrate correctness, the same query structure was validated against additional customers with repeat orders. The SQL and dbt models are **not hard-coded to a specific customer** and behave consistently across the dataset.

---

## Why This Matters
This project highlights:
- Thoughtful modeling over ad-hoc querying
- Clear separation of concerns between transformation and reporting
- BI deliverables that are easy to explain to both technical and non-technical stakeholders

---

## How This Would Scale
In a production environment:
- dbt models would be tested and versioned
- Power BI datasets would refresh on a schedule
- Additional facts (shipments, invoices, signatures) could be joined cleanly without rewriting logic

---

## Tools Used
- PostgreSQL
- dbt
- Power BI
- SQL

cat scripts/rename_sms_tables.sql | docker compose exec -T postgres psql -U airflow -d seafood
python scripts/load_sms_dataset.py
