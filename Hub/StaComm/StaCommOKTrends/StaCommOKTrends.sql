use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StaCommOKTrends
----------------------------------------------
create table dbo.StaCommOKTrends (
   id                     bigint   not null
  ,groupID                bigint   not null

  ,dayDate                date     not null

  ,commReach              bigint       null
  ,commReach_own          bigint       null
  ,commReach_earned       bigint       null
  ,commReach_mob          bigint       null
  ,commReach_web          bigint       null
  ,commReach_mobweb       bigint       null

  ,commEngagement         bigint       null
  ,commFeedback           bigint       null

  ,commMembers_count      bigint       null
  ,commNew_members        bigint       null
  ,commNew_members_target bigint       null
  ,commLeft_members       bigint       null
  ,commMembers_diff       bigint       null

  ,commRenderings         bigint       null
  
  ,commPage_visits        bigint       null

  ,commContent_opens      bigint       null

  ,commLikes              bigint       null
  ,commComments           bigint       null
  ,commReshares           bigint       null

  ,commVotes              bigint       null
  ,commLink_clicks        bigint       null
  ,commVideo_plays        bigint       null
  ,commMusic_plays        bigint       null
  
  ,commTopic_opens        bigint       null
  ,commPhoto_opens        bigint       null
  ,commNegatives          bigint       null
  ,commHides_from_feed    bigint       null
  ,commComplaints         bigint       null

  ,requestDate            datetime not null
  ,cntReq                 int      not null 

  ,constraint StaCommOKTrends_pk primary key nonclustered (id)
)
go

create sequence seq.StaCommOKTrends as bigint
  start with 1
  increment by 1 ;
go

create clustered index StaCommOKTrends_dayDate 
  on dbo.StaCommOKTrends (dayDate desc, groupID)
go