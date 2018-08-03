SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimScanGate] AS (

SELECT DISTINCT
      a.gate AS ETL__SSID 
      , a.gate AS ETL__SSID_TM_gate
      , a.gate AS [ScanGateCode]
      ,a.gate AS [ScanGateName]

FROM    ods.TM_AttendApi a (NOLOCK)
WHERE ISNULL(a.gate, '') <> ''

)




GO
