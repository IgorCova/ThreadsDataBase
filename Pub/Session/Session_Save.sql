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
alter procedure dbo.Session_Save
   @sessionReqID bigint
  ,@dID          varchar(64)
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
  declare 
     @id          bigint
    ,@sessionID   uniqueidentifier
    ,@ownerPubID  bigint
    ,@phone       varchar(32)
    ,@about       varchar(max)
    ,@isNewMember bit = cast(0 as bit)

  set @sessionID = newid()
  set @ID = next value for seq.Session

  select top 1
       @ownerPubID = m.id
      ,@Phone = t.Phone
    from dbo.SessionReq    as t
    left join dbo.OwnerPub as m on m.Phone = t.Phone       
    where t.id = @sessionReqID 
      and t.dID = @dID

  if @ownerPubID is null
  begin
    set @About = 'Joined on ' + convert(varchar, getdate(), 106)
    set @isNewMember = cast(1 as bit)

    if @Phone is null
    begin
      raiserror (15600,-1,-1, 'Session_Save: no Phone')
      return 0
    end

    exec dbo.OwnerPub_Save
       @id        = @ownerPubID out    
      ,@firstName = ''   
      ,@lastName  = ''   
      ,@phone     = @phone   
      ,@linkFB    = ''
  end

  insert into dbo.Session ( 
     id
    ,sessionReqID
    ,sessionID
    ,createDate 
  ) values (
     @id
    ,@sessionReqID
    ,@sessionID
    ,getdate() 
  )

  select
       t.sessionID      as SessionID
      ,@ownerPubID       as MemberID
      ,@isNewMember     as IsNewMember
    from dbo.Session  as t       
    where t.id = @id
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.Session_Save'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.Session_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save Session.'
  ,@Params = '
      @SessionReqID = Request Session ID \n
      @DID = Device ID \n'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.Session_Save 
   @debug_info      = 0xFF

select @err = @@error

select @ret as RETURN, @err as ERROR, convert(varchar(20), getdate()-@runtime, 114) as RUN_TIME
--*/
go
grant execute on dbo.Session_Save to public