

/*
exec dbo.OwnerHub_Save
   @id = null   
  ,@firstName = 'Igor'   
  ,@lastName = 'Cova'   
  ,@phone = '79164913669'   
  ,@linkFB = 'emptyparam'
go  
*/
/*
exec dbo.SubjectComm_Save
  @id = null,
  @ownerHubID = 3,
  @name = 'Entertainment'
go

exec dbo.SubjectComm_Save
  @id = null,
  @ownerHubID = 3,
  @name = 'Mechanics'
go

*/

/*
exec dbo.AdminComm_Save
  @id = null,
  @ownerHubID = 3,
  @firstName = 'Igor',
  @lastName = 'Cova',
  @phone = '79164913669',
  @linkFB = 'https://www.facebook.com/emptyparam'
go

exec dbo.AdminComm_Save
  @id = null,
  @ownerHubID = 1,
  @firstName = 'Antony',
  @lastName = 'Bubas',
  @phone = '79253396965',
  @linkFB = 'https://www.facebook.com/profile.php?id=100009033714409'
go

exec dbo.AdminComm_Save
  @id = null,
  @ownerHubID = 1,
  @firstName = 'Igor',
  @lastName = 'Cova',
  @phone = '79164913669',
  @linkFB = 'https://www.facebook.com/emptyparam'
*/
/*
exec dbo.SessionReq_Save
  @dID = 'iPhone-Jin',
  @phone = '79164913669'
go

exec dbo.Session_Save
  @sessionReqID = 1,
  @dID = 'iPhone-Jin'
go
*/
/*
exec dbo.SessionReq_Save
  @dID = 'iPhone-Torry',
  @phone = '79999999999'
go

exec dbo.Session_Save
  @sessionReqID = 2,
  @dID = 'iPhone-Torry'
go
*/
/*
insert into dbo.AreaComm ( 
   id
  ,links
  ,name 
) values (
   next value for seq.AreaComm
  ,'vk.сom, vkontakte.com, vkontakte.ru'
  ,'ВКонтакте'
)

insert into dbo.AreaComm ( 
   id
  ,links
  ,name 
) values (
   next value for seq.AreaComm
  ,'ok.com, ok.ru'
  ,'Одноклассники'
)
*/
/*
exec dbo.Comm_Save
  @id = null,
  @ownerHubID = 1,
  @subjectCommID = 3,
  @areaCommID = 1,
  @name = 'Run Foundation',
  @adminCommID = 1,
  @link = 'http://vk.com/runfoundation'
go

exec dbo.Comm_Save
  @id = null,
  @ownerHubID = 1,
  @subjectCommID = 4,
  @areaCommID = 1,
  @name = 'Major Mafia',
  @adminCommID = 1,
  @link = 'http://vk.com/majormafia'
go

exec dbo.Comm_Save
  @id = null,
  @ownerHubID = 1,
  @subjectCommID = 4,
  @areaCommID = 1,
  @name = 'EAT SLEEP JDM',
  @adminCommID = 2,
  @link = 'http://vk.com/eatsleepjdm',
  @groupID = 30857188
 go
 
exec dbo.Comm_Save
  @id = null,
  @ownerHubID = 3,
  @subjectCommID = 3,
  @areaCommID = 1,
  @name = 'MDK',
  @adminCommID = 1,
  @link = 'http://vk.com/mdk',
  @groupID = 10639516
go

exec dbo.Comm_Save
  @id = null,
  @ownerHubID = 3,
  @subjectCommID = 5,
  @areaCommID = 1,
  @name = 'MDK',
  @adminCommID = 4,
  @link = 'http://vk.com/thesmolny',
  @groupID = 44781847
go

exec dbo.AdminComm_Save
  @id = null,
  @ownerHubID = 3,
  @firstName = 'Antony',
  @lastName = 'Bubas',
  @phone = '79253396965',
  @linkFB = 'https://www.facebook.com/profile.php?id=100009033714409'
go

*/
select * from dbo.SubjectComm
select * from dbo.OwnerHub
select * from dbo.AdminComm
select * from dbo.AreaComm
select * from dbo.Comm

