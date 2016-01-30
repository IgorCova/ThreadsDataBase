insert into dbo.MemberCommunity ( 
   MemberID
  ,CommunityID
  ,CreateDate 
)
select
     c.OwnerID
    ,c.ID
    ,getdate()
  from dbo.Community as c

