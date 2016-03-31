set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.Comm
----------------------------------------------
create table dbo.Comm (
   id              bigint
  ,ownerPubID      bigint
  ,subjectCommID   bigint
  ,areaCommID      int
  ,name            varchar(256)
  ,adminCommID     bigint
  ,link            varchar(512)
  ,constraint Comm_pk primary key clustered (id)
)
go

alter table dbo.Comm
  add constraint Comm_fkOwnerPubID
  foreign key (ownerPubID) references dbo.OwnerPub (id)
go

alter table dbo.Comm
  add constraint Comm_fkAreaCommID
  foreign key (areaCommID) references dbo.AreaComm (id)
go

alter table dbo.Comm
  add constraint Comm_fkSbjectCommID
  foreign key (subjectCommID) references dbo.SubjectComm (id)
go

alter table dbo.Comm
  add constraint Comm_fkAdminCommID
  foreign key (adminCommID) references dbo.AdminComm (id)
go

create sequence seq.Comm as bigint
    start with 1
    increment by 1 ;
go