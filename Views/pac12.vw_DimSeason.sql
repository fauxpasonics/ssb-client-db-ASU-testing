SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimSeason] as 
(
	SELECT  [DimSeasonId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_SEASON], [ETL__SSID_TM_season_Id], [SeasonCode], [SeasonName], [SeasonDesc], [SeasonClass], [Activity], [Status], [IsActive], [SeasonYear], [DimSeasonId_Prev], [ManifestId], [Config_SeasonEventCntFSE], [Config_SeasonYear], [Config_SeasonYearLabel], [Config_FiscalYear], [Config_DefaultDimSeasonHeaderId], [Config_RenewalStartDateTimeFS], [Config_RenewalDeadLineDateTimeFS], [Config_RenewalStartDateTimeHS], [Config_RenewalDeadLineDateTimeHS], [Config_RenewalStartDateTimeMP], [Config_RenewalDeadLineDateTimeMP], [Config_Category1], [Config_Category2], [Config_Category3], [Config_Category4], [Config_Category5], [Config_Org], [Config_DefaultFactInventoryEligible], [SeasonEventCntFSE], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [TM_arena_id], [TM_manifest_id], [TM_org_id], [TM_org_name], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5]
	FROM dbo.DimSeason_V2 (NOLOCK)
)
GO
