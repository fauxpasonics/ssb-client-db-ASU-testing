SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[ods_Load_TI_TK_ODET] 

AS
BEGIN 

DECLARE @RunTime datetime = getdate()

MERGE INTO ods.TI_TK_ODET AS myTarget
USING [etl].[vw_src_TI_TK_ODET] AS mySource
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
	, myTarget.ITEM = mySource.ITEM
	, myTarget.I_DATE = mySource.I_DATE
	, myTarget.I_OQTY = mySource.I_OQTY
	, myTarget.I_PT = mySource.I_PT
	, myTarget.I_PRICE = mySource.I_PRICE
	, myTarget.I_DISC = mySource.I_DISC
	, myTarget.I_DAMT = mySource.I_DAMT
	, myTarget.I_PAY_MODE = mySource.I_PAY_MODE
	, myTarget.ITEM_DELIVERY_ID = mySource.ITEM_DELIVERY_ID
	, myTarget.I_GCDOC = mySource.I_GCDOC
	, myTarget.I_PRQTY = mySource.I_PRQTY
	, myTarget.I_PL = mySource.I_PL
	, myTarget.I_BAL = mySource.I_BAL
	, myTarget.I_PAY = mySource.I_PAY
	, myTarget.I_PAYQ = mySource.I_PAYQ
	, myTarget.LOCATION_PREF = mySource.LOCATION_PREF
	, myTarget.I_SPECIAL = mySource.I_SPECIAL
	, myTarget.I_MARK = mySource.I_MARK
	, myTarget.I_DISP = mySource.I_DISP
	, myTarget.I_ACUST = mySource.I_ACUST
	, myTarget.I_PRI = mySource.I_PRI
	, myTarget.I_DMETH = mySource.I_DMETH
	, myTarget.I_FPRICE = mySource.I_FPRICE
	, myTarget.I_BPTYPE = mySource.I_BPTYPE
	, myTarget.PROMO = mySource.PROMO
	, myTarget.ITEM_PREF = mySource.ITEM_PREF
	, myTarget.TAG = mySource.TAG
	, myTarget.I_CHG = mySource.I_CHG
	, myTarget.I_CPRICE = mySource.I_CPRICE
	, myTarget.I_CPAY = mySource.I_CPAY
	, myTarget.I_FPAY = mySource.I_FPAY
	, myTarget.INREFSOURCE = mySource.INREFSOURCE
	, myTarget.INREFDATA = mySource.INREFDATA
	, myTarget.I_SCHG = mySource.I_SCHG
	, myTarget.I_SCAMT = mySource.I_SCAMT
	, myTarget.I_SCPAY = mySource.I_SCPAY
	, myTarget.ORIG_SALECODE = mySource.ORIG_SALECODE
	, myTarget.ORIGTS_USER = mySource.ORIGTS_USER
	, myTarget.ORIGTS_DATETIME = mySource.ORIGTS_DATETIME
	, myTarget.I_PKG = mySource.I_PKG
	, myTarget.E_SBLS_1 = mySource.E_SBLS_1
	, myTarget.LAST_USER = mySource.LAST_USER
	, myTarget.LAST_DATETIME = mySource.LAST_DATETIME
	, myTarget.ZID = mySource.ZID
	, myTarget.SOURCE_ID = mySource.SOURCE_ID

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
		, ITEM
		, I_DATE
		, I_OQTY
		, I_PT
		, I_PRICE
		, I_DISC
		, I_DAMT
		, I_PAY_MODE
		, ITEM_DELIVERY_ID
		, I_GCDOC
		, I_PRQTY
		, I_PL
		, I_BAL
		, I_PAY
		, I_PAYQ
		, LOCATION_PREF
		, I_SPECIAL
		, I_MARK
		, I_DISP
		, I_ACUST
		, I_PRI
		, I_DMETH
		, I_FPRICE
		, I_BPTYPE
		, PROMO
		, ITEM_PREF
		, TAG
		, I_CHG
		, I_CPRICE
		, I_CPAY
		, I_FPAY
		, INREFSOURCE
		, INREFDATA
		, I_SCHG
		, I_SCAMT
		, I_SCPAY
		, ORIG_SALECODE
		, ORIGTS_USER
		, ORIGTS_DATETIME
		, I_PKG
		, E_SBLS_1
		, LAST_USER
		, LAST_DATETIME
		, ZID
		, SOURCE_ID
	 				
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
		, mySource.ITEM
		, mySource.I_DATE
		, mySource.I_OQTY
		, mySource.I_PT
		, mySource.I_PRICE
		, mySource.I_DISC
		, mySource.I_DAMT
		, mySource.I_PAY_MODE
		, mySource.ITEM_DELIVERY_ID
		, mySource.I_GCDOC
		, mySource.I_PRQTY
		, mySource.I_PL
		, mySource.I_BAL
		, mySource.I_PAY
		, mySource.I_PAYQ
		, mySource.LOCATION_PREF
		, mySource.I_SPECIAL
		, mySource.I_MARK
		, mySource.I_DISP
		, mySource.I_ACUST
		, mySource.I_PRI
		, mySource.I_DMETH
		, mySource.I_FPRICE
		, mySource.I_BPTYPE
		, mySource.PROMO
		, mySource.ITEM_PREF
		, mySource.TAG
		, mySource.I_CHG
		, mySource.I_CPRICE
		, mySource.I_CPAY
		, mySource.I_FPAY
		, mySource.INREFSOURCE
		, mySource.INREFDATA
		, mySource.I_SCHG
		, mySource.I_SCAMT
		, mySource.I_SCPAY
		, mySource.ORIG_SALECODE
		, mySource.ORIGTS_USER
		, mySource.ORIGTS_DATETIME
		, mySource.I_PKG
		, mySource.E_SBLS_1
		, mySource.LAST_USER
		, mySource.LAST_DATETIME
		, mySource.ZID
		, mySource.SOURCE_ID

	)
;

END 
GO
