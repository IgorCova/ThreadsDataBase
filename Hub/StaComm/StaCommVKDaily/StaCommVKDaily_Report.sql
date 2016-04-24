use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKDaily_Report', 'P'
go

alter procedure dbo.StaCommVKDaily_Report
   @ownerHubID bigint = null
  ,@isPast     bit    = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 24.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  ----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'GetReport', 'dbo.StaCommVKDaily_Report'
  -----------------------------------------------------------------
  declare 
     @startDate date = iif(@isPast = 1, cast(getdate()-1 as date),  cast(getdate() as date))
    ,@endDate   date = iif(@isPast = 1, cast(getdate()-2 as date),  cast(getdate() -1 as date))

  select
       comm_id                   = t.id
      ,comm_name                 = t.name
      ,comm_photoLink            = isnull(t.photoLink , '')
      ,comm_groupID              = t.groupID
 
      ,subjectComm_name          = b.name
      ,areaComm_code             = a.code

      ,adminComm_fullName        = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB          = d.linkFB
      ,lastRequestDate           = s.requestDate

      ,subscribed                = isnull(0, 0)     
      ,subscribedNew             = isnull(s.commSubscribed, 0)
      ,subscribedOld             = isnull(v.commSubscribed, 0)
      ,subscribedDif             = isnull(f.commSubscribed, 0)
      ,subscribedDifPercent      = cast(isnull(f.commSubscribed * 100.00 / nullif(v.commSubscribed, 0), 0) as numeric(16, 0))

      ,unsubscribed              = isnull(0, 0)
      ,unsubscribedNew           = isnull(s.commUnsubscribed, 0)
      ,unsubscribedOld           = isnull(v.commUnsubscribed, 0)
      ,unsubscribedDif           = isnull(f.commUnsubscribed, 0)
      ,unsubscribedDifPercent    = cast(isnull(f.commUnsubscribed * 100.00 / nullif(v.commUnsubscribed, 0), 0) as numeric(16, 0))

      ,visitors                  = isnull(0, 0)
      ,visitorsNew               = isnull(s.commVisitors, 0)
      ,visitorsOld               = isnull(v.commVisitors, 0)
      ,visitorsDif               = isnull(f.commVisitors, 0)
      ,visitorsDifPercent        = cast(isnull(f.commVisitors * 100.00 / nullif(v.commVisitors, 0), 0) as numeric(16, 0))

      ,views                     = isnull(0, 0)
      ,viewsNew                  = isnull(s.commViews, 0)
      ,viewsOld                  = isnull(v.commViews, 0)
      ,viewsDif                  = isnull(f.commViews, 0)
      ,viewsDifPercent           = cast(isnull(f.commViews * 100.00 / nullif(v.commViews, 0), 0) as numeric(16, 0))

      ,members                   = isnull(0, 0)
      ,membersNew                = isnull(s.commMembers, 0)
      ,membersOld                = isnull(v.commMembers, 0)
      ,membersDif                = isnull(f.commMembers, 0)
      ,membersDifPercent         = cast(isnull(f.commMembers * 100.00 / nullif(v.commMembers, 0), 0) as numeric(16, 0))

      ,postCount                 = isnull(0, 0)
      ,postCountNew              = isnull(v.commPostCount, 0)
      ,postCountOld              = isnull(v.commPostCount, 0)
      ,postCountDif              = isnull(f.commPostCount, 0)
      ,postCountDifPercent       = cast(isnull(f.commPostCount * 100.00 / nullif(v.commPostCount, 0), 0) as numeric(16, 0))

      ,likes                     = isnull(0 , 0)     
      ,likesNew                  = isnull(s.commLikes, 0)
      ,likesOld                  = isnull(v.commLikes, 0)
      ,likesDif                  = isnull(f.commLikes, 0)
      ,likesDifPercent           = cast(isnull(f.commLikes * 100.00 / nullif(v.commLikes, 0), 0) as numeric(16, 0))

      ,comments                  = isnull(0, 0)
      ,commentsNew               = isnull(s.commComments, 0)
      ,commentsOld               = isnull(v.commComments, 0)
      ,commentsDif               = isnull(f.commComments, 0)
      ,commentsDifPercent        = cast(isnull(f.commComments * 100.00 / nullif(v.commComments, 0), 0) as numeric(16, 0))

      ,reposts                   = isnull(0, 0)
      ,repostsNew                = isnull(s.commReposts, 0)
      ,repostsOld                = isnull(v.commReposts, 0)
      ,repostsDif                = isnull(f.commReposts, 0)
      ,repostsDifPercent         = cast(isnull(f.commReposts * 100.00 / nullif(v.commReposts, 0), 0) as numeric(16, 0))

      ,reach                     = isnull(0, 0)
      ,reachNew                  = isnull(s.commReach, 0)
      ,reachOld                  = isnull(v.commReach, 0)
      ,reachDif                  = isnull(f.commReach, 0)
      ,reachDifPercent           = cast(isnull(f.commReach * 100.00 / nullif(v.commReach, 0), 0) as numeric(16, 0))

      ,reachSubscribers          = isnull(0, 0)
      ,reachSubscribersNew       = isnull(s.commReachSubscribers, 0)
      ,reachSubscribersOld       = isnull(v.commReachSubscribers, 0)
      ,reachSubscribersDif       = isnull(f.commReachSubscribers, 0)
      ,reachSubscribersDifPercent= cast(isnull(f.commReachSubscribers * 100.00 / nullif(v.commReachSubscribers, 0), 0) as numeric(16, 0))
    from dbo.Comm             as t
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID
    outer apply (
      select
           s.commLikes             as commLikes
          ,s.commComments          as commComments
          ,s.commReposts           as commReposts
          ,s.commSubscribed        as commSubscribed
          ,s.commUnsubscribed      as commUnsubscribed
          ,s.commViews             as commViews
          ,s.commVisitors          as commVisitors
          ,s.commReach             as commReach
          ,s.commReachSubscribers  as commReachSubscribers
          ,s.commPostCount         as commPostCount
          ,s.commMembers           as commMembers
          ,s.requestDate           as requestDate
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and s.dayDate = @startDate
    ) as s

    outer apply (
      select
           s.commLikes             as commLikes
          ,s.commComments          as commComments
          ,s.commReposts           as commReposts
          ,s.commSubscribed        as commSubscribed
          ,s.commUnsubscribed      as commUnsubscribed
          ,s.commViews             as commViews
          ,s.commVisitors          as commVisitors
          ,s.commReach             as commReach
          ,s.commReachSubscribers  as commReachSubscribers
          ,s.commPostCount         as commPostCount
          ,s.commMembers           as commMembers
        from dbo.StaCommVKDaily as s       
        where s.commID = t.id 
          and s.dayDate = @endDate
    ) as v

    outer apply (
      select
           commLikes            = cast((s.commLikes            - v.commLikes)            as numeric(16,2)) 
          ,commComments         = cast((s.commComments         - v.commComments)         as numeric(16,2))
          ,commReposts          = cast((s.commReposts          - v.commReposts)          as numeric(16,2))
          ,commSubscribed       = cast((s.commSubscribed       - v.commSubscribed)       as numeric(16,2))
          ,commUnsubscribed     = cast((s.commUnsubscribed     - v.commUnsubscribed)     as numeric(16,2))
          ,commViews            = cast((s.commViews            - v.commViews)            as numeric(16,2))
          ,commVisitors         = cast((s.commVisitors         - v.commVisitors)         as numeric(16,2))
          ,commReach            = cast((s.commReach            - v.commReach)            as numeric(16,2))
          ,commReachSubscribers = cast((s.commReachSubscribers - v.commReachSubscribers) as numeric(16,2))
          ,commPostCount        = cast((s.commPostCount        - v.commPostCount)        as numeric(16,2))
          ,commMembers          = cast((s.commMembers          - v.commMembers)          as numeric(16,2))
    ) as f
    where t.ownerHubID = iif(@ownerHubID = 1, t.ownerHubID, @ownerHubID)
-----------------------------------------------------------
  -- End Point
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommVKDaily_Report'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKDaily_Report'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with day dynamic statistic on Vkontakte by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKDaily_Report 
   @ownerHubId = 1
  ,@isPast = 0

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKDaily_Report to [public]
/*
select * from dbo.StaCommVKDaily as scv
order by scv.commID, dayDate desc*/