set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///   procedure for Save column of community.
///</description>
*/
alter procedure [dbo].[ColumnCommunity.Save]
   @ID             bigint  = null out
  ,@CommunityID    bigint 
  ,@Name           varchar(128)
  ,@CreatorID      bigint          
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

  if not exists (
      select * 
        from dbo.ColumnCommunity as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.ColumnCommunity
    
    select
         @CreatorID = c.OwnerID
      from dbo.Community as c       
      where c.ID = @CommunityID

    insert into dbo.ColumnCommunity ( 
       ID
      ,CommunityID
      ,Name
      ,CreatorID
      ,CreateDate 
    ) values (
       @ID
      ,@CommunityID
      ,@Name
      ,@CreatorID
      ,getdate() 
    )

  end
  else
  begin
    update t set    
         t.Name           = @Name
      from dbo.ColumnCommunity as t
      where ID = @ID
  end

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[ColumnCommunity.Save]'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[ColumnCommunity.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Save column of community'
  ,@Params = '
      @ID = ID column \n
     ,@CommunityID = ID community \n
     ,@Name = Name column \n
     ,@CreatorID = ID creator column \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[ColumnCommunity.Save] -- '[dbo].[ColumnCommunity.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[ColumnCommunity.Save] to [public]
