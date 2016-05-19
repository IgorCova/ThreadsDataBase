use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec sp.object_create 'OwnerHub_Del', 'P'
go

alter procedure dbo.OwnerHub_Del
   @id  bigint  
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

  delete s
    from dbo.StaCommVKDaily as s
    join dbo.Comm           as c on c.id = s.commID
    where c.ownerHubID = @id

  delete s
    from dbo.StaCommVKWeekly as s
    join dbo.Comm            as c on c.id = s.commID
    where c.ownerHubID = @id

  delete  
    from dbo.Comm
    where ownerHubID = @id

  delete  
    from dbo.SubjectComm
    where ownerHubID = @id

  delete  
    from dbo.AdminComm
    where ownerHubID = @id

  delete  
    from dbo.OwnerHub
    where id = @id 
   
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.OwnerHub_Del'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.OwnerHub_Del'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save owner Hub.'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.OwnerHub_Del 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
deny execute on dbo.OwnerHub_Del to [public]
