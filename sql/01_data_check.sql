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



-- check 04: sessions without a matching user
select
    count(*) as sessions_without_user,
    count(*) filter (
        where s.user_id is null
    ) as missing_user_id
from sessions as s
left join users as u
    on s.user_id = u.user_id
where u.user_id is null;



-- check 05: trips referenced by multiple sessions (wir prüfen wie häufig dieselbe Reise in mehreren Sessions vorkommt,
-- damit wir Buchungen später nicht mehrfach zählen)

with trip_session_counts as (
    select
        trip_id,
        count(*) as session_count
    from sessions
    where trip_id is not null
    group by trip_id
)
select
    count(*) as distinct_trips,
    count(*) filter (where session_count > 1) as trips_with_multiple_sessions,
    max(session_count) as max_sessions_per_trip
from trip_session_counts;



-- check 06: cancellation patterns for trips with two sessions (hängen die doppelten Reiseverweise mit Stornierungen zusammen)
with repeated_trips as (
    select
        trip_id,
        count(*) filter (
            where cancellation is true
        ) as cancellation_sessions
    from sessions
    where trip_id is not null
    group by trip_id
    having count(*) = 2
)
select
    cancellation_sessions,
    count(*) as trip_count
from repeated_trips
group by cancellation_sessions
order by cancellation_sessions;



-- check 07: identify sessions marked as booked without matching booking details
-- prüfung 07: sessions finden, die als gebucht markiert sind,
-- aber keine passenden flug- oder hoteldetails haben

select
    count(*) filter (
        where s.flight_booked is true
          and f.trip_id is null
    ) as flight_bookings_without_details,
    count(*) filter (
        where s.hotel_booked is true
          and h.trip_id is null
    ) as hotel_bookings_without_details
from sessions as s
left join flights as f
    on s.trip_id = f.trip_id
left join hotels as h
    on s.trip_id = h.trip_id;




-- check 08: distinguish missing trip ids from missing booking records
-- unterscheiden, ob bei als gebucht markierten sessions die reise-id fehlt oder kein passender buchungseintrag vorhanden ist

select
    'flight' as booking_type,
    count(*) as sessions_marked_as_booked,
    count(*) filter (
        where s.trip_id is null
    ) as missing_trip_id,
    count(*) filter (
        where s.trip_id is not null
          and f.trip_id is null
    ) as missing_booking_record
from sessions as s
left join flights as f
    on s.trip_id = f.trip_id
where s.flight_booked is true

union all

select
    'hotel',
    count(*),
    count(*) filter (
        where s.trip_id is null
    ),
    count(*) filter (
        where s.trip_id is not null
          and h.trip_id is null
    )
from sessions as s
left join hotels as h
    on s.trip_id = h.trip_id
where s.hotel_booked is true;



