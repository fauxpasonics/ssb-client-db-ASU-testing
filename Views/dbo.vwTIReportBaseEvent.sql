SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE view [dbo].[vwTIReportBaseEvent] as (
	select * from dbo.TI_ReportBaseEvent1 (nolock)
)
GO
