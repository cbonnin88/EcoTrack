-- Average Session Duration
-- On average, how long do our users use our app ?
SELECT 
  ROUND(AVG(session_duration_minutes),1) AS avg_duration 
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_sessions`;