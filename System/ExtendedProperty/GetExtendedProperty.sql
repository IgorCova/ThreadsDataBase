set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <PROC> [dbo].[GetExtendedProperty]
----------------------------------------------
/*
///<description>
///Просмотр расширенных свойств (ExtendedProperty) объекта в MS SQL Server
///</description>
*/
alter procedure [dbo].[GetExtendedProperty]
-- v1.0
  -- of(Object):   
   @ObjSysName     sysname
 
  ,@debug_info     int          = 0
with execute as owner 
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  set ansi_padding on
  -----------------------------------------------------------------
  declare
     @res     int      -- для Return-кодов вызываемых процедур.
    ,@ret     int      -- для хранения Return-кода данной процедуры.
    ,@err     int      -- для хранения @@error-кода после вызовов процедур.
    ,@cnt     int      -- для хранения количеств обрабатываемых записей.
    ,@ErrMsg  varchar(1000) -- для формирования сообщений об ошибках  
    
  --------------------------------------   
  select 
       cast(p.name as varchar(256))  as [name]
      ,cast(p.value as varchar(max)) as [value]    
    from sys.objects as s
    inner join sys.extended_properties as p on p.major_id = s.object_id
                                      and p.minor_id = 0
                                      and p.class = 1
                                      and p.name is not null
    where s.[object_id] = object_id(@ObjSysName)    
   
  -----------------------------------------------------------------
  -- End Point
  select @ret = 0
  return (@ret)
end
go
----------------------------------------------
-- <WRAPPER>
----------------------------------------------
exec [dbo].[Procedure.NativeCheck] '[dbo].[GetExtendedProperty]'
go
----------------------------------------------
-- <Filling Extended Property>
----------------------------------------------
exec dbo.FillExtendedProperty
	 @ObjSysName = '[dbo].[GetExtendedProperty]'
	,@Author = 'Cova Igor'
	,@Description = 'Просмотр расширенных свойств (ExtendedProperty) объекта в MS SQL Server.'
	,@Params = '@ObjSysName = Имя обьекта в MS SQL Server. \n'
go

/* ОТЛАДКА: dbo.dbo_GetExtendedProperty
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[GetExtendedProperty] 
   @ObjSysName    = 'dbo.[GetExtendedProperty]'      
  
  ,@debug_info      = 1 --0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
