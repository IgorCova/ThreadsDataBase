use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

alter procedure dbo.Comm_Read
   @id             bigint
  ,@ownerHubID     bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 30.03.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'Read', 'dbo.Comm_Read'
  -----------------------------------------------------------------

  select top 1
       t.id
      ,t.ownerHubID
      ,t.groupID
      ,t.subjectCommID  as subjectCommID
      ,s.name           as subjectCommID_name
      ,t.link
      ,t.photoLink
      ,t.photoLinkBig

      ,t.areaCommID     as areaCommID
      ,a.code           as areaCommID_code

      ,t.name

      ,t.adminCommID    as adminCommID
      ,c.firstName      as adminCommID_firstName
      ,c.lastName       as adminCommID_lastName
      ,concat(c.firstName, ' ' + c.lastName) as adminCommID_Name

      ,c.phone          as adminCommID_phone
      ,c.linkFB         as adminCommID_linkFB

      ,coalesce(nullif(ss.countMemebers, 0), nullif(st.commMembers, 0), t.members_count) as countMemebers

      ,w.countWoman
      ,cast(round(isnull(w.countWoman, 0) * 100.0 / nullif(ss.countMemebers, 0),1,1) as int) as countWomanPercent
      ,w.countMen
      ,100 - cast(round(isnull(w.countWoman, 0) * 100.0 / nullif(ss.countMemebers, 0),1,1) as int) as countMenPercent
    from dbo.Comm        as t 
    join dbo.SubjectComm as s on s.id = t.subjectCommID 
    join dbo.AdminComm   as c on c.id = t.adminCommID 
    join dbo.AreaComm    as a on a.id = t.areaCommID 
    outer apply (
      select          
           s.commMembers           as commMembers         
        from dbo.StaCommVKDaily as s
        where s.commID = t.id
          and t.areaCommID = 1
          and s.dayDate = cast(getdate() as date)
    ) as st

    outer apply (
      select 
          sum(s.other) + sum(s.under18) + sum(s.from18to21) + sum(s.from21to24) + sum(s.from24to27) + sum(s.from27to30) + sum(s.from30to35) + sum(s.from35to45) + sum(s.over45) as countWoman
        from dbo.SexComm  as s 
        where s.groupID = t.groupID
          and s.areaCommID = t.areaCommID 
          and s.sex = 0 
    ) as sf

    outer apply (
      select 
           sum(s.other) + sum(s.under18) + sum(s.from18to21) + sum(s.from21to24) + sum(s.from24to27) + sum(s.from27to30) + sum(s.from30to35) + sum(s.from35to45) + sum(s.over45) as countMen
        from dbo.SexComm  as s 
        where s.groupID = t.groupID
          and s.areaCommID = t.areaCommID 
          and s.sex = 1
    ) as sm

    outer apply (
      select 
          sum(s.other) + sum(s.under18) + sum(s.from18to21) + sum(s.from21to24) + sum(s.from24to27) + sum(s.from27to30) + sum(s.from30to35) + sum(s.from35to45) + sum(s.over45) as countUndefined
        from dbo.SexComm  as s 
        where s.groupID = t.groupID
          and s.areaCommID = t.areaCommID 
          and s.sex = 2
    ) as su

    outer apply (
      select 
          sum(s.other) + sum(s.under18) + sum(s.from18to21) + sum(s.from21to24) + sum(s.from24to27) + sum(s.from27to30) + sum(s.from30to35) + sum(s.from35to45) + sum(s.over45) as countMemebers
        from dbo.SexComm  as s 
        where s.groupID = t.groupID
          and s.areaCommID = t.areaCommID
    ) as ss

    outer apply ( 
      select
           (sf.countWoman + (su.countUndefined / 2) + (su.countUndefined % 2)) as countWoman
          ,(sm.countMen + (su.countUndefined / 2) ) as countMen
    ) as w
    where t.id = @id
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Comm_Read'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Comm_Read'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read comm info.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:*/
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_Read 
   @id = 234
  ,@ownerHubID = 1
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_Read to [public]
