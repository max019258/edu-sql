--1. 아래와 같이 EMP Table의 각 로우가 2번씩 조회되도록 하되 GUBUN 컬럼을 두어 EMPNO 컬럼값을 구분하도록 한다. 총 28건 조회되며 순서는 EMPNO 컬럼순으로 조회되도록 함. 
--(Join으로 1개,Compound Operator 사용하여 1개)

--<Compound Operator>
select  *
from
(
   (select rank() over(order by empno) gubun,e.* from (select * from emp ) e)
     union all
   (select rank() over(order by empno) gubun,e.* from (select * from emp ) e)
   )
order by gubun,empno;

--==> order by 1개로 줄이도록 함.

--<join>
select  b.*
from
(select level gubun from dual connect by level<=2) --2번
cross join
(
   (select rownum gubun,e.*  from (select * from emp) e order by empno) b
)
order by b.gubun;



--==> Analytic Function 사용하지 말것. EMP Table은 1번만 Access 하도록 할 것.


--2. 아래와 같이 EMP Table의 각 로우가 2번씩 조회되도록 하되 GUBUN 컬럼을 두어 첫번째 로우와 두번째 로우를 구분하는 컬럼을 둔다. 총 28건 조회되며 순서는 EMPNO 와 GUBUN 컬럼순으로 조회되도록 함. 
--(Join으로 1개,Compound Operator 사용하여 1개)

--<Compound Operator>
select * 
from 
(
    (select 1 gubun,e.* from emp e)
    union all
    (select 2 gubun,e.* from emp e) 
)
order by empno,gubun;

--==> Compound Operator 는 어디 있나? -> 삭제됐던 것 같습니다.

--<join>
select  gubun,e.*
from
(
   (select * from (select * from emp ) )e
     cross join
    (select level gubun from dual connect by level<=2)
)
order by empno,gubun;

--==> order by 1개로 줄이도록 함.

--3. 아래와 같이 EMP Table을 참조하여 금년 매월 1일에 해당하는  SAL_DATE 컬럼이 조회되도록 하여 2020년도 월별 총 14*12 건이 조회되도록 함. 

select  empno,ename,job,
d.month1 as sal_date,
sal
from emp
cross join
(select 
to_char(add_months(to_date(to_char(sysdate,'yyyy')||'01', 'yyyymm'), level - 1),'yyyy-mm-dd') as month1
from dual connect by level <= 12) d
order by sal_date,empno;

==> order by 를 명시하여 기준을 정할 것.





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

select empno ,ranknum from emp group by empno;


