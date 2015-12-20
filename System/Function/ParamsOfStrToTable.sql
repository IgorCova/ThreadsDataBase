set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go
----------------------------------------------
-- <Func> [tf].[ParamsOfStrToTable]
----------------------------------------------
-------------------------------------------
/*
///<description>
/// 
На вход текст 
   @Params = '@поле1 = описание поля1
             ,@поле2 = описание поля2
             ,@поле3 = описание поля3
              .......................
             ,@полеN = описание полеN'
На выход таблица из двух столбцов Name и Value

Name        Value
@поле1      описание поля1
@поле2      описание поля2
@поле3      описание поля3

-- Разделителем между полями явдяется ,@ 
-- Разделителем между полем и описание является первое = 
-- и до следующего ,@ будет считаться описанием поля

///</description>
*/
create function tf.ParamsOfStrToTable(@Params varchar(max))

returns @ret table(Name varchar(1024), value varchar(max), sort_order int identity(1,1))
as
begin
----------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
----------------------------------------------
  declare @ObjectPropertys table (Name varchar(1024) , value varchar(max))  
   
  declare 
     @String    varchar(max) 
    ,@LenString int
    ,@Sep       varchar(2) = '\n'
    ,@PosSep    int    
    ,@LenSep    int    
    ,@Par       varchar(1) = '='
    ,@PosPar    int     
     
  select 
     @Params = fn.trim(replace(replace(replace(@Params, char(13), ''), char(10), ''), char(9), '')) 
    ,@LenSep = len(@Sep)    
    
  while len(@Params) > 0
  begin
    select 
       @PosSep = case 
                   when charindex(@Sep, @Params) > 0 then charindex(@Sep, @Params)
                   else len(@Params) + 1
                 end
     select
       @String = fn.trim(substring(@Params, 0, @PosSep)) 
       
    select 
       @PosPar = charindex(@Par, @String)
      ,@LenString = len(@String) 

    insert into @ObjectPropertys (Name, value) 
    select 
       fn.trim(substring(@String, 0, @PosPar)) as Name
      ,fn.trim(substring(@String, @PosPar + 1, @LenString - @PosPar + 1))	as value  
   
    select @Params = fn.trim(substring(@Params, @PosSep + @LenSep, len(@Params)))
  end
  if exists(select * from @ObjectPropertys) 
  begin
    insert into @ret(Name, value) 
    select 
         case 
           when charindex(',', Name) = 1 then substring(name, 2, len(name)) 
           else name
         end                  as Name
        ,value                as Value
      from @ObjectPropertys
  end
  return
end
go 
grant select on tf.ParamsOfStrToTable to [public]