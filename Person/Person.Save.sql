set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// procedure for Save Person.
///</description>
*/
alter procedure [dbo].[Person.Save]
   @ID             bigint  = null out
  ,@Name           varchar(256)
  ,@Surname        varchar(256) = null
  ,@UserName       varchar(32) = null
  ,@About          varchar(1024) = null

  ,@debug_info     int = 0
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
        from dbo.Person as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.Person
    
    insert into dbo.Person ( 
       ID
      ,Name
      ,Surname
      ,UserName
      ,About
      ,JoinedDate 
    ) values (
       @ID
      ,@Name
      ,@Surname
      ,@UserName
      ,@About
      ,getdate() 
    )
  end
  else
  begin
    update t set    
         t.Name           = @Name
        ,t.Surname        = @Surname
        ,t.UserName       = @UserName
        ,t.About          = @About
      from dbo.Person as t
      where t.ID = @ID
  end

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <[NativeCheck]>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Person.Save]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Person.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Person'
  ,@Params = '
      @About = About community \n
     ,@ID = ID community \n
     ,@Name = Name \n
     ,@Surname = Surname \n
     ,@UserName = User Name \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Person.Save] -- '[dbo].[Person.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[Person.Save] to [public]