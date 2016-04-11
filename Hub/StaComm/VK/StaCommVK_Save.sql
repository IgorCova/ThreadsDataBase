use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go
/*
exec dbo.DropIfExists 'dbo.StaCommVK_Save'
go
*/
-------------------------------------------------------------
-- <PROC> dbo.StaCommVK_Save
-------------------------------------------------------------
alter procedure dbo.StaCommVK_Save
   @groupID              bigint
  ,@requestStartDate     datetime
  ,@commViews            bigint
  ,@commVisitors         bigint
  ,@commReach            bigint
  ,@commReachSubscribers bigint
  ,@commSubscribed       bigint
  ,@commUnsubscribed     bigint
  ,@commLikes            bigint
  ,@commComments         bigint
  ,@commReposts          bigint
  ,@commPostCount        bigint
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
  declare 
     @id     bigint = next value for seq.StaCommVK
    ,@commID bigint

  select top 1 
       @commID = c.id
    from dbo.Comm as c       
    where c.groupID = @groupID

  insert into dbo.StaCommVK ( 
     id
    ,commID
    ,requestStartDate
    ,requestFinishDate
    ,commViews
    ,commVisitors
    ,commReach
    ,commReachSubscribers
    ,commSubscribed
    ,commUnsubscribed
    ,commLikes
    ,commComments
    ,commReposts
    ,commPostCount 
  ) values (
     @id
    ,@commID
    ,@requestStartDate
    ,getdate()
    ,@commViews
    ,@commVisitors
    ,@commReach
    ,@commReachSubscribers
    ,@commSubscribed
    ,@commUnsubscribed
    ,@commLikes
    ,@commComments
    ,@commReposts
    ,@commPostCount 
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
   @ObjSysName  = 'dbo.StaCommVK_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save statistics of community on VKontakte.'
  ,@Params = '
      @requestStartDate = Start date of this request \n
     ,@groupID = id group in VKontakte \n
     ,@commReach = Reach \n
     ,@commReachSubscribers = ReachSubscribers \n
     ,@commSubscribed = Subscribed \n
     ,@commUnsubscribed = Unsubscribed \n
     ,@commViews = Views \n
     ,@commVisitors = Visitors \n 
     ,@commComments = Comments \n
     ,@commLikes = Likes \n
     ,@commReposts = Reposts \n
     ,@commPostCount = Count posts \n'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StaCommVK_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVK_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVK_Save to [public]
