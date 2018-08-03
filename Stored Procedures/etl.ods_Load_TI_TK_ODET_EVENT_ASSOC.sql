SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ods_Load_TI_TK_ODET_EVENT_ASSOC] 

AS
BEGIN 

	DECLARE @RunTime datetime = getdate()

	MERGE INTO ods.TI_TK_ODET_EVENT_ASSOC AS myTarget
	USING [etl].[vw_src_TI_TK_ODET_EVENT_ASSOC] AS mySource
	ON myTarget.SEASON = mySource.SEASON
		AND myTarget.ZID = mySource.ZID
	WHEN MATCHED 
	AND 
	(
		ISNULL(mySource.ETL_DeltaHashKey,-1) <> isnull(myTarget.ETL_DeltaHashKey, -1) )
	THEN 
	UPDATE SET
		myTarget.ETL_DeltaHashKey = mySource.ETL_DeltaHashKey
		, myTarget.ETL_UpdatedDate = @RunTime
		, myTarget.ETL_DeletedDate = null
		, myTarget.ETL_IsDeleted = 0

		, myTarget.EXPORT_DATETIME = mySource.EXPORT_DATETIME
		, myTarget.SEASON = mySource.SEASON
		, myTarget.CUSTOMER = mySource.CUSTOMER
		, myTarget.SEQ = mySource.SEQ
		, myTarget.ZID = mySource.ZID
		, myTarget.SOURCE_ID = mySource.SOURCE_ID
		, myTarget.VMC = mySource.VMC
		, myTarget.EVENT = mySource.EVENT
		, myTarget.E_PL = mySource.E_PL
		, myTarget.E_PRICE = mySource.E_PRICE
		, myTarget.E_DAMT = mySource.E_DAMT
		, myTarget.E_STAT = mySource.E_STAT
		, myTarget.E_PQTY = mySource.E_PQTY
		, myTarget.E_ADATE = mySource.E_ADATE
		, myTarget.E_SBLS = mySource.E_SBLS
		, myTarget.E_CPRICE = mySource.E_CPRICE
		, myTarget.E_FEE = mySource.E_FEE
		, myTarget.E_FPRICE = mySource.E_FPRICE
		, myTarget.E_SCAMT = mySource.E_SCAMT

	WHEN NOT MATCHED BY Target THEN
		INSERT 
		( 		
			ETL_CreatedDate
			, ETL_UpdatedDate
			, ETL_IsDeleted
			, ETL_DeletedDate
			, ETL_DeltaHashKey
		
			, EXPORT_DATETIME
			, SEASON
			, CUSTOMER
			, SEQ
			, ZID
			, SOURCE_ID
			, VMC
			, EVENT
			, E_PL
			, E_PRICE
			, E_DAMT
			, E_STAT
			, E_PQTY
			, E_ADATE
			, E_SBLS
			, E_CPRICE
			, E_FEE
			, E_FPRICE
			, E_SCAMT			
		)
		VALUES
		(
			@RunTime --ETL_CreatedDate
			, @RunTime --ETL_UpdatedDate
			, 0 --ETL_IsDeleted
			, null --ETL_DeleteDate
			, mySource.ETL_DeltaHashKey	
			
			, mySource.EXPORT_DATETIME
			, mySource.SEASON
			, mySource.CUSTOMER
			, mySource.SEQ
			, mySource.ZID
			, mySource.SOURCE_ID
			, mySource.VMC
			, mySource.EVENT
			, mySource.E_PL
			, mySource.E_PRICE
			, mySource.E_DAMT
			, mySource.E_STAT
			, mySource.E_PQTY
			, mySource.E_ADATE
			, mySource.E_SBLS
			, mySource.E_CPRICE
			, mySource.E_FEE
			, mySource.E_FPRICE
			, mySource.E_SCAMT
		)
	;

END 
GO
