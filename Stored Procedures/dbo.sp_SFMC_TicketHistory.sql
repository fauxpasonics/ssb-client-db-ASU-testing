SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[sp_SFMC_TicketHistory]

AS
BEGIN



IF OBJECT_ID('tempdb..#head') IS NOT NULL
    DROP TABLE #head
create table #head (ContactID varchar(64), PacID varchar(100), EmailAddress varchar(254)) -- header


--Join Advance Information on PacID
insert into #head (ContactID, PacID, EmailAddress) 
select distinct case when t.ContactID = '00000000-0000-0000-0000-000000000000' then NULL else t.ContactId end as ContactId, 
		t.PacID, 
		ISNULL(t.PersonEmail,a.AdvEmail) as EmailAddress
from
	(select distinct p.ContactId, Patron as PacID, 
	coalesce(
		(case when CD_PersonalEmail not like '%@%' then null else CD_PersonalEmail end), 
		(case when CD_EvEmail not like '%@%' then null else CD_EvEmail end), 
		(case when CD_OtherEmail not like '%@%' then null else CD_OtherEmail end), 
		(case when CD_BusinessEmail not like '%@%' then null else  CD_BusinessEmail end) ) as PersonEmail
	FROM dbo.Patron__c p (NOLOCK)
	) t 
left join --Advance Account not required
	(select distinct x.PacID , x.AdvEmail
	from 
		(select distinct i.OTHER_ID as PacID, 
		coalesce(
			(case when PRIMARY_EMAIL not like '%@%' then null else PRIMARY_EMAIL end),
			(case when SPOUSE_EMAIL not like '%@%' then null else SPOUSE_EMAIL end) ) as AdvEmail
		from ASU.dbo.FD_SDA_ENTITY_BIOGRAPHIC b (NOLOCK)
		inner join ASU.dbo.FD_SDA_ENTITY_OTHER_IDS i on b.ID_NUMBER = i.ID_NUMBER 
		where i.TYPE_CODE in ('SDP', 'SDJ')	--order by 1
			and exists (	select ii.Other_ID as PacID, max(ii.TYPE_CODE) Type_Code from ASU.dbo.FD_SDA_ENTITY_BIOGRAPHIC bb (NOLOCK)
					inner join ASU.dbo.FD_SDA_ENTITY_OTHER_IDS ii (NOLOCK) on bb.ID_NUMBER = ii.ID_NUMBER 
					where ii.TYPE_CODE in ('SDP', 'SDJ') and ii.OTHER_ID = i.OTHER_ID
					group by ii.OTHER_ID
					having max(ii.TYPE_CODE) = i.TYPE_CODE --order by 1 
					)
		) x
	
					
	) a on t.PacID = a.PacID 
order by PacID




select h.EmailAddress, h.ContactID,
o.SEASON as SeasonCode,
o.ITEM as ItemCode,
o.I_PT as PriceType,
o.I_PL as PriceLevel,
o.I_OQTY as ItemQuantity,
o.SEASON + ':' + o.ZID as OrderID, 
o.CUSTOMER as PacID,
e.PIN as eVenuePIN,
case when d.Linked is null then 0 else d.Linked end as LinkedStatus
	from
	ASU.dbo.TK_ODet o (NOLOCK)
	left join ASU.dbo.EPD_ACCOUNT e (NOLOCK) on o.CUSTOMER = e.CUSTOMER
	left join ASU.dbo.EPD_ACCOUNT_DISTRIBUTOR d (NOLOCK) on o.CUSTOMER = d.CUSTOMER
	left join  #head h on h.PacID = o.CUSTOMER
where o.I_DATE >= ( DATEADD(yy,-5,GETDATE()))


END


GO
