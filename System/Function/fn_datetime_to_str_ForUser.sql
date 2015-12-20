create function dbo.fn_datetime_to_str_ForUser(@date datetime)
-- v1.0
returns varchar(50)
begin
-- v1.0: Created by Cova Igor 20.12.2015
	return ( convert(varchar(30), @date, 104) + ' ' + left(convert(varchar(50), @date, 114), 5) )
end
GO 
GRANT EXECUTE ON [dbo].[fn_datetime_to_str_ForUser] TO [public]