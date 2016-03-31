set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[ColumnCommunity]
----------------------------------------------

create table [dbo].[ColumnCommunity] (
   ID                              bigint
  ,CommunityID                     bigint
  ,Name                            varchar(32)
  
  ,CreatorID                       bigint
  ,CreateDate                      datetime
  ,DeleteDate                      datetime        null
  ,DeleteNote                      varchar(1024)   null
  ,constraint [ColumnCommunity.pk] primary key clustered ([ID])
)
go

alter table [dbo].[ColumnCommunity]
  add constraint [ColumnCommunity.fkCommunityID]
  foreign key (CommunityID) references dbo.Community ([ID])
go

alter table [dbo].[ColumnCommunity]
  add constraint [ColumnCommunity.fkCreatorID]
  foreign key (CreatorID) references dbo.Member ([ID])
go

create sequence seq.[ColumnCommunity] as bigint
    start with 1
    increment by 1 ;
go