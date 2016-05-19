use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

alter procedure dbo.Comm_Save
   @id              bigint
  ,@ownerHubID      bigint
  ,@subjectCommID   bigint
  ,@name            varchar(256)
  ,@adminCommID     bigint
  ,@link            varchar(512)
  ,@areaCommID      int
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
  exec dbo.Getter_Save @ownerHubID, 'Save', 'dbo.Comm_Save'
  -----------------------------------------------------------------
  set @name = fn.Trim(@name)
  declare @true bit = cast(1 as bit)
  
  if @areaCommID = 1 -- vk
    set @link = fn.ClearLinkToVK(@link)
  else if @areaCommID = 2 -- ok
    set @link = fn.ClearLinkToOK(@link)

  ----------------------------------------
  begin tran Comm_Save
  ----------------------------------------
    if not exists (
        select * 
          from dbo.Comm as s 
          where s.id = @id)
    begin
      set @id = next value for seq.Comm
      
      insert into dbo.Comm ( 
         id
        ,ownerHubID
        ,subjectCommID
        ,areaCommID
        ,name
        ,adminCommID
        ,link
        ,groupID
        ,IsNew
      ) values (
         @id
        ,@ownerHubID
        ,@subjectCommID
        ,@areaCommID
        ,@name
        ,@adminCommID
        ,@link
        ,0
        ,@true
      )

      exec sb.StaCommVKDaily_Request_ForNew_Send
    end
    else
    begin
      update t set
           t.subjectCommID = @subjectCommID
          ,t.link          = @link
          ,t.name          = @name
          ,t.adminCommID   = @adminCommID
        from dbo.Comm as t
        where t.id = @id
          and t.ownerHubID = @ownerHubID
    end
  ----------------------------------------
  commit tran Comm_Save
  ----------------------------------------  
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
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
      ,@link = link to community \n
      ,@name = name \n
      ,@ownerHubID = owner Hub id \n
      ,@subjectCommID = subject comm id \n
      ,@areaCommID = area id \n'
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.Comm_Save'
go

/* Debug:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_Save to [public]
