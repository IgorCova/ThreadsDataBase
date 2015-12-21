set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure read entries communities
///</description>
*/
alter procedure [dbo].[Entry.ReadByCommunityID]
   @CommunityID    bigint
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
      ,t.CommunityID
      ,c.Name         as [CommunityID.Name]
      ,t.ColumnID
      ,cc.Name        as [ColumnID.Name]
      ,t.CreatorID
      ,p.FullName     as [CreatorID.FullName]
      ,t.EntryText
      ,t.CreateDate
      ,t.DeleteDate
      ,t.DeleteNote
    from dbo.Entry           as t       
    join dbo.Community       as c on c.ID = t.CommunityID
    join dbo.ColumnCommunity as cc on cc.ID = t.ColumnID
    join dbo.[Person.View]   as p on p.ID = t.CreatorID
    where t.CommunityID = @CommunityID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Entry.ReadByCommunityID]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Entry.ReadByCommunityID]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read entries communities'
  ,@Params = '@CommunityID = id community'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Entry.ReadByCommunityID]
   @CommunityID = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Entry.ReadByCommunityID] to [public]
go