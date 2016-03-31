use Pub

go
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-----------------------------------------------------------------------------
-- <FUNC> dbo.ClearLinkToFB
-----------------------------------------------------------------------------
/* 
///<description>
/// returns clean LinkToFB 
///</description>
*/
create function fn.ClearLinkToFB(@linkFB varchar(512))
returns varchar(512)
as
begin
  declare 
    @ret varchar(512) = @linkFB

  set @ret = replace(@ret, 'https://www.facebook.com/profile.php?id=', '')
  set @ret = replace(@ret, 'http://www.facebook.com/profile.php?id=', '')
  set @ret = replace(@ret, 'www.facebook.com/profile.php?id=', '')
  set @ret = replace(@ret, 'facebook.com/profile.php?id=', '')

  set @ret = replace(@ret, 'https://www.fb.com/profile.php?id=', '')
  set @ret = replace(@ret, 'http://www.fb.com/profile.php?id=', '')
  set @ret = replace(@ret, 'www.fb.com/profile.php?id=', '')
  set @ret = replace(@ret, 'fb.com/profile.php?id=', '')

  set @ret = replace(@ret, 'https://www.facebook.com/', '')
  set @ret = replace(@ret, 'http://www.facebook.com/', '')
  set @ret = replace(@ret, 'www.facebook.com/', '')
  set @ret = replace(@ret, 'facebook.com/', '')

 return @ret
end
go

/* Œ“À¿ƒ ¿:
declare @ret varchar(32), @err int, @runtime datetime
select @runtime = getdate()

select @ret = fn.ClearLinkToFB('https://www.facebook.com/emptyparam')

select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
