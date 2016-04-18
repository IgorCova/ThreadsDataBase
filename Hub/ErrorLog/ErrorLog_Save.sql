use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

alter procedure dbo.ErrorLog_Save
   @Session                         varchar(64)
  ,@FuncName                        sysname      = null
  ,@Params                          varchar(max) = null
  ,@ErrorText                       varchar(max) = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 12.03.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare
      @ID  bigint
     ,@len int
     ,@SessionID bigint

  select
       @SessionID = @SessionID
    from dbo.Session as s       
    where s.SessionID = @Session

  set @ID = next value for seq.ErrorLog
  
  while @ErrorText like '%' + char(10)
  begin
    set @len = len(@ErrorText)
    set @ErrorText = left(@ErrorText, @len-1)
  end

  set @ErrorText = fn.DelDoubleSpace(@ErrorText)

  insert into dbo.ErrorLog ( 
     ID
    ,SessionID
    ,FuncName
    ,Params
    ,ErrorText
    ,CreateDate 
  ) values (
     @ID
    ,@SessionID
    ,@FuncName
    ,@Params
    ,@ErrorText
    ,getdate() 
  )
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] 'dbo.ErrorLog_Save'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.ErrorLog_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for save ErrorLogs.'
  ,@Params = '
       @ErrorText = Text of error \n
      ,@FuncName = function/procedure name \n
      ,@Session = Session uniqident \n
      ,@Params = list of input parameters \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.ErrorLog_Save 
   @Session    = 'FAEB413F-7AA2-49C5-A18C-824E0A881A9B'
  ,@FuncName   = 'Tester'
  ,@Params     = 'id=1'
  ,@ErrorText  = 'test errol log'

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.ErrorLog_Save to [public]
