--2. �Ʒ��� ���� EMP Table�� �����(MGR)�� �̸��� ��ȸ�ǵ��� �Ͻÿ�. 
--�� JOB�� PRESIDENT,MANAGER,SALESMAN,ANALYST,CLERK ������ ��ȸ�ǵ��� �Ͻÿ�.
select e.empno,e.ename,e.job,e.mgr,e2.empno mgr_name
from emp e left outer join emp e2
on e.mgr=e2.empno
ORDER BY DECODE(job, 'PRESIDENT', 1),
 DECODE(job, 'MANAGER', 2),
 DECODE(job, 'SALESMAN', 3),
 DECODE(job, 'ANALYST', 4),
 DECODE(job, 'CLERK', 5),
 job asc;


--3. �Ʒ��� ���� SALGRADE Table ,EMP Table�� �����Ͽ� GRADE�� �� ������  ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�.
select grade,count(e.empno) per_grade_count
from  SALGRADE s  join emp e
on e.sal between s.losal and s.hisal
group by s.grade
order by grade;

--4. �μ� ��� �޿� �̸��� /������ ���� �μ� ��� �޿��� 
--10% �ش��ϴ� �޿��� �λ��ϴ� Update ���� �ۼ��Ͻÿ�.
update emp e
set sal=sal+((select avg(sal) from (select avg(sal) over(partition by deptno) avg_sal from emp )
where e.empno=empno)*0.1)
where  empno in 
(select empno from (select sal,empno,avg(sal) over(partition by deptno) avg_sal from emp )
where sal<avg_sal );

