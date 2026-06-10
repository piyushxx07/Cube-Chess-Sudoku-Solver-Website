# DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics Platform

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge\&logo=powerbi\&logoColor=black)
![Python](https://img.shields.io/badge/Python-Data%20Analysis-3776AB?style=for-the-badge\&logo=python\&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-SQL-FFF000?style=for-the-badge)
![Kaggle](https://img.shields.io/badge/Kaggle-Notebook-20BEFF?style=for-the-badge\&logo=kaggle\&logoColor=white)
![Status](https://img.shields.io/badge/Project-Portfolio%20Ready-success?style=for-the-badge)

## Project Summary

**DiscoverIQ** is an ecommerce product discovery analytics platform built using the public **REES46 Ecommerce Behavior Dataset** from Kaggle.

The project analyzes user behavior across **October and November 2019** to understand how shoppers move through the product discovery journey:

```text
Product View → Add to Cart → Purchase
```

The goal is to identify:

* where users drop off in the discovery funnel,
* which products receive visibility but fail to convert,
* which underexposed products deserve higher ranking,
* which categories and brands drive revenue,
* how user segments behave differently,
* and why revenue declined despite higher traffic in November.

This project is inspired by ecommerce search, ranking, personalization, and product discovery problems similar to the type of work done by companies like **Constructor.io**.

> This is not an official Constructor.io project or dataset. It is an independent portfolio project using public ecommerce behavior data.

---

## Why This Project Matters

Most ecommerce dashboards only show revenue and sales.

DiscoverIQ goes deeper.

It asks product-discovery questions such as:

* Are users finding the right products?
* Are high-visibility products actually converting?
* Which products should be promoted higher?
* Which products should be investigated or ranked lower?
* Which user segments are most valuable?
* Where does the customer journey break?

This makes the project more than a sales dashboard. It becomes a **decision intelligence dashboard** for ecommerce product discovery and conversion optimization.

---

## Business Problem

Ecommerce users often browse products but fail to complete purchases.

In this project, the key problem was:

> November had more sessions and more product/cart activity than October, but revenue and conversion declined sharply.

The dashboard investigates this problem through funnel analysis, product ranking logic, category and brand performance, and user segmentation.

---

## Dataset

| Property                | Details                                                  |
| ----------------------- | -------------------------------------------------------- |
| Dataset                 | REES46 Ecommerce Behavior Data from Multi-Category Store |
| Source                  | Kaggle                                                   |
| Time Period             | October 2019 and November 2019                           |
| Domain                  | Multi-category ecommerce store                           |
| Event Types             | View, Cart, Purchase                                     |
| Raw Scale               | 42M+ October rows and 67M+ November rows                 |
| Working Sample          | 5M stratified rows per month                             |
| Final Combined Sessions | 6.5M+                                                    |
| Final Users             | 3.1M+                                                    |
| Final Products          | 268K+                                                    |
| Brands Analyzed         | 726                                                      |
| Combined Revenue        | $47.38M                                                  |

Original event columns included:

| Column          | Description                  |
| --------------- | ---------------------------- |
| `event_time`    | Timestamp of user event      |
| `event_type`    | View, cart, or purchase      |
| `product_id`    | Product identifier           |
| `category_id`   | Encoded category             |
| `category_code` | Human-readable category path |
| `brand`         | Product brand                |
| `price`         | Product price                |
| `user_id`       | User identifier              |
| `user_session`  | Session identifier           |

Additional columns created during cleaning:

| Column        | Purpose                         |
| ------------- | ------------------------------- |
| `date`        | Date-level analysis             |
| `hour`        | Hourly trend analysis           |
| `day_of_week` | Day-of-week behavior            |
| `week_number` | Weekly trend analysis           |
| `month`       | October / November comparison   |
| `category_l1` | Top-level category              |
| `category_l2` | Sub-category                    |
| `price_tier`  | Budget / Mid / Premium / Luxury |

---

## The Real Data Challenge

The original dataset was too large to process directly in a normal free notebook environment.

The raw files contained tens of millions of rows and required more memory than available in a standard notebook workflow. This became one of the most important learning parts of the project.

Instead of randomly reducing the data, I used **stratified sampling by `event_type`**.

This preserved the original behavior distribution of:

```text
Views
Carts
Purchases
```

That was important because a random or careless sample could destroy the funnel structure and make conversion analysis unreliable.

### Memory Optimization

To make the project workable, I applied:

* stratified sampling,
* price filtering,
* null handling,
* datatype optimization,
* category conversion,
* integer downcasting,
* float downcasting,
* session-level aggregation,
* BI-ready summary exports.

Memory was reduced from approximately:

```text
2.94 GB → 0.84 GB
```

This was around a **71% memory reduction**.

This project taught an important real-world lesson:

> Data analysis is not only about charts and KPIs. It also requires understanding memory, data volume, sampling strategy, and efficient processing.

---

## Tools Used

| Tool            | Purpose                                 |
| --------------- | --------------------------------------- |
| Python          | Data cleaning, feature engineering, EDA |
| Pandas          | Data manipulation                       |
| DuckDB SQL      | SQL analysis inside Kaggle Notebook     |
| Kaggle Notebook | Processing large ecommerce files        |
| Power BI        | Dashboard design and storytelling       |
| Power Query     | Data loading and model preparation      |
| GitHub          | Project packaging and documentation     |

---

## Project Workflow

```text
Raw Kaggle Data
        ↓
Python Cleaning & Feature Engineering
        ↓
Stratified Sampling
        ↓
Session, Product, User, Brand, Category Tables
        ↓
DuckDB SQL Analysis
        ↓
BI-ready CSV Exports
        ↓
Power BI Dashboard
        ↓
Business Insights & Recommendations
```

---

## Final Data Tables Created

### Combined BI Tables

| Table                      | Purpose                                       |
| -------------------------- | --------------------------------------------- |
| `combined_session_summary` | Session-level funnel and revenue analysis     |
| `combined_dim_product`     | Product-level ranking and conversion analysis |
| `combined_dim_user`        | User segmentation and value analysis          |
| `combined_dim_brand`       | Brand-level revenue and conversion analysis   |
| `combined_dim_category`    | Category-level discovery analysis             |

### BI-ready Export Tables

| BI Export                               | Used For                                       |
| --------------------------------------- | ---------------------------------------------- |
| `bi_executive_kpis.csv`                 | Main KPI cards                                 |
| `bi_discovery_funnel.csv`               | Product View → Cart → Purchase funnel          |
| `bi_funnel_rates.csv`                   | Funnel rates and drop-offs                     |
| `bi_daily_trend.csv`                    | Daily revenue and conversion trends            |
| `bi_day_of_week_performance.csv`        | Day-wise ecommerce performance                 |
| `bi_category_performance.csv`           | Category revenue and conversion                |
| `bi_brand_performance.csv`              | Brand performance                              |
| `bi_product_ranking.csv`                | Product-level ranking KPIs                     |
| `bi_product_ranking_classification.csv` | Product ranking segments                       |
| `bi_hidden_gems.csv`                    | Underexposed high-converting products          |
| `bi_high_visibility_low_conversion.csv` | Products with high traffic but weak conversion |
| `bi_user_segment_performance.csv`       | User segment analysis                          |
| `bi_high_value_users.csv`               | Top high-value users                           |
| `bi_mom_kpi_change.csv`                 | October vs November KPI comparison             |
| `bi_category_mom_change.csv`            | Category month-over-month analysis             |
| `bi_brand_mom_change.csv`               | Brand month-over-month analysis                |

---

## Dashboard Pages

The Power BI report contains the following pages:

### 1. Home

A branded landing page for the DiscoverIQ analytics platform.

### 2. Executive Overview

Shows high-level ecommerce performance:

* total revenue,
* total sessions,
* total users,
* conversion rate,
* cart abandonment,
* revenue by month,
* funnel overview,
* top categories,
* top brands.

### 3. Product Discovery Funnel

Analyzes the ecommerce journey:

```text
Product View → Add to Cart → Purchase
```

Key focus:

* view-to-cart rate,
* cart-to-purchase rate,
* final conversion,
* drop-off points,
* daily revenue trend,
* day-of-week behavior.

### 4. Product Ranking Analytics

Identifies product ranking opportunities:

* winner products,
* hidden gems,
* high-visibility low-conversion products,
* low-priority products.

This page simulates product ranking intelligence by comparing product visibility with conversion quality.

### 5. Category & Brand Performance

Analyzes business performance by:

* category,
* brand,
* revenue,
* conversion,
* cart abandonment,
* month-over-month change.

### 6. User Segmentation & Personalization

Analyzes user behavior by segment:

* new users,
* returning users,
* loyal users,
* high-value users,
* revenue per user,
* sessions per user,
* purchases per user.

---

## Key Metrics

| Metric                    |   Value |
| ------------------------- | ------: |
| Total Events Analyzed     |   9.97M |
| Combined Sessions         |   6.55M |
| Combined Users            |   3.10M |
| Unique Products           |   268K+ |
| Brands Analyzed           |     726 |
| Combined Revenue          | $47.38M |
| October Revenue           | $27.02M |
| November Revenue          | $20.36M |
| Revenue Change            | -$6.66M |
| October Conversion Rate   |   2.82% |
| November Conversion Rate  |   2.05% |
| October Cart Abandonment  |  13.68% |
| November Cart Abandonment |  67.73% |

---

## Key Findings

### 1. More Traffic Did Not Mean More Revenue

November had more sessions and more users than October.

However, revenue declined sharply.

| Metric           | October | November |     Change |
| ---------------- | ------: | -------: | ---------: |
| Sessions         |   3.12M |    3.43M |     +9.70% |
| Users            |   1.50M |    1.60M |     +6.89% |
| Revenue          | $27.02M |  $20.36M |    -24.65% |
| Conversion Rate  |   2.82% |    2.05% |  -0.77 pts |
| Cart Abandonment |  13.68% |   67.73% | +54.05 pts |

**Insight:**
November did not fail because users stopped browsing. It failed because users added products to cart but did not complete purchases.

---

### 2. November Improved Product Interest but Lost Purchase Completion

| Funnel Metric         | October | November |
| --------------------- | ------: | -------: |
| View-to-Cart Rate     |   3.27% |    6.35% |
| Cart-to-Purchase Rate |  86.32% |   32.27% |
| Final Conversion      |   2.82% |    2.05% |

**Insight:**
November had stronger early product interest, but cart-to-purchase performance collapsed.

---

### 3. Electronics Drove Revenue but Also the Largest Decline

Electronics was the top revenue category in both months.

However, it also caused the largest revenue drop.

| Category     | October Revenue | November Revenue |  Change |
| ------------ | --------------: | ---------------: | ------: |
| Electronics  |         $20.73M |          $15.14M | -$5.60M |
| Appliances   |          $1.63M |           $1.40M |  -$226K |
| Construction |           $113K |             $87K |   -$26K |

**Insight:**
Electronics had stable discovery volume but fewer purchases and higher abandonment in November.

---

### 4. Apple and Samsung Led Revenue but Declined in November

| Brand   | October Revenue | November Revenue |  Change |
| ------- | --------------: | ---------------: | ------: |
| Apple   |         $13.00M |           $9.40M | -$3.60M |
| Samsung |          $5.49M |           $4.04M | -$1.45M |
| Xiaomi  |          $1.09M |            $834K |  -$251K |

**Insight:**
Top brands still generated the most revenue, but their conversion rates dropped and cart abandonment increased.

---

### 5. Hidden-Gem Products Were Identified

Hidden gems were defined as products with:

```text
20–200 views
conversion rate >= 3%
purchases >= 3
```

These products had limited visibility but strong conversion.

**Insight:**
Hidden-gem products should be promoted higher in ranking, recommendations, or product discovery modules.

---

### 6. High-Visibility Low-Conversion Products Were Identified

These products had:

```text
1,000+ views
conversion rate < 1%
less than 10 purchases
```

**Insight:**
These products were being discovered but not purchased. They should be investigated for pricing, product quality, relevance, image quality, or ranking issues.

---

### 7. Loyal Users Had the Highest Revenue per User

| Segment   | October Revenue/User | November Revenue/User |
| --------- | -------------------: | --------------------: |
| New       |                $6.64 |                 $5.55 |
| Returning |               $23.06 |                $16.90 |
| Loyal     |              $105.71 |                $55.92 |

**Insight:**
Loyal users were the highest-value segment, but their spending dropped significantly in November. This suggests a need for personalized offers, urgency signals, or retention-focused recommendations.

---

## Constructor.io Alignment

This project maps directly to ecommerce product discovery use cases:

| Project Finding                   | Product Discovery Use Case                  |
| --------------------------------- | ------------------------------------------- |
| View-to-cart drop-off             | Search and ranking optimization             |
| Hidden-gem products               | Boost underexposed high-converting products |
| High-view low-conversion products | Searchandising and ranking investigation    |
| Category-level drop-offs          | Category page optimization                  |
| Brand conversion gaps             | Brand-level merchandising strategy          |
| Cart abandonment spike            | Urgency signals and checkout nudges         |
| Loyal user spend decline          | Personalization and retention               |
| Co-purchase patterns              | Recommendation systems                      |

This makes DiscoverIQ relevant to roles involving:

* ecommerce analytics,
* product analytics,
* data analysis,
* business intelligence,
* conversion optimization,
* search and recommendation analytics.

---

## Repository Structure

```text
discoveriq-ecommerce-product-discovery-analytics/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── docs/
│   ├── project_overview.md
│   ├── business_problem.md
│   ├── data_dictionary.md
│   ├── dashboard_pages.md
│   ├── insights_summary.md
│   ├── methodology.md
│   ├── limitations.md
│   └── constructor_alignment.md
│
├── notebooks/
│   ├── 01_data_cleaning_feature_engineering.ipynb
│   ├── 02_october_analysis.ipynb
│   ├── 03_november_analysis.ipynb
│   ├── 04_combined_analysis.ipynb
│   └── 05_sql_bi_exports_duckdb.ipynb
│
├── sql/
│   ├── 01_validation_queries.sql
│   ├── 02_executive_kpis.sql
│   ├── 03_funnel_analysis.sql
│   ├── 04_category_brand_analysis.sql
│   ├── 05_product_ranking_analysis.sql
│   ├── 06_user_segmentation.sql
│   └── 07_month_over_month_analysis.sql
│
├── powerbi/
│   ├── DiscoverIQ_Ecommerce_Analytics.pbix
│   ├── DiscoverIQ_VisualsOnly_NoBackground.json
│   └── dashboard_screenshots/
│       ├── 01_home.png
│       ├── 02_executive_overview.png
│       ├── 03_product_discovery_funnel.png
│       ├── 04_product_ranking_analytics.png
│       ├── 05_category_brand_performance.png
│       └── 06_user_segmentation.png
│
├── data/
│   ├── README.md
│   └── sample/
│       ├── sample_bi_executive_kpis.csv
│       ├── sample_bi_funnel_rates.csv
│       └── sample_bi_category_performance.csv
│
├── reports/
│   ├── executive_summary.md
│   └── DiscoverIQ_Project_Report.pdf
│
└── assets/
    ├── logo/
    │   └── discoveriq_logo.png
    └── images/
        ├── dashboard_cover.png
        └── architecture.png
```

---

## How to Reproduce This Project

### 1. Download Dataset

Download the REES46 Ecommerce Behavior Dataset from Kaggle:

```text
mkechinov/ecommerce-behavior-data-from-multi-category-store
```

### 2. Run Notebooks

Run the notebooks in order:

```text
01_data_cleaning_feature_engineering.ipynb
02_october_analysis.ipynb
03_november_analysis.ipynb
04_combined_analysis.ipynb
05_sql_bi_exports_duckdb.ipynb
```

### 3. Generate BI-ready Tables

The DuckDB SQL notebook creates the BI export files used in Power BI.

### 4. Open Power BI Report

Open:

```text
powerbi/DiscoverIQ_Ecommerce_Analytics.pbix
```

If needed, update the data source paths to point to your local BI export folder.

---

## Dashboard Preview

Add screenshots here:

```markdown
![Home](powerbi/dashboard_screenshots/01_home.png)

![Executive Overview](powerbi/dashboard_screenshots/02_executive_overview.png)

![Product Discovery Funnel](powerbi/dashboard_screenshots/03_product_discovery_funnel.png)

![Product Ranking Analytics](powerbi/dashboard_screenshots/04_product_ranking_analytics.png)

![Category & Brand Performance](powerbi/dashboard_screenshots/05_category_brand_performance.png)

![User Segmentation](powerbi/dashboard_screenshots/06_user_segmentation.png)
```

---

## Limitations

This project uses public ecommerce event data and has some limitations:

1. The dataset does not include real search query text.
2. Search analytics are inferred through product discovery behavior, not actual query-level search logs.
3. Recommendation analytics are simulated through co-purchase and product behavior patterns.
4. Stratified sampling was used because the full dataset was too large for free notebook memory limits.
5. Some session-level anomalies can occur because sampling may split events from the same session.
6. Revenue and behavior patterns are from 2019 and may not reflect current ecommerce behavior.

---

## Future Improvements

Future versions of this project could include:

* search query simulation,
* query intent classification,
* product recommendation model,
* market basket analysis,
* customer lifetime value prediction,
* churn prediction,
* ranking score model,
* Streamlit dashboard version,
* live database pipeline,
* incremental refresh in Power BI.

---

## What This Project Demonstrates

This project demonstrates skills in:

* handling large ecommerce datasets,
* memory-aware data processing,
* Python-based cleaning and feature engineering,
* SQL-based analytics using DuckDB,
* funnel analysis,
* product analytics,
* user segmentation,
* ranking opportunity detection,
* business insight generation,
* Power BI dashboard design,
* ecommerce product discovery thinking.

---

## Project Positioning

DiscoverIQ is a portfolio project designed to show how data analytics can support ecommerce product discovery decisions.

It connects raw user behavior data to business actions such as:

* improving ranking,
* reducing cart abandonment,
* promoting hidden gems,
* investigating weak products,
* optimizing category and brand performance,
* and personalizing experiences for high-value users.

---

## Author

**Piyush Kumar**

Data Analyst Portfolio Project
Focused on Ecommerce Analytics, Product Discovery, SQL, Python, and Power BI
