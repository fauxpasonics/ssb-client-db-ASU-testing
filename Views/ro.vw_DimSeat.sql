SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ro].[vw_DimSeat] AS ( SELECT * FROM dbo.DimSeat_V2 (NOLOCK) )
GO
