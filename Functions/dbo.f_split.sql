SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







Create function [dbo].[f_split](@SourceSql varchar(8000),@StrSeprate varchar(10))
returns @temp 
table(val varchar(500), val_id int)
begin    
 declare @i int
 declare @n int    
 set @SourceSql=rtrim(ltrim(@SourceSql)) 
 set @i=charindex(@StrSeprate,@SourceSql)
 set @n = 1    
 while @i>=1    
 begin        
  insert @temp values(left(@SourceSql,@i-1), @n)        
  set @SourceSql=substring(@SourceSql,@i+1,len(@SourceSql)-@i)        
  set @i=charindex(@StrSeprate,@SourceSql) 
  set @n = @n + 1   
 end    
 if @SourceSql<>'\'       
 insert @temp values(@SourceSql, @n)    
 return 
end







GO
