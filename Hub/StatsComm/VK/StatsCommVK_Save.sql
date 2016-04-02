use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.DropIfExists 'dbo.StatsCommVK_Save'
go

-------------------------------------------------------------
-- <PROC> dbo.StatsCommVK_Save
-------------------------------------------------------------
create procedure dbo.StatsCommVK_Save
   @ownerHubID           bigint
  ,@commID               bigint
  ,@commViews            bigint
  ,@commVisitors         bigint
  ,@commReach            bigint
  ,@commReachSubscribers bigint
  ,@commSubscribed       bigint
  ,@commUnsubscribed     bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 01.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare @id bigint = next value for seq.StatsCommVK

  insert into dbo.StatsCommVK ( 
     id
    ,ownerHubID
    ,requestDate
    ,commViews
    ,commVisitors
    ,commReach
    ,commReachSubscribers
    ,commSubscribed
    ,commUnsubscribed
    ,commID 
  ) values (
     @id
    ,@ownerHubID
    ,getdate()
    ,@commViews
    ,@commVisitors
    ,@commReach
    ,@commReachSubscribers
    ,@commSubscribed
    ,@commUnsubscribed
    ,@commID 
  )
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StatsCommVK_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save stats of community on VK.'
  ,@Params = '
     ,@ownerHubID = owner Hub id \n
     ,@commID = id comm \n
     ,@commReach = Reach \n
     ,@commReachSubscribers = ReachSubscribers \n
     ,@commSubscribed = Subscribed \n
     ,@commUnsubscribed = Unsubscribed \n
     ,@commViews = Views \n
     ,@commVisitors = Visitors \n '
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StatsCommVK_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StatsCommVK_Save 
   @MemberID = 1
  ,@EntryID = 410  

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StatsCommVK_Save to [public]
