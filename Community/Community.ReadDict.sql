set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure for reading Communities
///</description>
*/
alter procedure [dbo].[Community.ReadDict]
   @MemberID bigint = null
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
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
      ,t.Tagline
      ,t.OwnerID
      ,t.CreateDate
      ,isnull(m.IsMember, @false) as IsMember
      ,c.DefaultColumnID
      ,cm.CountMembers
    from dbo.Community as t
    outer apply (
      select top 1 
           @true as IsMember
        from dbo.MemberCommunity as m 
        where m.CommunityID = t.ID
          and m.MemberID = @MemberID
    ) as m

    outer apply (
      select top 1 
           c.ID as DefaultColumnID
        from dbo.ColumnCommunity  as c      
        where c.CommunityID = t.ID 
          and c.Name = 'Timeline' 
    ) as c

    outer apply (
      select
           try_cast(count(m.MemberID) as varchar(32)) as CountMembers
        from dbo.MemberCommunity as m       
        where m.CommunityID = t.ID 
    ) as cm
    where t.ClosedDate is null
    order by isnull(m.IsMember, @false) desc, t.Name
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Community.ReadDict]'
go


----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.ReadDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for reading Communities'
  ,@Params      = '@MemberID = Member ID'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.ReadDict]
  @MemberID = 1
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Community.ReadDict] to [public]
go