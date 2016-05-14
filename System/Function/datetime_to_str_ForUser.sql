create function fn.datetime_to_str_ForUser(@date datetime)
returns varchar(50)
begin
-- v1.0: Created by Cova Igor 02.02.2016
	return ( convert(varchar(30), @date, 104) + ' ' + left(convert(varchar(50), @date, 114), 5) )
end
go 
grant execute on fn.datetime_to_str_ForUser to [public]