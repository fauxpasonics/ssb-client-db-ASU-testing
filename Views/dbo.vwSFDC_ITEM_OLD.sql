SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[vwSFDC_ITEM_OLD] AS 
SELECT
	 SEASON
	,ITEM
	,NAME ITEM_NAME
	,EXPORT_DATETIME

	FROM TK_ITEM (NOLOCK)

GO