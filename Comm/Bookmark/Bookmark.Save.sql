set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///   procedure for Save entry of community.
///</description>
*/
alter procedure dbo.[Bookmark.Save]
   @EntryID    bigint 
  ,@MemberID   bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 18.03.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare 
     @IsPin bit

  declare @res table(EntryID bigint null ,MemberID bigint null)

  merge dbo.Bookmark as target
    using (
      select
           @EntryID as EntryID
          ,@MemberID as MemberID) as source (EntryID, MemberID)
    on (    target.EntryID = source.EntryID
        and target.MemberID = source.MemberID)

    when matched then 
      delete

    when not matched by target then
      insert (        
         EntryID
        ,MemberID
        ,PinDate
      ) values (
         EntryID
        ,MemberID
        ,getdate())
    output inserted.EntryID, inserted.MemberID into @res(EntryID, MemberID);

    select top 1
        @IsPin = iif(t.EntryID is null, cast(0 as bit), cast(1 as bit))
      from @res as t

    select @IsPin as IsPin
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.[NativeCheck] 'dbo.[Bookmark.Save]'
go
----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.[Bookmark.Save]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for Save Bookmark entry by Member.'
  ,@Params = '
      @MemberID = ID Member \n
     ,@EntryID = ID entry \n'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.[Bookmark.Save] 
   @MemberID = 1
  ,@EntryID = 410  

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.[Bookmark.Save] to [public]
