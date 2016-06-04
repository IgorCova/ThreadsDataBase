set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go
----------------------------------------------
-- <Func> [fn].[ConvertToDateTimeMS]
-------------------------------------------
/*
///<description>
/// The function return datetime from unixtime milliseconds
///</description>
*/

alter function fn.ConvertToDateTimeMS(@unixtime bigint)
  returns datetime
as
begin
----------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
----------------------------------------------
 declare 
    @LocalTimeOffset bigint
   ,@AdjustedLocalDatetime bigint

  set @LocalTimeOffset = datediff(second, getdate(), getutcdate())
  set @AdjustedLocalDatetime = @unixtime - @LocalTimeOffset
  return ( select dateadd(ms, @AdjustedLocalDatetime%(3600*24*1000), dateadd(day, @AdjustedLocalDatetime/(3600*24*1000), cast('1970-01-01 00:00:00.0' as datetime))))
end
go 
grant execute on fn.ConvertToDateTimeMS to [public]
