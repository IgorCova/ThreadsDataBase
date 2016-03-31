use Pub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// procedure for Save owner pub.
///</description>
*/
alter procedure dbo.OwnerPub_Save
   @id             bigint  = null out
  ,@firstName      varchar(512) 
  ,@lastName       varchar(512)
  ,@phone          varchar(32)
  ,@linkFB         varchar(512)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 30.03.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @linkFB = fn.ClearLinkToFB(@linkFB)
  set @firstName = fn.Trim(@firstName)
  set @lastName = fn.Trim(@lastName)
  set @phone = fn.ClearPhone(@phone)

  if not exists (
      select * 
        from dbo.OwnerPub as s 
        where s.id = @id)
  begin
    set @id = next value for seq.OwnerPub

    insert into dbo.OwnerPub ( 
       id
      ,firstName
      ,lastName
      ,phone
      ,linkFB 
    ) values (
       @id
      ,@firstName
      ,@lastName
      ,@phone
      ,@linkFB
    )
  end
  else
  begin
    update t set    
         t.firstName = @firstName
        ,t.lastName  = @lastName
        ,t.phone     = @phone
        ,t.linkFB    = @linkFB  
      from dbo.OwnerPub as t
      where t.id = @id
  end

  select top 1
       t.id
      ,t.firstName
      ,t.lastName
      ,t.phone
      ,t.linkFB
    from dbo.OwnerPub as t
    where t.id = @id
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.OwnerPub_Save'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.OwnerPub_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save owner pub.'
  ,@Params = '
      @firstName = First Name \n
     ,@lastName = Last Name \n
     ,@linkFB = link to facebook \n
     ,@phone = phone number \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.OwnerPub_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.OwnerPub_Save to [public]
