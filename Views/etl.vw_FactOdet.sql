SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_FactOdet] AS ( SELECT * FROM dbo.FactOdet_V2 )
GO
