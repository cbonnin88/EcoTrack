-- Retention Query
SELECT
  subscription_tier,
  DATE_TRUNC(activity_date, MONTH) AS activity_month,
  COUNT(DISTINCT user_id) AS active_users,
  SUM(daily_total_revenue_eur) AS monthly_rev,
  RANK() OVER(PARTITION BY DATE_TRUNC(activity_date, MONTH)ORDER BY  SUM(daily_total_revenue_eur)DESC) AS tier_rank  
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`
GROUP BY
  subscription_tier,
  activity_date;