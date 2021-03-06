CREATE TABLE [dbo].[FD_SDA_ENTITY_OTHER_IDS]
(
[ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [idx_fd_sda_entity_other_ids_type_code] ON [dbo].[FD_SDA_ENTITY_OTHER_IDS] ([TYPE_CODE]) INCLUDE ([ID_NUMBER], [OTHER_ID])
GO
