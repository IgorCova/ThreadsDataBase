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
alter procedure [dbo].[ColumnCommunity.Save]
   @ID             bigint  = null out
  ,@CommunityID    bigint 
  ,@Name           varchar(128)
  ,@CreatorID      bigint          

  ,@debug_info     int = 0
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
  
  if not exists (
      select * 
        from dbo.ColumnCommunity as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.ColumnCommunity
    
    select
         @CreatorID = c.OwnerID
      from dbo.Community as c       
      where c.ID = @CommunityID

    insert into dbo.ColumnCommunity ( 
       ID
      ,CommunityID
      ,Name
      ,CreatorID
      ,CreateDate 
    ) values (
       @ID
      ,@CommunityID
      ,@Name
      ,@CreatorID
      ,getdate() 
    )

  end
  else
  begin
    update t set    
         t.Name           = @Name
      from dbo.ColumnCommunity as t
      where ID = @ID
  end

 
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
-- <WRAPPER>
----------------------------------------------
exec [dbo].[Procedure.NativeCheck] '[dbo].[ColumnCommunity.Save]'
go
----------------------------------------------
 -- <Заполнение Extended Property объекта>
----------------------------------------------

exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[ColumnCommunity.Save]'
  ,@Author      = 'Коваленко Игорь'
  ,@Description = 'Созранение инфо о сообществе'
  ,@Params = '
      @ID = ID колонки \n
     ,@CommunityID = ID сообщества \n
     ,@Name = Название колонки сообщества \n
     ,@CreatorID = ID создателя колонки \n'
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[ColumnCommunity.Save] -- '[dbo].[ColumnCommunity.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
