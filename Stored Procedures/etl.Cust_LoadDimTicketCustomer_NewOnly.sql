SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Cust_LoadDimTicketCustomer_NewOnly]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(max) = NULL
)

AS 
BEGIN

DECLARE @RunTime DATETIME = GETDATE()

--DECLARE @BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000';
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = 'ProcessStandardMerge_dbo.DimTicketCustomer'
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM etl.vw_Load_DimTicketCustomer),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting('ClientName'), DB_NAME()));

/*Load Options into a temp table*/
--SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

--DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId


--SELECT ROW_NUMBER() OVER(ORDER BY ETL__SSID_PATRON) RowIndex
--, * 
--INTO #data
--FROM etl.vw_Load_DimTicketCustomer

SELECT ROW_NUMBER() OVER(ORDER BY s.ETL__SSID_PATRON) RowIndex
, s.* 
INTO #data
FROM etl.vw_Load_DimTicketCustomer s
LEFT OUTER JOIN dbo.DimTicketCustomer t ON s.ETL__SSID_PATRON = t.ETL__SSID_PATRON
WHERE t.DimTicketCustomerId IS null

CREATE NONCLUSTERED INDEX IDX_RowIndex ON #data (RowIndex)

DECLARE @RecordCount INT = (SELECT COUNT(*) FROM #data)
DECLARE @StartIndex INT = 1, @PageCount INT = 25000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)

WHILE @StartIndex <= @RecordCount
BEGIN

SELECT CAST(NULL AS BINARY(32)) ETL__DeltaHashKey
,  ETL__SourceSystem, ETL__SSID, ETL__SSID_PATRON, DimRepId, IsCompany, CompanyName, FullName, Prefix, FirstName, MiddleName, LastName, Suffix, TicketCustomerClass, Status, CustomerId, VIPCode, IsVIP, Tag, AccountType, Keywords, Gender, AddDateTime, SinceDate, Birthday, Email, Phone, AddressStreet1, AddressStreet2, AddressCity, AddressState, AddressZip, AddressCountry
INTO #SrcData
FROM #data
WHERE RowIndex BETWEEN @StartIndex AND @EndIndex

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL__DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AccountType),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),AddDateTime)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AddressCity)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AddressCountry)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AddressState)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AddressStreet1)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AddressStreet2)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AddressZip)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),Birthday)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CompanyName),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CustomerId),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),DimRepId)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(Email),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),FirstName)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(FullName),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(Gender),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),IsCompany)),'DBNULL_BIT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),IsVIP)),'DBNULL_BIT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),LastName)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),MiddleName)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),Phone)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),Prefix)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),SinceDate)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(Status),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(Suffix),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TicketCustomerClass),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(VIPCode),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ETL__SSID_PATRON)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.DimTicketCustomer AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ETL__SSID_PATRON = mySource.ETL__SSID_PATRON

WHEN MATCHED AND (
     ISNULL(mySource.ETL__DeltaHashKey,-1) <> ISNULL(myTarget.ETL__DeltaHashKey, -1)
	 OR ISNULL(mySource.Tag,'') <> ISNULL(myTarget.Tag,'') OR ISNULL(mySource.Keywords,'') <> ISNULL(myTarget.Keywords,'') 
)
THEN UPDATE SET
	ETL__EndDate = @RunTime
WHEN NOT MATCHED BY Target
THEN INSERT
     (
		ETL__CreatedBy
		, ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 , [ETL__SourceSystem]
     , [ETL__SSID]
     , [ETL__SSID_PATRON]
     , [DimRepId]
     , [IsCompany]
     , [CompanyName]
     , [FullName]
     , [Prefix]
     , [FirstName]
     , [MiddleName]
     , [LastName]
     , [Suffix]
     , [TicketCustomerClass]
     , [Status]
     , [CustomerId]
     , [VIPCode]
     , [IsVIP]
     , [Tag]
     , [AccountType]
     , [Keywords]
     , [Gender]
     , [AddDateTime]
     , [SinceDate]
     , [Birthday]
     , [Email]
     , [Phone]
     , [AddressStreet1]
     , [AddressStreet2]
     , [AddressCity]
     , [AddressState]
     , [AddressZip]
     , [AddressCountry]
     )
VALUES
     (
		SUSER_NAME() --ETL__CreatedBy
		, GETDATE() --ETL__CreatedDate
		, @RunTime	--ETL__StartDate
		, mySource.ETL__DeltaHashKey	
	 , mySource.[ETL__SourceSystem]
     , mySource.[ETL__SSID]
     , mySource.[ETL__SSID_PATRON]
     , mySource.[DimRepId]
     , mySource.[IsCompany]
     , mySource.[CompanyName]
     , mySource.[FullName]
     , mySource.[Prefix]
     , mySource.[FirstName]
     , mySource.[MiddleName]
     , mySource.[LastName]
     , mySource.[Suffix]
     , mySource.[TicketCustomerClass]
     , mySource.[Status]
     , mySource.[CustomerId]
     , mySource.[VIPCode]
     , mySource.[IsVIP]
     , mySource.[Tag]
     , mySource.[AccountType]
     , mySource.[Keywords]
     , mySource.[Gender]
     , mySource.[AddDateTime]
     , mySource.[SinceDate]
     , mySource.[Birthday]
     , mySource.[Email]
     , mySource.[Phone]
     , mySource.[AddressStreet1]
     , mySource.[AddressStreet2]
     , mySource.[AddressCity]
     , mySource.[AddressState]
     , mySource.[AddressZip]
     , mySource.[AddressCountry]
     )
;

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

INSERT INTO dbo.DimTicketCustomer (
		ETL__CreatedBy
		, ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 , [ETL__SourceSystem]
     , [ETL__SSID]
     , [ETL__SSID_PATRON]
     , [DimRepId]
     , [IsCompany]
     , [CompanyName]
     , [FullName]
     , [Prefix]
     , [FirstName]
     , [MiddleName]
     , [LastName]
     , [Suffix]
     , [TicketCustomerClass]
     , [Status]
     , [CustomerId]
     , [VIPCode]
     , [IsVIP]
     , [Tag]
     , [AccountType]
     , [Keywords]
     , [Gender]
     , [AddDateTime]
     , [SinceDate]
     , [Birthday]
     , [Email]
     , [Phone]
     , [AddressStreet1]
     , [AddressStreet2]
     , [AddressCity]
     , [AddressState]
     , [AddressZip]
     , [AddressCountry]
     )

SELECT 
	SUSER_NAME() --ETL__CreatedBy
	, GETDATE() --ETL__CreatedDate
	, @RunTime	--ETL__StartDate
	, mySource.*
FROM #SrcData mySource
INNER JOIN dbo.DimTicketCustomer myTarget ON myTarget.ETL__SSID_PATRON = mySource.ETL__SSID_PATRON
WHERE myTarget.ETL__EndDate = @RunTime


DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop


DROP TABLE #data

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Error', @EventSource, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

END
GO
