--1. 아래와 같이 각 empno 당 2개씩 row가 생성되도록 만든 후 
--각 empno 당 1건만 남기고 삭제시키는 문을 작성하시요.  

--create table emp_dup
--as
--select a.*
--from emp a,
--     (select 1 from emp where rownum <= 2) b;

--<첫번째>
delete from emp_dup e1
where rowid < (select max(rowid) from emp_dup e2 where e1.empno=e2.empno);

--<두번째>
delete from emp_dup
where rowid in (
    select rowid from (
        select * from (
            select row_number()over(partition by empno order by  empno) cnt
            from emp_dup
        )
        where cnt > 1 
    )
);






select * from emp_dup;
rollback;

--2. 아래와 같이 sal_hist table을 생성한 후  아래와 같이 기간이 조회되도록 하시요. 

--create table sal_hist 
--(
--	empno      number (4) not null,
--	start_yymm char(6),
--	sal        number (7,2)
--);
--
--insert into sal_hist values (1,'201501',1000);
--insert into sal_hist values (1,'201610',1500);
--insert into sal_hist values (1,'201801',1700);
--insert into sal_hist values (2,'201901',1700);
--insert into sal_hist values (3,'201710',1900);
--insert into sal_hist values (3,'201901',1700);
--commit;

select  
empno,
start_yymm,
(
    nvl
    (
        to_char
        (
            add_months
            (
                to_date((lead(start_yymm) over (partition by empno order by empno)) ,'yyyymm'),-1
            )
            ,'yyyymm'
         ),
         999912
    )
) as end_yymm
from sal_hist;


--3. 아래와 같이 EMP Table을 참조하여 부서별,기간별 소속된 직원수를 구하는 SQL을 작성하시요.

select 
    deptno,
    to_char(hiredate,'yyyy-mm-dd') as start_date,
    nvl(
        to_char(
        lead(hiredate) over (partition by deptno order by deptno)-1
        ,'yyyy-mm-dd'
        )
        ,to_char(sysdate,'yyyy-mm-dd')
    )as end_date,
    sum(cnt) over (partition by deptno order by deptno,hiredate) as "COUNT(*)"
from 
    (select deptno,hiredate,count(*) cnt from emp group by deptno,hiredate order by deptno);




