use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.ProjectHub_ReadDict', 'P'
go

alter procedure dbo.ProjectHub_ReadDict
   @ownerHubID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 05.07.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'Save', 'dbo.ProjectHub_ReadDict'
  -----------------------------------------------------------------
  select
       t.id
      ,t.name
    from dbo.ProjectHub as t       
    where t.ownerHubID = @ownerHubID       
    order by t.name asc
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.ProjectHub_ReadDict'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.ProjectHub_ReadDict'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Read dict of ProjectHub'
  ,@Params      = '@ownerHubID = owner hub ID \n'
go

/* DEBUG:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.ProjectHub_ReadDict
  @ownerHubID = 2

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.ProjectHub_ReadDict to [public]

 