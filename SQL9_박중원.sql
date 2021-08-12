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
