-- Daily Revenue Growth
-- What is our revenue growth ? 
SELECT
  activity_date,
  daily_total_revenue_eur,
  LAG(daily_total_revenue_eur) OVER(ORDER BY activity_date) AS prev_day_rev  
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`;