SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[rptCust_ListBuild_AllocOptions] (@Fund VARCHAR(100))
AS

SELECT DISTINCT ALLOC_DESC, ALLOC_CODE FROM dbo.FD_SDA_TRANSACTION_DETAIL
WHERE ATHLETIC_FUND_DESC IN (SELECT s from [dbo].[fnSplitDelimString] (',',@Fund))
ORDER BY alloc_desc
GO
