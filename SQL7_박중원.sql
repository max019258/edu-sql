--1. 아래와 같이 Table 생성,Data를 입력한 후 /질문에 대한 SQL을 최소 각각 3개씩 작성하시요!!!!

--drop table cust_status;
--create table cust_status
-- (cust_id      char(1)      not null,
--  cust_id_seq  number       not null,
--  status       varchar2(10) not null)
-- ;
--insert into cust_status values ('A',1,'정상');
--insert into cust_status values ('A',2,'위험');
--insert into cust_status values ('B',1,'정상');
--insert into cust_status values ('B',2,'정상');
--insert into cust_status values ('C',1,'위험');
--insert into cust_status values ('C',2,'위험');
--insert into cust_status values ('D',1,'위험');
--insert into cust_status values ('D',2,'위험');
--insert into cust_status values ('D',3,'정상');
--insert into cust_status values ('E',1,'정상');
--commit;

select * from cust_status ; --테이블 확인


--Q1>  cust_id 별로 status 값이  한 종류만 가진  cust_id 만 출력

--Q1_정답1
select cust_id
from(
        select cust_id,count(*) over (partition by cust_id) as cnt
        from 
            (select cust_id,status from cust_status group by cust_id,status) cust
     )
where cnt=1;

--Q1_정답2
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
--Q1_정답3
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


--Q2>  cust_id 별로 status 값이  한 종류만 가진  Row 전체를 출력

--Q2_정답1
select cust2.*
from(
        select cust_id,count(*) over (partition by cust_id) as cnt
        from 
            (select cust_id,status from cust_status group by cust_id,status)
     )  cust
     , cust_status cust2
where cust.cust_id = cust2.cust_id and cnt=1;


--Q2_정답2
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

--q2_정답3
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

       
       
 




--2. 아래와 같은 Table을 생성 ,Data를 입력한 후 
--20190101~20191231까지 총 365건이 조회되도록 일자별집계를 구하시요.

--drop table  repay_test;
--
--create table repay_test
-- (REPAY_DATE     varchar(8)    not null,
--  DETR_NM    varchar(10)  not null,
--  RBPO      varchar2(15) not null,
--  LOAN_BAL_AMT number not null) ;
-- 
-- insert into repay_test values ('20190103','홍길동','1234567-1234567',1500000);
-- insert into repay_test values ('20190906','홍길동','1234567-1234567',1000000);
-- insert into repay_test values ('20190909','홍길동','1234567-1234567',500000);
-- -------------------------------------------------------------------
select r_date,nm,rbpo,

nvl(amt,max(amt) over (order by r_date ) )
 from
     (
     select 
        rownumber,
        rownumber2,
        dual2.repay_date r_date,
        dual2.detr_nm nm,
        dual2.RBPO rbpo, 
        repay_test.loan_bal_amt amt
     from
        repay_test
        right outer join
        (   
          select 
            rownum rownumber,
            rownum rownumber2,
            to_char((to_date('20190101','yyyymmdd') + (level - 1)) ,'yyyymmdd') as repay_date,
            '홍길동' as detr_nm,
            '1234567-1234567' as rbpo
          from dual
          connect by level <= 365
        )  dual2
        on  repay_test.REPAY_DATE=dual2.repay_date
        and  repay_test.detr_nm=dual2.detr_nm
        and  repay_test.rbpo=dual2.rbpo 
     order by dual2.repay_date
     )
 
;








