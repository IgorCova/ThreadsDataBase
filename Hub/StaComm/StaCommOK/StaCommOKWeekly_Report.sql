use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommOKWeekly_Report', 'P'
go

alter procedure dbo.StaCommOKWeekly_Report
   @ownerHubID bigint = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 06.06.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  ----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'GetReport', 'dbo.StaCommOKWeekly_Report'
  -----------------------------------------------------------------
  declare @dw int = datepart(dw, getdate()-1) 
  declare 
     @startDate date = dateadd(day, - @dw, cast(getdate() as date))
    ,@endDate   date = dateadd(day, - @dw, cast(getdate() -7 as date))
    ,@preDate   date = dateadd(day, - @dw, cast(getdate() -14 as date))
    
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

  select
       comm_id                   = t.id
      ,comm_name                 = t.name
      ,comm_photoLink            = isnull(t.photoLink , '')
      ,comm_photoLinkBig          = isnull(t.photoLinkBig , '')
      ,comm_groupID              = t.groupID
 
      ,subjectComm_name          = b.name
      ,areaComm_code             = a.code

      ,adminComm_fullName        = concat(d.firstName + ' ', d.lastName)
      ,adminComm_linkFB          = d.linkFB
      ,lastRequestDate           = s.requestDate

      ---------------------------------------------------------------------------------------------------------------------------------------------------
      -- Periodically +

      ,increaseNew               = isnull(rs.commNew_members - rs.commLeft_members, 0)
      ,increaseDifPercent        = cast(isnull(isnull(rs.commNew_members - rs.commLeft_members, 0) * 100.00 / nullif(isnull(re.commNew_members - re.commLeft_members, 0), 0), 0) as int) 

      ,reachNew                  = isnull(s.commReach, 0)
      ,reachDifPercent           = cast(isnull(f.commReach * 100.00 / nullif(v.commReach, 0), 0) as int)

      ,postCountNew              = isnull(s.commPostCount, 0)
      ,postCountDifPercent       = cast(isnull(f.commPostCount * 100.00 / nullif(v.commPostCount, 0), 0) as int)
      -- Periodically +
      ---------------------------------------------------------------------------------------------------------------------------------------------------
      ,members                   = coalesce(rs.commMembers_count, t.members_count, 0)
      ---------------------------------------------------------------------------------------------------------------------------------------------------
      -- Wall + 
      ,likesNew                  = isnull(s.commLikes, 0)
      ,likesDifPercent           = cast(isnull(f.commLikes * 100.00 / nullif(v.commLikes, 0), 0) as int)

      ,commentsNew               = isnull(s.commComments, 0)
      ,commentsDifPercent        = cast(isnull(f.commComments * 100.00 / nullif(v.commComments, 0), 0) as int)

      ,resharesNew                = isnull(s.commReshares, 0)
      ,resharesDifPercent         = cast(isnull(f.commReshares * 100.00 / nullif(v.commReshares, 0), 0) as int)
      -- Wall +
      ---------------------------------------------------------------------------------------------------------------------------------------------------      
    from dbo.Comm             as t
    join @ownersTeam          as w on w.id = t.ownerHubID
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID

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
          and s.dayDate >= @startDate 
          and s.dayDate < cast(getdate() as date)
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
          and s.dayDate >= @endDate 
          and s.dayDate < @startDate
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
          and r.dayDate >= @endDate 
          and r.dayDate < @startDate
    ) as re

    outer apply (
      select
           commLikes            = cast((s.commLikes    - v.commLikes   ) as int) 
          ,commComments         = cast((s.commComments - v.commComments) as int)
          ,commReshares         = cast((s.commReshares    - v.commReshares   ) as int)

          ,commMembers          = cast((rs.commMembers_count  - re.commMembers_count ) as int)
          ,commReach            = cast((s.commReach            - v.commReach)            as int)
          ,commPostCount        = cast((s.commPostCount        - v.commPostCount)        as int)
    ) as f

    where t.areaCommID = 2 -- OK only
    order by t.name asc
-----------------------------------------------------------
  -- End Point
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommOKWeekly_Report'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommOKWeekly_Report'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with day dynamic statistic on OK by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n '
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommOKWeekly_Report 
   @ownerHubId = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommOKWeekly_Report to [public]
/*
select * from dbo.StaCommVKDaily as scv
order by scv.commID, dayDate desc*/