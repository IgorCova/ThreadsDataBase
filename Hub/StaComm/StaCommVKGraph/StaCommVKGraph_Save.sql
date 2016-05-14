use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommVKGraph_Save', 'P'
go

-------------------------------------------------------------
-- <PROC> dbo.StaCommVKGraph_Save
-------------------------------------------------------------
alter procedure dbo.StaCommVKGraph_Save
   @groupID        bigint
  ,@feedback_graph varchar(max)
  ,@activity_graph varchar(max)
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 16.04.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  declare @feedback xml = fn.ClearXML(@feedback_graph)
  declare @activity xml = fn.ClearXML(@activity_graph)

  declare @graph table (
     dayDate                date
      -- Feedback
    ,commLikes              bigint null
    ,commComments           bigint null
    ,commShare              bigint null
    ,commRemoved            bigint null
    -- Activity
    ,commPhotos             bigint null
    ,commPhotoComments      bigint null
    ,commVideoComments      bigint null
    ,commDiscussionComments bigint null
    ,commMarketComments     bigint null)

  insert into @graph (dayDate, commLikes)
  select
       dayDate   = cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date)
      ,commLikes = c.value('d[2]', 'bigint') 
    from @feedback.nodes('/root/root/d') g(c)
    where c.value('../name[1]', 'varchar(256)') = 'Like'

  update t set 
       t.commComments = c.value('d[2]', 'bigint')
    from @graph as t
    join @feedback.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Comments'

  update t set 
       t.commShare = c.value('d[2]', 'bigint')
    from @graph as t
    join @feedback.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Share'

  update t set 
       t.commRemoved = c.value('d[2]', 'bigint')
    from @graph as t
    join @feedback.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Removed from their news feed'

  update t set 
       t.commPhotos = c.value('d[2]', 'bigint')
    from @graph as t
    join @activity.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Photos'

  update t set 
       t.commPhotoComments = c.value('d[2]', 'bigint')
    from @graph as t
    join @activity.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Photo comments'

  update t set 
       t.commVideoComments = c.value('d[2]', 'bigint')
    from @graph as t
    join @activity.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Video comments'

  update t set 
       t.commDiscussionComments = c.value('d[2]', 'bigint')
    from @graph as t
    join @activity.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Discussion comments'

  update t set 
       t.commMarketComments = c.value('d[2]', 'bigint')
    from @graph as t
    join @activity.nodes('/root/root/d') g(c) on cast(fn.ConvertToDateTime(c.value('d[1]', 'bigint')) as date) = t.dayDate
    where c.value('../name[1]', 'varchar(256)') = 'Market comments'

  ----------------------------------------
  begin tran StaCommVKGraph_Save
  ----------------------------------------
    update t set    
         t.commLikes              = g.commLikes
        ,t.commComments           = g.commComments
        ,t.commShare              = g.commShare
        ,t.commRemoved            = g.commRemoved
        ,t.commPhotos             = g.commPhotos
        ,t.commPhotoComments      = g.commPhotoComments
        ,t.commVideoComments      = g.commVideoComments
        ,t.commDiscussionComments = g.commDiscussionComments  
      from dbo.StaCommVKGraph as t
      join @graph             as g on g.dayDate = t.dayDate
      where (   t.dayDate = cast(getdate() as date) 
             or t.dayDate = cast(getdate()-1 as date))
        and t.groupID = @groupID
    
    insert into dbo.StaCommVKGraph ( 
       id
      ,groupID
      ,dayDate
      ,commLikes
      ,commComments
      ,commShare
      ,commRemoved
      ,commPhotos
      ,commPhotoComments
      ,commVideoComments
      ,commDiscussionComments
      ,commMarketComments 
    )
    select
         next value for seq.StaCommVKGraph
        ,@groupID
        ,t.dayDate
        ,t.commLikes
        ,t.commComments
        ,t.commShare
        ,t.commRemoved
        ,t.commPhotos
        ,t.commPhotoComments
        ,t.commVideoComments
        ,t.commDiscussionComments
        ,t.commMarketComments
      from @graph as t
      where not exists (select * 
                          from dbo.StaCommVKGraph as s 
                          where s.dayDate = t.dayDate 
                            and s.groupID = @groupID) 
    
   
  ----------------------------------------
  commit tran StaCommVKGraph_Save
  ---------------------------------------- 
  -----------------------------------------------------------------
end
go
---------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommVKGraph_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for Save graph of community on VKontakte.'
  ,@Params = '
    @groupID = group id \n
   ,@activity_graph = activity graph \n
   ,@feedback_graph = feedback graph \n'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StaCommVKGraph_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommVKGraph_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommVKGraph_Save to [public]
