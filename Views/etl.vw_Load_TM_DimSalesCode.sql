SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimSalesCode] AS (

	SELECT  
		sc.sell_location_id AS ETL__SSID
		, sc.sell_location_id AS ETL__SSID_TM_Sell_Location_Id
		, CAST(sc.sell_location_code AS NVARCHAR(50)) AS SalesCode
		, CAST(sc.sell_location_name AS NVARCHAR(200)) AS SalesCodeName
		, CAST(sc.sell_location_desc AS NVARCHAR(500)) AS SalesCodeDesc
		, CAST(NULL AS NVARCHAR(50))  SalesCodeClass

		, sc.[outlet_code] [TM_outlet_code]
		, sc.[active] [TM_active]
		, sc.[protected] [TM_protected]
		, sc.[sort_order] [TM_sort_order]

	--SELECT *
	FROM ods.TM_SellLocation sc (NOLOCK) 

)




GO
