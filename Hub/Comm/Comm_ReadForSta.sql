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

  select distinct
      t.groupID
    from dbo.Comm        as t
    outer apply (
      select
           max(s.commPostCount) as commPostCount
        from dbo.StaCommVKDaily as s    
        where s.commID = t.id 
    ) as s
    where @IsNewComm = cast(0 as bit)
       or (    t.IsNew = @IsNewComm
           and @IsNewComm = cast(1 as bit))
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
  ,@Params      = '@IsNewComm = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_ReadForSta 
  @IsNewComm = 0

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_ReadForSta to [public]
