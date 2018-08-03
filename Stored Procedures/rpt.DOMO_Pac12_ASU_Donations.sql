SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[DOMO_Pac12_ASU_Donations]
AS
    TRUNCATE TABLE [etl].[DOMO_Pac12_ExportFile_ASU_Donation]

	    IF OBJECT_ID('tempdb..#output') IS NOT NULL
        DROP TABLE #output

    CREATE TABLE #output
        (
          TX_NUMBER VARCHAR(10)
        , ID_NUMBER VARCHAR(10)
        , PACIOLAN_ID VARCHAR(10)
        , CAMPAIGN_CODE VARCHAR(5)
        , DATE_OF_RECORD DATE
        , ATHLETIC_FUND_DESC VARCHAR(40)
        , TRANS_TYPE_DESC VARCHAR(40)
        , NET_LEGAL_AMOUNT FLOAT
        , BATCH_NUMBER VARCHAR(10)
        , ALLOC_CODE VARCHAR(16)
        , ALLOC_DESC VARCHAR(255)
        , AGENCY_DESC VARCHAR(40)
        , PAYMENT_TYPE_DESC VARCHAR(40)
        , BATCH_PROCESSED_DATE DATE
        , RECORD_OPERATOR_NAME VARCHAR(32)
        , MATCHING_COMPANY_ID VARCHAR(10)
        , MATCHED_RECEIPT_NBR VARCHAR(10)
        );

with sdpids(id_number, other_id) as
(
select ID_NUMBER, other_id from FD_SDA_ENTITY_OTHER_IDS WITH (NOLOCK) where TYPE_CODE='SDP'
)



  INSERT  INTO #output
          ( TX_NUMBER
          , ID_NUMBER
          , PACIOLAN_ID
          , CAMPAIGN_CODE
          , DATE_OF_RECORD
          , ATHLETIC_FUND_DESC
          , TRANS_TYPE_DESC
          , NET_LEGAL_AMOUNT
          , BATCH_NUMBER
          , ALLOC_CODE
          , ALLOC_DESC
          , AGENCY_DESC
          , PAYMENT_TYPE_DESC
          , BATCH_PROCESSED_DATE
          , RECORD_OPERATOR_NAME
          , MATCHING_COMPANY_ID
          , MATCHED_RECEIPT_NBR
          )

/*Consolidate all records that have a pac ID in dbo.FD_SDA_ENTITY_OTHER_IDS
pulling the id_number that has been flagged as the primary*/



SELECT  fd.TX_NUMBER
                , primaryID.ID_NUMBER
                , fd.PACIOLAN_ID
                , fd.CAMPAIGN_CODE
                , fd.DATE_OF_RECORD
                , fd.ATHLETIC_FUND_DESC
                , fd.TRANS_TYPE_DESC
                , SUM(fd.NET_LEGAL_AMOUNT) NET_LEGAL_AMOUNT
                , fd.BATCH_NUMBER
                , fd.ALLOC_CODE
                , fd.ALLOC_DESC
                , fd.AGENCY_DESC
                , fd.PAYMENT_TYPE_DESC
                , fd.BATCH_PROCESSED_DATE
                , fd.RECORD_OPERATOR_NAME
                , fd.MATCHING_COMPANY_ID
                , fd.MATCHED_RECEIPT_NBR
          FROM    dbo.FD_SDA_TRANSACTION_DETAIL fd WITH (NOLOCK)
                  JOIN
                   sdpids primaryID ON fd.PACIOLAN_ID = primaryID.OTHER_ID
          GROUP BY fd.TX_NUMBER
                , primaryID.ID_NUMBER
                , fd.PACIOLAN_ID
                , fd.CAMPAIGN_CODE
                , fd.DATE_OF_RECORD
                , fd.ATHLETIC_FUND_DESC
                , fd.TRANS_TYPE_DESC
                , fd.BATCH_NUMBER
                , fd.ALLOC_CODE
                , fd.ALLOC_DESC
                , fd.AGENCY_DESC
                , fd.PAYMENT_TYPE_DESC
                , fd.BATCH_PROCESSED_DATE
                , fd.RECORD_OPERATOR_NAME
                , fd.MATCHING_COMPANY_ID
                , fd.MATCHED_RECEIPT_NBR

                 UNION ALL

/*pull in any remaining records that don't have a pac ID in dbo.FD_SDA_ENTITY_OTHER_IDS.
  These records aren't consolidated since the primary donor cannot be determined*/

SELECT  fd.TX_NUMBER
                , fd.ID_NUMBER
                , NULL AS PACIOLAN_ID
                , fd.CAMPAIGN_CODE
                , fd.DATE_OF_RECORD
                , fd.ATHLETIC_FUND_DESC
                , fd.TRANS_TYPE_DESC
                , fd.NET_LEGAL_AMOUNT
                , fd.BATCH_NUMBER
                , fd.ALLOC_CODE
                , REPLACE(ALLOC_DESC, '"', '''') ALLOC_DESC
                , fd.AGENCY_DESC
                , fd.PAYMENT_TYPE_DESC
                , fd.BATCH_PROCESSED_DATE
                , fd.RECORD_OPERATOR_NAME
                , fd.MATCHING_COMPANY_ID
                , fd.MATCHED_RECEIPT_NBR
          FROM    dbo.FD_SDA_TRANSACTION_DETAIL fd WITH (NOLOCK)
           left join sdpids oi
           on fd.PACIOLAN_ID=oi.OTHER_ID
           where oi.other_id is null


    INSERT  INTO [etl].[DOMO_Pac12_ExportFile_ASU_Donation]
            SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID
                  , TX_NUMBER
                  , ID_NUMBER
                  , PACIOLAN_ID
                  , CAMPAIGN_CODE
                  , DATE_OF_RECORD
                  , ATHLETIC_FUND_DESC
                  , TRANS_TYPE_DESC
                  , NET_LEGAL_AMOUNT
                  , BATCH_NUMBER
                  , ALLOC_CODE
                  , REPLACE(ALLOC_DESC, '"', '''') ALLOC_DESC
                  , AGENCY_DESC
                  , MATCHING_COMPANY_ID
                  , MATCHED_RECEIPT_NBR
                  , NULL AS MatchAmount
                  , NULL AS MatchingGift
                  , PAYMENT_TYPE_DESC
                  , BATCH_PROCESSED_DATE
                  , RECORD_OPERATOR_NAME
            FROM    #output
                    LEFT JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON ssbid.SSID = PACIOLAN_ID


GO
