/*
declare
  @dateFrom datetime = '20160418 00:00'
 ,@dateTo datetime  = '20160418 23:59'

exec dbo.sp_ws_VKontakte_Sta_ByDate 
         @groupID  = 12213282   
        ,@dateFrom = @dateFrom   
        ,@dateTo   = @dateTo
        
select
     *
  from dbo.Comm                 as c
  left join dbo.StaCommVKDaily  as s on s.commID = c.id
                           and s.dayDate = '20160415'       
  where s.id is null
*/

/*
declare
  @dateFrom datetime = '20160416',
  @dateTo datetime  = '20160417'

exec dbo.StaCommVKDaily_Request
  @dateFrom = @dateFrom,
  @dateTo = @dateTo
*/


exec dbo.StaCommVKDaily_RequestForNew
  @groupID = 12213282

select
     *
  from dbo.StaCommVKDaily as t       
 -- where t.dayDate = cast(getdate() as date)       
  order by
    t.commID, t.dayDate  asc

select
     *
  from dbo.ErrorLog as t       
  where t.CreateDate > cast(getdate() as date)       
  order by
     t.CreateDate desc  

select
     *
  from dbo.Exception as t       
  where t.exDate > cast(getdate() as date)       
  order by
     t.exDate desc  
   
select
     *
  from dbo.GroupAccess as t       
  where t.requestDate > cast(getdate() as date)       
  order by
     t.requestDate desc  

select * from dbo.Comm as c
select * from dbo.AdminComm as ac
select * from dbo.SubjectComm as sc
--select * from dbo.OwnerHub

select
     *
  from dbo.Comm              as c
  left join dbo.GroupAccess  as g on g.groupID = c.groupID       
  where g.id is null and
        not exists ( select
                          *
                       from dbo.StaCommVKDaily as s       
                       where s.commID = c.id 
                         and s.requestDate > dateadd(hour ,-1 ,getdate()))