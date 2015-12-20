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
alter procedure [dbo].[Community.ReadDict]
-- v1.0
   @debug_info     int          = 0
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
      ,t.Name
      ,t.LogoLink
      ,t.Link
      ,t.Decription
      ,t.OwnerID
      ,t.CreateDate
      ,t.ClosedDate
      ,t.ClosedNote
    from dbo.Community as t
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go
----------------------------------------------
-- <WRAPPER>
----------------------------------------------
exec [dbo].[Procedure.NativeCheck] '[dbo].[Community.ReadDict]'
go
----------------------------------------------
 -- <Заполнение Extended Property объекта>
----------------------------------------------

exec dbo.FillExtendedProperty
   @ObjSysName  = '[dbo].[Community.ReadDict]'
  ,@Author      = 'Коваленко Игорь'
  ,@Description = 'Процедура чтения Сообществ.'
  ,@Params = ''
go

/* ОТЛАДКА:
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec @ret = [dbo].[Community.ReadDict] -- '[dbo].[Community.ReadDict]'
   @debug_info      = 0xFF

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--*/
go
