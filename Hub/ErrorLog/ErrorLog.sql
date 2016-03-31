use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.ErrorLog
----------------------------------------------
create table dbo.ErrorLog (
   ID                              bigint
  ,SessionID                       bigint
  ,FuncName                        sysname      null
  ,Params                          varchar(max) null
  ,ErrorText                       varchar(max) null
  ,CreateDate                      datetime
  ,constraint ErrorLog_pk primary key clustered (ID)
)
go

alter table dbo.ErrorLog
  add constraint Error_fkSessionID
  foreign key (SessionID) references dbo.Session (ID)
go

create sequence seq.ErrorLog as bigint
    start with 1
    increment by 1 ;
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.ErrorLog'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.ErrorLog'
  ,@Author      = 'Igor Cova'
  ,@Description = 'ErrorLog table'
  ,@Params = '
     CreateDate = Date create \n
    ,ErrorText = Error text \n
    ,FuncName = function/procedure name \n
    ,ID = ID seq \n
    ,SessionID = Session ID \n
    ,Params = list of input parameters \n'
go
