use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.OwnerHub
----------------------------------------------

create table dbo.OwnerHub (
   id             bigint
  ,firstName      varchar(512)
  ,lastName       varchar(512)
  ,phone          varchar(32)
  ,linkFB         varchar(512)
  ,TeamHubID      bigint
  ,dateCreate     datetime
  ,constraint ownerHub_pk primary key clustered (id)
)
go

create unique index OwnerHub_uixPhone
  on dbo.OwnerHub (phone)
go

create sequence seq.OwnerHub as bigint
  start with 1
  increment by 1 ;
go


