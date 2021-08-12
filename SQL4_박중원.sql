--1. �Ʒ��� ���� EMP Table�� ����Ͽ� /�μ��� MAX SAL,MIN SAL,AVG SAL(�Ҽ��� ����),�Ǽ� 
--/ �׸��� ��ü MAX SAL,MIN SAL,AVG SAL(�Ҽ��� ����),�Ǽ��� ���Ͻÿ�.

--<Inline View>
select a.empno,
a.deptno,
a.sal,
d_max max_dept_sal,
d_min min_dept_sal,
d_avg avg_dept_sal,
d_cnt count_dept,
a_max max_sal,
a_min min_sal,
a_avg avg_sal,
cemp count_all
from (select max(sal) a_max,min(sal) a_min,round(avg(sal)) a_avg ,count(empno) cemp from emp ) , 
(select deptno ,max(sal) d_max,min(sal) d_min,round(avg(sal)) d_avg,count(deptno) d_cnt from emp group by deptno)  d,emp a
where 
a.deptno=d.deptno;

--<Analytic Function>
select 
empno,
ename,
deptno,
sal,
max(sal) over(partition by deptno) max_dept_sal,
min(sal) over(partition by deptno) min_dept_sal,
round(avg(sal) over(partition by deptno)) avg_dept_sal,
max(sal) over(partition by deptno) count_dept,
max(sal) over() max_sal,
min(sal) over() min_sal,
round(avg(sal) over()) avg_sal,
count(empno) over()count_all
from
emp;

--2. �Ʒ��� ���� EMP Table�� ����Ͽ�
--/ �μ��� SAL,HIREDATE �� /Numbering, ���� SAL�� Analytic Function�� ����Ͽ� ���Ͻÿ�. 
select 
empno,
ename,
deptno,
sal ,
hiredate,
count(sal) over(partition by deptno order by sal,hiredate) num_sal,
sum(sal) over(partition by deptno order by sal,hiredate)cumm_sal
from EMP
order by deptno;

--3. �Ʒ��� ���� 2�� SQL�� �����Ͽ� �μ����� SAL,HIREDATE ������ ENAME�� �����ϴ� SQL�� �ۼ��Ͻÿ�
select 
t.deptno deptno,
dname,
MAX( DECODE( num_sal, 1, ename,null )) ename_1,
MAX( DECODE( num_sal, 2, ename,null )) ename_2,
MAX( DECODE( num_sal, 3, ename ,null)) ename_3,
MAX( DECODE( num_sal, 4, ename,null )) ename_4,
MAX( DECODE( num_sal, 5, ename ,null)) ename_5,
MAX( DECODE( num_sal, 6, ename ,null)) ename_6
from
(
    select 
    empno,
    ename,
    deptno,
    sal ,
    hiredate,
    count(sal) over(partition by deptno order by sal,hiredate) num_sal,
    sum(sal) over(partition by deptno order by sal,hiredate)cumm_sal
    from EMP
    order by deptno;
) t,
dept  d
where t.deptno=d.deptno
group by t.deptno,dname
order by t.deptno;


