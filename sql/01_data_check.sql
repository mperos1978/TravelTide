-- Check 01: Row counts of the four source tables before filtering

SELECT 'users' AS table_name, COUNT(*) AS row_count
FROM users

UNION ALL

SELECT 'sessions', COUNT(*)
FROM sessions

UNION ALL

SELECT 'flights', COUNT(*)
FROM flights

UNION ALL

SELECT 'hotels', COUNT(*)
FROM hotels;



-- Check 02: Available session period and missing start timestamps
SELECT
    MIN(session_start) AS first_session_start,
    MAX(session_start) AS last_session_start,
    COUNT(*) FILTER (
        WHERE session_start IS NULL
    ) AS missing_session_start
FROM sessions;



-- check 03: missing and duplicate primary keys
select
    'users' as table_name,
    count(*) as row_count,
    count(*) - count(user_id) as missing_keys,
    count(user_id) - count(distinct user_id) as duplicate_key_rows
from users

union all

select
    'sessions',
    count(*),
    count(*) - count(session_id),
    count(session_id) - count(distinct session_id)
from sessions

union all

select
    'flights',
    count(*),
    count(*) - count(trip_id),
    count(trip_id) - count(distinct trip_id)
from flights

union all

select
    'hotels',
    count(*),
    count(*) - count(trip_id),
    count(trip_id) - count(distinct trip_id)
from hotels;