# Methodology

## Overview

This document explains the methodology followed in the **DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics Platform** project.

The project started with raw ecommerce event data from the REES46 Kaggle dataset and converted it into clean, optimized, SQL-ready, and Power BI-ready analytical tables.

The complete workflow followed this structure:

```text
Raw Kaggle Dataset
        ↓
Large Data Handling & Stratified Sampling
        ↓
Data Cleaning & Feature Engineering
        ↓
Memory Optimization
        ↓
Session, Product, User, Brand, Category Tables
        ↓
DuckDB SQL Analysis
        ↓
BI-ready CSV Exports
        ↓
Power BI Dashboard
        ↓
Business Insights
```

---

## 1. Dataset Understanding

The first step was to understand the raw ecommerce event data.

The dataset contained user-product interaction events from a large multi-category ecommerce store.

The main event types were:

```text
view
cart
purchase
```

These events represent the ecommerce product discovery journey:

```text
Product View → Add to Cart → Purchase
```

The original dataset included columns such as:

| Column          | Description                         |
| --------------- | ----------------------------------- |
| `event_time`    | Timestamp of user event             |
| `event_type`    | Type of event: view, cart, purchase |
| `product_id`    | Unique product identifier           |
| `category_id`   | Encoded category identifier         |
| `category_code` | Human-readable product category     |
| `brand`         | Product brand                       |
| `price`         | Product price                       |
| `user_id`       | Unique user identifier              |
| `user_session`  | Session identifier                  |

The first analysis focused on understanding:

* dataset shape,
* event distribution,
* missing values,
* date range,
* price distribution,
* unique users,
* unique products,
* categories,
* brands,
* session behavior.

---

## 2. Large Data Challenge

The original dataset was very large.

Approximate raw scale:

| Month         | Raw Data Size |
| ------------- | ------------: |
| October 2019  |     42M+ rows |
| November 2019 |     67M+ rows |

The full files were too large to process directly in a normal free notebook environment.

This created problems such as:

* high RAM usage,
* slow loading,
* notebook crashes,
* long processing time,
* memory errors during transformations,
* difficulty using the full raw data directly in Power BI.

This became an important real-world learning point.

In real analytics projects, working with large data is not only about writing code. It also requires understanding memory limits, sampling strategy, data types, aggregation, and efficient processing.

---

## 3. Sampling Strategy

Because the full raw dataset was too large, a working sample was created.

A simple random sample was not enough because the dataset had an imbalanced event distribution.

Most events were product views, while cart and purchase events were much smaller in number.

If the data was sampled carelessly, the funnel behavior could become unreliable.

To avoid this, stratified sampling was used.

## Stratified Sampling Logic

The data was sampled by `event_type`.

This means the sample preserved the original distribution of:

```text
view
cart
purchase
```

The working sample size was:

| Month    | Working Sample |
| -------- | -------------: |
| October  |        5M rows |
| November |        5M rows |

## Why Stratified Sampling Was Used

Stratified sampling was used because the project depends heavily on funnel analysis.

The dashboard compares:

```text
View Sessions → Cart Sessions → Purchase Sessions
```

If the sample does not preserve the correct ratio of views, carts, and purchases, then conversion rate and cart abandonment analysis becomes misleading.

By sampling within each event type, the project preserved the business meaning of the funnel while reducing the data size enough to process.

---

## 4. Data Cleaning

After sampling, the data was cleaned before analysis.

## 4.1 Price Filtering

Rows with `price = 0` were removed.

These were treated as invalid or pipeline-error rows because real purchase and product analytics require meaningful price values.

Reason:

```text
A product with zero price can distort revenue, average order value, price-tier analysis, and product ranking metrics.
```

## 4.2 Missing Value Handling

Missing values were handled carefully.

| Column          | Issue                 | Action                |
| --------------- | --------------------- | --------------------- |
| `category_code` | Many missing values   | Filled with `unknown` |
| `brand`         | Missing brand values  | Filled with `unknown` |
| `user_session`  | Very few missing rows | Dropped               |

## Why Missing Categories Were Not Dropped

A large percentage of `category_code` values were missing.

Dropping all missing categories would remove too much data and distort the analysis.

Instead, missing categories were grouped as:

```text
unknown
```

This allowed the project to keep the data while still making missing-category behavior visible in the dashboard.

## Why Missing Brands Were Filled

Missing brand values were also filled as:

```text
unknown
```

This made brand-level analysis more complete and avoided losing valid user behavior.

---

## 5. Feature Engineering

New columns were created from the raw data to support analysis.

## Time-Based Features

| New Column    | Source        | Purpose                        |
| ------------- | ------------- | ------------------------------ |
| `date`        | `event_time`  | Daily trend analysis           |
| `hour`        | `event_time`  | Hourly behavior analysis       |
| `day_of_week` | `event_time`  | Day-of-week performance        |
| `week_number` | `event_time`  | Weekly trend analysis          |
| `month`       | Dataset month | October vs November comparison |

## Category Features

The `category_code` column was split into category levels.

Example:

```text
electronics.smartphone
```

became:

| Column        | Value       |
| ------------- | ----------- |
| `category_l1` | electronics |
| `category_l2` | smartphone  |

This allowed the dashboard to analyze both broad category behavior and sub-category behavior.

## Price Tier Feature

Products were grouped into price tiers.

| Price Tier | Price Range |
| ---------- | ----------: |
| `budget`   |      $0–$50 |
| `mid`      |    $50–$200 |
| `premium`  |   $200–$500 |
| `luxury`   |       $500+ |

This allowed analysis of how product price range affects conversion, revenue, and purchase behavior.

---

## 6. Memory Optimization

Memory optimization was one of the most important parts of the project.

The original data was too large to work with directly, so the project applied several optimization techniques.

## Optimization Techniques Used

| Technique                             | Purpose                                              |
| ------------------------------------- | ---------------------------------------------------- |
| Stratified sampling                   | Reduce row count while preserving event distribution |
| Dropping invalid rows                 | Remove unusable data                                 |
| Downcasting integers                  | Reduce memory usage of ID columns                    |
| Downcasting floats                    | Reduce memory usage of price columns                 |
| Converting object columns to category | Reduce memory for repeated text values               |
| Aggregating to summary tables         | Avoid using raw events directly in BI                |
| Exporting BI-ready CSVs               | Make Power BI faster and lighter                     |

## Example Data Type Optimizations

| Column        | Original Type | Optimized Type | Reason                           |
| ------------- | ------------- | -------------- | -------------------------------- |
| `product_id`  | int64         | int32          | ID column does not require int64 |
| `category_id` | int64         | int32          | Reduces memory usage             |
| `user_id`     | int64         | int32          | Reduces memory usage             |
| `price`       | float64       | float32        | Enough precision for analysis    |
| `event_type`  | object        | category       | Few repeated values              |
| `brand`       | object        | category       | Many repeated brand names        |
| `hour`        | int64         | int8           | Hour only ranges from 0 to 23    |

## Result

Memory usage was reduced significantly.

Approximate reduction:

```text
2.94 GB → 0.84 GB
```

This made it possible to continue the project inside Kaggle Notebook.

## Learning

This step proved that data analysis is not only about creating charts.

A real analyst must also understand:

* RAM limits,
* data size,
* data types,
* sampling,
* aggregation,
* efficient processing.

---

## 7. Analytical Table Creation

After cleaning and optimization, the data was transformed into analytical tables.

Instead of sending raw event-level data directly to Power BI, summary tables were created.

This made the final Power BI report faster, cleaner, and easier to model.

## Final Combined Tables

| Table                      | Grain                          | Purpose                           |
| -------------------------- | ------------------------------ | --------------------------------- |
| `combined_session_summary` | One row per session            | Funnel, revenue, session behavior |
| `combined_dim_product`     | One row per product per month  | Product ranking and conversion    |
| `combined_dim_user`        | One row per user per month     | User segmentation                 |
| `combined_dim_brand`       | One row per brand per month    | Brand performance                 |
| `combined_dim_category`    | One row per category per month | Category performance              |

## Why Summary Tables Were Created

Summary tables were created because:

* raw event data was too large,
* Power BI performs better with aggregated tables,
* dashboard pages need business metrics, not raw rows,
* SQL analysis becomes easier on structured tables,
* each table has a clear business grain.

---

## 8. Session-Level Methodology

The session table was created to understand the user journey.

Each session was classified based on whether it contained:

| Flag        | Meaning                                    |
| ----------- | ------------------------------------------ |
| `viewed`    | Session had at least one product view      |
| `carted`    | Session had at least one add-to-cart event |
| `purchased` | Session had at least one purchase event    |

This allowed funnel metrics such as:

```text
View Sessions
Cart Sessions
Purchase Sessions
View-to-Cart Rate
Cart-to-Purchase Rate
Conversion Rate
Cart Abandonment Rate
```

## Session-Level Metrics

| Metric            | Logic                             |
| ----------------- | --------------------------------- |
| Total Sessions    | Count of sessions                 |
| View Sessions     | Sessions where `viewed = 1`       |
| Cart Sessions     | Sessions where `carted = 1`       |
| Purchase Sessions | Sessions where `purchased = 1`    |
| Revenue           | Sum of purchase prices            |
| Conversion Rate   | Purchase sessions / view sessions |
| Cart Abandonment  | Cart sessions without purchase    |

---

## 9. Product-Level Methodology

Product-level tables were created to understand visibility and conversion quality.

Each product was analyzed using:

| Metric                  | Meaning                        |
| ----------------------- | ------------------------------ |
| `total_views`           | Product visibility             |
| `total_carts`           | Product interest               |
| `total_purchases`       | Product purchase success       |
| `conversion_rate`       | Product purchase efficiency    |
| `cart_rate`             | Add-to-cart efficiency         |
| `cart_to_purchase_rate` | Purchase completion after cart |

This helped identify product ranking opportunities.

## Product Ranking Segments

Products were classified into four groups:

| Segment                        | Meaning                                | Business Action   |
| ------------------------------ | -------------------------------------- | ----------------- |
| Winner Product                 | High visibility and high conversion    | Keep ranking high |
| Hidden Gem                     | Lower visibility but strong conversion | Promote higher    |
| High Visibility Low Conversion | High visibility but weak conversion    | Investigate       |
| Low Priority Product           | Low visibility and weak conversion     | Low focus         |

---

## 10. Hidden-Gem Methodology

Hidden gems were products with limited visibility but strong conversion.

## Hidden-Gem Criteria

```text
total_views between 20 and 200
conversion_rate >= 3%
total_purchases >= 3
```

## Business Meaning

These products are not receiving huge visibility, but users who discover them are buying.

This suggests they may deserve:

* better ranking,
* more recommendation exposure,
* category page promotion,
* personalized placement.

---

## 11. High-Visibility Low-Conversion Methodology

This analysis identifies products that receive many views but fail to convert.

## Criteria

```text
total_views >= 1,000
conversion_rate < 1%
total_purchases < 10
```

## Business Meaning

These products may be wasting valuable visibility.

Possible issues:

* wrong ranking position,
* poor price competitiveness,
* weak product page,
* bad product images,
* low relevance,
* low trust,
* poor offer quality.

These products should be investigated or deprioritized.

---

## 12. User Segmentation Methodology

Users were segmented based on number of sessions.

| Segment   | Logic        | Meaning                             |
| --------- | ------------ | ----------------------------------- |
| New       | 1 session    | One-time or first-time users        |
| Returning | 2–5 sessions | Users with moderate repeat behavior |
| Loyal     | 6+ sessions  | Highly engaged repeat users         |

User metrics were calculated to support personalization analysis.

| Metric               | Meaning              |
| -------------------- | -------------------- |
| `total_sessions`     | Engagement frequency |
| `total_events`       | Activity level       |
| `total_purchases`    | Purchase behavior    |
| `total_spend`        | Revenue contribution |
| `revenue_per_user`   | User value           |
| `sessions_per_user`  | Engagement depth     |
| `purchases_per_user` | Purchase depth       |

---

## 13. Category and Brand Methodology

Category and brand tables were created to identify revenue drivers and weak areas.

Each category and brand was analyzed using:

| Metric            | Meaning                |
| ----------------- | ---------------------- |
| View sessions     | Discovery volume       |
| Cart sessions     | Product interest       |
| Purchase sessions | Purchase completion    |
| Revenue           | Business value         |
| Conversion rate   | Purchase efficiency    |
| Cart abandonment  | Purchase friction      |
| Revenue per view  | Discovery monetization |

This helped identify:

* top revenue categories,
* top revenue brands,
* underperforming categories,
* brand conversion gaps,
* month-over-month declines.

---

## 14. Month-over-Month Methodology

October and November were compared to understand behavioral change.

The project calculated changes in:

* sessions,
* users,
* revenue,
* conversion rate,
* cart abandonment,
* revenue per session,
* category revenue,
* brand revenue,
* category conversion,
* brand conversion.

## Month-over-Month Change Logic

```text
change = November value - October value
```

```text
change percentage = (November value - October value) / October value * 100
```

This helped explain why November had more traffic but lower revenue.

---

## 15. SQL Analysis Methodology

DuckDB was used to run SQL queries inside Kaggle Notebook.

The SQL layer was used to create BI-ready export tables.

SQL analysis covered:

| Area               | Output                               |
| ------------------ | ------------------------------------ |
| Executive KPIs     | Revenue, sessions, users, conversion |
| Funnel Analysis    | Product view, cart, purchase stages  |
| Daily Trends       | Revenue and conversion by date       |
| Day-of-Week Trends | Best and worst shopping days         |
| Category Analysis  | Category revenue and conversion      |
| Brand Analysis     | Brand revenue and conversion         |
| Product Ranking    | Hidden gems and weak products        |
| User Segmentation  | Segment value and behavior           |
| Month-over-Month   | October vs November comparison       |

Using SQL made the project closer to real BI workflows, where dashboards are powered by structured query outputs rather than raw data files.

---

## 16. Power BI Methodology

Power BI was used for dashboard design and business storytelling.

The BI-ready CSV exports were loaded into Power BI and connected through a month dimension table.

## Dashboard Pages

The Power BI dashboard contains:

```text
Home
Executive Overview
Product Discovery Funnel
Product Ranking Analytics
Category & Brand Performance
User Segmentation & Personalization
```

## Power BI Design Rules

The dashboard followed these rules:

* use summary tables instead of raw event data,
* keep pages focused on one business question,
* use KPI cards for executive metrics,
* use funnel visuals for journey analysis,
* use scatter plots for product ranking analysis,
* use bar charts for category and brand ranking,
* use tables for detailed product/user lists,
* use consistent month colors,
* avoid overloading pages with too many visuals,
* write insight text to explain the business meaning.

---

## 17. Aggregation Methodology

Correct aggregation was important in Power BI.

| Field Type            | Aggregation                              |
| --------------------- | ---------------------------------------- |
| Revenue               | Sum                                      |
| Sessions              | Sum                                      |
| Users                 | Sum or distinct count depending on table |
| Views                 | Sum                                      |
| Carts                 | Sum                                      |
| Purchases             | Sum                                      |
| Conversion Rate       | Average                                  |
| Cart Abandonment      | Average                                  |
| View-to-Cart Rate     | Average                                  |
| Cart-to-Purchase Rate | Average                                  |
| Product ID            | Do not summarize                         |
| User ID               | Do not summarize                         |
| Brand                 | Do not summarize                         |
| Category              | Do not summarize                         |

## Important Percentage Note

Percentage columns were stored as actual percentage values.

Example:

```text
2.82 means 2.82%, not 0.0282
```

Therefore, these values should not be multiplied by 100 again in Power BI.

---

## 18. Known Methodology Limitation

Because stratified sampling was performed at the row level, some session-level artifacts may appear.

For example, a session may contain a purchase event in the sample but miss the earlier cart event if the cart row was not included.

This can affect some cart-to-purchase or cart abandonment calculations at a detailed level.

To reduce the impact:

* analysis was focused on aggregated patterns,
* unreliable category/brand cases were filtered when needed,
* limitations were documented clearly,
* the project avoided claiming exact production-level causality.

---

## 19. Why This Methodology Was Chosen

This methodology was chosen because it balances:

* large-data practicality,
* memory limits,
* business accuracy,
* reproducibility,
* SQL readiness,
* Power BI performance,
* and portfolio presentation quality.

The goal was not just to create a dashboard.

The goal was to build a full analytics workflow:

```text
Large raw data → clean model → SQL analysis → BI dashboard → business actions
```

---

## 20. Final Methodology Summary

The methodology followed in this project was:

1. Understand the raw ecommerce event dataset.
2. Identify memory and processing constraints.
3. Use stratified sampling to preserve funnel behavior.
4. Clean invalid prices and missing values.
5. Engineer time, category, month, and price-tier features.
6. Optimize data types to reduce RAM usage.
7. Create session, product, user, brand, and category summary tables.
8. Use DuckDB SQL to create BI-ready analytical exports.
9. Load BI exports into Power BI.
10. Build dashboard pages around business questions.
11. Interpret results into product discovery and conversion insights.

This approach transformed a large raw ecommerce dataset into a complete product discovery analytics platform.
