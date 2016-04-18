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
///   procedure for read subjects of community.
///</description>
*/
alter procedure dbo.SubjectComm_ReadDict
  @ownerHubID bigint 
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
  exec dbo.Getter_Save @ownerHubID, 'ReadDict', 'dbo.SubjectComm_ReadDict'
  -----------------------------------------------------------------
  select
       t.id
      ,t.ownerHubID
      ,t.name
    from dbo.SubjectComm as t       
    where t.ownerHubID = @ownerHubID
    order by t.name
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.SubjectComm_ReadDict'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.SubjectComm_ReadDict'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save subject of community.'
  ,@Params = '
     ,@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.SubjectComm_ReadDict 
   @ownerHubID = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.SubjectComm_ReadDict to [public]
