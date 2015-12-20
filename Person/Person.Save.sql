set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

/*
///<description>
///Процедура сохранения Person.
///</description>
*/
alter procedure [dbo].[Person.Save]
   @ID             bigint  = null out
  ,@Name           varchar(256)
  ,@Surname        varchar(256) = null
  ,@UserName       varchar(32) = null
  ,@PhotoLink      varchar(1024) = null
  ,@About          varchar(1024) = null

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
        from dbo.Person as c 
        where c.ID = @ID)
  begin
    set @ID = next value for seq.Person
    
    insert into dbo.Person ( 
       ID
      ,Name
      ,Surname
      ,UserName
      ,PhotoLink
      ,About
      ,JoinedDate 
    ) values (
       @ID
      ,@Name
      ,@Surname
      ,@UserName
      ,@PhotoLink
      ,@About
      ,getdate() 
    )

  end
  else
  begin
    update t set    
         t.Name           = @Name
        ,t.Surname        = @Surname
        ,t.UserName       = @UserName
        ,t.PhotoLink      = @PhotoLink
        ,t.About          = @About
      from dbo.Person as t
      where t.ID = @ID
  end

  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
-- <WRAPPER>
----------------------------------------------
exec [dbo].[Procedure.NativeCheck] '[dbo].[Person.Save]'
go
----------------------------------------------
 -- <Заполнение Extended Property объекта>
----------------------------------------------

exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Person.Save]'
  ,@Author      = 'Коваленко Игорь'
  ,@Description = 'Созранение инфо о Person'
  ,@Params = '
      @About = описание сообщества \n
     ,@ID = ID сообщества \n
     ,@PhotoLink = Ссылка на фото Person \n
     ,@Name = Имя \n
     ,@Surname = Фамилия \n
     ,@UserName = Системное имя пользователя \n'
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Person.Save] -- '[dbo].[Person.Save]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
