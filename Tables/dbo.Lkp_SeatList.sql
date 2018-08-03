CREATE TABLE [dbo].[Lkp_SeatList]
(
[Seat] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[Lkp_SeatList] ADD CONSTRAINT [PK_Lkp_SeatList] PRIMARY KEY CLUSTERED  ([Seat])
GO
