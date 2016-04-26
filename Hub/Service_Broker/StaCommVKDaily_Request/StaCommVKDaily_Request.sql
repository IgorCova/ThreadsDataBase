Use Hub
go

------------------------------------------------------------------------------------------------------------------
-- service_message_types
------------------------------------------------------------------------------------------------------------------
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

if not exists(
  select * 
    from sys.service_message_types 
    where [name] = 'msg_StaCommVKDaily_Request')
begin
  create message type msg_StaCommVKDaily_Request
end 
go

alter message type msg_StaCommVKDaily_Request 
  validation = well_formed_xml;
go

------------------------------------------------------------------------------------------------------------------
-- service_contracts
------------------------------------------------------------------------------------------------------------------
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

if exists(select * from sys.service_contracts 
              where [name] = 'ct_StaCommVKDaily_Request')
begin
  drop contract ct_StaCommVKDaily_Request
end 
go

create contract ct_StaCommVKDaily_Request (msg_StaCommVKDaily_Request sent by any );
go

------------------------------------------------------------------------------------------------------------------
-- service_queues
------------------------------------------------------------------------------------------------------------------
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

if not exists(select * 
                from sys.service_queues
                where [name] = 'que_StaCommVKDaily_Request')
begin
  create queue que_StaCommVKDaily_Request with status=on
end 
go

alter queue que_StaCommVKDaily_Request
   with status = on 
  ,activation (
      status = on,       
      procedure_name = sb.StaCommVKDaily_Request_Exe,
      max_queue_readers = 4,
      execute as owner)  
go

------------------------------------------------------------------------------------------------------------------
-- services
------------------------------------------------------------------------------------------------------------------
set nocount on
set quoted_identifier, ansi_nulls, ansi_warnings, arithabort, concat_null_yields_null, ansi_padding on
set numeric_roundabort off
set transaction isolation level read uncommitted
set xact_abort on
go

if not exists(select * 
                from sys.services
                where [name] = 'srv_StaCommVKDaily_Request')
begin
  create service srv_StaCommVKDaily_Request on queue que_StaCommVKDaily_Request(ct_StaCommVKDaily_Request) 
end
go

alter service srv_StaCommVKDaily_Request on queue que_StaCommVKDaily_Request;
go


