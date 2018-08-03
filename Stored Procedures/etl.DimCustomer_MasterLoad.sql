SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN


-- TI --removed 8/7/2017  AMEITIN
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'ASU', @LoadView = 'etl.vw_TI_Load_DimCustomer', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- TM --added 8/7/2017  AMEITIN
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'ASU', @LoadView = '[ods].[vw_TM_LoadDimCustomer]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Advance
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'ASU', @LoadView = '[etl].[vw_Load_DimCustomer_Advance]', @LogLevel = '0', @DropTemp = '0', @IsDataUploaderSource = '0'


-- SFMC (Added May 2017 by AMeitin)
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'ASU', @LoadView = '[etl].[vw_Load_DimCustomer_SFMC]', @LogLevel = '0', @DropTemp = '0', @IsDataUploaderSource = '0'


-- SFDC (Added 5/18/2017 by AMeitin)
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'ASU', @LoadView = 'etl.vw_Load_DimCustomer_SFDCAccount', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


--SFDC deletes (Added 5/18/2017 by AMeitin)
UPDATE b
	SET b.IsDeleted = a.IsDeleted
	,deletedate = GETDATE()
	--SELECT a.IsDeleted
	--SELECT COUNT(*) 
	FROM ASU_Reporting.ProdCopy.Account a 
	INNER JOIN dbo.DimCustomer b ON a.id = b.SSID AND b.SourceSystem = 'ASU PC_SFDC Account'
	WHERE a.IsDeleted <> b.IsDeleted

-- TM Deletes (Added 4/23/20018 by KSniffin)
UPDATE dc
SET dc.IsDeleted = 1
FROM dbo.dimcustomer dc (NOLOCK)
LEFT JOIN ods.TM_Cust tmc (NOLOCK)
	ON dc.SSID = CONCAT(tmc.acct_id, ':', tmc.cust_name_id)
WHERE dc.SourceSystem = 'TM'
	AND tmc.acct_id IS null



END













GO
