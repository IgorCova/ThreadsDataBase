set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

-----------------------------------------------------------------------------
-- <FUNC> [fn].[FormatPhone]
-----------------------------------------------------------------------------
/* 
///<description>
//Adds a string with the format +71234568900 parentheses and hyphens.
// No checks on the input string
// Result: +7 (123) 456-89-00
// If it is not formatted, return the input string
///</description>
*/
create function fn.[FormatPhone](@phone varchar(256))
returns varchar(256)
as
begin
  declare @ret varchar(256) 

  set @ret = dbo.ClearPhone(ltrim(rtrim(@phone)))

  if @ret like '89%'
    or @ret like '79%'
  begin
    set @ret = '+79' + right(@ret, len(@ret)-2)
  end
  else if len(@ret) = 10
    and @ret like '9%'
  begin
    set @ret = '+7' + @ret
  end

  if len(@ret) = 12
  begin
    select @ret = left(@ret, 2) + ' (' + right(left(@ret, 5), 3) + ') ' + right(left(@ret, 8), 3) + '-' + left(right(@ret, len(@ret)-8), 2) + '-' + right(@ret, len(@ret)-10)

    if   substring(@ret,1,2) <> '+7' 
      or substring(@ret,13,1) <> '-'
      or substring(@ret,16,1) <> '-' 
      or len(@ret) <> 18
    set @ret = @phone
  end
  else
  	set @ret = @phone 
  ------------
 return ltrim(rtrim(@ret))
end
go

/* Debug:
declare @ret varchar(4096), @err int, @runtime datetime
select @runtime = getdate()

select @ret = [fn].[FormatPhone]('+79164913669')

select
   @err = @@error
  ,@runtime = getdate()-@runtime

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), @runtime, 114) as [RUN_TIME]
--*/
go
