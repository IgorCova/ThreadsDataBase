use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.AreaComm
----------------------------------------------
create table dbo.AreaComm (
   id           int
  ,links        varchar(1024)
  ,name         varchar(256)
  ,constraint AreaComm_pk primary key clustered (id)
)
go

create sequence seq.AreaComm as int
    start with 1
    increment by 1 ;
go