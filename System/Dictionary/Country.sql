set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> [dbo].[Country]
----------------------------------------------
create table [dbo].[Country] (
   ID                              int
  ,Name                            varchar(256)
  ,Code                            varchar(32)
  ,IsActive                        bit           
  ,constraint [Country.pk] primary key clustered ([ID])
)
go

create index [Country.ixName]
  on dbo.[Country] (Name)
go

create sequence seq.[Country] as bigint
    start with 1
    increment by 1 ;
go
