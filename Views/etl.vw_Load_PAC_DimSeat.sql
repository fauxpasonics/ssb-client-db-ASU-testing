SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_PAC_DimSeat] AS (

	SELECT DISTINCT
		
		(ss.SEASON + ':' + ss.[LEVEL] + ':' + ss.SECTION + ':' + ss.[ROW] + ':' + ss.SEAT) ETL__SSID
		, ss.SEASON ETL__SSID_PAC_SEASON
		, ss.[LEVEL] ETL__SSID_PAC_LEVEL
		, ss.SECTION ETL__SSID_PAC_SECTION
		, ss.[ROW] ETL__SSID_PAC_ROW
		, ss.SEAT ETL__SSID_PAC_SEAT

		, ss.SEASON Season
		, ss.[LEVEL] LevelName
		, ss.SECTION SectionName
		, ss.[ROW] RowName
		, ss.SEAT Seat
		, ss.PL DefaultPriceLevel
		, ss.VMC SortOrderSeat

		--SELECT top 1000 *
		FROM (
			SELECT ss.SEASON, ss.[LEVEL], ss.SECTION, ss.[ROW], ss.SEAT
				, MIN(ss.VMC) VMC
				, MIN(PL) PL
			FROM dbo.TK_SEAT_SEAT (NOLOCK) ss
			WHERE ss.SEAT IS NOT NULL
			GROUP BY ss.SEASON, ss.[LEVEL], ss.SECTION, ss.[ROW], ss.SEAT
		) ss
)



GO
