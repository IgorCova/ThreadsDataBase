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
/// View ExtendedProperty object in MS SQL Server
///</description>
*/
alter procedure dbo.GetExtendedProperty
-- v1.0
  -- of(Object):   
   @ObjSysName     sysname
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
  --------------------------------------   
  select 
       cast(p.name as varchar(256))  as [name]
      ,cast(p.value as varchar(max)) as [value]    
    from sys.objects             as s
    join sys.extended_properties as p on p.major_id = s.object_id
                                     and p.minor_id = 0
                                     and p.class = 1
                                     and p.name is not null
    where s.[object_id] = object_id(@ObjSysName)    

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <[NativeCheck]>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[GetExtendedProperty]'
go

----------------------------------------------
-- <Filling Extended Property>
----------------------------------------------
exec dbo.FillExtendedProperty
	 @ObjSysName = '[dbo].[GetExtendedProperty]'
	,@Author = 'Cova Igor'
	,@Description = 'View ExtendedProperty object in MS SQL Server'
	,@Params = '@ObjSysName = Name object in MS SQL Server. \n'
go

/* Debugger: dbo.dbo_GetExtendedProperty
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[GetExtendedProperty] 
   @ObjSysName    = 'dbo.[GetExtendedProperty]'      

select @err = @@error
select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
go
--*/

