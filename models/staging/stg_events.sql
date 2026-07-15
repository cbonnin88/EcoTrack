WITH source AS (
    SELECT * FROM {{source('ecotrack_raw_data','events')}}
),

cleaned AS (
    SELECT
        CAST(event_id AS STRING) AS event_id,
        CAST(user_id AS STRING) AS user_id,
        CAST(session_id AS STRING) AS session_id,
        LOWER(TRIM(event_type)) AS event_type,
        CAST(event_timestamp AS TIMESTAMP) AS event_at,
        DATE(CAST(event_timestamp AS TIMESTAMP)) AS event_date
    FROM source
    WHERE event_id IS NOT NULL
)

SELECT * FROM cleaned