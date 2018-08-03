SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_src_TI_TK_ODET] 
AS 

	SELECT *
		, HASHBYTES('sha2_256', ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') + ISNULL(RTRIM(I_ACUST),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),I_BAL)),'DBNULL_NUMBER') + ISNULL(RTRIM(I_BPTYPE),'DBNULL_TEXT') + ISNULL(RTRIM(I_CHG),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),I_CPAY)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),I_CPRICE)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),I_DAMT)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),I_DATE)),'DBNULL_DATETIME') + ISNULL(RTRIM(I_DISC),'DBNULL_TEXT') + ISNULL(RTRIM(I_DISP),'DBNULL_TEXT') + ISNULL(RTRIM(I_DMETH),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),I_FPAY)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),I_FPRICE)),'DBNULL_NUMBER') + ISNULL(RTRIM(I_GCDOC),'DBNULL_TEXT') + ISNULL(RTRIM(I_MARK),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),I_OQTY)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(25),I_PAY)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),I_PAYQ)),'DBNULL_INT') + ISNULL(RTRIM(I_PKG),'DBNULL_TEXT') + ISNULL(RTRIM(I_PL),'DBNULL_TEXT') + ISNULL(RTRIM(I_PRI),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),I_PRICE)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),I_PRQTY)),'DBNULL_BIGINT') + ISNULL(RTRIM(I_PT),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),I_SCAMT)),'DBNULL_NUMBER') + ISNULL(RTRIM(I_SCHG),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),I_SCPAY)),'DBNULL_NUMBER') + ISNULL(RTRIM(INREFDATA),'DBNULL_TEXT') + ISNULL(RTRIM(INREFSOURCE),'DBNULL_TEXT') + ISNULL(RTRIM(ITEM),'DBNULL_TEXT') + ISNULL(RTRIM(ITEM_DELIVERY_ID),'DBNULL_TEXT') + ISNULL(RTRIM(ITEM_PREF),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') + ISNULL(RTRIM(LOCATION_PREF),'DBNULL_TEXT') + ISNULL(RTRIM(ORIG_SALECODE),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ORIGTS_DATETIME)),'DBNULL_DATETIME') + ISNULL(RTRIM(ORIGTS_USER),'DBNULL_TEXT') + ISNULL(RTRIM(PROMO),'DBNULL_TEXT') + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SEQ)),'DBNULL_BIGINT') + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') + ISNULL(RTRIM(ZID),'DBNULL_TEXT')) AS ETL_DeltaHashKey
	FROM src.TI_TK_ODET


GO
