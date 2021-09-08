--1. Owner,Index Name을 Input 값으로 받아 Index Column을 순서대로 
--   List하는 Function을 만들어 보시오. User_ind_columns Dictionary 참조
--  
--  예> SCOTT USER 소유 EMP_IDX1 Index가 COL1,COL2 컬럼으로 구성되어 있다면 
--     select f_name('SCOTT','EMP_IDX1) from dual;
--     ==> COL1,COL2 
create or replace function f_name(f_owner varchar,f_index_name varchar)
    return varchar2
is 
   tempstr varchar2(4000);
   cursor cl_cur is
        select column_name
        from all_ind_columns
        where table_owner = f_owner and
                index_name = f_index_name;
        cl_rec cl_cur%rowtype;    
begin 
    tempstr:='';
    for cl_rec in cl_cur loop
        tempstr:=tempstr||cl_rec.column_name||',';
    end loop;
    tempstr:= rtrim(tempstr,',');
    return tempstr;
end; --



--2. Owner,Table Name을 Input 값으로 받아 Column을 순서대로
--   List하는 Function을 만드는데 Column Name 옆에 Data Type , Length,Not Null 여부도 같이 List 되도록 만들어 보시오. User_tab_columns Dictionary 참조
--   예> SCOTT USER 소유 EMP Table의 경우

create or replace function f_name2(f_owner varchar,f_table_name varchar)
    return varchar2
is 
   tempstr varchar2(4000);
   cursor tb_cur is
   select ' '||
              case 
    when data_type='NUMBER'  --숫자일때
            then 
            column_name ||' '||
            data_type ||'('||
                case 
                when (data_scale=0) then to_char(data_precision)
                when (data_scale>0) then data_precision ||','||data_scale
                    end
            ||') ' ||
                case when (nullable='N') then 'NOT NULL '
                else ''
                end   
    when data_type like 'VARCHAR%' --문자일때
            then
            column_name ||' '||
            data_type ||'('||
            data_length||') ' ||
                case when (nullable='N') then 'NOT NULL '
                else ''
                end  
    when data_type='DATE' --날짜일때
            then
            column_name ||' '||
            data_type ||' '||
                case when (nullable='N') then 'NOT NULL '
                else ''
                end                   
end as name
        from all_tab_columns
        where table_name=f_table_name
        and owner=f_owner;
        tb_rec tb_cur%rowtype;    
begin 
    tempstr:='';
    for tb_rec in tb_cur loop
        tempstr:=tempstr||tb_rec.name||',';
    end loop;
    tempstr:= rtrim(tempstr,',');
    return tempstr;
end;
