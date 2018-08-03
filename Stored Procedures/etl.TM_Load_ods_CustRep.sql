SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_Load_ods_CustRep]
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
DECLARE @EventSource nvarchar(255) = 'TM_Load_ods_CustRep'
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.TM_CustRep),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting('ClientName'), DB_NAME()));

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)



INSERT INTO archive.TM_CustRep
(
	ETL__CreatedDate, ETL__Source, ETL__BatchId, ETL__ExecutionId
	,  [acct_id], [acct_rep_id], [acct_rep_type], [acct_rep_type_name], [rep_cust_name_id], [rep_name_first], [rep_name_middle], [rep_name_last], [rep_name_title], [rep_company_name], [rep_nick_name], [rep_name_last_first_mi], [rep_full_name], [rep_user_id], [rep_email_addr], [rep_phone], [rep_phone_formatted], [seq_num]
)

SELECT 
GETDATE() ETL__CreatedDate, ETL__Source
, @BatchId ETL__BatchId, @ExecutionId ETL__ExecutionId
,  [acct_id], [acct_rep_id], [acct_rep_type], [acct_rep_type_name], [rep_cust_name_id], [rep_name_first], [rep_name_middle], [rep_name_last], [rep_name_title], [rep_company_name], [rep_nick_name], [rep_name_last_first_mi], [rep_full_name], [rep_user_id], [rep_email_addr], [rep_phone], [rep_phone_formatted], [seq_num]
FROM stg.TM_CustRep



DECLARE @RecordCount INT = (SELECT COUNT(*) FROM stg.TM_CustRep)
DECLARE @StartIndex INT = 1, @PageCount INT = 25000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)



IF EXISTS (
	SELECT COUNT(*)
	FROM stg.TM_CustRep
	GROUP BY acct_id, acct_rep_id, acct_rep_type
	HAVING COUNT(*) > 1
)
BEGIN 
	DELETE a
	FROM stg.TM_CustRep a
	INNER JOIN (
	SELECT ETL__ID
	, ROW_NUMBER() OVER(PARTITION BY acct_id, acct_rep_id, acct_rep_type ORDER BY ETL__ID) RowRank
	FROM stg.TM_CustRep
	) b ON a.ETL__ID = b.ETL__ID
	WHERE b.RowRank > 1
END

UPDATE stg.TM_CustRep SET acct_id = NULL WHERE acct_id = '';

UPDATE stg.TM_CustRep SET acct_rep_id = NULL WHERE acct_rep_id = '';

UPDATE stg.TM_CustRep SET rep_cust_name_id = NULL WHERE rep_cust_name_id = '';


SELECT t.id, t.InsertDate, t.UpdatedDate, t.SourceFileName, t.acct_id, t.acct_rep_id, t.acct_rep_type, t.acct_rep_type_name, t.rep_cust_name_id,
       t.rep_name_first, t.rep_name_middle, t.rep_name_last, t.rep_name_title, t.rep_company_name, t.rep_nick_name, t.rep_name_last_first_mi, t.rep_full_name,
       t.rep_user_id, t.rep_email_addr, t.rep_phone, t.rep_phone_formatted
INTO #ToDelete
FROM ods.TM_CustRep t
INNER JOIN (
	SELECT DISTINCT acct_id
	FROM stg.TM_CustRep
) p ON t.acct_id = p.acct_id
LEFT OUTER JOIN (
	SELECT CAST(1 AS BIT) ForceExists, acct_id, acct_rep_id, acct_rep_type
	FROM stg.TM_CustRep 
) s ON t.[acct_id] = s.[acct_id] and t.[acct_rep_id] = s.[acct_rep_id] and t.[acct_rep_type] = s.[acct_rep_type]
WHERE s.ForceExists IS NULL


INSERT INTO etl.TM_DeleteLog ( ETL__CreatedDate, SourceTable, RowDataXML )
SELECT GETDATE() ETL__CreatedDate, 'ods.TM_CustRep' SourceTable
, (SELECT a.* FOR XML RAW)
FROM #ToDelete a


DELETE t
FROM ods.TM_CustRep t
INNER JOIN #ToDelete s ON t.[acct_id] = s.[acct_id] and t.[acct_rep_id] = s.[acct_rep_id] and t.[acct_rep_type] = s.[acct_rep_type]



DECLARE @MaxId INT = (SELECT MAX(ETL__ID) FROM stg.TM_CustRep)


WHILE @StartIndex <= @MaxId
BEGIN

SELECT ETL__Source
, CAST(HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),[acct_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[acct_rep_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([acct_rep_type]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([acct_rep_type_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_company_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[rep_cust_name_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_email_addr]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_full_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_name_first]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_name_last]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_name_last_first_mi]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_name_middle]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_name_title]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_nick_name]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_phone]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_phone_formatted]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([rep_user_id]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS) as binary(32)) ETL__DeltaHashKey
, TRY_CAST([acct_id] AS DECIMAL(19,0)) [acct_id], TRY_CAST([acct_rep_id] AS DECIMAL(19,0)) [acct_rep_id], [acct_rep_type], [acct_rep_type_name], TRY_CAST([rep_cust_name_id] AS DECIMAL(19,0)) [rep_cust_name_id], [rep_name_first], [rep_name_middle], [rep_name_last], [rep_name_title], [rep_company_name], [rep_nick_name], [rep_name_last_first_mi], [rep_full_name], [rep_user_id], [rep_email_addr], [rep_phone], [rep_phone_formatted]
INTO #SrcData
FROM stg.TM_CustRep
WHERE ETL__ID BETWEEN @StartIndex AND @EndIndex

CREATE NONCLUSTERED INDEX IDX_Key ON #SrcData (acct_id, acct_rep_id, acct_rep_type)
CREATE NONCLUSTERED INDEX IDX_ETL__DeltaHashKey ON #SrcData (ETL__DeltaHashKey)


MERGE ods.TM_CustRep AS t

USING #SrcData s
    
	ON t.[acct_id] = s.[acct_id] and t.[acct_rep_id] = s.[acct_rep_id] and t.[acct_rep_type] = s.[acct_rep_type]

WHEN MATCHED AND (
     ISNULL(s.[ETL__DeltaHashKey],-1) <> ISNULL(t.[HashKey], -1)
	 
)
THEN UPDATE SET
     t.[UpdatedDate] = GETDATE()
     , t.[SourceFileName] = s.[ETL__Source]
     , t.[HashKey] = s.[ETL__DeltaHashKey]
     , t.[acct_id] = s.[acct_id]
     ,t.[acct_rep_id] = s.[acct_rep_id]
     ,t.[acct_rep_type] = s.[acct_rep_type]
     ,t.[acct_rep_type_name] = s.[acct_rep_type_name]
     ,t.[rep_cust_name_id] = s.[rep_cust_name_id]
     ,t.[rep_name_first] = s.[rep_name_first]
     ,t.[rep_name_middle] = s.[rep_name_middle]
     ,t.[rep_name_last] = s.[rep_name_last]
     ,t.[rep_name_title] = s.[rep_name_title]
     ,t.[rep_company_name] = s.[rep_company_name]
     ,t.[rep_nick_name] = s.[rep_nick_name]
     ,t.[rep_name_last_first_mi] = s.[rep_name_last_first_mi]
     ,t.[rep_full_name] = s.[rep_full_name]
     ,t.[rep_user_id] = s.[rep_user_id]
     ,t.[rep_email_addr] = s.[rep_email_addr]
     ,t.[rep_phone] = s.[rep_phone]
     ,t.[rep_phone_formatted] = s.[rep_phone_formatted]
     

WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [InsertDate]
     , [UpdatedDate]
     , [SourceFileName]
     , [HashKey]
	 , [acct_id]
     ,[acct_rep_id]
     ,[acct_rep_type]
     ,[acct_rep_type_name]
     ,[rep_cust_name_id]
     ,[rep_name_first]
     ,[rep_name_middle]
     ,[rep_name_last]
     ,[rep_name_title]
     ,[rep_company_name]
     ,[rep_nick_name]
     ,[rep_name_last_first_mi]
     ,[rep_full_name]
     ,[rep_user_id]
     ,[rep_email_addr]
     ,[rep_phone]
     ,[rep_phone_formatted]
     )
VALUES
     (
     GETDATE() --s.[InsertDate]
     , GETDATE() --s.[[UpdatedDate]]
     , s.[ETL__Source]
     , s.[ETL__DeltaHashKey]
	 , s.[acct_id]
     ,s.[acct_rep_id]
     ,s.[acct_rep_type]
     ,s.[acct_rep_type_name]
     ,s.[rep_cust_name_id]
     ,s.[rep_name_first]
     ,s.[rep_name_middle]
     ,s.[rep_name_last]
     ,s.[rep_name_title]
     ,s.[rep_company_name]
     ,s.[rep_nick_name]
     ,s.[rep_name_last_first_mi]
     ,s.[rep_full_name]
     ,s.[rep_user_id]
     ,s.[rep_email_addr]
     ,s.[rep_phone]
     ,s.[rep_phone_formatted]
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
