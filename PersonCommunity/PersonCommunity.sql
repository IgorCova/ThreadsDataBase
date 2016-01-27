set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[PersonCommunity]
----------------------------------------------

create table [dbo].[PersonCommunity] (
   PersonID                        bigint
  ,CommunityID                     bigint

  ,CreateDate                      datetime
  ,constraint [PersonCommunity.pk] primary key clustered (PersonID, CommunityID)
)
go

alter table [dbo].[PersonCommunity]
  add constraint [PersonCommunity.fkCommunityID]
  foreign key (CommunityID) references dbo.Community ([ID])
go

alter table [dbo].[PersonCommunity]
  add constraint [PersonCommunity.fkCreatorID]
  foreign key (PersonID) references dbo.Person ([ID])
go
