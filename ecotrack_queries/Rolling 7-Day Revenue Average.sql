-- Rolling 7-Day Revenue Average
-- What are some of our weekly averages ? 
SELECT
  activity_date,
  AVG(daily_total_revenue_eur) OVER(ORDER BY activity_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS revenue_average
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`;