--1. �Ʒ��� ���� Table ����,Data�� �Է��� �� /������ ���� SQL�� �ּ� ���� 3���� �ۼ��Ͻÿ�!!!!

--drop table cust_status;
--create table cust_status
-- (cust_id      char(1)      not null,
--  cust_id_seq  number       not null,
--  status       varchar2(10) not null)
-- ;
--insert into cust_status values ('A',1,'����');
--insert into cust_status values ('A',2,'����');
--insert into cust_status values ('B',1,'����');
--insert into cust_status values ('B',2,'����');
--insert into cust_status values ('C',1,'����');
--insert into cust_status values ('C',2,'����');
--insert into cust_status values ('D',1,'����');
--insert into cust_status values ('D',2,'����');
--insert into cust_status values ('D',3,'����');
--insert into cust_status values ('E',1,'����');
--commit;

select * from cust_status ; --���̺� Ȯ��


--Q1>  cust_id ���� status ����  �� ������ ����  cust_id �� ���

--Q1_����1
select cust_id
from(
        select cust_id,count(*) over (partition by cust_id) as cnt
        from 
            (select cust_id,status from cust_status group by cust_id,status) cust
     )
where cnt=1;

--Q1_����2
select distinct cust_id
from cust_status
where cust_id not in
(
    select cust_id
    from(
            select cust_id,row_number() over (partition by cust_id order by cust_id) as cnt
            from 
                (select cust_id,status from cust_status group by cust_id,status) cust
         )
    where cnt=2
);
--Q1_����3
select distinct cust_id
from cust_status
where cust_id not in
(
    select cust_id
    from(
            select cust.* ,max(status)over(partition by cust_id) as max_cust
            from cust_status cust
        )
    where max_cust!=status
)
;


select * from cust_status;


--Q2>  cust_id ���� status ����  �� ������ ����  Row ��ü�� ���

--Q2_����1
select cust2.*
from(
        select cust_id,count(*) over (partition by cust_id) as cnt
        from 
            (select cust_id,status from cust_status group by cust_id,status)
     )  cust
     , cust_status cust2
where cust.cust_id = cust2.cust_id and cnt=1;


--Q2_����2
select cust2.*
from(
    select distinct cust_id
    from cust_status
    where cust_id not in
    (
        select cust_id
        from(
                select cust_id,row_number() over (partition by cust_id order by cust_id) as cnt
                from 
                    (select cust_id,status from cust_status group by cust_id,status) cust
             )
        where cnt=2
    )    ) cust
    , cust_status cust2
where cust.cust_id = cust2.cust_id 
;

--q2_����3
select cust2.*
from(
select distinct cust_id
from cust_status
where cust_id not in
(
    select cust_id
    from(
            select cust.* ,max(status)over(partition by cust_id) as max_cust
            from cust_status cust
        )
    where max_cust!=status
) ) cust
    , cust_status cust2
where cust.cust_id = cust2.cust_id 
;

       
       
 




--2. �Ʒ��� ���� Table�� ���� ,Data�� �Է��� �� 
--20190101~20191231���� �� 365���� ��ȸ�ǵ��� ���ں����踦 ���Ͻÿ�.

drop table  repay_test;
--
create table repay_test
 (REPAY_DATE     varchar(8)    not null,
  DETR_NM    varchar(10)  not null,
  RBPO      varchar2(15) not null,
  LOAN_BAL_AMT number not null) ; 
 insert into repay_test values ('20190103','ȫ�浿','1234567-1234567',1500000);
 insert into repay_test values ('20190906','ȫ�浿','1234567-1234567',1000000);
 insert into repay_test values ('20190909','ȫ�浿','1234567-1234567',500000);
-- -------------------------------------------------------------------


select tot_date,detr_nm,rbpo,
nvl(
nvl(amt, 
    (
        select loan_bal_amt
        from REPAY_TEST
        where repay_date=
        (
            select max(repay_date) 
            from repay_test
            where REPAY_date<tot_date and loan_bal_amt is not null
        )
    )
)
 ,0)as amt
from(
    select 
        tot_date,detr_nm,rbpo,
        (select loan_bal_amt from REPAY_TEST where repay_date=tot_date) as amt
        
    from(     
        select 
            to_char((to_date('20190101','yyyymmdd') + (level - 1)) ,'yyyymmdd') as tot_date,
            r_t2.detr_nm,    
           r_t2.rbpo     
         from dual,
            (select max(detr_nm) detr_nm,max(rbpo) as rbpo from repay_test r_t) r_t2
         connect by level <= 365
         order by tot_date
    ) from2 --�������̺�
);





