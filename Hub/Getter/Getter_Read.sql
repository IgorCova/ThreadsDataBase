use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.Getter_Read', 'P'
go

alter procedure dbo.Getter_Read
   @dateFrom   datetime = null
  ,@dateTo     datetime = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 20.05.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @dateFrom = isnull(@dateFrom, cast(getdate() as date))
  set @dateTo = isnull(@dateTo, cast(getdate()+1 as date))

  select
       g.gsAction
      ,g.gsProcedure
      ,h.OwnerHub
      ,count(*) as counts
    from dbo.Getter as g   
    join dbo.OwnerHub as o on o.id = g.ownerHubID  
    left join dbo.TeamHub as t on t.id = o.TeamHubID  
    outer apply (select concat(nullif(o.firstName,'') + ' ', nullif(o.lastName,'') + ' ', '(' + t.name + ')') as OwnerHub) h
    where g.gsDate > @dateFrom
      and g.ownerHubID not in (1,5) -- Founder an Server
      and h.OwnerHub <> ''
    group by 
      g.gsAction
     ,g.gsProcedure
     ,h.OwnerHub
   order by 3, 4 desc ,1

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Getter_Read'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Getter_Read'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Read info hwo use CommHub.'
  ,@Params      = '
    ,@dateFrom = action date from \n
    ,@dateTo = action date to \n
    '
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Getter_Read 
  @date = null

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
--grant execute on dbo.Getter_Read to [public]
