use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.SexComm
----------------------------------------------
create table dbo.SexComm (
   groupID         bigint
  ,areaCommID      int   
  ,sex             smallint -- 0 Woman 1 Man 2 Undefined
  
  ,other           int
  ,under18         int
  ,from18to21      int
  ,from21to24      int
  ,from24to27      int
  ,from27to30      int
  ,from30to35      int
  ,from35to45      int
  ,over45          int

  ,lastUpdate      datetime
  ,constraint SexComm_pk primary key clustered (groupID, areaCommID, sex)
)
go

create sequence seq.SexComm as bigint
  start with 1
  increment by 1 ;
go

alter table dbo.SexComm
  add constraint SexComm_fkAreaCommID
  foreign key (areaCommID) references dbo.AreaComm (id)
go