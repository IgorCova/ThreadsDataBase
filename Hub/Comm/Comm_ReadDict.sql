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
/// procedure for read owner Hub.
///</description>
*/
alter procedure dbo.Comm_ReadDict
   @ownerHubID     bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 11.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------

  select
       t.id             as id
      ,t.name           as name

      ,t.ownerHubID     as ownerHubID
      ,h.firstName      as ownerHubID_firstName
      ,h.lastName       as ownerHubID_lastName
      ,h.linkFB         as ownerHubID_linkFB

      ,t.subjectCommID  as subjectCommID
      ,s.name           as subjectCommID_name

      ,t.areaCommID     as areaCommID
      ,a.name           as areaCommID_name

      ,t.adminCommID    as adminCommID
      ,c.firstName      as adminCommID_firstName
      ,c.lastName       as adminCommID_lastName
      ,c.phone          as adminCommID_phone
      ,c.linkFB         as adminCommID_linkFB
    from dbo.Comm        as t
    join dbo.OwnerHub    as h on h.id = t.ownerHubID
    join dbo.SubjectComm as s on s.id = t.subjectCommID 
                             and s.ownerHubId = t.ownerHubID

    join dbo.AdminComm   as c on c.id = t.adminCommID 
                             and c.ownerHubId = t.ownerHubID

    join dbo.AreaComm    as a on a.id = t.areaCommID
    where t.ownerHubID = @ownerHubID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Comm_ReadDict'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Comm_ReadDict'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read comms by owner Hub id.'
  ,@Params      = '@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_ReadDict 
  @ownerHubId = 3

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_ReadDict to [public]
