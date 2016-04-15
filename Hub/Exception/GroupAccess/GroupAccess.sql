use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.GroupAccess
----------------------------------------------
create table dbo.GroupAccess (
   id              bigint
  ,groupID         bigint
  ,requestDate     datetime
  ,exception       varchar(4028)
  ,innerException  varchar(4028)
  ,constraint GroupAccess_pk primary key clustered (id)
)
go

create sequence seq.GroupAccess as bigint
    start with 1
    increment by 1 ;
go
