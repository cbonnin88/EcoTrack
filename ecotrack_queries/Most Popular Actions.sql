-- Most Popular Logs
-- What is the most popular action does the customer do ?
SELECT 
  UPPER(event_type) AS action,
  COUNT(*) AS frequency,
  ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_events`
GROUP BY 
  event_type
ORDER BY
  frequency DESC;
