-- Customer Lifetime Value Distribution
-- How much value do our users add to the app ? 
SELECT
  CASE
    WHEN user_age BETWEEN 18 AND 25 THEN '18-25'
    WHEN user_age BETWEEN 26 AND 40 THEN '26-40'
    WHEN user_age BETWEEN 41 AND 50 THEN '41-50'
    WHEN user_age BETWEEN 51 AND 60 THEN '50-60'
    ELSE '60+'
  END AS age_group,
  AVG(cumulative_user_ltv_eur) AS avg_ltv  
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`
GROUP BY
  age_group;  
