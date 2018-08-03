SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_TM_DimPromo] AS (


	SELECT a.ETL__SSID, a.ETL__SSID_TM_promo_code, a.PromoCode, a.PromoName, a.PromoDesc, a.PromoClass, a.TM_promo_inet_name, a.TM_promo_inet_desc, a.TM_promo_type,
		   a.TM_promo_group_sell_flag, a.TM_promo_active_flag, a.TM_inet_start_datetime, a.TM_inet_end_datetime, a.TM_archtics_start_datetime,
		   a.TM_archtics_end_datetime, a.TM_event_id
	FROM (
		SELECT  
			p.promo_code AS ETL__SSID
			, p.promo_code AS ETL__SSID_TM_promo_code
		
			, p.promo_code AS PromoCode
			, p.promo_code_name PromoName
			, p.promo_inet_desc PromoDesc
			, p.promo_type PromoClass

			, p.[promo_inet_name] [TM_promo_inet_name]
			, p.[promo_inet_desc] [TM_promo_inet_desc]
			, p.[promo_type] [TM_promo_type]
			, p.[promo_group_sell_flag] [TM_promo_group_sell_flag]
			, p.[promo_active_flag] [TM_promo_active_flag]
			, p.[inet_start_datetime] [TM_inet_start_datetime]
			, p.[inet_end_datetime] [TM_inet_end_datetime]
			, p.[archtics_start_datetime] [TM_archtics_start_datetime]
			, p.[archtics_end_datetime] [TM_archtics_end_datetime]
			, p.[event_id] [TM_event_id]

			, ROW_NUMBER() OVER(PARTITION BY p.promo_code ORDER BY p.UpdateDate) RowRank
		--SELECT *
		FROM ods.TM_PromoCode (NOLOCK) p
	) a	
	WHERE a.RowRank = 1

)







GO
