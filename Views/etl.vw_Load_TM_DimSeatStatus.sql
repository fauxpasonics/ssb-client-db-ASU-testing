SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimSeatStatus] AS (

SELECT 

	c.class_id ETL__SSID
	, c.class_id ETL__SSID_TM_class_id
	, c.matrix_char SeatStatusCode
	, c.[name] SeatStatusName
	, CONCAT(c.[name], ' (', c.matrix_char, ')') SeatStatusDesc
	, CAST(CASE WHEN c.[kill] = 'Y' THEN 1 ELSE 0 END AS BIT) IsKill
	, CAST(CASE WHEN c.system_class = 'N' THEN 1 ELSE 0 END AS BIT) IsCustomStatus

	, c.[matrix_char] [TM_matrix_char]
	, c.[color] [TM_color]
	, c.[return_class_id] [TM_return_class_id]
	, c.[valid_for_reclass] [TM_valid_for_reclass]
	, c.[dist_status] [TM_dist_status]
	, c.[dist_name] [TM_dist_name]
	, c.[dist_ett] [TM_dist_ett]
	, c.[ism_class_id] [TM_ism_class_id]
	, c.[qualifier_state_names] [TM_qualifier_state_names]
	, c.[system_class] [TM_system_class]
	, c.[qualifier_template] [TM_qualifier_template]
	, c.[unsold_type] [TM_unsold_type]
	, c.[unsold_qual_id] [TM_unsold_qual_id]
	, c.[attrib_type] [TM_attrib_type]
	, c.[attrib_code] [TM_attrib_code]
	, c.[qualifier_state_name] [TM_qualifier_state_name]

FROM ods.TM_Class c (NOLOCK)

)

GO
