SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE PROCEDURE [etl].[Load_FactTicketSales] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'Load_stg_FactTicketSalesBase' step 
	EXEC etl.Load_stg_FactTicketSalesBaseEvents 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'Load_stg_FactTicketSalesBaseItems' step 
	EXEC etl.Load_stg_FactTicketSalesBaseItems 
 
 
	TRUNCATE TABLE dbo.FactTicketSales 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'Load_FactFactTicketSales' step 
	EXEC etl.Load_FactTicketSalesEvents 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'Load_FactFactTicketSalesItems' step 
	EXEC etl.Load_FactTicketSalesItems 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'FactTicketSales REBUILD' step 
	ALTER INDEX ALL ON dbo.FactTicketSales REBUILD 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'Cust_FactTicketSalesProcessing' step 
	IF EXISTS (SELECT * FROM sys.procedures WHERE [object_id] = OBJECT_ID('etl.Cust_FactTicketSalesProcessing')) 
	BEGIN	 
		EXEC etl.Cust_FactTicketSalesProcessing 
	END 
 
	INSERT INTO etl.DimFactLoadLog (CreatedDate, Step) 
	SELECT getdate() ts, 'FactTicketSales REBUILD' step 
	ALTER INDEX ALL ON dbo.FactTicketSales REBUILD 
 
 
 
END 
 
GO
