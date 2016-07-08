use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommProjectDaily_Report', 'P'
go

alter procedure dbo.StaCommProjectDaily_Report
   @ownerHubID bigint = null
  ,@isPast     bit    = null
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
  exec dbo.Getter_Save @ownerHubID, 'GetReport', 'dbo.StaCommProjectDaily_Report'
  -----------------------------------------------------------------
  set @ownerHubID = iif(@ownerHubID in (1,2,80), 3, @ownerHubID)
  declare 
     @startDate date = iif(@isPast = 1, cast(getdate()-1 as date),  cast(getdate() as date))
    ,@endDate   date = iif(@isPast = 1, cast(getdate()-2 as date),  cast(getdate() -1 as date))
    ,@preDate   date = iif(@isPast = 1, cast(getdate()-3 as date),  cast(getdate() -2 as date))
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

      ,increase                  = isnull(rs.commNew_members - rs.commLeft_members, 0)
      ,increaseNew               = isnull(rs.commNew_members, 0)
      ,increaseOld               = isnull(rs.commLeft_members, 0)
      ,increaseDifPercent        = cast(isnull(isnull(rs.commNew_members - rs.commLeft_members, 0) * 100.00 / nullif(isnull(re.commNew_members - re.commLeft_members, 0), 0), 0) as int) 

      ,reachNew                  = isnull(s.commReach, 0)
      ,reachDifPercent           = cast(isnull(f.commReach * 100.00 / nullif(v.commReach, 0), 0) as int)

      ,postCountNew              = isnull(s.commPostCount, 0)
      ,postCountDifPercent       = cast(isnull(f.commPostCount * 100.00 / nullif(v.commPostCount, 0), 0) as int)

      -- Periodically +
      ---------------------------------------------------------------------------------------------------------------------------------------------------

      ,members                   = coalesce(cast(re.commMembers_count as int), t.members_count, 0)

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
    join @ownersTeam          as o on o.id = t.ownerHubID
    left join dbo.AreaComm    as a on a.id = t.areaCommID
    left join dbo.SubjectComm as b on b.id = t.subjectCommID
    left join dbo.AdminComm   as d on d.id = t.adminCommID
    outer apply (
      select
           s.commReach        
          ,s.commPostCount
          ,s.commLikes
          ,s.commComments
          ,s.commReshares
          ,s.requestDate
        from dbo.StaCommOKTopics  as s
        where s.groupID = t.groupID
          and s.dayDate = @startDate
    ) as oks

    outer apply (
      select          
           s.commReach        
          ,s.commPostCount
          ,s.commLikes
          ,s.commComments
          ,s.commReshares
          ,s.requestDate
        from dbo.StaCommOKTopics  as s
        where s.groupID = t.groupID
          and s.dayDate = @endDate
    ) as okv

    outer apply (
      select          
           s.commReach        
          ,s.commPostCount
          ,s.commLikes
          ,s.commComments
          ,s.commReshares
          ,s.requestDate
        from dbo.StaCommOKTopics  as s
        where s.groupID = t.groupID
          and s.dayDate = @preDate
    ) as okp

    outer apply (
      select          
           r.commMembers_count
          ,isnull(r.commNew_members,0)        as commNew_members
          ,isnull(r.commNew_members_target,0) as commNew_members_target
          ,isnull(r.commLeft_members,0)       as commLeft_members
          ,isnull(r.commMembers_diff    ,0)   as commMembers_diff     
        from dbo.StaCommOKTrends as r 
        where r.groupID = t.groupID
          and r.dayDate = @startDate
    ) as okrs

    outer apply (
      select
           r.commMembers_count
          ,isnull(r.commNew_members,0)        as commNew_members
          ,isnull(r.commNew_members_target,0) as commNew_members_target
          ,isnull(r.commLeft_members,0)       as commLeft_members
          ,isnull(r.commMembers_diff    ,0)   as commMembers_diff        
        from dbo.StaCommOKTrends as r 
        where r.groupID = t.groupID
          and r.dayDate = @endDate
    ) as okre

    outer apply (
      select
           commLikes            = cast((oks.commLikes          - okv.commLikes)     as int) 
          ,commComments         = cast((oks.commComments       - okv.commComments)  as int)
          ,commReshares         = cast((oks.commReshares       - okv.commReshares)  as int)
          ,commMembers          = cast((okrs.commMembers_count - okre.commMembers_count) as int)
          ,commReach            = cast((oks.commReach          - okv.commReach)     as int)
          ,commPostCount        = cast((oks.commPostCount      - okv.commPostCount) as int)
          
    ) as f
    order by t.name asc
-----------------------------------------------------------
  -- End Point
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommProjectDaily_Report'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommProjectDaily_Report'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report with day dynamic statistic on OK by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n
                   @isPast = for past period \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommProjectDaily_Report 
   @ownerHubId = 1
  ,@isPast = 0

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommProjectDaily_Report to [public]
/*
select * from dbo.StaCommVKDaily as scv
order by scv.commID, dayDate desc*/