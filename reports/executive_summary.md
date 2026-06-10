# Executive Summary

## Project Name

**DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics Platform**

## Project Purpose

DiscoverIQ is an ecommerce analytics project built to understand how users move through the product discovery journey:

```text
Product View → Add to Cart → Purchase
```

The project uses the public REES46 ecommerce behavior dataset from Kaggle and analyzes October and November 2019 user behavior.

The goal is to identify:

* where users drop off in the ecommerce funnel,
* why revenue declined despite more traffic,
* which products deserve more visibility,
* which products waste visibility,
* which categories and brands need attention,
* and which user segments should be personalized.

---

## Dataset Summary

The original dataset was very large, with approximately 42M+ October rows and 67M+ November rows. Because the raw files were too large for a normal free notebook workflow, a 5M-row stratified sample was created for each month while preserving the original event-type distribution. This made the analysis possible without destroying the funnel structure.

| Area             | Details                           |
| ---------------- | --------------------------------- |
| Dataset          | REES46 Ecommerce Behavior Dataset |
| Source           | Kaggle                            |
| Period           | October–November 2019             |
| Domain           | Multi-category ecommerce          |
| Events           | View, cart, purchase              |
| Working sample   | 5M rows per month                 |
| Final sessions   | 6.5M+                             |
| Final users      | 3.1M+                             |
| Final products   | 268K+                             |
| Brands analyzed  | 726                               |
| Combined revenue | $47.38M                           |

---

## Tools Used

| Tool            | Purpose                               |
| --------------- | ------------------------------------- |
| Python          | Data cleaning and feature engineering |
| Pandas          | Data manipulation                     |
| DuckDB SQL      | Analytical SQL and BI-ready exports   |
| Kaggle Notebook | Large data processing                 |
| Power BI        | Dashboard development                 |
| GitHub          | Project packaging and documentation   |

---

## Business Problem

The main business problem was:

> November generated more traffic and product interest, but revenue declined because purchase completion became weaker.

This means traffic alone was not the issue.

The real issue was conversion quality, especially the sharp increase in cart abandonment.

---

## Key Executive KPIs

| Metric              | October | November |     Change |
| ------------------- | ------: | -------: | ---------: |
| Sessions            |   3.12M |    3.43M |     +9.70% |
| Users               |   1.50M |    1.60M |     +6.89% |
| Revenue             | $27.02M |  $20.36M |    -24.65% |
| Conversion Rate     |   2.82% |    2.05% |  -0.77 pts |
| Cart Abandonment    |  13.68% |   67.73% | +54.05 pts |
| Revenue per Session |   $8.65 |    $5.94 |     -$2.71 |

---

## Main Finding

November had more sessions and users than October, but revenue dropped by approximately $6.66M.

The biggest reason was the collapse in cart-to-purchase conversion.

Users were not failing to discover products. They were failing to complete purchases after showing interest.

```text
October  → Lower cart activity, stronger purchase completion
November → Higher cart activity, weaker purchase completion
```

---

## Funnel Insight

| Funnel Metric         | October | November |
| --------------------- | ------: | -------: |
| View Sessions         |   3.02M |    3.26M |
| Cart Sessions         |   98.7K |   206.8K |
| Purchase Sessions     |   85.2K |    66.7K |
| View-to-Cart Rate     |   3.27% |    6.35% |
| Cart-to-Purchase Rate |  86.32% |   32.27% |
| Final Conversion      |   2.82% |    2.05% |

## Interpretation

November had stronger early-stage product interest because users added more products to cart.

However, purchase completion dropped sharply.

This suggests that users were browsing and saving products, but delaying or avoiding purchase completion.

Possible reasons include:

* pre-Black-Friday waiting behavior,
* price comparison,
* checkout hesitation,
* weak urgency signals,
* lack of personalized offers,
* cart used like a wishlist.

---

## Category Insight

Electronics was the strongest category by revenue in both months, but it also caused the largest revenue decline.

| Category     | October Revenue | November Revenue |  Change |
| ------------ | --------------: | ---------------: | ------: |
| Electronics  |         $20.73M |          $15.14M | -$5.60M |
| Appliances   |          $1.63M |           $1.40M |  -$226K |
| Construction |           $113K |             $87K |   -$26K |

## Interpretation

Electronics had strong demand and visibility, but users were less likely to complete purchases in November.

This makes electronics the highest-priority category for conversion optimization.

---

## Brand Insight

Apple and Samsung were the top revenue brands, but both declined in November.

| Brand   | October Revenue | November Revenue |  Change |
| ------- | --------------: | ---------------: | ------: |
| Apple   |         $13.00M |           $9.40M | -$3.60M |
| Samsung |          $5.49M |           $4.04M | -$1.45M |
| Xiaomi  |          $1.09M |            $834K |  -$251K |

## Interpretation

Top brands still attracted strong demand, but conversion weakened.

This suggests that brand demand existed, but purchase confidence or purchase timing changed.

---

## Product Ranking Insight

The project classified products into action-based ranking segments:

| Segment                        | Meaning                                | Business Action             |
| ------------------------------ | -------------------------------------- | --------------------------- |
| Winner Product                 | High visibility and strong conversion  | Keep ranking high           |
| Hidden Gem                     | Lower visibility but strong conversion | Promote higher              |
| High Visibility Low Conversion | High visibility but weak conversion    | Investigate or deprioritize |
| Low Priority Product           | Low visibility and weak conversion     | Low focus                   |

## Key Product Insight

Some products received many views but did not convert. These products may be wasting valuable ranking space.

Other products had low visibility but strong conversion. These products are hidden gems and should be promoted higher.

---

## User Segmentation Insight

User segments were analyzed as new, returning, and loyal users.

| Segment   | October Revenue/User | November Revenue/User |
| --------- | -------------------: | --------------------: |
| New       |                $6.64 |                 $5.55 |
| Returning |               $23.06 |                $16.90 |
| Loyal     |              $105.71 |                $55.92 |

## Interpretation

Loyal users generated the highest revenue per user, but their spending dropped sharply in November.

This suggests that even highly engaged users were delaying purchases or waiting for better offers.

---

## Business Recommendations

### 1. Reduce Cart Abandonment

Cart abandonment was the biggest issue in November.

Recommended actions:

* abandoned cart reminders,
* urgency signals,
* price-drop alerts,
* personalized offers,
* checkout simplification,
* delivery and return clarity.

### 2. Optimize Electronics First

Electronics caused the largest revenue decline.

Recommended actions:

* improve electronics ranking,
* promote high-converting electronics products,
* add urgency and offer messaging,
* improve product comparison and product-page content.

### 3. Promote Hidden-Gem Products

Products with low visibility and strong conversion should receive more exposure.

Recommended actions:

* boost in ranking,
* place in recommendation blocks,
* promote on category pages,
* add to personalized product sections.

### 4. Investigate High-Visibility Low-Conversion Products

Products with high views but weak conversion should be reviewed.

Recommended actions:

* check pricing,
* improve images,
* improve descriptions,
* review ranking relevance,
* compare against substitute products.

### 5. Personalize for Loyal and Returning Users

Loyal users are the most valuable segment.

Recommended actions:

* personalized offers,
* early access campaigns,
* loyalty rewards,
* brand-specific recommendations,
* cart recovery flows.

---

## Constructor-Style Alignment

DiscoverIQ is aligned with ecommerce product discovery use cases such as:

| DiscoverIQ Finding                | Product Discovery Use Case                  |
| --------------------------------- | ------------------------------------------- |
| View-to-cart drop-off             | Search and ranking optimization             |
| Hidden gems                       | Boost underexposed high-converting products |
| High-view low-conversion products | Searchandising investigation                |
| Category decline                  | Category page optimization                  |
| Brand conversion gaps             | Brand-level merchandising                   |
| Loyal user behavior               | Personalization                             |
| Co-purchase patterns              | Recommendation opportunities                |
| Cart abandonment                  | Urgency signals and conversion nudges       |

This project is independent and uses public data. It is not an official Constructor.io project or dataset.

---

## Final Conclusion

DiscoverIQ shows that ecommerce performance cannot be judged only by traffic.

November had more users and more sessions, but revenue declined because purchase completion weakened.

The most important business issue was cart abandonment.

The project turns raw ecommerce event data into business decisions for:

* funnel optimization,
* product ranking,
* hidden-gem promotion,
* category optimization,
* brand analysis,
* cart recovery,
* and personalization.

The final output is a portfolio-ready analytics project demonstrating Python, SQL, Power BI, large-data handling, and ecommerce product discovery thinking.
