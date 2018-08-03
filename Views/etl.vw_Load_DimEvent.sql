SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_DimEvent] AS (

	SELECT  
		'PAC' ETL__SourceSystem
		, e.SEASON + ':' + e.ZID COLLATE SQL_Latin1_General_CP1_CI_AS AS ETL__SSID 
		, e.SEASON ETL__SSID_SEASON
		, e.[EVENT] ETL__SSID_EVENT

		, e.[EVENT] COLLATE SQL_Latin1_General_CP1_CI_AS EventCode
		, e.NAME COLLATE SQL_Latin1_General_CP1_CI_AS EventName
		, e.NAME + ' (' + e.EVENT COLLATE SQL_Latin1_General_CP1_CI_AS + ')' EventDesc
		, e.CLASS COLLATE SQL_Latin1_General_CP1_CI_AS EventClass
		, e.FACILITY COLLATE SQL_Latin1_General_CP1_CI_AS Arena
		, e.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS Season
		, TRY_CAST(e.DATE AS DATE) EventDate
		, TRY_CAST(e.TIME AS TIME) EventTime
		, CASE 
			WHEN ISNULL(e.TIME, 'TBA') = 'TBA' THEN TRY_CAST(e.DATE AS DATETIME)
			ELSE CAST(e.DATE AS DATETIME) + TRY_CAST(e.TIME AS DATETIME) 
		END EventDateTime
		, e.ETYPE COLLATE SQL_Latin1_General_CP1_CI_AS EType
		, e.BASIS COLLATE SQL_Latin1_General_CP1_CI_AS Basis
		, e.EGROUP COLLATE SQL_Latin1_General_CP1_CI_AS EGroup
		, e.KEYWORD COLLATE SQL_Latin1_General_CP1_CI_AS Keywords
		, e.TAG COLLATE SQL_Latin1_General_CP1_CI_AS Tag
		--, NULL ManifestId

	--SELECT *
	FROM dbo.TK_EVENT (NOLOCK) e

)

GO
