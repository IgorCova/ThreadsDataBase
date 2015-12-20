set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

----------------------------------------------
-- <PROC> [dbo].[FillExtendedProperty]
----------------------------------------------
/*
///<description>
///Механизм документирования объектов в MS SQL Server. 
  Заполнение Extended Property объекта.
///</description>
*/
alter procedure [dbo].[FillExtendedProperty]
-- v1.0
  -- of(Object):   
   @ObjSysName     sysname       = null
  ,@ObjWrapName    sysname       = null
  ,@Author         varchar(512)  = null
  ,@Description    varchar(4000) = null
  ,@Params         varchar(max)  = null
  ,@RowSets        varchar(4000) = null
  ,@Errors         varchar(4000) = null

  ,@debug_info     int           = null
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
  set ansi_padding on
  ------------------------------------
  -----------------------------------------------------------------
  declare
     @res     int      -- для Return-кодов вызываемых процедур.
    ,@ret     int      -- для хранения Return-кода данной процедуры.
    ,@err     int      -- для хранения @@error-кода после вызовов процедур.
    ,@cnt     int      -- для хранения количеств обрабатываемых записей.
    ,@ErrMsg  varchar(1000) -- для формирования сообщений об ошибках   
    ,@InfoMsg varchar(1000) -- для формирования информационных сообщений
    ,@El      varchar(2) = char(13)+char(10) -- Перевод строки и Возврат каретки
    
    ,@InfoMsgPrms   varchar(1000)   
    ,@ParamName     sysname  
    ,@ParamValue    varchar(4000)       
    ,@ObjName       sysname   
    ,@ObjSchema     sysname  
    ,@ObjType       char(2)
    ,@ObjTypeName   nvarchar(60)
    ,@ObjSchemaId   int        
    ,@TemplateMsg   varchar(1000)    
  ---------------------------------------------------------
  --|| /*Аргументы
  select 
       @ObjName     = o.Name
      ,@ObjSchema   = s.Name 
      ,@ObjSchemaId = s.[schema_id]
      ,@ObjType     = o.[type]
      ,@ObjTypeName = case o.[type] 
                        when 'P'  then 'Procedure' -- хранимая процедура
                        when 'FN' then 'Function'  -- скалярная функция
                        when 'TF' then 'Function' -- табличная функция
                        when 'V'  then 'View'       -- представление
                        when 'FS' then 'Function'  -- скалярная функция сборки (среда CLR)
                        when 'TR' then '' -- триггер DML SQL
                        when 'PC' then '' -- хранимая процедура сборки (среда CLR)
                        when 'SQ' then '' -- очередь обслуживания
                        when 'TT' then ''  -- табличный тип
                        when 'S'  then 'Table' -- системная таблица
                        when 'D'  then '' -- ограничение по умолчанию или DEFAULT
                        when 'IT' then 'Table'  -- внутренняя таблица
                        when 'F'  then '' -- ограничение FOREIGN KEY
                        when 'PK' then ''  -- ограничение PRIMARY KEY
                        when 'U'  then 'Table'  -- пользовательская таблица
                        when 'IF' then 'Function'  -- подставляемая табличная функция
                        when 'C'  then '' -- ограничение CHECK
                        when 'UQ' then '' -- ограничение UNIQUE (type K)
                        when 'AF' then '' -- агрегатная функция (среда CLR)
                        when 'FT' then 'Function' -- функция сборки с табличным значением (среда CLR)  
                        when 'K'  then '' -- ограничение PRIMARY KEY или UNIQUE
                        when 'L'  then '' -- журнал
                        when 'R'  then '' -- правило
                        when 'RF' then '' -- хранимая процедура фильтра репликации
                        when 'SN' then '' -- синоним
                        when 'TA' then '' -- триггер DML сборки (среда CLR)
                        when 'X'  then '' -- расширенная хранимая процедура
                      end   
    from sys.objects as o 
    join sys.schemas as s on s.[schema_id] = o.[schema_id]   
    where o.[object_id] = object_id(@ObjSysName) 

  select
       @Params = isnull(fn.DelDoubleSpace(@Params), '')     
	  ,@TemplateMsg = 'Следуйте следующему шаблону: '   + @El + @El
	  + 'exec [dbo].[FillExtendedProperty]' + @El 
	  + ' @ObjSysName = ''схема.НазваниеОбьекта'''   + @El
	  + ',@ObjWrapName = ''схема.НазваниеОбьекта'''+ @El
	  + ',@Author = ''Создатель объекта'''+ @El
	  + ',@Description = ''Описание Обьекта'''+ @El
	  + ',@Params = ''  параметр1 = описание параметра1 \n' + @El
	  + '             ,параметр2 = описание параметра2 \n' + @El
	  + '             ,параметр3 = описание параметра3 \n' + @El
	  + '             ,параметрN = описание параметраN ''' + @El + @El
	  + 'Разделителем между параметрами обекта является \n' + @El
	  + 'Разделителем между параметром и описанием параметром является знак ='  + @El
	  + ',@RowSets = ''Возвращаемые наборы данных'''+ @El
	  + ',@Errors = ''Возможные ошибки'''+ @El
	  + '@ObjWrapName параметр не обязательный. Вычисляется автоматически.'  
  --|| */Аргументы
  
  --||/* RAISERROR   
  if isnull(@ObjSysName, 'help') = 'help' 
  begin
    print (@TemplateMsg) 
    return                    
  end else if  isnull(@ObjSysName, '') = ''
    select @ErrMsg = 'Укажите название процедуры.'      

  else if  @Description = ''
    select @ErrMsg = 'Укажите описание\назначение процедуры.' 

  else if  @Author = ''
    select @ErrMsg = 'Укажите создателя объекта @Author' 

  else if isnull(@ObjName, '') = ''
    select @ErrMsg = 'Объект с именем ' + @ObjName + ' не существует!!!'                    
  
  --|| Обязательные параметры Объекта и Wrapper'а Объекта
  declare @RequiredPrms table (Name sysname, Value varchar(4000))
  insert into @RequiredPrms (Name, Value) 
  select 'Description', isnull(fn.DelDoubleSpace(@Description), '')
  union 
  select 'Author',  isnull(fn.DelDoubleSpace(@Author), '')
  union 
  select 'DateCreate', master.dbo.fn_datetime_to_str_ForUser(getdate())
  union
  select 'Creator suser sname', suser_sname()
  union 
  select 'RowSets',  isnull(fn.DelDoubleSpace(@RowSets), '')
  union 
  select 'Errors',  isnull(fn.DelDoubleSpace(@Errors), '') 
     
  --|| Входные параметры
  declare @InParamsObj table(Name sysname, Value varchar(4000))  
  insert into @InParamsObj (Name, Value) 
  select 
       Name
      ,Value 
    from tf.ParamsOfStrToTable(@Params) 
    where isnull(Value, '') <> ''       
  union
  select 
       r.Name
      ,r.Value
    from @RequiredPrms as r  

  --|| Все extended properties объекта
  declare @ObjExtendedProp table (Name sysname, Value varchar(4000))
  insert into @ObjExtendedProp (Name, Value)
  select 
       p.Name                         as Name
      ,cast(p.Value as varchar(4000)) as Value
    from sys.extended_properties as p     
    where p.major_id = object_id(@ObjSysName)  
      and p.minor_id = 0
      and p.class = 1
      and p.Name is not null   
         
  ------------------------------------    
  --|| /*Списки параметров для изменения
  ------------------------------------
  
  --|| Список для удаления
  declare @RemoveExtendedProp table (Name sysname, Value varchar(4000))
  insert into @RemoveExtendedProp (Name, Value)
  select 
       p.Name  as Name
      ,p.Value as Value
    from @ObjExtendedProp as p     
    where p.Name not in (select Name from @InParamsObj)

  --|| Список для обновления
  declare @UpdateExtendedProp table (Name sysname, Value varchar(4000))
  insert into @UpdateExtendedProp (Name, Value)
  select 
       p.Name 
      ,r.Value
    from @ObjExtendedProp   as p  
    inner join @InParamsObj as r on r.Name = p.Name 
                                and r.Value <> p.Value
    where p.Name not in ('DateCreate', 'CreatorLoginDev')     
  
  --|| Список для добавления 
  declare @AddExtendedProp table (Name sysname, Value varchar(4000))
  insert into @AddExtendedProp (Name, Value)
  select 
       pr.Name    as Name  
      ,pr.Value   as Value 
    from @InParamsObj as pr 
    where  pr.Name not in (select Name from @ObjExtendedProp) 
  ------------------------------------  
  --|| */Списки параметров для изменения
  ------------------------------------
  ------------------
   --|| /*debug_info
  ------------------
  if @debug_info & 0x01 > 0       
  begin  
    select * from @InParamsObj
    
    select 
       @ObjSysName    as '@ObjSysName'        
      ,@ObjName       as '@ObjName'
      ,@ObjSchema     as '@ObjSchema'
      ,@ObjType       as '@ObjType'
      ,@ObjSchemaId   as '@ObjSchemaId'
      ,@ObjWrapName   as '@ObjWrapName'

    select 
         r.Name            as Name
        ,r.Value           as Value
        ,'параметр удалён' as Status 
      from @RemoveExtendedProp as r
    union                 
    select 
         u.Name             as Name
        ,u.Value            as Value
        ,'описание параметра изменено' as Status
      from @UpdateExtendedProp as u
    union                 
    select 
         a.Name                           as Name
        ,a.Value                          as Value
        ,'добавлен параметр с описанием'  as Status
      from @AddExtendedProp as a
    
  end 
  ------------------
  --|| /*debug_info
  ------------------
      
  -------------------------------------
  begin tran TRAN_ExtendedProperty
  -------------------------------------
    ---------------------------------------------
    --|| /* Изменение extended properties Объекта
    ---------------------------------------------
    if exists (select Name from @AddExtendedProp)
    begin 
      -----------------------------
      --|| /*Добавление новых параметров
      -----------------------------
      select  @cnt = 0
      declare cursor_for_add_param cursor local fast_forward for 
        select
             name
            ,value
          from @AddExtendedProp  

      open cursor_for_add_param
      fetch next from cursor_for_add_param into
         @ParamName  
        ,@ParamValue 
        
      while @@fetch_status = 0
      begin
        exec sys.sp_addextendedproperty 
           @Name       = @ParamName
          ,@Value      = @ParamValue
          ,@level0type = 'SCHEMA' 
          ,@level0Name = @ObjSchema
          ,@level1type = @ObjTypeName 
          ,@level1Name = @ObjName      

        select @err = @@error, @cnt = @cnt + 1  
        ------------------------------------       
        if (@res < 0 or @err != 0) 
        begin
          if @@trancount > 0 rollback
          raiserror (@ErrMsg, 16, 1)
          return (@ret)              
        end   
        ------------------------------------ 
        fetch next from cursor_for_add_param into
           @ParamName  
          ,@ParamValue
      end
      close cursor_for_add_param
      deallocate cursor_for_add_param  
      print 'Добавление параметров с описанием в Extended Property объекта: '  + cast(@cnt as varchar) + ' шт.' + @El
      -----------------------------
      --|| */Добавление новых параметров в Extended Property объекта
      -----------------------------     
    end 
    --------------------------------------
    if exists (select * from @UpdateExtendedProp)
    begin 
      --------------------------------------
      --|| /*Изменение значений(values) параметров в Extended Property
      --------------------------------------  
      select  @cnt = 0      
      declare cursor_for_update_param cursor
      for 
      select 
           Name
          ,Value
        from @UpdateExtendedProp 
      open cursor_for_update_param
      fetch next from cursor_for_update_param into
         @ParamName
        ,@ParamValue  

      while @@fetch_status = 0
      begin
        exec sys.sp_updateextendedproperty
           @Name       = @ParamName
          ,@Value      = @ParamValue
          ,@level0type = 'SCHEMA'
          ,@level0Name = @ObjSchema
          ,@level1type = @ObjTypeName   
          ,@level1Name = @ObjName   

        select @err = @@error, @cnt = @cnt +1
        ------------------------------------       
        if (@res < 0 or @err != 0) 
        begin
          select 
             @ret = case when @res = 0 then @err else @res end
            ,@ErrMsg = 'Неудачная попытка обновления Extended Property в описание объекта.' 
          if @@trancount > 0 rollback
          raiserror (@ErrMsg, 16, 1)
          return (@ret)             
        end
        ------------------------------------  
        fetch next from cursor_for_update_param into
           @ParamName  
          ,@ParamValue
      end
      close cursor_for_update_param
      deallocate cursor_for_update_param
      print 'Изменение описаний параметров в Extended Property объекта: '  + cast(@cnt as varchar) + ' шт.'  + @El 
      ------------------------------------
      --|| */Изменение значений(values) параметров в Extended Property
      ------------------------------------ 
    end
    --------------------------------------
    if exists (select * from @RemoveExtendedProp as p)
    begin  
      --------------------------
      --|| /*Удаление параметров из Extended Property объекта    
      ---------------------------  
      select @cnt = 0
      declare cursor_for_rem_param cursor
      for 
      select Name
        from @RemoveExtendedProp          
      open cursor_for_rem_param
      fetch next from cursor_for_rem_param into
        @ParamName  

      while @@fetch_status = 0
      begin
        exec sys.sp_dropextendedproperty 
           @Name       = @ParamName
          ,@level0type = 'SCHEMA' 
          ,@level0Name = @ObjSchema
          ,@level1type = @ObjTypeName 
          ,@level1Name = @ObjName   

        select @err = @@error, @cnt = @cnt +1
        ------------------------------------       
        if (@res < 0 or @err != 0) 
        begin
          select 
             @ret = case when @res = 0 then @err else @res end
            ,@ErrMsg = 'Неудачная попытка удаления расширенных Extended Property в описание объекта.' 
          if @@trancount > 0 rollback
          raiserror (@ErrMsg, 16, 1)
          return (@ret)
        end 
        ------------------------------------
        fetch next from cursor_for_rem_param into
           @ParamName  
      end
      close cursor_for_rem_param
      deallocate cursor_for_rem_param  
      print 'Удаление параметров из Extended Property объекта: ' + cast(@cnt as varchar) + ' шт.' + @El 
      -------------------------
      --|| */Удаление параметров из Extended Property объекта         
      -------------------------    
    end
    ---------------------------------------------
    --|| */ Изменение extended properties Объекта
    ---------------------------------------------   
    -----------------------------------------------------
    --|| /* Изменение extended properties Wrapper'a Объекта
    -----------------------------------------------------   
    
    if    @ObjWrapName is not null 
    begin
      --|| Все extended properties Wrapper'a Объекта
      declare @ObjWrapExtendedProp table (Name sysname, Value varchar(4000))
      insert into @ObjWrapExtendedProp (Name, Value)
      select 
           p.Name                         as Name
          ,cast(p.Value as varchar(4000)) as Value
        from sys.extended_properties as p     
        where p.major_id = object_id(@ObjWrapName)  
          and p.minor_id = 0
          and p.class = 1
          and p.Name is not null  
     
      --|| Все extended properties объекта 
      delete from @ObjExtendedProp
      insert into @ObjExtendedProp (Name, Value)
      select 
           p.Name                         as Name
          ,cast(p.Value as varchar(4000)) as Value
        from sys.extended_properties as p     
        where p.major_id = object_id(@ObjSysName)  
          and p.minor_id = 0
          and p.class = 1
          and p.Name is not null     
         
      ------------------------------------    
      --|| /*Списки параметров для изменения
      ------------------------------------
      --|| Список для удаления
      declare @RemoveWrapExtendedProp table (Name sysname)
      insert into @RemoveWrapExtendedProp (Name)
      select Name as Name
        from @ObjWrapExtendedProp        
        where Name not in (select Name from @ObjExtendedProp)
      
      --|| Список на добавление
      declare @AddWrapExtendedProp table (Name sysname, Value varchar(4000))
      insert into @AddWrapExtendedProp (Name, Value)
      select 
           p.Name    as Name
          ,p.Value   as Value
        from @ObjExtendedProp as p     
        where p.Name not in (select Name from @ObjWrapExtendedProp)

      --|| Список на изменение
      declare @UpdateWrapExtendedProp table (Name sysname, Value varchar(4000))
      insert into @UpdateWrapExtendedProp (Name, Value)
      select 
           p.Name    as Name
          ,p.Value   as Value         
        from @ObjExtendedProp as p    
        inner join @ObjWrapExtendedProp as r on r.Name = p.Name
        where p.Value <> r.Value       
      ------------------------------------    
      --|| */Списки параметров для изменения
      ------------------------------------
      
      if exists (select Name from @AddWrapExtendedProp)
      begin
      -----------------------------
      --|| /*Добавление новых параметров в Extended Properties Wrapper'a Объекта      
      -----------------------------
        declare cursor_for_wrapadd_param cursor
        for 
        select 
             Name
            ,Value
          from @AddWrapExtendedProp  
        open cursor_for_wrapadd_param
        fetch next from cursor_for_wrapadd_param into
           @ParamName  
          ,@ParamValue 

        while @@fetch_status = 0
        begin
          exec sys.sp_addextendedproperty 
             @Name       = @ParamName
            ,@Value      = @ParamValue
            ,@level0type = 'SCHEMA' 
            ,@level0Name = @ObjWrapName
            ,@level1type = @ObjTypeName 
            ,@level1Name = @ObjWrapName      

          select @err = @@error  
          ----------------------------------------
          if (@res < 0 or @err != 0) 
          begin
            select
               @ret = case when @res = 0 then @err else @res end
              ,@ErrMsg = 'Неудачная попытка добавления расширенных параметров в описание wrapper объекта.' 
            if @@trancount > 0 rollback
            raiserror (@ErrMsg, 16, 1)
            return (@ret)
          end           
          ----------------------------------------      
          fetch next from cursor_for_wrapadd_param into
             @ParamName  
            ,@ParamValue
        end
        close cursor_for_wrapadd_param
        deallocate cursor_for_wrapadd_param
      -----------------------------
      --|| /*Добавление новых параметров в Extended Properties Wrapper'a Объекта  
      -----------------------------
      end
      
      if exists (select * from @UpdateWrapExtendedProp)
      begin 
      ------------------------------------
      --|| /*Изменение значений(value) параметров в Extended Properties Wrapper'a Объекта  
      --------------------------------------            
        declare cursor_for_wrapupdate_param cursor
        for 
        select 
             Name
            ,Value
          from @UpdateWrapExtendedProp
        open cursor_for_wrapupdate_param
        fetch next from cursor_for_wrapupdate_param into
           @ParamName
          ,@ParamValue  

        while @@fetch_status = 0
        begin
          exec sys.sp_updateextendedproperty 
             @Name       = @ParamName
            ,@Value      = @ParamValue
            ,@level0type = 'SCHEMA'
            ,@level0Name = @ObjWrapName
            ,@level1type = @ObjTypeName   
            ,@level1Name = @ObjWrapName   

          select @err = @@error  
          ------------------------------------       
          if (@res < 0 or @err != 0) 
          begin
            select 
               @ret = case when @res = 0 then @err else @res end
              ,@ErrMsg = 'Неудачная попытка обновления Extended Property в описание wrapper объекта.' 
            if @@trancount > 0 rollback
            raiserror (@ErrMsg, 16, 1)
            return (@ret)
          end           
          ------------------------------------ 
          fetch next from cursor_for_wrapupdate_param into
             @ParamName  
            ,@ParamValue
        end
        close cursor_for_wrapupdate_param
        deallocate cursor_for_wrapupdate_param 
      ------------------------------------
      --|| */Изменение значений(value) параметров в Extended Properties Wrapper'a Объекта  
      --------------------------------------      
      end
      
      if exists (select * from @RemoveWrapExtendedProp as p)
      begin  
      -------------------------
      --|| /*Удаление параметров из Extended Properties Wrapper'a Объекта       
      -------------------------     
        declare cursor_for_wraprem_param cursor
        for 
        select Name
          from @RemoveWrapExtendedProp 
        open cursor_for_wraprem_param
        fetch next from cursor_for_wraprem_param into
          @ParamName  

        while @@fetch_status = 0
        begin
          exec sys.sp_dropextendedproperty 
             @Name       = @ParamName
            ,@level0type = 'SCHEMA' 
            ,@level0Name = @ObjWrapName
            ,@level1type = @ObjTypeName 
            ,@level1Name = @ObjWrapName   

          select @err = @@error  
          ------------------------------------------
          if (@res < 0 or @err != 0) 
          begin
            select
               @ret = case when @res = 0 then @err else @res end
              ,@ErrMsg = 'Неудачная попытка удаления расширенных Extended Property в описание wrapper объекта.' 
            if @@trancount > 0 rollback
            raiserror (@ErrMsg, 16, 1)
            return (@ret) 
          end
          ------------------------------------------   
          fetch next from cursor_for_wraprem_param into
            @ParamName  
        end
        close cursor_for_wraprem_param
        deallocate cursor_for_wraprem_param 
      -------------------------
      --|| */Удаление параметров из Extended Properties Wrapper'a Объекта    
      -------------------------    
      end  
    end   
    -----------------------------------------------------
    --|| */ Изменение extended properties Wrapper'a Объекта
    -----------------------------------------------------       
  ------------------------------------
  commit tran TRAN_ExtendedProperty
  ------------------------------------          
  --|| /* Информационное сообщение   
  --|| Входные параметры не входящие в список параметров Обьекта
  declare @InNotIncludedParams table(Name sysname, Value varchar(4000))  
  insert into @InNotIncludedParams (Name, Value) 
  select 
       t.Name
      ,t.[Value]
    from @ObjExtendedProp as t
    where t.Name not in (select c.Name as Name
                           from syscolumns        as c
                           inner join sysobjects  as o on o.id = c.id
                           where  o.name = @ObjName
                         union
                         select s.Name as Name 
                           from @RequiredPrms as s)    
                          
  --|| Список входных параметров без описания
  select @InfoMsg = ( select '  ,' + c.Name + char(10) as 'data()' 
                        from sys.syscolumns               as c
                        left join sys.extended_properties as p on p.major_id = c.id
                                                              and p.minor_id = 0
                                                              and p.class = 1
                                                              and p.Name = c.Name   
                        where c.id = object_id(@ObjSysName) 
                          and c.Name not in (select Name from @InParamsObj)
                          and isnull(p.Value, '') = ''
                          and c.Name <> '@debug_info'
                        for xml path('')) + @el
                        
  --|| Параметры которые есть в Extended Properties объекта, но нет в списке параметров самого объекта(произвольный параметр с описанием)                       
  select @InfoMsgPrms =  ( select '  ,' + c.Name + ' = ' + c.Value + char(10) as 'data()' 
                             from @InNotIncludedParams as c
                             for xml path('')) + @el                      
  select @InfoMsg = 'Список входных параметров без описания: ' + @el + '    ' + right(@InfoMsg, len(@InfoMsg) - 3)   
  select @InfoMsgPrms =  'Список параметров с описанием  (не декларированных в объекте)' + @el + '    ' + right(@InfoMsgPrms, len(@InfoMsgPrms) - 3)                  
                        
  --доработать в соответствии текстом вывода
  if (isnull(@InfoMsg, '') <> '') or (isnull(@InfoMsgPrms, '') <> '')   
    print isnull(@El + @InfoMsg, '') + isnull(@InfoMsgPrms, '')
    
  --|| */Информационное сообщение
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <WRAPPER>
----------------------------------------------
--exec [dbo]. '[dbo].[FillExtendedProperty]'
go
----------------------------------------------
-- <Filling Extended Property>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName = 'dbo.[FillExtendedProperty]'
  ,@Author = 'Cova Igor'
  ,@Description = 'Механизм документирования объектов в MS SQL Server. 
                   Заполнение Extendefdhd Property объекта.'
  ,@Params = '@ObjSysName = Имя объекта в MS SQL Server. Вносить вместе со схемой.\n
             ,@ObjWrapName =  Имя оболочки обьекта. Вносить вместе со схемой. Параметр не обязательный. \n
             ,@Author =  Создатель объекта \n             
             ,@Params =  Входные параметры для вызова объекта\n
             ,@Description = Описание объекта: Предназначение\способ использования и все что возможно будет важно при использовании данного объекта \n
             ,@RowSets = Описание возвращаемых наборов данных \n
             ,@Errors = Описание возможных ошибок \n
             ,@debug_info = Для отладки \n
             '
go
------------------------------------------------
-- <View Extended Property>
------------------------------------------------
/*exec dbo.[Object.ExtendedProperty] 
  @ObjSysName = '[dbo].[FillExtendedProperty]'
go
*/
 /*ОТЛАДКА: 
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec [dbo].[FillExtendedProperty] 
   @ObjSysName    = 'dbo.[RequestCar.Create]'      
  ,@Author        = 'Коваленко Игорь'
  ,@Description   = 'Процедура создания заявки в рекар.'
  ,@Params        = 
     '@DateOfIssue =  Ориентировочная дата выдачи авто (Склад продавца) Дата\n
     ,@DocumentsInTime = Документы ко времени \n
     ,@FileSpec =  Файл спецификации \n
     ,@IsClientInSalon = Клиент в салоне (Да/Нет) \n
     ,@IsDateOfIssue = Выдача к Ориентировочная дата выдачи авто (Склад продавца) (Да/Нет)\n
     ,@IsDocumentsInTime = Документы ко времени, пожелаение клиента (Да/Нет) \n
     ,@IsRegistration = Постановка авто на учет Да/Нет\n
     ,@IsSucces =  output возвращает true как об успещном commit Да/Нет \n
     ,@OrderOID =  OID заказа\n
     ,@SaleHistoryNote = История оплат клиента за авто \n
     ,@SalesPrice = Цена продажи авто из 1С \n
     ,@TradeIn =  Номер заказа из оценки авто, если авто проданное способом TradeIn в пользу покупаемого авто \n '

  ,@debug_info = 1
  ,@debug_shift = null
  ,@log_sesid = null     

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
--
go
*/