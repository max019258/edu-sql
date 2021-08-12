--1. �Ʒ��� ���� EMP Table�� �� �ο찡 2���� ��ȸ�ǵ��� �ϵ� GUBUN �÷��� �ξ� EMPNO �÷����� �����ϵ��� �Ѵ�. �� 28�� ��ȸ�Ǹ� ������ EMPNO �÷������� ��ȸ�ǵ��� ��. 
--(Join���� 1��,Compound Operator ����Ͽ� 1��)

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


--2. �Ʒ��� ���� EMP Table�� �� �ο찡 2���� ��ȸ�ǵ��� �ϵ� GUBUN �÷��� �ξ� ù��° �ο�� �ι�° �ο츦 �����ϴ� �÷��� �д�. �� 28�� ��ȸ�Ǹ� ������ EMPNO �� GUBUN �÷������� ��ȸ�ǵ��� ��. 
--(Join���� 1��,Compound Operator ����Ͽ� 1��)

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



--3. �Ʒ��� ���� EMP Table�� �����Ͽ� �ݳ� �ſ� 1�Ͽ� �ش��ϴ�  SAL_DATE �÷��� ��ȸ�ǵ��� �Ͽ� 2020�⵵ ���� �� 14*12 ���� ��ȸ�ǵ��� ��. 

select  empno,ename,job,
d.month1 as sal_date,
sal
from emp
cross join
(select 
to_char(add_months(to_date(to_char(sysdate,'yyyy')||'01', 'yyyymm'), level - 1),'yyyy-mm-dd') as month1
from dual connect by level <= 12) d;

--4. 3�� ���� ����Ͽ� �Ʒ��� ���� ���� SAL SUM�� �������� �Ͽ� �� 14*12 ���� ��ȸ�ǵ��� ��. ROLLUP ������� ����..

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




