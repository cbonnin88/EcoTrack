-- Business Question: "Does higher engagement (defined as habits logged) correlate with higher revenue, and does this pattern differ by our subscription tiers?"

WITH user_performance AS (
  -- Calculating key engagement and revenue metrics per user, per month
  SELECT
    subscription_tier,
    DATE_TRUNC(activity_date,MONTH) AS activity_month,
    user_id,
    SUM(daily_habits_logged) AS total_habits_logged,
    SUM(daily_total_revenue_eur) AS total_revenue_eur
  FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`
  GROUP BY
    subscription_tier,
    activity_date,
    user_id
),

tier_summary AS (
  -- Aggregate those metrics to the tier/month level
  SELECT
    subscription_tier,
    activity_month,
    AVG(total_habits_logged) AS avg_habits_per_user,
    SUM(total_revenue_eur) AS total_tier_revenue,
    COUNT(DISTINCT user_id) AS active_user_count
  FROM user_performance
  GROUP BY
    subscription_tier,
    activity_month
)

SELECT
  *,
  RANK() OVER(PARTITION BY tier_summary.activity_month ORDER BY total_tier_revenue DESC) AS revenue_rank,
  -- Calculate ARPU for financial impact
  ROUND(total_tier_revenue / NULLIF(active_user_count,0),2) AS arpu
FROM tier_summary
ORDER BY
  activity_month DESC,
  revenue_rank ASC;