--1. 아래와 같이 EMP Table의 각 로우가 2번씩 조회되도록 하되 GUBUN 컬럼을 두어 EMPNO 컬럼값을 구분하도록 한다. 총 28건 조회되며 순서는 EMPNO 컬럼순으로 조회되도록 함. 
--(Join으로 1개,Compound Operator 사용하여 1개)

--<Compound Operator>
select  *
from
(
   (select rownum,e.* from (select * from emp order by empno) e)
     union all
    (select rownum,e.* from (select * from emp order by empno) e)
)
order by empno;



--<join>
select  b.ranking as gubun, a.*
from
(select level gubun from dual connect by level<=2)
cross join
(
   (select * from (select * from emp order by empno) e) a
  full outer join
   (select empno,RANK() OVER (ORDER BY empno asc) as ranking from emp group by empno) b
   on a.empno=b.empno
)
order by a.empno;


--2. 아래와 같이 EMP Table의 각 로우가 2번씩 조회되도록 하되 GUBUN 컬럼을 두어 첫번째 로우와 두번째 로우를 구분하는 컬럼을 둔다. 총 28건 조회되며 순서는 EMPNO 와 GUBUN 컬럼순으로 조회되도록 함. 
--(Join으로 1개,Compound Operator 사용하여 1개)

--<Compound Operator>
select  gubun,e.*
from
(
   (select * from (select * from emp order by empno) )e
     cross join
    (select level gubun from dual connect by level<=2)
)
order by empno,gubun;


--<join>
select  gubun,e.*
from
(
   (select * from (select * from emp order by empno) )e
     cross join
    (select level gubun from dual connect by level<=2)
)
order by empno,gubun;



--3. 아래와 같이 EMP Table을 참조하여 금년 매월 1일에 해당하는  SAL_DATE 컬럼이 조회되도록 하여 2020년도 월별 총 14*12 건이 조회되도록 함. 

select  empno,ename,job,
d.month1 as sal_date,
sal
from emp
cross join
(select 
to_char(add_months(to_date(to_char(sysdate,'yyyy')||'01', 'yyyymm'), level - 1),'yyyy-mm-dd') as month1
from dual connect by level <= 12) d;

--4. 3번 답을 사용하여 아래와 같이 월별 SAL SUM이 나오도록 하여 총 14*12 건이 조회되도록 함. ROLLUP 사용하지 말것..

select empno,ename,job,sal_date,sal
from
(
    select  empno,ename,job,
    d.month1 as sal_date,
    sal
    from emp
    cross join
    (select 
    to_char(add_months(to_date(to_char(sysdate,'yyyy')||'01', 'yyyymm'), level - 1),'yyyy-mm-dd') as month1
    from dual connect by level <= 12) d
)
union all
(
    select  null,null,null,month1 sal_date,sum(sal)
    from emp
    cross join
    (select 
    to_char(add_months(to_date(to_char(sysdate,'yyyy')||'01', 'yyyymm'), level - 1),'yyyy-mm-dd') as month1
    from dual connect by level <= 12) d
    group by month1
)
order by sal_date,empno;




