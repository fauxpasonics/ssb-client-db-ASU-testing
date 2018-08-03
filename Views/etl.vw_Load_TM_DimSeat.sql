SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimSeat] AS (

	SELECT a.ETL__SSID, a.ETL__SSID_TM_manifest_id, a.ETL__SSID_TM_section_id, a.ETL__SSID_TM_row_id, a.ETL__SSID_TM_seat, a.ManifestId, a.SectionName, a.RowName, a.Seat
           , a.DefaultClass, a.DefaultPriceCode			   
             , a.TM_section_name, a.TM_section_desc, a.TM_section_type, a.TM_section_type_name, a.TM_gate, a.TM_ga,
             a.TM_row_id, a.TM_row_name, a.TM_row_desc, a.TM_default_class, a.TM_class_name, a.TM_def_price_code, a.TM_tm_section_name, a.TM_tm_row_name,
             a.TM_section_info1, a.TM_section_info2, a.TM_section_info3, a.TM_section_info4, a.TM_section_info5, a.TM_row_info1, a.TM_row_info2, a.TM_row_info3,
             a.TM_row_info4, a.TM_row_info5, a.TM_manifest_name, a.TM_aisle
	FROM (
		SELECT
			CONCAT(ms.manifest_id, ':', ms.section_id, ':', ms.row_id, ':', sl.Seat) AS ETL__SSID 
			, ms.manifest_id ETL__SSID_TM_manifest_id
			, ms.section_id ETL__SSID_TM_section_id
			, ms.row_id ETL__SSID_TM_row_id
			, sl.Seat ETL__SSID_TM_seat

			, ms.manifest_id ManifestId
			, ms.section_name SectionName
			, ms.row_name RowName		
			, sl.Seat Seat
			, ms.default_class DefaultClass
			, ms.def_price_code DefaultPriceCode

			, ms.[section_name] [TM_section_name]
			, ms.[section_desc] [TM_section_desc]
			, ms.[section_type] [TM_section_type]
			, ms.[section_type_name] [TM_section_type_name]
			, ms.[gate] [TM_gate]
			, ms.[ga] [TM_ga]
			, ms.[row_id] [TM_row_id]
			, ms.[row_name] [TM_row_name]
			, ms.[row_desc] [TM_row_desc]
			, ms.[default_class] [TM_default_class]
			, ms.[class_name] [TM_class_name]
			, ms.[def_price_code] [TM_def_price_code]
			, ms.[section_name] [TM_tm_section_name]
			, ms.[row_name] [TM_tm_row_name]
			, ms.[section_info1] [TM_section_info1]
			, ms.[section_info2] [TM_section_info2]
			, ms.[section_info3] [TM_section_info3]
			, ms.[section_info4] [TM_section_info4]
			, ms.[section_info5] [TM_section_info5]
			, ms.[row_info1] [TM_row_info1]
			, ms.[row_info2] [TM_row_info2]
			, ms.[row_info3] [TM_row_info3]
			, ms.[row_info4] [TM_row_info4]
			, ms.[row_info5] [TM_row_info5]
			, ms.[manifest_name] [TM_manifest_name]
			, ms.[aisle] [TM_aisle]

		, ROW_NUMBER() OVER	(PARTITION BY ms.manifest_id, ms.section_id, ms.row_id, sl.Seat ORDER BY ms.UpdateDate DESC) RowRank

		--SELECT COUNT(*)
		FROM ods.TM_ManifestSeat ms
		INNER JOIN (
			SELECT DISTINCT manifest_id 
			FROM ods.TM_ManifestSeat
			WHERE UpdateDate > GETDATE() - 2
		) mu ON ms.manifest_id = mu.manifest_id
		INNER JOIN dbo.Lkp_SeatList sl ON sl.seat >= ms.seat_num AND sl.Seat < (ms.seat_num + ms.num_seats)		


	) a
	WHERE RowRank = 1

) 


GO
