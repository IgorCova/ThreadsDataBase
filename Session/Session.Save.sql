set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
/// procedure for Save Session.
///</description>
*/
alter procedure [dbo].[Session.Save]
   @SessionReqID bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 13.02.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare 
     @ID        bigint
    ,@SessionID uniqueidentifier
    ,@MemberID  bigint

  set @SessionID = newid()
  set @ID = next value for seq.Session
    
  select top 1
       @MemberID = m.ID
    from dbo.SessionReq as t
    join dbo.Member     as m on m.Phone = t.Phone
    where t.ID = @SessionReqID
  
 /* if @MemberID is null
  begin
    exec dbo.mem
  end
*/
  insert into dbo.Session ( 
     ID
    ,SessionReqID
    ,SessionID
    ,CreateDate 
  ) values (
     @ID
    ,@SessionReqID
    ,@SessionID
    ,getdate() 
  )

  select
       @SessionID  as SessionID
      ,@MemberID   as MemberID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <[NativeCheck]>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Session.Save]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Session.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Session.'
  ,@Params = '
      @SessionReqID = Request Session ID \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Session.Save] 
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[Session.Save] to [public]