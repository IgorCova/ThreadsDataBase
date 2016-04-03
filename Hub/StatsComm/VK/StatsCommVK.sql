use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StatsCommVK
----------------------------------------------
create table dbo.StatsCommVK (
   id                   bigint
  ,ownerHubID           bigint
  ,requestDate          datetime
  ,commID               bigint

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
  ,constraint StatsCommVK_pk primary key clustered (id)
)
go

alter table dbo.StatsCommVK
  add constraint StatsCommVK_fkOwnerHubID
  foreign key (ownerHubID) references dbo.OwnerHub (id)
go

alter table dbo.StatsCommVK
  add constraint StatsCommVK_fkCommID
  foreign key (commID) references dbo.Comm (id)
go

create sequence seq.StatsCommVK as bigint
  start with 1
  increment by 1 ;
go
