# Project Overview

## Project Name

**DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics Platform**

## Short Description

DiscoverIQ is an ecommerce analytics project built to understand how users move through the product discovery journey:

```text
Product View → Add to Cart → Purchase
```

The project analyzes October and November 2019 ecommerce behavior data from the public REES46 multi-category store dataset. It uses Python, DuckDB SQL, and Power BI to identify funnel drop-offs, product ranking opportunities, hidden-gem products, category and brand performance, and user segment behavior.

The final output is a Power BI dashboard designed as a product discovery intelligence platform for ecommerce decision-making.

---

## Project Objective

The main objective of this project is to answer a core ecommerce business question:

> Users are viewing products and adding some of them to cart, but why are they not completing purchases?

To answer this, the project focuses on five areas:

1. Executive ecommerce performance
2. Product discovery funnel analysis
3. Product ranking and hidden-gem detection
4. Category and brand performance
5. User segmentation and personalization opportunities

The goal is not only to report what happened, but to identify where the business should take action.

---

## Business Context

Modern ecommerce platforms depend heavily on product discovery. If users cannot find the right products, or if the products shown to them are not relevant, conversion drops.

This project studies product discovery through behavioral signals such as:

* product views,
* add-to-cart actions,
* purchases,
* revenue,
* product visibility,
* conversion rate,
* cart abandonment,
* user segment behavior.

The project is inspired by ecommerce product discovery use cases similar to companies working on search, ranking, personalization, recommendations, and conversion optimization.

This project is independent and uses public data. It is not an official Constructor.io project or dataset.

---

## Dataset Used

The project uses the public **REES46 Ecommerce Behavior Dataset** from Kaggle.

The dataset contains ecommerce events from a large multi-category online store.

### Original Event Types

The raw dataset contains three main event types:

| Event Type | Meaning                      |
| ---------- | ---------------------------- |
| `view`     | User viewed a product        |
| `cart`     | User added a product to cart |
| `purchase` | User purchased a product     |

### Original Columns

| Column          | Description                         |
| --------------- | ----------------------------------- |
| `event_time`    | Timestamp of user event             |
| `event_type`    | Type of event: view, cart, purchase |
| `product_id`    | Unique product identifier           |
| `category_id`   | Encoded product category            |
| `category_code` | Human-readable category path        |
| `brand`         | Product brand                       |
| `price`         | Product price                       |
| `user_id`       | Unique user identifier              |
| `user_session`  | Session identifier                  |

---

## Data Scale

The original dataset was large and could not be processed directly in a normal free notebook environment.

Approximate raw scale:

| Month         | Raw Dataset Size |
| ------------- | ---------------: |
| October 2019  |        42M+ rows |
| November 2019 |        67M+ rows |

To make the project workable, I created a stratified working sample of approximately 5M rows per month while preserving the original event-type distribution.

This allowed analysis to continue without destroying the business meaning of the funnel.

---

## Large Data and RAM Challenge

One of the most important learning parts of this project was handling large data under memory limits.

The raw CSV files were too large to load and process directly in a standard notebook environment. This created real issues around:

* RAM usage,
* file size,
* processing time,
* data type memory cost,
* notebook crashes,
* inefficient transformations.

Instead of reducing the dataset randomly, I used stratified sampling based on `event_type`.

This ensured that the proportion of views, carts, and purchases remained close to the original dataset distribution.

This was important because the entire project depends on accurate funnel behavior.

### Memory Optimization Steps

To reduce memory usage, the following steps were applied:

* loaded only necessary data,
* applied stratified sampling,
* removed invalid zero-price rows,
* handled null values,
* converted object columns to category where useful,
* downcasted integer columns,
* downcasted float columns,
* created session-level and dimension-level summary tables,
* exported BI-ready summary files instead of using raw event data directly in Power BI.

The working memory footprint was reduced significantly, making the project practical to complete inside Kaggle Notebook.

This project taught a key real-world lesson:

> Data analytics is not only about dashboards. It also requires understanding data size, RAM, sampling strategy, and efficient processing.

---

## Data Cleaning and Feature Engineering

After loading and sampling the data, several cleaning and feature engineering steps were performed.

### Cleaning Steps

1. Removed rows with invalid zero prices.
2. Dropped rows with missing `user_session` values.
3. Filled missing `brand` values with `unknown`.
4. Filled missing `category_code` values with `unknown`.
5. Converted timestamp columns to datetime.
6. Optimized data types to reduce memory usage.

### New Features Created

| New Column    | Purpose                                   |
| ------------- | ----------------------------------------- |
| `date`        | Date-level trend analysis                 |
| `hour`        | Hourly behavior analysis                  |
| `day_of_week` | Day-of-week performance                   |
| `week_number` | Weekly trend analysis                     |
| `month`       | October vs November comparison            |
| `category_l1` | Top-level category                        |
| `category_l2` | Sub-category                              |
| `price_tier`  | Budget, mid, premium, luxury segmentation |

---

## Final Analytical Tables

The raw event data was transformed into analytical tables for SQL and Power BI.

### Combined Tables

| Table                      | Purpose                                               |
| -------------------------- | ----------------------------------------------------- |
| `combined_session_summary` | Session-level funnel, revenue, and event summary      |
| `combined_dim_product`     | Product-level views, carts, purchases, and conversion |
| `combined_dim_user`        | User-level sessions, spend, purchases, and segment    |
| `combined_dim_brand`       | Brand-level revenue and conversion performance        |
| `combined_dim_category`    | Category-level revenue and conversion performance     |

### BI Export Tables

The following BI-ready tables were created using DuckDB SQL:

| BI Table                            | Purpose                               |
| ----------------------------------- | ------------------------------------- |
| `bi_executive_kpis`                 | Executive KPI cards                   |
| `bi_discovery_funnel`               | Product view → cart → purchase funnel |
| `bi_funnel_rates`                   | Funnel conversion and drop-off rates  |
| `bi_daily_trend`                    | Daily revenue and conversion trend    |
| `bi_day_of_week_performance`        | Day-of-week performance               |
| `bi_category_performance`           | Category-level performance            |
| `bi_brand_performance`              | Brand-level performance               |
| `bi_product_ranking`                | Product-level ranking metrics         |
| `bi_product_ranking_classification` | Product ranking segments              |
| `bi_hidden_gems`                    | Underexposed high-converting products |
| `bi_high_visibility_low_conversion` | High-traffic weak-conversion products |
| `bi_user_segment_performance`       | User segment performance              |
| `bi_high_value_users`               | Top high-value users                  |
| `bi_mom_kpi_change`                 | Month-over-month KPI change           |
| `bi_category_mom_change`            | Category month-over-month change      |
| `bi_brand_mom_change`               | Brand month-over-month change         |

---

## Tools and Technologies

| Tool            | Role                                      |
| --------------- | ----------------------------------------- |
| Python          | Data cleaning and feature engineering     |
| Pandas          | Data manipulation                         |
| DuckDB          | SQL analysis inside Kaggle Notebook       |
| Kaggle Notebook | Large data processing environment         |
| Power BI        | Dashboard development                     |
| Power Query     | Data loading and transformation           |
| GitHub          | Project documentation and version control |

---

## Dashboard Pages

The Power BI dashboard contains six pages.

### 1. Home

A branded landing page for DiscoverIQ.

### 2. Executive Overview

Shows high-level business performance:

* total revenue,
* total sessions,
* total users,
* conversion rate,
* cart abandonment,
* revenue by month,
* top categories,
* top brands.

### 3. Product Discovery Funnel

Analyzes how users move through:

```text
Product View → Add to Cart → Purchase
```

This page identifies where the largest funnel drop-offs happen.

### 4. Product Ranking Analytics

Analyzes product-level performance to identify:

* winner products,
* hidden gems,
* high-visibility low-conversion products,
* low-priority products.

This page connects product visibility with conversion quality.

### 5. Category & Brand Performance

Compares category and brand performance across revenue, conversion, abandonment, and month-over-month change.

### 6. User Segmentation & Personalization

Analyzes user segments such as new, returning, loyal, and high-value users.

This page identifies which segments generate the most revenue and where personalization can help.

---

## Core Business Findings

### 1. November Had More Traffic but Lower Revenue

November had more sessions and users than October, but revenue declined.

This means the problem was not lack of traffic. The problem was weak conversion after users showed product interest.

### 2. Cart Abandonment Increased Sharply

Cart abandonment increased significantly from October to November.

This suggests that many users were adding products to cart but delaying or avoiding purchase completion.

### 3. Product Discovery Interest Improved, but Purchase Completion Dropped

November had a higher view-to-cart rate than October, which means product interest improved.

However, cart-to-purchase conversion dropped sharply, causing lower final conversion and revenue.

### 4. Electronics Drove the Most Revenue but Also the Largest Decline

Electronics was the dominant revenue category in both months, but it also contributed the largest revenue decline from October to November.

### 5. Apple and Samsung Led Revenue but Declined in November

Apple and Samsung remained the top revenue brands, but both saw lower purchases and higher cart abandonment in November.

### 6. Hidden-Gem Products Were Found

The project identified products with low visibility but strong conversion.

These products are good candidates for higher ranking, recommendation blocks, or product discovery promotion.

### 7. High-Visibility Low-Conversion Products Were Found

Some products received high visibility but failed to convert.

These products should be investigated for pricing, relevance, product page quality, image quality, or ranking issues.

### 8. Loyal Users Were the Most Valuable Segment

Loyal users generated the highest revenue per user, showing that repeat engagement is strongly connected with customer value.

---

## Product Discovery Logic

The product ranking section of this project classifies products into four groups:

| Segment                        | Meaning                             | Business Action             |
| ------------------------------ | ----------------------------------- | --------------------------- |
| Winner Product                 | High visibility and high conversion | Keep ranking high           |
| Hidden Gem                     | Low visibility and high conversion  | Promote higher              |
| High Visibility Low Conversion | High visibility but weak conversion | Investigate or deprioritize |
| Low Priority Product           | Low visibility and weak conversion  | Low focus                   |

This logic turns raw product metrics into ranking decisions.

---

## Why This Project Is Useful

This project can help ecommerce teams answer questions such as:

* Which products should be promoted?
* Which products are wasting visibility?
* Which categories are losing conversion?
* Which brands are underperforming?
* Which user segments should be targeted?
* Where does the funnel break?
* Why did revenue decline despite traffic growth?

These are practical questions for product, analytics, merchandising, and growth teams.

---

## Constructor.io Alignment

This project aligns with ecommerce product discovery use cases such as:

| Project Area                      | Product Discovery Use Case                  |
| --------------------------------- | ------------------------------------------- |
| Funnel drop-off                   | Search and ranking optimization             |
| Hidden gems                       | Boost underexposed high-converting products |
| High-view low-conversion products | Searchandising and ranking investigation    |
| Category performance              | Category page optimization                  |
| Brand performance                 | Brand-level merchandising                   |
| User segmentation                 | Personalization                             |
| Co-purchase behavior              | Recommendation systems                      |
| Cart abandonment                  | Urgency signals and checkout nudges         |

The project shows how analytics can connect shopper behavior to ranking, personalization, and conversion decisions.

---

## Limitations

This project has some limitations:

1. The dataset does not contain real search query text.
2. Search analytics are inferred from product discovery behavior, not actual search logs.
3. Recommendation analytics are simulated using product behavior and co-purchase patterns.
4. Stratified sampling was required because of memory limits.
5. Some session-level artifacts may occur because row-level sampling can split user sessions.
6. The data is from 2019 and may not represent current ecommerce behavior.

---

## Final Outcome

The final outcome is a portfolio-ready analytics project that demonstrates:

* large dataset handling,
* memory-aware data processing,
* Python cleaning and feature engineering,
* SQL analysis with DuckDB,
* BI-ready data modeling,
* Power BI dashboard design,
* funnel analysis,
* product ranking analytics,
* user segmentation,
* and ecommerce product discovery thinking.

DiscoverIQ shows how raw ecommerce event data can be transformed into business decisions for improving product discovery, ranking, conversion, and personalization.
