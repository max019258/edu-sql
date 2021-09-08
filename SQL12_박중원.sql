--1. 아래 Script를 수행한 후 year,hakgi,jumin_no,hakbun,name,iphak_ymd,address  값 총 3건을 구하시요.
 select year,hakgi,jumin_no,hakbun,name,iphak_ymd,address
 from(
     select year,hakgi,student.jumin_no jumin_no,hakbun,name,iphak_ymd,address,pk_janghak,
                max(IPHAK_YMD) over (partition by pk_janghak) max_iphak      
     from (select rownum pk_janghak,janghak.* from janghak) janghak,student
     where janghak.jumin_no=student.jumin_no
     and substr(iphak_ymd,1,4) <= (year||decode(hakgi,'1','0302','2','0902')) 
     order by jumin_no,year
    ) 
    where max_iphak=iphak_ymd;
    
--2. 로또 당첨 번호가 생성되는 Function을 구하시요!!!
--create or replace function func_lotto
--    return varchar
-- is
--    type va_type is varray(7) of varchar2(50);
--    i number:=0;
--    j number;
--    result varchar(50):='';
--    arr va_type;
-- begin
--    arr := va_type('','','','','','','');
--    loop
--        i:=i+1;
--        if i>7 then
--            exit;
--        end if;            
--        select to_char(ceil(dbms_random.value(1,45)))
--        into arr(i)
--        from dual;
--        j:=0;
--        loop
--            j:=j+1;
--            if j=i then
--                exit;
--            end if;
--            if arr(i)=arr(j) then
--                i:=i-1;
--            end if;
--        end loop;   
--    end loop;
--    i:=0;
--    loop 
--        i:=i+1;
--         if i>7 then
--            exit;
--        end if; 
--        if i=7 then
--           result := result||'  +'||arr(i);
--        else 
--            result := result||'  '||arr(i);
--        end if;
--    end loop;
--    return result;
-- end;

  --실행
select func_lotto() from dual;
