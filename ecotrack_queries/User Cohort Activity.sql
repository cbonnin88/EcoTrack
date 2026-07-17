-- User Cohort Activity
-- What are some activities that our users are routinely doing ? 
SELECT
  *  
FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`
WHERE user_id IN (
  SELECT
    user_id
  FROM `product-analytics-494706.dbt_ecotrack_marts.dim_users`
  WHERE subscription_tier = 'premium'
) AND daily_habits_logged > 0;