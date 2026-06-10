```sql
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 02_executive_kpis.sql
Purpose:
    Create executive-level KPI outputs for the Power BI Executive Overview page.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Main Output:
    bi_executive_kpis

Business Question:
    Did ecommerce performance improve or decline between October and November,
    and which KPI explains the change?
===============================================================================
*/


/*=============================================================================
1. Executive KPIs by month
=============================================================================*/

SELECT
    month,

    COUNT(*) AS total_sessions,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(viewed) AS view_sessions,

    SUM(carted) AS cart_sessions,

    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

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

GROUP BY month

ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END;


/*=============================================================================
2. Optional: Create BI export table
   Use this if running in DuckDB and you want to save the output as a table.
=============================================================================*/

CREATE OR REPLACE TABLE bi_executive_kpis AS

SELECT
    month,

    COUNT(*) AS total_sessions,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(viewed) AS view_sessions,

    SUM(carted) AS cart_sessions,

    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

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

GROUP BY month;


/*=============================================================================
3. Validate output
=============================================================================*/

SELECT *
FROM bi_executive_kpis
ORDER BY
    CASE
        WHEN month = 'October' THEN 1
        WHEN month = 'November' THEN 2
        ELSE 3
    END;


/*=============================================================================
4. Combined KPI summary for all months
   This is useful for showing total/all-month cards.
=============================================================================*/

SELECT
    'All Months' AS period,

    COUNT(*) AS total_sessions,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(viewed) AS view_sessions,

    SUM(carted) AS cart_sessions,

    SUM(purchased) AS purchase_sessions,

    ROUND(SUM(revenue), 2) AS total_revenue,

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
    ) AS conversion_rate,

    ROUND(
        (SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0),
        2
    ) AS cart_abandonment_pct,

    ROUND(
        SUM(revenue) / NULLIF(COUNT(*), 0),
        2
    ) AS revenue_per_session

FROM combined_session_summary;


/*=============================================================================
5. Month-over-month executive comparison
   This query compares October and November side by side.
=============================================================================*/

WITH monthly_kpis AS (
    SELECT
        month,
        COUNT(*) AS total_sessions,
        COUNT(DISTINCT user_id) AS total_users,
        SUM(viewed) AS view_sessions,
        SUM(carted) AS cart_sessions,
        SUM(purchased) AS purchase_sessions,
        SUM(revenue) AS total_revenue,

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

    ROUND(o.total_revenue, 2) AS oct_revenue,
    ROUND(n.total_revenue, 2) AS nov_revenue,
    ROUND(n.total_revenue - o.total_revenue, 2) AS revenue_change,
    ROUND(
        (n.total_revenue - o.total_revenue) * 100.0 / NULLIF(o.total_revenue, 0),
        2
    ) AS revenue_change_pct,

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
6. Optional: Create month-over-month KPI export table
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

    ROUND(o.total_revenue, 2) AS oct_revenue,
    ROUND(n.total_revenue, 2) AS nov_revenue,
    ROUND(n.total_revenue - o.total_revenue, 2) AS revenue_change,
    ROUND(
        (n.total_revenue - o.total_revenue) * 100.0 / NULLIF(o.total_revenue, 0),
        2
    ) AS revenue_change_pct,

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
7. Validate month-over-month output
=============================================================================*/

SELECT *
FROM bi_mom_kpi_change;
```
