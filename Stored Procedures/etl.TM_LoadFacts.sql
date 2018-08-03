SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadFacts]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN

	SELECT 'Start...', GETDATE() ts
	
	EXEC etl.TM_FactTicketSales_DeleteReturns @BatchId = @BatchId, @Options = @Options

	SELECT 'Step 2...', GETDATE() ts
	
	EXEC etl.TM_Stage_FactTicketSales @BatchId = @BatchId, @Options = @Options

	SELECT 'Step 3...', GETDATE() ts

	EXEC etl.Cust_FactTicketSalesProcessing @BatchId = @BatchId, @Options = @Options

	SELECT 'Step 4...', GETDATE() ts	

	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170730] @BatchId = '00000000-0000-0000-0000-000000000000', @Target = 'etl.vw_FactTicketSales', @Source = 'etl.vw_Load_TM_FactTicketSales', @BusinessKey = 'ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num', @SourceSystem = 'TM'
	--, @Options = @Options

	SELECT 'Step 5...', GETDATE() ts	

	
	EXEC [etl].[TM_Stage_FactTicketActivity]

	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170730] @BatchId = '00000000-0000-0000-0000-000000000000', @Target = 'etl.vw_FactTicketActivity', @Source = 'etl.vw_Load_TM_FactTicketActivity'
	, @BusinessKey = 'ETL__SSID_TM_ods_id', @SourceSystem = 'TM'

	EXEC [etl].[TM_Stage_FactHeldSeats] 

	DELETE t
	FROM etl.vw_FactHeldSeats t
	LEFT OUTER JOIN ods.TM_HeldSeats s ON t.ETL__SSID_TM_ods_id = s.id
	WHERE s.id IS NULL

	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170730] @BatchId = '00000000-0000-0000-0000-000000000000', @Target = 'etl.vw_FactHeldSeats', @Source = 'etl.vw_Load_TM_FactHeldSeats'
	, @BusinessKey = 'ETL__SSID_TM_ods_id', @SourceSystem = 'TM'




	EXEC [etl].[TM_Stage_FactAvailSeats]

	DELETE t
	FROM etl.vw_FactAvailSeats t
	LEFT OUTER JOIN ods.TM_AvailSeats s ON t.ETL__SSID_TM_ods_id = s.id
	WHERE s.id IS NULL

	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170730] @BatchId = '00000000-0000-0000-0000-000000000000', @Target = 'etl.vw_FactAvailSeats', @Source = 'etl.vw_Load_TM_FactAvailSeats'
	, @BusinessKey = 'ETL__SSID_TM_ods_id', @SourceSystem = 'TM'


	--EXEC etl.TM_LoadFactInventory_Seats

	SELECT 'Step 6...', GETDATE() ts

	EXEC etl.TM_LoadFactInventory_Held --@BatchId = @BatchId, @Options = @Options

	EXEC etl.TM_LoadFactInventory_Avail	--@BatchId = @BatchId, @Options = @Options

	EXEC etl.TM_LoadFactInventory_Sales

	SELECT 'Step 7...', GETDATE() ts

	EXEC etl.TM_LoadFactInventory_Resold --@BatchId = @BatchId, @Options = @Options

	

	EXEC etl.TM_LoadFactInventory_Tranferred --@BatchId = @BatchId, @Options = @Options

	SELECT 'Step 8...', GETDATE() ts

	

	SELECT 'Step 9...', GETDATE() ts



	EXEC etl.TM_LoadFactAttendance @BatchId = @BatchId, @Options = @Options

	SELECT 'Step 10...', GETDATE() ts

END












GO
