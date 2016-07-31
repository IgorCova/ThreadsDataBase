use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.ProjectHub_Save', 'P'
go

alter procedure dbo.ProjectHub_Save
   @id         bigint = null
  ,@ownerHubID bigint
  ,@name       varchar(512)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 05.07.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  exec dbo.Getter_Save @ownerHubID, 'Save', 'dbo.ProjectHub_Save'
  -----------------------------------------------------------------
  set @id = nullif(@id, 0)

  if @id is null
  begin
    set @id = next value for seq.ProjectHub

    insert into dbo.ProjectHub ( 
       id
      ,ownerHubID
      ,name
      ,createDate
      ,lastUpdate 
    ) values (
       @id
      ,@ownerHubID
      ,@name
      ,getdate()
      ,getdate() 
    )
  end
  else
  begin
    update t set    
         t.name       = @name
        ,t.lastUpdate = getdate()  
      from dbo.ProjectHub as t
      where t.id = @id
        and t.ownerHubID = @ownerHubID
  end
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.ProjectHub_Save'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.ProjectHub_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'proc for save Projects Hub'
  ,@Params      = '@ownerHubID = owner hub ID  \n
                  ,@name = name \n'
go

/* DEBUG:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.ProjectHub_Save

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.ProjectHub_Save to [public]

 