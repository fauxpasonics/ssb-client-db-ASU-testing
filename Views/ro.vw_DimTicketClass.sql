SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ro].[vw_DimTicketClass] AS ( SELECT * FROM dbo.DimTicketClass_V2 (NOLOCK) )

GO
