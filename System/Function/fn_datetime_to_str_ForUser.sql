create function dbo.fn_datetime_to_str_ForUser(@date datetime)
returns varchar(50)
begin
-- v1.0: Created by Cova Igor 20.12.2015
	return ( convert(varchar(30), @date, 104) + ' ' + left(convert(varchar(50), @date, 114), 5) )
end
go 
grant execute on [dbo].[fn_datetime_to_str_ForUser] to [public]