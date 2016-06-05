use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommOKTopics_Save', 'P'
go

-------------------------------------------------------------
-- <PROC> dbo.StaCommOKTopics_Save
-------------------------------------------------------------
alter procedure dbo.StaCommOKTopics_Save
   @groupID    bigint
  ,@dayDate    datetime
  ,@statTopics varchar(max) 
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 05.06.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @dayDate = cast(@dayDate as date)
  declare @xmlTopics xml = fn.ClearXML(@statTopics)
 
  declare @tStatTopics table (
     groupID               bigint
    ,commRenderings        bigint 
    ,commRenderings_own    bigint 
    ,commRenderings_earned bigint 
    ,commReach             bigint 
    ,commReach_own         bigint 
    ,commReach_earned      bigint 
    ,commEngagement        bigint 
    ,commFeedback          bigint 
    ,commFeedback_total    bigint 
    ,commContent_opens     bigint
    ,commPostCount         bigint 
    ,commLikes             bigint 
    ,commComments          bigint 
    ,commReshares          bigint 
    ,commVideo_plays       bigint 
    ,commMusic_plays       bigint 
    ,commLink_clicks       bigint 
    ,commNegatives         bigint 
    ,commHides_from_feed   bigint 
    ,commComplaints        bigint) 
   
   insert into @tStatTopics ( 
      groupID
     ,commRenderings
     ,commRenderings_own
     ,commRenderings_earned
     ,commReach
     ,commReach_own
     ,commReach_earned
     ,commEngagement
     ,commFeedback
     ,commFeedback_total
     ,commPostCount
     ,commContent_opens
     ,commLikes
     ,commComments
     ,commReshares
     ,commVideo_plays
     ,commMusic_plays
     ,commLink_clicks
     ,commNegatives
     ,commHides_from_feed
     ,commComplaints 
   )
   select
      @groupID
     ,renderings        = sum(c.value('renderings[1]',        'bigint'))
     ,renderings_own    = sum(c.value('renderings_own[1]',    'bigint'))
     ,renderings_earned = sum(c.value('renderings_earned[1]', 'bigint'))
     ,reach             = sum(c.value('reach[1]',             'bigint'))
     ,reach_own         = sum(c.value('reach_own[1]',         'bigint'))
     ,reach_earned      = sum(c.value('reach_earned[1]',      'bigint'))
     ,engagement        = sum(c.value('engagement[1]',        'bigint'))
     ,feedback          = sum(c.value('feedback[1]',          'bigint'))
     ,feedback_total    = sum(c.value('feedback_total[1]',    'bigint'))
     ,commPostCount   = count(c.value('likes[1]',             'bigint'))
     ,content_opens     = sum(c.value('content_opens[1]',     'bigint'))
     ,likes             = sum(c.value('likes[1]',             'bigint'))
     ,comments          = sum(c.value('comments[1]',          'bigint'))
     ,reshares          = sum(c.value('reshares[1]',          'bigint'))
     ,video_plays       = sum(c.value('video_plays[1]',       'bigint'))
     ,music_plays       = sum(c.value('music_plays[1]',       'bigint'))
     ,link_clicks       = sum(c.value('link_clicks[1]',       'bigint'))
     ,negatives         = sum(c.value('negatives[1]',         'bigint'))
     ,hides_from_feed   = sum(c.value('hides_from_feed[1]',   'bigint'))
     ,complaints        = sum(c.value('complaints[1]',        'bigint'))
    from @xmlTopics.nodes('/group_getStatTopics_response/topics') g(c)
  ----------------------------------------
  begin tran StaCommOKTopics_Save
  ----------------------------------------
    update t set    
         t.commRenderings        = s.commRenderings
        ,t.commRenderings_own    = s.commRenderings_own
        ,t.commRenderings_earned = s.commRenderings_earned
        ,t.commReach             = s.commReach
        ,t.commReach_own         = s.commReach_own
        ,t.commReach_earned      = s.commReach_earned
        ,t.commEngagement        = s.commEngagement
        ,t.commFeedback          = s.commFeedback
        ,t.commFeedback_total    = s.commFeedback_total
        ,t.commPostCount         = s.commPostCount
        ,t.commContent_opens     = s.commContent_opens
        ,t.commLikes             = s.commLikes
        ,t.commComments          = s.commComments
        ,t.commReshares          = s.commReshares
        ,t.commVideo_plays       = s.commVideo_plays
        ,t.commMusic_plays       = s.commMusic_plays
        ,t.commLink_clicks       = s.commLink_clicks
        ,t.commNegatives         = s.commNegatives
        ,t.commHides_from_feed   = s.commHides_from_feed
        ,t.commComplaints        = s.commComplaints
        ,t.requestDate           = getdate()
        ,t.cntReq                = (t.cntReq + 1)
      from dbo.StaCommOKTopics as t      
      join @tStatTopics        as s on s.groupID =  t.groupID
      where t.dayDate = @dayDate

      insert into dbo.StaCommOKTopics ( 
         id
        ,groupID
        ,dayDate
        ,commRenderings
        ,commRenderings_own
        ,commRenderings_earned
        ,commReach
        ,commReach_own
        ,commReach_earned
        ,commEngagement
        ,commFeedback
        ,commFeedback_total
        ,commPostCount
        ,commContent_opens
        ,commLikes
        ,commComments
        ,commReshares
        ,commVideo_plays
        ,commMusic_plays
        ,commLink_clicks
        ,commNegatives
        ,commHides_from_feed
        ,commComplaints
        ,requestDate
        ,cntReq 
      )
      select
           next value for seq.StaCommOKTopics
          ,@groupID
          ,@dayDate
          ,t.commRenderings
          ,t.commRenderings_own
          ,t.commRenderings_earned
          ,t.commReach
          ,t.commReach_own
          ,t.commReach_earned
          ,t.commEngagement
          ,t.commFeedback
          ,t.commFeedback_total
          ,t.commPostCount
          ,t.commContent_opens
          ,t.commLikes
          ,t.commComments
          ,t.commReshares
          ,t.commVideo_plays
          ,t.commMusic_plays
          ,t.commLink_clicks
          ,t.commNegatives
          ,t.commHides_from_feed
          ,t.commComplaints
          ,getdate()
          ,1
        from @tStatTopics as t
        where not exists (
            select * from dbo.StaCommOKTopics as s
              where s.groupID = @groupID
                and s.dayDate = @dayDate)
  ----------------------------------------
  commit tran StaCommOKTopics_Save
  ---------------------------------------- 
  -----------------------------------------------------------------
end
go
---------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommOKTopics_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for save statistics topics of community on OK.'
  ,@Params = '
     ,@dayDate = daily report \n
     ,@groupID = id group in OK \n
     ,@statTopics = xml string \n'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StaCommOKTopics_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommOKTopics_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommOKTopics_Save to [public]
