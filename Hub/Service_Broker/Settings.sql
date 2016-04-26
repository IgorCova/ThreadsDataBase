use master
go

declare @dbname sysname

set @dbname = 'Hub'

declare @spid int
select
     @spid = min(spid)
  from master.dbo.sysprocesses       
  where dbid = db_id(@dbname)

while @spid is not null
begin
    execute ('KILL ' + @spid)
    select
         @spid = min(spid)
      from master.dbo.sysprocesses       
      where dbid = db_id(@dbname) 
        and spid > @spid
end


alter database Hub 
set enable_broker
