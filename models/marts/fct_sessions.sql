WITH sessions AS (
    SELECT * FROM {{ref('stg_sessions')}}
)

SELECT
    session_id,
    user_id,
    session_start_at,
    session_end_at,
    session_date,
    session_duration_minutes
FROM sessions