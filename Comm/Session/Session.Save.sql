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
  ,@DID          varchar(64)
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
    ,@Phone     varchar(32)
    ,@About     varchar(max)
    ,@IsNewMember bit = 0

  set @SessionID = newid()
  set @ID = next value for seq.Session

  select top 1
       @MemberID = m.ID
      ,@Phone = t.Phone
    from dbo.SessionReq  as t
    left join dbo.Member as m on m.Phone = t.Phone       
    where t.ID = @SessionReqID 
      and t.DID = @DID
  
  if @MemberID is null
  begin
    set @About = 'Joined on ' + convert(varchar, getdate(), 106)
    set @IsNewMember = 1

    if @Phone is null
    begin
      raiserror (15600,-1,-1, 'Fuck6')
      return 0
    end

    exec dbo.[Member.New]
       @ID       = @MemberID out   
      ,@Name     = ''   
      ,@Surname  = null   
      ,@UserName = null   
      ,@About    = @About
      ,@Phone    = @Phone
  end

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
       t.SessionID      as SessionID
      ,@MemberID        as MemberID
      ,@IsNewMember     as IsNewMember
    from dbo.[Session]  as t       
    where t.ID = @ID
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
      @SessionReqID = Request Session ID \n
      @DID = Device ID \n'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Session.Save] 
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on [dbo].[Session.Save] to [public]