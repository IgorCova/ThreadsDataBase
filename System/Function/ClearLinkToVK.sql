use Hub

go
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-----------------------------------------------------------------------------
-- <FUNC> dbo.ClearLinkToVK
-----------------------------------------------------------------------------
/* 
///<description>
/// returns clean LinkToFB 
///</description>
*/
alter function fn.ClearLinkToVK(@linkVK varchar(512))
returns varchar(512)
as
begin
  declare 
    @ret varchar(512) = @linkVK 

  set @ret = replace(@ret, 'https://www.vk.com/', '')
  set @ret = replace(@ret, 'http://www.vk.com/', '')
  set @ret = replace(@ret, 'www.vk.com/', '')

  set @ret = replace(@ret, 'https://vk.com/', '')  
  set @ret = replace(@ret, 'http://vk.com/', '')  
  set @ret = replace(@ret, 'vk.com/', '')

 return @ret
end
go

/* Œ“À¿ƒ ¿:
declare @ret varchar(32), @err int, @runtime datetime
select @runtime = getdate()

select @ret = fn.ClearLinkToVK('https://vk.com/runfoundation')

select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
