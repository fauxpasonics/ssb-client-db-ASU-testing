SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ExportObjectHeader]
(
	@ObjectName NVARCHAR(255) = ''
)
AS
BEGIN

	DECLARE @SqlHeader NVARCHAR(MAX) = ''

	SELECT @SqlHeader = @SqlHeader + '''' + name + ''' [' + name + '], '
	FROM sys.columns 
	WHERE object_id = OBJECT_ID(@ObjectName)

	SET @SqlHeader = 'SELECT ' + LEFT(@SqlHeader, LEN(@SqlHeader) - 1)

	--SELECT @SqlHeader
	EXEC (@SqlHeader)

END

GO
