SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[upd_FD_BIOGRAPHIC]
as

begin

if
	(select case when
		(cast((select count(*) from dbo.FD_SDA_ENTITY_BIOGRAPHIC) as float)/2) > 
		(cast((select count(*) from src.FD_SDA_ENTITY_BIOGRAPHIC) as float)) then 0 else 1 end) = 1
	begin

	truncate table dbo.FD_SDA_ENTITY_BIOGRAPHIC

	insert into dbo.FD_SDA_ENTITY_BIOGRAPHIC
	select * from src.FD_SDA_ENTITY_BIOGRAPHIC

	end
else 
begin
	raiserror('Source Data contains less than 50 percent of expected rows',16,1)
end

end
GO
