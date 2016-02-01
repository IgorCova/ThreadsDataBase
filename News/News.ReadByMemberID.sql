set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// Procedure read news for member
///</description>
*/
alter procedure [dbo].[News.ReadByMemberID]
   @MemberID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 27.12.2015
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------

  select
       e.CommunityID as [Community_ID]
      ,c.Name        as [Community_Name]
      ,e.ID          as [Entry_ID]
      ,m.Name        as [ColumnCommunity_Name]
      ,m.ID          as [ColumnCommunity_ID]
      ,e.EntryText   as [Entry_Text]
      ,e.CreateDate  as [Entry_CreateDate]
    from dbo.MemberCommunity as t
    join dbo.Community       as c on c.ID = t.CommunityID

    join dbo.Entry           as e on e.CommunityID = c.ID

    join dbo.ColumnCommunity as m on m.ID = e.ColumnID 
                                 and m.CommunityID = e.CommunityID
    where t.MemberID = @MemberID
    order by 
       e.CreateDate desc

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[News.ReadByMemberID]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[News.ReadByMemberID]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read news for user.'
  ,@Params = '@MemberID = ID Member'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[News.ReadByMemberID]
   @MemberID = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[News.ReadByMemberID] to [public]
go
