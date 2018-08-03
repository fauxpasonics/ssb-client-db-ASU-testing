SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE VIEW [dbo].[vw_DimPhone]  
AS 
SELECT a.*, b.ShortDescription AS PhoneLineType 
FROM dbo.DimPhone a WITH (NOLOCK) 
LEFT JOIN dbo.PhoneLineTypeCode b WITH (NOLOCK) ON a.PhoneLineTypeCode = b.PhoneLineTypeCode 
GO
