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
   @CommunityID  bigint
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
       0         as ID 
      ,0         as CommunityID
      ,'Non'     as [CommunityID_Name] 
      ,0         as ColumnID
      ,'Non'     as [ColumnID_Name]
      ,0         as CreatorID
      ,'Non'     as [CreatorID_FullName] 
      ,'Non'     as EntryText
      ,getdate() as CreateDate
  union
  select
       t.ID
      ,t.CommunityID
      ,c.Name         as [CommunityID_Name]
      ,t.ColumnID
      ,m.Name        as [ColumnID_Name]
      ,t.CreatorID
      ,p.FullName     as [CreatorID_FullName]
      ,t.EntryText
      ,t.CreateDate
    from dbo.Entry           as t       
    join dbo.Community       as c on c.ID = t.CommunityID
    join dbo.[Person.View]   as p on p.ID = t.CreatorID
    left join dbo.ColumnCommunity as m on m.ID = t.ColumnID 
                                       and m.CommunityID = t.CommunityID
    where t.CommunityID = @CommunityID
      and t.DeleteDate is null
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
  ,@Description = 'Procedure for read entries communities'
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