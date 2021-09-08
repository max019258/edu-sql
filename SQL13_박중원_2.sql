--2. �Ʒ��� ���� Table ���� �� Data�� �Է��� �� �Ʒ� ȭ��� ���� �ֺ��� overtime ���� ���Ͻÿ�.  
--�� ���ִ� �Ͽ��Ϻ��� ����ϱ����� �Ѵ�.
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
) --�⺻ ���̺�
,
max_date as(
    select max(start_date) as md
    from basic
) -- �⺻���̺��� �ִ� ��¥
,
day_list as(
   select trunc(md,'yyyy') + (rownum -1) as yymmdd
    from max_date
    connect by level <= (trunc(md,'D') - trunc(md,'YY') + 1)
) -- 1��1�Ϻ��� �⺻���̺��� �ִ� ��¥���� ���� ���̺�
,
sunday_list as
(
    select yymmdd
    from(
        select yymmdd
        from day_list
        where to_char(yymmdd,'dy')='��')
        
) -- �Ͽ����� ��¥ ���
,
sunday_fin as
(
    select yymmdd,
    decode((select to_char(yymmdd,'mmdd') from sunday_list where rownum=1),'0101',rownum-1,rownum) 
    as week
    from sunday_list

) -- 1��1���� ��������� �Ǵ����� ���������� ���
,
period as 
(
   select 
       to_char(yymmdd,'yyyy-mm-dd') as starts,
       to_char(nvl(lead(yymmdd-1)over (order by yymmdd),yymmdd+6) ,'yyyy-mm-dd')fins,
       week
   from sunday_fin
) -- n������ �Ⱓ ����
,
merge_table as
(
    select sabun,starts,start_date,fins,week,time
    from period,basic
    where to_date(starts,'yyyy-mm-dd')<= trunc(start_date,'D')
    and trunc(start_date,'D')<= to_date(fins,'yyyy-mm-dd')
)  --����
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
) --�ٵ��
select * from result










