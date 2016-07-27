use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.ProjectHub_Del', 'P'
go

alter procedure dbo.ProjectHub_Del
   @id         bigint = null
  ,@ownerHubID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 27.07.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'Delete', 'dbo.ProjectHub_Del'
  -----------------------------------------------------------------
  if not exists (select * from dbo.Comm where projectHubID = @id)
    delete from dbo.ProjectHub
      where id = @id
        and ownerHubID = @ownerHubID 
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.ProjectHub_Del'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.ProjectHub_Del'
  ,@Author      = 'Cova Igor'
  ,@Description = 'proc for save Projects Hub'
  ,@Params      = '@ownerHubID = owner hub ID  \n'
go

/* DEBUG:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.ProjectHub_Del

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.ProjectHub_Del to [public]

 