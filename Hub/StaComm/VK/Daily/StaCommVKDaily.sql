use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StaCommVKDaily
----------------------------------------------
create table dbo.StaCommVKDaily (
   id                   bigint
  ,commID               bigint

  ,dayDate              date

  ,commViews            bigint
  ,commVisitors         bigint
  ,commReach            bigint
  ,commReachSubscribers bigint
  ,commSubscribed       bigint
  ,commUnsubscribed     bigint
  ,commLikes            bigint
  ,commComments         bigint
  ,commReposts          bigint
  ,commPostCount        bigint
  ,commMembers          int
  ,requestDate          datetime

  ,constraint StaCommVKDaily_pk primary key nonclustered (id)
)
go

create sequence seq.StaCommVKDaily as bigint
  start with 1
  increment by 1 ;
go

alter table dbo.StaCommVKDaily
  add constraint StaCommVKDaily_fkCommID
  foreign key (commID) references dbo.Comm (id)
go

create clustered index StaCommVKDaily_dayDate 
  on dbo.StaCommVKDaily (dayDate, commID)
go
