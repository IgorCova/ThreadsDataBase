set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure for Saving information about the community
///</description>
*/
alter procedure [dbo].[Community.Save]
   @ID             bigint        = null
  ,@Name           varchar(128)
  ,@Link           varchar(1024) = null
  ,@Decription     varchar(1024) = null
  ,@Tagline        varchar(64)   = null
  ,@OwnerID        bigint          
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
        from dbo.Community as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.Community
    
    insert into dbo.Community ( 
       ID
      ,Name
      ,Link
      ,Decription
      ,Tagline
      ,OwnerID
      ,CreateDate 
    ) values (
       @ID
      ,@Name
      ,@Link
      ,@Decription
      ,@Tagline
      ,@OwnerID
      ,getdate()
    )
    
    exec dbo.[ColumnCommunity.Save]
       @ID          = null   
      ,@CommunityID = @ID   
      ,@Name        = 'Post'   
      ,@CreatorID   = @OwnerID
  end
  else
  begin
    update t set    
         t.Name           = @Name
        ,t.Link           = @Link
        ,t.Decription     = @Decription
        ,t.Tagline        = @Tagline
      from dbo.Community as t
      where ID = @ID
  end

  select
       top 1 c.ID
    from dbo.Community as c       
    where c.ID = @ID

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Community.Save]'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Saving information about the community'
  ,@Params = '
      @Decription = Decription community \n
     ,@ID = ID community \n
     ,@Link = Link to community \n
     ,@Name = Name community \n
     ,@OwnerID = ID owner community \n
     ,@Tagline = Tagline community'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.Save]
   @Name          = 'TEstTest'
  ,@LogoLink      = 'TEstTest.png'
  ,@Link          = 'comm\TEstTest'
  ,@Decription    = 'The TEstTest - project for TEstTest'
  ,@OwnerID       = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Community.Save] to [public]
go