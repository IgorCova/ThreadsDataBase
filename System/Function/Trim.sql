-------------------------------------------
/*
///<description>
Удаляет ведущие и концевые пробелы, а также двойные пробелы заменяется одинарным в строке $s, и возвращает измененную строку.
///</description>
*/
create function fn.Trim(@str varchar(max))
returns varchar(max) 
as
begin
----------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
----------------------------------------------
  return ltrim(rtrim(@str))
end
GO 
GRANT EXECUTE ON [fn].[Trim] TO [public]