--2. 아래와 같이 EMP Table의 상급자(MGR)의 이름이 조회되도록 하시요. 
--단 JOB이 PRESIDENT,MANAGER,SALESMAN,ANALYST,CLERK 순으로 조회되도록 하시요.
select e.empno,e.ename,e.job,e.mgr,e2.empno mgr_name
from emp e left outer join emp e2
on e.mgr=e2.empno
ORDER BY DECODE(job, 'PRESIDENT', 1),
 DECODE(job, 'MANAGER', 2),
 DECODE(job, 'SALESMAN', 3),
 DECODE(job, 'ANALYST', 4),
 DECODE(job, 'CLERK', 5),
 job asc;


--3. 아래와 같이 SALGRADE Table ,EMP Table을 참조하여 GRADE별 몇 명인지  조회하는 SQL을 작성하시요.
select grade,count(e.empno) per_grade_count
from  SALGRADE s  join emp e
on e.sal between s.losal and s.hisal
group by s.grade
order by grade;

--4. 부서 평균 급여 미만인 /직원에 대해 부서 평균 급여의 
--10% 해당하는 급여를 인상하는 Update 문을 작성하시요.
update emp e
set sal=sal+((select avg(sal) from (select avg(sal) over(partition by deptno) avg_sal from emp )
where e.empno=empno)*0.1)
where  empno in 
(select empno from (select sal,empno,avg(sal) over(partition by deptno) avg_sal from emp )
where sal<avg_sal );

