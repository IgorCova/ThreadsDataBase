use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKDaily_ReportWeek', 'P'
go

alter procedure dbo.StaCommVKDaily_ReportWeek
   @ownerHubID bigint
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
     @beginCurrentWeek date = cast(getdate() - datepart(weekday, getdate()) as date)
    ,@beginPrevWeek date = cast(getdate() -7 - datepart(weekday, getdate()) as date) -- date end of the previous week's    
    ,@endPrevWeek date = cast(getdate() - datepart(weekday, getdate()) as date) -- date end of the previous week's  

  select
       comm_id                    = t.id
      ,comm_name                  = t.name
      ,comm_groupID               = t.groupID

      ,subjectComm_name           = b.name
      ,areaComm_code              = a.code

      ,adminComm_fullName         = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB           = d.linkFB

      ,members                    = s.commMembers
      ,membersNew                 = s.commMembers - c.commMembers
      ,membersNewPercent          = cast( cast(s.commMembers - c.commMembers as numeric(16, 2)) / ( cast(nullif((c.commMembers), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,subscribed                 = s.commSubscribed
      ,subscribedNew              = s.commSubscribed - c.commSubscribed
      ,subscribedNewPercent       = cast( cast(s.commSubscribed as numeric(16, 2)) / ( cast(nullif((c.commSubscribed), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,unsubscribed               = s.commUnsubscribed
      ,unsubscribedNew            = s.commUnsubscribed - c.commUnsubscribed
      ,unsubscribedNewPercent     = cast( cast(s.commUnsubscribed as numeric(16, 2)) / ( cast(nullif((c.commUnsubscribed), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,visitors                   = s.commVisitors
      ,visitorsNew                = s.commVisitors - c.commVisitors
      ,visitorsNewPercent         = cast( (cast(s.commVisitors as numeric(16, 2)) / ( cast(nullif((c.commVisitors), 0) as numeric(16, 2)))) * 100 as numeric(16, 2))

      ,views                      = s.commViews
      ,viewsNew                   = s.commViews - c.commViews
      ,viewsNewPercent            = cast( cast(s.commViews as numeric(16, 2)) / (cast(nullif((c.commViews), 0) as numeric(16, 2))) * 100 as numeric(16, 2)) 

      ,reach                      = s.commReach
      ,reachNew                   = s.commReach - c.commReach
      ,reachNewPercent            = cast( cast(s.commReach as numeric(16, 2)) / (cast(nullif((c.commReach), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,reachSubscribers           = s.commReachSubscribers
      ,reachSubscribersNew        = s.commReachSubscribers - c.commReachSubscribers
      ,reachSubscribersNewPercent = cast( cast(s.commReachSubscribers as numeric(16,2)) / ( cast(nullif((c.commReachSubscribers), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,postCount                  = s.commPostCount
      ,postCountNew               = s.commPostCount - c.commPostCount
      ,postCountNewPercent        = cast( cast(s.commPostCount - c.commPostCount as numeric(16, 2)) / ( cast(nullif((c.commPostCount), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,likes                      = s.commLikes
      ,likesNew                   = s.commLikes - c.commLikes 
      ,likesNewPercent            = cast( cast(s.commLikes - c.commLikes as numeric(16, 2)) / (cast(nullif((c.commLikes ), 0) as numeric(16, 2))) * 100 as numeric(16, 2))

      ,comments                   = s.commComments
      ,commentsNew                = s.commComments - c.commComments
      ,commentsNewPercent         = cast( cast(s.commComments - c.commComments as numeric(16, 2)) / ( cast(nullif((c.commComments), 0) as numeric(16, 2))) * 100 as numeric(16, 2)) 

      ,reposts                    = s.commReposts
      ,repostsNew                 = s.commReposts - c.commReposts
      ,repostsNewPercent          = cast( cast(s.commReposts - c.commReposts as numeric(16, 2)) / ( cast(nullif((c.commReposts), 0) as numeric(16, 2))) * 100 as numeric(16, 2))      
    from dbo.Comm             as t
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID

    outer apply (
      select
           max(s.commLikes)     as commLikes
          ,max(s.commComments)  as commComments
          ,max(s.commReposts)   as commReposts
          ,max(s.commPostCount) as commPostCount
          ,max(s.commMembers)   as commMembers

          ,sum(s.commSubscribed)       as commSubscribed
          ,sum(s.commUnsubscribed)     as commUnsubscribed
          ,sum(s.commViews)            as commViews
          ,sum(s.commVisitors)         as commVisitors
          ,sum(s.commReach)            as commReach
          ,sum(s.commReachSubscribers) as commReachSubscribers          
        from dbo.StaCommVKDaily as s    
        where s.commID = t.id 
          and s.dayDate > @beginPrevWeek
          and s.dayDate < @endPrevWeek
    ) as c

    outer apply (
      select
           max(s.commLikes)     as commLikes
          ,max(s.commComments)  as commComments
          ,max(s.commReposts)   as commReposts
          ,max(s.commPostCount) as commPostCount
          ,max(s.commMembers)   as commMembers

          ,sum(s.commSubscribed)       as commSubscribed
          ,sum(s.commUnsubscribed)     as commUnsubscribed
          ,sum(s.commViews)            as commViews
          ,sum(s.commVisitors)         as commVisitors
          ,sum(s.commReach)            as commReach
          ,sum(s.commReachSubscribers) as commReachSubscribers
        from dbo.StaCommVKDaily as s    
        where s.commID = t.id 
          and s.dayDate > @beginCurrentWeek
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
exec dbo.[NativeCheck] 'dbo.StaCommVKDaily_ReportWeek'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKDaily_ReportWeek'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with week dynamic statistic on Vkontakte by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:*/
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKDaily_ReportWeek 
  @ownerHubId = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKDaily_ReportWeek to [public]
