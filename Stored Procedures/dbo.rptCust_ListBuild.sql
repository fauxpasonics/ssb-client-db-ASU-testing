SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[rptCust_ListBuild] (@ReportType VARCHAR(10), @Campaign VARCHAR(100), @StartDate DATETIME, @EndDate DATETIME, @AllocDesc VARCHAR(MAX))
AS


create TABLE #CampaignDates (CampaignName varchar(100), StartDate datetime, EndDate Datetime)

INSERT #CampaignDates VALUES ('SC12','07/01/2011','06/30/2012')
INSERT #CampaignDates VALUES ('SC13','07/01/2012','06/30/2013')
INSERT #CampaignDates VALUES ('SC14','07/01/2013','06/30/2014')
INSERT #CampaignDates VALUES ('SC15','07/01/2014','06/30/2015')
INSERT #CampaignDates VALUES ('SC16','07/01/2015','06/30/2016')
INSERT #CampaignDates VALUES ('SC17','07/01/2016','06/30/2017')

SELECT 
 bio.ID_NUMBER
,ids.OTHER_ID PaciolanId 
,PREFIX
,FIRST_NAME
,MIDDLE_NAME
,LAST_NAME
,SUFFIX
,PREF_MAIL_NAME
,RECORD_STATUS_DESC
,PERSON_OR_ORG
,PREF_ADDR_LABEL
,SALUTATION
,PREF_PHONE
,PREF_NO_CONTACT_FLAG
,PREF_PHONE_NO_SOLICIT_FLAG
,PRIMARY_EMAIL
,PRIMARY_EMAIL_NO_CONTACT_FLAG
,PRIMARY_EMAIL_NO_SOLICIT_FLAG
,ISNULL(ATHLETIC_FUND_DESC,'Blank/Missing') ATHLETIC_FUND_DESC
,SUM(trans.NET_LEGAL_AMOUNT) Total 

FROM 
 dbo.FD_SDA_TRANSACTION_DETAIL trans WITH (NOLOCK) 
   INNER JOIN  dbo.FD_SDA_ENTITY_OTHER_IDS ids WITH (NOLOCK)
       ON trans.PACIOLAN_ID = ids.OTHER_ID 
   INNER JOIN dbo.FD_SDA_ENTITY_BIOGRAPHIC bio WITH (NOLOCK)
       ON bio.ID_NUMBER = ids.ID_NUMBER 
   LEFT JOIN #CampaignDates cd ON (trans.CAMPAIGN_CODE IS NULL AND Date_Of_Record BETWEEN cd.StartDate AND cd.EndDate AND CampaignName IN (SELECT s FROM [dbo].[fnSplitDelimString] (',',@Campaign))) OR trans.CAMPAIGN_CODE IN (SELECT s FROM [dbo].[fnSplitDelimString] (',',@Campaign))
WHERE ids.TYPE_CODE = 'SDP' --not param need to have 
AND 
(
(DATE_OF_RECORD BETWEEN @StartDate AND @EndDate AND @ReportType <> 'Campaign') OR (@ReportType = 'Campaign' AND cd.CampaignName IS NOT NULL)  -- 2015 campain is set param
)
--category allocation params need to default to all 
AND ALLOC_CODE IN (SELECT s FROM [dbo].[fnSplitDelimString] (',',@AllocDesc))
GROUP BY 
 bio.ID_NUMBER
,ids.OTHER_ID
,PREFIX
,FIRST_NAME
,MIDDLE_NAME
,LAST_NAME
,SUFFIX
,PREF_MAIL_NAME
,RECORD_STATUS_DESC
,PERSON_OR_ORG
,PREF_ADDR_LABEL
,SALUTATION
,PREF_PHONE
,PREF_NO_CONTACT_FLAG
,PREF_PHONE_NO_SOLICIT_FLAG
,PRIMARY_EMAIL
,PRIMARY_EMAIL_NO_CONTACT_FLAG
,PRIMARY_EMAIL_NO_SOLICIT_FLAG
,ISNULL(ATHLETIC_FUND_DESC,'Blank/Missing') 
GO
