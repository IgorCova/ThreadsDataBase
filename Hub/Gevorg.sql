exec dbo.StaCommVKDaily_Report 3
select * from dbo.AdminComm as s where s.ownerHubID = 3
select * from dbo.SubjectComm as s where s.ownerHubID = 3
select * from dbo.Comm as s where s.ownerHubID = 3

