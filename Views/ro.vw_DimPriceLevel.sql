SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ro].[vw_DimPriceLevel] AS ( SELECT * FROM dbo.DimPriceLevel_V2 (NOLOCK) )
GO
