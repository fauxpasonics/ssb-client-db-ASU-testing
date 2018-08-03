SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [segmentation].[vw__Ticket_Exchange_Recipient] AS 

        SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID AS SSB_CRMSYSTEM_CONTACT_ID
			  , DimCustomer.AccountId AS R_Archtics_Acct_Id
			  , Tex.activity AS R_Activity
			  , Tex.activity_name AS R_Activity_Name
			  , CAST(Tex.add_datetime AS DATE) AS R_Transaction_Date 
              , Tex.season_year AS R_Season_Year
              , Tex.event_name AS R_Event_Code
			  , Event.Team AS R_Event_Name 
              , CAST(Tex.event_time AS NVARCHAR(50)) AS R_Event_Time
              , Tex.event_date AS R_Event_Date
              , Tex.section_name AS R_Section_Name
              , Tex.row_name AS R_Row_Name
              , Tex.seat_num AS R_First_Seat
              --, Tex.last_seat AS R_Last_Seat
              , Tex.num_seats AS R_Qty_Seat
              , CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					CAST(Tex.Orig_purchase_price AS NUMERIC (18,2) )  * Tex.num_seats END AS R_Orig_purchase_price
              , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END AS R_TE_Purchase_Price
			  , CASE WHEN ISNUMERIC(Tex.te_purchase_price) = 0 THEN 0 ELSE CAST(Tex.te_purchase_price AS NUMERIC) END - CASE WHEN ISNUMERIC(Tex.Orig_purchase_price) = 0 THEN 0 ELSE
					  CAST(Tex.Orig_purchase_price AS NUMERIC) * Tex.num_seats END  AS R_TE_Price_Difference
        FROM    ods.TM_Tex Tex WITH ( NOLOCK )
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.AccountId = Tex.assoc_acct_id AND DimCustomer.CustomerType = 'Primary' AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = DimCustomer.DimCustomerId
				INNER JOIN ods.TM_Evnt Event WITH ( NOLOCK ) ON Event.Event_id = Tex.event_id
        WHERE   Tex.activity IN ('F', 'ES')



GO
