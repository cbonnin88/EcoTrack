WITH user_dim AS (
    SELECT * FROM {{ref('dim_users')}}
),

daily_sessions AS (
    SELECT
        user_id,
        session_date AS activity_date,
        COUNT(DISTINCT session_id) AS daily_session_count,
        SUM(session_duration_minutes) AS daily_total_session_minutes
    FROM {{ref('fct_sessions')}}
    GROUP BY
        1,
        2
),

daily_events AS (
    SELECT
        user_id,
        event_date AS activity_date,
        COUNTIF(event_type = 'log_habit') AS daily_habits_logged,
        COUNTIF(event_type = 'join_challenge') AS daily_challenges_joined,
        COUNTIF(event_type = 'share_milestone') AS daily_milestones_shared
    FROM {{ref('fct_events')}}
    GROUP BY
        1,
        2
),

daily_transactions AS (
    SELECT
        user_id,
        transaction_date AS activity_date,
        SUM(CASE WHEN revenue_category = 'one_time' THEN amount_eur ELSE 0 END) AS daily_one_time_revenue_eur,
        SUM(CASE WHEN revenue_category = 'recurring' THEN amount_eur ELSE 0 END) AS daily_recurring_revenue_eur,
        SUM(amount_eur) AS daily_total_revenue_eur
    FROM {{ref("fct_transactions")}}
    GROUP BY
        1,
        2
),

user_active_dates AS (
    SELECT
        user_id,
        activity_date,
    FROM daily_sessions
    UNION DISTINCT
    SELECT
        user_id,
        activity_date
    FROM daily_events
    UNION DISTINCT
    SELECT
        user_id,
        activity_date
    FROM daily_transactions
),

joined_daily_activity AS (
    SELECT
        d.activity_date,
        d.user_id,
        u.country,
        u.subscription_tier,
        u.user_age,
        u.gender,
        u.signup_date,
        DATE_DIFF(d.activity_date,u.signup_date, DAY) AS days_since_signup,
        COALESCE(s.daily_session_count,0) AS daily_session_count,
        COALESCE(s.daily_total_session_minutes,0) AS daily_total_session_minutes,
        COALESCE(e.daily_habits_logged, 0) AS daily_habits_logged,
        COALESCE(e.daily_challenges_joined, 0) AS daily_challenges_joined,
        COALESCE(e.daily_milestones_shared, 0) AS  daily_milestones_shared,
        COALESCE(t.daily_one_time_revenue_eur, 0) AS daily_one_time_revenue_eur,
        COALESCE(t.daily_recurring_revenue_eur, 0) AS daily_recurring_revenue_eur,
        COALESCE(t.daily_total_revenue_eur, 0) AS daily_total_revenue_eur
    FROM user_active_dates AS d
    LEFT JOIN user_dim AS u
        ON d.user_id = u.user_id
    LEFT JOIN daily_sessions AS s
        ON d.user_id = s.user_id AND d.activity_date = s.activity_date
    LEFT JOIN daily_events AS e 
        ON d.user_id = e.user_id AND d.activity_date = e.activity_date
    LEFT JOIN daily_transactions AS t
        ON d.user_id = t.user_id AND d.activity_date = t.activity_date
)

SELECT
    *,
    SUM(daily_total_revenue_eur) OVER (
        PARTITION BY user_id
        ORDER BY activity_date
        ROWS BETWEEN unbounded preceding AND CURRENT ROW
    ) AS cumulative_user_ltv_eur,
    CASE
        WHEN COUNT(activity_date) OVER (
            PARTITION BY user_id
            ORDER BY unix_date(activity_date)
            RANGE BETWEEN 6 preceding AND CURRENT ROW
        ) > 0 THEN 1
        ELSE 0
    END AS is_active_rolling_7d
FROM joined_daily_activity