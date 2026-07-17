-- Total Users by Country
-- How many users do we have per country for the free subscription
SELECT
  country,
  COUNT(DISTINCT user_id) AS total_users
FROM `product-analytics-494706.dbt_ecotrack_marts.dim_users`
WHERE subscription_tier != 'free'
GROUP BY
  country
ORDER BY
  total_users DESC;