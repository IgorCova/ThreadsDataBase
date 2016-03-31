set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// Procedure read bookmarks for member
///</description>
*/
alter procedure [dbo].[Bookmark.ReadByMemberID]
   @MemberID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 19.03.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------

  select top 25
       e.CommunityID  as Community_ID
      ,c.Name         as Community_Name
      ,e.ID           as Entry_ID
      ,m.Name         as ColumnCommunity_Name
      ,m.ID           as ColumnCommunity_ID
      ,e.EntryText    as Entry_Text
      ,fn.datetime_to_str_ForUser(e.CreateDate)  as Entry_CreateDate
      ,fn.datetime_to_text_ForUser(e.CreateDate) as Entry_CreateDateEst
      ,e.CreatorID    as CreatorID
      ,p.FullName     as CreatorID_Fullname
      ,cast(1 as bit) as IsPin
    from dbo.Bookmark        as t
    join dbo.Entry           as e on e.ID = t.EntryID
    join dbo.Community       as c on c.ID = e.CommunityID
    join dbo.[Member.View]   as p on p.ID = e.CreatorID

    join dbo.ColumnCommunity as m on m.ID = e.ColumnID 
                                 and m.CommunityID = e.CommunityID
    where t.MemberID = @MemberID
    order by 
      t.PinDate desc

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Bookmark.ReadByMemberID]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Bookmark.ReadByMemberID]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read bookmarks for member.'
  ,@Params = '@MemberID = ID Member'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Bookmark.ReadByMemberID]
   @MemberID = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Bookmark.ReadByMemberID] to [public]
go
