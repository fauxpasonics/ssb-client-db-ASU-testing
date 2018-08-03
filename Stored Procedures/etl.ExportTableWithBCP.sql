SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[ExportTableWithBCP]
(
	@ObjectName nvarchar(255) = ''
)
AS
BEGIN

	DECLARE @SqlHeader NVARCHAR(max) = '', @SqlData nvarchar(max) = '', @Sql NVARCHAR(max) = ''

	SELECT @SqlHeader = @SqlHeader + '''' + COLUMN_NAME + ''' [' + COLUMN_NAME + '], '
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 1=1
	AND TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME LIKE 'DimEvent'

	SET @SqlHeader = 'SELECT ' + LEFT(@SqlHeader, LEN(@SqlHeader) - 1)

	--select @SqlHeader

	
	SET @SqlData = 'SELECT * FROM ' + @ObjectName

	SET @Sql = @SqlHeader + ' UNION ' + @SqlData

	SELECT @Sql
	--EXEC (@Sql)

END
GO
