SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[SSB_ResetAllDeltaHashKeys]
(
	@TableName NVARCHAR(255)
)

AS
BEGIN

DECLARE @HashSyntax VARCHAR(MAX)

DECLARE	 @HashTbl TABLE (HashSyntax VARCHAR(MAX))

INSERT @HashTbl (HashSyntax)
EXEC  etl.SSB_MergeHashFieldSyntax @TableName, 'ETL_Sync_DeltaHashKey'

SET @HashSyntax = (SELECT TOP 1 HashSyntax FROM @HashTbl)

DECLARE @Sql nvarchar(MAX) = ''

SET @Sql = '
UPDATE ' + @TableName + '
SET ETL_Sync_DeltaHashKey = ' + @HashSyntax

SET @Sql = '
SELECT 1
WHILE @@ROWCOUNT > 0
BEGIN
	UPDATE TOP (100000) ' + @TableName + '
	SET ETL_Sync_DeltaHashKey = ' + @HashSyntax + '
	WHERE ETL_Sync_DeltaHashKey IS NULL
END
'


EXEC (@Sql)


END

GO
