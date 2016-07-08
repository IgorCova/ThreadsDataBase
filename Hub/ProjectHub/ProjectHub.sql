use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.ProjectHub
----------------------------------------------
create table dbo.ProjectHub (
   id           bigint
  ,ownerHubID   bigint
  ,name         varchar(512)
  ,lastUpdate   datetime
  ,createDate   datetime

  ,constraint ProjectHub_pk primary key clustered (id)
)
go

alter table dbo.ProjectHub
  add constraint ProjectHub_fkownerHubID
  foreign key (ownerHubID) references dbo.OwnerHub (id)
go

create sequence seq.ProjectHub as bigint
  start with 1
  increment by 1;
go