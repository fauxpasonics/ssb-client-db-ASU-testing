SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[upd_FD_PRIORITY_POINT_SUMMARY]
as

begin

if
	(select case when
		(cast((select count(*) from dbo.FD_SDA_PRIORITY_POINT_SUMMARY) as float)/2) > 
		(cast((select count(*) from src.FD_SDA_PRIORITY_POINT_SUMMARY) as float)) then 0 else 1 end) = 1
	begin

	truncate table dbo.FD_SDA_PRIORITY_POINT_SUMMARY

	insert into dbo.FD_SDA_PRIORITY_POINT_SUMMARY
	select * from src.FD_SDA_PRIORITY_POINT_SUMMARY

	end
else 
begin
	raiserror('Source Data contains less than 50 percent of expected rows',16,1)
end

end
GO
