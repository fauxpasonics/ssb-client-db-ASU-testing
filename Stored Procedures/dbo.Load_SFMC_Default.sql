SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE  [dbo].[Load_SFMC_Default]
AS

TRUNCATE TABLE dbo.SFMC_Default

INSERT INTO dbo.SFMC_Default
EXEC dbo.sp_SFMC_Default


GO
