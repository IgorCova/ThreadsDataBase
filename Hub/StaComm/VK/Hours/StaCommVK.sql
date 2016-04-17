use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StaCommVK
----------------------------------------------
create table dbo.StaCommVK (
   id                   bigint
  ,commID               bigint

  ,requestDate          date
  ,requestStartDate     datetime
  ,requestFinishDate    datetime      

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

  ,constraint StaCommVK_pk primary key clustered (id)
)
go

create sequence seq.StaCommVK as bigint
  start with 1
  increment by 1 ;
go

alter table dbo.StaCommVK
  add constraint StaCommVK_fkCommID
  foreign key (commID) references dbo.Comm (id)
go


