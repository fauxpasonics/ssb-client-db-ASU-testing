SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ro].[vw_DimSeason] AS ( SELECT * FROM dbo.DimSeason_V2 (NOLOCK) )
GO