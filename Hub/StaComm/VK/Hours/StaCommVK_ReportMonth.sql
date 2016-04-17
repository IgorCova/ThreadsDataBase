use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVK_ReportMonth', 'P'
go

alter procedure dbo.StaCommVK_ReportMonth
   @ownerHubID     bigint
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
  ----------------------------------------------------------------
  declare 
     @today   date = cast(getdate() as date)
    ,@monthday date = eomonth(cast(dateadd(month, -1, getdate()) as date)) -- date end of the previous Month's 

  select
       comm_id             = t.id
      ,comm_name           = t.name
      ,comm_groupID        = t.groupID

      ,subjectComm_name    = b.name
      ,areaComm_code       = a.code

      ,adminComm_fullName  = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB    = d.linkFB

      ,members                    = c.commMembers
      ,membersNew                 = s.commMembers - c.commMembers
      ,membersNewPercent          = cast( cast(s.commMembers as numeric(16, 2)) / ( cast((s.commMembers - c.commMembers) as numeric(16, 2))* 100)as numeric(16, 2))

      ,subscribed                 = c.commSubscribed
      ,subscribedNew              = s.commSubscribed - c.commSubscribed
      ,subscribedNewPercent       = cast( cast(s.commSubscribed as numeric(16, 2)) / ( cast((s.commSubscribed - c.commSubscribed) as numeric(16, 2))* 100)as numeric(16, 2))

      ,unsubscribed               = c.commUnsubscribed
      ,unsubscribedNew            = s.commUnsubscribed - c.commUnsubscribed
      ,unsubscribedNewPercent     = cast( cast(s.commUnsubscribed as numeric(16, 2)) / ( cast((s.commUnsubscribed - c.commUnsubscribed) as numeric(16, 2))* 100)as numeric(16, 2))

      ,visitors                   = c.commVisitors
      ,visitorsNew                = s.commVisitors - c.commVisitors
      ,visitorsNewPercent         = cast( cast(s.commVisitors as numeric(16, 2)) / ( cast((s.commVisitors - c.commViews) as numeric(16, 2))* 100)as numeric(16, 2))

      ,[views]                    = c.commViews
      ,viewsNew                   = s.commViews - c.commViews
      ,viewsNewPercent            = cast( cast(s.commViews as numeric(16, 2)) / (cast((s.commViews - c.commViews) as numeric(16, 2)) * 100) as numeric(16, 2)) 

      ,reach                      = c.commReach
      ,reachNew                   = s.commReach - c.commReach
      ,reachNewPercent            = cast( cast(s.commReach as numeric(16, 2)) / (cast((s.commReach - c.commReach) as numeric(16, 2)) * 100) as numeric(16, 2))

      ,reachSubscribers           = c.commReachSubscribers
      ,reachSubscribersNew        = s.commReachSubscribers - c.commReachSubscribers
      ,reachSubscribersNewPercent = cast( cast(s.commReachSubscribers as numeric(16,2)) / ( cast( (s.commReachSubscribers - c.commReachSubscribers) as numeric(16, 2)) * 100) as numeric(16, 2))

      ,postCount                  = c.commPostCount
      ,postCountNew               = s.commPostCount - c.commPostCount
      ,postCountNewPercent        = cast( cast(s.commPostCount as numeric(16, 2)) / ( cast((s.commPostCount - c.commPostCount) as numeric(16, 2))* 100)as numeric(16, 2))
      
      ,likes                      = c.commLikes
      ,likesNew                   = s.commLikes - c.commLikes 
      ,likesNewPercent            = cast( cast(s.commLikes as numeric(16, 2)) / (cast((s.commLikes - c.commLikes) as numeric(16, 2)) * 100) as numeric(16, 2))

      ,comments                   = c.commComments
      ,commentsNew                = s.commComments - c.commComments
      ,commentsNewPercent         = cast( cast(s.commComments as numeric(16, 2)) / ( cast((s.commComments - c.commComments) as numeric(16, 2))* 100)as numeric(16, 2)) 

      ,reposts                    = c.commReposts
      ,repostsNew                 = s.commReposts - c.commReposts
      ,repostsPercent             = cast( cast(s.commReposts as numeric(16, 2)) / ( cast((s.commReposts - c.commReposts) as numeric(16, 2)) * 100)as numeric(16, 2))      
    from dbo.Comm             as t
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID

    outer apply (
      select
           max(s.commLikes) as commLikes
          ,max(s.commComments) as commComments
          ,max(s.commReposts) as commReposts
          ,max(s.commSubscribed) as commSubscribed
          ,max(s.commUnsubscribed) as commUnsubscribed
          ,max(s.commViews) as commViews
          ,max(s.commVisitors) as commVisitors
          ,max(s.commReach) as commReach
          ,max(s.commReachSubscribers) as commReachSubscribers
          ,max(s.commPostCount) as commPostCount
          ,max(s.commMembers) as commMembers
        from dbo.StaCommVK as s    
        where s.commID = t.id 
          and s.requestDate = @monthday
    ) as c

    outer apply (
      select
           max(s.commLikes) as commLikes
          ,max(s.commComments) as commComments
          ,max(s.commReposts) as commReposts
          ,max(s.commSubscribed) as commSubscribed
          ,max(s.commUnsubscribed) as commUnsubscribed
          ,max(s.commViews) as commViews
          ,max(s.commVisitors) as commVisitors
          ,max(s.commReach) as commReach
          ,max(s.commReachSubscribers) as commReachSubscribers
          ,max(s.commPostCount) as commPostCount
          ,max(s.commMembers) as commMembers
        from dbo.StaCommVK as s    
        where s.commID = t.id 
          and s.requestDate = @today
    ) as s
    where t.ownerHubID = @ownerHubID
-----------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommVK_ReportMonth'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVK_ReportMonth'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with month dynamic statistic on Vkontakte by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVK_ReportMonth 
  @ownerHubId = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVK_ReportMonth to [public]
