# Business Problem

## Core Business Problem

Ecommerce platforms do not lose revenue only because users fail to visit the website.

They also lose revenue when users visit, browse products, show interest, add items to cart, but do not complete the purchase.

This project focuses on that exact problem.

The central business question is:

> Why are users discovering products but not converting into buyers?

The project analyzes the ecommerce customer journey from product view to add-to-cart to purchase, then identifies where the funnel breaks and which business areas require action.

```text
Product View → Add to Cart → Purchase
```

---

## Background

In ecommerce, product discovery is one of the most important parts of the customer journey.

A user may enter a site with purchase intent, but if the products shown are not relevant, priced incorrectly, poorly ranked, or not convincing enough, the user may leave without buying.

Even if the user adds a product to cart, revenue is not guaranteed. A cart action only shows interest. The business still needs to convert that interest into a completed purchase.

This makes ecommerce analytics more complex than simply tracking total revenue.

A strong ecommerce analytics system should answer:

* Are users finding products?
* Are users adding products to cart?
* Are users completing purchases?
* Which products receive visibility but fail to convert?
* Which products have strong conversion but low visibility?
* Which categories and brands are driving or losing revenue?
* Which user segments generate the most value?
* Where should the business take action?

DiscoverIQ was built to answer these questions.

---

## Problem Observed in the Dataset

The dataset shows a clear business issue between October and November 2019.

November had more sessions and more users than October, but revenue declined.

| Metric           | October | November | Business Meaning                |
| ---------------- | ------: | -------: | ------------------------------- |
| Sessions         |   3.12M |    3.43M | More traffic in November        |
| Users            |   1.50M |    1.60M | More shoppers visited           |
| Revenue          | $27.02M |  $20.36M | Revenue dropped                 |
| Conversion Rate  |   2.82% |    2.05% | Fewer sessions converted        |
| Cart Abandonment |  13.68% |   67.73% | Many more carts did not convert |

This means the business problem was not lack of traffic.

The real issue was conversion quality.

Users were visiting the store and interacting with products, but many of them were not completing purchases.

---

## Why This Problem Matters

Traffic growth without conversion growth can create a false sense of success.

A company may think performance is improving because:

* sessions are increasing,
* users are increasing,
* product views are increasing,
* cart actions are increasing.

But if purchase completion drops, the business loses revenue despite higher engagement.

This creates three major risks:

### 1. Wasted Product Visibility

Some products may receive many views but generate very few purchases.

This means valuable screen space, ranking position, or recommendation placement is being wasted on products that do not convert.

### 2. Missed Hidden-Gem Products

Some products may have low visibility but strong conversion rates.

These products may be good candidates for higher ranking, better recommendation placement, or promotional visibility.

### 3. Poor Funnel Efficiency

A weak funnel means users are moving through early stages but failing before purchase.

This can happen because of pricing, product relevance, checkout friction, weak urgency, poor trust, or mismatch between user intent and product ranking.

---

## Main Business Questions

This project is designed around the following business questions.

### 1. Executive Performance

* What happened to revenue, sessions, users, conversion, and cart abandonment?
* Did the business improve or decline month over month?
* Was the issue caused by traffic, conversion, or purchase completion?

### 2. Product Discovery Funnel

* How many users viewed products?
* How many added products to cart?
* How many completed purchases?
* Where is the biggest drop-off?
* Did November fail at discovery or at purchase completion?

### 3. Product Ranking Performance

* Which products are high-performing winners?
* Which products are hidden gems?
* Which products have high visibility but poor conversion?
* Which products should be promoted, investigated, or deprioritized?

### 4. Category and Brand Performance

* Which categories generate the most revenue?
* Which brands generate the most revenue?
* Which categories and brands declined from October to November?
* Which business areas caused the largest revenue loss?

### 5. User Segmentation

* Which user segment is most valuable?
* How do new, returning, and loyal users behave differently?
* Which users generate the highest revenue per user?
* Where can personalization improve performance?

---

## Business Impact

The project identifies several areas where an ecommerce business can improve performance.

### Improve Product Ranking

Products with strong conversion but low visibility should be promoted higher.

Products with high visibility but weak conversion should be reviewed for ranking, pricing, product content, or relevance.

### Reduce Cart Abandonment

A large cart abandonment spike shows that users are interested but hesitant to purchase.

Possible business actions include:

* urgency signals,
* price-drop alerts,
* checkout simplification,
* personalized offers,
* abandoned cart recovery,
* trust and delivery messaging.

### Optimize Categories and Brands

Category and brand performance analysis helps identify where revenue is declining.

This can support merchandising decisions, campaign planning, and product placement strategies.

### Personalize User Experience

Different user segments behave differently.

New users may need trust-building and product guidance.

Returning users may need better recommendations.

Loyal users may need personalized offers, early access, or retention-focused experiences.

---

## Product Discovery Perspective

This project treats ecommerce analytics as a product discovery problem.

The goal is not only to measure sales, but to understand whether users are being shown the right products at the right time.

From this perspective:

| Business Problem                | Product Discovery Interpretation                             |
| ------------------------------- | ------------------------------------------------------------ |
| Low view-to-cart rate           | Users are not finding attractive or relevant products        |
| High cart abandonment           | Users are interested but not convinced to purchase           |
| High visibility, low conversion | Product may be over-ranked or poorly positioned              |
| Low visibility, high conversion | Product may be under-ranked                                  |
| Category revenue decline        | Category discovery or purchase experience may be weak        |
| Loyal user spend decline        | Personalization or retention experience may need improvement |

---

## Why DiscoverIQ Was Built

DiscoverIQ was built to convert raw ecommerce event data into business decisions.

Instead of only showing what happened, the dashboard helps explain:

* where users drop off,
* which products deserve attention,
* which products waste visibility,
* which categories and brands are underperforming,
* which users are most valuable,
* and what actions can improve conversion.

The final goal is to support ecommerce teams in making better decisions around:

* product ranking,
* searchandising,
* recommendations,
* category optimization,
* brand strategy,
* cart recovery,
* and personalization.

---

## Final Problem Statement

The ecommerce store had strong product discovery activity, but weak purchase completion.

November showed higher traffic and product interest, yet revenue declined because cart-to-purchase conversion dropped sharply and cart abandonment increased.

The business needs a product discovery analytics system that can identify funnel drop-offs, ranking inefficiencies, hidden-gem products, weak product placements, category and brand issues, and user segments that require personalized action.

DiscoverIQ solves this by transforming raw ecommerce behavior data into a structured Power BI analytics platform for product discovery and conversion optimization.
