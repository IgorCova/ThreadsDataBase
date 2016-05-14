use Hub

go
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-----------------------------------------------------------------------------
-- <FUNC> fn.ClearXML
-----------------------------------------------------------------------------
/* 
///<description>
/// returns Valid XML 
///</description>
*/
exec dbo.sp_object_create 'fn.ClearXML', 'FN'
go

alter function fn.ClearXML(@xmlString varchar(max))
returns xml
as
begin
  declare @ret varchar(max) = @xmlString

  set @ret = replace(@ret, ' >', '>')
  set @ret = replace(@ret, '< ', '<')
  set @ret = replace(@ret, ' /', '/')
  set @ret = replace(@ret, '/ ', '/')
  set @ret = replace(@ret, '<d/>', '<d></d>')
  set @ret = replace(@ret, '<l/>', '<l></l>')

  declare @xml xml = @ret

  return @xml
end
go

/* Œ“À¿ƒ ¿:
declare @ret varchar(32), @err int, @runtime datetime
select @runtime = getdate()

select @ret = fn.ClearXML('')

select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
