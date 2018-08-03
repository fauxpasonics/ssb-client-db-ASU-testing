SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
DECLARE
@TaskName NVARCHAR(MAX) = 'Test'
,@TaskType NVARCHAR(MAX) = 'type1'
,@SQL NVARCHAR(MAX) = NULL
,@Target NVARCHAR(MAX) = '[dw].[DimProperty]'
,@Source NVARCHAR(MAX) = '[predw].[DimProperty]'
,@CustomMatchOn NVARCHAR(MAX) = '[PropertyCode]'
,@ExcludeColumns NVARCHAR(MAX) = '[ETL_CREATED_DATE],[ETL_LUPDATED_DATE]'
PRINT [dev].[SQLGenerator] (@TaskName,@TaskType,@SQL,@Target,@Source,@CustomMatchOn,@ExcludeColumns)
*/

CREATE FUNCTION [dev].[SQLGenerator]
(
	 @TaskName NVARCHAR(MAX) = 'Not Specified'
	,@TaskType NVARCHAR(MAX)
	,@SQL NVARCHAR(MAX) = NULL
	,@Target NVARCHAR(MAX) = NULL
	,@Source NVARCHAR(MAX) = NULL
	,@CustomMatchOn NVARCHAR(MAX) = NULL
	,@ExcludeColumns NVARCHAR(MAX) = NULL
)

RETURNS NVARCHAR(MAX)

AS
BEGIN

------------------------ Get Target Table Info ------------------------
DECLARE @TargetDatabaseName NVARCHAR(400)
DECLARE @TargetSchemaName NVARCHAR(400)
DECLARE @TargetTableName NVARCHAR(400)
DECLARE @TargetFullTableName NVARCHAR(400)

SELECT
	 @TargetDatabaseName = [DBName]
	,@TargetSchemaName = [SchemaName]
	,@TargetTableName = [TableName]
	,@TargetFullTableName = ISNULL([DBName] + '.','') + ISNULL([SchemaName] + '.','') + [TableName]
FROM
	(
	SELECT a.o,b.a
	FROM
		(
		SELECT Item o,ROW_NUMBER() OVER(ORDER BY (SELECT 1)) + (SELECT COUNT(*) FROM dev.Split(@Target,'.') a) - 3 jn
		FROM dev.Split('DBName,SchemaName,TableName',',') a
		) a
		LEFT JOIN
			(
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) rn,REPLACE(REPLACE('[' + a.Item + ']','[[','['),']]',']') a
			FROM dev.Split(@Target,'.') a
			) b
		ON a.jn = b.rn
		) p
	PIVOT (MAX(a) FOR o IN ([DBName],[SchemaName],[TableName])
	) pvt	
--SELECT @TargetDatabaseName DatabaseName,@TargetSchemaName SchemaName,@TargetTableName TableName,@TargetFullTableName FullTableName

------------------------ Get Source Table/View Info ------------------------
DECLARE @SourceDatabaseName NVARCHAR(400)
DECLARE @SourceSchemaName NVARCHAR(400)
DECLARE @SourceTableName NVARCHAR(400)
DECLARE @SourceFullTableName NVARCHAR(400)

IF LEFT(@Source,1) <> '('
SELECT
	@SourceDatabaseName = [DBName]
	,@SourceSchemaName = [SchemaName]
	,@SourceTableName = [TableName]
	,@SourceFullTableName = ISNULL([DBName] + '.','') + ISNULL([SchemaName] + '.','') + [TableName]
FROM
	(
	SELECT a.o,b.a
	FROM
		(
		SELECT Item o,ROW_NUMBER() OVER(ORDER BY (SELECT 1)) + (SELECT COUNT(*) FROM dev.Split(@Source,'.') a) - 3 jn
		FROM dev.Split('DBName,SchemaName,TableName',',') a
		) a
		LEFT JOIN
			(
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) rn,REPLACE(REPLACE('[' + a.Item + ']','[[','['),']]',']') a
			FROM dev.Split(@Source,'.') a
			) b
		ON a.jn = b.rn
		) p
	PIVOT (MAX(a) FOR o IN ([DBName],[SchemaName],[TableName])
	) pvt	
--SELECT @SourceDatabaseName DatabaseName,@SourceSchemaName SchemaName,@SourceTableName TableName,@SourceFullTableName FullTableName

SET @SQL = 'DECLARE @RowCountBefore INT = 0, @RowCountAfter INT = 0, @Inserted INT = 0, @Updated INT = 0, @Deleted INT = 0, @Truncated INT = 0
' + ISNULL(@SQL,'')

------------------------------------------ When the Task Type is a procedure request ------------------------------------------
IF @TaskType = 'Procedure'
BEGIN
SELECT @SQL += '
EXEC [' + ROUTINE_SCHEMA + '].[' + ROUTINE_NAME + ']
'
FROM INFORMATION_SCHEMA.Routines
WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_SCHEMA = 'rpt'

END
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------ When the Task Type is a Truncate request ------------------------------------------
IF @TaskType = 'Truncate'
BEGIN
SET @SQL = @SQL + '
SET @RowCountBefore = (SELECT COUNT(*) RowCountBefore FROM ' + @TargetFullTableName + ')
TRUNCATE TABLE ' + @TargetFullTableName + '
SET @RowCountAfter = (SELECT COUNT(*) RowCountAfter FROM ' + @TargetFullTableName + ')
SET @Truncated = @RowCountBefore - @RowCountAfter
'
END
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------ When the Task Type is a merge request ------------------------------------------
IF @TaskType IN ('Insert','Update','Upsert','Sync','SyncSoftDelete','Type1','Type2')
BEGIN

;WITH cte AS
(
SELECT *
FROM
	(
	SELECT
		a.TableType
		,a.FullTableName
		,a.DatabaseName
		,a.TableName
		,a.SchemaName
		,a.OrdinalPosition
		,a.ColumnName TargetColumnName
		,COALESCE(b.ColumnName,a.ColumnName) SourceColumnName
		,a.DataType
		,CASE
			WHEN @CustomMatchOn IS NOT NULL THEN
				CASE WHEN a.ColumnName IN (SELECT '[' + REPLACE(REPLACE(Item,'[',''),']','') + ']' FROM dev.Split(@CustomMatchOn,',') a) THEN 1 ELSE 0 END
			ELSE a.IsPK
		END IsPK
		,a.PKName
		,a.IsHasFK
		,a.FKName
		,a.FKReferencesTableName
		,a.FKNameReferencesColumnName
		,a.IsIdentity
		,a.PriorityOrder
		,a.MatchOn
	FROM dev.InfoSchema a
		LEFT JOIN
			(
			SELECT *
				,CASE WHEN ColumnName LIKE '%_K]' THEN LEFT(ColumnName,LEN(ColumnName) - 3) + ']' ELSE ColumnName END MatchingColumnName
			FROM dev.InfoSchema a
			WHERE
				(DatabaseName = @SourceDatabaseName OR @SourceDatabaseName IS NULL)
				AND (SchemaName = @SourceSchemaName OR @SourceSchemaName IS NULL)
				AND TableName = @SourceTableName
				AND ColumnName NOT IN (SELECT * FROM dev.Split(@ExcludeColumns,','))
			) b
		ON a.ColumnName = b.MatchingColumnName
	WHERE
		(a.DatabaseName = @TargetDatabaseName OR @TargetDatabaseName IS NULL)
		AND (a.SchemaName = @TargetSchemaName OR @TargetSchemaName IS NULL)
		AND a.TableName = @TargetTableName
		AND a.ColumnName NOT IN (SELECT * FROM dev.Split(@ExcludeColumns,','))
	) a
)

--SELECT * FROM cte ORDER BY OrdinalPosition END

SELECT @SQL += '
SET @RowCountBefore = (SELECT COUNT(*) RowCountBefore FROM ' + FullTableName + ')
DECLARE @RunDateTime DATETIME = dev.UDTToLocalTime(GETDATE())' +
CASE WHEN @TaskType <> 'Type2' THEN '
DECLARE @MergeAudit TABLE (MergeAction NVARCHAR(10))
MERGE ' + FullTableName + ' t
USING ' + @Source + ' s
ON (' + MatchON + ')' + CASE WHEN @TaskType IN ('Sync','Upsert','Update','Type1','SyncSoftDelete') THEN '
' + CASE WHEN ThenUpdateSet IS NULL THEN '' ELSE 'WHEN MATCHED AND (' + REPLACE(WhenMatchedAnd,'&lt;&gt;', '<>') + ') ' + CASE WHEN @TaskType IN ('SyncSoftDelete') THEN 'OR IS_DELETED = 1 ' ELSE '' END + '
THEN UPDATE SET ' + CASE WHEN @TaskType = 'Type1' THEN 'ETL_LUPDATED_DATE = @RunDateTime, ' ELSE '' END + ThenUpdateSet END ELSE '' END + CASE WHEN @TaskType IN ('SyncSoftDelete') THEN ', IS_DELETED = 0, ETL_DELETE_DATE = NULL' ELSE '' END + 
CASE WHEN @TaskType IN ('Sync','Upsert','Insert','Type1','SyncSoftDelete') THEN '
WHEN NOT MATCHED THEN INSERT (' + WhenNotMatchedThenInsert + ')
VALUES (' + InsertValues + ')' ELSE '' END + CASE WHEN @TaskType IN ('Sync') THEN '
WHEN NOT MATCHED BY SOURCE THEN DELETE' ELSE '' END + CASE WHEN @TaskType IN ('SyncSoftDelete') THEN '
WHEN NOT MATCHED BY SOURCE THEN UPDATE SET IS_DELETED = 1, ETL_DELETE_DATE = GETDATE()' ELSE '' END + '
OUTPUT $action INTO @MergeAudit;
'
ELSE '
DECLARE @MergeAudit TABLE (MergeAction NVARCHAR(10)' + ColumnsAndDataTypes + ', EFF_BEG_DATE DATE, EFF_END_DATE DATE) 
DECLARE @newStartDate DATE = DATEADD(dd, -1, dev.UDTToLocalTime(GETDATE())) 
DECLARE @newEndDate DATE = ''12/31/9999''
DECLARE @oldEndDate DATE = DATEADD(dd, -2, dev.UDTToLocalTime(GETDATE())) 

MERGE ' + FullTableName + ' t
USING ' + @Source + ' s
	ON (' + MatchOn + ')
WHEN NOT MATCHED 
THEN 
	INSERT VALUES (' + InsertValues + ', @newStartDate, @newEndDate, @RunDateTime, @RunDateTime)
WHEN MATCHED 
	AND t.EFF_END_DATE = @newEndDate
	AND (' + REPLACE(WhenMatchedAnd,'&lt;&gt;', '<>') + ')
THEN
	UPDATE SET EFF_END_DATE = @oldEndDate
OUTPUT $action MergeAction, ' + InsertValues + ', @newStartDate AS [EFF_BEG_DATE], @newEndDate AS EFF_END_DATE INTO @MergeAudit;

INSERT INTO ' + FullTableName + '
SELECT ' + [Columns] + ', EFF_BEG_DATE, EFF_END_DATE, @RunDateTime, @RunDateTime
FROM @MergeAudit MERGE_OUT
WHERE MERGE_OUT.MergeAction = ''UPDATE''; 
'
		END + '
SET @RowCountAfter = (SELECT COUNT(*) RowCountAfter FROM ' + FullTableName + ')
SELECT @Inserted = [INSERT]' + CASE WHEN @TaskType = 'Type2' THEN ' + [UPDATE]' ELSE '' END + ', @Updated = [UPDATE], @Deleted = [DELETE]
FROM (SELECT NULL MergeAction, 0 [Rows] UNION ALL SELECT MergeAction, 1 [Rows] FROM @MergeAudit) p
PIVOT (COUNT(rows) FOR MergeAction IN ([INSERT],[UPDATE],[DELETE])) pvt
'
FROM
	(SELECT DISTINCT
		a.FullTableName
		,a.TableName
		,SUBSTRING(
			(SELECT ' OR ' + 'ISNULL(t.' + l.TargetColumnName + ',' + CASE WHEN l.DataType IN ('[int]','[float]','[decimal]') THEN '-1' ELSE '''''' END + ') <> ISNULL(s.' + l.SourceColumnName + ',' + CASE WHEN l.DataType IN ('[int]','[float]','[decimal]') THEN '-1' ELSE '''''' END + ')' [text()]
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName
				AND (l.IsPK = 0 OR @TaskType = 'Type2')
				AND NOT (@TaskType IN ('Type1','Type2') AND l.OrdinalPosition = 1)
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			), 5, 10000000) WhenMatchedAnd
		,SUBSTRING(
			(SELECT ' AND ISNULL(' + 't.' + l.TargetColumnName + ',' + CASE WHEN l.DataType IN ('[int]','[float]','[decimal]') THEN '-1' ELSE '''''' END + ') = ISNULL(s.' + l.SourceColumnName + ',' + CASE WHEN l.DataType IN ('[int]','[float]','[decimal]') THEN '-1' ELSE '''''' END + ')' [text()]
			--(SELECT ' AND t.' + l.TargetColumnName + ' = s.' + l.SourceColumnName [text()] -- ## TD NOTE for Travis - not taking into account the ISNULLS broke some things for me, so I changed it back. Let's discuss.
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName AND l.IsPK = 1
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			), 6, 10000000) MatchOn
		,SUBSTRING(
			(SELECT ', ' + l.TargetColumnName + ' = s.' + l.SourceColumnName [text()]
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName AND l.IsPK <> 1
				AND NOT (@TaskType = 'Type1' AND l.OrdinalPosition = 1)
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			), 3, 10000000) ThenUpdateSet
		,SUBSTRING(
			(SELECT ', ' + l.TargetColumnName [text()]
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName AND l.TargetColumnName <> (CASE WHEN @TaskType = 'insert' THEN '[ID]' ELSE '' END) AND l.IsIdentity <> 1
				AND NOT (@TaskType = 'Type1' AND l.OrdinalPosition = 1)
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			), 3, 10000000) WhenNotMatchedThenInsert
		,SUBSTRING(
			(SELECT ', s.' + l.SourceColumnName [text()]
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName AND l.TargetColumnName <> (CASE WHEN @TaskType = 'insert' THEN '[ID]' ELSE '' END) AND l.IsIdentity <> 1
				AND NOT (@TaskType IN ('Type1','Type2') AND l.OrdinalPosition = 1)
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			), 3, 10000000) InsertValues
		,(
			(SELECT ', ' + l.TargetColumnName + ' ' + l.DataType
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName AND OrdinalPosition <> 1
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			)) ColumnsAndDataTypes
		,SUBSTRING(
			(SELECT ', ' + l.TargetColumnName
			FROM cte l
			WHERE l.SchemaName = a.SchemaName AND l.TableName = a.TableName
				AND NOT (@TaskType = 'Type2' AND l.OrdinalPosition = 1)
			ORDER BY l.OrdinalPosition
			FOR XML PATH ('')
			), 3, 10000000) [Columns]
	FROM cte a	
	) a

END

SET @SQL = @SQL + '
SELECT @RowCountBefore RowCountBefore,@RowCountAfter RowCountAfter,@Inserted Inserted,@Updated Updated,@Deleted Deleted,@Truncated Truncated'

--PRINT CAST(@SQL AS NTEXT)

RETURN @SQL

END

GO
