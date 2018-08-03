SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*****		Revision History

DCH on 2017-09-26:		Initial sproc creation.  Purpose is to create a string of columns... mostly ETL_... to be excluded from the hashkey build in etl.SSB_MergeHashFieldSyntax.


*****/


CREATE PROCEDURE [etl].[SSB_ExcludedHashColumns]
(
	@Source			nvarchar(255),
	@AddlColumns	nvarchar(255) = NULL
)  
AS
BEGIN 
	declare @ExcludedColumns		nvarchar(255),
			@SourceSchema			nvarchar(255),
			@SourceTable			nvarchar(255),
			@tmp_ExcludedColumns	nvarchar(255),
			@loopcounter			int,
			@maxloop				int;


	set @SourceSchema =	(select LEFT(@Source, CHARINDEX('.',@Source)-1));
	set @SourceTable =	(select SUBSTRING(@Source, CHARINDEX('.',@Source)+1, LEN(@Source)));


	select c.name as columnName, ROW_NUMBER() over (Partition By 1 Order By c.column_id) as rownum
	into #columns
	from sys.tables t
	join sys.schemas s
		on t.schema_id = s.schema_id
		and s.name = @SourceSchema
	join sys.columns c
		on t.object_id = c.object_id
		and t.name = @SourceTable
		and LEFT(c.name,4) = 'ETL_';


	set @maxloop = (select ISNULL(MAX(rownum),0) from #columns);
	set @loopcounter = 1;


	while @loopcounter <= @maxloop
	begin
		set @tmp_ExcludedColumns = (select CASE WHEN @loopcounter = 1 THEN columnName ELSE CONCAT(@tmp_ExcludedColumns,',',columnName) END from #columns where rownum = @loopcounter);
		
		set @loopcounter = @loopcounter+1;
	end 


	set @ExcludedColumns = (select CASE WHEN ISNULL(@AddlColumns,'') = '' THEN @tmp_ExcludedColumns ELSE CONCAT(@tmp_ExcludedColumns,',',@AddlColumns) END);


	select @ExcludedColumns; 
END 







GO
