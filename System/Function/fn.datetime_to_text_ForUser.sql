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
     @years  int
    ,@months int 
    ,@weeks  int 
    ,@days   int 
    ,@hours  int
    ,@mins   int 
    ,@sec    int

  set @years = nullif(datediff(year, @date, getdate()), 0)

  if @years is null
  begin
    set @months = nullif(datediff(month, @date, getdate()),0)

    if @months is null
    begin
      set @weeks = nullif(datediff(week, @date, getdate()), 0)

      if @weeks is null
      begin
        set @days = nullif(datediff(day, @date, getdate()), 0)

        if @days is null
        begin
          set @hours = nullif(datediff(hour, @date, getdate()), 0)

          if @hours is null
          begin
            set @mins = nullif(datediff(minute, @date, getdate()), 0)

            if @mins is null
              set @sec = datediff(second, @date, getdate())
          end
        end
      end
    end
  end

  return ( 
    concat(try_cast(@years as varchar(4)) + ' years ago'
          ,try_cast(@months as varchar(8)) + ' month ago'
          ,try_cast(@weeks as varchar(8)) + ' weeks ago'
          ,try_cast(@days as varchar(8)) + ' days ago'
          ,try_cast(@hours as varchar(8)) + ' hours ago'
          ,try_cast(@mins as varchar(8)) + ' mins ago'
          ,iif(@sec >= 0 and @sec <60, 'just now', '')))
end
go 
grant execute on fn.datetime_to_text_ForUser to [public]