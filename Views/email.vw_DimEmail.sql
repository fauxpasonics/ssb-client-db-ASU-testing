SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [email].[vw_DimEmail]  
AS 
SELECT a.* , b.EmailStatus
FROM email.DimEmail a WITH (NOLOCK) 
inner JOIN email.DimEmailStatus b WITH (NOLOCK) ON a.DimEmailStatusId = b.DimEmailStatusID
;
GO
