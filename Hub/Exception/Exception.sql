use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.Exception
----------------------------------------------
create table dbo.Exception (
   id                      bigint
  ,methodName              sysname      null
  ,note                    varchar(max) null
  ,exDate                  datetime 

  ,exMessage               varchar(max)
  ,exInnerExceptionMessage varchar(max)
  ,exHelpLink              varchar(max)
  ,exHResult               int
  ,exSource                varchar(max)
  ,exStackTrace            varchar(max)

  ,constraint Exception_pk primary key clustered (id)
)
go

create sequence seq.Exception as bigint
    start with 1
    increment by 1 ;
go
