WITH source AS (
    SELECT * FROM {{source('ecotrack_raw_data','users')}}
),

cleaned AS (
    SELECT
        CAST(user_id AS STRING) AS user_id,
        CAST(created_at AS TIMESTAMP) AS signup_at,
        DATE(created_at) AS signup_date,
        INITCAP(country) AS country,
        LOWER(subscription_tier) AS subscription_tier,
        CAST(age AS INTEGER) AS user_age,
        INITCAP(gender) AS gender
    FROM source
    WHERE user_id IS NOT NULL
)

SELECT * FROM cleaned