set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <VIEW> [dbo].[Member.View]
----------------------------------------------

alter view [dbo].[Member.View]
as
select
     t.ID
    ,t.Name
    ,t.Surname
    ,ltrim(concat(t.Name + ' ', t.Surname)) as FullName
    ,t.UserName
    ,t.About
    ,t.JoinedDate
    ,t.LeaveDate
    ,t.LeaveNote
    ,t.Phone
  from [dbo].[Member] as t                                       
go

/*
select * from [dbo].[Member.View]
--*/
go
