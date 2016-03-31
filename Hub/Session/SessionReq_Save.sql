use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// procedure for Save Session request.
///</description>
*/
alter procedure dbo.SessionReq_Save
   @dID            varchar(64)
  ,@phone          varchar(64)
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
  declare 
     @id bigint
    ,@OwnerHubID bigint

  set @id = next value for seq.SessionReq

  select
       @OwnerHubID = m.id
    from dbo.OwnerHub as m       
    where m.Phone = @Phone  

  insert into dbo.SessionReq ( 
     id
    ,dID
    ,phone
    ,createDate 
  ) values (
     @id
    ,@dID
    ,@phone
    ,getdate() 
  )

  select
       @id                    as id
      ,isnull(@OwnerHubID, 0) as ownerHubID 
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.SessionReq_Save'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.SessionReq_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Session request.'
  ,@Params = '
     ,@dID = Device ID \n
     ,@phone = Phone number \n
     '
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.SessionReq_Save 

select @err = @@error

select @ret as RETURN, @err as ERROR, convert(varchar(20), getdate()-@runtime, 114) as RUN_TIME
--*/
go
grant execute on dbo.SessionReq_Save to public