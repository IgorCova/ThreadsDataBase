/*
exec dbo.SubjectComm_Save
  @id = null,
  @ownerPubID = 1,
  @name = 'Цветочные горшки'
go
*/

/*
exec dbo.OwnerPub_Save
   @id = null   
  ,@firstName = 'Igor'   
  ,@lastName = 'Cova'   
  ,@phone = '79164913669'   
  ,@linkFB = 'emptyparam'
go  
*/


/*
exec dbo.AdminComm_Save
  @id = null,
  @ownerPubID = 1,
  @firstName = 'Andrew',
  @lastName = 'Dzhur',
  @phone = '79264308272',
  @linkFB = 'https://www.facebook.com/profile.php?id=100006125686790'
go
exec dbo.AdminComm_Save
  @id = null,
  @ownerPubID = 1,
  @firstName = 'Antony',
  @lastName = 'Bubas',
  @phone = '79253396965',
  @linkFB = 'https://www.facebook.com/profile.php?id=100009033714409'
go
*/
/*
exec dbo.SessionReq_Save
  @dID = 'iPhone-Jin',
  @phone = '79164913669'
go

exec dbo.Session_Save
  @sessionReqID = 5,
  @dID = 'iPhone-Jin'
go
*/
/*
exec dbo.SessionReq_Save
  @dID = 'iPhone-Torry',
  @phone = '79999999999'
go

exec dbo.Session_Save
  @sessionReqID = 6,
  @dID = 'iPhone-Torry'
go
*/
/*
insert into dbo.AreaComm ( 
   id
  ,links
  ,name 
) values (
   nexy value for seq.AreaComm
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

exec dbo.Comm_Save
  @id = null,
  @ownerPubID = 1,
  @subjectCommID = 1,
  @areaCommID = 1,
  @name = 'Run Foundation',
  @adminCommID = 1,
  @link = 'http://vk.com/runfoundation'
go

exec dbo.Comm_Save
  @id = null,
  @ownerPubID = 1,
  @subjectCommID = 3,
  @areaCommID = 1,
  @name = 'Major Mafia',
  @adminCommID = 1,
  @link = 'http://vk.com/majormafia'
go

select * from dbo.SubjectComm
select * from dbo.OwnerPub
select * from dbo.AdminComm
select * from dbo.AreaComm
select * from dbo.Comm