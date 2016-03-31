use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.SubjectComm
----------------------------------------------
create table dbo.SubjectComm (
   id           bigint
  ,ownerHubID   bigint
  ,name         varchar(256)
  ,constraint SubjectComm_pk primary key clustered (id)
)
go

create unique index SubjectComm_uixName
  on dbo.SubjectComm (ownerHubID, name)
go

alter table dbo.SubjectComm
  add constraint SubjectComm_fkownerHubID
  foreign key (ownerHubID) references dbo.OwnerHub (id)
go

create sequence seq.SubjectComm as bigint
    start with 1
    increment by 1 ;
go