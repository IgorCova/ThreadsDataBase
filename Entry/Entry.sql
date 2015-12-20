set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[Entry]
----------------------------------------------

create table [dbo].[Entry] (
   ID                              bigint
  ,CommunityID                     bigint
  ,ColumnID                        bigint
  ,CreatorID                       bigint
  ,EntryText                       varchar(4048)   null

  ,CreateDate                      datetime
  ,DeleteDate                      datetime        null
  ,DeleteNote                      varchar(1024)   null
  ,constraint [Entry.pk] primary key clustered ([ID])
)
go

alter table [dbo].[Entry]
  add constraint [Entry.fkCommunityID]
  foreign key (CommunityID) references dbo.Community ([ID])
go

alter table [dbo].[Entry]
  add constraint [Entry.fkColumnID]
  foreign key (ColumnID) references dbo.ColumnCommunity ([ID])
go

alter table [dbo].[Entry]
  add constraint [Entry.fkCreatorID]
  foreign key (CreatorID) references dbo.Person ([ID])
go

create sequence seq.[Entry] as bigint
    start with 1
    increment by 1 ;
go