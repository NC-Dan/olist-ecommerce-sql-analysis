# Olist E-Commerce SQL Analysis — Project 2

**Author:** Duncan Chicho (NC-Dan)  
**Tool:** Microsoft SQL Server  
**Dataset:** Olist Brazilian E-Commerce Dataset (Kaggle)  
**Scale:** 99,441 orders | 4 related tables | 415,418 total rows  
**Complexity:** Intermediate — Multi-table JOINs, CTEs, Window Functions, Date Functions

---

## Business Problem

Olist is Brazil's largest e-commerce marketplace. This project analyses 
99,441 orders across 4 relational tables to answer three core business 
questions:

1. **Growth** — How did order volume trend over time?
2. **Revenue** — Which payment types and states drive the most value?
3. **Retention** — Are customers coming back?

---

## Database Architecture

This project uses a real relational database structure with enforced 
Primary Keys and Foreign Keys:

---

## Data Quality Audit

Before any analysis, I performed a full data quality check:

| Column | Issue | Rows Affected | Action Taken |
|---|---|---|---|
| order_approved_at | NULL values | 160 | Flagged — cancelled orders |
| order_delivered_customer_date | NULL values | 2,965 | Excluded from delivery analysis |
| not_defined payment_type | Unknown type | 3 | Flagged — excluded from revenue |
| delivered status + NULL delivery date | Inconsistency | 8 | Flagged as data quality issue |

**Clean columns:** order_id, customer_id, order_status, order_purchase_timestamp — 
0 NULLs, 0 duplicates confirmed.

---

## Key Findings

### Finding 1 — Explosive Growth in 14 Months
- September 2016: **1 order** — business launch
- November 2017: **7,289 orders** — Black Friday Brazil spike
- August 2018: **6,351 orders** — sustained mature volume
- Growth from 1 to 7,000+ orders/month in just 14 months

### Finding 2 — Credit Card Dominates Revenue
- Credit card: **78.34% of total revenue** | $163.32 avg order value
- Boleto: 17.92% revenue | $145.03 avg order value
- Voucher: 2.37% revenue | $65.70 avg order value — significantly lower
- Credit card customers spend **$18 more per order** than boleto customers

### Finding 3 — Delivery Speed Is a Competitive Problem
- Only **31.82%** of orders arrive within 1 week
- **39.37%** arrive within 2 weeks
- **4.45%** take over 1 month
- Average delivery across Brazil: **12 days**
- For context: Amazon Prime delivers 90%+ within 2 days

### Finding 4 — São Paulo Dominates, Remote States Pay More
- SP: $5,769,081 revenue | 40,493 orders | 8 days avg delivery — Rank 1
- RJ: $2,055,690 revenue | 12,350 orders | 15 days avg delivery — Rank 2
- Top 3 states (SP, RJ, MG) generate majority of revenue
- Remote northern states (RR, AP, AM) average 26-29 days delivery
- **Remote customers pay more per order** — AP avg $240, AC avg $244, AL avg $237
- Opportunity: Remote customers already spend more — targeted marketing could 
  increase their order frequency

### Finding 5 — Zero Repeat Customers
- **100% of customers purchased exactly once**
- 96,478 customers — not a single repeat buyer
- Customer retention rate: **0%**
- This is the single most critical business problem in the dataset
- Amazon repeat purchase rate: 90%+ — Olist has a fundamental retention gap

---

## Recommendations

**1. Fix delivery speed urgently**
12-day average delivery is 6x slower than global e-commerce leaders. 
Investment in regional fulfilment centres — particularly in RJ, MG and 
BA — would directly improve the 68% of orders currently taking over 1 week.

**2. Launch a customer retention programme**
Zero repeat buyers is an existential business risk. Every customer acquired 
is lost after one purchase. Email re-engagement, loyalty discounts and 
personalised recommendations should be immediate priorities.

**3. Target remote high-value customers**
States like AP, AC and AL have the highest avg order values ($240+) but 
lowest order volumes. A targeted marketing campaign in these states would 
yield high revenue per customer acquired.

**4. Protect and grow credit card customers**
At 78.34% of revenue and $18 higher avg order value than boleto, credit 
card users are the most valuable segment. Payment instalment offers and 
credit card exclusive promotions would deepen this relationship.

---

## SQL Skills Demonstrated

- **Multi-table JOINs** — 3 tables joined in a single query (Orders + Customers + Payments)
- **Primary Keys & Foreign Keys** — enforced referential integrity across 4 tables
- **Multi-level CTEs** — CTEs feeding CTEs for complex aggregations
- **Date Functions** — YEAR(), MONTH(), DATEDIFF(), FORMAT() for trend analysis
- **Window Functions** — RANK(), SUM() OVER(), running totals
- **UNION ALL** — combining result sets for data quality checks
- **ISNULL()** — professional NULL handling
- **CASE WHEN** — delivery banding and segmentation
- **Data Quality Auditing** — NULL counts, duplicate detection, consistency checks
- **CAST & DECIMAL** — precision formatting for financial figures

---

## Project Files

| File | Description |
|---|---|
| 01_setup_and_data_quality.sql | Import verification, NULL audit, PK/FK setup, data quality checks |
| 02_core_analysis.sql | Monthly trends, payment revenue analysis, delivery performance |
| 03_advanced_analysis.sql | Multi-table JOINs, state analysis, customer frequency analysis |

---

## Dataset Source

[Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
Real anonymised commercial data from Olist — Brazil's largest e-commerce marketplace

---

## | Other SQL & Excel Projects |

- 🔗 [IBM HR Attrition Analysis — SQL](https://github.com/NC-Dan/ibm-hr-attrition-sql-analysis)
- 🔗 [Global Superstore Sales Dashboard — Excel](https://github.com/NC-Dan/global-superstore-sales-dashboard)
- 🔗 [Kenya Banking Risk Dashboard — Excel](https://github.com/NC-Dan/kenya-banking-risk-dashboard)
- 🔗 [Healthcare Analytics — Excel](https://github.com/NC-Dan/healthcare-analytics-dashboard)

---

Connect on LinkedIn 🔗 [linkedin.com/in/duncanalyst](https://www.linkedin.com/in/duncanalyst)
