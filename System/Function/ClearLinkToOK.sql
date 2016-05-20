use Hub

go
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-----------------------------------------------------------------------------
-- <FUNC> dbo.ClearLinkToOK
-----------------------------------------------------------------------------
/* 
///<description>
/// returns clean Link To OK 
///</description>
*/
exec sp.object_create 'ClearLinkToOK', 'FN'
go

alter function fn.ClearLinkToOK(@link varchar(512))
returns varchar(512)
as
begin
  declare 
    @ret varchar(512) = @link 

  set @ret = replace(@ret, 'https://', '')
  set @ret = replace(@ret, 'http://', '')
  
  set @ret = replace(@ret, 'www.odnoklassniki.ru/group/', '')
  set @ret = replace(@ret, 'odnoklassniki.ru/group/', '')  
  set @ret = replace(@ret, 'www.ok.ru/group/', '')
  set @ret = replace(@ret, 'ok.ru/group/', '')

  set @ret = replace(@ret, 'www.odnoklassniki.ru/', '')
  set @ret = replace(@ret, 'odnoklassniki.ru/', '')  
  set @ret = replace(@ret, 'www.ok.ru/', '')
  set @ret = replace(@ret, 'ok.ru/', '')

 return @ret
end
go

/* Œ“À¿ƒ ¿:
declare @ret varchar(32), @err int, @runtime datetime
select @runtime = getdate()

select fn.ClearLinkToOK('https://vk.com/runfoundation')
select fn.ClearLinkToOK('https://vk.com/public84032162')
select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
