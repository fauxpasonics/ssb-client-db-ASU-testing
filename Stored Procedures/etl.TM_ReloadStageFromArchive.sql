SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_ReloadStageFromArchive]
(
	@SourceTable NVARCHAR(255),
	@TargetTable NVARCHAR(255),
	@BatchId NVARCHAR(50)
)

AS
BEGIN


--DECLARE @SourceTable NVARCHAR(255) = 'stg.TM_Class'
--DECLARE @TargetTable NVARCHAR(255) = 'src.TM_Class'


DECLARE @SQL_TruncateTarget NVARCHAR(MAX), @SQL_InsertTarget NVARCHAR(MAX)

DECLARE @Columns NVARCHAR(MAX) = '', @SelectColumns NVARCHAR(MAX) = ''

SELECT @Columns = @Columns + ', [' + o.COLUMN_NAME + ']'
FROM (
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = PARSENAME(@TargetTable, 2)
	AND TABLE_NAME = PARSENAME(@TargetTable, 1)
) o
INNER JOIN (
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = PARSENAME(@SourceTable, 2)
	AND TABLE_NAME = PARSENAME(@SourceTable, 1)
) s ON o.COLUMN_NAME = s.COLUMN_NAME
WHERE s.COLUMN_NAME NOT IN ('ETL__ID')
ORDER BY o.COLUMN_NAME

SET @Columns = RIGHT(@Columns, LEN(@Columns) - 2)

--PRINT @Columns

--SET @SelectColumns = REPLACE(@Columns, ', [', ', s.[')



SELECT @SelectColumns = @SelectColumns +
CASE 
	WHEN o.DATA_TYPE <> s.DATA_TYPE THEN ', TRY_CAST(s.[' + o.COLUMN_NAME + '] as ' + o.DATA_TYPE + ') [' + o.COLUMN_NAME + ']' 
	ELSE ', s.[' + o.COLUMN_NAME + ']'
END
FROM (
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = PARSENAME(@TargetTable, 2)
	AND TABLE_NAME = PARSENAME(@TargetTable, 1)
) o
INNER JOIN (
	SELECT *
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = PARSENAME(@SourceTable, 2)
	AND TABLE_NAME = PARSENAME(@SourceTable, 1)
) s ON o.COLUMN_NAME = s.COLUMN_NAME
WHERE s.COLUMN_NAME NOT IN ('ETL__ID')
ORDER BY o.COLUMN_NAME

SET @SelectColumns = RIGHT(@SelectColumns, LEN(@SelectColumns) - 2)

--PRINT @SelectColumns



SET @SQL_TruncateTarget = 'TRUNCATE TABLE ' + @TargetTable

--PRINT @SQL_TruncateTarget

--EXEC (@SQL_TruncateTarget)

SET @SQL_InsertTarget = 

@SQL_TruncateTarget + '

INSERT INTO ' + @TargetTable  + '
( 
	' + @Columns + '	
)

SELECT
	' + @SelectColumns + '
FROM ' + @SourceTable + ' s
WHERE s.ETL__BatchId = ''' + @BatchId + '''
'


--SELECT @SQL_InsertTarget

EXEC (@SQL_InsertTarget)

END







GO
