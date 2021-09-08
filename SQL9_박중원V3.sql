----1
create or replace function f_name(f_owner varchar,f_index_name varchar)
    return varchar2
is 
   tempstr varchar2(4000);
   cursor cl_cur is
       
        select column_name
        from dba_ind_columns
        where index_owner = f_owner and
                index_name = f_index_name
        order by column_position;
        cl_rec cl_cur%rowtype;    
begin 
    tempstr:='';
    for cl_rec in cl_cur loop
        tempstr:=tempstr||cl_rec.column_name||',';
    end loop;
    tempstr:= rtrim(tempstr,',');
    return nvl(tempstr,'조건에 맞는 데이터가 없습니다.');
end;




--2
create or replace function f_name2(f_owner varchar,f_table_name varchar)
    return varchar2
is 
   tempstr varchar2(4000);
   cursor tb_cur is
   select ' '||
   column_name ||' '||
    case 
    when data_type='NUMBER'  --숫자일때           
            then 
            data_type ||'('||
                case 
                when (data_scale=0) then to_char(data_precision)
                when (data_scale>0) then data_precision ||','||data_scale
                    end
            ||') ' 
               
    when data_type like 'VARCHAR%' --문자일때
            then
            data_type ||'('||
            data_length||') ' 
               
    when data_type='DATE' --날짜일때
            then
            data_type ||' '                             
     end 
    ||
    case when (nullable='N') then 'NOT NULL ' --
               else ''
               end as name
    from dba_tab_columns
    where table_name=f_table_name
    and owner=f_owner;
    tb_rec tb_cur%rowtype;    
begin 
    tempstr:='';
    for tb_rec in tb_cur loop
        tempstr:=tempstr||tb_rec.name||',';
    end loop;
    tempstr:= rtrim(tempstr,',');
    return nvl(tempstr,'조건에 맞는 결과가 없습니다.');
end;
