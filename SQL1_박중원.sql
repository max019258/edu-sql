
--1
select empno,SAL,comm,HIREDATE,SAL+NVL(COMM,0) as TOTAL_INCOME
from emp
order by TOTAL_INCOME asc,hiredate desc;

--2
select empno,ename,hiredate,trunc(sysdate-hiredate) as hiredatetotal_working_period
from emp
order by hiredate asc;

--3
select e.DEPTNO,MIN(SAL) as SAL_MIN,
MAX(SAL) as SAL_MAX, 
SUM(SAL) as SAL_SUM, 
COUNT(e.DEPTNO) as DEPT_COUNT,
TRUNC(AVG(SAL)) as AVG_SAL
from dept d, emp e
where d.deptno=e.deptno
group by e.deptno
order by AVG_SAL desc
;

--4
select e.deptno,COUNT(e.deptno) as dept_COUNT
from emp e
group by deptno
having COUNT(deptno) >=5;
