SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_PAC_DimPlan] AS (

	SELECT  
		
		i.SEASON + ':' + i.ZID COLLATE SQL_Latin1_General_CP1_CI_AS AS ETL__SSID 
		, i.SEASON ETL__SSID_PAC_SEASON
		, i.ITEM ETL__SSID_PAC_ITEM

		, i.ITEM PlanCode
		, i.NAME PlanName
		, i.NAME + ' (' + i.ITEM COLLATE SQL_Latin1_General_CP1_CI_AS + ')' PlanDesc
		, i.CLASS PlanClass
		, i.SEASON
		--, NULL PlanFSE
		--, NULL PlanType
		--, NULL PlanEventCnt
		--, NULL Config_PlanTicketType
		--, NULL Config_PlanName,
		--, NULL Config_PlanRenewableFSE

	--SELECT *
	FROM dbo.TK_ITEM (NOLOCK) i
	WHERE i.BASIS = 'C'

)
GO
