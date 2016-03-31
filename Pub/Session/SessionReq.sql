set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.SessionReq
----------------------------------------------
create table dbo.SessionReq (
   id                              bigint
  ,dID                             varchar(64)
  ,phone                           varchar(64)
  ,createDate                      datetime 
  ,constraint SessionReq_pk primary key nonclustered (id)
)
go

create index SessionReq_ixSessionReqID
  on dbo.SessionReq (id)
go

create sequence seq.SessionReq as bigint
    start with 1
    increment by 1 ;
go
