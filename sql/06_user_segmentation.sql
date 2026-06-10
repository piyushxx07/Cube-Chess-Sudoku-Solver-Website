```sql
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 06_user_segmentation.sql
Purpose:
    Create SQL outputs for user segment performance, high-value users,
    and personalization opportunity analysis.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Main Outputs:
    bi_user_segment_performance
    bi_high_value_users

Business Question:
    Which user segments generate the most value, and where can personalization
    improve ecommerce performance?
===============================================================================
*/


/*=============================================================================
1. User Segment Performance by Month
   Segments:
       new       = 1 session
       returning = 2 to 5 sessions
       loyal     = 6+ sessions
=============================================================================*/

SELECT
    month,
    segment,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(total_sessions) AS total_sessions,
    SUM(total_events) AS total_events,
    SUM(total_views) AS total_views,
    SUM(total_carts) AS total_carts,
    SUM(total_purchases) AS total_purchases,

    ROUND(SUM(total_spend), 2) AS total_revenue,

    ROUND(
        SUM(total_spend) / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS revenue_per_user,

    ROUND(
        SUM(total_sessions) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS sessions_per_user,

    ROUND(
        SUM(total_purchases) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS purchases_per_user,

    ROUND(
        SUM(total_purchases) * 100.0 / NULLIF(SUM(total_views), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(total_carts) - SUM(total_purchases)) * 100.0 / NULLIF(SUM(total_carts), 0),
        2
    ) AS cart_abandonment_pct

FROM combined_dim_user

GROUP BY
    month,
    segment

ORDER BY
    month,
    total_revenue DESC;


/*=============================================================================
2. Optional: Create BI export table for user segment performance
=============================================================================*/

CREATE OR REPLACE TABLE bi_user_segment_performance AS

SELECT
    month,
    segment,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(total_sessions) AS total_sessions,
    SUM(total_events) AS total_events,
    SUM(total_views) AS total_views,
    SUM(total_carts) AS total_carts,
    SUM(total_purchases) AS total_purchases,

    ROUND(SUM(total_spend), 2) AS total_revenue,

    ROUND(
        SUM(total_spend) / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS revenue_per_user,

    ROUND(
        SUM(total_sessions) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS sessions_per_user,

    ROUND(
        SUM(total_purchases) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS purchases_per_user,

    ROUND(
        SUM(total_purchases) * 100.0 / NULLIF(SUM(total_views), 0),
        2
    ) AS conversion_rate,

    ROUND(
        (SUM(total_carts) - SUM(total_purchases)) * 100.0 / NULLIF(SUM(total_carts), 0),
        2
    ) AS cart_abandonment_pct

FROM combined_dim_user

GROUP BY
    month,
    segment;


/*=============================================================================
3. Validate user segment output
=============================================================================*/

SELECT *
FROM bi_user_segment_performance
ORDER BY
    month,
    total_revenue DESC;


/*=============================================================================
4. Segment Distribution
   Shows user mix by segment.
=============================================================================*/

SELECT
    month,
    segment,

    total_users,

    ROUND(
        total_users * 100.0
        / NULLIF(SUM(total_users) OVER (PARTITION BY month), 0),
        2
    ) AS user_share_pct,

    total_revenue,

    ROUND(
        total_revenue * 100.0
        / NULLIF(SUM(total_revenue) OVER (PARTITION BY month), 0),
        2
    ) AS revenue_share_pct

FROM bi_user_segment_performance

ORDER BY
    month,
    user_share_pct DESC;


/*=============================================================================
5. Segment Value Ranking
   Identifies the highest-value user segment by revenue per user.
=============================================================================*/

WITH ranked_segments AS (
    SELECT
        month,
        segment,
        total_users,
        total_revenue,
        revenue_per_user,
        sessions_per_user,
        purchases_per_user,

        RANK() OVER (
            PARTITION BY month
            ORDER BY revenue_per_user DESC
        ) AS value_rank

    FROM bi_user_segment_performance
)

SELECT
    month,
    value_rank,
    segment,
    total_users,
    total_revenue,
    revenue_per_user,
    sessions_per_user,
    purchases_per_user
FROM ranked_segments
ORDER BY
    month,
    value_rank;


/*=============================================================================
6. High-Value Users
   Top users by total spend.
=============================================================================*/

SELECT
    month,
    user_id,
    segment,

    total_sessions,
    total_events,
    total_views,
    total_carts,
    total_purchases,

    ROUND(total_spend, 2) AS total_spend,

    ROUND(
        total_spend / NULLIF(total_sessions, 0),
        2
    ) AS spend_per_session,

    ROUND(
        total_purchases * 1.0 / NULLIF(total_sessions, 0),
        2
    ) AS purchases_per_session

FROM combined_dim_user

WHERE total_spend > 0

ORDER BY
    total_spend DESC

LIMIT 1000;


/*=============================================================================
7. Optional: Create BI export table for high-value users
=============================================================================*/

CREATE OR REPLACE TABLE bi_high_value_users AS

SELECT
    month,
    user_id,
    segment,

    total_sessions,
    total_events,
    total_views,
    total_carts,
    total_purchases,

    ROUND(total_spend, 2) AS total_spend,

    ROUND(
        total_spend / NULLIF(total_sessions, 0),
        2
    ) AS spend_per_session,

    ROUND(
        total_purchases * 1.0 / NULLIF(total_sessions, 0),
        2
    ) AS purchases_per_session

FROM combined_dim_user

WHERE total_spend > 0

ORDER BY total_spend DESC

LIMIT 1000;


/*=============================================================================
8. Validate high-value users output
=============================================================================*/

SELECT *
FROM bi_high_value_users
ORDER BY total_spend DESC
LIMIT 50;


/*=============================================================================
9. High-Value Users by Segment
=============================================================================*/

SELECT
    month,
    segment,

    COUNT(*) AS high_value_user_count,

    ROUND(SUM(total_spend), 2) AS high_value_user_revenue,

    ROUND(AVG(total_spend), 2) AS avg_high_value_user_spend,

    ROUND(AVG(total_sessions), 2) AS avg_sessions,

    ROUND(AVG(total_purchases), 2) AS avg_purchases

FROM bi_high_value_users

GROUP BY
    month,
    segment

ORDER BY
    month,
    high_value_user_revenue DESC;


/*=============================================================================
10. User Engagement Buckets
    Groups users by number of sessions to understand engagement depth.
=============================================================================*/

SELECT
    month,

    CASE
        WHEN total_sessions = 1 THEN '1 session'
        WHEN total_sessions BETWEEN 2 AND 3 THEN '2-3 sessions'
        WHEN total_sessions BETWEEN 4 AND 5 THEN '4-5 sessions'
        WHEN total_sessions BETWEEN 6 AND 10 THEN '6-10 sessions'
        WHEN total_sessions BETWEEN 11 AND 20 THEN '11-20 sessions'
        ELSE '20+ sessions'
    END AS engagement_bucket,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(total_sessions) AS total_sessions,

    SUM(total_purchases) AS total_purchases,

    ROUND(SUM(total_spend), 2) AS total_revenue,

    ROUND(
        SUM(total_spend) / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS revenue_per_user,

    ROUND(
        SUM(total_purchases) * 1.0 / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS purchases_per_user

FROM combined_dim_user

GROUP BY
    month,
    CASE
        WHEN total_sessions = 1 THEN '1 session'
        WHEN total_sessions BETWEEN 2 AND 3 THEN '2-3 sessions'
        WHEN total_sessions BETWEEN 4 AND 5 THEN '4-5 sessions'
        WHEN total_sessions BETWEEN 6 AND 10 THEN '6-10 sessions'
        WHEN total_sessions BETWEEN 11 AND 20 THEN '11-20 sessions'
        ELSE '20+ sessions'
    END

ORDER BY
    month,
    CASE
        WHEN engagement_bucket = '1 session' THEN 1
        WHEN engagement_bucket = '2-3 sessions' THEN 2
        WHEN engagement_bucket = '4-5 sessions' THEN 3
        WHEN engagement_bucket = '6-10 sessions' THEN 4
        WHEN engagement_bucket = '11-20 sessions' THEN 5
        ELSE 6
    END;


/*=============================================================================
11. Spending Buckets
    Groups users by total spend.
=============================================================================*/

SELECT
    month,

    CASE
        WHEN total_spend = 0 THEN 'No spend'
        WHEN total_spend > 0 AND total_spend < 50 THEN '$0-$50'
        WHEN total_spend >= 50 AND total_spend < 200 THEN '$50-$200'
        WHEN total_spend >= 200 AND total_spend < 500 THEN '$200-$500'
        WHEN total_spend >= 500 AND total_spend < 1000 THEN '$500-$1K'
        ELSE '$1K+'
    END AS spend_bucket,

    COUNT(DISTINCT user_id) AS total_users,

    SUM(total_sessions) AS total_sessions,

    SUM(total_purchases) AS total_purchases,

    ROUND(SUM(total_spend), 2) AS total_revenue,

    ROUND(
        SUM(total_spend) / NULLIF(COUNT(DISTINCT user_id), 0),
        2
    ) AS revenue_per_user

FROM combined_dim_user

GROUP BY
    month,
    CASE
        WHEN total_spend = 0 THEN 'No spend'
        WHEN total_spend > 0 AND total_spend < 50 THEN '$0-$50'
        WHEN total_spend >= 50 AND total_spend < 200 THEN '$50-$200'
        WHEN total_spend >= 200 AND total_spend < 500 THEN '$200-$500'
        WHEN total_spend >= 500 AND total_spend < 1000 THEN '$500-$1K'
        ELSE '$1K+'
    END

ORDER BY
    month,
    total_revenue DESC;


/*=============================================================================
12. Month-over-Month Segment Comparison
=============================================================================*/

WITH oct_segments AS (
    SELECT
        segment,
        total_users AS oct_users,
        total_sessions AS oct_sessions,
        total_purchases AS oct_purchases,
        total_revenue AS oct_revenue,
        revenue_per_user AS oct_revenue_per_user,
        sessions_per_user AS oct_sessions_per_user,
        purchases_per_user AS oct_purchases_per_user
    FROM bi_user_segment_performance
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
    FROM bi_user_segment_performance
    WHERE month = 'November'
)

SELECT
    COALESCE(o.segment, n.segment) AS segment,

    COALESCE(o.oct_users, 0) AS oct_users,
    COALESCE(n.nov_users, 0) AS nov_users,
    COALESCE(n.nov_users, 0) - COALESCE(o.oct_users, 0) AS user_change,

    COALESCE(o.oct_revenue, 0) AS oct_revenue,
    COALESCE(n.nov_revenue, 0) AS nov_revenue,
    ROUND(COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0), 2) AS revenue_change,

    ROUND(
        (COALESCE(n.nov_revenue, 0) - COALESCE(o.oct_revenue, 0)) * 100.0
        / NULLIF(o.oct_revenue, 0),
        2
    ) AS revenue_change_pct,

    COALESCE(o.oct_revenue_per_user, 0) AS oct_revenue_per_user,
    COALESCE(n.nov_revenue_per_user, 0) AS nov_revenue_per_user,
    ROUND(
        COALESCE(n.nov_revenue_per_user, 0) - COALESCE(o.oct_revenue_per_user, 0),
        2
    ) AS revenue_per_user_change,

    COALESCE(o.oct_sessions_per_user, 0) AS oct_sessions_per_user,
    COALESCE(n.nov_sessions_per_user, 0) AS nov_sessions_per_user,
    ROUND(
        COALESCE(n.nov_sessions_per_user, 0) - COALESCE(o.oct_sessions_per_user, 0),
        2
    ) AS sessions_per_user_change,

    COALESCE(o.oct_purchases_per_user, 0) AS oct_purchases_per_user,
    COALESCE(n.nov_purchases_per_user, 0) AS nov_purchases_per_user,
    ROUND(
        COALESCE(n.nov_purchases_per_user, 0) - COALESCE(o.oct_purchases_per_user, 0),
        2
    ) AS purchases_per_user_change

FROM oct_segments o
FULL OUTER JOIN nov_segments n
    ON o.segment = n.segment

ORDER BY revenue_change ASC;


/*=============================================================================
13. Personalization Opportunity Labels
=============================================================================*/

SELECT
    month,
    segment,
    total_users,
    total_revenue,
    revenue_per_user,
    sessions_per_user,
    purchases_per_user,

    CASE
        WHEN segment = 'new'
            THEN 'Build trust, show popular products, and guide first purchase'

        WHEN segment = 'returning'
            THEN 'Use personalized recommendations based on repeat behavior'

        WHEN segment = 'loyal'
            THEN 'Protect high-value users with loyalty offers and premium recommendations'

        ELSE 'Review segment behavior'
    END AS personalization_opportunity

FROM bi_user_segment_performance

ORDER BY
    month,
    revenue_per_user DESC;


/*=============================================================================
14. Users With High Sessions but No Purchase
    These users show interest but have not converted.
=============================================================================*/

SELECT
    month,
    user_id,
    segment,

    total_sessions,
    total_events,
    total_views,
    total_carts,
    total_purchases,
    total_spend,

    'High engagement but no purchase — target with personalized offer or cart recovery' AS recommendation

FROM combined_dim_user

WHERE total_sessions >= 5
  AND total_purchases = 0

ORDER BY
    total_sessions DESC,
    total_events DESC

LIMIT 500;


/*=============================================================================
15. Users With Cart Activity but No Purchase
    These users are strong cart recovery candidates.
=============================================================================*/

SELECT
    month,
    user_id,
    segment,

    total_sessions,
    total_events,
    total_views,
    total_carts,
    total_purchases,
    total_spend,

    'Cart activity without purchase — target with cart recovery campaign' AS recommendation

FROM combined_dim_user

WHERE total_carts > 0
  AND total_purchases = 0

ORDER BY
    total_carts DESC,
    total_sessions DESC

LIMIT 500;


/*=============================================================================
16. Final User Segmentation Story Check
=============================================================================*/

SELECT
    month,
    segment,
    total_users,
    total_revenue,
    revenue_per_user,
    sessions_per_user,
    purchases_per_user
FROM bi_user_segment_performance
ORDER BY
    month,
    revenue_per_user DESC;
```
