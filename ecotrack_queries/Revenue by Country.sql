-- Revenue by Country
-- How much are we gaing per country ? 
SELECT
  u.country,
  SUM(t.amount_eur) AS total_revenue  
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_transactions` AS t
INNER JOIN `product-analytics-494706.dbt_ecotrack_marts.dim_users` AS u
  ON t.user_id = u.user_id
GROUP BY
  u.country;
