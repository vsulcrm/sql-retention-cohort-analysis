/* PROJECT: Advanced Subscription Cohort Analysis
   AUTHOR: Volker Schulz
   PURPOSE: This script calculates monthly retention cohorts to identify churn patterns.
*/

-- STEP 1: Identify the "Birth Month" (Cohort) for each user
WITH user_cohorts AS (
    SELECT 
        user_id,
        MIN(DATE_TRUNC('month', purchase_date)) AS cohort_month
    FROM raw_subscriptions -- This represents your source table
    GROUP BY 1
),

-- STEP 2: Calculate the "Lifetime Month" index for every transaction
order_activities AS (
    SELECT
        t.user_id,
        DATE_TRUNC('month', t.purchase_date) AS activity_month,
        uc.cohort_month,
        -- Calculate the difference in months between purchase and first purchase
        (EXTRACT(YEAR FROM t.purchase_date) - EXTRACT(YEAR FROM uc.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM t.purchase_date) - EXTRACT(MONTH FROM uc.cohort_month)) AS month_number
    FROM raw_subscriptions t
    JOIN user_cohorts uc ON t.user_id = uc.user_id
),

-- STEP 3: Aggregate active users per cohort and month_number
cohort_size AS (
    SELECT 
        cohort_month,
        month_number,
        COUNT(DISTINCT user_id) AS active_users
    FROM order_activities
    GROUP BY 1, 2
),

-- STEP 4: Final Pivot to create the Retention Matrix (%)
SELECT
    cohort_month,
    MAX(CASE WHEN month_number = 0 THEN active_users END) AS cohort_size,
    -- Calculate retention rates for subsequent months
    ROUND(100.0 * MAX(CASE WHEN month_number = 1 THEN active_users END) / NULLIF(MAX(CASE WHEN month_number = 0 THEN active_users END), 0), 2) AS month_1,
    ROUND(100.0 * MAX(CASE WHEN month_number = 2 THEN active_users END) / NULLIF(MAX(CASE WHEN month_number = 0 THEN active_users END), 0), 2) AS month_2,
    ROUND(100.0 * MAX(CASE WHEN month_number = 3 THEN active_users END) / NULLIF(MAX(CASE WHEN month_number = 0 THEN active_users END), 0), 2) AS month_3,
    ROUND(100.0 * MAX(CASE WHEN month_number = 6 THEN active_users END) / NULLIF(MAX(CASE WHEN month_number = 0 THEN active_users END), 0), 2) AS month_6
FROM cohort_size
GROUP BY 1
ORDER BY 1;