select *
from
(
    select 
        sabun,
        week as week_chasu,
        starts||'~'||fins as period,
        sum(time)over(partition by week) as total_week_overtime
    from 
        (
            select sabun,starts,start_date,fins,week,time
            from 
                overtime basic,
                (
                       select 
                           to_char(yymmdd,'yyyy-mm-dd') as starts,
                           to_char(nvl(lead(yymmdd-1)over (order by yymmdd),yymmdd+6) ,'yyyy-mm-dd')fins,
                           week
                       from 
                       (
                               select yymmdd ,rownum week
                               from
                               (
                                        select yymmdd
                                        from(
                                                select 
                                                      (trunc(md,'YY') + level )-1 as yymmdd --
                                                from 
                                                    (
                                                    select max(start_date) as md -- overtime�� �ִ� ��¥ ���
                                                    from overtime
                                                    )
                                                 connect by level <= (trunc(md,'HH')+1) - trunc(md,'YY')-- level <= (yyyy-mm-dd �ִ밪) - (yyyy-01-01 ) +1
                                            )
                                        where to_char(yymmdd,'dy')='��'
                                 )sunday_list-- �Ͽ����� ��¥ ����� ���������� ���
                       )
                ) period --�Ͽ��� ��¥ ����
                    where to_date(starts,'yyyy-mm-dd')<= trunc(start_date,'D')
                    and trunc(start_date,'D')<= to_date(fins,'yyyy-mm-dd')
        )
 )
group by period,total_week_overtime,sabun,week_chasu
order by week_chasu;
