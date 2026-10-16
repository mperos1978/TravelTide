-- compare gender distributions in the full population and analysis group
-- geschlechterverteilung aller nutzer mit der analysegruppe vergleichen

with analysis_group as (
    select user_id
    from sessions
    where session_start > timestamp '2023-01-04 00:00:00'
    group by user_id
    having count(*) > 7
),
gender_counts as (
    select
        'all_users' as population,
        gender,
        count(*) as user_count
    from users
    group by gender

    union all

    select
        'analysis_group' as population,
        u.gender,
        count(*) as user_count
    from users as u
    inner join analysis_group as a
        on u.user_id = a.user_id
    group by u.gender
)
select
    population,
    gender,
    user_count,
    round(
        100.0 * user_count
        / sum(user_count) over (partition by population),
        2
    ) as share_pct
from gender_counts
order by population, gender;


-- compare gender distributions across three selection stages
-- geschlechterverteilung über drei auswahlstufen vergleichen

with session_counts as (
    select
        user_id,
        count(*) as session_count
    from sessions
    where session_start > timestamp '2023-01-04 00:00:00'
    group by user_id
),
population_counts as (
    select
        '1_all_users' as population,
        gender,
        count(*) as user_count
    from users
    group by gender

    union all

    select
        '2_active_in_period',
        u.gender,
        count(*)
    from users as u
    inner join session_counts as s
        on u.user_id = s.user_id
    group by u.gender

    union all

    select
        '3_analysis_group',
        u.gender,
        count(*)
    from users as u
    inner join session_counts as s
        on u.user_id = s.user_id
    where s.session_count > 7
    group by u.gender
)
select
    population,
    gender,
    user_count,
    round(
        100.0 * user_count
        / sum(user_count) over (partition by population),
        2
    ) as share_pct
from population_counts
order by population, gender;


-- compare booking activity between users with 1–7 and 8+ sessions
-- buchungsaktivität von nutzern mit 1–7 und mindestens 8 sessions vergleichen
-- count each trip once per user, even if referenced by multiple sessions
-- jede reise je nutzer einmal zählen, auch bei mehreren session-verweisen

with period_sessions as (
    select *
    from sessions
    where session_start > timestamp '2023-01-04 00:00:00'
),
user_activity as (
    select
        user_id,
        count(*) as session_count,
        bool_or(
            flight_booked is true
            or hotel_booked is true
        ) as has_booking
    from period_sessions
    group by user_id
),
user_groups as (
    select
        user_id,
        session_count,
        has_booking,
        case
            when session_count <= 7 then '1–7 sessions'
            else '8+ sessions'
        end as activity_group
    from user_activity
),
booked_trips as (
    select distinct
        user_id,
        trip_id
    from period_sessions
    where trip_id is not null
      and (
          flight_booked is true
          or hotel_booked is true
      )
),
cancelled_trips as (
    select distinct
        user_id,
        trip_id
    from sessions
    where trip_id is not null
      and cancellation is true
),
trip_counts as (
    select
        b.user_id,
        count(*) as booked_trips,
        count(*) filter (
            where c.trip_id is null
        ) as trips_without_recorded_cancellation
    from booked_trips as b
    left join cancelled_trips as c
        on b.user_id = c.user_id
       and b.trip_id = c.trip_id
    group by b.user_id
)
select
    g.activity_group,
    count(*) as users,
    sum(g.session_count) as sessions,
    count(*) filter (
        where g.has_booking
    ) as users_with_booking,
    round(
        100.0 * count(*) filter (where g.has_booking)
        / count(*),
        2
    ) as users_with_booking_pct,
    sum(coalesce(t.booked_trips, 0)) as booked_trips,
    sum(
        coalesce(t.trips_without_recorded_cancellation, 0)
    ) as trips_without_recorded_cancellation
from user_groups as g
left join trip_counts as t
    on g.user_id = t.user_id
group by g.activity_group
order by g.activity_group;