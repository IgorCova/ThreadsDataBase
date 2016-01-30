set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[Member]
----------------------------------------------
create table [dbo].[Member] (
   ID                              bigint
  ,Name                            varchar(256)    null
  ,Surname                         varchar(256)    null
  ,UserName                        varchar(32)     null
  ,About                           varchar(1024)   null
  ,Phone                           varchar(32)     null
  ,JoinedDate                      datetime        null
  ,LeaveDate                       datetime        null
  ,LeaveNote                       varchar(1024)   null
  ,constraint [Member.pk] primary key clustered ([ID])
)
go

create index [Member.ixName]
  on dbo.[Member] (Name, Surname)
go

create index [Member.ixJoinedDate]
  on dbo.[Member] (JoinedDate)
go

create sequence seq.[Member] as bigint
    start with 1
    increment by 1 ;
go
