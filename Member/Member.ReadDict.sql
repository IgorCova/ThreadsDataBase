set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure read dict of Members
///</description>
*/
alter procedure [dbo].[Member.ReadDict]
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
      ,t.About
      ,t.IsMale
      ,t.JoinedDate
      ,t.LeaveDate
      ,t.LeaveNote
    from dbo.Member as t
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Member.ReadDict]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Member.ReadDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read dict of Members'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Member.ReadDict]

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go 

grant execute on [dbo].[Member.ReadDict] to [public]
go
