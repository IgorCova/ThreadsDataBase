set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
    concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-------------------------------------------------------------
-- <PROC> dbo.[NativeCheck]
-------------------------------------------------------------
alter procedure dbo.[NativeCheck]
   @procname sysname
as
begin
-------------------------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
-------------------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  ------------------------------------
  --|| In to print fall notification about fill Extended Properties db object
  exec dbo.GetBlankExtendedProperty
    @ObjSysName  = @procname

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.[NativeCheck]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Native check for procedure'
  ,@Params = '
     @procname = System name procedure \n'
go

-------------------------------------------------------------
-- <[NativeCheck]>
-------------------------------------------------------------
exec dbo.[NativeCheck] 
  @procname = 'dbo.[NativeCheck]'
go
