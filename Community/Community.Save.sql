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
alter procedure [dbo].[Community.Save]
   @ID             bigint  = null out
  ,@Name           varchar(128)
  ,@LogoLink       varchar(1024) = null
  ,@Link           varchar(1024) = null
  ,@Decription     varchar(1024) = null
  ,@OwnerID        bigint          

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
        from dbo.Community as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.Community
    
    insert into dbo.Community ( 
       ID
      ,Name
      ,LogoLink
      ,Link
      ,Decription
      ,OwnerID
      ,CreateDate 
    ) values (
       @ID
      ,@Name
      ,@LogoLink
      ,@Link
      ,@Decription
      ,@OwnerID
      ,getdate()
    )

  end
  else
  begin
    update t set    
         t.Name           = @Name
        ,t.LogoLink       = @LogoLink
        ,t.Link           = @Link
        ,t.Decription     = @Decription
      from dbo.Community as t
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
exec [dbo].[Procedure.NativeCheck] '[dbo].[Community.Save]'
go
----------------------------------------------
 -- <Заполнение Extended Property объекта>
----------------------------------------------

exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.Save]'
  ,@Author      = 'Коваленко Игорь'
  ,@Description = 'Созранение инфо о сообществе'
  ,@Params = '
      @Decription = описание сообщества \n
     ,@ID = ID сообщества \n
     ,@Link = Ссылка на сообщество \n
     ,@LogoLink = Ссылка на логотип сообщества \n
     ,@Name = Наименование сообщества \n
     ,@OwnerID = ID создателя сообщества \n'
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.Save] -- '[dbo].[Community.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
