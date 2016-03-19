set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure for reading all columns Communities
///</description>
*/
alter procedure [dbo].[ColumnCommunity.ReadDict]
   @CommunityID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 19.03.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------

  select
       t.ID
      ,t.Name
    from dbo.ColumnCommunity as t
    outer apply (
      select top 1 
           e.ID   as true
        from dbo.Entry  as e       
        where e.CommunityID = t.CommunityID 
          and e.ColumnID = t.ID) as e
    where t.CommunityID = @CommunityID
      and t.DeleteDate is null
      and e.[true] is not null

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[ColumnCommunity.ReadDict]'
go


----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[ColumnCommunity.ReadDict]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for reading Communities'
  ,@Params      = '@CommunityID = Community ID'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[ColumnCommunity.ReadDict]
  @CommunityID = 1
select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[ColumnCommunity.ReadDict] to [public]
go