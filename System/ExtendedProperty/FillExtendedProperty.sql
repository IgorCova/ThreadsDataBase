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
///  Fill Extended Property of db object in MS SQL Server
///</description>
*/
alter procedure [dbo].[FillExtendedProperty]
-- v1.0
  -- of(Object):   
   @ObjSysName     sysname       = null
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
                        when 'P'  then 'Procedure' -- Stored Procedure
                        when 'FN' then 'Function'  -- Function
                        when 'TF' then 'Function' -- Table Function
                        when 'V'  then 'View'       -- View
                        when 'FS' then 'Function'  -- Function (CLR)
                        when 'TR' then '' -- Trigger DML SQL
                        when 'PC' then '' -- Stored Procedure (CLR)
                        when 'SQ' then '' -- Sequence
                        when 'TT' then ''  -- Table type
                        when 'S'  then 'Table' -- System table
                        when 'D'  then '' -- Constraint or DEFAULT
                        when 'IT' then 'Table'  -- Inline table
                        when 'F'  then '' -- Constraint FOREIGN KEY
                        when 'PK' then ''  -- Constraint PRIMARY KEY
                        when 'U'  then 'Table'  -- User table
                        when 'IF' then 'Function'  -- Inline Function
                        when 'C'  then '' -- CHECK
                        when 'UQ' then '' -- UNIQUE (type K)
                        when 'AF' then '' -- aggregate function (CLR)
                        when 'FT' then 'Function' -- unction of the assembly with the tabulated value (CLR)  
                        when 'K'  then '' -- Constraint PRIMARY KEY or UNIQUE
                        when 'L'  then '' -- Journal
                        when 'R'  then '' -- Role
                        when 'RF' then '' -- Stored Procedure replication filter
                        when 'SN' then '' -- Synonim
                        when 'TA' then '' -- Trigger DML (CLR)
                        when 'X'  then '' -- Extended Stored Procedure
                      end   
    from sys.objects as o 
    join sys.schemas as s on s.[schema_id] = o.[schema_id]   
    where o.[object_id] = object_id(@ObjSysName) 

  select
       @Params = isnull(fn.DelDoubleSpace(@Params), '')     
	    ,@TemplateMsg = 'Fallow next blank: '   + @El + @El
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
  --|| */Arguments
  
  --||/* RAISERROR   
  if isnull(@ObjSysName, 'help') = 'help' 
  begin
    print (@TemplateMsg) 
    return                    
  end else if  isnull(@ObjSysName, '') = ''
    select @ErrMsg = 'Specify the name of the procedure.'      

  else if  @Description = ''
    select @ErrMsg = 'Specify the describe of the procedure.' 

  else if  @Author = ''
    select @ErrMsg = 'Specify the author of the procedure @Author' 

  else if isnull(@ObjName, '') = ''
    select @ErrMsg = 'Object with name ' + @ObjName + ' don''t exists!!!'                    
  
  --|| Mandatory parameters of objects and object NativeCheck's
  declare @RequiredPrms table (Name sysname, Value varchar(4000))
  insert into @RequiredPrms (Name, Value) 
  select 'Description', isnull(fn.DelDoubleSpace(@Description), '')
  union 
  select 'Author',  isnull(fn.DelDoubleSpace(@Author), '')
  union 
  select 'DateCreate', master.dbo.fn_datetime_to_str_ForUser(getdate())
  union
  select 'Creator suser_sname', suser_sname()

  --|| In params
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

  --|| All extended properties object
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
  --|| /*СLists of parameters for change
  ------------------------------------
  
  --|| List remover
  declare @RemoveExtendedProp table (Name sysname, Value varchar(4000))
  insert into @RemoveExtendedProp (Name, Value)
  select 
       p.Name  as Name
      ,p.Value as Value
    from @ObjExtendedProp as p     
    where p.Name not in (select Name from @InParamsObj)

  --|| List update
  declare @UpdateExtendedProp table (Name sysname, Value varchar(4000))
  insert into @UpdateExtendedProp (Name, Value)
  select 
       p.Name 
      ,r.Value
    from @ObjExtendedProp   as p  
    inner join @InParamsObj as r on r.Name = p.Name 
                                and r.Value <> p.Value
    where p.Name not in ('DateCreate')     
  
  --|| List add 
  declare @AddExtendedProp table (Name sysname, Value varchar(4000))
  insert into @AddExtendedProp (Name, Value)
  select 
       pr.Name    as Name  
      ,pr.Value   as Value 
    from @InParamsObj as pr 
    where  pr.Name not in (select Name from @ObjExtendedProp) 
  ------------------------------------  
  --|| */List change
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
 
    select 
         r.Name            as Name
        ,r.Value           as Value
        ,'Param was deleted' as Status 
      from @RemoveExtendedProp as r
    union                 
    select 
         u.Name             as Name
        ,u.Value            as Value
        ,'Describe was changed' as Status
      from @UpdateExtendedProp as u
    union                 
    select 
         a.Name                           as Name
        ,a.Value                          as Value
        ,'Add new parameter with desrcribe'  as Status
      from @AddExtendedProp as a
    
  end 
  ------------------
  --|| /*debug_info
  ------------------
      
  -------------------------------------
  begin tran TRAN_ExtendedProperty
  -------------------------------------
    ---------------------------------------------
    --|| /* Change extended properties of object
    ---------------------------------------------
    if exists (select Name from @AddExtendedProp)
    begin 
      -----------------------------
      --|| /*Add new parametrs
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
      print 'Add parameters with description to Extended Property db object: '  + cast(@cnt as varchar) + ' psc.' + @El
      -----------------------------
      --|| */Add new parameters to Extended Property of object
      -----------------------------     
    end 
    --------------------------------------
    if exists (select * from @UpdateExtendedProp)
    begin 
      --------------------------------------
      --|| /*Change values parameters in Extended Property
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
            ,@ErrMsg = 'A failed attempt to upgrade to Extended Property description.' 
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
      print 'Changing the parameter descriptions in the Extended Property object: '  + cast(@cnt as varchar) + ' pcs.'  + @El 
      ------------------------------------
      --|| */Change values parameters in Extended Property
      ------------------------------------ 
    end
    --------------------------------------
    if exists (select * from @RemoveExtendedProp as p)
    begin  
      --------------------------
      --|| /*Delete parameters in Extended Property   
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
            ,@ErrMsg = 'The attempt to remove the extended Extended Property descriptions.' 
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
      print 'Deleting parameters from the Extended Property object: ' + cast(@cnt as varchar) + ' pcs.' + @El 
      -------------------------
      --|| */Deleting parameters from the Extended Property object         
      -------------------------    
    end
    ---------------------------------------------
    --|| */ Changing extended properties of object
    ---------------------------------------------         
  ------------------------------------
  commit tran TRAN_ExtendedProperty
  ------------------------------------          
  --|| /* Announcement
  --|| Input parameters are not included in the list of object parameters
  declare @InNotIncludedParams table(Name sysname, Value varchar(4000))  
  insert into @InNotIncludedParams (Name, Value) 
  select 
       t.Name
      ,t.[Value]
    from @ObjExtendedProp as t
    where t.Name not in (select c.Name as Name
                           from syscolumns  as c
                           join sysobjects  as o on o.id = c.id
                           where  o.name = @ObjName
                         union
                         select s.Name as Name 
                           from @RequiredPrms as s)    
                          
  --|| List of input parameters with no description
  select @InfoMsg = ( select '  ,' + c.Name + ' =  \n' + char(10) as 'data()' 
                        from sys.syscolumns               as c
                        left join sys.extended_properties as p on p.major_id = c.id
                                                              and p.minor_id = 0
                                                              and p.class = 1
                                                              and p.Name = c.Name   
                        where c.id = object_id(@ObjSysName) 
                          and c.Name not in (select Name from @InParamsObj)
                          and isnull(p.Value, '') = ''
                          and not (c.Name in ('@debug_info', '@id'))
                        for xml path('')) + @el
                        
  --|| Parameters which are in Extended Properties object, but not in the list of parameters of the object (an arbitrary parameter description)                      
  select @InfoMsgPrms =  ( select '  ,' + c.Name + ' = ' + c.Value + char(10) as 'data()' 
                             from @InNotIncludedParams as c
                             for xml path('')) + @el                      
  select @InfoMsg = 'The list of input parameters with no description: ' + @el + '    ' + right(@InfoMsg, len(@InfoMsg) - 3)   
  select @InfoMsgPrms =  'List of parameters describing the (undeclared in the object): ' + @el + '    ' + right(@InfoMsgPrms, len(@InfoMsgPrms) - 3)                  
                        
  -- modify according to the text output
  if (isnull(@InfoMsg, '') <> '') or (isnull(@InfoMsgPrms, '') <> '')   
    print isnull(@El + @InfoMsg, '') + isnull(@InfoMsgPrms, '')
    
  --|| */Announcement
  -----------------------------------------------------------------
  -- End Point
  return (0)
end
go

----------------------------------------------
-- <NativeCheck>
----------------------------------------------
exec [dbo].[NativeCheck] '[dbo].[FillExtendedProperty]'
go

----------------------------------------
-- <Filling Extended Property>
----------------------------------------------
exec dbo.FillExtendedProperty
   @ObjSysName = 'dbo.[FillExtendedProperty]'
  ,@Author = 'Cova Igor'
  ,@Description = 'Fill Extended Property of db object in MS SQL Server'
  ,@Params = '@ObjSysName = Name of object in MS SQL Server. Make together with the scheme. \n
             ,@Author =  Author of object \n             
             ,@Params =  Input parameters for the call object \n
             ,@Description = Description\Purpose way to use all that may be important when using this object \n
             ,@RowSets = Description of returned data sets \n
             ,@Errors = A description of the error \n
             ,@debug_info = For debugging \n
             '
go

/*Debugger: 
declare @ret int, @err int, @runtime datetime

select @runtime = getdate()
exec [dbo].[FillExtendedProperty] 
   @ObjSysName    = 'dbo.[RequestCar.Create]'      
  ,@Author        = 'Cova Igor'
  ,@Description   = 'Procedure Description.'
  ,@Params        = ''

select @err = @@error

select @ret as [RETURN], @err as [ERROR], convert(varchar(20), getdate()-@runtime, 114) as [RUN_TIME]
go
*/