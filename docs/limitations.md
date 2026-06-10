# Limitations

## Overview

This document explains the limitations of the **DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics Platform** project.

The goal of this project is to analyze ecommerce product discovery, funnel behavior, product ranking opportunities, category and brand performance, and user segmentation using the REES46 ecommerce behavior dataset.

Although the project provides strong business insights, it is important to clearly document the limitations so that the analysis is interpreted correctly.

---

# 1. Dataset Does Not Contain Search Query Data

## Limitation

The dataset contains ecommerce event behavior such as:

```text
view
cart
purchase
```

However, it does not contain actual search query text.

This means the dataset does not show:

* what users searched for,
* search result pages,
* search keywords,
* zero-result searches,
* search refinements,
* autocomplete interactions,
* search ranking positions,
* product impressions from search results.

## Impact

Because of this, the project cannot perform true query-level search analytics.

For example, the project cannot directly answer:

* Which search queries had low conversion?
* Which queries returned zero results?
* Which search terms were abandoned?
* Which search results were clicked first?
* Which products ranked at position 1, 2, or 3?

## How This Project Handles It

Instead of real search-query analytics, this project analyzes **product discovery behavior** using available event data.

The project studies:

* product views,
* add-to-cart behavior,
* purchases,
* product visibility,
* conversion rate,
* hidden gems,
* high-visibility low-conversion products,
* category and brand performance.

This allows the project to simulate product discovery intelligence, but it should not be presented as true search-query analytics.

---

# 2. Recommendation Data Is Not Directly Available

## Limitation

The dataset does not contain recommendation module data.

It does not show:

* which products were recommended,
* recommendation impressions,
* recommendation clicks,
* recommendation position,
* personalized recommendation logic,
* recommendation-driven purchases.

## Impact

The project cannot directly measure recommendation system performance.

For example, it cannot directly calculate:

* recommendation CTR,
* recommendation conversion rate,
* recommendation revenue,
* recommendation uplift,
* personalized recommendation effectiveness.

## How This Project Handles It

The project uses product behavior and co-purchase patterns to infer recommendation opportunities.

For example:

* hidden-gem products may be good recommendation candidates,
* frequently bought together products may support bundle recommendations,
* loyal users may benefit from personalized product suggestions.

These are analytical recommendations, not proof of an existing recommendation engine.

---

# 3. Stratified Sampling Was Required

## Limitation

The original dataset was very large, with tens of millions of rows across October and November.

Because the raw data was too large for a normal free notebook workflow, a working sample was created.

The project used approximately:

```text
5M rows for October
5M rows for November
```

The uploaded project notes mention that the full data was reduced through stratified sampling because of RAM and file-size limitations, while preserving the original event-type distribution.

## Impact

Sampling means the project does not use every single row from the raw dataset.

As a result, the final numbers are based on the working sample and processed summary tables, not the full raw dataset.

## Why This Was Acceptable

A stratified sample was used instead of a simple random sample.

The sampling was done by `event_type`, preserving the distribution of:

```text
view
cart
purchase
```

This was important because the project depends heavily on funnel analysis.

## Learning Value

This was also an important real-world learning point.

The project showed that data analytics is not only about writing queries and building dashboards. It also requires understanding:

* RAM limits,
* large file handling,
* sampling strategy,
* memory optimization,
* data type optimization,
* summary table design.

---

# 4. Row-Level Sampling Can Create Session Artifacts

## Limitation

The sampling was performed at the row level.

In ecommerce data, one user session can contain multiple events:

```text
view → cart → purchase
```

If sampling includes the purchase row but misses the earlier cart row from the same session, the session may look like it purchased without carting.

## Impact

This can create some session-level artifacts, such as:

* purchase sessions greater than cart sessions in some detailed cuts,
* negative cart abandonment in some daily or category-level rows,
* incomplete session journeys,
* distorted cart-to-purchase metrics at very granular levels.

## How This Project Handles It

To reduce the impact:

* analysis focuses mainly on aggregated trends,
* month-level insights are prioritized over highly granular anomalies,
* unreliable category or brand cuts are filtered where needed,
* this limitation is documented clearly,
* the project avoids claiming exact production-level causality.

---

# 5. Cart Abandonment Is Session-Based, Not User-Level

## Limitation

Cart abandonment is calculated using session-level logic:

```text
(cart_sessions - purchase_sessions) / cart_sessions * 100
```

This means the metric checks whether a session had cart activity and purchase activity.

## Impact

A user may add a product to cart in one session and purchase later in another session.

In that case, session-level cart abandonment may overstate abandonment.

## Better Production Approach

In a production ecommerce system, cart abandonment should ideally be tracked using:

* cart ID,
* user ID,
* product ID,
* timestamp sequence,
* cart creation time,
* purchase completion time,
* cross-session tracking.

This dataset does not provide enough cart lifecycle detail for that level of tracking.

---

# 6. Revenue Is Based on Purchase Event Price

## Limitation

Revenue is calculated from purchase event price values.

The dataset does not include full order-level details such as:

* order ID,
* quantity,
* tax,
* discount,
* shipping fee,
* coupon code,
* refund,
* cancellation,
* final paid amount.

## Impact

Revenue in this project should be treated as estimated purchase revenue based on available event prices.

It may not exactly match real accounting revenue.

## Better Production Approach

A production ecommerce revenue model should use order-level transactional data, including:

* final order amount,
* quantity,
* discounts,
* refunds,
* returns,
* shipping,
* tax,
* payment status.

---

# 7. Product Identity Is Limited

## Limitation

The dataset contains `product_id`, brand, category, and price, but does not contain full product catalog information.

Missing product attributes include:

* product name,
* product image,
* product rating,
* review count,
* stock availability,
* discount percentage,
* delivery time,
* product description,
* seller information.

## Impact

The project can identify product performance patterns, but it cannot explain every reason why a product converts or fails.

For example, a product may have low conversion because of:

* poor reviews,
* bad images,
* weak description,
* high price,
* low stock,
* slow delivery,
* poor seller trust.

The dataset does not contain these fields, so these remain hypotheses.

---

# 8. Brand and Category Values Have Missing Data

## Limitation

Some products have missing brand or category values.

These were filled as:

```text
unknown
```

This prevented large data loss, but it also created an `unknown` category or brand group.

## Impact

The `unknown` group can appear in category and brand visuals.

This group is useful for transparency, but it does not represent a real business category.

## Interpretation Rule

`unknown` should be treated as a data-quality group, not a real ecommerce category or brand.

---

# 9. Data Is From 2019

## Limitation

The dataset represents ecommerce behavior from October and November 2019.

## Impact

User behavior, ecommerce trends, mobile adoption, recommendation systems, checkout experience, and promotional strategies may have changed since then.

The project should be interpreted as a historical ecommerce behavior analysis, not a current market benchmark.

## Why It Is Still Useful

The project is still valuable because the analytical problems remain relevant:

* funnel drop-off,
* product visibility,
* conversion quality,
* cart abandonment,
* category performance,
* brand performance,
* user segmentation.

These are still important ecommerce analytics problems today.

---

# 10. Black Friday Interpretation Is an Inference

## Limitation

November behavior appears consistent with pre-Black-Friday browsing and shopping hesitation.

However, the dataset does not explicitly label Black Friday campaigns, promotions, discount events, or marketing activity.

## Impact

The Black Friday explanation should be treated as a business interpretation, not a confirmed fact from campaign data.

## Careful Wording

Use wording such as:

```text
The behavior suggests a possible Black Friday window-shopping pattern.
```

Avoid wording such as:

```text
Black Friday definitely caused the decline.
```

---

# 11. Power BI Uses Summary Tables, Not Raw Events

## Limitation

The Power BI dashboard uses BI-ready summary tables instead of the full raw event table.

## Impact

This improves dashboard speed and usability, but it means users cannot drill down to every individual raw event inside Power BI.

## Why This Was Done

Using raw event-level data directly in Power BI would make the report heavy and slower.

Summary tables were created for:

* better performance,
* cleaner modeling,
* easier visuals,
* focused business analysis.

This is a practical BI design decision.

---

# 12. Percentage Aggregation Needs Care

## Limitation

Percentage fields such as conversion rate and cart abandonment are stored as percentage numbers.

Example:

```text
2.82 means 2.82%, not 0.0282
```

## Impact

If Power BI sums percentage fields across months or categories, the result becomes misleading.

For example, adding October conversion and November conversion together does not create a valid combined conversion rate.

## Correct Approach

Use:

* average for simple visual comparison,
* weighted calculation for more accurate combined metrics,
* DAX measures when building final production-level KPIs.

## Recommended Aggregation

| Field Type          | Recommended Aggregation     |
| ------------------- | --------------------------- |
| Revenue             | Sum                         |
| Sessions            | Sum                         |
| Views               | Sum                         |
| Carts               | Sum                         |
| Purchases           | Sum                         |
| Conversion Rate     | Average or weighted measure |
| Cart Abandonment    | Average or weighted measure |
| Revenue per Session | Average or weighted measure |

---

# 13. Product Ranking Logic Is Rule-Based

## Limitation

Product ranking classifications are based on business rules.

Example:

```text
Hidden Gem = 20 to 200 views + conversion rate >= 3% + purchases >= 3
```

```text
High Visibility Low Conversion = views >= 1,000 + conversion rate < 1% + purchases < 10
```

## Impact

These rules are useful for business analysis, but they are not machine-learning ranking models.

The project does not train a ranking algorithm.

## Better Production Approach

A production ranking model could include:

* product relevance,
* user intent,
* price,
* stock,
* margin,
* reviews,
* click-through rate,
* conversion rate,
* personalization signals,
* seasonality,
* availability,
* historical demand.

---

# 14. User Segmentation Is Simple and Behavior-Based

## Limitation

User segmentation is based mainly on number of sessions.

Example:

| Segment   | Logic        |
| --------- | ------------ |
| New       | 1 session    |
| Returning | 2–5 sessions |
| Loyal     | 6+ sessions  |

## Impact

This is easy to understand and useful for dashboarding, but it is not an advanced customer segmentation model.

It does not include:

* lifetime value prediction,
* RFM scoring,
* churn probability,
* demographic data,
* acquisition channel,
* customer intent,
* loyalty program status.

## Better Production Approach

A stronger segmentation model could include:

* recency,
* frequency,
* monetary value,
* product preferences,
* category affinity,
* churn risk,
* predicted lifetime value.

---

# 15. No Marketing Channel Data

## Limitation

The dataset does not include traffic source or marketing channel.

Missing fields include:

* paid ads,
* organic search,
* email,
* social media,
* direct traffic,
* referral traffic,
* campaign ID,
* UTM parameters.

## Impact

The project cannot explain whether performance changes were caused by marketing channels.

For example, it cannot answer:

* Did paid traffic convert worse?
* Did email users purchase more?
* Did social traffic cause more browsing but fewer purchases?
* Did a campaign drive November traffic?

---

# 16. No Checkout Step Data

## Limitation

The dataset only has view, cart, and purchase events.

It does not contain detailed checkout steps.

Missing checkout events include:

* checkout started,
* address entered,
* payment selected,
* payment failed,
* order confirmed,
* coupon applied,
* shipping selected.

## Impact

The project can identify that cart-to-purchase conversion dropped, but it cannot identify the exact checkout step where users failed.

## Better Production Approach

A production funnel should include:

```text
View → Cart → Checkout Start → Payment → Purchase
```

This would make cart abandonment analysis more accurate.

---

# 17. No Inventory or Stock Data

## Limitation

The dataset does not include product inventory or stock status.

## Impact

The project cannot determine whether weak conversion was caused by:

* out-of-stock products,
* low stock,
* delayed delivery,
* unavailable variants,
* incomplete sizes/colors.

This is especially important for ecommerce ranking and recommendations.

---

# 18. No Profit or Margin Data

## Limitation

The project analyzes revenue, not profit.

The dataset does not include:

* product cost,
* gross margin,
* net margin,
* shipping cost,
* discount cost,
* return cost.

## Impact

A high-revenue product may not be the most profitable product.

For ranking decisions, revenue and conversion are useful but not enough.

## Better Production Approach

A production merchandising model should include margin and profitability.

---

# 19. No Returns or Cancellation Data

## Limitation

The dataset does not include returns, cancellations, or refunds.

## Impact

The project cannot measure post-purchase quality.

For example, a product may have strong purchase conversion but high return rate.

Without return data, the project cannot evaluate true net performance.

---

# 20. Final Interpretation Guideline

The dashboard should be interpreted as a product discovery and conversion analytics project based on available ecommerce event data.

It is strong for analyzing:

* funnel behavior,
* month-over-month change,
* product visibility,
* product conversion,
* category performance,
* brand performance,
* user segment behavior.

It is limited for analyzing:

* true search query behavior,
* recommendation engine performance,
* exact checkout friction,
* marketing attribution,
* inventory impact,
* profit margin,
* returns and cancellations.

---

# Final Note

These limitations do not weaken the project.

They make the project more realistic.

Real-world data is rarely perfect. A strong analyst should not hide data limitations. A strong analyst should explain what the data can support, what it cannot support, and how future versions can improve.

DiscoverIQ is valuable because it turns imperfect but realistic ecommerce behavior data into useful product discovery and conversion insights.
