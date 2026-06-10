```sql id="a6p4sf"
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 05_product_ranking_analysis.sql
Purpose:
    Create SQL outputs for product-level ranking, hidden-gem detection,
    high-visibility low-conversion products, and price-tier performance.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Main Outputs:
    bi_product_ranking
    bi_product_ranking_classification
    bi_hidden_gems
    bi_high_visibility_low_conversion

Business Question:
    Are the right products getting the right visibility?
===============================================================================
*/


/*=============================================================================
1. Product Ranking Base Table
   This output is used for product-level dashboard visuals.
=============================================================================*/

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,

    ROUND(avg_price, 2) AS avg_price,

    total_views,
    total_carts,
    total_purchases,

    ROUND(
        total_carts * 100.0 / NULLIF(total_views, 0),
        2
    ) AS cart_rate,

    ROUND(
        total_purchases * 100.0 / NULLIF(total_views, 0),
        2
    ) AS conversion_rate,

    ROUND(
        total_purchases * 100.0 / NULLIF(total_carts, 0),
        2
    ) AS cart_to_purchase_rate

FROM combined_dim_product

ORDER BY
    month,
    total_purchases DESC,
    total_views DESC;


/*=============================================================================
2. Optional: Create BI export table for product ranking
=============================================================================*/

CREATE OR REPLACE TABLE bi_product_ranking AS

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,

    ROUND(avg_price, 2) AS avg_price,

    total_views,
    total_carts,
    total_purchases,

    ROUND(
        total_carts * 100.0 / NULLIF(total_views, 0),
        2
    ) AS cart_rate,

    ROUND(
        total_purchases * 100.0 / NULLIF(total_views, 0),
        2
    ) AS conversion_rate,

    ROUND(
        total_purchases * 100.0 / NULLIF(total_carts, 0),
        2
    ) AS cart_to_purchase_rate

FROM combined_dim_product;


/*=============================================================================
3. Validate product ranking output
=============================================================================*/

SELECT *
FROM bi_product_ranking
ORDER BY
    month,
    total_purchases DESC,
    total_views DESC
LIMIT 50;


/*=============================================================================
4. Product Distribution Summary
   Used to understand product visibility and conversion spread.
=============================================================================*/

SELECT
    month,

    COUNT(*) AS total_products,

    ROUND(AVG(total_views), 2) AS avg_views,
    MEDIAN(total_views) AS median_views,

    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_views) AS p75_views,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_views) AS p90_views,

    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate,

    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY conversion_rate) AS p75_conversion_rate,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY conversion_rate) AS p90_conversion_rate,

    SUM(CASE WHEN total_purchases > 0 THEN 1 ELSE 0 END) AS products_with_purchase,
    SUM(CASE WHEN total_purchases >= 5 THEN 1 ELSE 0 END) AS products_with_5plus_purchases

FROM bi_product_ranking

GROUP BY month

ORDER BY month;


/*=============================================================================
5. Product Ranking Classification
   Classifies products into business action groups.

   Segment Logic:
   - Winner Product:
       high visibility and strong conversion
   - Hidden Gem - Promote Higher:
       lower visibility but strong conversion
   - High Visibility Low Conversion - Investigate:
       high visibility but weak conversion
   - Low Priority Product:
       lower visibility and weak conversion
=============================================================================*/

CREATE OR REPLACE TABLE bi_product_ranking_classification AS

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    cart_rate,
    conversion_rate,
    cart_to_purchase_rate,

    CASE
        WHEN total_views >= 1000
             AND conversion_rate >= 3
             AND total_purchases >= 10
            THEN 'Winner Product'

        WHEN total_views BETWEEN 20 AND 200
             AND conversion_rate >= 3
             AND total_purchases >= 3
            THEN 'Hidden Gem - Promote Higher'

        WHEN total_views >= 1000
             AND conversion_rate < 1
             AND total_purchases < 10
            THEN 'High Visibility Low Conversion - Investigate'

        ELSE 'Low Priority Product'
    END AS product_ranking_segment

FROM bi_product_ranking;


/*=============================================================================
6. Validate product ranking classification
=============================================================================*/

SELECT
    month,
    product_ranking_segment,
    COUNT(*) AS product_count,
    SUM(total_views) AS total_views,
    SUM(total_purchases) AS total_purchases,
    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate
FROM bi_product_ranking_classification
GROUP BY
    month,
    product_ranking_segment
ORDER BY
    month,
    product_count DESC;


/*=============================================================================
7. Winner Products
   Products with strong visibility and strong conversion.
=============================================================================*/

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,
    total_views,
    total_carts,
    total_purchases,
    conversion_rate,
    cart_to_purchase_rate,
    product_ranking_segment
FROM bi_product_ranking_classification
WHERE product_ranking_segment = 'Winner Product'
ORDER BY
    month,
    total_purchases DESC,
    conversion_rate DESC
LIMIT 100;


/*=============================================================================
8. Hidden Gems
   Underexposed products with strong conversion.

   Logic:
       total_views between 20 and 200
       conversion_rate >= 3%
       total_purchases >= 3
=============================================================================*/

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    conversion_rate,
    cart_to_purchase_rate,

    'Promote higher in ranking, recommendations, or category placement' AS recommendation

FROM bi_product_ranking

WHERE total_views BETWEEN 20 AND 200
  AND conversion_rate >= 3
  AND total_purchases >= 3

ORDER BY
    month,
    conversion_rate DESC,
    total_purchases DESC;


/*=============================================================================
9. Optional: Create BI export table for hidden gems
=============================================================================*/

CREATE OR REPLACE TABLE bi_hidden_gems AS

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    conversion_rate,
    cart_to_purchase_rate,

    'Promote higher in ranking, recommendations, or category placement' AS recommendation

FROM bi_product_ranking

WHERE total_views BETWEEN 20 AND 200
  AND conversion_rate >= 3
  AND total_purchases >= 3;


/*=============================================================================
10. Validate hidden gems
=============================================================================*/

SELECT *
FROM bi_hidden_gems
ORDER BY
    month,
    conversion_rate DESC,
    total_purchases DESC
LIMIT 50;


/*=============================================================================
11. Hidden Gem Count by Month
=============================================================================*/

SELECT
    month,
    COUNT(*) AS hidden_gem_products,
    SUM(total_views) AS hidden_gem_views,
    SUM(total_purchases) AS hidden_gem_purchases,
    ROUND(AVG(conversion_rate), 2) AS avg_hidden_gem_conversion
FROM bi_hidden_gems
GROUP BY month
ORDER BY month;


/*=============================================================================
12. High Visibility Low Conversion Products
   Products getting strong visibility but weak purchase conversion.

   Logic:
       total_views >= 1,000
       conversion_rate < 1%
       total_purchases < 10
=============================================================================*/

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    conversion_rate,
    cart_rate,
    cart_to_purchase_rate,

    'Investigate ranking, price, product content, relevance, or product-page quality' AS recommendation

FROM bi_product_ranking

WHERE total_views >= 1000
  AND conversion_rate < 1
  AND total_purchases < 10

ORDER BY
    month,
    total_views DESC,
    conversion_rate ASC;


/*=============================================================================
13. Optional: Create BI export table for high visibility low conversion products
=============================================================================*/

CREATE OR REPLACE TABLE bi_high_visibility_low_conversion AS

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    conversion_rate,
    cart_rate,
    cart_to_purchase_rate,

    'Investigate ranking, price, product content, relevance, or product-page quality' AS recommendation

FROM bi_product_ranking

WHERE total_views >= 1000
  AND conversion_rate < 1
  AND total_purchases < 10;


/*=============================================================================
14. Validate high visibility low conversion products
=============================================================================*/

SELECT *
FROM bi_high_visibility_low_conversion
ORDER BY
    month,
    total_views DESC,
    conversion_rate ASC
LIMIT 50;


/*=============================================================================
15. High Visibility Low Conversion Count by Month
=============================================================================*/

SELECT
    month,
    COUNT(*) AS weak_high_visibility_products,
    SUM(total_views) AS weak_product_views,
    SUM(total_purchases) AS weak_product_purchases,
    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate
FROM bi_high_visibility_low_conversion
GROUP BY month
ORDER BY month;


/*=============================================================================
16. Top Products by Purchase Count
=============================================================================*/

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    conversion_rate,
    cart_to_purchase_rate

FROM bi_product_ranking

WHERE total_purchases > 0

ORDER BY
    month,
    total_purchases DESC,
    conversion_rate DESC

LIMIT 100;


/*=============================================================================
17. Top Products by Revenue Proxy
   Note:
       Product-level table does not store total product revenue directly.
       Revenue proxy = total_purchases * avg_price.
=============================================================================*/

SELECT
    month,
    product_id,
    brand,
    category_l1,
    category_l2,
    price_tier,
    avg_price,

    total_views,
    total_carts,
    total_purchases,

    ROUND(total_purchases * avg_price, 2) AS estimated_product_revenue,

    conversion_rate

FROM bi_product_ranking

WHERE total_purchases > 0

ORDER BY
    month,
    estimated_product_revenue DESC

LIMIT 100;


/*=============================================================================
18. Price Tier Performance
=============================================================================*/

SELECT
    month,
    price_tier,

    COUNT(*) AS product_count,

    SUM(total_views) AS total_views,
    SUM(total_carts) AS total_carts,
    SUM(total_purchases) AS total_purchases,

    ROUND(AVG(avg_price), 2) AS avg_price,

    ROUND(
        SUM(total_carts) * 100.0 / NULLIF(SUM(total_views), 0),
        2
    ) AS cart_rate,

    ROUND(
        SUM(total_purchases) * 100.0 / NULLIF(SUM(total_views), 0),
        2
    ) AS conversion_rate,

    ROUND(
        SUM(total_purchases) * 100.0 / NULLIF(SUM(total_carts), 0),
        2
    ) AS cart_to_purchase_rate

FROM bi_product_ranking

GROUP BY
    month,
    price_tier

ORDER BY
    month,
    CASE
        WHEN price_tier = 'budget' THEN 1
        WHEN price_tier = 'mid' THEN 2
        WHEN price_tier = 'premium' THEN 3
        WHEN price_tier = 'luxury' THEN 4
        ELSE 5
    END;


/*=============================================================================
19. Product Ranking Segment by Category
=============================================================================*/

SELECT
    month,
    category_l1,
    product_ranking_segment,

    COUNT(*) AS product_count,

    SUM(total_views) AS total_views,
    SUM(total_purchases) AS total_purchases,

    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate

FROM bi_product_ranking_classification

GROUP BY
    month,
    category_l1,
    product_ranking_segment

ORDER BY
    month,
    category_l1,
    product_count DESC;


/*=============================================================================
20. Product Ranking Segment by Brand
=============================================================================*/

SELECT
    month,
    brand,
    product_ranking_segment,

    COUNT(*) AS product_count,

    SUM(total_views) AS total_views,
    SUM(total_purchases) AS total_purchases,

    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate

FROM bi_product_ranking_classification

WHERE brand IS NOT NULL

GROUP BY
    month,
    brand,
    product_ranking_segment

ORDER BY
    month,
    product_count DESC;


/*=============================================================================
21. Final Product Ranking Story Check
=============================================================================*/

SELECT
    month,

    COUNT(*) AS total_products,

    SUM(CASE WHEN product_ranking_segment = 'Winner Product' THEN 1 ELSE 0 END) AS winner_products,

    SUM(CASE WHEN product_ranking_segment = 'Hidden Gem - Promote Higher' THEN 1 ELSE 0 END) AS hidden_gems,

    SUM(CASE WHEN product_ranking_segment = 'High Visibility Low Conversion - Investigate' THEN 1 ELSE 0 END) AS high_visibility_low_conversion_products,

    SUM(CASE WHEN product_ranking_segment = 'Low Priority Product' THEN 1 ELSE 0 END) AS low_priority_products

FROM bi_product_ranking_classification

GROUP BY month

ORDER BY month;
```
