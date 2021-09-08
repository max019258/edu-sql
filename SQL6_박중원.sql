--1. �Ʒ��� ���� �� empno �� 2���� row�� �����ǵ��� ���� �� 
--�� empno �� 1�Ǹ� ����� ������Ű�� ���� �ۼ��Ͻÿ�.  

--create table emp_dup
--as
--select a.*
--from emp a,
--     (select 1 from emp where rownum <= 2) b;

--<ù��°>
delete from emp_dup e1
where rowid < (select max(rowid) from emp_dup e2 where e1.empno=e2.empno);

--<�ι�°>
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

--2. �Ʒ��� ���� sal_hist table�� ������ ��  �Ʒ��� ���� �Ⱓ�� ��ȸ�ǵ��� �Ͻÿ�. 

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


--3. �Ʒ��� ���� EMP Table�� �����Ͽ� �μ���,�Ⱓ�� �Ҽӵ� �������� ���ϴ� SQL�� �ۼ��Ͻÿ�.

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




