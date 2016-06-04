use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.Comm_ReadForSta', 'P'
go

alter procedure dbo.Comm_ReadForSta
   @IsNewComm bit
  ,@areaCode  varchar(2) = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 24.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare @action varchar(32) = iif(@IsNewComm = 0,'ReadForSta','ReadForNewSta')
  -----------------------------------------------------------------
  exec dbo.Getter_Save 5, @action, 'dbo.Comm_ReadForSta'
  -----------------------------------------------------------------
  declare @areaID int
  set @IsNewComm = isnull(@IsNewComm, cast(0 as bit))

  if @areaCode is not null
    select @areaID = c.id
      from dbo.AreaComm as c
      where c.code = @areaCode

  select distinct
      t.groupID
     ,t.link
    from dbo.Comm as t
    where t.areaCommID = @areaID
      and isnull(t.IsNew, cast(0 as bit)) = @IsNewComm
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Comm_ReadForSta'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Comm_ReadForSta'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for read comms by sta at WCF-Service.'
  ,@Params      = '@IsNewComm = owner Hub id \n
                   @areaCode = Area Code - Social Network shortname \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_ReadForSta 
  @IsNewComm = 0
 ,@areaCode = 'vk'

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_ReadForSta to [public]
