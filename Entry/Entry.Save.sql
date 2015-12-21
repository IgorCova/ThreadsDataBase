set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///   procedure for Save entry of community.
///</description>
*/
alter procedure [dbo].[Entry.Save]
   @ID             bigint  = null out
  ,@CommunityID    bigint 
  ,@ColumnID       bigint
  ,@Name           varchar(128)
  ,@CreatorID      bigint          
  ,@EntryText      varchar(4048)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 22.12.2015
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
        from dbo.Entry as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.Entry
    
    select
         @CreatorID = c.OwnerID
      from dbo.Community as c       
      where c.ID = @CommunityID

    insert into dbo.Entry ( 
       ID
      ,CommunityID
      ,ColumnID
      ,CreatorID
      ,EntryText
      ,CreateDate 
    ) values (
       @ID
      ,@CommunityID
      ,@ColumnID
      ,@CreatorID
      ,@EntryText      
      ,getdate() 
    )

  end
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Entry.Save]'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Entry.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for Save entry of community.'
  ,@Params = '
      @ID = ID column \n
     ,@CommunityID = ID community \n
     ,@Name = Name column \n
     ,@CreatorID = ID creator column \n
     ,@ColumnID = ID Column of community \n
     ,@EntryText = Text  \n
     '
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Entry.Save] -- '[dbo].[Entry.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[Entry.Save] to [public]
