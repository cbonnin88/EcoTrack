WITH source AS (
    SELECT * FROM {{source("ecotrack_raw_data",'transactions')}}
),

cleaned AS (
    SELECT
        CAST(transaction_id AS STRING) AS transaction_id,
        CAST(user_id AS STRING) AS user_id,
        CAST(transaction_date AS TIMESTAMP) AS transaction_at,
        DATE(CAST(transaction_date AS TIMESTAMP)) as transaction_date,
        CAST(amount AS NUMERIC) AS amount_eur,
        LOWER(item_type) AS item_type,
        CASE
            WHEN STARTS_WITH(LOWER(item_type),'subscription_') THEN 'recurring'
            ELSE 'one_time'
        END AS revenue_category
    FROM source
    WHERE transaction_id IS NOT NULL
)

SELECT * FROM cleaned