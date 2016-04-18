use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.Getter
----------------------------------------------
create table dbo.Getter (
   id              bigint
  ,ownerHubID      bigint

  ,gsAction        varchar(256)
  ,gsProcedure     sysname
  ,gsDate          datetime
  ,constraint Getter_pk primary key clustered (id)
)
go

create sequence seq.Getter as bigint
  start with 1
  increment by 1
go