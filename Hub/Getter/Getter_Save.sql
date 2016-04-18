use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.Getter_Save', 'P'
go

alter procedure dbo.Getter_Save
   @ownerHubID  bigint
  ,@gsAction    varchar(256)
  ,@gsProcedure sysname
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 18.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  insert into dbo.Getter ( 
     id
    ,ownerHubID
    ,gsAction
    ,gsProcedure
    ,gsDate 
  ) values (
     next value for seq.Getter
    ,@ownerHubID
    ,@gsAction
    ,@gsProcedure
    ,getdate() 
  )

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Getter_Save'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Getter_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for save info hwo use CommHub.'
  ,@Params      = '
     @ownerHubID = owner Hub id \n
    ,@gsAction = Action Get/Set \n
    ,@gsProcedure = procedure name \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Getter_Save 
   @id = 1
  ,@ownerHubId = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Getter_Save to [public]
