set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go
----------------------------------------------
-- <Func> [fn].[datetime_to_text_ForUser]
----------------------------------------------
-------------------------------------------
/*
///<description>
/// Function return date time like this - 2 hour ago, 5 min ago, just now, 3 days ago
///</description>
*/
alter function fn.datetime_to_text_ForUser(@date datetime)
returns varchar(max)
as
begin
----------------------------------------------
-- v1.0: Created by Cova Igor 02.02.2016
----------------------------------------------
  declare 
     @year int
    ,@mont int 
    ,@week int 
    ,@days int 
    ,@hour int
    ,@mins int 
    ,@secs int

  if nullif(datediff(month, @date, getdate()), 0) > 12
    set @year = nullif(datediff(year, @date, getdate()), 0)
  else if @year is null
  begin
    set @mont = nullif(datediff(month, @date, getdate()),0)

    if @mont is null
    begin
      if (nullif(datediff(day, @date, getdate()), 0) % 7) = 0
        set @week = nullif(datediff(week, @date, getdate()), 0)
      else 
      begin
        set @days = nullif(datediff(day, @date, getdate()), 0)

        if @days is null
        begin
          set @hour = nullif(datediff(hour, @date, getdate()), 0)

          if @hour is null
          begin
            set @mins = nullif(datediff(minute, @date, getdate()), 0)

            if @mins is null
              set @secs = datediff(second, @date, getdate())
          end
        end
      end
    end
  end

  return ( 
    concat(iif(@year = 1, '1 year',  try_cast(@year as varchar(4)) + ' years')
          ,iif(@mont = 1, '1 month', try_cast(@mont as varchar(8)) + ' months')
          ,iif(@week = 1, '1 week',  try_cast(@week as varchar(8)) + ' weeks')
          ,iif(@days = 1, '1 day',   try_cast(@days as varchar(8)) + ' days')
          ,iif(@hour = 1, '1 hour',  try_cast(@hour as varchar(8)) + ' hours')
          ,iif(@mins = 1, '1 min',   try_cast(@mins as varchar(8)) + ' mins')
          ,iif(@secs >= 0 and @secs < 60, 'just now', '')))
end
go
grant execute on fn.datetime_to_text_ForUser to [public]