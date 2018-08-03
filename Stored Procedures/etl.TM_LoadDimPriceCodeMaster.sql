SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_LoadDimPriceCodeMaster] 

as
BEGIN

	CREATE TABLE #NewPriceCodes (PriceCode NVARCHAR(4))

	INSERT INTO #NewPriceCodes (PriceCode)
	
	SELECT PriceCode
	FROM (		
		SELECT DISTINCT price_code PriceCode
		FROM ods.TM_PriceCode

			UNION

		SELECT DISTINCT REPLACE(price_code, '*', '') PriceCode
		FROM ods.TM_Ticket

			UNION

		SELECT DISTINCT REPLACE(price_code, '*', '') PriceCode
		FROM ods.TM_AvailSeats

			UNION

		SELECT DISTINCT REPLACE(price_code, '*', '') PriceCode
		FROM ods.TM_HeldSeats

	) a

	EXCEPT 

	SELECT DISTINCT PriceCode
	FROM etl.vw_DimPriceCode
	WHERE ETL__SourceSystem = 'TM' AND ETL__SSID_TM_event_id IS NULL


	INSERT INTO etl.vw_DimPriceCode ([ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__SSID], [ETL__SSID_TM_price_code], priceCode, PC1, PC2, PC3, PC4)

	SELECT 'TM' [ETL__SourceSystem], GETDATE() [ETL__CreatedDate], GETDATE() [ETL__UpdatedDate], 0, PriceCode [ETL__SSID], PriceCode [ETL__SSID_TM_price_code]

	, PriceCode
	, CASE WHEN LEN(PriceCode) >= 1 THEN  SUBSTRING(PriceCode,1,1) END AS PC1
	, CASE WHEN LEN(PriceCode) >= 2 THEN  SUBSTRING(PriceCode,2,1) END AS PC2
	, CASE WHEN LEN(PriceCode) >= 3 THEN  SUBSTRING(PriceCode,3,1) END AS PC3
	, CASE WHEN LEN(PriceCode) >= 4 THEN  SUBSTRING(PriceCode,4,1) END AS PC4
	FROM #NewPriceCodes


END




GO
