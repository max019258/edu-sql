--�Ʒ� Table�� EMP Table�� DML �۾��� ������ ������ �Է��ϴ� Trigger�� �ۼ��Ͻÿ�.
-- (�� �����ϰų� Rollback�� ��쿡�� �Էµǵ��� �Ͻÿ�.)

--create table emp_audit
-- (username   varchar2(30),   
--  action_time date,
--  action_flag char(1),
--  rid         rowid,
--  machine     varchar2(64), -- session �������� ���̴� machine name
--  module      varchar2(64)); -- session �������� ���̴� module name
  

--==> action_flag  column���� Update�� 'U',Insert�� 'I',Delete�� 'D'
--     rid column���� Update�� old.rowid,Insert�� new.rowid,Delete�� old.rowid ���� ���� ��


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