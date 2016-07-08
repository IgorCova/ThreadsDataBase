use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'Exception_Report', 'P'
go

alter procedure dbo.Exception_Report
   @dateFrom   datetime = null
  ,@dateTo     datetime = null
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
  -----------------------------------------------------------------
  set @dateFrom = isnull(@dateFrom, dateadd(minute, -60,getdate()) )
  set @dateTo = isnull(@dateTo, getdate()+1)

  select
       t.methodName
      ,t.exMessage 
      ,t.note    
      ,count(t.exDate) as countExcept 
      ,max(t.exDate)   as lastDate
    from dbo.Exception as t       
    where t.exDate between @dateFrom and @dateTo
    group by t.methodName, t.exMessage,t.note
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Exception_Report'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for report Exceptions'
  ,@Params      = '
    ,@dateFrom = action date from \n
    ,@dateTo = action date to \n
    '
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.Exception_Report'
go

/* Debug:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Exception_Report 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
--grant execute on dbo.Exception_Report to [public]
