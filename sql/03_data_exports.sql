-- export sessions of users with more than seven sessions in the selected period
-- sessions der nutzer mit mehr als sieben sessions im ausgewählten zeitraum exportieren

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
)
select s.*
from filtered_sessions as s
inner join analysis_group as a
    on s.user_id = a.user_id
order by s.user_id, s.session_start, s.session_id;



-- export user profiles belonging to the selected analysis group
-- nutzerprofile der ausgewählten analysegruppe exportieren

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
)
select u.*
from users as u
inner join analysis_group as a
    on u.user_id = a.user_id
order by u.user_id;



-- export flight records linked to sessions of the selected analysis group
-- flugdetails zu den sessions der ausgewählten analysegruppe exportieren
-- use distinct trip ids to avoid exporting the same flight record twice
-- eindeutige reise-ids verwenden, um flugdetails nicht doppelt zu exportieren

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
selected_trips as (
    select distinct s.trip_id
    from filtered_sessions as s
    inner join analysis_group as a
        on s.user_id = a.user_id
    where s.trip_id is not null
)
select f.*
from flights as f
inner join selected_trips as t
    on f.trip_id = t.trip_id
order by f.trip_id;



-- export hotel records linked to sessions of the selected analysis group
-- hoteldetails zu den sessions der ausgewählten analysegruppe exportieren
-- use distinct trip ids to avoid exporting the same hotel record twice
-- eindeutige reise-ids verwenden, um hoteldetails nicht doppelt zu exportieren

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
selected_trips as (
    select distinct s.trip_id
    from filtered_sessions as s
    inner join analysis_group as a
        on s.user_id = a.user_id
    where s.trip_id is not null
)
select h.*
from hotels as h
inner join selected_trips as t
    on h.trip_id = t.trip_id
order by h.trip_id;