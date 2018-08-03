SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimScanType] AS (

SELECT DISTINCT
      a.channel_ind AS ETL__SSID 
      , a.channel_ind AS [ETL__SSID_TM_channel_ind]
      , a.channel_ind AS [ScanTypeCode]
      ,a.access_type AS [ScanTypeName]

FROM    ods.TM_AttendApi a (NOLOCK)
WHERE ISNULL(a.channel_ind, '') <> ''

)

GO
