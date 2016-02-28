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
create function [dbo].[ClearPhone](@phone varchar(512))
returns varchar(512)
as
begin
  declare 
    @ret      varchar(512)
   ,@i        int
   ,@r        varchar(1)
    select @ret = @phone

    select @i = patindex('%[^0-9]%', @ret)
    while @i > 0
    begin
      select @r = substring(@ret, @i, 1)
      select @ret = replace(@ret, @r, '')
      select @i = patindex('%[^0-9]%', @ret) 
    end 
     
 return @ret
end
go

/* Œ“À¿ƒ ¿:
declare @ret varchar(32), @err int, @runtime datetime
select @runtime = getdate()

select @ret = [dbo].[ClearPhone]('89 031 448 046')

select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
