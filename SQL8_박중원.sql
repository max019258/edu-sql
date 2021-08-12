--아래 Table에 EMP Table에 DML 작업을 수행한 정보를 입력하는 Trigger를 작성하시요.
-- (단 실패하거나 Rollback한 경우에도 입력되도록 하시요.)

--create table emp_audit
-- (username   varchar2(30),   
--  action_time date,
--  action_flag char(1),
--  rid         rowid,
--  machine     varchar2(64), -- session 정보에서 보이는 machine name
--  module      varchar2(64)); -- session 정보에서 보이는 module name
  

--==> action_flag  column에는 Update는 'U',Insert는 'I',Delete는 'D'
--     rid column에는 Update는 old.rowid,Insert는 new.rowid,Delete는 old.rowid 값을 넣을 것


create or replace trigger trig  
    before insert or update or delete 
    on emp
    for each row
declare

   pragma autonomous_transaction;
begin
if inserting then
    insert into  emp_audit
    values(
    sys_context( 'userenv','session_user')
    ,sysdate
    ,'i'
    ,:new.rowid
    ,sys_context( 'userenv','host')
    ,sys_context( 'userenv','module'));
    commit;
elsif updating then 
     insert into emp_audit
    values(
    sys_context( 'userenv','session_user')
    ,sysdate
    ,'u'
    ,:old.rowid
    ,sys_context( 'userenv','host')
    ,sys_context( 'userenv','module'));
    commit;

elsif deleting then 
     insert into emp_audit
    values(
    sys_context( 'userenv','session_user')
    ,sysdate
    ,'d'
    ,:old.rowid
    ,sys_context( 'userenv','host')
    ,sys_context( 'userenv','module'));
    commit;
end if;
exception
when others then
    if inserting then
        insert into  emp_audit
        values(
        sys_context( 'userenv','session_user')
        ,sysdate
        ,'i'
        ,:new.rowid
        ,sys_context( 'userenv','host')
        ,sys_context( 'userenv','module'));
        commit;
    elsif updating then 
         insert into emp_audit
        values(
        sys_context( 'userenv','session_user')
        ,sysdate
        ,'u'
        ,:old.rowid
        ,sys_context( 'userenv','host')
        ,sys_context( 'userenv','module'));
        commit;

    elsif deleting then 
         insert into emp_audit
        values(
        sys_context( 'userenv','session_user')
        ,sysdate
        ,'d'
        ,:old.rowid
        ,sys_context( 'userenv','host')
        ,sys_context( 'userenv','module'));
        commit;
    end if;
end;