# 🌍 EcoTrack: Western Europe Product & Monetization Pulse

An end-to-end Analytics Engineering and Product Data Analysis project simulating a consumer ClimateTech mobile application. This repository demonstrates a modern data stack pipeline—from synthetic data generation and automated cloud ingestion to dbt data modeling, advanced BigQuery SQL analytics, and Looker Studio business intelligence.

---

## 🚀 Project Overview

**EcoTrack** is a mock ClimateTech mobile application operating across six Western European markets: **France, Germany, Netherlands, Belgium, Spain, and Italy**. The app helps users track daily eco-friendly habits, participate in sustainability challenges, and offset their carbon footprint through in-app purchases and subscription tiers (`Free`, `Basic`, and `Premium`).

This project answers critical product and business questions:
* *How is user engagement and app stickiness trending across different European countries?*
* *What is the conversion rate and revenue share of recurring subscriptions versus one-time carbon offset purchases?*
* *How do demographic cohorts (age and gender) impact Lifetime Value (LTV) and feature adoption?*

---

## 🛠️ Tech Stack & Architecture

```text
[Python / Pandas] -> 4 CSV Datasets (25k Users + Logs)
       ↓
[Google Cloud Storage] -> Raw Cloud Data Lake
       ↓
[Fivetran] -> Automated ELT Sync
       ↓
[Google BigQuery] -> Data Warehouse (Raw & Marts Schemas)
       ↓
[dbt Cloud] -> Data Cleaning, Testing & OBT Modeling
       ↓
[Looker Studio] -> EcoTrack Product Health & Tier Vitality Monitor
```

## 📊 Project Phases & Methodology

This project follows a structured data engineering and product analytics workflow, moving data from raw synthetic logs to optimized, executive-ready BI visualizations.

---

### Phase 0: Synthetic Data Generation & Automated Ingestion
To simulate a realistic consumer ClimateTech app without privacy risks, we developed a Python data generator using the `pandas` and `Faker` libraries (`data_generation/generate_ecotrack_data.py`).

* **Data Scale & Demographics:** Simulated **25,000 unique users** distributed across six Western European countries (France, Germany, Netherlands, Belgium, Spain, and Italy) with realistic age (18–70) and gender distributions.
* **Relational Schema:** Generated four interconnected CSV datasets:
  * `users.csv`: Master customer records and subscription tiers (`free`, `basic`, `premium`).
  * `sessions.csv`: Mobile app login sessions with randomized durations (2–20 minutes) scaled to user tiers.
  * `events.csv`: Granular clickstream product tracking logs (`open_app`, `log_habit`, `join_challenge`, `share_milestone`, etc.).
  * `transactions.csv`: Financial ledger tracking recurring subscription revenue and one-time e-commerce purchases (carbon offsets and eco-merchandise) in Euros (€).
* **Automated ELT Pipeline:** Uploaded raw CSVs to Google Cloud Storage (GCS) in the `europe-west1` (Belgium) region. Configured a **Fivetran** automated ingestion pipeline to stream these files directly into a Google BigQuery `raw_data` dataset.

---

### Phase 1: Data Modeling & Transformation (dbt Cloud)
We used **dbt Cloud** to transform raw, unindexed data into structured, tested analytical schemas inside BigQuery.

* **Staging Layer (`models/staging/`):** 
  * Cleaned column formatting, cast data types (UUID strings, timestamps, numeric currencies), and standardized text fields using SQL functions like `INITCAP()` and `LOWER()`.
  * Created `stg_transactions.sql` to dynamically flag financial records as either `recurring` platform revenue or `one_time` commerce revenue.
* **Data Quality & Automated Testing (`schema.yml`):**
  * Implemented strict data integrity contracts before building downstream analytics tables.
  * Applied built-in dbt tests: `unique` and `not_null` on primary keys (`user_id`, `transaction_id`, `session_id`), and `accepted_values` to ensure subscription tiers and clickstream event names match our product schema strictly.
* **Marts & BI Optimization (`models/marts/`):**
  * Built traditional star-schema models (`dim_users`, `fct_sessions`, `fct_events`, `fct_transactions`).
  * **Architectural Decision (One-Big-Table):** To optimize Looker Studio performance and minimize BigQuery cloud query costs, we built an aggregated One-Big-Table (`fct_looker_user_daily_obt`) at the **user-day grain**. This model pre-calculates heavy rolling aggregations in dbt, eliminating runtime `JOIN` latency and metric fan-out in the BI layer.

---

### Phase 2: [Product Exploratory Data Analysis (BigQuery SQL)](ecotrack_queries)
Using our optimized mart tables, we wrote 12 business-oriented SQL queries (`sql_queries/product_eda_12_queries.sql`) to evaluate app health, retention, and monetization. Key SQL coding concepts implemented include:

* **Window Functions & Rolling Averages:** 
  * Computed 7-day rolling active user flags and 7-day moving revenue averages using `AVG(...) OVER (ORDER BY activity_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`.
  * Tracked day-over-day revenue momentum using `LAG()`.
* **User Behavioral Segmentation:** 
  * Grouped users into activity deciles and quartiles using `NTILE(4) OVER (ORDER BY SUM(daily_session_count) DESC)` to isolate "Power Users" from casual users.
* **Ranking & Leaderboards:** 
  * Used `DENSE_RANK()` and `RANK() OVER (PARTITION BY DATE_TRUNC(activity_date, MONTH))` to identify our highest-grossing calendar days and rank monthly subscription tier vitality.
* **Granular Product Funnels:** Evaluated core engagement loops, such as calculating the exact average time (in hours) it takes a new user to reach their first core activation milestone (`log_habit`) after registration.

---

### Phase 3: [Looker Studio Executive Dashboard](https://datastudio.google.com/reporting/cb2553ea-df46-4d33-931a-96eeb24a68d3)
We connected Looker Studio directly to our dbt One-Big-Table (`fct_looker_user_daily_obt`) to build a responsive, interactive 3-page reporting suite: **Executive Summary**, **Product Engagement**, and **Monetization & Tier Vitality**.

* **Semantic Layer & Dynamic Ratios:** Because ratios cannot be pre-averaged across dynamic date and country filters without mathematical error, we coded custom calculated fields directly within Looker Studio:
  * **Average Revenue Per User (ARPU):** `SUM(daily_total_revenue_eur) / COUNT_DISTINCT(user_id)`
  * **7-Day Stickiness Ratio (DAU / rolling active users):** `SUM(is_active_rolling_7d) / COUNT_DISTINCT(user_id)`
  * **Recurring Revenue Share:** `SUM(daily_recurring_revenue_eur) / SUM(daily_total_revenue_eur)`
* **Chronological Sorting Implementation:** Solved Looker Studio's default alphabetical sorting limitations on pivot tables by formatting our SQL age cohort strings with sequential numbers (`18-25`, `26-35`, `36-45`, `46-55`, `56-60`, `60+`), allowing ascending alphabetical sorts to mirror natural chronological progression perfectly.
