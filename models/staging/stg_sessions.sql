WITH source AS (
    SELECT * FROM {{source('ecotrack_raw_data','sessions')}}
),

cleaned AS (
    SELECT
        CAST(session_id AS STRING) AS session_id,
        CAST(user_id AS STRING) AS user_id,
        CAST(session_start AS TIMESTAMP) AS session_start_at,
        CAST(session_end AS TIMESTAMP) AS session_end_at,
        DATE(CAST(session_start AS TIMESTAMP)) AS session_date,
        TIMESTAMP_DIFF(
            CAST(session_end AS TIMESTAMP),
            CAST(session_start AS TIMESTAMP),
            MINUTE
        ) AS session_duration_minutes
    FROM source
    WHERE session_id IS NOT NULL
)

SELECT * FROM cleaned