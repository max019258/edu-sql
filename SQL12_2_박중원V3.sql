create or replace function lotto
    return varchar
 is
   result varchar(50);
 begin
        select 
        replace(listagg(decode(row_num,7,'+'||rand,rand),',') within group(order by rownum) ,',+',' +')
        into result
        from
        (
            select ran as rand , row_num
            from(
                    select ran,rownum row_num
                    from
                    (
                        select distinct trunc(dbms_random.value(1,45)) as ran
                        from dual
                        connect by level <= 1000
                        order by dbms_random.value
                    )
                )
            where row_num<8
            order by (case when row_num<7 then 1 else 2 end), rand asc
        );
    return result;
 end;
