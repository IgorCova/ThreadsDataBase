set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[SessionReq]
----------------------------------------------
create table [dbo].[SessionReq] (
   ID                              bigint
  ,DID                             varchar(64)
  ,Phone                           varchar(64)
  ,CreateDate                      datetime 
  ,constraint [SessionReq.pk] primary key nonclustered ([ID])
)
go

create index [SessionReq.ixSessionReqID]
  on dbo.[SessionReq] (ID)
go

create sequence seq.[SessionReq] as bigint
    start with 1
    increment by 1 ;
go
