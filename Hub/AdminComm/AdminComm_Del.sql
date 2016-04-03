use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.DropIfExists 'dbo.AdminComm_Del'
go
 
create procedure dbo.AdminComm_Del
   @id             bigint
  ,@ownerHubID     bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 02.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare @comms varchar(256), @ErrMsg varchar(max)
  select
       @comms = concat(@comms + ' и ', c.name)
    from dbo.Comm as c
    where c.ownerHubID = @ownerHubID
      and c.adminCommID = @id

  if (@@rowcount = 0)
  begin
    delete  
      from dbo.AdminComm
      where id = @id and
            @ownerHubID = @ownerHubID
  end
  else
  begin   
    set @ErrMsg = concat('Удаление не возможно: админ является ответственным в сообществе ', @comms)
    raiserror (@ErrMsg, 13, 1)
    return (-1)
  end
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.AdminComm_Del'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for delete Admin of community.'
  ,@Params = '
     @firstName = Firstname \n
    ,@lastName = Lastname \n
    ,@linkFB = lint to facebook \n
    ,@phone = phone number \n
    ,@ownerHubID = Owner Hub id \n'
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.AdminComm_Del'
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
begin tran
  exec @ret = dbo.AdminComm_Del 
     @id          = 2
    ,@ownerHubID  = 1
rollback tran
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.AdminComm_Del to [public]
