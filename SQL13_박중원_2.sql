--2. 아래와 같이 Table 생성 및 Data를 입력한 후 아래 화면과 같이 주별로 overtime 합을 구하시요.  
--단 한주는 일요일부터 토요일까지로 한다.
--
--
--create table overtime
--( 
--sabun        varchar2(10) not null,
--start_date   date         not null,
--time         number
--);
--
--insert into overtime values ('1',to_date('20210628 18:00:00','yyyymmdd hh24:mi:ss'),4);
--insert into overtime values ('1',to_date('20210702 18:00:00','yyyymmdd hh24:mi:ss'),2);
--insert into overtime values ('1',to_date('20210703 10:00:00','yyyymmdd hh24:mi:ss'),6);
--insert into overtime values ('1',to_date('20210704 10:00:00','yyyymmdd hh24:mi:ss'),8);
--insert into overtime values ('1',to_date('20210707 18:00:00','yyyymmdd hh24:mi:ss'),4);
--insert into overtime values ('1',to_date('20210710 10:00:00','yyyymmdd hh24:mi:ss'),5);
--insert into overtime values ('1',to_date('20210711 09:00:00','yyyymmdd hh24:mi:ss'),10);
--insert into overtime values ('1',to_date('20210715 18:00:00','yyyymmdd hh24:mi:ss'),3);
--commit;


with 
basic as 
(
    select *
    from overtime
) --기본 테이블
,
max_date as(
    select max(start_date) as md
    from basic
) -- 기본테이블에서 최대 날짜
,
day_list as(
   select trunc(md,'yyyy') + (rownum -1) as yymmdd
    from max_date
    connect by level <= (trunc(md,'D') - trunc(md,'YY') + 1)
) -- 1월1일부터 기본테이블의 최대 날짜까지 구한 테이블
,
sunday_list as
(
    select yymmdd
    from(
        select yymmdd
        from day_list
        where to_char(yymmdd,'dy')='일')
        
) -- 일요일인 날짜 목록
,
sunday_fin as
(
    select yymmdd,
    decode((select to_char(yymmdd,'mmdd') from sunday_list where rownum=1),'0101',rownum-1,rownum) 
    as week
    from sunday_list

) -- 1월1일이 몇요일인지 판단한후 몇주차인지 출력
,
period as 
(
   select 
       to_char(yymmdd,'yyyy-mm-dd') as starts,
       to_char(nvl(lead(yymmdd-1)over (order by yymmdd),yymmdd+6) ,'yyyy-mm-dd')fins,
       week
   from sunday_fin
) -- n주차의 기간 범위
,
merge_table as
(
    select sabun,starts,start_date,fins,week,time
    from period,basic
    where to_date(starts,'yyyy-mm-dd')<= trunc(start_date,'D')
    and trunc(start_date,'D')<= to_date(fins,'yyyy-mm-dd')
)  --병합
,
result as
(
    select *
    from
    (
        select 
            sabun,
            week as week_chasu,
            starts||'~'||fins as period,
            sum(time)over(partition by week) as total_week_overtime
        from 
            merge_table
     )
    group by period,total_week_overtime,sabun,week_chasu
    order by week_chasu
) --다듬기
select * from result










