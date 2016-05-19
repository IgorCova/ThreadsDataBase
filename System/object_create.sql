/*
  This procedure creates a blank object..
*/
create procedure sp.object_create
-- v1.0
   @objname  sysname
  ,@xtype    char(2) = 'P'
      -- 'P'  - procedure
      -- 'V'  - view
      -- 'TR' - trigger
      -- 'FN' - function (scalar)
      -- 'TF' - function (table)
      -- 'IF' - function (inline)
as 
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 17.05.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -------------------------------------------
  declare @err   int
  declare @objid int = object_id(@objname)
  declare @sql   nvarchar(4000)
  -------------------------------------------
  -------------------------------------------
  if (@objid is not null) 
    return (0)
  -------------------------------------------
  -- print @xtype
  select
      @sql = case
               when @xtype = 'P ' then 'create procedure ' + @objname + ' as begin return(-1) end'
               when @xtype = 'V ' then 'create view ' + @objname + ' as select null as [dummy]'
               when @xtype = 'FN' then 'create function ' + @objname + '() returns int as begin return(null) end'
               when @xtype = 'TF' then 'create function ' + @objname + '() returns @ret table([dummy] int) as begin return end'
               when @xtype = 'IF' then 'create function ' + @objname + '() returns table as return select null as [dummy]'
             end
  -------------------------------------------
  -- print @sql
  exec (@sql)
  select @err = @@error

  if (@err != 0) 
  begin
    print (@sql)
    return (@err)
  end
  -------------------------------------------
  return(0)
end