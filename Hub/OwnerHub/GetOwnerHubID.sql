use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.GetOwnerHubID', 'P'
go

alter procedure dbo.GetOwnerHubID
   @sessionID varchar(36)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 12.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------

  select top 1
       h.id as ownerHubID
    from dbo.Session    as s
    join dbo.SessionReq as r on r.id = s.sessionReqID
    join dbo.OwnerHub   as h on h.phone = r.phone
    where s.sessionID = @sessionID

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.GetOwnerHubID'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.GetOwnerHubID'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read comm info.'
  ,@Params      = '@sessionID = session id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.GetOwnerHubID 
   @sessionID = 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.GetOwnerHubID to [public]
