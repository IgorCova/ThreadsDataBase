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
///   procedure for Save Admin of community.
///</description>
*/
alter procedure dbo.AdminComm_Save
   @id             bigint = null
  ,@ownerHubID     bigint
  ,@firstName      varchar(512)
  ,@lastName       varchar(512)
  ,@phone          varchar(32)
  ,@linkFB         varchar(512)
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
  exec dbo.Getter_Save @ownerHubID, 'Save', 'dbo.AdminComm_Save'
  -----------------------------------------------------------------
  set @linkFB = fn.ClearLinkToFB(@linkFB)
  set @firstName = fn.Trim(@firstName)
  set @lastName = fn.Trim(@lastName)
  set @phone = fn.ClearPhone(@phone)

  if not exists (
      select * 
        from dbo.AdminComm as s 
        where s.id = @id)
  begin
    set @id = next value for seq.AdminComm

    insert into dbo.AdminComm ( 
       id
      ,ownerHubId
      ,firstName
      ,lastName
      ,phone
      ,linkFB 
    ) values (
       @id
      ,@ownerHubID
      ,@firstName
      ,@lastName
      ,@phone
      ,@linkFB 
    )
  end
  else
  begin
    update t set    
         t.firstName     = @firstName
        ,t.lastName      = @lastName
        ,t.phone         = @phone
        ,t.linkFB        = @linkFB  
      from dbo.AdminComm as t
      where t.id = @id 
        and t.ownerHubID = @ownerHubID
  end

  select
       a.id
      ,a.ownerHubId
      ,a.firstName
      ,a.lastName
      ,a.phone
      ,a.linkFB
    from dbo.AdminComm as a       
    where a.id = @id

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.AdminComm_Save'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.AdminComm_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Admin of community.'
  ,@Params = '
     @firstName = Firstname \n
    ,@lastName = Lastname \n
    ,@linkFB = lint to facebook \n
    ,@phone = phone number \n
    ,@ownerHubID = Owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.AdminComm_Save 
     @id         = 12
    ,@ownerHubID = 3 
    ,@firstName  = 'Gevorg'
    ,@lastName   = 'Osipyan'
    ,@linkFB     = 'https://www.facebook.com/1751641651'
    ,@phone      = '77777777777'

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.AdminComm_Save to [public]