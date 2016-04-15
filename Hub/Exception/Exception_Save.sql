use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'Exception_Save', 'P'
go

alter procedure dbo.Exception_Save
   @methodName              sysname     = null
  ,@note                    varchar(max) = null
  ,@exMessage               varchar(max)
  ,@exInnerExceptionMessage varchar(max)
  ,@exHelpLink              varchar(max)
  ,@exHResult               int
  ,@exSource                varchar(max)
  ,@exStackTrace            varchar(max)
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
  declare @id bigint = next value for seq.Exception

  insert into dbo.Exception ( 
     id
    ,methodName
    ,note
    ,exDate
    ,exMessage
    ,exInnerExceptionMessage
    ,exHelpLink
    ,exHResult
    ,exSource
    ,exStackTrace 
  ) values (
     @id
    ,@methodName
    ,@note
    ,getdate()
    ,@exMessage
    ,@exInnerExceptionMessage
    ,@exHelpLink
    ,@exHResult
    ,@exSource
    ,@exStackTrace 
  )
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Exception_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Exception.'
  ,@Params      = '
    @exHelpLink = HelpLink \n
   ,@exHResult = HResult \n
   ,@exInnerExceptionMessage = InnerExceptionMessage \n
   ,@exMessage = Message \n
   ,@exSource = Source \n
   ,@exStackTrace = StackTrace \n
   ,@methodName = methodName \n
   ,@note = note \n'
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.Exception_Save'
go

/* Debug:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Exception_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Exception_Save to [public]
