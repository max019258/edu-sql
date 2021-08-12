create or replace trigger trig  
    before insert or update or delete 
    on emp
    for each row
declare
   t_username varchar2(30);
   t_action_time date;
   t_action_flag char(1);
   t_rid rowid;
   t_machine varchar2(64);
   t_module varchar2(64);
   pragma autonomous_transaction;
   
begin
    t_username := sys_context( 'userenv','session_user');
    t_machine := sys_context( 'userenv','host');
    t_module := sys_context( 'userenv','module');
    
    if updating then
          t_action_flag := 'u';
          t_rid := :old.rowid;
    elsif inserting then 
          t_action_flag := 'i';
          t_rid := :new.rowid;
    elsif deleting then
          t_action_flag := 'd';
          t_rid := :old.rowid;
    end if;
        
    insert into emp_audit
    values(t_username,sysdate,t_action_flag,t_rid,t_machine,t_module);
    commit;
end;
