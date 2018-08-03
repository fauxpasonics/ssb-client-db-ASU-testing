SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [KPI].[vw_RptKPICounts_ASUVert] AS

SELECT [rpt].[ReportName] 
, dc.[ClientID]
, [kpi].[KPIDisplayName]
, [dc].[KPIID]
, DateId Date
, [dc].[KPIValue]
, [rpt].KPIRPTID
--,kpi.KPIDetail_Query
,0 AS KPIExportEnable
,((DENSE_RANK() OVER (ORDER BY ISNULL(KPIOrder,999) ASC, kpi.KpiID)-1)/3) + 1 AS displayrownumber
,((DENSE_RANK() OVER (ORDER BY ISNULL(KPIOrder,999) ASC, kpi.KpiID)-1)%3) + 1 AS displaycolnumber
,LAG(KPIValue,1) OVER (PARTITION BY dc.KPIID ORDER BY DateId) AS KpiPrev
,LAG(KPIValue,30) OVER (PARTITION BY dc.KPIID ORDER BY DateId) AS KpiPrevThirty
FROM CentralIntelligence.KPI.[ReportList] rpt
INNER JOIN CentralIntelligence.KPI.[ReportKPIs] rkpis ON [rkpis].[KPIRPTID] = [rpt].[KPIRPTID] 
--AND rpt.[KPIRPTID] = 1
 AND [rkpis].[Enabled] = 1
INNER JOIN CentralIntelligence.KPI.[KPI_List] kpi ON [kpi].[KPIID] = [rkpis].[KPIID] AND kpi.[Enabled] = 1
INNER JOIN CentralIntelligence.KPI.[DailyCount] dc ON [dc].[KPIID] = [rkpis].[KPIID] 
--AND dc.[ClientID] = 7
--WHERE ABS(DATEDIFF(d, DateId, GETDATE())) BETWEEN 0 AND max(DateId)
--ORDER BY kpiid, [DateId] DESC
GO
