set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure for reading my Communities
///</description>
*/
alter procedure [dbo].[Community.ReadMyDict]
   @MemberID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 30.12.2015
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
      ,t.Link
      ,t.Decription
      ,t.OwnerID
      ,t.CreateDate
    from dbo.Community as t
    join dbo.MemberCommunity as m on m.CommunityID = t.ID
    where t.ClosedDate is null
      and m.MemberID = @MemberID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Community.ReadMyDict]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.ReadMyDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for reading Communities by member'
  ,@Params     = '@MemberID = Member ID'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.ReadMyDict]
  @MemberID = 2
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Community.ReadMyDict] to [public]
go