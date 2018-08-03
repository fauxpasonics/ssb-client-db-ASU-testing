SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [segmentation].[DropOldSegmentationFlatDataTables]
AS
BEGIN

	DECLARE @cmd VARCHAR(4000)
	DECLARE cmds CURSOR FOR 
	SELECT 'drop table [segmentation].[' + Table_Name + ']'
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = 'segmentation'
	AND TABLE_NAME LIKE 'SegmentationFlatData%'

	OPEN cmds
	WHILE 1=1
	BEGIN
		FETCH cmds INTO @cmd
		IF @@fetch_status != 0 BREAK
		--print(@cmd)
		EXEC(@cmd)
	END
	CLOSE cmds;
	DEALLOCATE cmds

	-- usage:
	-- exec [segmentation].[DropOldSegmentationFlatDataTables]

END


GO
