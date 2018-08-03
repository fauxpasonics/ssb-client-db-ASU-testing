SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[TI_ReportBase_Load]
(
	@BatchId NVARCHAR(50) = null,
	@Client NVARCHAR(255) = null,
	@Options nvarchar(MAX) = NULL,
	@OptionsFormat nvarchar(50) = 'KeyValue'
)
AS 
BEGIN

SET @BatchId = ISNULL(@BatchId, NEWID())
SET @Client = COALESCE(@Client, [etl].[fnGetClientSetting]('ClientName'), DB_NAME())

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId

BEGIN TRY


DECLARE @CurrentReportBase INT = 1
DECLARE @SQL nvarchar(MAX) = ''


SELECT @CurrentReportBase = CASE WHEN definition LIKE '%dbo.TI_ReportBase1%' THEN 1 ELSE 2 END
FROM sys.sql_modules
WHERE OBJECT_ID = OBJECT_ID('dbo.vwTIReportBase')


IF (@CurrentReportBase = 1)
BEGIN

	IF EXISTS (SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID('dbo.TI_ReportBase2') AND name = 'IDX_CS_TI_ReportBase')
		DROP INDEX IDX_CS_TI_ReportBase ON dbo.TI_ReportBase2

	TRUNCATE TABLE dbo.TI_ReportBase2

	INSERT INTO dbo.TI_ReportBase2
			( SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE )
	EXEC etl.TI_ReportBase_Build

	CREATE CLUSTERED COLUMNSTORE INDEX IDX_CS_TI_ReportBase ON dbo.TI_ReportBase2

	SET @SQL = 'ALTER VIEW [dbo].[vwTIReportBase] AS (
		SELECT SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE 
		FROM dbo.TI_ReportBase2 (NOLOCK)
			UNION ALL
		SELECT SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE
		FROM dbo.TI_ReportBase_History (NOLOCK)
	)'

END

ELSE BEGIN

	IF EXISTS (SELECT * FROM sys.indexes WHERE OBJECT_ID = OBJECT_ID('dbo.TI_ReportBase1') AND name = 'IDX_CS_TI_ReportBase')
		DROP INDEX IDX_CS_TI_ReportBase ON dbo.TI_ReportBase1

	truncate table dbo.TI_ReportBase1

	INSERT INTO dbo.TI_ReportBase1
			( SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE )
	EXEC etl.TI_ReportBase_Build

	CREATE CLUSTERED COLUMNSTORE INDEX IDX_CS_TI_ReportBase ON dbo.TI_ReportBase1

	SET @SQL = 'ALTER VIEW [dbo].[vwTIReportBase] AS (
		SELECT SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE
		FROM dbo.TI_ReportBase1 (NOLOCK)
			UNION ALL
		SELECT SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE
		FROM dbo.TI_ReportBase_History (NOLOCK)
	)'

END

EXEC (@SQL)

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId



END



GO
