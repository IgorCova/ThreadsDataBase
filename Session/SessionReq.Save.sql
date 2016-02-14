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
alter procedure [dbo].[SessionReq.Save]
   @DID            varchar(64)
  ,@Phone          varchar(64)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 13.02.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare @ID bigint

  set @ID = next value for seq.SessionReq

  insert into dbo.SessionReq ( 
     ID
    ,DID
    ,Phone
    ,CreateDate 
  ) values (
     @ID
    ,@DID
    ,@Phone
    ,getdate() 
  )
  
  select @ID as ID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <[NativeCheck]>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[SessionReq.Save]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[SessionReq.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Session request.'
  ,@Params = '
     ,@DID = Device ID \n
     ,@Phone = Phone number \n
     '
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[SessionReq.Save] 
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[SessionReq.Save] to [public]