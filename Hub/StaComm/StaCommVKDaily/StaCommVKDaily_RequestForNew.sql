use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKDaily_RequestForNew', 'P'
go

alter procedure dbo.StaCommVKDaily_RequestForNew
   @groupID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 17.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  ----------------------------------------------------------------
  -- Заполняем таблицу датами с помощью CTE
  declare
     @DateFrom datetime = cast(getdate()-2 as date)
    ,@DateTo   datetime = cast(getdate()-1 as date)

  declare @Dates table ([Date] date not null, primary key ([Date]));
  with Dates([Date]) 
  as ( select
            @DateFrom as [Date]       
       union all         
       select
            dateadd(day ,1 ,[Date]) as [Date]   
         from Dates as t
         where @DateTo > t.[Date])

  insert into @Dates
  select
       [Date]
    from Dates

  declare request cursor local fast_forward for
  select
       @groupID
      ,d.[Date]
    from @Dates as d

  open request
    fetch next from request into @groupID, @DateFrom
    while @@fetch_status = 0
    begin
      set @dateTo = dateadd(minute, -1, dateadd(day, 2, @DateFrom))

      exec dbo.sp_ws_VKontakte_Sta_ByDate 
         @groupID  = @groupID   
        ,@dateFrom = @dateFrom   
        ,@dateTo   = @dateTo
      fetch next from request into @groupID, @DateFrom
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
exec dbo.[NativeCheck] 'dbo.StaCommVKDaily_RequestForNew'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKDaily_RequestForNew'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for request statistic on Vkontakte for every groups.'
  ,@Params      = '
    @groupID = New group id \n'
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKDaily_RequestForNew 
   @groupID = 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
--grant execute on dbo.StaCommVKDaily_RequestForNew to [public]
