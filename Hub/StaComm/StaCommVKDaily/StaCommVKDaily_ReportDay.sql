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
      ,subscribedNew             = isnull(s.commSubscribed - c.commSubscribed, 0)
      ,subscribedNewPercent      = isnull(cast( (cast(s.commSubscribed as numeric(16, 2)) / ( cast(nullif((c.commSubscribed), 0) as numeric(16, 2)))) * 100 as numeric(16, 2)), 0)

      ,unsubscribed              = isnull(s.commUnsubscribed, 0)
      ,unsubscribedNew           = isnull(s.commUnsubscribed - c.commUnsubscribed, 0)
      ,unsubscribedNewPercent    = isnull(cast( cast(s.commUnsubscribed as numeric(16, 2)) / ( cast(nullif((c.commUnsubscribed), 0) as numeric(16, 2)) * 100 ) as numeric(16, 2)), 0)

      ,visitors                  = isnull(s.commVisitors, 0)
      ,visitorsNew               = isnull(s.commVisitors - c.commVisitors, 0)
      ,visitorsNewPercent        = isnull(cast( (cast(s.commVisitors as numeric(16, 2)) / ( cast(nullif((c.commVisitors), 0) as numeric(16, 2)))) * 100 as numeric(16, 2)), 0)

      ,views                     = isnull(s.commViews, 0)
      ,viewsNew                  = isnull(s.commViews - c.commViews, 0)
      ,viewsNewPercent           = isnull(cast( cast(s.commViews as numeric(16, 2)) / (cast(nullif((c.commViews), 0) as numeric(16, 2))) * 100 as numeric(16, 2)) , 0)
     -- Periodically -
     --------------------------------------------------------------------------------

     --------------------------------------------------------------------------------
     -- Summary +
      ,members                   = isnull(s.commMembers, 0)
      ,membersNew                = isnull(s.commMembers - c.commMembers, 0)
      ,membersNewPercent         = isnull(cast( cast(c.commMembers - r.commMembers as numeric(16, 2)) / ( cast(nullif((s.commMembers - c.commMembers), 0) as numeric(16, 2))) * 100 as numeric(16, 2)), 0) 

      ,postCount                 = isnull(s.commPostCount - c.commPostCount, 0)
      ,postCountNew              = isnull(s.commPostCount - c.commPostCount, 0)
      ,postCountNewPercent       = isnull(cast( cast(c.commPostCount - r.commPostCount as numeric(16, 2)) / ( cast(nullif((s.commPostCount - c.commPostCount), 0) as numeric(16, 2))) * 100 as numeric(16, 2)), 0)

      ,likes                     = isnull(s.commLikes - c.commLikes , 0)
      ,likesNew                  = isnull(s.commLikes - c.commLikes , 0)
      ,likesNewPercent           = isnull(cast( cast(c.commLikes - r.commLikes as numeric(16, 2)) / (cast(nullif((s.commLikes - c.commLikes), 0) as numeric(16, 2))) * 100 as numeric(16, 2)), 0)

      ,comments                  = isnull(s.commComments - c.commComments, 0)
      ,commentsNew               = isnull(s.commComments - c.commComments, 0)
      ,commentsNewPercent        = isnull(cast( cast(c.commComments - r.commComments as numeric(16, 2)) / ( cast(nullif((s.commComments - c.commComments), 0) as numeric(16, 2))) * 100 as numeric(16, 2)) , 0)

      ,reposts                   = isnull(s.commReposts - c.commReposts, 0)
      ,repostsNew                = isnull(s.commReposts - c.commReposts, 0)
      ,repostsNewPercent         = isnull(cast( cast(c.commReposts - r.commReposts as numeric(16, 2)) / ( cast(nullif((s.commReposts - c.commReposts), 0) as numeric(16, 2))) * 100 as numeric(16, 2)) , 0)

      ,reach                     = isnull(s.commReach - c.commReach, 0)
      ,reachNew                  = isnull(s.commReach - c.commReach, 0)
      ,reachNewPercent           = isnull(cast( cast(c.commReach - r.commReach as numeric(16, 2)) / (cast(nullif((s.commReach - c.commReach), 0) as numeric(16, 2))) * 100 as numeric(16, 2)), 0)

      ,reachSubscribers          = isnull(s.commReachSubscribers - c.commReachSubscribers, 0)
      ,reachSubscribersNew       = isnull(s.commReachSubscribers - c.commReachSubscribers, 0)
      ,reachSubscribersNewPercent= isnull(cast( cast(c.commReachSubscribers - r.commReachSubscribers as numeric(16,2)) / ( cast(nullif((s.commReachSubscribers - c.commReachSubscribers), 0) as numeric(16, 2))) * 100 as numeric(16, 2)), 0)
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
    ) as c

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
    ) as r
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

/* Œ“À¿ƒ ¿:
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