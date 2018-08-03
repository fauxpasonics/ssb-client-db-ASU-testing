SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[rptCustPriorityPoints_1_DEV]
AS

BEGIN

SET TRAN ISOLATION LEVEL READ COMMITTED

SELECT
	o.id_number AS ADVANCE_ID
	, pps.paciolan_id AS SDC_ID
	, eb.pref_mail_name AS NAME
	, pps.SUN_DEVIL_CLUB_POINTS AS CONSECUTIVE_MEMBER_POINTS
	, pps.LETTER_WINNER_POINTS AS LETTER_WINNER_POINTS
	, pps.SEASON_TICKET_POINTS AS SEASON_TICKET_POINTS
	, pps.CONTIBUTIONS_POINTS AS SDC_CUMULATIVE_CONTRIB_POINTS
	, pps.MISC_ADJUSTMENT_POINTS AS MISCELLANEOUS_ADJUST_POINTS
	, pps.total_points AS TOTAL_POINTS
	, pps.RANKING AS POINT_RANK
	, udf.Active_Membership_Level	
	, udf.Active_Total_Giving_Amount	
	, udf.Active_Year	
	, udf.Future_Membership_Level	
	, udf.Future_Total_Giving_Amount	
	, udf.Future_Year
FROM[dbo].[FD_SDA_PRIORITY_POINT_SUMMARY] pps WITH (NOLOCK)
	LEFT JOIN dbo.FD_SDA_ENTITY_OTHER_IDS o WITH (NOLOCK) ON pps.PACIOLAN_ID = o.OTHER_ID
	LEFT JOIN dbo.FD_SDA_ENTITY_BIOGRAPHIC eb WITH (NOLOCK) ON o.ID_NUMBER = eb.ID_NUMBER
	LEFT JOIN (SELECT ssbid2.ssid AS ADVANCE_ID 
					, udf.* 
			   FROM [dbo].[vw__ASU_SDC_Advance_UserDefinedFields] udf WITH (NOLOCK) 
					JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON ssbid.ssid = udf.PACIOLAN_ID
													AND ssbid.SourceSystem = 'TI ASU'
													AND ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
					JOIN dbo.dimcustomerssbid ssbid2 WITH (NOLOCK) ON ssbid2.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
																 AND ssbid2.SourceSystem = 'Advance ASU'
																 AND ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
				)udf ON udf.ADVANCE_ID = o.ID_NUMBER
WHERE o.TYPE_CODE = 'SDP'
	  AND pps.TOTAL_POINTS > 0
ORDER BY POINT_RANK

END


GO
