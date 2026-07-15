WITH users AS (
    SELECT * FROM {{ref('stg_users')}}
)

SELECT
    user_id,
    signup_at,
    signup_date,
    country,
    subscription_tier,
    user_age,
    gender,
    CASE
        WHEN user_age < 25 THEN '18-24'
        WHEN user_age < 35 THEN '25-34'
        WHEN user_age < 50 THEN '35-49'
        ELSE '50+'
    END AS age_bracket
FROM users