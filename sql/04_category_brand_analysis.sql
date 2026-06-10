```sql id="etwmcb"
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 04_category_brand_analysis.sql
Purpose:
    Create SQL outputs for category and brand performance analysis.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Main Outputs:
    bi_category_performance
    bi_brand_performance
    bi_category_mom_change
    bi_brand_mom_change

Business Question:
    Which categories and brands drive revenue, and which ones caused the
    biggest performance decline between October and November?
===============================================================================
*/


/*=============================================================================
1. Category Performance by Month
=============================================================================*/

SELECT
    month,
    category_l1,

    SUM(view_sessions) AS view_sessions,
    SUM(cart_sessions) AS cart_sessions,
    SUM(purchase_sessions) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(cart_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(cart_sessions) - SUM(purchase_sessions)) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(SUM(view_sessions), 0),
        2
    ) AS revenue_per_view

FROM combined_dim_category

GROUP BY
    month,
    category_l1

ORDER BY
    month,
    total_revenue DESC;


/*=============================================================================
2. Optional: Create BI export table for category performance
=============================================================================*/

CREATE OR REPLACE TABLE bi_category_performance AS

SELECT
    month,
    category_l1,

    SUM(view_sessions) AS view_sessions,
    SUM(cart_sessions) AS cart_sessions,
    SUM(purchase_sessions) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(cart_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(cart_sessions) - SUM(purchase_sessions)) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(SUM(view_sessions), 0),
        2
    ) AS revenue_per_view

FROM combined_dim_category

GROUP BY
    month,
    category_l1;


/*=============================================================================
3. Validate category performance output
=============================================================================*/

SELECT *
FROM bi_category_performance
ORDER BY
    month,
    total_revenue DESC;


/*=============================================================================
4. Top Revenue Categories by Month
=============================================================================*/

WITH ranked_categories AS (
    SELECT
        month,
        category_l1,
        total_revenue,
        conversion_rate,
        cart_abandonment_pct,

        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM bi_category_performance
)

SELECT
    month,
    revenue_rank,
    category_l1,
    total_revenue,
    conversion_rate,
    cart_abandonment_pct
FROM ranked_categories
WHERE revenue_rank <= 10
ORDER BY
    month,
    revenue_rank;


/*=============================================================================
5. Brand Performance by Month
=============================================================================*/

SELECT
    month,
    brand,

    SUM(view_sessions) AS view_sessions,
    SUM(cart_sessions) AS cart_sessions,
    SUM(purchase_sessions) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(cart_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(cart_sessions) - SUM(purchase_sessions)) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(SUM(view_sessions), 0),
        2
    ) AS revenue_per_view

FROM combined_dim_brand

GROUP BY
    month,
    brand

ORDER BY
    month,
    total_revenue DESC;


/*=============================================================================
6. Optional: Create BI export table for brand performance
=============================================================================*/

CREATE OR REPLACE TABLE bi_brand_performance AS

SELECT
    month,
    brand,

    SUM(view_sessions) AS view_sessions,
    SUM(cart_sessions) AS cart_sessions,
    SUM(purchase_sessions) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(cart_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(cart_sessions) - SUM(purchase_sessions)) * 100.0 / NULLIF(SUM(cart_sessions), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(SUM(view_sessions), 0),
        2
    ) AS revenue_per_view

FROM combined_dim_brand

GROUP BY
    month,
    brand;


/*=============================================================================
7. Validate brand performance output
=============================================================================*/

SELECT *
FROM bi_brand_performance
ORDER BY
    month,
    total_revenue DESC
LIMIT 50;


/*=============================================================================
8. Top Revenue Brands by Month
=============================================================================*/

WITH ranked_brands AS (
    SELECT
        month,
        brand,
        total_revenue,
        conversion_rate,
        cart_abandonment_pct,

        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM bi_brand_performance
)

SELECT
    month,
    revenue_rank,
    brand,
    total_revenue,
    conversion_rate,
    cart_abandonment_pct
FROM ranked_brands
WHERE revenue_rank <= 10
ORDER BY
    month,
    revenue_rank;


/*=============================================================================
9. Category Month-over-Month Change
=============================================================================*/

WITH oct_category AS (
    SELECT
        category_l1,
        view_sessions AS oct_views,
        cart_sessions AS oct_carts,
        purchase_sessions AS oct_purchase_sessions,
        total_revenue AS oct_revenue,
        conversion_rate AS oct_conversion_rate,
        cart_abandonment_pct AS oct_cart_abandonment,
        revenue_per_view AS oct_revenue_per_view
    FROM bi_category_performance
    WHERE month = 'October'
),

nov_category AS (
    SELECT
        category_l1,
        view_sessions AS nov_views,
        cart_sessions AS nov_carts,
        purchase_sessions AS nov_purchase_sessions,
        total_revenue AS nov_revenue,
        conversion_rate AS nov_conversion_rate,
        cart_abandonment_pct AS nov_cart_abandonment,
        revenue_per_view AS nov_revenue_per_view
    FROM bi_category_performance
    WHERE month = 'November'
)

SELECT
    COALESCE(o.category_l1, n.category_l1) AS category_l1,

    COALESCE(o.oct_views, 0) AS oct_views,
    COALESCE(n.nov_views, 0) AS nov_views,
    COALESCE(n.nov_views, 0) - COALESCE(o.oct_views, 0) AS view_change,

    COALESCE(o.oct_purchase_sessions, 0) AS oct_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) AS nov_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) - COALESCE(o.oct_purchase_sessions, 0) AS purchase_change,

    COALESCE(o.oct_revenue, 0) AS oct_revenue,
    COALESCE(n.nov_revenue, 0) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    COALESCE(o.oct_conversion_rate, 0) AS oct_conversion_rate,
    COALESCE(n.nov_conversion_rate, 0) AS nov_conversion_rate,
    ROUND(
        COALESCE(n.nov_conversion_rate, 0) - COALESCE(o.oct_conversion_rate, 0),
        2
    ) AS conversion_rate_change,

    COALESCE(o.oct_cart_abandonment, 0) AS oct_cart_abandonment,
    COALESCE(n.nov_cart_abandonment, 0) AS nov_cart_abandonment,
    ROUND(
        COALESCE(n.nov_cart_abandonment, 0) - COALESCE(o.oct_cart_abandonment, 0),
        2
    ) AS cart_abandonment_change,

    COALESCE(o.oct_revenue_per_view, 0) AS oct_revenue_per_view,
    COALESCE(n.nov_revenue_per_view, 0) AS nov_revenue_per_view,
    ROUND(
        COALESCE(n.nov_revenue_per_view, 0) - COALESCE(o.oct_revenue_per_view, 0),
        2
    ) AS revenue_per_view_change

FROM oct_category o
FULL OUTER JOIN nov_category n
    ON o.category_l1 = n.category_l1

ORDER BY revenue_change ASC;


/*=============================================================================
10. Optional: Create BI export table for category MoM change
=============================================================================*/

CREATE OR REPLACE TABLE bi_category_mom_change AS

WITH oct_category AS (
    SELECT
        category_l1,
        view_sessions AS oct_views,
        cart_sessions AS oct_carts,
        purchase_sessions AS oct_purchase_sessions,
        total_revenue AS oct_revenue,
        conversion_rate AS oct_conversion_rate,
        cart_abandonment_pct AS oct_cart_abandonment,
        revenue_per_view AS oct_revenue_per_view
    FROM bi_category_performance
    WHERE month = 'October'
),

nov_category AS (
    SELECT
        category_l1,
        view_sessions AS nov_views,
        cart_sessions AS nov_carts,
        purchase_sessions AS nov_purchase_sessions,
        total_revenue AS nov_revenue,
        conversion_rate AS nov_conversion_rate,
        cart_abandonment_pct AS nov_cart_abandonment,
        revenue_per_view AS nov_revenue_per_view
    FROM bi_category_performance
    WHERE month = 'November'
)

SELECT
    COALESCE(o.category_l1, n.category_l1) AS category_l1,

    COALESCE(o.oct_views, 0) AS oct_views,
    COALESCE(n.nov_views, 0) AS nov_views,
    COALESCE(n.nov_views, 0) - COALESCE(o.oct_views, 0) AS view_change,

    COALESCE(o.oct_purchase_sessions, 0) AS oct_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) AS nov_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) - COALESCE(o.oct_purchase_sessions, 0) AS purchase_change,

    COALESCE(o.oct_revenue, 0) AS oct_revenue,
    COALESCE(n.nov_revenue, 0) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    COALESCE(o.oct_conversion_rate, 0) AS oct_conversion_rate,
    COALESCE(n.nov_conversion_rate, 0) AS nov_conversion_rate,
    ROUND(
        COALESCE(n.nov_conversion_rate, 0) - COALESCE(o.oct_conversion_rate, 0),
        2
    ) AS conversion_rate_change,

    COALESCE(o.oct_cart_abandonment, 0) AS oct_cart_abandonment,
    COALESCE(n.nov_cart_abandonment, 0) AS nov_cart_abandonment,
    ROUND(
        COALESCE(n.nov_cart_abandonment, 0) - COALESCE(o.oct_cart_abandonment, 0),
        2
    ) AS cart_abandonment_change,

    COALESCE(o.oct_revenue_per_view, 0) AS oct_revenue_per_view,
    COALESCE(n.nov_revenue_per_view, 0) AS nov_revenue_per_view,
    ROUND(
        COALESCE(n.nov_revenue_per_view, 0) - COALESCE(o.oct_revenue_per_view, 0),
        2
    ) AS revenue_per_view_change

FROM oct_category o
FULL OUTER JOIN nov_category n
    ON o.category_l1 = n.category_l1;


/*=============================================================================
11. Validate category MoM output
=============================================================================*/

SELECT *
FROM bi_category_mom_change
ORDER BY revenue_change ASC;


/*=============================================================================
12. Brand Month-over-Month Change
=============================================================================*/

WITH oct_brand AS (
    SELECT
        brand,
        view_sessions AS oct_views,
        cart_sessions AS oct_carts,
        purchase_sessions AS oct_purchase_sessions,
        total_revenue AS oct_revenue,
        conversion_rate AS oct_conversion_rate,
        cart_abandonment_pct AS oct_cart_abandonment,
        revenue_per_view AS oct_revenue_per_view
    FROM bi_brand_performance
    WHERE month = 'October'
),

nov_brand AS (
    SELECT
        brand,
        view_sessions AS nov_views,
        cart_sessions AS nov_carts,
        purchase_sessions AS nov_purchase_sessions,
        total_revenue AS nov_revenue,
        conversion_rate AS nov_conversion_rate,
        cart_abandonment_pct AS nov_cart_abandonment,
        revenue_per_view AS nov_revenue_per_view
    FROM bi_brand_performance
    WHERE month = 'November'
)

SELECT
    COALESCE(o.brand, n.brand) AS brand,

    COALESCE(o.oct_views, 0) AS oct_views,
    COALESCE(n.nov_views, 0) AS nov_views,
    COALESCE(n.nov_views, 0) - COALESCE(o.oct_views, 0) AS view_change,

    COALESCE(o.oct_purchase_sessions, 0) AS oct_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) AS nov_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) - COALESCE(o.oct_purchase_sessions, 0) AS purchase_change,

    COALESCE(o.oct_revenue, 0) AS oct_revenue,
    COALESCE(n.nov_revenue, 0) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    COALESCE(o.oct_conversion_rate, 0) AS oct_conversion_rate,
    COALESCE(n.nov_conversion_rate, 0) AS nov_conversion_rate,
    ROUND(
        COALESCE(n.nov_conversion_rate, 0) - COALESCE(o.oct_conversion_rate, 0),
        2
    ) AS conversion_rate_change,

    COALESCE(o.oct_cart_abandonment, 0) AS oct_cart_abandonment,
    COALESCE(n.nov_cart_abandonment, 0) AS nov_cart_abandonment,
    ROUND(
        COALESCE(n.nov_cart_abandonment, 0) - COALESCE(o.oct_cart_abandonment, 0),
        2
    ) AS cart_abandonment_change,

    COALESCE(o.oct_revenue_per_view, 0) AS oct_revenue_per_view,
    COALESCE(n.nov_revenue_per_view, 0) AS nov_revenue_per_view,
    ROUND(
        COALESCE(n.nov_revenue_per_view, 0) - COALESCE(o.oct_revenue_per_view, 0),
        2
    ) AS revenue_per_view_change

FROM oct_brand o
FULL OUTER JOIN nov_brand n
    ON o.brand = n.brand

ORDER BY revenue_change ASC;


/*=============================================================================
13. Optional: Create BI export table for brand MoM change
=============================================================================*/

CREATE OR REPLACE TABLE bi_brand_mom_change AS

WITH oct_brand AS (
    SELECT
        brand,
        view_sessions AS oct_views,
        cart_sessions AS oct_carts,
        purchase_sessions AS oct_purchase_sessions,
        total_revenue AS oct_revenue,
        conversion_rate AS oct_conversion_rate,
        cart_abandonment_pct AS oct_cart_abandonment,
        revenue_per_view AS oct_revenue_per_view
    FROM bi_brand_performance
    WHERE month = 'October'
),

nov_brand AS (
    SELECT
        brand,
        view_sessions AS nov_views,
        cart_sessions AS nov_carts,
        purchase_sessions AS nov_purchase_sessions,
        total_revenue AS nov_revenue,
        conversion_rate AS nov_conversion_rate,
        cart_abandonment_pct AS nov_cart_abandonment,
        revenue_per_view AS nov_revenue_per_view
    FROM bi_brand_performance
    WHERE month = 'November'
)

SELECT
    COALESCE(o.brand, n.brand) AS brand,

    COALESCE(o.oct_views, 0) AS oct_views,
    COALESCE(n.nov_views, 0) AS nov_views,
    COALESCE(n.nov_views, 0) - COALESCE(o.oct_views, 0) AS view_change,

    COALESCE(o.oct_purchase_sessions, 0) AS oct_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) AS nov_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) - COALESCE(o.oct_purchase_sessions, 0) AS purchase_change,

    COALESCE(o.oct_revenue, 0) AS oct_revenue,
    COALESCE(n.nov_revenue, 0) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    COALESCE(o.oct_conversion_rate, 0) AS oct_conversion_rate,
    COALESCE(n.nov_conversion_rate, 0) AS nov_conversion_rate,
    ROUND(
        COALESCE(n.nov_conversion_rate, 0) - COALESCE(o.oct_conversion_rate, 0),
        2
    ) AS conversion_rate_change,

    COALESCE(o.oct_cart_abandonment, 0) AS oct_cart_abandonment,
    COALESCE(n.nov_cart_abandonment, 0) AS nov_cart_abandonment,
    ROUND(
        COALESCE(n.nov_cart_abandonment, 0) - COALESCE(o.oct_cart_abandonment, 0),
        2
    ) AS cart_abandonment_change,

    COALESCE(o.oct_revenue_per_view, 0) AS oct_revenue_per_view,
    COALESCE(n.nov_revenue_per_view, 0) AS nov_revenue_per_view,
    ROUND(
        COALESCE(n.nov_revenue_per_view, 0) - COALESCE(o.oct_revenue_per_view, 0),
        2
    ) AS revenue_per_view_change

FROM oct_brand o
FULL OUTER JOIN nov_brand n
    ON o.brand = n.brand;


/*=============================================================================
14. Validate brand MoM output
=============================================================================*/

SELECT *
FROM bi_brand_mom_change
ORDER BY revenue_change ASC
LIMIT 50;


/*=============================================================================
15. Biggest revenue-declining brands
=============================================================================*/

SELECT
    brand,
    oct_revenue,
    nov_revenue,
    revenue_change,
    revenue_change_pct,
    oct_conversion_rate,
    nov_conversion_rate,
    conversion_rate_change,
    cart_abandonment_change
FROM bi_brand_mom_change
WHERE revenue_change < 0
ORDER BY revenue_change ASC
LIMIT 20;


/*=============================================================================
16. Biggest revenue-declining categories
=============================================================================*/

SELECT
    category_l1,
    oct_revenue,
    nov_revenue,
    revenue_change,
    revenue_change_pct,
    oct_conversion_rate,
    nov_conversion_rate,
    conversion_rate_change,
    cart_abandonment_change
FROM bi_category_mom_change
WHERE revenue_change < 0
ORDER BY revenue_change ASC;


/*=============================================================================
17. Final category and brand story check
=============================================================================*/

SELECT
    'Top Category' AS insight_type,
    month,
    category_l1 AS name,
    total_revenue,
    conversion_rate,
    cart_abandonment_pct
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY total_revenue DESC
        ) AS rn
    FROM bi_category_performance
) x
WHERE rn = 1

UNION ALL

SELECT
    'Top Brand' AS insight_type,
    month,
    brand AS name,
    total_revenue,
    conversion_rate,
    cart_abandonment_pct
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY total_revenue DESC
        ) AS rn
    FROM bi_brand_performance
) y
WHERE rn = 1

ORDER BY insight_type, month;
```
