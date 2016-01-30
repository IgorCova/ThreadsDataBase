set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[MemberCommunity]
----------------------------------------------

create table [dbo].[MemberCommunity] (
   MemberID                        bigint
  ,CommunityID                     bigint

  ,CreateDate                      datetime
  ,constraint [MemberCommunity.pk] primary key clustered (MemberID, CommunityID)
)
go

alter table [dbo].[MemberCommunity]
  add constraint [MemberCommunity.fkCommunityID]
  foreign key (CommunityID) references dbo.Community ([ID])
go

alter table [dbo].[MemberCommunity]
  add constraint [MemberCommunity.fkMemberID]
  foreign key (MemberID) references dbo.Member ([ID])
go
