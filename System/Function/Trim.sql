-------------------------------------------
/*
///<description>
 Ltrim + rtrim, and change double spaces to single space in string, and return changed string.
///</description>
*/
alter function fn.Trim(@str varchar(max))
returns varchar(max) 
as
begin
----------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
----------------------------------------------
  return ltrim(rtrim(@str))
end
go 
grant execute on [fn].[Trim] to [public]