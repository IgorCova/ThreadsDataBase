set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[Community]
----------------------------------------------

create table [dbo].[Community] (
   ID                              bigint
  ,Name                            varchar(128)
  ,Link                            varchar(1024)   null
  ,Decription                      varchar(1024)   null
  ,OwnerID                         bigint          

  ,CreateDate                      datetime
  ,ClosedDate                      datetime        null
  ,ClosedNote                      varchar(1024)   null
  ,constraint [Community.pk] primary key clustered ([ID])
)
go

create index [Community.ixName]
  on dbo.[Community] (Name)
go

create index [Community.ixCreateDate]
  on dbo.[Community] (CreateDate)
go

alter table [dbo].[Community]
  add constraint [Community.fkOwner]
  foreign key (OwnerID) references dbo.Member ([ID])
go

create sequence seq.Community as bigint
    start with 1
    increment by 1 ;
go