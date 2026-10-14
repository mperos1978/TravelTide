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