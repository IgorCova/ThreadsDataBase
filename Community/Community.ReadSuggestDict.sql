set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure for reading Communities
///</description>
*/
alter procedure [dbo].[Community.ReadSuggestDict]
   @MemberID bigint = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 31.12.2015
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare
     @false bit = cast(0 as bit)

  select
       t.ID
      ,t.Name
      ,t.Link
      ,t.Decription
      ,t.OwnerID
      ,t.CreateDate
      ,@false as IsMember
    from dbo.Community       as t
    join dbo.MemberCommunity as m on m.CommunityID = t.ID
    where t.ClosedDate is null
      and m.MemberID <> @MemberID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Community.ReadSuggestDict]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.ReadSuggestDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for reading Communities'
  ,@Params      = '@MemberID = Member ID'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.ReadSuggestDict]
  @MemberID = 1
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Community.ReadSuggestDict] to [public]
go