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
///   procedure for read Admin of community.
///</description>
*/
alter procedure dbo.AdminComm_ReadDict
   @ownerHubID     bigint
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
  exec dbo.Getter_Save @ownerHubID, 'ReadDict', 'dbo.AdminComm_ReadDict'
  -----------------------------------------------------------------
  declare @teamHubID bigint

  select top 1 
       @teamHubID = t.teamHubID
    from dbo.OwnerHub as t       
    where t.id = @ownerHubID
  
  declare @ownersTeam table (id bigint)
  insert into @ownersTeam ( id ) values (@ownerHubID)
  insert into @ownersTeam ( id )
  select
       t.id
    from dbo.OwnerHub as t       
    where t.TeamHubID = @teamHubID
     and t.id <> @ownerHubID

  select
       t.id
      ,t.firstName
      ,t.lastName
      ,cast(fn.FormatPhone(t.phone) as varchar(32)) as phone
      ,t.linkFB
    from dbo.AdminComm as t
    join @ownersTeam   as o on o.id = t.ownerHubID  
    order by t.lastName

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.AdminComm_ReadDict'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.AdminComm_ReadDict'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read Admin of community.'
  ,@Params = '
     @ownerHubID = Owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.AdminComm_ReadDict 
   @ownerHubID = 63

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.AdminComm_ReadDict to [public]
