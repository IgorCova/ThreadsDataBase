use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StaCommVKWeekly
----------------------------------------------
create table dbo.StaCommVKWeekly (
   id                   bigint
  ,commID               bigint

  ,weekDate              date -- Date From of week

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
  ,cntReq               int          

  ,constraint StaCommVKWeekly_pk primary key nonclustered (id)
)
go

create sequence seq.StaCommVKWeekly as bigint
  start with 1
  increment by 1 ;
go

alter table dbo.StaCommVKWeekly
  add constraint StaCommVKWeekly_fkCommID
  foreign key (commID) references dbo.Comm (id)
go

create clustered index StaCommVKWeekly_dayDate 
  on dbo.StaCommVKWeekly (weekDate, commID)
go