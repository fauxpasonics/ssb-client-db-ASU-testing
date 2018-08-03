SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_Load_PAC_DimSeatStatus] AS (

	SELECT  
		
		sst.SEASON + ':' + sst.SSTAT COLLATE SQL_Latin1_General_CP1_CI_AS AS ETL__SSID 
		, sst.SEASON ETL__SSID_PAC_SEASON
		, sst.SSTAT ETL__SSID_PAC_SSTAT
		
		, sst.SSTAT SeatStatusCode
		, sst.NAME SeatStatusName
		, sst.NAME + ' (' + sst.SSTAT COLLATE SQL_Latin1_General_CP1_CI_AS + ')' SeatStatusDesc
		, sst.STAT_COLOR SeatStatusClass
		, CAST(CASE WHEN SSTAT = 'K' THEN 1 ELSE 0 END AS BIT) IsKill
		, sst.SEASON Season

	--SELECT *
	FROM dbo.TK_SSTAT (NOLOCK) sst

)
GO
