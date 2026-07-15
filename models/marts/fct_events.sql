WITH events AS (
    SELECT * FROM {{ref('stg_events')}}
)

SELECT
    event_id,
    user_id,
    session_id,
    event_type,
    event_at,
    event_date
FROM events