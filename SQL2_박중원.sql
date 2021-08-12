--1. 아래와 같이 EMP Table을 참조하여 부서 평균 급여(소수점 반올림) 이상인 사람을 조회하는 SQL을 작성하되 
--급여 와 부서 평균 급여 차가 큰 사람순으로 나오도록 하시요.
select deptno,empno,ename,sal,
round((select avg(sal) from emp e2 where e.deptno=e2.deptno group by e.deptno having avg(sal)<=e.sal))
as avg_sal
from emp e
where e.sal>=(select avg(sal) from emp e2 where e.deptno=e2.deptno group by e.deptno)
order by 
sal-avg_sal desc;

--2. 아래와 같이 현재까지 재직한 기간(일 절삭)을 년개월을 구하되 오래된 사람순으로 조회하는 SQL을 작성하시요.
select empno,ename,hiredate,
trunc(months_between(sysdate,hiredate)/12) ||' 년 '||
trunc(mod(months_between(sysdate,hiredate),12)) || ' 개월' 
as total_working_period
from emp
order by (sysdate-hiredate) desc;


--3. 부서 평균 급여 미만인 직원에 대해 급여를 10% 이상 인상하여 
--아래와 같이 급여 높은 순으로 조회되도록 하는 SQL을 작성하시요.
select  deptno,empno,sal,
case when sal<(select avg(sal) from emp e2 where e.deptno=e2.deptno group by deptno ) then sal*1.1
     else sal
end as total_sal
from emp e
order by total_sal desc;

--4. 부서 평균 급여 미만인 직원에 대해 급여를 10% 인상하는 Update 문을 작성하시요.
update emp e
set sal=sal*1.1
where (select avg(sal) from emp e2 where e.deptno=e2.deptno group by deptno) > sal;

