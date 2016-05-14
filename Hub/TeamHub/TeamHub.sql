use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.TeamHub
----------------------------------------------

create table dbo.TeamHub (
   id             bigint
  ,name           varchar(512)  
  ,constraint teamHub_pk primary key clustered (id)
)
go

create sequence seq.TeamHub as bigint
    start with 1
    increment by 1 ;
go
