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
  ,@CommunityID    = 3
  ,@ColumnID       = 3
  ,@CreatorID      = 1         
  ,@EntryText      = 'Running is a method of terrestrial locomotion allowing humans and other animals to move rapidly on foot. Running is a type of gait characterized by an aerial phase in which all feet are above the ground (though there are exceptions). This is in contrast to walking, where one foot is always in contact with the ground, the legs are kept mostly straight and the center of gravity vaults over the stance leg or legs in an inverted pendulum fashion. A characteristic feature of a running body from the viewpoint of spring-mass mechanics is that changes in kinetic and potential energy within a stride occur simultaneously, with energy storage accomplished by springy tendons and passive muscle elasticity. The term running can refer to any of a variety of speeds ranging from jogging to sprinting.'

go