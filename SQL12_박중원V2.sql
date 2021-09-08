--1. �Ʒ� Script�� ������ �� year,hakgi,jumin_no,hakbun,name,iphak_ymd,address  �� �� 3���� ���Ͻÿ�.

select year,hakgi,student2.jumin_no,hakbun,name,iphak_ymd,address
from
    (
       select janghak.*,(to_date(year||decode(hakgi,'1','0302','2','0902') ,'yyyymmdd'))as janghak_date
       from janghak
     ) janghak2
 ,
     (select student.*,nvl(lead(iphak_ymd) over(partition by jumin_no order by iphak_ymd),'99991231') as ex_date
    from student) student2
 where student2.JUMIN_NO=janghak2.JUMIN_NO
and janghak_date>=iphak_ymd
and janghak_date<ex_date 
order by hakbun
;

--2. �ζ� ��÷ ��ȣ�� �����Ǵ� Function�� ���Ͻÿ�!!!
--���� ��� �ش� Function�� �����ϸ� 5, 10, 11, 28, 41, 43 + 7 �̷������� �Ź� �ٸ� ���� �������� �ϴ� Function�� �ۼ��Ͻÿ�,

--pl/sql
create or replace function lotto
    return varchar
 is
   result varchar(50);
 begin
        select listagg(decode(row_num,7,'+'||rand,rand),',') within group(order by rownum) rand_lotto
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


--����
select lotto 
 from dual; 

