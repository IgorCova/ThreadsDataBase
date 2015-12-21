set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[Person]
----------------------------------------------
create table [dbo].[Person] (
   ID                              bigint
  ,Name                            varchar(256)    null
  ,Surname                         varchar(256)    null
  ,UserName                        varchar(32)     null
  ,PhotoLink                       varchar(1024)   null
  ,About                           varchar(1024)   null

  ,JoinedDate                      datetime        null
  ,LeaveDate                       datetime        null
  ,LeaveNote                       varchar(1024)   null
  ,constraint [Person.pk] primary key clustered ([ID])
)
go

create index [Person.ixName]
  on dbo.[Person] (Name, Surname)
go

create index [Person.ixJoinedDate]
  on dbo.[Person] (JoinedDate)
go

create sequence seq.[Person] as bigint
    start with 1
    increment by 1 ;
go