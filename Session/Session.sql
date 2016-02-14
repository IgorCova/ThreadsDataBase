set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[Session]
----------------------------------------------
create table [dbo].[Session] (
   ID                              bigint
  ,SessionReqID                    bigint
  ,SessionID                       varchar(64)
  ,CreateDate                      datetime 
  ,constraint [Session.pk] primary key nonclustered ([ID])
)
go

alter table dbo.[Session] 
add constraint [Session.fkReqID]
  foreign key (SessionReqID) references dbo.SessionReq (ID)
go

create index [Session.ixSessionID]
  on dbo.[Session] (SessionID)
go

create sequence seq.[Session] as bigint
    start with 1
    increment by 1 ;
go
