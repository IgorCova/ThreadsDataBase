set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///  Procedure read entries communities
///</description>
*/
alter procedure [dbo].[Entry.ReadByCommunityID]
   @CommunityID  bigint
  ,@ColumnID     bigint = null
  ,@MemberID     bigint
as
begin
------------------------------------------------
-- v1.0: Created by Cova Igor 20.12.2015
------------------------------------------------
  set nocount on
  set quoted_identifier, ansi_nulls, ansi_warnings, arithabort,
      concat_null_yields_null, ansi_padding on
  set numeric_roundabort off
  set transaction isolation level read uncommitted
  set xact_abort on
  -----------------------------------------------------------------
  set @ColumnID = nullif(@ColumnID, 0)

  declare @Table table (
     id                   int identity(1,1)
    ,Entry_ID             bigint 
    ,Community_ID         bigint 
    ,Community_Name       varchar(256) 
    ,ColumnCommunity_ID   bigint 
    ,ColumnCommunity_Name varchar(256) 
    ,Entry_Text           varchar(max) 
    ,Entry_CreateDate     datetime
    ,CreatorID            bigint
    ,CreatorID_Fullname   varchar(512)
    ,primary key(Entry_ID))  
  
  insert into @Table ( 
     Entry_ID
    ,Community_ID
    ,Community_Name
    ,ColumnCommunity_ID
    ,ColumnCommunity_Name
    ,Entry_Text
    ,Entry_CreateDate 
    ,CreatorID
    ,CreatorID_Fullname
  )
  select top 15
       t.ID
      ,t.CommunityID
      ,c.Name
      ,m.ID
      ,m.Name
      ,t.EntryText
      ,t.CreateDate
      ,t.CreatorID
      ,p.FullName    as CreatorID_FullName

    from dbo.[Entry]           as t       
    join dbo.Community       as c on c.ID = t.CommunityID
    join dbo.[Member.View]   as p on p.ID = t.CreatorID
    left join dbo.ColumnCommunity as m on m.ID = t.ColumnID 
                                      and m.CommunityID = t.CommunityID
    
    where t.CommunityID = @CommunityID
      and t.ColumnID = isnull(@ColumnID, t.ColumnID)
      and t.DeleteDate is null
    order by t.CreateDate desc

    select
         t.Entry_ID
        ,t.Community_ID
        ,t.Community_Name
        ,t.ColumnCommunity_ID
        ,t.ColumnCommunity_Name
        ,t.Entry_Text
        ,fn.datetime_to_str_ForUser(t.Entry_CreateDate)  as Entry_CreateDate
        ,fn.datetime_to_text_ForUser(t.Entry_CreateDate) as Entry_CreateDateEst
        ,t.CreatorID
        ,t.CreatorID_Fullname
        ,isnull(b.IsPin, cast(0 as bit)) as IsPin
      from @Table as t
      outer apply (
        select
             cast(1 as bit) as IsPin
          from dbo.Bookmark as b
          where b.EntryID = t.Entry_ID
            and b.MemberID = @MemberID
      ) as b
      order by t.id
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[Entry.ReadByCommunityID]'
go

----------------------------------------------
 -- <Fill Extended Property of db object>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Entry.ReadByCommunityID]'
  ,@Author      = 'Cova Igor'
  ,@Description = 'Procedure for read entries communities'
  ,@Params = '@CommunityID = id community \n
             ,@MemberID = id Member \n
             ,@ColumnID = id Column'
go

/* Debugger:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Entry.ReadByCommunityID]
   @CommunityID = 4
  ,@ColumnID = 69
  ,@MemberID = 1

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go

grant execute on [dbo].[Entry.ReadByCommunityID] to [public]
go