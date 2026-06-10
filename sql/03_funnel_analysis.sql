```sql id="qul4ed"
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 03_funnel_analysis.sql
Purpose:
    Create SQL outputs for product discovery funnel analysis.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Main Outputs:
    bi_discovery_funnel
    bi_funnel_rates
    bi_daily_trend
    bi_day_of_week_performance

Business Question:
    Where does the ecommerce journey break between product view,
    add-to-cart, and purchase?
===============================================================================
*/


/*=============================================================================
1. Product Discovery Funnel
   Output used for Power BI funnel chart:
   Product Views → Add to Cart → Purchase
=============================================================================*/

SELECT
    month,
    'Product Views' AS funnel_stage,
    SUM(viewed) AS sessions,
    1 AS stage_order
FROM combined_session_summary
GROUP BY month

UNION ALL

SELECT
    month,
    'Add to Cart' AS funnel_stage,
    SUM(carted) AS sessions,
    2 AS stage_order
FROM combined_session_summary
GROUP BY month

UNION ALL

SELECT
    month,
    'Purchase' AS funnel_stage,
    SUM(purchased) AS sessions,
    3 AS stage_order
FROM combined_session_summary
GROUP BY month

ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END,
    stage_order;


/*=============================================================================
2. Optional: Create BI export table for funnel
=============================================================================*/

CREATE OR REPLACE TABLE bi_discovery_funnel AS

SELECT
    month,
    'Product Views' AS funnel_stage,
    SUM(viewed) AS sessions,
    1 AS stage_order
FROM combined_session_summary
GROUP BY month

UNION ALL

SELECT
    month,
    'Add to Cart' AS funnel_stage,
    SUM(carted) AS sessions,
    2 AS stage_order
FROM combined_session_summary
GROUP BY month

UNION ALL

SELECT
    month,
    'Purchase' AS funnel_stage,
    SUM(purchased) AS sessions,
    3 AS stage_order
FROM combined_session_summary
GROUP BY month;


/*=============================================================================
3. Validate funnel export
=============================================================================*/

SELECT *
FROM bi_discovery_funnel
ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END,
    stage_order;


/*=============================================================================
4. Funnel Rates and Drop-offs
   Output used to compare funnel efficiency by month.
=============================================================================*/

SELECT
    month,

    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    SUM(viewed) - SUM(carted) AS view_to_cart_dropoff,
    SUM(carted) - SUM(purchased) AS cart_to_purchase_dropoff,

    ROUND(
        (SUM(viewed) - SUM(carted)) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_cart_dropoff_pct,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_to_purchase_dropoff_pct,

    ROUND(
        SUM(carted) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_purchase_pct

FROM combined_session_summary

GROUP BY month

ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END;


/*=============================================================================
5. Optional: Create BI export table for funnel rates
=============================================================================*/

CREATE OR REPLACE TABLE bi_funnel_rates AS

SELECT
    month,

    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    SUM(viewed) - SUM(carted) AS view_to_cart_dropoff,
    SUM(carted) - SUM(purchased) AS cart_to_purchase_dropoff,

    ROUND(
        (SUM(viewed) - SUM(carted)) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_cart_dropoff_pct,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_to_purchase_dropoff_pct,

    ROUND(
        SUM(carted) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_purchase_pct

FROM combined_session_summary

GROUP BY month;


/*=============================================================================
6. Validate funnel rates export
=============================================================================*/

SELECT *
FROM bi_funnel_rates
ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END;


/*=============================================================================
7. Daily Funnel and Revenue Trend
   Output used for daily revenue and conversion trend visuals.
=============================================================================*/

SELECT
    date,
    month,
    week_number,
    day_of_week,

    COUNT(*) AS total_sessions,

    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS revenue_per_session

FROM combined_session_summary

GROUP BY
    date,
    month,
    week_number,
    day_of_week

ORDER BY date;


/*=============================================================================
8. Optional: Create BI export table for daily trend
=============================================================================*/

CREATE OR REPLACE TABLE bi_daily_trend AS

SELECT
    date,
    month,
    week_number,
    day_of_week,

    COUNT(*) AS total_sessions,

    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS revenue_per_session

FROM combined_session_summary

GROUP BY
    date,
    month,
    week_number,
    day_of_week;


/*=============================================================================
9. Validate daily trend output
=============================================================================*/

SELECT *
FROM bi_daily_trend
ORDER BY date
LIMIT 20;


/*=============================================================================
10. Day-of-Week Performance
    Output used to identify best and worst shopping days.
=============================================================================*/

SELECT
    month,
    day_of_week,

    COUNT(*) AS total_sessions,

    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS conversion_rate,

    ROUND(
        SUM(carted) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS revenue_per_session

FROM combined_session_summary

GROUP BY
    month,
    day_of_week

ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END,
    CASE
        WHEN day_of_week = 'Monday' THEN 1
        WHEN day_of_week = 'Tuesday' THEN 2
        WHEN day_of_week = 'Wednesday' THEN 3
        WHEN day_of_week = 'Thursday' THEN 4
        WHEN day_of_week = 'Friday' THEN 5
        WHEN day_of_week = 'Saturday' THEN 6
        WHEN day_of_week = 'Sunday' THEN 7
        ELSE 8
    END;


/*=============================================================================
11. Optional: Create BI export table for day-of-week performance
=============================================================================*/

CREATE OR REPLACE TABLE bi_day_of_week_performance AS

SELECT
    month,
    day_of_week,

    COUNT(*) AS total_sessions,

    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS conversion_rate,

    ROUND(
        SUM(carted) * 100.0 / NULLIF(SUM(viewed), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        SUM(purchased) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS revenue_per_session

FROM combined_session_summary

GROUP BY
    month,
    day_of_week;


/*=============================================================================
12. Validate day-of-week output
=============================================================================*/

SELECT *
FROM bi_day_of_week_performance
ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END,
    total_revenue DESC;


/*=============================================================================
13. Best revenue day by month
=============================================================================*/

WITH ranked_days AS (
    SELECT
        month,
        day_of_week,
        total_revenue,
        conversion_rate,
        revenue_per_session,

        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY total_revenue DESC
        ) AS revenue_rank

    FROM bi_day_of_week_performance
)

SELECT
    month,
    day_of_week,
    total_revenue,
    conversion_rate,
    revenue_per_session
FROM ranked_days
WHERE revenue_rank = 1;


/*=============================================================================
14. Worst conversion day by month
=============================================================================*/

WITH ranked_days AS (
    SELECT
        month,
        day_of_week,
        total_sessions,
        total_revenue,
        conversion_rate,

        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY conversion_rate ASC
        ) AS conversion_rank

    FROM bi_day_of_week_performance
)

SELECT
    month,
    day_of_week,
    total_sessions,
    total_revenue,
    conversion_rate
FROM ranked_days
WHERE conversion_rank = 1;


/*=============================================================================
15. Final funnel story check
=============================================================================*/

SELECT
    month,
    view_sessions,
    cart_sessions,
    purchase_sessions,
    view_to_cart_pct,
    cart_to_purchase_pct,
    view_to_purchase_pct,
    cart_to_purchase_dropoff_pct
FROM bi_funnel_rates
ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END;
```
