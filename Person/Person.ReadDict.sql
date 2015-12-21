set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure read dict of persons
///</description>
*/
alter procedure [dbo].[Person.ReadDict]
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
  -----------------------------------------------------------------

  select
       t.ID
      ,t.Name
      ,t.UserName
      ,concat(t.Name +  ' ', t.Surname) as FullName
      ,t.PhotoLink
      ,t.About
      ,t.JoinedDate
      ,t.LeaveDate
      ,t.LeaveNote
    from dbo.Person as t
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Person.ReadDict]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Person.ReadDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read dict of persons'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Person.ReadDict]

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go 

grant execute on [dbo].[Person.ReadDict] to [public]
go
