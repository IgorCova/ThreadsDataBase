use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKDaily_Request', 'P'
go

alter procedure dbo.StaCommVKDaily_Request
   @dateFrom datetime
  ,@dateTo   datetime
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 16.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  ----------------------------------------------------------------
  declare @groupID bigint

  declare request cursor local fast_forward for
  select distinct c.groupID
    from dbo.Comm as c

  open request
    fetch next from request into @groupID  
    while @@fetch_status = 0
    begin
      exec dbo.sp_ws_VKontakte_Sta_ByDate 
         @groupID  = @groupID   
        ,@dateFrom = @dateFrom   
        ,@dateTo   = @dateTo
      fetch next from request into @groupID
    end
  close request
  deallocate request
-----------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.StaCommVKDaily_Request'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKDaily_Request'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for request statistic on Vkontakte for every groups.'
  ,@Params      = '
    @dateFrom = Date From \n
   ,@dateTo = Date To \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKDaily_Request 
   @dateFrom = '20160415'
  ,@dateTo   = '20160416'

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
--grant execute on dbo.StaCommVKDaily_Request to [public]
