--1. �Ʒ��� ���� EMP Table�� �����Ͽ� �μ� ��� �޿�(�Ҽ��� �ݿø�) �̻��� ����� ��ȸ�ϴ� SQL�� �ۼ��ϵ� 
--�޿� �� �μ� ��� �޿� ���� ū ��������� �������� �Ͻÿ�.
select deptno,empno,ename,sal,
round((select avg(sal) from emp e2 where e.deptno=e2.deptno group by e.deptno having avg(sal)<=e.sal))
as avg_sal
from emp e
where e.sal>=(select avg(sal) from emp e2 where e.deptno=e2.deptno group by e.deptno)
order by 
sal-avg_sal desc;

--2. �Ʒ��� ���� ������� ������ �Ⱓ(�� ����)�� �ⰳ���� ���ϵ� ������ ��������� ��ȸ�ϴ� SQL�� �ۼ��Ͻÿ�.
select empno,ename,hiredate,
trunc(months_between(sysdate,hiredate)/12) ||' �� '||
trunc(mod(months_between(sysdate,hiredate),12)) || ' ����' 
as total_working_period
from emp
order by (sysdate-hiredate) desc;


--3. �μ� ��� �޿� �̸��� ������ ���� �޿��� 10% �̻� �λ��Ͽ� 
--�Ʒ��� ���� �޿� ���� ������ ��ȸ�ǵ��� �ϴ� SQL�� �ۼ��Ͻÿ�.
select  deptno,empno,sal,
case when sal<(select avg(sal) from emp e2 where e.deptno=e2.deptno group by deptno ) then sal*1.1
     else sal
end as total_sal
from emp e
order by total_sal desc;

--4. �μ� ��� �޿� �̸��� ������ ���� �޿��� 10% �λ��ϴ� Update ���� �ۼ��Ͻÿ�.
update emp e
set sal=sal*1.1
where (select avg(sal) from emp e2 where e.deptno=e2.deptno group by deptno) > sal;

