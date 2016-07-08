use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'SubjectComm_New', 'P'
go

alter procedure dbo.SubjectComm_New
   @id         bigint = null
  ,@ownerHubID bigint 
  ,@name       varchar(256)
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
  exec dbo.Getter_Save @ownerHubID, 'Save', 'dbo.SubjectComm_New'
  -----------------------------------------------------------------

  insert into dbo.SubjectComm ( 
     id
    ,ownerHubID
    ,name 
  ) values (
     @id
    ,@ownerHubID
    ,@name 
  )
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.SubjectComm_New'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.SubjectComm_New'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save subject of community.'
  ,@Params = '
      @id = id SubjectComm \n 
     ,@name = name \n
     ,@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.SubjectComm_New 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.SubjectComm_New to [public]
