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