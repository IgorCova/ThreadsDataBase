use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommWeekly_Report', 'P'
go

alter procedure dbo.StaCommWeekly_Report
   @ownerHubID bigint = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 31.07.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  ----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'GetReport', 'dbo.StaCommWeekly_Report'
  -----------------------------------------------------------------
 -- set @ownerHubID = iif(@ownerHubID in (1,80) , 3, @ownerHubID)
  declare 
     @startDate date = cast(getdate() + 1 as date)
    ,@endDate   date = dateadd(week, -1, cast(getdate() as date))
    ,@preDate   date = dateadd(week, -2, cast(getdate() as date))   
    ,@perDate   date = dateadd(week, -4, cast(getdate() as date))
    
    ,@teamHubID bigint

  select top 1 
       @teamHubID = t.teamHubID
    from dbo.OwnerHub as t       
    where t.id = @ownerHubID
  
  declare @ownersTeam table (id bigint)
  insert into @ownersTeam ( id ) values (@ownerHubID)
  insert into @ownersTeam ( id )
  select
       t.id
    from dbo.OwnerHub as t       
    where t.TeamHubID = @teamHubID
     and t.id <> @ownerHubID

  declare @Results table (
     projectHub_id       bigint
    ,projectHub_name     varchar(256) 
    ,comm_id             bigint 
    ,comm_name           varchar(256) 
    ,comm_photoLink      varchar(512) 
    ,comm_photoLinkBig   varchar(512) 
    ,comm_groupID        bigint 

    ,subjectComm_name    varchar(256) 
    ,areaComm_code       varchar(32) 
    ,adminComm_fullName  varchar(512) 
    ,adminComm_linkFB    varchar(512) 

    ,increase            bigint 
    ,increaseNew         bigint 
    ,increaseOld         bigint 
    ,increaseDifPercent  int 

    ,reachNew            bigint 
    ,reachDifPercent     int 

    ,postCountNew        bigint 
    ,postCountDifPercent int 

    ,members             int 

    ,likesNew            bigint 
    ,likesDifPercent     int 

    ,commentsNew         bigint 
    ,commentsDifPercent  int 
    ,repostsNew          bigint 
    ,repostsDifPercent   int
    ,primary key (projectHub_id, comm_id))

  insert into @Results ( 
     projectHub_id
    ,projectHub_name
    ,comm_id
    ,comm_name
    ,comm_photoLink
    ,comm_photoLinkBig
    ,comm_groupID
    ,subjectComm_name
    ,areaComm_code
    ,adminComm_fullName
    ,adminComm_linkFB

    ,increase
    ,increaseNew
    ,increaseOld
    ,increaseDifPercent

    ,reachNew
    ,reachDifPercent

    ,postCountNew
    ,postCountDifPercent

    ,members

    ,likesNew
    ,likesDifPercent

    ,commentsNew
    ,commentsDifPercent

    ,repostsNew
    ,repostsDifPercent 
  )

  select
       projectHub_id             = t.projectHubID
      ,projectHub_name           = r.name
      ,comm_id                   = t.id
      ,comm_name                 = isnull(t.name, '')
      ,comm_photoLink            = isnull(t.photoLink , '')
      ,comm_photoLinkBig          = isnull(t.photoLinkBig , '')
      ,comm_groupID              = t.groupID
 
      ,subjectComm_name          = b.name
      ,areaComm_code             = a.code

      ,adminComm_fullName        = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB          = d.linkFB

      ,increase                  = isnull(s.commSubscribed - s.commUnsubscribed, 0)
      ,increaseNew               = isnull(s.commSubscribed, 0)
      ,increaseOld               = isnull(s.commUnsubscribed, 0)
      ,increaseDifPercent        = cast(isnull(isnull(s.commSubscribed - s.commUnsubscribed, 0) * 100.00 / nullif(isnull(v.commSubscribed - v.commUnsubscribed, 0), 0), 0) as int) 

      ,reachNew                  = isnull(s.commReach, 0)
      ,reachDifPercent           = cast(isnull(f.commReach * 100.00 / nullif(v.commReach, 0), 0) as int)

      ,postCountNew              = isnull(s.commPostCount, 0)
      ,postCountDifPercent       = cast(isnull(f.commPostCount * 100.00 / nullif(v.commPostCount, 0), 0) as int)

      ,members                   = isnull(s.commMembers, 0)

      ,likesNew                  = isnull(st.commLikes, 0)
      ,likesDifPercent           = cast(isnull(f.commLikes * 100.00 / nullif(vt.commLikes, 0), 0) as int)

      ,commentsNew               = isnull(st.commComments, 0)
      ,commentsDifPercent        = cast(isnull(f.commComments * 100.00 / nullif(vt.commComments, 0), 0) as int)

      ,repostsNew                = isnull(st.commShare, 0)
      ,repostsDifPercent         = cast(isnull(f.commShare * 100.00 / nullif(vt.commShare, 0), 0) as int)     
    from dbo.Comm             as t
    join @ownersTeam          as o on o.id = t.ownerHubID
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID
    join dbo.ProjectHub  as r on r.id = t.projectHubID
    outer apply (
      select         
           s.commMembers         
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and s.dayDate = cast(getdate() as date)
    ) as sm

    outer apply (
      select
           sum(s.commSubscribed)        as commSubscribed
          ,sum(s.commUnsubscribed)      as commUnsubscribed
          ,sum(s.commViews)             as commViews
          ,sum(s.commVisitors)          as commVisitors
          ,sum(s.commReach)             as commReach
          ,sum(s.commReachSubscribers)  as commReachSubscribers
          ,sum(s.commPostCount)         as commPostCount
          ,sum(s.commMembers)           as commMembers
          ,max(s.requestDate)           as requestDate
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and s.dayDate > @endDate 
          and s.dayDate < @startDate
    ) as s

    outer apply (
      select
           sum(s.commSubscribed)        as commSubscribed
          ,sum(s.commUnsubscribed)      as commUnsubscribed
          ,sum(s.commViews)             as commViews
          ,sum(s.commVisitors)          as commVisitors
          ,sum(s.commReach)             as commReach
          ,sum(s.commReachSubscribers)  as commReachSubscribers
          ,sum(s.commPostCount)         as commPostCount
          ,sum(s.commMembers)           as commMembers
          ,max(s.requestDate)           as requestDate
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and s.dayDate > @preDate
          and s.dayDate < @endDate
    ) as v

    outer apply (
      select
           sum(s.commLikes)            as commLikes
          ,sum(s.commComments)         as commComments
          ,sum(s.commShare)            as commShare      
          ,sum(s.commMembers)          as commMembers
          ,sum(s.commMembersLost)      as commMembersLost    
        from dbo.StaCommVKGraph as s
        where s.groupID = t.groupID
          and s.dayDate > @endDate 
          and s.dayDate < @startDate
    ) as st

    outer apply (
      select
           sum(s.commLikes)            as commLikes
          ,sum(s.commComments)         as commComments
          ,sum(s.commShare)            as commShare   
          ,sum(s.commMembers)          as commMembers
          ,sum(s.commMembersLost)      as commMembersLost
        from dbo.StaCommVKGraph as s
        where s.groupID = t.groupID
          and s.dayDate > @preDate
          and s.dayDate < @endDate
    ) as vt

    outer apply (
      select
           sum(s.commSubscribed)        as commSubscribed
          ,sum(s.commUnsubscribed)      as commUnsubscribed
          ,sum(s.commViews)             as commViews
          ,sum(s.commVisitors)          as commVisitors
          ,sum(s.commReach)             as commReach
          ,sum(s.commReachSubscribers)  as commReachSubscribers
          ,sum(s.commPostCount)         as commPostCount
          ,sum(s.commMembers)           as commMembers
          ,max(s.requestDate)           as requestDate
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and s.dayDate > @perDate
          and s.dayDate < @preDate
    ) as p

    outer apply (
      select
           commLikes            = cast((st.commLikes    - vt.commLikes   )  as int) 
          ,commComments         = cast((st.commComments - vt.commComments)  as int)
          ,commShare            = cast((st.commShare  - vt.commShare )  as int)

          ,commMembers          = cast((s.commMembers  - v.commMembers ) - (v.commMembers  - p.commMembers ) as int)
          ,commSubscribed       = cast((s.commSubscribed       - v.commSubscribed)       as int)
          ,commUnsubscribed     = cast((s.commUnsubscribed     - v.commUnsubscribed)     as int)
          ,commViews            = cast((s.commViews            - v.commViews)            as int)
          ,commVisitors         = cast((s.commVisitors         - v.commVisitors)         as int)
          ,commReach            = cast((s.commReach            - v.commReach)            as int)
          ,commReachSubscribers = cast((s.commReachSubscribers - v.commReachSubscribers) as int)
          ,commPostCount        = cast((s.commPostCount        - v.commPostCount)        as int)
    ) as f
    where t.areaCommID = 1
      and t.groupID <> 0

  insert into @Results ( 
     projectHub_id
    ,projectHub_name
    ,comm_id
    ,comm_name
    ,comm_photoLink
    ,comm_photoLinkBig
    ,comm_groupID
    ,subjectComm_name
    ,areaComm_code
    ,adminComm_fullName
    ,adminComm_linkFB

    ,increase
    ,increaseNew
    ,increaseOld
    ,increaseDifPercent

    ,reachNew
    ,reachDifPercent

    ,postCountNew
    ,postCountDifPercent

    ,members

    ,likesNew
    ,likesDifPercent

    ,commentsNew
    ,commentsDifPercent

    ,repostsNew
    ,repostsDifPercent )
  select 
      projectHub_id             = t.projectHubID
      ,projectHub_name           = r.name
      ,comm_id                   = t.id
      ,comm_name                 = isnull(t.name, '')
      ,comm_photoLink            = isnull(t.photoLink , '')
      ,comm_photoLinkBig          = isnull(t.photoLinkBig , '')
      ,comm_groupID              = t.groupID
 
      ,subjectComm_name          = b.name
      ,areaComm_code             = a.code

      ,adminComm_fullName        = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB          = d.linkFB

      ,increase                  = isnull(rs.commNew_members - rs.commLeft_members, 0)
      ,increaseNew               = isnull(rs.commNew_members, 0)
      ,increaseOld               = isnull(rs.commLeft_members, 0)
      ,increaseDifPercent        = cast(isnull(isnull(rs.commNew_members - rs.commLeft_members, 0) * 100.00 / nullif(isnull(re.commNew_members - re.commLeft_members, 0), 0), 0) as int) 

      ,reachNew                  = isnull(s.commReach, 0)
      ,reachDifPercent           = cast(isnull(f.commReach * 100.00 / nullif(v.commReach, 0), 0) as int)

      ,postCountNew              = isnull(s.commPostCount, 0)
      ,postCountDifPercent       = cast(isnull(f.commPostCount * 100.00 / nullif(v.commPostCount, 0), 0) as int)

      ,members                   = coalesce(cast(re.commMembers_count as int), t.members_count, 0)

      ,likesNew                  = isnull(s.commLikes, 0)
      ,likesDifPercent           = cast(isnull(f.commLikes * 100.00 / nullif(v.commLikes, 0), 0) as int)

      ,commentsNew               = isnull(s.commComments, 0)
      ,commentsDifPercent        = cast(isnull(f.commComments * 100.00 / nullif(v.commComments, 0), 0) as int)

      ,repostsNew                = isnull(s.commReshares, 0)
      ,repostsDifPercent         = cast(isnull(f.commReshares * 100.00 / nullif(v.commReshares, 0), 0) as int)   
    from dbo.Comm             as t
    join @ownersTeam          as o on o.id = t.ownerHubID
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID
    join dbo.ProjectHub  as r on r.id = t.projectHubID
     outer apply (
      select
           sum(s.commReach)     as commReach           
          ,sum(s.commPostCount) as commPostCount
          ,sum(s.commLikes)     as commLikes
          ,sum(s.commComments)  as commComments
          ,sum(s.commReshares)  as commReshares      
          ,max(s.requestDate)   as requestDate
        from dbo.StaCommOKTopics as s
        where s.groupID = t.groupID
          and s.dayDate > @endDate 
          and s.dayDate < @startDate
    ) as s

    outer apply (
      select 
           sum(s.commReach)     as commReach           
          ,sum(s.commPostCount) as commPostCount
          ,sum(s.commLikes)     as commLikes
          ,sum(s.commComments)  as commComments
          ,sum(s.commReshares)  as commReshares      
          ,max(s.requestDate)   as requestDate
        from dbo.StaCommOKTopics  as s
        where s.groupID = t.groupID          
          and s.dayDate > @preDate
          and s.dayDate < @endDate
    ) as v

    outer apply (
      select
           sum(r.commMembers_count) as commMembers_count
          ,sum(r.commNew_members)   as commNew_members
          ,sum(r.commLeft_members)  as commLeft_members       
        from dbo.StaCommOKTrends as r 
        where r.groupID = t.groupID
          and r.dayDate >= @startDate 
          and r.dayDate < cast(getdate() as date)
    ) as rs

    outer apply (
      select
           sum(r.commMembers_count) as commMembers_count
          ,sum(r.commNew_members)   as commNew_members
          ,sum(r.commLeft_members)  as commLeft_members     
        from dbo.StaCommOKTrends as r 
        where r.groupID = t.groupID        
          and r.dayDate >= @preDate 
          and r.dayDate < @endDate
    ) as re

    outer apply (
      select
           commLikes            = cast((s.commLikes    - v.commLikes   ) as int) 
          ,commComments         = cast((s.commComments - v.commComments) as int)
          ,commReshares         = cast((isnull(s.commReshares,0) - isnull(v.commReshares,0)) as int)

          ,commMembers          = cast((rs.commMembers_count  - re.commMembers_count )   as int)
          ,commReach            = cast((s.commReach            - v.commReach)            as int)
          ,commPostCount        = cast((s.commPostCount        - v.commPostCount)        as int)
    ) as f

    where t.areaCommID = 2 -- OK only
      and t.groupID <> 0
    order by t.name asc
  
  insert into @Results ( 
     projectHub_id
    ,projectHub_name
    ,comm_id
    ,comm_name
    ,comm_photoLink
    ,comm_photoLinkBig
    ,comm_groupID
    ,subjectComm_name
    ,areaComm_code
    ,adminComm_fullName
    ,adminComm_linkFB

    ,increase
    ,increaseNew
    ,increaseOld
    ,increaseDifPercent

    ,reachNew
    ,reachDifPercent

    ,postCountNew
    ,postCountDifPercent

    ,members

    ,likesNew
    ,likesDifPercent

    ,commentsNew
    ,commentsDifPercent

    ,repostsNew
    ,repostsDifPercent
  )
  select
       projectHub_id         = t.projectHub_id
      ,projectHub_name       = t.projectHub_name

      ,comm_id               = 0
      ,comm_name             = ''
      ,comm_photoLink        = ''
      ,comm_photoLinkBig     = ''
      ,comm_groupID          = 0
      ,subjectComm_name      = concat('ÍÓÎ. ÒÓÓ·˘ÂÒÚ‚ (',cast(count(t.comm_id) as varchar(5)),')')
      ,areaComm_code         = ''
      ,adminComm_fullName    = ''
      ,adminComm_linkFB      = ''
      
      ,increase              = sum(t.increase)
      ,increaseNew           = sum(t.increaseNew)
      ,increaseOld           = sum(t.increaseOld)
      ,increaseDifPercent    = avg(t.increaseDifPercent)

      ,reachNew              = sum(t.reachNew)
      ,reachDifPercent       = avg(t.reachDifPercent)

      ,postCountNew          = sum(t.postCountNew)
      ,postCountDifPercent   = avg(t.postCountDifPercent)

      ,members               = sum(t.members)

      ,likesNew              = sum(t.likesNew)
      ,likesDifPercent       = avg(t.likesDifPercent)

      ,commentsNew           = sum(t.commentsNew)
      ,commentsDifPercent    = avg(t.commentsDifPercent)

      ,repostsNew            = sum(t.repostsNew)
      ,repostsDifPercent     = avg(t.repostsDifPercent)
    from @Results as t
    group by
       t.projectHub_id
      ,t.projectHub_name

  select
       t.projectHub_id
      ,t.projectHub_name
      ,t.comm_id
      ,t.comm_name
      ,t.comm_photoLink
      ,t.comm_photoLinkBig
      ,t.comm_groupID
      ,t.subjectComm_name
      ,t.areaComm_code
      ,t.adminComm_fullName
      ,t.adminComm_linkFB
      ,t.members
      ,t.increase
      ,t.increaseNew
      ,t.increaseOld
      ,t.increaseDifPercent
      ,t.reachNew
      ,t.reachDifPercent
      ,t.postCountNew
      ,t.postCountDifPercent
      ,t.likesNew
      ,t.likesDifPercent
      ,t.commentsNew
      ,t.commentsDifPercent
      ,t.repostsNew
      ,t.repostsDifPercent
    from @Results as t
    order by t.projectHub_name, t.comm_name
-----------------------------------------------------------
  -- End Point
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommWeekly_Report'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommWeekly_Report'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with day dynamic statistic on Vkontakte by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommWeekly_Report
   @ownerHubId = 1
  ,@isPast = 0

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommWeekly_Report to [public]
/*
select * from dbo.StaCommVKDaily as scv
order by scv.commID, dayDate desc*/--select * from dbo.OwnerHub as oh
