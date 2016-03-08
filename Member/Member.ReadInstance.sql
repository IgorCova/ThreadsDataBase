set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure read Instance of Members
///</description>
*/
alter procedure [dbo].[Member.ReadInstance]
   @ID bigint
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
      ,t.Surname
      ,t.UserName
      ,t.About
      ,dbo.FormatPhone(t.Phone) as Phone
      ,t.IsMale
      ,try_convert(varchar, t.BirthdayDate, 111) as BirthdayDate
    from dbo.[Member.View] as t       
    where t.ID = @ID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Member.ReadInstance]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Member.ReadInstance]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read Instance of Member'
  ,@Params = '@ID = ID Member'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Member.ReadInstance]
  @ID = 1
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go 

grant execute on [dbo].[Member.ReadInstance] to [public]
go
