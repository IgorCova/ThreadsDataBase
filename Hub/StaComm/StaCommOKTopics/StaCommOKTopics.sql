use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StaCommOKTopics
----------------------------------------------
create table dbo.StaCommOKTopics (
   id                    bigint   not null
  ,groupID               bigint   not null

  ,dayDate               date     not null

  ,commRenderings        bigint       null
  ,commRenderings_own    bigint       null
  ,commRenderings_earned bigint       null

  ,commContent_opens     bigint       null

  ,commReach             bigint       null
  ,commReach_own         bigint       null
  ,commReach_earned      bigint       null

  ,commEngagement        bigint       null

  ,commFeedback          bigint       null
  ,commFeedback_total    bigint       null
  
  ,commPostCount         bigint       null
  
  ,commLikes             bigint       null
  ,commComments          bigint       null
  ,commReshares          bigint       null

  ,commVideo_plays       bigint       null
  ,commMusic_plays       bigint       null
  ,commLink_clicks       bigint       null
  ,commNegatives         bigint       null
  ,commHides_from_feed   bigint       null
  ,commComplaints        bigint       null

  ,requestDate           datetime not null
  ,cntReq                int      not null 

  ,constraint StaCommOKTopics_pk primary key nonclustered (id)
)
go

create sequence seq.StaCommOKTopics as bigint
  start with 1
  increment by 1 ;
go

create clustered index StaCommOKTopics_dayDate 
  on dbo.StaCommOKTopics (dayDate desc, groupID)
go