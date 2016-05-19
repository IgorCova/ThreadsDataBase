use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'Owner_Set', 'P'
go

alter procedure dbo.Owner_Set 
   @ownerHubID   bigint 
  ,@sessionReqID bigint
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
     @phone         varchar(64)
    ,@adminCommId   bigint = next value for seq.AdminComm
    ,@subjectCommId bigint = next value for seq.SubjectComm

  select @phone = fn.ClearPhone(s.phone)
    from dbo.SessionReq as s       
    where s.id = @sessionReqID

  exec dbo.OwnerHub_New
       @id    = @ownerHubID   
      ,@phone = @phone

  select
       @phone = t.phone
    from dbo.OwnerHub as t       
    where t.id = @ownerHubID

  -- Admin 
  exec dbo.AdminComm_Save_New
     @id         = @adminCommId
    ,@ownerHubID = @ownerHubID   
    ,@firstName  = 'Администратор'   
    ,@lastName   = ''   
    ,@phone      = @phone   
    ,@linkFB     = '100012171880572'

  -- Subject
  exec dbo.SubjectComm_Save_New
     @id = @subjectCommId   
    ,@ownerHubID = @ownerHubID   
    ,@name = 'Топы статистики'

  -- Add example Comms
  exec dbo.Comm_Save
     @id = null   
    ,@ownerHubID = @ownerHubID   
    ,@subjectCommID = @subjectCommId   
    ,@name = 'Новинки Музыки 2016'   
    ,@adminCommID = @adminCommId   
    ,@link = 'https://vk.com/public27895931'
  
  exec dbo.Comm_Save
     @id = null   
    ,@ownerHubID = @ownerHubID   
    ,@subjectCommID = @subjectCommId   
    ,@name = 'Наука и Техника'   
    ,@adminCommID = @adminCommId   
    ,@link = 'https://vk.com/public31976785'
  
  exec dbo.Comm_Save
     @id = null   
    ,@ownerHubID = @ownerHubID   
    ,@subjectCommID = @subjectCommId   
    ,@name = 'Science|Наука'   
    ,@adminCommID = @adminCommId   
    ,@link = 'https://vk.com/public29559271'
  
  exec dbo.Comm_Save
     @id = null   
    ,@ownerHubID = @ownerHubID   
    ,@subjectCommID = @subjectCommId   
    ,@name = 'Подслушано'   
    ,@adminCommID = @adminCommId   
    ,@link = 'https://vk.com/public34215577'
  
  exec dbo.Comm_Save
     @id = null   
    ,@ownerHubID = @ownerHubID   
    ,@subjectCommID = @subjectCommId   
    ,@name = 'Хитрости жизни'   
    ,@adminCommID = @adminCommId   
    ,@link = 'https://vk.com/public76314525'

 -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.Owner_Set'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Owner_Set'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Session.'
  ,@Params = '@ownerHubID = ownerHubID \n
              @sessionReqID =  id session req \n'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Owner_Set 
   @debug_info      = 0xFF

select @err = @@error

select @ret as RETURN, @err as ERROR, convert(varchar(20), getdate()-@runtime, 114) as RUN_TIME
--*/
go
grant execute on dbo.Owner_Set to public