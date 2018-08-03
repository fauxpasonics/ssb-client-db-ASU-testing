SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_src_TI_TK_ODET_EVENT_ASSOC]
AS
	SELECT *
		, HASHBYTES('sha2_256', ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),E_ADATE)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),E_CPRICE)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),E_DAMT)),'DBNULL_NUMBER') + ISNULL(RTRIM(E_FEE),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),E_FPRICE)),'DBNULL_NUMBER') + ISNULL(RTRIM(E_PL),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),E_PQTY)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(25),E_PRICE)),'DBNULL_NUMBER') + ISNULL(RTRIM(E_SBLS),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),E_SCAMT)),'DBNULL_NUMBER') + ISNULL(RTRIM(E_STAT),'DBNULL_TEXT') + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') + ISNULL(RTRIM(EVENT),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SEQ)),'DBNULL_BIGINT') + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') + ISNULL(RTRIM(VMC),'DBNULL_TEXT') + ISNULL(RTRIM(ZID),'DBNULL_TEXT')) AS ETL_DeltaHashKey
	FROM src.TI_TK_ODET_EVENT_ASSOC

GO
