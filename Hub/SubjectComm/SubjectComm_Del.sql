use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///   procedure for del subject of community.
///</description>
*/
alter procedure dbo.SubjectComm_Del
   @id         bigint
  ,@ownerHubID bigint 
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
  exec dbo.Getter_Save @ownerHubID, 'Del', 'dbo.SubjectComm_Del'
  -----------------------------------------------------------------
  delete  
    from dbo.SubjectComm
    where id = @id 
      and ownerHubID = @ownerHubID 
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.SubjectComm_Del'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.SubjectComm_Del'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for del subject of community.'
  ,@Params = '
      @id = id SubjectComm \n 
     ,@ownerHubID = owner Hub id \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.SubjectComm_Del 
   @MemberID = 1
  ,@EntryID = 410  

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.SubjectComm_Del to [public]
