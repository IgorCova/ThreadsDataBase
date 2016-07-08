use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'Comm_Set', 'P'
go

alter procedure dbo.Comm_Set
   @link            varchar(512)
  ,@groupID         bigint
  ,@name            varchar(256)
  ,@photoLink       varchar(512)
  ,@photoLinkBig    varchar(512)
  ,@areaCommCode    varchar(32)
  ,@members_count   int
  ,@screenName      varchar(512)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 28.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  exec dbo.Getter_Save 5, 'Comm_Set', 'dbo.Comm_Set'
  -----------------------------------------------------------------
  declare @areaCommID int = 1

  select
       @areaCommID = c.id
    from dbo.AreaComm as c       
    where c.code = @areaCommCode
  ----------------------------------------
  begin tran Comm_Set
  ----------------------------------------
    update t set
         t.groupID = @groupID
        ,t.name = @name
        ,t.photoLink = @photoLink
        ,t.photoLinkBig = @photoLinkBig
        ,t.IsNew = cast(0 as bit)
        ,t.lastUpdate = getdate()
        ,t.members_count = @members_count
        ,t.link = @screenName
      from dbo.Comm as t
      where t.link = @link
        and t.areaCommID = @areaCommID
  ----------------------------------------
  commit tran Comm_Set
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
   @ObjSysName  = 'dbo.Comm_Set'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save comm.'
  ,@Params = '
       @link = link to community \n
      ,@groupID = id group \n
      ,@name = name \n
      ,@photoLink = Photo link \n      
      ,@photoLinkBig = big photo link \n
      ,@areaCommCode = area code (Social Network shortname) \n
      '
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.Comm_Set'
go

/* Debug:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Comm_Set 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.Comm_Set to [public]
