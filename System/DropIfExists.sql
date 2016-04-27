set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
    concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.DropIfExists 'dbo.DropIfExists'
go

-------------------------------------------------------------
-- <PROC> dbo.DropIfExists
-------------------------------------------------------------
create procedure dbo.DropIfExists
   @objName sysname
as
begin
-------------------------------------------------------------
-- v1.0: Created by Cova Igor 01.04.2015
-------------------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare 
      @typeObj varchar(32)
     ,@name    sysname
     ,@sql     nvarchar(500)
     
  select
       @typeObj = o.[type]
      ,@name = o.name
    from sys.objects as o       
    where o.[object_id] = object_id(@objName)
  
  if @typeObj in ('P', 'PC')
  begin
    set @sql = 'drop procedure ' + @name
    execute sp_executesql @sql
  end
  else if @typeObj = 'FN'
  begin
    set @sql = 'drop function ' + @name
    execute sp_executesql @sql
  end /*
  else if @typeObj = 'U'
  begin
    set @sql = 'drop table ' + @name
    execute sp_executesql @sql
  end*/

  --select * from sys.objects as o
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.DropIfExists'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Native check for procedure'
  ,@Params = '
     @objName = System name object \n'
go
/*
-------------------------------------------------------------
-- <DropIfExists>
-------------------------------------------------------------
exec dbo.DropIfExists 
  @procname = 'dbo.DropIfExists'
go
*/