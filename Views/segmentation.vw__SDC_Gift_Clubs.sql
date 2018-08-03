SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Created By: Abbey Meitin
-- Create Date: before we tracked
-- Reviewed By: 
-- Reviewed Date: 
-- Description: ASU Sun Devil Club Gift Clubs
-- =============================================
 
/***** Revision History
 
Abbey Meitin on 2018-07/24: Added additional codes to the Seat Related Contributions, Reviewed By: Payton SOicher 2018/07/26
 
*****/

CREATE VIEW [segmentation].[vw__SDC_Gift_Clubs]

AS
(
SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID
, gc.GIFT_CLUB_ID_NUMBER
, gc.GIFT_CLUB_CODE
, gc.GIFT_CLUB_DESC
, ISNULL(gc.QUALIFIED_AMOUNT,0) AS GIFT_CLUB_QUALIFIED_AMOUNT
, gc.GIFT_CLUB_YEAR
, gc.GIFT_CLUB_STATUS
, gc.DATE_ADDED AS GIFT_CLUB_DATE_ADDED
, gc.DATE_MODIFIED AS GIFT_CLUB_DATE_MODIFIED 
, ISNULL(x.SEATGIVING,0) AS SEATGIVING
, ISNULL(gc.QUALIFIED_AMOUNT,0) - ISNULL(x.SEATGIVING,0) AS PHILANTHROPIC_AMOUNT
FROM [dbo].[FD_SDC_GIFT_CLUBS] gc WITH (NOLOCK)
	JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON ssbid.sourcesystem = 'Advance ASU' AND ssbid.SSID = gc.GIFT_CLUB_ID_NUMBER
	LEFT JOIN (SELECT OTHER_ID, oid.ID_NUMBER 
				FROM dbo.FD_SDA_ENTITY_OTHER_IDS oid WITH (NOLOCK)
				WHERE oid.TYPE_CODE IN ('SDP', 'SDJ')) AllSDC ON AllSDC.ID_NUMBER = gc.GIFT_CLUB_ID_NUMBER
	LEFT JOIN (( SELECT DISTINCT seatgifts.PACIOLAN_ID
								,FISCAL_YEAR
								,SUM(NET_LEGAL_AMOUNT)  AS SEATGIVING	
				FROM (  SELECT  PACIOLAN_ID
								,CASE WHEN campaign_code LIKE 'SC%' THEN RIGHT(campaign_code,2) ELSE RIGHT(FISCAL_YEAR,2) END AS FISCAL_YEAR
								,NET_LEGAL_AMOUNT
						FROM    [dbo].[FD_SDA_TRANSACTION_DETAIL] trans WITH (NOLOCK)
						WHERE   (trans.CAMPAIGN_CODE LIKE 'SC%' OR trans.CAMPAIGN_CODE = '')
								AND ALLOC_CODE IN ('95106029'          --Football Suite Seat Contribution
													,'95006010'          --Football Seat Contribution
													,'95007806'          --North Terrace Club Football Seat Premium
													,'95106049'          --MidFirst Club Seat Contribution
													,'95007015'          --Legend's Club Seat Contributions
													,'95006029'          --Football Suite Seat Contribution
													,'95006004'          --Basketball Seat Contribution
													,'30007266'          --Sun Devil Club Football Seat Contributions
													,'95006049'          --MidFirst Club Seat Contribution
													,'30007265'          --Sun Devil Club Basketball Seat Contributions
													 )
								AND GYPMD_DESC LIKE '%Gift%'
								AND ISNULL(trans.PACIOLAN_ID,'')<>''		
						) seatgifts
			  GROUP BY seatgifts.PACIOLAN_ID, seatgifts.FISCAL_YEAR)) x ON x.PACIOLAN_ID = AllSDC.OTHER_ID AND FISCAL_YEAR = RIGHT(gc.GIFT_CLUB_YEAR,2)
)

GO
