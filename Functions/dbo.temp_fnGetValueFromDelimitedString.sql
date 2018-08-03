SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[temp_fnGetValueFromDelimitedString]
(
      @String NVARCHAR(MAX), 
      @Delimiter NVARCHAR(MAX) = ',',
      @ValuePosition INT      
)

RETURNS VARCHAR(4000)
AS 

BEGIN

	DECLARE @Result VARCHAR(4000)	
		
	DECLARE @Values TABLE (ValueNumber INT IDENTITY(1,1), Value VARCHAR(4000))	
	DECLARE @Xdoc XML

	--XML parser doesn't work for the & symbol. 
	--Convert it to another value before parsing and then convert back before returning the table
	SET @String = REPLACE(@String, '&', '*$and$*')

	SET @Xdoc = CONVERT(XML,'<r><v>' + REPLACE(@String, @Delimiter,'</v><v>') + '</v></r>')

	INSERT INTO @Values(Value)
	SELECT [Item] = REPLACE(LTRIM(RTRIM(T.c.value('.','varchar(1000)'))),'*$and$*','&')
	FROM @Xdoc.nodes('/r/v') T(c) 
	
	SET @Result = (
					SELECT Value
					FROM @Values
					WHERE ValueNumber = @ValuePosition
	)
	
	RETURN @Result

END




GO
