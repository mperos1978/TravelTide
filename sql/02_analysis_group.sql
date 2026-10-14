-- count users with at least eight sessions in the selected period
-- nutzer mit mindestens acht sessions im ausgewählten zeitraum zählen
-- start: after midnight on 2023-01-04; end: last available session
-- beginn: nach mitternacht am 04.01.2023; ende: letzte verfügbare session

with filtered_sessions as (
    select *
    from sessions
    where session_start > timestamp '2023-01-04 00:00:00'
      
  ),
user_session_counts as (
    select
        user_id,
        count(*) as session_count
    from filtered_sessions
    group by user_id
),
analysis_group as (
    select
        user_id,
        session_count
    from user_session_counts
    where session_count > 7
)



-- check missing booking details within the selected analysis group
-- fehlende buchungsdetails innerhalb der ausgewählten analysegruppe prüfen

with filtered_sessions as (
    select *
    from sessions
    where session_start > timestamp '2023-01-04 00:00:00'
),
analysis_group as (
    select user_id
    from filtered_sessions
    group by user_id
    having count(*) > 7
),
selected_sessions as (
    select s.*
    from filtered_sessions as s
    inner join analysis_group as a
        on s.user_id = a.user_id
)
select
    'flight' as booking_type,
    count(*) as sessions_marked_as_booked,
    count(*) filter (
        where f.trip_id is null
    ) as missing_booking_details
from selected_sessions as s
left join flights as f
    on s.trip_id = f.trip_id
where s.flight_booked is true

union all

select
    'hotel',
    count(*),
    count(*) filter (
        where h.trip_id is null
    )
from selected_sessions as s
left join hotels as h
    on s.trip_id = h.trip_id
where s.hotel_booked is true;