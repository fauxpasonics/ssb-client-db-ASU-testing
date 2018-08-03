SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  VIEW [segmentation].[vw__Ticket_Exchange_Originator] AS 

        SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
			  , DimCustomer.AccountId AS O_Archtics_Acct_Id
			  , Tex.activity AS O_Activity
			  , Tex.activity_name AS O_Activity_Name
			  , CAST(Tex.add_datetime AS DATE) AS O_Transaction_Date 
              , Tex.season_year AS O_Season_Year
              , Tex.event_name AS O_Event_Code
			  , Event.Team AS O_Event_Name 
              , CAST(Tex.event_time AS NVARCHAR(50)) AS O_Event_Time
              , Tex.event_date AS O_Event_Date
              , Tex.section_name AS O_Section_Name
              , Tex.row_name AS O_Row_Name
              , Tex.seat_num AS O_First_Seat
              --, Tex.last_seat AS O_Last_Seat
              , Tex.num_seats AS O_Qty_Seat
              , CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					CAST(Tex.Orig_purchase_price AS NUMERIC (18,2) )  * Tex.num_seats END AS O_Orig_purchase_price
              , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END AS O_TE_Purchase_Price
			  , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END - CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					  CAST(Tex.Orig_purchase_price AS NUMERIC) * Tex.num_seats END  AS O_TE_Price_Difference
        FROM    ods.TM_Tex Tex WITH ( NOLOCK )
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.AccountId = Tex.acct_id AND DimCustomer.CustomerType = 'Primary' AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = DimCustomer.DimCustomerId
				INNER JOIN ods.TM_Evnt Event WITH ( NOLOCK ) ON Event.Event_id = Tex.event_id
        WHERE   Tex.activity IN ('F', 'ES')












GO
