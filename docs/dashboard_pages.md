# Dashboard Pages

## Overview

The **DiscoverIQ Power BI Dashboard** is designed as an ecommerce product discovery and conversion analytics report.

The dashboard does not only show sales numbers. It explains how users move through the ecommerce journey, where they drop off, which products should be promoted or investigated, which categories and brands are driving performance, and which user segments create the most value.

The dashboard is structured into six pages:

```text
1. Home
2. Executive Overview
3. Product Discovery Funnel
4. Product Ranking Analytics
5. Category & Brand Performance
6. User Segmentation & Personalization
```

Each page answers a different business question.

---

# 1. Home Page

## Purpose

The Home page acts as the landing page for the DiscoverIQ report.

It introduces the project, explains the dashboard objective, and gives users a clear navigation point before entering the analytical pages.

## Main Goal

To present DiscoverIQ as a product discovery intelligence platform for ecommerce analytics.

## Business Question

> What is this dashboard about, and what business problem does it solve?

## Recommended Components

| Component          | Description                                                                                                            |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| Project title      | DiscoverIQ                                                                                                             |
| Subtitle           | Product Discovery Intelligence for Ecommerce                                                                           |
| Short description  | Explains that the dashboard analyzes product discovery, conversion drop-offs, ranking opportunities, and user behavior |
| Navigation buttons | Links to all main report pages                                                                                         |
| Key project stats  | Sessions, users, products, brands, revenue                                                                             |
| Dataset note       | REES46 Ecommerce Behavior Dataset, October–November 2019                                                               |

## Suggested Text

```text
DiscoverIQ is an ecommerce product discovery analytics platform built to understand how users move from product view to cart to purchase.

The dashboard helps identify funnel drop-offs, hidden-gem products, high-visibility low-conversion products, category and brand performance, and user segment behavior.
```

## Tables Used

This page is mainly a design and navigation page.

Optional tables:

| Table               | Usage                       |
| ------------------- | --------------------------- |
| `bi_executive_kpis` | Summary metrics             |
| `bi_mom_kpi_change` | Month-over-month highlights |

---

# 2. Executive Overview

## Purpose

The Executive Overview page gives a high-level summary of ecommerce performance across October and November.

This page is designed for quick business understanding.

It answers whether the business improved or declined and what metric caused the biggest change.

## Main Business Question

> Did ecommerce performance improve or decline, and why?

## Key Metrics Shown

| KPI              | Description                                                       |
| ---------------- | ----------------------------------------------------------------- |
| Total Revenue    | Total sales generated                                             |
| Total Sessions   | Total browsing sessions                                           |
| Total Users      | Unique users                                                      |
| Conversion Rate  | Percentage of product-view sessions that converted into purchases |
| Cart Abandonment | Percentage of cart sessions that did not convert into purchases   |

## Main Visuals

| Visual                    | Table Used                | Purpose                                      |
| ------------------------- | ------------------------- | -------------------------------------------- |
| KPI cards                 | `bi_executive_kpis`       | Show high-level performance                  |
| Revenue by Month          | `bi_executive_kpis`       | Compare October vs November revenue          |
| Conversion Rate by Month  | `bi_executive_kpis`       | Compare conversion performance               |
| Product Discovery Funnel  | `bi_discovery_funnel`     | Show product view, cart, and purchase stages |
| Top Categories by Revenue | `bi_category_performance` | Identify highest revenue categories          |
| Top Brands by Revenue     | `bi_brand_performance`    | Identify highest revenue brands              |
| Key Insights Card         | Manual text               | Summarize business findings                  |

## Filters / Slicers

| Slicer | Field              |
| ------ | ------------------ |
| Month  | `Dim_Month[month]` |

## Important Power BI Formatting Rules

| Field Type        | Aggregation                              |
| ----------------- | ---------------------------------------- |
| Revenue           | Sum                                      |
| Sessions          | Sum                                      |
| Users             | Sum or distinct count depending on table |
| Conversion Rate   | Average                                  |
| Cart Abandonment  | Average                                  |
| Percentage Fields | Do not multiply by 100 again             |

## Key Insight

November had more traffic than October, but revenue declined.

The main issue was not lack of users. The issue was weaker purchase completion and a sharp increase in cart abandonment.

## Suggested Insight Text

```text
November generated more sessions and users than October, but revenue declined by 24.65%. The key issue was cart abandonment, which increased from 13.68% in October to 67.73% in November. This shows that November's problem was not product discovery volume, but purchase completion after add-to-cart.
```

---

# 3. Product Discovery Funnel

## Purpose

The Product Discovery Funnel page analyzes how users move through the ecommerce funnel.

```text
Product View → Add to Cart → Purchase
```

This page identifies the exact stage where users drop off.

## Main Business Question

> Where does the ecommerce journey break?

## Key Metrics Shown

| Metric                | Description                                               |
| --------------------- | --------------------------------------------------------- |
| View Sessions         | Sessions where users viewed products                      |
| Cart Sessions         | Sessions where users added products to cart               |
| Purchase Sessions     | Sessions where users completed purchase                   |
| View-to-Cart Rate     | Percentage of view sessions that became cart sessions     |
| Cart-to-Purchase Rate | Percentage of cart sessions that became purchase sessions |
| View-to-Purchase Rate | Final conversion from product view to purchase            |
| Drop-off Rate         | Percentage of users lost between funnel stages            |

## Main Visuals

| Visual                        | Table Used                   | Purpose                                       |
| ----------------------------- | ---------------------------- | --------------------------------------------- |
| Funnel chart                  | `bi_discovery_funnel`        | Shows product view, cart, and purchase stages |
| Funnel stage comparison       | `bi_discovery_funnel`        | Compares funnel stages by month               |
| View-to-Cart vs Cart Drop-off | `bi_funnel_rates`            | Shows early interest vs later purchase loss   |
| Daily Revenue Trend           | `bi_daily_trend`             | Shows revenue trend by date                   |
| Daily Conversion Trend        | `bi_daily_trend`             | Shows conversion pattern by date              |
| Day-of-Week Performance       | `bi_day_of_week_performance` | Identifies best and worst days                |

## Filters / Slicers

| Slicer | Field              |
| ------ | ------------------ |
| Month  | `Dim_Month[month]` |

## Tables Used

| Table                        | Purpose                    |
| ---------------------------- | -------------------------- |
| `bi_discovery_funnel`        | Funnel stage counts        |
| `bi_funnel_rates`            | Funnel rates and drop-offs |
| `bi_daily_trend`             | Daily trend analysis       |
| `bi_day_of_week_performance` | Day-level behavior         |

## Key Insight

November improved view-to-cart performance, meaning users were showing product interest.

However, cart-to-purchase performance declined sharply.

This means November’s main issue was not product discovery interest. The issue was purchase completion after cart.

## Suggested Insight Text

```text
November had a higher view-to-cart rate than October, but cart-to-purchase conversion dropped sharply. Users were interested enough to add products to cart, but many did not complete the purchase. This indicates a purchase completion problem rather than a product visibility problem.
```

---

# 4. Product Ranking Analytics

## Purpose

The Product Ranking Analytics page analyzes product-level performance.

It identifies which products deserve more visibility, which products should stay highly ranked, and which high-visibility products are failing to convert.

## Main Business Question

> Are the right products getting the right visibility?

## Product Ranking Logic

Products are classified into four business action segments.

| Segment                                      | Meaning                                           | Business Action             |
| -------------------------------------------- | ------------------------------------------------- | --------------------------- |
| Winner Product                               | High visibility and high conversion               | Keep ranking high           |
| Hidden Gem - Promote Higher                  | Low or moderate visibility with strong conversion | Promote higher              |
| High Visibility Low Conversion - Investigate | High visibility but weak conversion               | Investigate or deprioritize |
| Low Priority Product                         | Low visibility and weak conversion                | Low focus                   |

## Main Visuals

| Visual                                   | Table Used                          | Purpose                                                        |
| ---------------------------------------- | ----------------------------------- | -------------------------------------------------------------- |
| Product Visibility vs Conversion Scatter | `bi_product_ranking_classification` | Shows relationship between views and conversion                |
| Product Segment Distribution             | `bi_product_ranking_classification` | Shows count of products by ranking segment                     |
| Hidden Gems Table                        | `bi_hidden_gems`                    | Lists underexposed high-converting products                    |
| High Visibility Low Conversion Table     | `bi_high_visibility_low_conversion` | Lists products with many views but poor conversion             |
| Top Products by Purchases                | `bi_product_ranking`                | Shows best-selling products                                    |
| Price Tier Performance                   | `bi_product_ranking`                | Compares performance by budget, mid, premium, and luxury tiers |

## Filters / Slicers

| Slicer     | Field                             |
| ---------- | --------------------------------- |
| Month      | `Dim_Month[month]`                |
| Category   | `bi_product_ranking[category_l1]` |
| Brand      | `bi_product_ranking[brand]`       |
| Price Tier | `bi_product_ranking[price_tier]`  |

## Tables Used

| Table                               | Purpose                                           |
| ----------------------------------- | ------------------------------------------------- |
| `bi_product_ranking`                | Product-level views, carts, purchases, conversion |
| `bi_product_ranking_classification` | Product action segments                           |
| `bi_hidden_gems`                    | Underexposed high-converting products             |
| `bi_high_visibility_low_conversion` | High-visibility weak-conversion products          |

## Key Insight

Some products receive high visibility but fail to convert. These products may be over-ranked or may have issues with pricing, product content, relevance, or trust.

Other products have limited visibility but strong conversion. These are hidden gems and should be promoted higher.

## Suggested Insight Text

```text
Product ranking analysis shows that visibility alone is not enough. Some highly viewed products convert poorly, while some lower-visibility products convert strongly. Hidden-gem products should be promoted higher, and high-visibility low-conversion products should be reviewed for ranking, pricing, relevance, or product-page quality.
```

---

# 5. Category & Brand Performance

## Purpose

The Category & Brand Performance page identifies which business areas drive revenue and which areas caused the largest decline.

This page helps understand whether performance issues are category-specific, brand-specific, or site-wide.

## Main Business Question

> Which categories and brands are driving revenue, and which ones are underperforming?

## Key Metrics Shown

| Metric            | Description                             |
| ----------------- | --------------------------------------- |
| Category Revenue  | Revenue by category                     |
| Brand Revenue     | Revenue by brand                        |
| Conversion Rate   | Purchase conversion rate                |
| Cart Abandonment  | Cart sessions that did not convert      |
| Revenue Change    | October vs November revenue movement    |
| Conversion Change | October vs November conversion movement |

## Main Visuals

| Visual                                | Table Used                | Purpose                                      |
| ------------------------------------- | ------------------------- | -------------------------------------------- |
| Revenue by Category                   | `bi_category_performance` | Shows top categories                         |
| Category Conversion Rate              | `bi_category_performance` | Compares category conversion                 |
| Cart Abandonment by Category          | `bi_category_performance` | Finds weak category purchase completion      |
| Category Discovery Efficiency Scatter | `bi_category_performance` | Compares views, conversion, and revenue      |
| Top Brands by Revenue                 | `bi_brand_performance`    | Shows top revenue brands                     |
| Conversion Rate of Top Brands         | `bi_brand_performance`    | Shows brand conversion quality               |
| Biggest Brand Revenue Declines        | `bi_brand_mom_change`     | Identifies brands with largest revenue loss  |
| Category MoM Table                    | `bi_category_mom_change`  | Compares category performance between months |

## Filters / Slicers

| Slicer   | Field                                  |
| -------- | -------------------------------------- |
| Month    | `Dim_Month[month]`                     |
| Category | `bi_category_performance[category_l1]` |
| Brand    | `bi_brand_performance[brand]`          |

## Tables Used

| Table                     | Purpose                                   |
| ------------------------- | ----------------------------------------- |
| `bi_category_performance` | Category revenue, conversion, abandonment |
| `bi_brand_performance`    | Brand revenue, conversion, abandonment    |
| `bi_category_mom_change`  | Category October vs November comparison   |
| `bi_brand_mom_change`     | Brand October vs November comparison      |

## Key Insight

Electronics was the dominant revenue category in both months, but it also caused the largest revenue decline.

Apple and Samsung remained the strongest brands by revenue, but both saw lower revenue and weaker conversion in November.

## Suggested Insight Text

```text
Electronics remained the largest revenue category, but it also caused the biggest revenue decline from October to November. Apple and Samsung continued to lead brand revenue, but both experienced lower purchases and higher cart abandonment in November. This suggests that the issue was not only category demand, but purchase completion and conversion quality.
```

---

# 6. User Segmentation & Personalization

## Purpose

The User Segmentation page analyzes how different types of users behave.

It helps identify which users are most valuable and where personalization can improve performance.

## Main Business Question

> Which user segments generate the most value, and how can personalization improve performance?

## User Segments

| Segment   | Definition   | Meaning                      |
| --------- | ------------ | ---------------------------- |
| New       | 1 session    | First-time or one-time users |
| Returning | 2–5 sessions | Users with repeated activity |
| Loyal     | 6+ sessions  | Highly engaged users         |

## Key Metrics Shown

| Metric             | Description                     |
| ------------------ | ------------------------------- |
| Total Users        | Number of users in each segment |
| Total Revenue      | Revenue generated by segment    |
| Total Purchases    | Purchases generated by segment  |
| Revenue per User   | Average user value              |
| Sessions per User  | Engagement depth                |
| Purchases per User | Purchase depth                  |
| Cart Abandonment   | Purchase friction by segment    |

## Main Visuals

| Visual                              | Table Used                    | Purpose                                       |
| ----------------------------------- | ----------------------------- | --------------------------------------------- |
| Revenue by User Segment             | `bi_user_segment_performance` | Shows total revenue by segment                |
| Revenue per User by Segment         | `bi_user_segment_performance` | Identifies highest-value segment              |
| Segment Value vs Engagement Scatter | `bi_user_segment_performance` | Compares engagement and value                 |
| Purchases by Segment                | `bi_user_segment_performance` | Shows purchase contribution                   |
| User Segment Distribution           | `bi_user_segment_performance` | Shows user mix                                |
| High Value Users Table              | `bi_high_value_users`         | Lists top spending users                      |
| High Value User Behavior Scatter    | `bi_high_value_users`         | Shows relationship between sessions and spend |

## Filters / Slicers

| Slicer  | Field                                  |
| ------- | -------------------------------------- |
| Month   | `Dim_Month[month]`                     |
| Segment | `bi_user_segment_performance[segment]` |

## Tables Used

| Table                         | Purpose                            |
| ----------------------------- | ---------------------------------- |
| `bi_user_segment_performance` | Segment-level revenue and behavior |
| `bi_high_value_users`         | User-level high-value analysis     |

## Key Insight

Loyal users generate the highest revenue per user, proving that repeat engagement is strongly connected with customer value.

However, loyal user spending dropped in November, which suggests that even valuable users may need stronger personalized offers, urgency signals, or retention campaigns.

## Suggested Insight Text

```text
Loyal users generated the highest revenue per user in both October and November, showing that repeat engagement is strongly connected with customer value. Returning users contributed strong total revenue, while new users had lower spend and lower purchase depth. Personalization should focus on converting new users into returning users and protecting high-value loyal users.
```

---

# Dashboard Navigation Design

The dashboard uses a consistent navigation structure across all pages.

Recommended navigation items:

```text
Home
Executive Overview
Product Discovery Funnel
Product Ranking Analytics
Category & Brand Performance
User Segmentation
```

## Navigation Best Practices

* Keep navigation in the same location on all pages.
* Highlight the active page.
* Use short page names.
* Use consistent icon style.
* Keep the month slicer available on analytical pages.
* Avoid overcrowding the canvas.
* Use page-level insights to explain what the visuals mean.

---

# Design Guidelines

## Visual Style

The report uses a modern ecommerce analytics style:

| Element          | Style                                       |
| ---------------- | ------------------------------------------- |
| Background       | Light neutral or custom designed background |
| Cards            | White or soft neutral containers            |
| Borders          | Subtle light gray                           |
| Shadows          | Soft and minimal                            |
| Main accent      | Royal blue                                  |
| Secondary accent | Violet purple                               |
| Warning / issue  | Orange or red                               |
| Positive change  | Green                                       |

## Month Colors

For month comparison visuals:

| Month    | Color         |
| -------- | ------------- |
| October  | Royal Blue    |
| November | Violet Purple |

These colors should be used consistently across month comparison charts.

---

# Power BI Modeling Notes

## Month Slicer

A separate month dimension table should be used:

```text
Dim_Month
```

Recommended values:

```text
October
November
```

Connect `Dim_Month[month]` to the month column in BI tables that support month filtering.

## Aggregation Rules

| Field Type            | Correct Aggregation                      |
| --------------------- | ---------------------------------------- |
| Revenue               | Sum                                      |
| Sessions              | Sum                                      |
| Users                 | Sum or distinct count depending on grain |
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

## Percentage Note

Percentage values are stored as percentage numbers, not decimals.

Example:

```text
2.82 = 2.82%
```

They should not be multiplied by 100 again in Power BI.

---

# Final Dashboard Story

The dashboard tells a complete ecommerce analytics story:

```text
Traffic increased in November
        ↓
Product interest increased
        ↓
Cart activity increased
        ↓
Purchase completion dropped
        ↓
Revenue declined
        ↓
Main issue: cart abandonment and conversion quality
```

This story is supported by executive KPIs, funnel analysis, product ranking analytics, category and brand performance, and user segmentation.

The final report helps ecommerce teams understand not only what happened, but also where to take action.
