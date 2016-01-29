exec [dbo].[ColumnCommunity.Save]
   @ID            = null
  ,@CommunityID   = 3 
  ,@Name          = 'Run'
  ,@CreatorID      = 1         

select * from dbo.Community

select * from dbo.ColumnCommunity

select * from dbo.Entry


exec [dbo].[Entry.Save]
   @ID             = null 
  ,@CommunityID    = 1
  ,@ColumnID       = 1
  ,@CreatorID      = 1         
  ,@EntryText      = 'Илья дома.'
go


update t set
   t.ColumnID = 1
from dbo.Entry as t
where t.EntryText = 'Илья дома.'
  and t.CommunityID = 1