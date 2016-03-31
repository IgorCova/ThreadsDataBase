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
  ,ownerPubID   bigint
  ,name         varchar(256)
  ,constraint SubjectComm_pk primary key clustered (id)
)
go

create unique index SubjectComm_uixName
  on dbo.SubjectComm (ownerPubID, name)
go

alter table dbo.SubjectComm
  add constraint SubjectComm_fkownerPubID
  foreign key (ownerPubID) references dbo.OwnerPub (id)
go

create sequence seq.SubjectComm as bigint
    start with 1
    increment by 1 ;
go