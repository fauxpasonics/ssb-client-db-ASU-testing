SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ro].[vw_DimPromo] AS ( SELECT * FROM dbo.DimPromo_V2 (NOLOCK) )
GO
