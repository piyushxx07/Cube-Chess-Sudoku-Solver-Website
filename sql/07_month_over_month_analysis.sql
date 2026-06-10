```sql id="tg9hvu"
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 07_month_over_month_analysis.sql
Purpose:
    Create SQL outputs for October vs November comparison across executive KPIs,
    funnel metrics, categories, brands, products, and user segments.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Main Outputs:
    bi_mom_kpi_change
    bi_category_mom_change
    bi_brand_mom_change

Business Question:
    What changed from October to November, and which areas caused the
    biggest performance decline?
===============================================================================
*/


/*=============================================================================
1. Executive KPI Month-over-Month Comparison
=============================================================================*/

CREATE OR REPLACE TABLE bi_mom_kpi_change AS

WITH monthly_kpis AS (
    SELECT
        month,

        COUNT(*) AS total_sessions,
        COUNT(DISTINCT user_id) AS total_users,

        SUM(viewed) AS view_sessions,
        SUM(carted) AS cart_sessions,
        SUM(purchased) AS purchase_sessions,

        SUM(revenue) AS total_revenue,

        SUM(carted) * 100.0 / NULLIF(SUM(viewed), 0) AS view_to_cart_pct,

        SUM(purchased) * 100.0 / NULLIF(SUM(carted), 0) AS cart_to_purchase_pct,

        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0) AS conversion_rate,

        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0) AS cart_abandonment_pct,

        SUM(revenue) / NULLIF(COUNT(*), 0) AS revenue_per_session

    FROM combined_session_summary
    GROUP BY month
),

october AS (
    SELECT *
    FROM monthly_kpis
    WHERE month = 'October'
),

november AS (
    SELECT *
    FROM monthly_kpis
    WHERE month = 'November'
)

SELECT
    o.total_sessions AS oct_sessions,
    n.total_sessions AS nov_sessions,
    n.total_sessions - o.total_sessions AS session_change,
    ROUND(
        (n.total_sessions - o.total_sessions) * 100.0 / NULLIF(o.total_sessions, 0),
        2
    ) AS session_change_pct,

    o.total_users AS oct_users,
    n.total_users AS nov_users,
    n.total_users - o.total_users AS user_change,
    ROUND(
        (n.total_users - o.total_users) * 100.0 / NULLIF(o.total_users, 0),
        2
    ) AS user_change_pct,

    o.view_sessions AS oct_view_sessions,
    n.view_sessions AS nov_view_sessions,
    n.view_sessions - o.view_sessions AS view_session_change,

    o.cart_sessions AS oct_cart_sessions,
    n.cart_sessions AS nov_cart_sessions,
    n.cart_sessions - o.cart_sessions AS cart_session_change,

    o.purchase_sessions AS oct_purchase_sessions,
    n.purchase_sessions AS nov_purchase_sessions,
    n.purchase_sessions - o.purchase_sessions AS purchase_session_change,

    ROUND(o.total_revenue, 2) AS oct_revenue,
    ROUND(n.total_revenue, 2) AS nov_revenue,
    ROUND(n.total_revenue - o.total_revenue, 2) AS revenue_change,
    ROUND(
        (n.total_revenue - o.total_revenue) * 100.0 / NULLIF(o.total_revenue, 0),
        2
    ) AS revenue_change_pct,

    ROUND(o.view_to_cart_pct, 2) AS oct_view_to_cart_pct,
    ROUND(n.view_to_cart_pct, 2) AS nov_view_to_cart_pct,
    ROUND(n.view_to_cart_pct - o.view_to_cart_pct, 2) AS view_to_cart_change,

    ROUND(o.cart_to_purchase_pct, 2) AS oct_cart_to_purchase_pct,
    ROUND(n.cart_to_purchase_pct, 2) AS nov_cart_to_purchase_pct,
    ROUND(n.cart_to_purchase_pct - o.cart_to_purchase_pct, 2) AS cart_to_purchase_change,

    ROUND(o.conversion_rate, 2) AS oct_conversion_rate,
    ROUND(n.conversion_rate, 2) AS nov_conversion_rate,
    ROUND(n.conversion_rate - o.conversion_rate, 2) AS conversion_rate_change,

    ROUND(o.cart_abandonment_pct, 2) AS oct_cart_abandonment_pct,
    ROUND(n.cart_abandonment_pct, 2) AS nov_cart_abandonment_pct,
    ROUND(n.cart_abandonment_pct - o.cart_abandonment_pct, 2) AS cart_abandonment_change,

    ROUND(o.revenue_per_session, 2) AS oct_revenue_per_session,
    ROUND(n.revenue_per_session, 2) AS nov_revenue_per_session,
    ROUND(n.revenue_per_session - o.revenue_per_session, 2) AS revenue_per_session_change

FROM october o
CROSS JOIN november n;


/*=============================================================================
2. Validate Executive MoM Output
=============================================================================*/

SELECT *
FROM bi_mom_kpi_change;


/*=============================================================================
3. Category Month-over-Month Comparison
=============================================================================*/

CREATE OR REPLACE TABLE bi_category_mom_change AS

WITH category_base AS (
    SELECT
        month,
        category_l1,

        SUM(view_sessions) AS view_sessions,
        SUM(cart_sessions) AS cart_sessions,
        SUM(purchase_sessions) AS purchase_sessions,
        SUM(revenue) AS total_revenue,

        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0) AS conversion_rate,

        (SUM(cart_sessions) - SUM(purchase_sessions)) * 100.0 / NULLIF(SUM(cart_sessions), 0) AS cart_abandonment_pct,

        SUM(revenue) / NULLIF(SUM(view_sessions), 0) AS revenue_per_view

    FROM combined_dim_category
    GROUP BY
        month,
        category_l1
),

oct_category AS (
    SELECT
        category_l1,
        view_sessions AS oct_views,
        cart_sessions AS oct_carts,
        purchase_sessions AS oct_purchase_sessions,
        total_revenue AS oct_revenue,
        conversion_rate AS oct_conversion_rate,
        cart_abandonment_pct AS oct_cart_abandonment,
        revenue_per_view AS oct_revenue_per_view
    FROM category_base
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
    FROM category_base
    WHERE month = 'November'
)

SELECT
    COALESCE(o.category_l1, n.category_l1) AS category_l1,

    COALESCE(o.oct_views, 0) AS oct_views,
    COALESCE(n.nov_views, 0) AS nov_views,
    COALESCE(n.nov_views, 0) - COALESCE(o.oct_views, 0) AS view_change,

    COALESCE(o.oct_carts, 0) AS oct_carts,
    COALESCE(n.nov_carts, 0) AS nov_carts,
    COALESCE(n.nov_carts, 0) - COALESCE(o.oct_carts, 0) AS cart_change,

    COALESCE(o.oct_purchase_sessions, 0) AS oct_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) AS nov_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) - COALESCE(o.oct_purchase_sessions, 0) AS purchase_change,

    ROUND(COALESCE(o.oct_revenue, 0), 2) AS oct_revenue,
    ROUND(COALESCE(n.nov_revenue, 0), 2) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    ROUND(COALESCE(o.oct_conversion_rate, 0), 2) AS oct_conversion_rate,
    ROUND(COALESCE(n.nov_conversion_rate, 0), 2) AS nov_conversion_rate,
    ROUND(
        COALESCE(n.nov_conversion_rate, 0) - COALESCE(o.oct_conversion_rate, 0),
        2
    ) AS conversion_rate_change,

    ROUND(COALESCE(o.oct_cart_abandonment, 0), 2) AS oct_cart_abandonment,
    ROUND(COALESCE(n.nov_cart_abandonment, 0), 2) AS nov_cart_abandonment,
    ROUND(
        COALESCE(n.nov_cart_abandonment, 0) - COALESCE(o.oct_cart_abandonment, 0),
        2
    ) AS cart_abandonment_change,

    ROUND(COALESCE(o.oct_revenue_per_view, 0), 2) AS oct_revenue_per_view,
    ROUND(COALESCE(n.nov_revenue_per_view, 0), 2) AS nov_revenue_per_view,
    ROUND(
        COALESCE(n.nov_revenue_per_view, 0) - COALESCE(o.oct_revenue_per_view, 0),
        2
    ) AS revenue_per_view_change

FROM oct_category o
FULL OUTER JOIN nov_category n
    ON o.category_l1 = n.category_l1;


/*=============================================================================
4. Validate Category MoM Output
=============================================================================*/

SELECT *
FROM bi_category_mom_change
ORDER BY revenue_change ASC;


/*=============================================================================
5. Brand Month-over-Month Comparison
=============================================================================*/

CREATE OR REPLACE TABLE bi_brand_mom_change AS

WITH brand_base AS (
    SELECT
        month,
        brand,

        SUM(view_sessions) AS view_sessions,
        SUM(cart_sessions) AS cart_sessions,
        SUM(purchase_sessions) AS purchase_sessions,
        SUM(revenue) AS total_revenue,

        SUM(purchase_sessions) * 100.0 / NULLIF(SUM(view_sessions), 0) AS conversion_rate,

        (SUM(cart_sessions) - SUM(purchase_sessions)) * 100.0 / NULLIF(SUM(cart_sessions), 0) AS cart_abandonment_pct,

        SUM(revenue) / NULLIF(SUM(view_sessions), 0) AS revenue_per_view

    FROM combined_dim_brand
    GROUP BY
        month,
        brand
),

oct_brand AS (
    SELECT
        brand,
        view_sessions AS oct_views,
        cart_sessions AS oct_carts,
        purchase_sessions AS oct_purchase_sessions,
        total_revenue AS oct_revenue,
        conversion_rate AS oct_conversion_rate,
        cart_abandonment_pct AS oct_cart_abandonment,
        revenue_per_view AS oct_revenue_per_view
    FROM brand_base
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
    FROM brand_base
    WHERE month = 'November'
)

SELECT
    COALESCE(o.brand, n.brand) AS brand,

    COALESCE(o.oct_views, 0) AS oct_views,
    COALESCE(n.nov_views, 0) AS nov_views,
    COALESCE(n.nov_views, 0) - COALESCE(o.oct_views, 0) AS view_change,

    COALESCE(o.oct_carts, 0) AS oct_carts,
    COALESCE(n.nov_carts, 0) AS nov_carts,
    COALESCE(n.nov_carts, 0) - COALESCE(o.oct_carts, 0) AS cart_change,

    COALESCE(o.oct_purchase_sessions, 0) AS oct_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) AS nov_purchase_sessions,
    COALESCE(n.nov_purchase_sessions, 0) - COALESCE(o.oct_purchase_sessions, 0) AS purchase_change,

    ROUND(COALESCE(o.oct_revenue, 0), 2) AS oct_revenue,
    ROUND(COALESCE(n.nov_revenue, 0), 2) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    ROUND(COALESCE(o.oct_conversion_rate, 0), 2) AS oct_conversion_rate,
    ROUND(COALESCE(n.nov_conversion_rate, 0), 2) AS nov_conversion_rate,
    ROUND(
        COALESCE(n.nov_conversion_rate, 0) - COALESCE(o.oct_conversion_rate, 0),
        2
    ) AS conversion_rate_change,

    ROUND(COALESCE(o.oct_cart_abandonment, 0), 2) AS oct_cart_abandonment,
    ROUND(COALESCE(n.nov_cart_abandonment, 0), 2) AS nov_cart_abandonment,
    ROUND(
        COALESCE(n.nov_cart_abandonment, 0) - COALESCE(o.oct_cart_abandonment, 0),
        2
    ) AS cart_abandonment_change,

    ROUND(COALESCE(o.oct_revenue_per_view, 0), 2) AS oct_revenue_per_view,
    ROUND(COALESCE(n.nov_revenue_per_view, 0), 2) AS nov_revenue_per_view,
    ROUND(
        COALESCE(n.nov_revenue_per_view, 0) - COALESCE(o.oct_revenue_per_view, 0),
        2
    ) AS revenue_per_view_change

FROM oct_brand o
FULL OUTER JOIN nov_brand n
    ON o.brand = n.brand;


/*=============================================================================
6. Validate Brand MoM Output
=============================================================================*/

SELECT *
FROM bi_brand_mom_change
ORDER BY revenue_change ASC
LIMIT 50;


/*=============================================================================
7. Biggest Revenue Declines by Category
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
    oct_cart_abandonment,
    nov_cart_abandonment,
    cart_abandonment_change
FROM bi_category_mom_change
WHERE revenue_change < 0
ORDER BY revenue_change ASC;


/*=============================================================================
8. Biggest Revenue Declines by Brand
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
    oct_cart_abandonment,
    nov_cart_abandonment,
    cart_abandonment_change
FROM bi_brand_mom_change
WHERE revenue_change < 0
ORDER BY revenue_change ASC
LIMIT 20;


/*=============================================================================
9. Biggest Conversion Rate Declines by Category
=============================================================================*/

SELECT
    category_l1,
    oct_conversion_rate,
    nov_conversion_rate,
    conversion_rate_change,
    oct_revenue,
    nov_revenue,
    revenue_change
FROM bi_category_mom_change
WHERE conversion_rate_change < 0
ORDER BY conversion_rate_change ASC;


/*=============================================================================
10. Biggest Conversion Rate Declines by Brand
=============================================================================*/

SELECT
    brand,
    oct_conversion_rate,
    nov_conversion_rate,
    conversion_rate_change,
    oct_revenue,
    nov_revenue,
    revenue_change
FROM bi_brand_mom_change
WHERE conversion_rate_change < 0
ORDER BY conversion_rate_change ASC
LIMIT 20;


/*=============================================================================
11. Cart Abandonment Spike by Category
=============================================================================*/

SELECT
    category_l1,
    oct_cart_abandonment,
    nov_cart_abandonment,
    cart_abandonment_change,
    revenue_change
FROM bi_category_mom_change
ORDER BY cart_abandonment_change DESC;


/*=============================================================================
12. Cart Abandonment Spike by Brand
=============================================================================*/

SELECT
    brand,
    oct_cart_abandonment,
    nov_cart_abandonment,
    cart_abandonment_change,
    revenue_change
FROM bi_brand_mom_change
ORDER BY cart_abandonment_change DESC
LIMIT 20;


/*=============================================================================
13. User Segment Month-over-Month Comparison
=============================================================================*/

WITH segment_base AS (
    SELECT
        month,
        segment,

        COUNT(DISTINCT user_id) AS total_users,
        SUM(total_sessions) AS total_sessions,
        SUM(total_purchases) AS total_purchases,
        SUM(total_spend) AS total_revenue,

        SUM(total_spend) / NULLIF(COUNT(DISTINCT user_id), 0) AS revenue_per_user,

        SUM(total_sessions) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0) AS sessions_per_user,

        SUM(total_purchases) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0) AS purchases_per_user

    FROM combined_dim_user
    GROUP BY
        month,
        segment
),

oct_segments AS (
    SELECT
        segment,
        total_users AS oct_users,
        total_sessions AS oct_sessions,
        total_purchases AS oct_purchases,
        total_revenue AS oct_revenue,
        revenue_per_user AS oct_revenue_per_user,
        sessions_per_user AS oct_sessions_per_user,
        purchases_per_user AS oct_purchases_per_user
    FROM segment_base
    WHERE month = 'October'
),

nov_segments AS (
    SELECT
        segment,
        total_users AS nov_users,
        total_sessions AS nov_sessions,
        total_purchases AS nov_purchases,
        total_revenue AS nov_revenue,
        revenue_per_user AS nov_revenue_per_user,
        sessions_per_user AS nov_sessions_per_user,
        purchases_per_user AS nov_purchases_per_user
    FROM segment_base
    WHERE month = 'November'
)

SELECT
    COALESCE(o.segment, n.segment) AS segment,

    COALESCE(o.oct_users, 0) AS oct_users,
    COALESCE(n.nov_users, 0) AS nov_users,
    COALESCE(n.nov_users, 0) - COALESCE(o.oct_users, 0) AS user_change,

    ROUND(COALESCE(o.oct_revenue, 0), 2) AS oct_revenue,
    ROUND(COALESCE(n.nov_revenue, 0), 2) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    ROUND(COALESCE(o.oct_revenue_per_user, 0), 2) AS oct_revenue_per_user,
    ROUND(COALESCE(n.nov_revenue_per_user, 0), 2) AS nov_revenue_per_user,
    ROUND(
        COALESCE(n.nov_revenue_per_user, 0) - COALESCE(o.oct_revenue_per_user, 0),
        2
    ) AS revenue_per_user_change,

    ROUND(COALESCE(o.oct_sessions_per_user, 0), 2) AS oct_sessions_per_user,
    ROUND(COALESCE(n.nov_sessions_per_user, 0), 2) AS nov_sessions_per_user,
    ROUND(
        COALESCE(n.nov_sessions_per_user, 0) - COALESCE(o.oct_sessions_per_user, 0),
        2
    ) AS sessions_per_user_change,

    ROUND(COALESCE(o.oct_purchases_per_user, 0), 2) AS oct_purchases_per_user,
    ROUND(COALESCE(n.nov_purchases_per_user, 0), 2) AS nov_purchases_per_user,
    ROUND(
        COALESCE(n.nov_purchases_per_user, 0) - COALESCE(o.oct_purchases_per_user, 0),
        2
    ) AS purchases_per_user_change

FROM oct_segments o
FULL OUTER JOIN nov_segments n
    ON o.segment = n.segment

ORDER BY revenue_change ASC;


/*=============================================================================
14. Product Ranking Segment MoM Summary
=============================================================================*/

WITH product_ranking AS (
    SELECT
        month,
        product_id,
        brand,
        category_l1,
        category_l2,
        price_tier,
        total_views,
        total_carts,
        total_purchases,

        ROUND(
            total_purchases * 100.0 / NULLIF(total_views, 0),
            2
        ) AS conversion_rate,

        CASE
            WHEN total_views >= 1000
                 AND ROUND(total_purchases * 100.0 / NULLIF(total_views, 0), 2) >= 3
                 AND total_purchases >= 10
                THEN 'Winner Product'

            WHEN total_views BETWEEN 20 AND 200
                 AND ROUND(total_purchases * 100.0 / NULLIF(total_views, 0), 2) >= 3
                 AND total_purchases >= 3
                THEN 'Hidden Gem - Promote Higher'

            WHEN total_views >= 1000
                 AND ROUND(total_purchases * 100.0 / NULLIF(total_views, 0), 2) < 1
                 AND total_purchases < 10
                THEN 'High Visibility Low Conversion - Investigate'

            ELSE 'Low Priority Product'
        END AS product_ranking_segment

    FROM combined_dim_product
)

SELECT
    month,
    product_ranking_segment,

    COUNT(*) AS product_count,
    SUM(total_views) AS total_views,
    SUM(total_purchases) AS total_purchases,
    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate

FROM product_ranking

GROUP BY
    month,
    product_ranking_segment

ORDER BY
    month,
    product_count DESC;


/*=============================================================================
15. Final Month-over-Month Business Story
=============================================================================*/

SELECT
    'Executive Summary' AS story_section,

    CASE
        WHEN revenue_change < 0 AND session_change > 0
            THEN 'Traffic increased, but revenue declined. The issue is conversion quality, not traffic volume.'
        WHEN revenue_change > 0 AND session_change > 0
            THEN 'Traffic and revenue both increased.'
        ELSE 'Performance change requires deeper analysis.'
    END AS insight,

    session_change,
    session_change_pct,
    revenue_change,
    revenue_change_pct,
    conversion_rate_change,
    cart_abandonment_change

FROM bi_mom_kpi_change;


/*=============================================================================
16. Final Action Priority Table
=============================================================================*/

SELECT
    1 AS priority_order,
    'Reduce Cart Abandonment' AS action_area,
    'Cart abandonment increased sharply from October to November' AS reason,
    'Use cart recovery, urgency signals, and checkout optimization' AS recommended_action

UNION ALL

SELECT
    2 AS priority_order,
    'Optimize Electronics Category' AS action_area,
    'Electronics caused the largest revenue decline' AS reason,
    'Improve ranking, offers, and product discovery inside electronics' AS recommended_action

UNION ALL

SELECT
    3 AS priority_order,
    'Protect Top Brands' AS action_area,
    'Apple and Samsung remained top brands but declined in November' AS reason,
    'Use personalized brand offers, urgency messaging, and cart recovery' AS recommended_action

UNION ALL

SELECT
    4 AS priority_order,
    'Promote Hidden Gems' AS action_area,
    'Some lower-visibility products convert strongly' AS reason,
    'Boost hidden gems in ranking, recommendations, and category pages' AS recommended_action

UNION ALL

SELECT
    5 AS priority_order,
    'Investigate Weak High-Visibility Products' AS action_area,
    'Some products receive many views but fail to convert' AS reason,
    'Review price, relevance, product content, images, and ranking logic' AS recommended_action

UNION ALL

SELECT
    6 AS priority_order,
    'Personalize for Loyal Users' AS action_area,
    'Loyal users have high value but spending declined in November' AS reason,
    'Use retention offers, early access, and personalized recommendations' AS recommended_action

ORDER BY priority_order;
```
