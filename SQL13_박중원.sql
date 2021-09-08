--1. 아래 Script를 수행한 후 아래와 같이 seq 기준으로 위로 연속으로 col1,col2 동일한 값을 가진 row수를 구하시요.
--create table test_0707 
--(seq      number        not null,
-- col1     varchar2(10),
-- col2     varchar2(10));
-- 
-- select * from test_0707 ;
-- insert into test_0707 values (1,'TEST',null);
-- insert into test_0707 values (2,'TEST','P');
-- insert into test_0707 values (3,'TEST','P');
-- insert into test_0707 values (4,'TEST1',null);
-- insert into test_0707 values (5,'TEST','U');
-- insert into test_0707 values (6,'TEST','P');
-- insert into test_0707 values (7,'TEST','P');
-- insert into test_0707 values (8,'TEST','P');
-- insert into test_0707 values (9,'TEST2','P');
-- commit;

 select seq,col1,col2,sum(same_cnt)over(partition by same_cnt order by seq)  as same_cnt   
 from(       
        select seq,col1,col2,same_cnt2 same_cnt,seq-part_temp from 
        (
            select
             nullif( sum(same_cnt2) over (partition by same_cnt2 order by seq) ,0) as part_temp,t1.*
            from(
                select seq,col1,col2,same_cnt2
                from (
                       select seq,
                               col1,
                               col2,
                               col1_lag,
                               col2_lag,
                               (CASE WHEN col1_lag=col1 and col2_lag=col2 then 
                                    same_cnt+1 
                                ELSE same_cnt
                                END)
                              as same_cnt2
                        from 
                        (
                            select seq,
                                    col1,
                                    col2,
                                    lag(col1) over (order by seq) col1_lag,
                                    lag(col2) over (order by seq) col2_lag,
                                    0 as same_cnt
                            from test_0707
                        )
                    ) 
            ) t1
            order by seq
        ) 
)
order by seq


