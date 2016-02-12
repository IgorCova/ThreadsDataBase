set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure for reading my Communities
///</description>
*/
alter procedure [dbo].[Community.ReadMyDict]
   @MemberID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 30.12.2015
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare
     @true  bit = cast(1 as bit)
    ,@false bit = cast(0 as bit)

  select
       t.ID
      ,t.Name
      ,t.Link
      ,t.Decription
      ,t.OwnerID
      ,t.CreateDate
      ,isnull(c.IsMember, @false) as IsMember
      ,cc.DefaultColumnID
      ,cm.CountMembers
    from dbo.Community as t
    join dbo.MemberCommunity as m on m.CommunityID = t.ID
    outer apply (
      select top 1 
           @true as IsMember
        from dbo.MemberCommunity as m 
        where m.CommunityID = t.ID
          and m.MemberID = @MemberID
    ) as c
    
    outer apply (
      select top 1 
           c.ID as DefaultColumnID
        from dbo.ColumnCommunity  as c      
        where c.CommunityID = t.ID 
          and c.Name = 'Post' 
    ) as cc

    outer apply (
      select
           try_cast(count(m.MemberID) as varchar(32)) as CountMembers
        from dbo.MemberCommunity as m       
        where m.CommunityID = t.ID 
    ) as cm
    where t.ClosedDate is null
      and m.MemberID = @MemberID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Community.ReadMyDict]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.ReadMyDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for reading Communities by member'
  ,@Params     = '@MemberID = Member ID'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.ReadMyDict]
  @MemberID = 1
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Community.ReadMyDict] to [public]
go