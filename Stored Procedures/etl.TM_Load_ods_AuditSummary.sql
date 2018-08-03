SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_Load_ods_AuditSummary]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000',
	@Target VARCHAR(256) = null,
	@Source VARCHAR(256) = null,
	@BusinessKey VARCHAR(256) = null,
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = 'TM_StandardMerge - ods.TM_AuditSummary'
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.TM_AuditSummary),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting('ClientName'), DB_NAME()));

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

UPDATE stg.TM_AuditSummary
SET ETL__Source = '00000000-0000-0000-0000-000000000000'
WHERE ETL__Source IS NULL




INSERT INTO archive.TM_AuditSummary
(
	ETL__CreatedDate, ETL__Source, ETL__BatchId, ETL__ExecutionId
	,  [event_name], [parent_price_code], [price_code_desc], [PLAN], [event], [groups], [comp], [held], [avail], [kill], [revenue], [price_code], [audithostsold], [auditarchticssold], [ticketarchticssold], [tickethostsold], [ticketavailsold], [diffhostsold], [diffarchticssold], [event_id], [export_datetime], [seq_num], [pc_ticket], [pc_tax], [pc_licfee], [pc_other1], [pc_other2], [pc_other3], [pc_other4], [pc_other5], [pc_other6], [pc_other7], [pc_other8]
)

SELECT 
GETDATE() ETL__CreatedDate, ETL__Source
, @BatchId ETL__BatchId, @ExecutionId ETL__ExecutionId
,  [event_name], [parent_price_code], [price_code_desc], [PLAN], [event], [groups], [comp], [held], [avail], [kill], [revenue], [price_code], [audithostsold], [auditarchticssold], [ticketarchticssold], [tickethostsold], [ticketavailsold], [diffhostsold], [diffarchticssold], [event_id], [export_datetime], [seq_num], [pc_ticket], [pc_tax], [pc_licfee], [pc_other1], [pc_other2], [pc_other3], [pc_other4], [pc_other5], [pc_other6], [pc_other7], [pc_other8]
FROM stg.TM_AuditSummary



DECLARE @RecordCount INT = (SELECT COUNT(*) FROM stg.TM_AuditSummary)
DECLARE @StartIndex INT = 1, @PageCount INT = 1000000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)




UPDATE stg.TM_AuditSummary SET [auditarchticssold] = NULL WHERE [auditarchticssold] = '';

UPDATE stg.TM_AuditSummary SET [audithostsold] = NULL WHERE [audithostsold] = '';

UPDATE stg.TM_AuditSummary SET [avail] = NULL WHERE [avail] = '';

UPDATE stg.TM_AuditSummary SET [comp] = NULL WHERE [comp] = '';

UPDATE stg.TM_AuditSummary SET [diffarchticssold] = NULL WHERE [diffarchticssold] = '';

UPDATE stg.TM_AuditSummary SET [diffhostsold] = NULL WHERE [diffhostsold] = '';

UPDATE stg.TM_AuditSummary SET [event] = NULL WHERE [event] = '';

UPDATE stg.TM_AuditSummary SET [event_id] = NULL WHERE [event_id] = '';

UPDATE stg.TM_AuditSummary SET [export_datetime] = NULL WHERE [export_datetime] = '';

UPDATE stg.TM_AuditSummary SET [groups] = NULL WHERE [groups] = '';

UPDATE stg.TM_AuditSummary SET [held] = NULL WHERE [held] = '';

UPDATE stg.TM_AuditSummary SET [kill] = NULL WHERE [kill] = '';

UPDATE stg.TM_AuditSummary SET [pc_licfee] = NULL WHERE [pc_licfee] = '';

UPDATE stg.TM_AuditSummary SET [pc_other1] = NULL WHERE [pc_other1] = '';

UPDATE stg.TM_AuditSummary SET [pc_other2] = NULL WHERE [pc_other2] = '';

UPDATE stg.TM_AuditSummary SET [pc_other3] = NULL WHERE [pc_other3] = '';

UPDATE stg.TM_AuditSummary SET [pc_other4] = NULL WHERE [pc_other4] = '';

UPDATE stg.TM_AuditSummary SET [pc_other5] = NULL WHERE [pc_other5] = '';

UPDATE stg.TM_AuditSummary SET [pc_other6] = NULL WHERE [pc_other6] = '';

UPDATE stg.TM_AuditSummary SET [pc_other7] = NULL WHERE [pc_other7] = '';

UPDATE stg.TM_AuditSummary SET [pc_other8] = NULL WHERE [pc_other8] = '';

UPDATE stg.TM_AuditSummary SET [pc_tax] = NULL WHERE [pc_tax] = '';

UPDATE stg.TM_AuditSummary SET [pc_ticket] = NULL WHERE [pc_ticket] = '';

UPDATE stg.TM_AuditSummary SET [PLAN] = NULL WHERE [PLAN] = '';

UPDATE stg.TM_AuditSummary SET [revenue] = NULL WHERE [revenue] = '';

UPDATE stg.TM_AuditSummary SET [ticketarchticssold] = NULL WHERE [ticketarchticssold] = '';

UPDATE stg.TM_AuditSummary SET [ticketavailsold] = NULL WHERE [ticketavailsold] = '';

UPDATE stg.TM_AuditSummary SET [tickethostsold] = NULL WHERE [tickethostsold] = '';








DECLARE @MaxId INT = (SELECT MAX(ETL__ID) FROM stg.TM_AuditSummary)


WHILE @StartIndex <= @MaxId
BEGIN

SELECT ETL__Source
, CAST(HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),[auditarchticssold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[audithostsold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[avail])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[comp])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[diffarchticssold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[diffhostsold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[event])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[event_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([event_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[export_datetime])),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[groups])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[held])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[kill])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([parent_price_code]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_licfee])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other1])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other2])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other3])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other4])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other5])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other6])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other7])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_other8])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_tax])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[pc_ticket])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[PLAN])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([price_code]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([price_code_desc]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),[revenue])),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[ticketarchticssold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[ticketavailsold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[tickethostsold])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS) as binary(32)) ETL__DeltaHashKey
, TRY_CAST([auditarchticssold] AS DECIMAL(19,0)) [auditarchticssold], TRY_CAST([audithostsold] AS DECIMAL(19,0)) [audithostsold], TRY_CAST([avail] AS DECIMAL(19,0)) [avail], TRY_CAST([comp] AS DECIMAL(19,0)) [comp], TRY_CAST([diffarchticssold] AS DECIMAL(19,0)) [diffarchticssold], TRY_CAST([diffhostsold] AS DECIMAL(19,0)) [diffhostsold], TRY_CAST([event] AS DECIMAL(19,0)) [event], TRY_CAST([event_id] AS DECIMAL(19,0)) [event_id], [event_name], TRY_CAST([export_datetime] AS datetime) [export_datetime], TRY_CAST([groups] AS DECIMAL(19,0)) [groups], TRY_CAST([held] AS DECIMAL(19,0)) [held], TRY_CAST([kill] AS DECIMAL(19,0)) [kill], [parent_price_code], TRY_CAST([pc_licfee] AS decimal(18,6)) [pc_licfee], TRY_CAST([pc_other1] AS decimal(18,6)) [pc_other1], TRY_CAST([pc_other2] AS decimal(18,6)) [pc_other2], TRY_CAST([pc_other3] AS decimal(18,6)) [pc_other3], TRY_CAST([pc_other4] AS decimal(18,6)) [pc_other4], TRY_CAST([pc_other5] AS decimal(18,6)) [pc_other5], TRY_CAST([pc_other6] AS decimal(18,6)) [pc_other6], TRY_CAST([pc_other7] AS decimal(18,6)) [pc_other7], TRY_CAST([pc_other8] AS decimal(18,6)) [pc_other8], TRY_CAST([pc_tax] AS decimal(18,6)) [pc_tax], TRY_CAST([pc_ticket] AS decimal(18,6)) [pc_ticket], TRY_CAST([PLAN] AS DECIMAL(19,0)) [PLAN], [price_code], [price_code_desc], TRY_CAST([revenue] AS decimal(18,6)) [revenue], TRY_CAST([ticketarchticssold] AS DECIMAL(19,0)) [ticketarchticssold], TRY_CAST([ticketavailsold] AS DECIMAL(19,0)) [ticketavailsold], TRY_CAST([tickethostsold] AS DECIMAL(19,0)) [tickethostsold]
INTO #SrcData
FROM stg.TM_AuditSummary
WHERE ETL__ID BETWEEN @StartIndex AND @EndIndex

CREATE NONCLUSTERED INDEX IDX_Key ON #SrcData (event_id,price_code)
CREATE NONCLUSTERED INDEX IDX_ETL__DeltaHashKey ON #SrcData (ETL__DeltaHashKey)


TRUNCATE TABLE ods.TM_AuditSummary

MERGE ods.TM_AuditSummary AS t

USING #SrcData s
    
	ON t.[event_id] = s.[event_id] and t.[price_code] = s.[price_code]

WHEN MATCHED AND (
     ISNULL(s.[ETL__DeltaHashKey],-1) <> ISNULL(t.[HashKey], -1)
	 
)
THEN UPDATE SET
     t.[UpdateDate] = GETDATE()
     , t.[SourceFileName] = s.[ETL__Source]
     , t.[HashKey] = s.[ETL__DeltaHashKey]
     , t.[event_name] = s.[event_name]
     ,t.[parent_price_code] = s.[parent_price_code]
     ,t.[price_code_desc] = s.[price_code_desc]
     ,t.[PLAN] = s.[PLAN]
     ,t.[event] = s.[event]
     ,t.[groups] = s.[groups]
     ,t.[comp] = s.[comp]
     ,t.[held] = s.[held]
     ,t.[avail] = s.[avail]
     ,t.[kill] = s.[kill]
     ,t.[revenue] = s.[revenue]
     ,t.[price_code] = s.[price_code]
     ,t.[audithostsold] = s.[audithostsold]
     ,t.[auditarchticssold] = s.[auditarchticssold]
     ,t.[ticketarchticssold] = s.[ticketarchticssold]
     ,t.[tickethostsold] = s.[tickethostsold]
     ,t.[ticketavailsold] = s.[ticketavailsold]
     ,t.[diffhostsold] = s.[diffhostsold]
     ,t.[diffarchticssold] = s.[diffarchticssold]
     ,t.[event_id] = s.[event_id]
     ,t.[export_datetime] = s.[export_datetime]
     ,t.[pc_ticket] = s.[pc_ticket]
     ,t.[pc_tax] = s.[pc_tax]
     ,t.[pc_licfee] = s.[pc_licfee]
     ,t.[pc_other1] = s.[pc_other1]
     ,t.[pc_other2] = s.[pc_other2]
     ,t.[pc_other3] = s.[pc_other3]
     ,t.[pc_other4] = s.[pc_other4]
     ,t.[pc_other5] = s.[pc_other5]
     ,t.[pc_other6] = s.[pc_other6]
     ,t.[pc_other7] = s.[pc_other7]
     ,t.[pc_other8] = s.[pc_other8]
     

WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [InsertDate]
     , [UpdateDate]
     , [SourceFileName]
     , [HashKey]
	 , [event_name]
     ,[parent_price_code]
     ,[price_code_desc]
     ,[PLAN]
     ,[event]
     ,[groups]
     ,[comp]
     ,[held]
     ,[avail]
     ,[kill]
     ,[revenue]
     ,[price_code]
     ,[audithostsold]
     ,[auditarchticssold]
     ,[ticketarchticssold]
     ,[tickethostsold]
     ,[ticketavailsold]
     ,[diffhostsold]
     ,[diffarchticssold]
     ,[event_id]
     ,[export_datetime]
     ,[pc_ticket]
     ,[pc_tax]
     ,[pc_licfee]
     ,[pc_other1]
     ,[pc_other2]
     ,[pc_other3]
     ,[pc_other4]
     ,[pc_other5]
     ,[pc_other6]
     ,[pc_other7]
     ,[pc_other8]
     )
VALUES
     (
     GETDATE() --s.[InsertDate]
     , GETDATE() --s.[[UpdateDate]]
     , s.[ETL__Source]
     , s.[ETL__DeltaHashKey]
	 , s.[event_name]
     ,s.[parent_price_code]
     ,s.[price_code_desc]
     ,s.[PLAN]
     ,s.[event]
     ,s.[groups]
     ,s.[comp]
     ,s.[held]
     ,s.[avail]
     ,s.[kill]
     ,s.[revenue]
     ,s.[price_code]
     ,s.[audithostsold]
     ,s.[auditarchticssold]
     ,s.[ticketarchticssold]
     ,s.[tickethostsold]
     ,s.[ticketavailsold]
     ,s.[diffhostsold]
     ,s.[diffarchticssold]
     ,s.[event_id]
     ,s.[export_datetime]
     ,s.[pc_ticket]
     ,s.[pc_tax]
     ,s.[pc_licfee]
     ,s.[pc_other1]
     ,s.[pc_other2]
     ,s.[pc_other3]
     ,s.[pc_other4]
     ,s.[pc_other5]
     ,s.[pc_other6]
     ,s.[pc_other7]
     ,s.[pc_other8]
     )
;


DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH




END








GO
