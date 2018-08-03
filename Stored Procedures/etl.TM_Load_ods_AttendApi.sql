SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_Load_ods_AttendApi]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000',
	@Target VARCHAR(256) = null,
	@Source VARCHAR(256) = null,
	@BusinessKey VARCHAR(256) = null,
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


--DECLARE @BatchId NVARCHAR(50) = '7415b0eb-b593-49ca-ab00-092b93a10d9d';
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = 'TM_Load_ods_AttendApi'
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.TM_AttendApi),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting('ClientName'), DB_NAME()));

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)



INSERT INTO archive.TM_AttendApi
(
	ETL__CreatedDate, ETL__Source, ETL__BatchId, ETL__ExecutionId
	,  [event_id], [event_name], [event_date], [section_id], [section_name], [row_id], [row_name], [seat_num], [acct_id], [plan_event_Id], [plan_event_name], [print_count], [ticket_type], [scan_type], [result_code], [action_time], [gate], [price_code], [comp], [result_type], [valid], [ticket_acct_id], [source_system], [access_type], [channel_ind], [mobile], [seq_num]
)

SELECT 
GETDATE() ETL__CreatedDate, ETL__Source
, @BatchId ETL__BatchId, @ExecutionId ETL__ExecutionId
,  [event_id], [event_name], [event_date], [section_id], [section_name], [row_id], [row_name], [seat_num], [acct_id], [plan_event_Id], [plan_event_name], [print_count], [ticket_type], [scan_type], [result_code], [action_time], [gate], [price_code], [comp], [result_type], [valid], [ticket_acct_id], [source_system], [access_type], [channel_ind], [mobile], [seq_num]
FROM stg.TM_AttendApi



DECLARE @RecordCount INT = (SELECT COUNT(*) FROM stg.TM_AttendApi)
DECLARE @StartIndex INT = 1, @PageCount INT = 25000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)



IF EXISTS (
	SELECT COUNT(*)
	FROM stg.TM_AttendApi
	GROUP BY event_id, section_id, row_id, seat_num, result_code
	HAVING COUNT(*) > 1
)
BEGIN 
	DELETE a
	FROM stg.TM_AttendApi a
	INNER JOIN (
	SELECT ETL__ID
	, ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num, result_code ORDER BY ETL__ID) RowRank
	FROM stg.TM_AttendApi
	) b ON a.ETL__ID = b.ETL__ID
	WHERE b.RowRank > 1
END


UPDATE stg.TM_AttendApi SET acct_id = NULL WHERE acct_id = '';

UPDATE stg.TM_AttendApi SET event_date = NULL WHERE event_date = '';

UPDATE stg.TM_AttendApi SET event_id = NULL WHERE event_id = '';

UPDATE stg.TM_AttendApi SET mobile = NULL WHERE mobile = '';

UPDATE stg.TM_AttendApi SET plan_event_Id = NULL WHERE plan_event_Id = '';

UPDATE stg.TM_AttendApi SET print_count = NULL WHERE print_count = '';

UPDATE stg.TM_AttendApi SET result_code = NULL WHERE result_code = '';

UPDATE stg.TM_AttendApi SET row_id = NULL WHERE row_id = '';

UPDATE stg.TM_AttendApi SET seat_num = NULL WHERE seat_num = '';

UPDATE stg.TM_AttendApi SET section_id = NULL WHERE section_id = '';

UPDATE stg.TM_AttendApi SET ticket_acct_id = NULL WHERE ticket_acct_id = '';

UPDATE stg.TM_AttendApi SET upd_datetime = NULL WHERE upd_datetime = '';


DECLARE @MaxId INT = (SELECT MAX(ETL__ID) FROM stg.TM_AttendApi)


WHILE @StartIndex <= @MaxId
BEGIN

SELECT ETL__Source
, CAST(HASHBYTES('sha2_256', ISNULL(RTRIM([access_type]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[acct_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([action_time]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([channel_ind]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([comp]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[event_date],112)),'DBNULL_DATE') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[event_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([event_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([gate]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[mobile])),'DBNULL_BIT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[plan_event_Id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([plan_event_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([price_code]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[print_count])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[result_code])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([result_type]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[row_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([row_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([scan_type]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[seat_num])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[section_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([section_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([source_system]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[ticket_acct_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([ticket_type]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([valid]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS) as binary(32)) ETL__DeltaHashKey
, [access_type], TRY_CAST([acct_id] AS DECIMAL(19,0)) [acct_id], [action_time], [channel_ind], [comp], TRY_CAST([event_date] AS date) [event_date], TRY_CAST([event_id] AS DECIMAL(19,0)) [event_id], [event_name], [gate], TRY_CAST([mobile] AS bit) [mobile], TRY_CAST([plan_event_Id] AS DECIMAL(19,0)) [plan_event_Id], [plan_event_name], [price_code], TRY_CAST([print_count] AS DECIMAL(19,0)) [print_count], TRY_CAST([result_code] AS DECIMAL(19,0)) [result_code], [result_type], TRY_CAST([row_id] AS DECIMAL(19,0)) [row_id], [row_name], [scan_type], TRY_CAST([seat_num] AS DECIMAL(19,0)) [seat_num], TRY_CAST([section_id] AS DECIMAL(19,0)) [section_id], [section_name], [source_system], TRY_CAST([ticket_acct_id] AS DECIMAL(19,0)) [ticket_acct_id], [ticket_type], [valid]
INTO #SrcData
FROM stg.TM_AttendApi
WHERE ETL__ID BETWEEN @StartIndex AND @EndIndex

CREATE NONCLUSTERED INDEX IDX_Key ON #SrcData (event_id, section_id, row_id, seat_num, result_code)
CREATE NONCLUSTERED INDEX IDX_ETL__DeltaHashKey ON #SrcData (ETL__DeltaHashKey)


MERGE ods.TM_AttendApi AS t

USING #SrcData s
    
	ON t.[event_id] = s.[event_id] and t.[section_id] = s.[section_id] and t.[row_id] = s.[row_id] and t.[seat_num] = s.[seat_num] and t.[result_code] = s.[result_code]

WHEN MATCHED AND (
     ISNULL(s.[ETL__DeltaHashKey],-1) <> ISNULL(t.[ETL__DeltaHashKey], -1)
	 
)
THEN UPDATE SET
     t.[ETL__UpdatedDate] = GETDATE()
     , t.[ETL_Source] = s.[ETL__Source]
     , t.[ETL__DeltaHashKey] = s.[ETL__DeltaHashKey]
     , t.[event_id] = s.[event_id]
     ,t.[event_name] = s.[event_name]
     ,t.[event_date] = s.[event_date]
     ,t.[section_id] = s.[section_id]
     ,t.[section_name] = s.[section_name]
     ,t.[row_id] = s.[row_id]
     ,t.[row_name] = s.[row_name]
     ,t.[seat_num] = s.[seat_num]
     ,t.[acct_id] = s.[acct_id]
     ,t.[plan_event_Id] = s.[plan_event_Id]
     ,t.[plan_event_name] = s.[plan_event_name]
     ,t.[print_count] = s.[print_count]
     ,t.[ticket_type] = s.[ticket_type]
     ,t.[scan_type] = s.[scan_type]
     ,t.[result_code] = s.[result_code]
     ,t.[action_time] = s.[action_time]
     ,t.[gate] = s.[gate]
     ,t.[price_code] = s.[price_code]
     ,t.[comp] = s.[comp]
     ,t.[result_type] = s.[result_type]
     ,t.[valid] = s.[valid]
     ,t.[ticket_acct_id] = s.[ticket_acct_id]
     ,t.[source_system] = s.[source_system]
     ,t.[access_type] = s.[access_type]
     ,t.[channel_ind] = s.[channel_ind]
     ,t.[mobile] = s.[mobile]
     

WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [ETL__CreatedDate]
     ,[ETL__UpdatedDate]
     ,[ETL_Source]
     ,[ETL__DeltaHashKey]
	 ,[event_id]
     ,[event_name]
     ,[event_date]
     ,[section_id]
     ,[section_name]
     ,[row_id]
     ,[row_name]
     ,[seat_num]
     ,[acct_id]
     ,[plan_event_Id]
     ,[plan_event_name]
     ,[print_count]
     ,[ticket_type]
     ,[scan_type]
     ,[result_code]
     ,[action_time]
     ,[gate]
     ,[price_code]
     ,[comp]
     ,[result_type]
     ,[valid]
     ,[ticket_acct_id]
     ,[source_system]
     ,[access_type]
     ,[channel_ind]
     ,[mobile]
     )
VALUES
     (
     GETDATE() --[ETL__CreatedDate]
     , GETDATE() --[ETL__UpdatedDate]
     , s.[ETL__Source]
     , s.[ETL__DeltaHashKey]
	 , s.[event_id]
     ,s.[event_name]
     ,s.[event_date]
     ,s.[section_id]
     ,s.[section_name]
     ,s.[row_id]
     ,s.[row_name]
     ,s.[seat_num]
     ,s.[acct_id]
     ,s.[plan_event_Id]
     ,s.[plan_event_name]
     ,s.[print_count]
     ,s.[ticket_type]
     ,s.[scan_type]
     ,s.[result_code]
     ,s.[action_time]
     ,s.[gate]
     ,s.[price_code]
     ,s.[comp]
     ,s.[result_type]
     ,s.[valid]
     ,s.[ticket_acct_id]
     ,s.[source_system]
     ,s.[access_type]
     ,s.[channel_ind]
     ,s.[mobile]
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
