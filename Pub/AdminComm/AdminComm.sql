set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.AdminComm
----------------------------------------------

create table dbo.AdminComm (
   id             bigint
  ,ownerPubId     bigint
  ,firstName      varchar(512)
  ,lastName       varchar(512)
  ,phone          varchar(32)
  ,linkFB         varchar(512)
  ,constraint adminComm_pk primary key clustered (id)
)
go

create unique index AdminComm_uixName
  on dbo.AdminComm (phone, ownerPubId)
go

alter table dbo.AdminComm
  add constraint AdminComm_fkownerPubID
  foreign key (ownerPubID) references dbo.OwnerPub (id)
go

create sequence seq.AdminComm as bigint
    start with 1
    increment by 1 ;
go