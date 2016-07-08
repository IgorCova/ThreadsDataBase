use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec sp.object_create 'dbo.SexComm_Save', 'P'
go

alter procedure dbo.SexComm_Save
   @groupID    bigint
  ,@areaCommID int
  ,@sex        smallint -- 0 = Woman, 1 = Man, 2 = Undefined
  
  ,@other      int
  ,@under18    int 
  ,@from18to21 int 
  ,@from21to24 int 
  ,@from24to27 int 
  ,@from27to30 int 
  ,@from30to35 int 
  ,@from35to45 int 
  ,@over45     int
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 13.06.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  exec dbo.Getter_Save 5, 'Save', 'dbo.SexComm_Save'
  -----------------------------------------------------------------
  ----------------------------------------
  begin tran SexComm_Save
  ----------------------------------------
    merge dbo.SexComm  as target 
    using (
      select 
           @other      as other
          ,@under18    as under18
          ,@from18to21 as from18to21
          ,@from21to24 as from21to24
          ,@from24to27 as from24to27
          ,@from27to30 as from27to30
          ,@from30to35 as from30to35
          ,@from35to45 as from35to45
          ,@over45     as over45
          ,@groupID    as groupID
          ,@areaCommID as areaCommID 
          ,@sex        as sex          
    ) as source (
         other
        ,under18     
        ,from18to21 
        ,from21to24 
        ,from24to27 
        ,from27to30 
        ,from30to35 
        ,from35to45 
        ,over45
        ,groupID
        ,areaCommID
        ,sex
    )
    on (    target.groupID = source.groupID
        and target.areaCommID = source.areaCommID
        and target.sex = source.sex
    )
    when matched then
      update set
         target.other      = source.other
        ,target.under18    = source.under18
        ,target.from18to21 = source.from18to21
        ,target.from21to24 = source.from21to24
        ,target.from24to27 = source.from24to27
        ,target.from27to30 = source.from27to30
        ,target.from30to35 = source.from30to35
        ,target.from35to45 = source.from35to45
        ,target.over45     = source.over45
        ,target.lastUpdate = getdate()

    when not matched by target then
      insert (   
         groupID 
        ,areaCommID 
        ,sex
        ,other
        ,under18     
        ,from18to21 
        ,from21to24 
        ,from24to27 
        ,from27to30 
        ,from30to35 
        ,from35to45 
        ,over45
        ,lastUpdate) 
      values (
         source.groupID 
        ,source.areaCommID 
        ,source.sex
        ,source.other
        ,source.under18     
        ,source.from18to21 
        ,source.from21to24 
        ,source.from24to27 
        ,source.from27to30 
        ,source.from30to35 
        ,source.from35to45 
        ,source.over45
        ,getdate());
      
  
  ----------------------------------------
  commit tran SexComm_Save
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
   @ObjSysName  = 'dbo.SexComm_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save comm.'
  ,@Params = '
       @other = other age \n
       @from18to21 = from 18 to 21 \n
      ,@from21to24 = from 21 to 24 \n
      ,@from24to27 = from 24 to 27 \n
      ,@from27to30 = from 27 to 30  \n
      ,@from30to35 = from 30 to 35  \n
      ,@from35to45 = from 35 to 45 \n
      ,@groupID = groupID \n
      ,@over45 = over 45 \n
      ,@sex = 0 = Woman, 1 = Man, 2 = Undefined \n
      ,@under18 = under 18 \n
      ,@areaCommID = area id \n'
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.SexComm_Save'
go

/* Debug:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.SexComm_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.SexComm_Save to [public]
