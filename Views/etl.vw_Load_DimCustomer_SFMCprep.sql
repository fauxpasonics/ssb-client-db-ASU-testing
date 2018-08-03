SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** 
Created by AMeitin 2017/05/01 to help with DimCustomer loading process
2017/12/11 - Added OptInSubscribers AMEITIN

******/



CREATE VIEW  [etl].[vw_Load_DimCustomer_SFMCprep] 
AS
    WITH    column_check
              AS (
                   SELECT   sa.SubscriberID
						  , sa.SubscriberKey
						  , ss.EmailAddress
                          , ss.[Status]
                          , CASE WHEN sa.FirstName = 'Sun Devil' THEN NULL ELSE sa.FirstName END AS FirstName
                          , sa.LastName
						  , sa.ASU_ATHLETICS
                          , ss.DateHeld
                          , ss.DateCreated
						  , ss.ETL_UpdatedDate
                          , ss.DateUnsubscribed
						  , CASE WHEN de.Emailaddress IS NOT NULL THEN 1 ELSE 0 END AS OptInSubscriber
                          , LEN(ISNULL(sa.FirstName, '')
                                + ISNULL(sa.LastName, '')) AS ColumnCount
                   FROM     ods.SFMC_Subscribers AS ss WITH (NOLOCK) 
                            LEFT JOIN ods.SFMC_Attributes AS sa WITH (NOLOCK)  ON sa.SUbscriberId = ss.SubscriberId
							LEFT JOIN ods.SFMC_OptInFormDataExtension AS de WITH (NOLOCK) ON ss.EmailAddress = de.EmailAddress
				   WHERE sa.ASU_ATHLETICS = 1  --DO NOT REMOVE THIS CRITERIA. THIS LIMITS TO ONLY ATHLETICS SUBSCRIBERS
                 )
    SELECT  column_check.SubscriberID
		  , column_check.SubscriberKey
		  , column_check.EmailAddress
          , column_check.[Status]
          , column_check.FirstName
          , column_check.LastName
		  , column_check.ASU_ATHLETICS
          , column_check.DateHeld
          , column_check.DateCreated
          , column_check.DateUnsubscribed
          , column_check.ColumnCount
		  , COLUMN_check.ETL_UpdatedDate
          , ROW_NUMBER() OVER ( PARTITION BY column_check.EmailAddress ORDER BY column_check.ColumnCount DESC ) AS contact_rank
    FROM    column_check
	WHERE column_check.OptInSubscriber = 1
	OR FirstName IS NOT NULL; --Not sure if I should load records that do not have a complete name AMEITIN 2017/05/01









GO
