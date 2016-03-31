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
/// procedure for Save comm.
///</description>
*/
alter procedure dbo.Comm_Save
   @id              bigint  = null out
  ,@ownerPubID      bigint
  ,@subjectCommID   bigint
  ,@areaCommID      int
  ,@name            varchar(256)
  ,@adminCommID     bigint
  ,@link            varchar(512)
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
  set @name = fn.Trim(@name)

  if not exists (
      select * 
        from dbo.Comm as s 
        where s.id = @id)
  begin
    set @id = next value for seq.Comm

    insert into dbo.Comm ( 
       id
      ,ownerPubID
      ,subjectCommID
      ,areaCommID
      ,name
      ,adminCommID 
      ,link
    ) values (
       @id
      ,@ownerPubID
      ,@subjectCommID
      ,@areaCommID
      ,@name
      ,@adminCommID
      ,@link
    )
  end
  else
  begin
    update t set    
         t.subjectCommID = @subjectCommID
        ,t.link          = @link
        ,t.name          = @name
        ,t.adminCommID   = @adminCommID
        ,t.areaCommID = @areaCommID
      from dbo.Comm as t
      where t.id = @id
        and t.ownerPubID = @ownerPubID
  end

  select top 1
       t.id
      ,t.ownerPubID
      ,t.subjectCommID
      ,t.areaCommID
      ,t.name
      ,t.adminCommID
    from dbo.Comm as t       
    where t.id = @id 
      and t.ownerPubID = @ownerPubID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.Comm_Save'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Comm_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save comm.'
  ,@Params = '
       @adminCommID = admin comm id \n
      ,@areaCommID = area social network \n
      ,@link = link to community \n
      ,@name = name \n
      ,@ownerPubID = owner pub id \n
      ,@subjectCommID = subject comm id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_Save to [public]
