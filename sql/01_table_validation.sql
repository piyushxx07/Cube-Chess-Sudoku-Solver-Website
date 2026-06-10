```sql
/*
===============================================================================
Project: DiscoverIQ — Ecommerce Product Discovery & Conversion Analytics
File: 01_table_validation.sql
Purpose:
    Validate the core analytical tables before creating KPI, funnel, product,
    category, brand, and user-segmentation outputs.

Environment:
    DuckDB SQL / Microsoft Fabric SQL style

Notes:
    These queries are used for data sanity checks.
    They are not Power BI visuals and not production database views.
===============================================================================
*/


/*=============================================================================
1. Validate row counts for core combined tables
=============================================================================*/

SELECT
    'combined_session_summary' AS table_name,
    COUNT(*) AS row_count
FROM combined_session_summary

UNION ALL

SELECT
    'combined_dim_product' AS table_name,
    COUNT(*) AS row_count
FROM combined_dim_product

UNION ALL

SELECT
    'combined_dim_user' AS table_name,
    COUNT(*) AS row_count
FROM combined_dim_user

UNION ALL

SELECT
    'combined_dim_brand' AS table_name,
    COUNT(*) AS row_count
FROM combined_dim_brand

UNION ALL

SELECT
    'combined_dim_category' AS table_name,
    COUNT(*) AS row_count
FROM combined_dim_category;


/*=============================================================================
2. Validate available months in session table
=============================================================================*/

SELECT
    month,
    COUNT(*) AS total_sessions
FROM combined_session_summary
GROUP BY month
ORDER BY month;


/*=============================================================================
3. Validate available months across all combined tables
=============================================================================*/

SELECT
    'combined_session_summary' AS table_name,
    month,
    COUNT(*) AS row_count
FROM combined_session_summary
GROUP BY month

UNION ALL

SELECT
    'combined_dim_product' AS table_name,
    month,
    COUNT(*) AS row_count
FROM combined_dim_product
GROUP BY month

UNION ALL

SELECT
    'combined_dim_user' AS table_name,
    month,
    COUNT(*) AS row_count
FROM combined_dim_user
GROUP BY month

UNION ALL

SELECT
    'combined_dim_brand' AS table_name,
    month,
    COUNT(*) AS row_count
FROM combined_dim_brand
GROUP BY month

UNION ALL

SELECT
    'combined_dim_category' AS table_name,
    month,
    COUNT(*) AS row_count
FROM combined_dim_category
GROUP BY month

ORDER BY table_name, month;


/*=============================================================================
4. Validate session-level flags
   Expected:
   viewed, carted, purchased should contain only 0 or 1.
=============================================================================*/

SELECT
    viewed,
    carted,
    purchased,
    COUNT(*) AS session_count
FROM combined_session_summary
GROUP BY viewed, carted, purchased
ORDER BY viewed, carted, purchased;


/*=============================================================================
5. Validate missing values in important session fields
=============================================================================*/

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN user_session IS NULL THEN 1 ELSE 0 END) AS null_user_session,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN month IS NULL THEN 1 ELSE 0 END) AS null_month,
    SUM(CASE WHEN revenue IS NULL THEN 1 ELSE 0 END) AS null_revenue
FROM combined_session_summary;


/*=============================================================================
6. Validate revenue values
   Revenue should not be negative.
=============================================================================*/

SELECT
    month,
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN revenue < 0 THEN 1 ELSE 0 END) AS negative_revenue_sessions,
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    SUM(revenue) AS total_revenue
FROM combined_session_summary
GROUP BY month
ORDER BY month;


/*=============================================================================
7. Validate product table basics
=============================================================================*/

SELECT
    month,
    COUNT(*) AS product_rows,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT brand) AS unique_brands,
    COUNT(DISTINCT category_l1) AS unique_categories,
    COUNT(DISTINCT price_tier) AS unique_price_tiers
FROM combined_dim_product
GROUP BY month
ORDER BY month;


/*=============================================================================
8. Validate product metric ranges
   Views, carts, and purchases should not be negative.
=============================================================================*/

SELECT
    month,
    COUNT(*) AS product_rows,
    SUM(CASE WHEN total_views < 0 THEN 1 ELSE 0 END) AS negative_views,
    SUM(CASE WHEN total_carts < 0 THEN 1 ELSE 0 END) AS negative_carts,
    SUM(CASE WHEN total_purchases < 0 THEN 1 ELSE 0 END) AS negative_purchases,
    MIN(total_views) AS min_views,
    MAX(total_views) AS max_views,
    MIN(total_purchases) AS min_purchases,
    MAX(total_purchases) AS max_purchases
FROM combined_dim_product
GROUP BY month
ORDER BY month;


/*=============================================================================
9. Validate price tiers
=============================================================================*/

SELECT
    month,
    price_tier,
    COUNT(*) AS product_count,
    AVG(avg_price) AS avg_price,
    MIN(avg_price) AS min_price,
    MAX(avg_price) AS max_price
FROM combined_dim_product
GROUP BY month, price_tier
ORDER BY month, avg_price;


/*=============================================================================
10. Validate user segments
=============================================================================*/

SELECT
    month,
    segment,
    COUNT(*) AS total_users,
    SUM(total_sessions) AS total_sessions,
    SUM(total_purchases) AS total_purchases,
    SUM(total_spend) AS total_spend
FROM combined_dim_user
GROUP BY month, segment
ORDER BY month, total_spend DESC;


/*=============================================================================
11. Validate brand table basics
=============================================================================*/

SELECT
    month,
    COUNT(*) AS brand_rows,
    COUNT(DISTINCT brand) AS unique_brands,
    SUM(view_sessions) AS total_view_sessions,
    SUM(cart_sessions) AS total_cart_sessions,
    SUM(purchase_sessions) AS total_purchase_sessions,
    SUM(revenue) AS total_revenue
FROM combined_dim_brand
GROUP BY month
ORDER BY month;


/*=============================================================================
12. Validate category table basics
=============================================================================*/

SELECT
    month,
    COUNT(*) AS category_rows,
    COUNT(DISTINCT category_l1) AS unique_categories,
    SUM(view_sessions) AS total_view_sessions,
    SUM(cart_sessions) AS total_cart_sessions,
    SUM(purchase_sessions) AS total_purchase_sessions,
    SUM(revenue) AS total_revenue
FROM combined_dim_category
GROUP BY month
ORDER BY month;


/*=============================================================================
13. Check top revenue categories
=============================================================================*/

SELECT
    month,
    category_l1,
    revenue,
    conversion_rate,
    cart_abandonment_pct
FROM combined_dim_category
ORDER BY month, revenue DESC;


/*=============================================================================
14. Check top revenue brands
=============================================================================*/

SELECT
    month,
    brand,
    revenue,
    conversion_rate,
    cart_abandonment_pct
FROM combined_dim_brand
ORDER BY month, revenue DESC
LIMIT 20;


/*=============================================================================
15. Validate whether percentage values are stored as percent numbers
   Example:
       2.82 means 2.82%, not 0.0282.
=============================================================================*/

SELECT
    month,
    MIN(conversion_rate) AS min_conversion_rate,
    MAX(conversion_rate) AS max_conversion_rate,
    AVG(conversion_rate) AS avg_conversion_rate,
    MIN(cart_abandonment_pct) AS min_cart_abandonment_pct,
    MAX(cart_abandonment_pct) AS max_cart_abandonment_pct,
    AVG(cart_abandonment_pct) AS avg_cart_abandonment_pct
FROM combined_dim_category
GROUP BY month
ORDER BY month;


/*=============================================================================
16. Final sanity check for executive-level numbers
=============================================================================*/

SELECT
    month,
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(viewed) AS view_sessions,
    SUM(carted) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(purchased) * 100.0 / NULLIF(SUM(viewed), 0), 2) AS conversion_rate,
    ROUND((SUM(carted) - SUM(purchased)) * 100.0 / NULLIF(SUM(carted), 0), 2) AS cart_abandonment_pct
FROM combined_session_summary
GROUP BY month
ORDER BY month;
```
