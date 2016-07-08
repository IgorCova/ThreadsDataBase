set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-----------------------------------------------------------------------------
-- <FUNC> [dbo].[ClearPhone]
-----------------------------------------------------------------------------
/* 
///<description>
/// returns clean phone with no characters .. or any other numerical value
///</description>
*/

exec dbo.sp_object_create 'fn.ClearPhone', 'F'
go

alter function fn.ClearPhone(@phone varchar(32))
returns varchar(256)
as
begin
  declare 
     @ret  varchar(32)
    ,@i    int
    ,@r    varchar(1)

  set @ret = @phone

  set @i = patindex('%[^0-9]%', @ret)
  while @i > 0
  begin
    select @r = substring(@ret, @i, 1)
    select @ret = replace(@ret, @r, '')
    select @i = patindex('%[^0-9]%', @ret) 
  end

  if @ret like '8%'
    set @ret = '7' + right(@ret, len(@ret)-1)

  return @ret
end
go

/* Œ“À¿ƒ ¿:
declare @ret varchar(32), @err int, @runtime datetime
select @runtime = getdate()

select fn.[ClearPhone]('8965353334')

select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
