use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'GroupAccess_Save', 'P'
go

alter procedure dbo.GroupAccess_Save
   @groupID        bigint
  ,@exception      varchar(4028)
  ,@innerException varchar(4028)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 16.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare @id bigint = next value for seq.GroupAccess

  insert into dbo.GroupAccess ( 
     id
    ,groupID
    ,requestDate
    ,exception
    ,innerException 
  ) values (
     @id
    ,@groupID
    ,getdate()
    ,@exception
    ,@innerException 
  )
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.GroupAccess_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save comm.'
  ,@Params      = '@groupID = id group \n
                   @exception = exception \n
                   @innerException = innerException \n'
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.GroupAccess_Save'
go

/* Debug:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.GroupAccess_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.GroupAccess_Save to [public]
