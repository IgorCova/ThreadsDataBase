set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go
----------------------------------------------
-- <Func> [fn].[DelDoubleSpace]
-------------------------------------------
/*
///<description>
/// The function removes extra spaces in a row
///</description>
*/
alter function fn.DelDoubleSpace(@str varchar(max))
  returns varchar(max)
as
begin
----------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
----------------------------------------------
  declare @HealedStr varchar(max) = ltrim(rtrim(@str))
  while charindex('  ', @HealedStr) > 0 
    select @HealedStr = replace(@HealedStr, '  ', ' ')
  return @HealedStr           
end
go 
grant execute on fn.DelDoubleSpace to [public]
