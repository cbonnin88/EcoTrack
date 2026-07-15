WITH transactions AS (
    SELECT * FROM {{ref('stg_transactions')}}
)

SELECT
    transaction_id,
    user_id,
    transaction_at,
    transaction_date,
    amount_eur,
    item_type,
    revenue_category
FROM transactions