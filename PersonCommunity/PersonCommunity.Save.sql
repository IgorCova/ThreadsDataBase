set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///   procedure for add/del community for person.
///</description>
*/
alter procedure [dbo].[PersonCommunity.Save]
   @PersonID       bigint
  ,@CommunityID    bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 27.01.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------

  if exists(select * from dbo.PersonCommunity as t where t.PersonID = @PersonID and t.CommunityID = @CommunityID)
    delete t
      from dbo.PersonCommunity as t 
      where t.PersonID = @PersonID 
        and t.CommunityID = @CommunityID
  else 
    insert into PersonCommunity ( 
       PersonID
      ,CommunityID
      ,CreateDate 
    ) values (
       @PersonID
      ,@CommunityID
      ,getdate() 
    )
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[PersonCommunity.Save]'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[PersonCommunity.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = ' procedure for add/del community for person.'
  ,@Params = '
      @PersonID = ID Person \n
     ,@CommunityID = ID community \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[PersonCommunity.Save] -- '[dbo].[PersonCommunity.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[PersonCommunity.Save] to [public]
