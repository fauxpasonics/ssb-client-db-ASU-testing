SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ro].[vw_DimDate] AS ( SELECT * FROM dbo.DimDate (NOLOCK) )


GO
