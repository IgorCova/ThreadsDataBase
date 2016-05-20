use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKGraph_Report', 'P'
go

alter procedure dbo.StaCommVKGraph_Report
   @ownerHubID bigint
  ,@commID     bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 21.05.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  ----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'GetReport', 'dbo.StaCommVKGraph_Report'
  -----------------------------------------------------------------
  declare @groupID   bigint
  declare @endDate   date = cast(getdate() + 1 as date)
  declare @startDate date = dateadd(month,-1, cast(getdate()-1 as date))

  select top 1
       @groupID = groupId
    from dbo.Comm as c       
    where c.id = @commID  

  select
       isnull(t.commLikes, 0)    as commLikes
      ,isnull(t.commComments, 0) as commComments
      ,isnull(t.commShare, 0)    as commShare
      ,isnull(t.commRemoved, 0)  as commRemoved
      ,t.dayDate                 as dayDate
    from dbo.StaCommVKGraph as t       
    where t.groupID = @groupID
      and t.dayDate > @startDate
      and t.dayDate < @endDate
    order by t.dayDate asc
-----------------------------------------------------------
  -- End Point
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommVKGraph_Report'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKGraph_Report'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read report activity statistic on Vkontakte by comm id.'
  ,@Params      = '@ownerHubID = owner Hub id \n
                   @commID = id Comm \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime
--select * from dbo.Comm
select @runtime = getdate()
exec @ret = dbo.StaCommVKGraph_Report 
   @ownerHubId = 3
  ,@commID = 119

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKGraph_Report to [public]
