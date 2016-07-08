use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.Comm_ReadForStaVKGraph', 'P'
go

alter procedure dbo.Comm_ReadForStaVKGraph
   @topCount  int = 7
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
  -----------------------------------------------------------------
  -----------------------------------------------------------------
  exec dbo.Getter_Save 5, 'ReadForStaVKGraph', 'dbo.Comm_ReadForStaVKGraph'
  -----------------------------------------------------------------

  select distinct top (@topCount)
      t.groupID
     ,t.link
    from dbo.Comm as t
    left join dbo.StaCommVKGraph as s on s.groupID = t.groupID
    where t.areaCommID = 1
      and not exists(select * from dbo.GroupAccess as g where g.groupID = t.groupID and t.areaCommID = 1)
      and not exists(select * from dbo.StaCommVKGraph as s where s.groupID = t.groupID and datediff(minute, s.requestDate, getdate()) < 55)
  --  order by s.requestDate asc
     -- and t.ownerHubID = 3
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Comm_ReadForStaVKGraph'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Comm_ReadForStaVKGraph'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read comms by sta at WCF-Service.'
  ,@Params      = '@topCount = count comm''s \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_ReadForStaVKGraph 
  @topCount = 7

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_ReadForStaVKGraph to [public]
