SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[vw__ASU_SDC_Advance_UserDefinedFields] AS 

SELECT  a.PACIOLAN_ID,
        a.TOTAL_POINTS ,
        a.RANKING ,
        REPLACE(b.Active_Membership_Level, 'SDC - ', '') AS Active_Membership_Level ,
        b.Active_Total_Giving_Amount ,
        b.Active_Year ,
        REPLACE(c.Future_Membership_Level, 'SDC - ', '') AS Future_Membership_Level ,
        c.Future_Total_Giving_Amount ,
        c.Future_Year
FROM    ( SELECT    PACIOLAN_ID ,
                    TOTAL_POINTS ,
                    RANKING
          FROM      [dbo].[FD_SDA_PRIORITY_POINT_SUMMARY] points
        ) a
        LEFT JOIN ( SELECT  otherid.OTHER_ID AS Paciolan_ID ,
                            gc.GIFT_CLUB_DESC AS Active_Membership_Level ,
                            gc.QUALIFIED_AMOUNT AS Active_Total_Giving_Amount ,
                            gc.GIFT_CLUB_YEAR AS Active_Year
                    FROM    [dbo].[FD_SDC_GIFT_CLUBS] gc
                            JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] otherid ON gc.GIFT_CLUB_ID_NUMBER = otherid.ID_NUMBER
                    WHERE   otherid.TYPE_CODE = 'SDP'
                            AND gc.GIFT_CLUB_STATUS = 'A'
                  ) b ON b.Paciolan_ID = a.PACIOLAN_ID
        LEFT JOIN ( SELECT  otherid.OTHER_ID AS Paciolan_ID ,
                            gc.GIFT_CLUB_DESC AS Future_Membership_Level ,
                            gc.QUALIFIED_AMOUNT AS Future_Total_Giving_Amount ,
                            gc.GIFT_CLUB_YEAR AS Future_Year ,
                            gc.GIFT_CLUB_STATUS
                    FROM    [dbo].[FD_SDC_GIFT_CLUBS] gc
                            JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] otherid ON gc.GIFT_CLUB_ID_NUMBER = otherid.ID_NUMBER
                    WHERE   otherid.TYPE_CODE = 'SDP'
                            AND gc.GIFT_CLUB_YEAR = (SELECT MIN(CAST(GIFT_CLUB_YEAR AS INT)+1) FROM [dbo].[FD_SDC_GIFT_CLUBS] WHERE GIFT_CLUB_STATUS = 'A')
                  ) c ON c.Paciolan_ID = a.PACIOLAN_ID




GO
