use Pub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.Session
----------------------------------------------
create table dbo.Session (
   id                              bigint
  ,sessionReqID                    bigint
  ,sessionID                       uniqueidentifier
  ,createDate                      datetime 
  ,constraint Session_pk primary key nonclustered (id)
)
go

alter table dbo.Session 
add constraint Session_fkReqID
  foreign key (SessionReqID) references dbo.SessionReq (id)
go

create index Session_ixSessionID
  on dbo.Session (SessionID)
go

create sequence seq.Session as bigint
    start with 1
    increment by 1 ;
go
