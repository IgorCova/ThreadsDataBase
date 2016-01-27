set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// Procedure read news for user
///</description>
*/
alter procedure [dbo].[News.ReadByPersonID]
   @PersonID bigint
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
       e.CommunityID as CommunityID
      ,c.Name        as [CommunityID.Name]
      ,e.ID          as [EntryID]
      ,m.Name        as [ColumnCommunityID.Name]
      ,e.EntryText   as [EntryID.EntryText]
      ,e.CreateDate  as [EntryID.CreateDate]
    from dbo.PersonCommunity as t
    join dbo.Community       as c on c.ID = t.CommunityID

    join dbo.Entry           as e on e.CommunityID = c.ID

    join dbo.ColumnCommunity as m on m.ID = e.ColumnID 
                                 and m.CommunityID = e.CommunityID
    where t.PersonID = @PersonID
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
exec [dbo].[NativeCheck] '[dbo].[News.ReadByPersonID]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[News.ReadByPersonID]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure read news for user.'
  ,@Params = '@PersonID = ID Person'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[News.ReadByPersonID]
   @PersonID = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[News.ReadByPersonID] to [public]
go
