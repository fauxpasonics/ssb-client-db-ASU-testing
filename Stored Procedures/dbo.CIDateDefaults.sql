SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[CIDateDefaults] @fiscalStart int as

declare @fiscalQ1start  varchar(2)
declare @fiscalQ2start  varchar(2)
declare @fiscalQ3start  varchar(2)
declare @fiscalQ4start  varchar(2)
declare @fiscalQ1end  varchar(2)
declare @fiscalQ2end  varchar(2)
declare @fiscalQ3end  varchar(2)
declare @fiscalQ4end  varchar(2)
declare @fiscalQ1Year  int
declare @fiscalQ2Year  int
declare @fiscalQ3Year  int
declare @fiscalQ4Year  int
declare @fiscalQ1Month  int
declare @fiscalQ2Month  int
declare @fiscalQ3Month  int
declare @fiscalQ4Month  int


Begin 
		--set @fiscalQ1start = '01'
		--set @fiscalQ2start = '04'
		--set @fiscalQ3start = '07'
		--set @fiscalQ4start = '10'
		--set @fiscalQ1end = '03'
		--set @fiscalQ2end = '06'
		--set @fiscalQ3end = '09'
		--set @fiscalQ4end = '12'
		set @fiscalQ1Month = @fiscalStart
End

		
Begin
Select cast(getdate() as date) as TodayDt
, cast(cast(datepart(yy, getdate()) as varchar(4)) + '-' + cast(datepart(mm, getdate()) as varchar(2)) + '-01' as date) as CurMonthStart
, dateadd(day,-1,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-' + cast(datepart(mm, getdate()) as varchar(2)) + '-01' as date)) as CurMonthEnd
,datepart(yy, getdate()) as CurrentYear, datepart(yy, getdate())+1 as NextYear, datepart(yy, getdate())-1 as LastYear
,datepart(mm, getdate()) as CurrentMonth,datepart(mm, getdate())+1 as NextMonth ,datepart(mm, getdate())-1 as LastMonth
, datepart(q, getdate()) as CurQuarter
, cast(cast(datepart(yy, getdate()) as varchar(4)) + case(datepart(q, getdate()))
	when '1' then '-01-01'
	when '2' then '-04-01'
	when '3' then '-07-01'
	when '4' then '-10-01' end as date) as CurQtrStart
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-01-01' as date) as Q1Start
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-03-31' as date) as Q1End
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-04-01' as date) as Q2Start
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-06-30' as date) as Q2End
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-07-01' as date) as Q3Start
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-09-30' as date) as Q3End
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-10-01' as date) as Q4Start
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-12-31' as date) as Q4End
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-' + @fiscalQ1start + '-01' as date) as Q1FiscalStart
,cast(cast(datepart(yy, getdate()) as varchar(4)) + '-' + @fiscalQ1end + '-31' as date) as Q1FiscalEnd
End

GO
