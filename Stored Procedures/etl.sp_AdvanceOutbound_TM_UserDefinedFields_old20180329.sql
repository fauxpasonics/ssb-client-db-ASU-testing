SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














CREATE PROC [etl].[sp_AdvanceOutbound_TM_UserDefinedFields_old20180329]
AS
BEGIN


IF EXISTS (select * from sys.tables where name = 'AdvanceOutbound_TM_UserDefinedFields' and type = 'U')
	DROP TABLE stg.AdvanceOutbound_TM_UserDefinedFields;

SELECT  CAST(NULL as binary(32)) as ETL_DeltaHashKey, 
		CAST(cust.acct_id AS nvarchar(255)) AS acct_id, --Ticketmaster AccountId
        CAST(ISNULL(a.TOTAL_POINTS, points.TOTAL_POINTS) AS nvarchar(255)) AS other_info_1, --Priority Points
        CAST(a.RANKING AS nvarchar(255)) AS other_info_2, --Rank
        CAST(REPLACE(b.Active_Membership_Level, 'SDC - ', '') AS nvarchar(255)) AS other_info_3 ,--Membership Level
        CAST(b.Active_Total_Giving_Amount AS nvarchar(255))  AS other_info_4, --Total GIving Amount
        CAST(b.Active_Year AS nvarchar(255)) AS other_info_5 , -- Year
        CAST(REPLACE(c.Future_Membership_Level, 'SDC - ', '') AS nvarchar(255)) AS other_info_6, --Future Level
        CAST(c.Future_Total_Giving_Amount AS nvarchar(255))AS other_info_7 , --Future Giving
        CAST(c.Future_Year AS nvarchar(255)) AS other_info_8 --Future Year
INTO stg.AdvanceOutbound_TM_UserDefinedFields 
FROM  ods.TM_Cust cust (NOLOCK)
INNER JOIN [dbo].[FD_SDA_PRIORITY_POINT_SUMMARY] points (NOLOCK)
	ON cust.acct_id = points.PACIOLAN_ID and cust.Primary_Code = 'Primary'
LEFT JOIN [dbo].[Priority_Points_StaticFileforMay2017Relocation] a (NOLOCK)
	ON points.PACIOLAN_ID = a.SDC_ID



/*** THIS IS THE NORMAL PRIORITY POINTS LOGIC, 
using different logic through reseat process
 
update join and select statment accordingly
********/
		--( SELECT   DISTINCT PACIOLAN_ID ,
  --                  TOTAL_POINTS ,
  --                  RANKING
  --        FROM      [dbo].[FD_SDA_PRIORITY_POINT_SUMMARY] points (NOLOCK)
		--  INNER JOIN [ods].[TM_Cust] c (NOLOCK) on points.PACIOLAN_ID = c.acct_id AND Primary_code = 'Primary'
		--  --INNER JOIN ods.TM_Ticket t on c.acct_id = t.acct_id -- added for testing athletic staff
		--  --where comp_name = 'ASC' -- added for testing athletic staff
  --      ) a
        LEFT JOIN ( SELECT  otherid.OTHER_ID AS SDC_ID ,
							gc.GIFT_CLUB_CODE Active_Year_Gift_Club_Code ,
                            gc.GIFT_CLUB_DESC AS Active_Membership_Level ,
                            gc.QUALIFIED_AMOUNT AS Active_Total_Giving_Amount ,
                            gc.GIFT_CLUB_YEAR AS Active_Year
                   FROM    [dbo].[FD_SDC_GIFT_CLUBS] gc (NOLOCK)
                            JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] otherid (NOLOCK) ON gc.GIFT_CLUB_ID_NUMBER = otherid.ID_NUMBER
							INNER JOIN  (SELECT GIFT_CLUB_ID_NUMBER, GIFT_CLUB_CODE, GIFT_CLUB_YEAR, ROW_NUMBER() OVER(PARTITION BY GIFT_CLUB_ID_NUMBER ORDER BY QUALIFIED_AMOUNT DESC, Date_MODIFIED) xRank 
										 FROM [dbo].[FD_SDC_GIFT_CLUBS] gc 
										  WHERE gc.GIFT_CLUB_STATUS = 'A'
										) x
							ON gc.GIFT_CLUB_ID_NUMBER = x.GIFT_CLUB_ID_NUMBER 
								AND gc.GIFT_CLUB_CODE = x.GIFT_CLUB_CODE
								AND gc.GIFT_CLUB_YEAR = x.GIFT_CLUB_YEAR
								AND x.xRank = '1'
				    WHERE   otherid.TYPE_CODE = 'SDP'
                            AND gc.GIFT_CLUB_STATUS = 'A'
                  ) b ON b.SDC_ID = points.PACIOLAN_ID
		 	
        LEFT JOIN ( SELECT  otherid.OTHER_ID AS SDC_ID ,
							gc.GIFT_CLUB_CODE AS Future_Gift_Club_Code ,
                            gc.GIFT_CLUB_DESC AS Future_Membership_Level ,
                            gc.QUALIFIED_AMOUNT AS Future_Total_Giving_Amount ,
                            gc.GIFT_CLUB_YEAR AS Future_Year ,
                            gc.GIFT_CLUB_STATUS
                    FROM    [dbo].[FD_SDC_GIFT_CLUBS] gc (NOLOCK)
                            JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] otherid (NOLOCK) ON gc.GIFT_CLUB_ID_NUMBER = otherid.ID_NUMBER
							INNER JOIN  (SELECT GIFT_CLUB_ID_NUMBER, GIFT_CLUB_CODE, GIFT_CLUB_YEAR, ROW_NUMBER() OVER(PARTITION BY GIFT_CLUB_ID_NUMBER ORDER BY QUALIFIED_AMOUNT DESC, Date_MODIFIED) xRank 
										 FROM [dbo].[FD_SDC_GIFT_CLUBS] gc (NOLOCK)
										 WHERE gc.GIFT_CLUB_YEAR = (SELECT MIN(CAST(GIFT_CLUB_YEAR AS INT)+1) FROM [dbo].[FD_SDC_GIFT_CLUBS] WHERE GIFT_CLUB_STATUS = 'A')
										) x
							ON gc.GIFT_CLUB_ID_NUMBER = x.GIFT_CLUB_ID_NUMBER 
								AND gc.GIFT_CLUB_CODE = x.GIFT_CLUB_CODE
								AND gc.GIFT_CLUB_YEAR = x.GIFT_CLUB_YEAR
								AND x.xRank = '1'
					WHERE   otherid.TYPE_CODE = 'SDP'
                            AND gc.GIFT_CLUB_YEAR = (SELECT MIN(CAST(GIFT_CLUB_YEAR AS INT)+1) FROM [dbo].[FD_SDC_GIFT_CLUBS] WHERE GIFT_CLUB_STATUS = 'A')
                  ) c ON c.SDC_ID = points.PACIOLAN_ID
WHERE  cust.other_info_1 <> ISNULL(a.TOTAL_POINTS, points.TOTAL_POINTS)
OR cust.other_info_2 <> CAST(a.RANKING AS nvarchar(255))
OR cust.other_info_3 <> CAST(REPLACE(b.Active_Membership_Level, 'SDC - ', '') AS nvarchar(255))
OR cust.other_info_4 <> CAST(b.Active_Total_Giving_Amount AS nvarchar(255))
OR cust.other_info_5 <> CAST(b.Active_Year AS nvarchar(255))
OR cust.other_info_6 <> CAST(REPLACE(c.Future_Membership_Level, 'SDC - ', '') AS nvarchar(255)) 
OR cust.other_info_7 <> CAST(c.Future_Total_Giving_Amount AS nvarchar(255))
OR cust.other_info_8 <> CAST(c.Future_Year AS nvarchar(255))



UNION ALL

--ASU dummy account to return all fields - do not remove!

select CAST(NULL as binary(32)) as ETL_DeltaHashKey
, CAST(acct_id AS nvarchar(255)) AS acct_id
, other_info_1
, other_info_2
, other_info_3
, other_info_4
, other_info_5
, other_info_6
, other_info_7
, other_info_8

from ods.TM_Cust c (NOLOCK) 
WHERE acct_id = '4264598'

-------------------------


--	set list of excluded columns to be omitted from hashkey build
DECLARE @ExcludedHashColumns VARCHAR(MAX);
DECLARE	@ExcludedHashColumnsTbl TABLE (ExcludedColumns VARCHAR(MAX));
INSERT @ExcludedHashColumnsTbl (ExcludedColumns)
	EXEC etl.SSB_ExcludedHashColumns 'stg.AdvanceOutbound_TM_UserDefinedFields','QueueID';
SET @ExcludedHashColumns = (SELECT TOP 1 ExcludedColumns FROM @ExcludedHashColumnsTbl); 


--	build hashkey for comparison in merge
DECLARE @HashSyntax VARCHAR(MAX);
DECLARE	@HashTbl TABLE (HashSyntax VARCHAR(MAX));
INSERT @HashTbl (HashSyntax)
	EXEC etl.SSB_MergeHashFieldSyntax 'stg.AdvanceOutbound_TM_UserDefinedFields', @ExcludedHashColumns;
SET @HashSyntax = (SELECT TOP 1 HashSyntax FROM @HashTbl);


DECLARE @SQL nvarchar(MAX);
SET @SQL = CONCAT('UPDATE stg.AdvanceOutbound_TM_UserDefinedFields SET ETL_DeltaHashKey = ', @HashSyntax, ';');
EXEC (@SQL);


--truncate table [ods].[AdvanceOutbound_TM_UserDefinedFields]
MERGE [ods].[AdvanceOutbound_TM_UserDefinedFields] AS myTarget
USING (SELECT *
		FROM stg.AdvanceOutbound_TM_UserDefinedFields) AS mySource
ON mySource.acct_id = myTarget.acct_id

WHEN MATCHED
AND ISNULL(myTarget.ETL_DeltaHashKey,-1) <> ISNULL(mySource.ETL_DeltaHashKey,-1)
THEN UPDATE SET

		 myTarget.acct_id						= mysource.acct_id
		 ,myTarget.other_info_1					= mysource.other_info_1	
		 ,myTarget.other_info_2					= mysource.other_info_2
		 ,myTarget.other_info_3					= mysource.other_info_3
		 ,myTarget.other_info_4					= mysource.other_info_4
		 ,myTarget.other_info_5					= mysource.other_info_5
		 ,myTarget.other_info_6					= mysource.other_info_6
		 ,myTarget.other_info_7					= mysource.other_info_7
		 ,myTarget.other_info_8					= mysource.other_info_8
		 ,mytarget.ETL__CreatedDate			        = GETDATE()
		 ,mytarget.ETL_DeltaHashKey			        = mySource.ETL_DeltaHashKey

WHEN NOT MATCHED THEN
INSERT (
        acct_id
		, other_info_1
		, other_info_2
		, other_info_3
		, other_info_4
		, other_info_5
		, other_info_6
		, other_info_7
		, other_info_8
		,ETL__CreatedDate
	    ,ETL_DeltaHashKey

		
		 )
VALUES (	 
              mysource.acct_id
			, mysource.other_info_1
			, mysource.other_info_2
			, mysource.other_info_3
			, mysource.other_info_4
			, mysource.other_info_5
			, mysource.other_info_6
			, mysource.other_info_7
			, mysource.other_info_8
			 ,GETDATE()
	         ,mySource.ETL_DeltaHashKey
			 );


	END	
		

	
GO
