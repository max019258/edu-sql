 select seq,col1,col2,sum(same_cnt)over(partition by same_cnt order by seq)      
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


