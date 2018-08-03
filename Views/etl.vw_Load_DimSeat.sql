SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_DimSeat] AS (

	SELECT DISTINCT
		'PAC' ETL__SourceSystem
		, (ss.SEASON + ':' + ss.[LEVEL] + ':' + ss.SECTION + ':' + ss.[ROW] + ':' + ss.SEAT) ETL__SSID
		, ss.SEASON ETL__SSID_SEASON
		, ss.[LEVEL] ETL__SSID_LEVEL
		, ss.SECTION ETL__SSID_SECTION
		, ss.[ROW] ETL__SSID_ROW
		, ss.SEAT ETL__SSID_PacSeat

		, ss.SEASON Season
		, ss.[LEVEL] LevelName
		, ss.SECTION SectionName
		, ss.[ROW] RowName
		, ss.SEAT Seat
		, ss.PL DefaultPriceLevel
		--, NULL Config_Location

		--SELECT top 1000 *
		FROM (
			SELECT ss.SEASON, ss.[LEVEL], ss.SECTION, ss.[ROW], ss.SEAT
			, MIN(PL) PL
			FROM dbo.TK_SEAT_SEAT (NOLOCK) ss
			GROUP BY ss.SEASON, ss.[LEVEL], ss.SECTION, ss.[ROW], ss.SEAT
		) ss

)
GO
