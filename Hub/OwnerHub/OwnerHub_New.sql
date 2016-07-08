use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.OwnerHub_New', 'P'
go

alter procedure dbo.OwnerHub_New
   @id             bigint
  ,@phone          varchar(32)
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
  declare @adminCommID   bigint = next value for seq.AdminComm
  declare @subjectCommID bigint = next value for seq.SubjectComm
  declare @teamHubID     int

  set @phone = fn.ClearPhone(@phone)

  if exists (select * from dbo.AdminComm as s where s.phone = @phone)
  begin
    select top 1 
         @teamHubID = h.TeamHubID
      from dbo.AdminComm as s
      join dbo.OwnerHub  as h on h.id = s.ownerHubId       
      where  s.phone = @phone
  end

  if @teamHubID is null
    set @teamHubID = next value for seq.TeamHub

  -----------------------------------------
  -- adding default project for the community
  exec dbo.ProjectHub_Save 
     @id         = null
    ,@ownerHubID = @id
    ,@name       = 'Main'
  -----------------------------------------

  -----------------------------------------
  -- adding default Admin for the community
  exec dbo.AdminComm_New
     @ownerHubID = @id
    ,@phone = @phone
  -----------------------------------------

  -----------------------------------------
  -- adding default Subject for the community
  exec dbo.SubjectComm_Save_New
     @id         = null
    ,@ownerHubID = @id   
    ,@name       = 'Main'    
  -----------------------------------------

  insert into dbo.OwnerHub ( 
     id
    ,firstName
    ,lastName
    ,phone
    ,linkFB 
    ,dateCreate
    ,TeamHubID
  ) values (
     @id
    ,''
    ,''
    ,@phone
    ,'' 
    ,getdate()
    ,@teamHubID
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
   @ObjSysName  = 'dbo.OwnerHub_New'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save owner Hub.'
  ,@Params = '
      @phone = phone number \n'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.OwnerHub_New'
go
/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.OwnerHub_New 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.OwnerHub_New to [public]
