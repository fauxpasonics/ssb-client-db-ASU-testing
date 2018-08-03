SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW  [segmentation].[vw__Source_System] AS (


SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID
		, dimcustomer.SourceSystem CustomerSourceSystem
		, ExtAttribute1
		, ExtAttribute2
		, ExtAttribute3
		, ExtAttribute4
		, ExtAttribute5
		, ExtAttribute6
		, ExtAttribute7
		, ExtAttribute8
		, ExtAttribute9
		, ExtAttribute10
		, ExtAttribute11
		, ExtAttribute12
		, ExtAttribute13
		, ExtAttribute14
		, ExtAttribute15
		, ExtAttribute16
		, ExtAttribute17
		, ExtAttribute18
		, ExtAttribute19
		, ExtAttribute20

FROM    dbo.DimCustomer dimcustomer WITH ( NOLOCK )
        JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = dimcustomer.DimCustomerId

WHERE dimcustomer.SourceSystem NOT IN ('TI ASU', 'TM', 'Advance ASU', 'ASU PC_SFDC Account', 'SFMC')


) 


GO
