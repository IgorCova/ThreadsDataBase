use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKDaily_Save', 'P'
go

-------------------------------------------------------------
-- <PROC> dbo.StaCommVKDaily_Save
-------------------------------------------------------------
alter procedure dbo.StaCommVKDaily_Save
   @groupID              bigint
  ,@dayDate              datetime
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
  ,@commPhotoLink        varchar(512)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 16.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @dayDate = cast(@dayDate as date)

  ----------------------------------------
  begin tran StaCommVKDaily_Save
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
      from dbo.StaCommVKDaily as t
      join dbo.Comm as c on c.id = t.commID
      where c.groupID = @groupID 
        and t.dayDate = @dayDate

      insert into dbo.StaCommVKDaily ( 
         id
        ,commID
        ,dayDate
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
           next value for seq.StaCommVKDaily
          ,c.id
          ,@dayDate
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
          select * from dbo.StaCommVKDaily as s
            where s.commID = c.id 
              and s.dayDate = @dayDate)
   
    update dbo.Comm set    
         photoLink = @commPhotoLink
      where groupID = @groupID
  ----------------------------------------
  commit tran StaCommVKDaily_Save
  ---------------------------------------- 
  -----------------------------------------------------------------
end
go
---------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKDaily_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save statistics of community on VKontakte.'
  ,@Params = '
     ,@dayDate = daily report \n
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
     ,@commMembers = count members \n
     ,@commPhotoLink = link to photo'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StaCommVKDaily_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKDaily_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKDaily_Save to [public]
