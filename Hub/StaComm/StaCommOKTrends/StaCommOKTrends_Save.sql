use Hub
go

set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

exec dbo.sp_object_create 'dbo.StaCommOKTrends_Save', 'P'
go

-------------------------------------------------------------
-- <PROC> dbo.StaCommOKTrends_Save
-------------------------------------------------------------
alter procedure dbo.StaCommOKTrends_Save
   @groupID    bigint
  ,@dayDate    datetime
  ,@statTrends varchar(max) 
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 06.06.2016
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @dayDate = cast(@dayDate as date)
  declare @xmlTrends xml = fn.ClearXML(@statTrends)

  declare @tStatTrends table (
     groupID                bigint primary key
    ,commReach              bigint
    ,commReach_own          bigint
    ,commReach_earned       bigint
    ,commReach_mob          bigint
    ,commReach_web          bigint
    ,commReach_mobweb       bigint

    ,commEngagement         bigint
    ,commFeedback           bigint

    ,commMembers_count      bigint
    ,commNew_members        bigint
    ,commNew_members_target bigint
    ,commLeft_members       bigint
    ,commMembers_diff       bigint

    ,commRenderings         bigint
  
    ,commPage_visits        bigint

    ,commContent_opens      bigint

    ,commLikes              bigint
    ,commComments           bigint
    ,commReshares           bigint

    ,commVotes              bigint
    ,commLink_clicks        bigint
    ,commVideo_plays        bigint
    ,commMusic_plays        bigint
  
    ,commTopic_opens        bigint
    ,commPhoto_opens        bigint
    ,commNegatives          bigint
    ,commHides_from_feed    bigint
    ,commComplaints         bigint) 

   insert into @tStatTrends ( 
      groupID
     ,commReach
     ,commReach_own
     ,commReach_earned
     ,commReach_mob
     ,commReach_web
     ,commReach_mobweb

     ,commEngagement
     ,commFeedback

     ,commMembers_count
     ,commNew_members
     ,commNew_members_target
     ,commLeft_members
     ,commMembers_diff

     ,commRenderings
     ,commPage_visits
     ,commContent_opens

     ,commLikes
     ,commComments
     ,commReshares

     ,commVotes

     ,commLink_clicks
     ,commVideo_plays
     ,commMusic_plays
     ,commTopic_opens
     ,commPhoto_opens

     ,commNegatives
     ,commHides_from_feed
     ,commComplaints 
   )
   select
      @groupID

     ,reach              = sum(c.value('(reach/value)[1]',              'bigint'))
     ,reach_own          = sum(c.value('(reach_own/value)[1]',          'bigint'))
     ,reach_earned       = sum(c.value('(reach_earned/value)[1]',       'bigint'))
     ,reach_mob          = sum(c.value('(reach_mob/value)[1]',          'bigint'))
     ,reach_web          = sum(c.value('(reach_web/value)[1]',          'bigint'))
     ,reach_mobweb       = sum(c.value('(reach_mobweb/value)[1]',       'bigint'))

     ,engagement         = sum(c.value('(engagement/value)[1]',         'bigint'))
     ,feedback           = sum(c.value('(feedback/value)[1]',           'bigint'))

     ,members_count      = sum(c.value('(members_count/value)[1]',      'bigint'))
     ,new_members        = sum(c.value('(new_members/value)[1]',        'bigint'))
     ,new_members_target = sum(c.value('(new_members_target/value)[1]', 'bigint'))
     ,left_members       = sum(c.value('(left_members/value)[1]',       'bigint'))
     ,members_diff       = sum(c.value('(members_diff/value)[1]',       'bigint'))

     ,renderings         = sum(c.value('(renderings/value)[1]',         'bigint'))
     ,page_visits        = sum(c.value('(page_visits/value)[1]',        'bigint'))
     ,content_opens      = sum(c.value('(content_opens/value)[1]',      'bigint'))

     ,likes              = sum(c.value('(likes/value)[1]',              'bigint'))
     ,comments           = sum(c.value('(comments/value)[1]',           'bigint'))
     ,reshares           = sum(c.value('(reshares/value)[1]',           'bigint'))

     ,votes              = sum(c.value('(votes/value)[1]',              'bigint'))

     ,link_clicks        = sum(c.value('(link_clicks/value)[1]',        'bigint'))
     ,video_plays        = sum(c.value('(video_plays/value)[1]',        'bigint'))
     ,music_plays        = sum(c.value('(music_plays/value)[1]',        'bigint'))
     ,topic_opens        = sum(c.value('(topic_opens/value)[1]',        'bigint')) 
     ,photo_opens        = sum(c.value('(photo_opens/value)[1]',        'bigint')) 

     ,negatives          = sum(c.value('(negatives/value)[1]',          'bigint'))
     ,hides_from_feed    = sum(c.value('(hides_from_feed/value)[1]',    'bigint'))
     ,complaints         = sum(c.value('(complaints/value)[1]',         'bigint'))
    from @xmlTrends.nodes('/group_getStatTrends_response') g(c)
  ----------------------------------------
  begin tran StaCommOKTrends_Save
  ----------------------------------------
    update t set    
         t.commReach              = s.commReach
        ,t.commReach_own          = s.commReach_own
        ,t.commReach_earned       = s.commReach_earned
        ,t.commReach_mob          = s.commReach_mob
        ,t.commReach_web          = s.commReach_web
        ,t.commReach_mobweb       = s.commReach_mobweb

        ,t.commEngagement         = s.commEngagement
        ,t.commFeedback           = s.commFeedback

        ,t.commMembers_count      = s.commMembers_count
        ,t.commNew_members        = s.commNew_members
        ,t.commNew_members_target = s.commNew_members_target
        ,t.commLeft_members       = s.commLeft_members
        ,t.commMembers_diff       = s.commMembers_diff

        ,t.commRenderings         = s.commRenderings
        ,t.commPage_visits        = s.commPage_visits
        ,t.commContent_opens      = s.commContent_opens

        ,t.commLikes              = s.commLikes
        ,t.commComments           = s.commComments
        ,t.commReshares           = s.commReshares

        ,t.commVotes              = s.commVotes

        ,t.commLink_clicks        = s.commLink_clicks
        ,t.commVideo_plays        = s.commVideo_plays
        ,t.commMusic_plays        = s.commMusic_plays
        ,t.commTopic_opens        = s.commTopic_opens
        ,t.commPhoto_opens        = s.commPhoto_opens

        ,t.commNegatives          = s.commNegatives
        ,t.commHides_from_feed    = s.commHides_from_feed
        ,t.commComplaints         = s.commComplaints
        ,t.requestDate            = getdate()
        ,t.cntReq                 = (t.cntReq + 1)  
      from dbo.StaCommOKTrends as t
      join @tStatTrends        as s on s.groupID =  t.groupID
      where t.dayDate = @dayDate

      insert into dbo.StaCommOKTrends ( 
         id
        ,groupID
        ,dayDate

        ,commReach
        ,commReach_own
        ,commReach_earned
        ,commReach_mob
        ,commReach_web
        ,commReach_mobweb

        ,commEngagement
        ,commFeedback

        ,commMembers_count
        ,commNew_members
        ,commNew_members_target
        ,commLeft_members
        ,commMembers_diff

        ,commRenderings
        ,commPage_visits
        ,commContent_opens

        ,commLikes
        ,commComments
        ,commReshares

        ,commVotes

        ,commLink_clicks
        ,commVideo_plays
        ,commMusic_plays
        ,commTopic_opens
        ,commPhoto_opens

        ,commNegatives
        ,commHides_from_feed
        ,commComplaints
        ,requestDate
        ,cntReq 
      )
      select
           next value for seq.StaCommOKTrends
          ,@groupID
          ,@dayDate
          ,t.commReach
          ,t.commReach_own
          ,t.commReach_earned
          ,t.commReach_mob
          ,t.commReach_web
          ,t.commReach_mobweb

          ,t.commEngagement
          ,t.commFeedback

          ,t.commMembers_count
          ,t.commNew_members
          ,t.commNew_members_target
          ,t.commLeft_members
          ,t.commMembers_diff

          ,t.commRenderings
          ,t.commPage_visits
          ,t.commContent_opens

          ,t.commLikes
          ,t.commComments
          ,t.commReshares

          ,t.commVotes
          ,t.commLink_clicks
          ,t.commVideo_plays
          ,t.commMusic_plays
          ,t.commTopic_opens
          ,t.commPhoto_opens

          ,t.commNegatives
          ,t.commHides_from_feed
          ,t.commComplaints
          ,getdate()
          ,1
        from @tStatTrends as t
        where not exists (
            select * from dbo.StaCommOKTrends as s
              where s.groupID = @groupID
                and s.dayDate = @dayDate)
  ----------------------------------------
  commit tran StaCommOKTrends_Save
  ---------------------------------------- 
  -----------------------------------------------------------------
end
go
---------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = 'dbo.StaCommOKTrends_Save'
  ,@Author      = 'Cova Igor'
  ,@Description = 'procedure for save statistics trends of community on OK.'
  ,@Params = '
     ,@dayDate = daily report \n
     ,@groupID = id group in OK \n
     ,@statTrends = xml string \n'
go
----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec dbo.NativeCheck 'dbo.StaCommOKTrends_Save'
go

/* Œ“À¿ƒ ¿:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = dbo.StaCommOKTrends_Save 

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
grant execute on dbo.StaCommOKTrends_Save to [public]
