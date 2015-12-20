set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///Процедура чтения Сообществ.
///</description>
*/
alter procedure [dbo].[Entry.ReadReadNewsByPersonID]
   @PersonID    bigint
  ,@debug_info     int          = 0
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
  declare   
     @res    int           -- для Return-кодов вызываемых процедур.
    ,@ret    int           -- для хранения Return-кода данной процедуры.
    ,@err    int           -- для хранения @@error-кода после вызовов процедур.
    ,@cnt    int           -- для хранения количеств обрабатываемых записей.
    ,@ErrMsg varchar(1000) -- для формирования сообщений об ошибках   

  select
       t.ID
      ,t.CommunityID
      ,c.Name         as [CommunityID.Name]
      ,t.ColumnID
      ,cc.Name        as [ColumnID.Name]
      ,t.CreatorID
      ,p.FullName     as [CreatorID.FullName]
      ,t.EntryText
      ,t.CreateDate
      ,t.DeleteDate
      ,t.DeleteNote
    from dbo.Entry           as t       
    join dbo.Community       as c on c.ID = t.CommunityID
    join dbo.ColumnCommunity as cc on cc.ID = t.ColumnID
    join dbo.[Person.View]   as p on p.ID = t.CreatorID
    where c.OwnerID = @PersonID
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
-- <WRAPPER>
----------------------------------------------
exec [dbo].[Procedure.NativeCheck] '[dbo].[Entry.ReadReadNewsByPersonID]'
go
----------------------------------------------
 -- <Заполнение Extended Property объекта>
----------------------------------------------

exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Entry.ReadReadNewsByPersonID]'
  ,@Author      = 'Коваленко Игорь'
  ,@Description = 'Процедура чтения записей сообществ в качестве новостей для пользователя.'
  ,@Params = '@PersonID = ID Person'
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Entry.ReadReadNewsByPersonID] -- '[dbo].[Entry.ReadReadNewsByPersonID]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
