-- User Activity Intensity
-- How long are our users active for ? 

WITH active_users AS (
  SELECT
    user_id,
    COUNT(DISTINCT activity_date) AS active_days
  FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`
  WHERE CONCAT(subscription_tier,gender) IS NOT NULL
  GROUP BY
    user_id
)

SELECT
  *,
  NTILE(4) OVER(ORDER BY active_days DESC) AS quartile
FROM active_users;