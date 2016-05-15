use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.StaCommVKGraph
----------------------------------------------
create table dbo.StaCommVKGraph (
   id                     bigint
  ,groupID                bigint

  ,dayDate                date

   -- Feedback
  ,commLikes              bigint
  ,commComments           bigint
  ,commShare              bigint
  ,commRemoved            bigint

  -- Activity
  ,commPhotos             bigint
  ,commPhotoComments      bigint
  ,commVideoComments      bigint
  ,commDiscussionComments bigint
  ,commMarketComments     bigint
  ,requestDate            datetime
  ,cntReq                 int          

  ,constraint StaCommVKGraph_pk primary key nonclustered (id)
)
go

create sequence seq.StaCommVKGraph as bigint
  start with 1
  increment by 1 ;
go

create unique clustered index StaCommVKGraph_ix_dayDate 
  on dbo.StaCommVKGraph (dayDate, groupID)
go