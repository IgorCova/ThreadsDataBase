use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKDaily_ReportDay', 'P'
go

alter procedure dbo.StaCommVKDaily_ReportDay
   @ownerHubID bigint = null
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
  exec dbo.Getter_Save @ownerHubID, 'GetReport', 'dbo.StaCommVKDaily_ReportDay'
  -----------------------------------------------------------------
  declare 
     @today   date = cast(getdate() as date)
    ,@yesterday date = cast(getdate()-1 as date) 
    ,@preYesterday date = cast(getdate()-2 as date) 

  select
       comm_id             = t.id
      ,comm_name           = t.name
      ,comm_photoLink      = isnull(t.photoLink , '')
      ,comm_groupID        = t.groupID

      ,subjectComm_name    = b.name
      ,areaComm_code       = a.code

      ,adminComm_fullName  = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB    = d.linkFB

     --------------------------------------------------------------------------------
     -- Periodically +
      ,subscribed                = isnull(s.commSubscribed, 0)
      ,subscribedOld             = isnull(v.commSubscribed, 0)
      ,subscribedDif             = isnull(s.commSubscribed, 0)
      ,subscribedDifPercent      = isnull(cast( (cast(s.commSubscribed as numeric(16, 2)) * 100 / ( cast(nullif((v.commSubscribed), 0) as numeric(16, 2)))) as numeric(16, 2)), 0)

      ,unsubscribed              = isnull(s.commUnsubscribed, 0)
      ,unsubscribedDif           = isnull(s.commUnsubscribed - v.commUnsubscribed, 0)
      ,unsubscribedDifPercent    = isnull(cast( cast(s.commUnsubscribed as numeric(16, 2))  * 100/ ( cast(nullif((v.commUnsubscribed), 0) as numeric(16, 2)) ) as numeric(16, 2)), 0)

      ,visitors                  = isnull(s.commVisitors, 0)
      ,visitorsDif               = isnull(s.commVisitors - v.commVisitors, 0)
      ,visitorsDifPercent        = isnull(cast( (cast(s.commVisitors as numeric(16, 2))  * 100/ ( cast(nullif((v.commVisitors), 0) as numeric(16, 2)))) as numeric(16, 2)), 0)

      ,views                     = isnull(s.commViews, 0)
      ,viewsDif                  = isnull(s.commViews - v.commViews, 0)
      ,viewsDifPercent           = isnull(cast( cast(s.commViews as numeric(16, 2)) / (cast(nullif((v.commViews), 0) as numeric(16, 2))) * 100 as numeric(16, 2)) , 0)
     -- Periodically -
     --------------------------------------------------------------------------------

     --------------------------------------------------------------------------------
     -- Summary +
      ,members                   = isnull(s.commMembers, 0)
      ,membersOld                = isnull(v.commMembers - p.commMembers, 0)
      ,membersDif                = isnull(s.commMembers - v.commMembers, 0)
      ,membersDifPercent         = isnull(cast( cast(v.commMembers - p.commMembers as numeric(16, 2)) / ( cast(nullif((s.commMembers - v.commMembers), 0) as numeric(16, 2))) * 100 as numeric(16, 2)), 0) 

      ,postCount                 = isnull(s.commPostCount, 0)
      ,postCountOld              = isnull(v.commPostCount, 0)
      ,postCountDif              = isnull(s.commPostCount - v.commPostCount, 0)
      ,postCountDifPercent       = isnull(cast(cast(s.commPostCount - v.commPostCount as numeric(16, 2)) * 100 / ( cast(nullif((v.commPostCount - p.commPostCount), 0)  as numeric(16, 2))) as numeric(16, 2)), 0)

      ,likes                     = isnull(s.commLikes - v.commLikes , 0)
      ,likesOld                  = isnull(v.commLikes - p.commLikes, 0)
      ,likesDif                  = isnull(s.commLikes - v.commLikes , 0)
      ,likesDifPercent           = isnull(cast( cast(s.commLikes - v.commLikes as numeric(16, 2)) * 100 / (cast(nullif((v.commLikes - p.commLikes), 0) as numeric(16, 2))) as numeric(16, 2)), 0)

      ,comments                  = isnull(s.commComments - v.commComments, 0)
      ,commentsOld               = isnull(v.commComments - p.commComments, 0)
      ,commentsDif               = isnull(s.commComments - v.commComments, 0)
      ,commentsDifPercent        = isnull(cast( cast(s.commComments - v.commComments as numeric(16, 2)) * 100 / ( cast(nullif((v.commComments - p.commComments), 0) as numeric(16, 2))) as numeric(16, 2)) , 0)

      ,reposts                   = isnull(s.commReposts - v.commReposts, 0)
      ,repostsOld                = isnull(v.commReposts - p.commReposts, 0)
      ,repostsDif                = isnull(s.commReposts - v.commReposts, 0)
      ,repostsDifPercent         = isnull(cast( cast(s.commReposts - v.commReposts as numeric(16, 2)) * 100 / ( cast(nullif((v.commReposts - p.commReposts), 0) as numeric(16, 2))) as numeric(16, 2)) , 0)

      ,reach                     = isnull(s.commReach, 0)
      ,reachOld                  = isnull(v.commReach - p.commReach, 0)
      ,reachDif                  = isnull(s.commReach - v.commReach, 0)
      ,reachDifPercent           = isnull(100.00 -cast( cast(s.commReach as numeric(16, 2)) * 100 / (cast(nullif((v.commReach), 0) as numeric(16, 2)))  as numeric(16, 2)), 0)

      ,reachSubscribers          = isnull(s.commReachSubscribers - v.commReachSubscribers, 0)
      ,reachSubscribersOld       = isnull(v.commReachSubscribers - p.commReachSubscribers, 0)
      ,reachSubscribersDif       = isnull(s.commReachSubscribers - v.commReachSubscribers, 0)
      ,reachSubscribersDifPercent= isnull(cast( cast(v.commReachSubscribers - p.commReachSubscribers as numeric(16,2)) * 100 / ( cast(nullif((s.commReachSubscribers - v.commReachSubscribers), 0) as numeric(16, 2))) as numeric(16, 2)), 0)
     -- Summary +
     --------------------------------------------------------------------------------
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
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and s.dayDate = @today
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
          and s.dayDate = @yesterday
    ) as v

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
          and s.dayDate = @preYesterday
    ) as p
    where t.ownerHubID = iif(@ownerHubID = 1, t.ownerHubID, @ownerHubID)
-----------------------------------------------------------
  -- End Point
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommVKDaily_ReportDay'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKDaily_ReportDay'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with week dynamic statistic on Vkontakte by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:*/
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKDaily_ReportDay 
  @ownerHubId = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKDaily_ReportDay to [public]
/*
select * from dbo.StaCommVKDaily as scv
order by scv.commID, dayDate desc*/