set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// procedure for add new Member.
///</description>
*/
alter procedure [dbo].[Member.New]
   @ID             bigint        = null out
  ,@Name           varchar(256)
  ,@Surname        varchar(256)  = null
  ,@UserName       varchar(32)   = null
  ,@About          varchar(1024) = null
  ,@Phone          varchar(32)   = null
  ,@IsMale         bit           = null
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
        from dbo.Member as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.Member

    insert into dbo.Member ( 
       ID
      ,Name
      ,Surname
      ,UserName
      ,About
      ,JoinedDate 
      ,Phone
      ,IsMale
    ) values (
       @ID
      ,fn.Trim(@Name)
      ,fn.Trim(@Surname)
      ,fn.Trim(@UserName)
      ,fn.Trim(@About)
      ,getdate() 
      ,@Phone
      ,isnull(@IsMale, 1)
    )
  end
  else
  begin
    update t set    
         t.Name           = fn.Trim(@Name)
        ,t.Surname        = fn.Trim(@Surname)
        ,t.UserName       = fn.Trim(@UserName)
        ,t.About          = fn.Trim(@About)
        ,t.Phone          = @Phone
        ,t.IsMale         = isnull(@IsMale, 1)
      from dbo.Member as t
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
exec [dbo].[NativeCheck] '[dbo].[Member.New]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Member.New]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for add new Member'
  ,@Params = '
      @About = About community \n
     ,@ID = ID community \n
     ,@Name = Name \n
     ,@Surname = Surname \n
     ,@UserName = User Name \n
     ,@Phone = Phone number \n
     ,@IsMale = Is Male \n
     '
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Member.New] -- '[dbo].[Member.New]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[Member.New] to [public]