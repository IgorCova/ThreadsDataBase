use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKWeekly_Save', 'P'
go

-------------------------------------------------------------
-- <PROC> dbo.StaCommVKWeekly_Save
-------------------------------------------------------------
alter procedure dbo.StaCommVKWeekly_Save
   @groupID              bigint
  ,@weekDate             datetime
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
  ,@commMembers          int
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 30.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @weekDate = cast(@weekDate as date)

  ----------------------------------------
  begin tran StaCommVKWeekly_Save
  ----------------------------------------
    update t set    
         t.commViews            = @commViews
        ,t.commVisitors         = @commVisitors
        ,t.commReach            = @commReach
        ,t.commReachSubscribers = @commReachSubscribers
        ,t.commSubscribed       = @commSubscribed
        ,t.commUnsubscribed     = @commUnsubscribed
        ,t.commLikes            = @commLikes
        ,t.commComments         = @commComments
        ,t.commReposts          = @commReposts
        ,t.commPostCount        = @commPostCount
        ,t.commMembers          = @commMembers
        ,t.requestDate          = getdate()  
        ,t.cntReq               = (t.cntReq + 1)
      from dbo.StaCommVKWeekly as t
      join dbo.Comm as c on c.id = t.commID
      where c.groupID = @groupID 
        and t.weekDate = @weekDate

      insert into dbo.StaCommVKWeekly ( 
         id
        ,commID
        ,weekDate
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
        ,commMembers
        ,requestDate 
        ,cntReq
      )
      select
           next value for seq.StaCommVKWeekly
          ,c.id
          ,@weekDate
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
          ,@commMembers
          ,getdate()
          ,1
      from dbo.Comm as c
      where c.groupID = @groupID
        and not exists (
          select * from dbo.StaCommVKWeekly as s
            where s.commID = c.id 
              and s.weekDate = @weekDate)
  ----------------------------------------
  commit tran StaCommVKWeekly_Save
  ---------------------------------------- 
  -----------------------------------------------------------------
end
go
---------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKWeekly_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save statistics of community on VKontakte.'
  ,@Params = '
     ,@weekDate = weekly report date from \n
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
     ,@commPostCount = Count posts \n
     ,@commMembers = count members \n'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StaCommVKWeekly_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKWeekly_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKWeekly_Save to [public]
