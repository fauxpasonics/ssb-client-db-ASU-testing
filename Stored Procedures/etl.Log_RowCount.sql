SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE  [etl].[Log_RowCount]
     @BatchID       BIGINT,
     @Task_Name     VARCHAR(50),
     @Processed  INT = 0,
     @Inserted   INT = 0,
     @Updated    INT = 0,
     @Deleted    INT = 0
AS

BEGIN

     INSERT INTO etl.Row_Counts
          (Batch_ID,
           Task_Name,
           Row_Count_Processed,
           Row_Count_Inserted,
           Row_Count_Updated,
           Row_Count_Del)
     SELECT
          @BatchID,
          @Task_Name,
          @Processed,
          @Inserted,
          @Updated,
          @Deleted
END
GO
