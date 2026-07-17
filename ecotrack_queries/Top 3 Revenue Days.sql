-- Top 3 Revenue Days
-- What dates where the best in terms of revenue
WITH daily_rev AS (
  SELECT
    activity_date,
    SUM(daily_total_revenue_eur) AS rev
  FROM `product-analytics-494706.dbt_ecotrack_marts.fct_user_daily_obt`
  GROUP BY
    activity_date
)

SELECT
  *
FROM (
  SELECT
    *,
    DENSE_RANK() OVER(ORDER BY rev DESC) AS rank
  FROM daily_rev
) WHERE rank <= 3;
