-- Engagement per Subscription Tier
-- How many customers are using are apps, by subscription tier
WITH tier_metrics AS (
  SELECT 
    u.subscription_tier, 
    COUNT(s.session_id) AS tier_session_count
  FROM `product-analytics-494706.dbt_ecotrack_marts.fct_sessions` AS s
  INNER JOIN `product-analytics-494706.dbt_ecotrack_marts.dim_users` AS u
    ON s.user_id = u.user_id
  GROUP BY
    u.subscription_tier
),
total_metrics AS (
  SELECT
    subscription_tier,
    tier_session_count,
    SUM(tier_session_count) OVER() AS grand_total_sessions
  FROM tier_metrics
)

SELECT
  subscription_tier,
  tier_session_count,
  ROUND(100.0 * tier_session_count / grand_total_sessions,2) AS usage_percentage
FROM total_metrics
ORDER BY
  usage_percentage DESC;