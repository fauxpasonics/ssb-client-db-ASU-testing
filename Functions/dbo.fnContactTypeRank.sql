SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE FUNCTION [dbo].[fnContactTypeRank]
(
	@ContactClass CHAR(1) --A (Address), P (Phone), E(Email)
)

RETURNS @Result TABLE 
(  
	ContactType	VARCHAR(25),
    PriorityRank INT
) 
AS
BEGIN

	/* find out which  types to use for Address --
		select ADTYPE, count(0) from [172.31.17.15].usc.dbo.PD_Address
		group by ADTYPE
		order by count(0) desc
		*/


	IF (@ContactClass = 'A')
	BEGIN

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('P', 1)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('B', 2)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('O', 3)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('H', 4)	
		
		
	END	

	ELSE IF (@ContactClass = 'P')
	BEGIN

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('H', 1)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('B', 2)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('C', 3)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('F', 4)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('P', 5)



	END

	ELSE IF (@ContactClass = 'E')
	BEGIN

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('E', 1)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('PAH', 2)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('SE', 3)


	END


	RETURN

END








GO
