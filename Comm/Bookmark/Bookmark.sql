set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <TABLE> dbo.Bookmark
----------------------------------------------

create table dbo.Bookmark (
   EntryID   bigint
  ,MemberID  bigint
  ,PinDate   datetime
  ,constraint Bookmark_pk primary key clustered (EntryID, MemberID)
)
go

alter table dbo.Bookmark
  add constraint Bookmark_fkEntryID
  foreign key (EntryID) references dbo.Entry (ID)
go

alter table dbo.Bookmark
  add constraint Bookmark_fkMemberID
  foreign key (MemberID) references dbo.Member (ID)
go