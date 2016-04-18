select * from dbo.Getter as g where g.ownerHubID <> 1

exec dbo.StaCommVKDaily_ReportDay
  @ownerHubID = 1


exec dbo.StaCommVKDaily_RequestForNew
  @groupID = 40129584