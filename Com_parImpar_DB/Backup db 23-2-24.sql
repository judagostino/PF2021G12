USE [ParImpar]
GO
/****** Object:  User [user_api]    Script Date: 23/2/2024 19:57:49 ******/
CREATE USER [user_api] FOR LOGIN [user_api] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[SearchTypesImpairment]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[SearchTypesImpairment](@filtersIds VARCHAR(MAX))  
RETURNS VARCHAR(MAX)   
AS   
-- Returns the stock level for the product.  
BEGIN 

/*
-- Para test;
DECLARE @filtersIds VARCHAR(MAX) = '1'
*/

	DECLARE @TableFilters TABLE 
	(
		[filter] INT
	)
	
	DECLARE @TableAux TABLE 
	(
		Txt VARCHAR(MAX)
	)

    DECLARE @ret VARCHAR(MAX);  

	INSERT INTO @TableFilters
	SELECT value
	FROM STRING_SPLIT(@filtersIds , ',')

	IF EXISTS (SELECT TOP 1 filter FROM @TableFilters)
	BEGIN
		
		INSERT INTO @TableAux
		SELECT STUFF((SELECT ',' + [Description]
        FROM TypesImpairment (NOLOCK) 
		WHERE ( TypeId IN  (SELECT filter FROM @TableFilters))
        FOR XML PATH('')) ,1,1,'') AS Txt 


		SELECT @ret = Txt from @TableAux

	END
   
     IF (@ret IS NULL)   
        SET @ret = NULL;


   RETURN @ret;  

	
END;
GO
/****** Object:  Table [dbo].[ActionLog]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionLog](
	[ActionLogId] [int] IDENTITY(1,1) NOT NULL,
	[ObjectKey] [varchar](255) NULL,
	[ObjectId] [int] NULL,
	[filters] [varchar](255) NULL,
	[ContactId] [int] NULL,
	[DateEntered] [datetime] NULL,
	[SearchText] [varchar](max) NULL,
	[ActionTypeId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ActionLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActionType]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionType](
	[ActionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_ActionType] PRIMARY KEY CLUSTERED 
(
	[ActionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contacts]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contacts](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[dateEntered] [datetime] NULL,
	[Email] [varchar](100) NOT NULL,
	[Password] [varchar](max) NOT NULL,
	[UserName] [varchar](100) NULL,
	[DateBrirth] [date] NULL,
	[Auditor] [bit] NULL,
	[Confirm] [bit] NULL,
	[Trusted] [bit] NULL,
	[Notifications] [bit] NULL,
	[ConfirmCode] [varchar](100) NULL,
	[ExpiredRecover] [datetime] NULL,
	[CodeRecover] [varchar](100) NULL,
	[ImageUrl] [nchar](255) NULL,
	[DateModify] [datetime] NULL,
	[Blocked] [bit] NULL,
	[DateDeleted] [datetime] NULL,
 CONSTRAINT [PK__Contact__CFED658FE377AA2D] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContactXEvent]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactXEvent](
	[ContactEventId] [int] IDENTITY(1,1) NOT NULL,
	[ContactId] [int] NOT NULL,
	[EventId] [int] NOT NULL,
	[DateEntered] [datetime] NOT NULL,
	[DateCancellation] [datetime] NULL,
 CONSTRAINT [PK_ContactXEvent] PRIMARY KEY CLUSTERED 
(
	[ContactEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContactXTypeImplairment]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactXTypeImplairment](
	[ContactTypeImplairmentId] [int] IDENTITY(1,1) NOT NULL,
	[ContactId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[DateEntered] [datetime] NOT NULL,
	[DateDelete] [datetime] NULL,
 CONSTRAINT [PK_ContactXTypeImplairment] PRIMARY KEY CLUSTERED 
(
	[ContactTypeImplairmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DenyObject]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DenyObject](
	[ObjectKey] [varchar](255) NOT NULL,
	[ObjectId] [int] NOT NULL,
	[Reason] [varchar](6000) NULL,
	[ContactId] [int] NULL,
	[DenyObject] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_DenyObject] PRIMARY KEY CLUSTERED 
(
	[DenyObject] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Events]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](max) NULL,
	[Title] [varchar](1000) NULL,
	[DateEntered] [datetime] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ContacCreate] [int] NOT NULL,
	[ContactAudit] [int] NULL,
	[StateId] [int] NOT NULL,
	[DateModify] [datetime] NULL,
	[ImageUrl] [varchar](500) NULL,
	[DateDeleted] [datetime] NULL,
 CONSTRAINT [PK__Events__7944C810D6BCD312] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MailExecutions]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MailExecutions](
	[Send] [varchar](500) NULL,
	[LastExecution] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Posts]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Posts](
	[PostId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](max) NULL,
	[Text] [varchar](max) NULL,
	[Title] [varchar](1000) NULL,
	[DateEntered] [datetime] NOT NULL,
	[DateModify] [datetime] NULL,
	[ContacCreate] [int] NOT NULL,
	[ContactAudit] [int] NULL,
	[ImageUrl] [varchar](500) NULL,
	[StateId] [int] NOT NULL,
	[DateDeleted] [datetime] NULL,
 CONSTRAINT [PK__Posts__AA1260180BDE6FC4] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostsXTypesImpairment]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostsXTypesImpairment](
	[PostXTypesImpairmentId] [int] IDENTITY(1,1) NOT NULL,
	[PostId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PostXTypesImpairmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[States]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[States](
	[StateId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tokens]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tokens](
	[RefreshTokenId] [varchar](50) NOT NULL,
	[AccessTokenId] [varchar](50) NOT NULL,
	[RefreshTokenSignature] [varchar](100) NOT NULL,
	[AccessTokenSignature] [varchar](100) NOT NULL,
	[RefreshToken] [varchar](2000) NOT NULL,
	[AccessToken] [varchar](2000) NOT NULL,
	[RefreshTokenExpirationDate] [datetime] NOT NULL,
	[AccessTokenExpirationDate] [datetime] NOT NULL,
	[Claims] [varchar](2000) NOT NULL,
	[KeepLoggedIn] [bit] NOT NULL,
	[IpAddress] [varchar](50) NULL,
	[Client] [varchar](1000) NULL,
	[DateEntered] [datetime] NOT NULL,
 CONSTRAINT [PK_Tokens_1] PRIMARY KEY CLUSTERED 
(
	[RefreshTokenId] ASC,
	[AccessTokenId] ASC,
	[RefreshTokenSignature] ASC,
	[AccessTokenSignature] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TypesImpairment]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypesImpairment](
	[TypeId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ActionLog] ON 
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T20:50:51.250' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (2, N'EventId', 1, NULL, 2, CAST(N'2024-02-21T20:55:11.340' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (3, N'EventId', 2, NULL, 2, CAST(N'2024-02-21T20:57:13.940' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (4, N'EventId', 3, NULL, 2, CAST(N'2024-02-21T21:03:55.637' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (5, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:04:25.860' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (6, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:04:43.060' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (7, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:07:03.267' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (8, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:07:46.000' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (9, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:07:59.943' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (10, N'EventId', NULL, NULL, 2, CAST(N'2024-02-21T21:33:19.530' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (11, N'PostId', 1, NULL, 2, CAST(N'2024-02-21T21:37:09.417' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (12, N'PostId', 2, NULL, 2, CAST(N'2024-02-21T21:42:42.760' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (13, N'PostId', 3, NULL, 2, CAST(N'2024-02-21T21:44:21.410' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (14, N'ContactId', 1, NULL, 1, CAST(N'2024-02-21T21:45:33.327' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (15, N'EventId', 2, NULL, 1, CAST(N'2024-02-21T21:46:26.213' AS DateTime), NULL, 16)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (16, N'PostId', 2, NULL, 1, CAST(N'2024-02-21T21:49:16.023' AS DateTime), NULL, 17)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (17, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:49:55.380' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (18, N'EventId', 1, NULL, 1, CAST(N'2024-02-21T21:50:07.983' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (19, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T21:50:13.240' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (20, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:50:18.193' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (21, N'EventId', 1, NULL, 1, CAST(N'2024-02-21T21:50:31.127' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (22, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T21:50:32.843' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (23, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:50:46.150' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (24, NULL, NULL, NULL, NULL, CAST(N'2024-02-21T21:52:03.577' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (25, NULL, NULL, N'7', NULL, CAST(N'2024-02-21T21:53:33.583' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (26, NULL, NULL, N'2', NULL, CAST(N'2024-02-21T21:53:44.120' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (27, N'PostId', 3, NULL, NULL, CAST(N'2024-02-21T21:53:56.503' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (28, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T21:54:02.113' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (29, N'PostId', 3, NULL, NULL, CAST(N'2024-02-21T21:54:04.727' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (30, N'PostId', 3, NULL, NULL, CAST(N'2024-02-21T21:54:44.700' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (31, N'PostId', 3, NULL, NULL, CAST(N'2024-02-21T21:55:16.950' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (32, N'PostId', 3, NULL, NULL, CAST(N'2024-02-21T21:56:11.747' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (33, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T21:56:14.847' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (34, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T21:57:16.340' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (35, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T21:57:32.083' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (36, N'EventId', 1, NULL, 2, CAST(N'2024-02-21T21:57:49.543' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (37, N'EventId', 1, NULL, 1, CAST(N'2024-02-21T22:00:15.543' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (38, N'EventId', 1, NULL, 1, CAST(N'2024-02-21T22:00:21.877' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (39, N'EventId', 1, NULL, 1, CAST(N'2024-02-21T22:00:33.927' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (40, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T22:01:25.650' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (41, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T22:01:57.130' AS DateTime), NULL, 15)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (42, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T22:02:30.460' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (43, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T22:09:54.870' AS DateTime), NULL, 14)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (44, N'ContactId', 2, NULL, 2, CAST(N'2024-02-21T22:10:05.587' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (45, N'ContactId', 1, NULL, 1, CAST(N'2024-02-23T18:36:58.880' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (46, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T18:37:21.417' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (47, N'ContactId', 1, NULL, 1, CAST(N'2024-02-23T18:44:13.120' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (48, N'ContactId', 2, NULL, 2, CAST(N'2024-02-23T18:44:38.420' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (49, N'PostId', 1, NULL, 2, CAST(N'2024-02-23T18:44:55.840' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (50, N'PostId', 2, NULL, 2, CAST(N'2024-02-23T18:45:11.320' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (51, N'PostId', 3, NULL, 2, CAST(N'2024-02-23T18:45:22.313' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (52, N'ContactId', 1, NULL, 1, CAST(N'2024-02-23T18:46:05.927' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (53, NULL, NULL, N'7', NULL, CAST(N'2024-02-23T18:46:59.907' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (54, NULL, NULL, N'5', NULL, CAST(N'2024-02-23T18:47:13.877' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (55, N'PostId', 3, NULL, 2, CAST(N'2024-02-23T18:47:41.200' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (56, N'PostId', 2, NULL, 2, CAST(N'2024-02-23T18:47:51.127' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (57, N'PostId', 3, NULL, 2, CAST(N'2024-02-23T18:48:06.050' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (58, N'PostId', 3, NULL, 2, CAST(N'2024-02-23T18:48:33.530' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (59, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T18:48:39.667' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (60, NULL, NULL, N'7', NULL, CAST(N'2024-02-23T18:48:44.990' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (61, N'PostId', 1, NULL, 2, CAST(N'2024-02-23T18:50:09.120' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (62, N'PostId', 1, NULL, 2, CAST(N'2024-02-23T19:01:12.310' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (63, N'PostId', 1, NULL, 2, CAST(N'2024-02-23T19:01:41.373' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (64, N'PostId', 3, NULL, 1, CAST(N'2024-02-23T19:02:12.330' AS DateTime), NULL, 17)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (65, N'ContactId', 3, NULL, 3, CAST(N'2024-02-23T19:06:11.207' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (66, N'EventId', 4, NULL, 3, CAST(N'2024-02-23T19:08:16.200' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (67, N'PostId', 4, NULL, 3, CAST(N'2024-02-23T19:10:19.507' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (68, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:10:25.453' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (69, NULL, NULL, N'1', NULL, CAST(N'2024-02-23T19:10:33.167' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (70, N'EventId', 1, NULL, 3, CAST(N'2024-02-23T19:10:38.480' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (71, N'ContactId', 2, NULL, 2, CAST(N'2024-02-23T19:10:41.650' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (72, N'EventId', 3, NULL, 3, CAST(N'2024-02-23T19:11:02.590' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (73, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:11:10.980' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (74, N'PostId', 1, NULL, NULL, CAST(N'2024-02-23T19:11:12.853' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (75, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:11:16.540' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (76, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:11:20.200' AS DateTime), N'inclusion', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (77, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:11:26.633' AS DateTime), N'discapacidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (78, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:12:01.370' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (79, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:12:06.040' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (80, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:12:14.883' AS DateTime), N'discapacidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (81, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:12:40.607' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (82, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:13:06.413' AS DateTime), N'calidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (83, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:17:23.650' AS DateTime), N'deportiva', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (84, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:17:35.590' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (85, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:17:49.033' AS DateTime), N'inclusion', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (86, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:18:18.883' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (87, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:18:26.543' AS DateTime), N'arte', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (88, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:18:31.913' AS DateTime), N'inclusión', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (89, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:18:39.787' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (90, N'EventId', 4, NULL, 1, CAST(N'2024-02-23T19:19:13.010' AS DateTime), NULL, 16)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (91, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:19:25.617' AS DateTime), N'deportiva', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (92, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:19:32.540' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (93, N'ContactId', 2, NULL, 2, CAST(N'2024-02-23T19:20:40.050' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (94, N'EventId', 1, NULL, 2, CAST(N'2024-02-23T19:20:46.937' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (95, N'EventId', 1, NULL, 2, CAST(N'2024-02-23T19:23:14.607' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (96, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:23:41.040' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (97, N'PostId', 2, NULL, NULL, CAST(N'2024-02-23T19:23:45.287' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (98, N'EventId', 1, NULL, 2, CAST(N'2024-02-23T19:26:37.703' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (99, N'ContactId', 3, NULL, 3, CAST(N'2024-02-23T19:30:40.440' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (100, N'ContactId', 3, NULL, 3, CAST(N'2024-02-23T19:31:13.453' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (101, N'PostId', 4, NULL, 3, CAST(N'2024-02-23T19:31:37.193' AS DateTime), NULL, 10)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (102, N'EventId', 4, NULL, 3, CAST(N'2024-02-23T19:31:37.197' AS DateTime), NULL, 10)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (103, N'ContactId', 2, NULL, 2, CAST(N'2024-02-23T19:31:45.690' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (104, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:32:07.043' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (105, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:32:14.440' AS DateTime), N'deportiva', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (106, N'PostId', 5, NULL, 2, CAST(N'2024-02-23T19:34:29.330' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (107, N'PostId', 5, NULL, 2, CAST(N'2024-02-23T19:35:31.797' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (108, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:37:29.787' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (109, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:38.400' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (110, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:42.610' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (111, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:42.863' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (112, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:43.263' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (113, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:44.140' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (114, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:45.030' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (115, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:45.953' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (116, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:46.710' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (117, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:47.427' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (118, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:48.230' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (119, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:49.020' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (120, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:49.740' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (121, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:50.500' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (122, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:51.407' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (123, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:52.510' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (124, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:53.107' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (125, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:53.707' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (126, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:54.253' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (127, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:54.810' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (128, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:55.377' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (129, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:55.860' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (130, N'PostId', 5, NULL, NULL, CAST(N'2024-02-23T19:37:56.383' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (131, N'PostId', 5, NULL, 2, CAST(N'2024-02-23T19:39:17.970' AS DateTime), NULL, 7)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (132, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:39:55.997' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (133, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:01.113' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (134, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:04.590' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (135, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:05.180' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (136, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:05.577' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (137, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:06.047' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (138, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:06.417' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (139, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:06.720' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (140, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:07.133' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (141, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:07.583' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (142, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:07.990' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (143, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:08.333' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (144, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:08.633' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (145, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:09.030' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (146, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:09.400' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (147, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:09.737' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (148, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:10.057' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (149, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:10.437' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (150, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:10.770' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (151, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:11.197' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (152, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:11.560' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (153, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:11.953' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (154, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:13.273' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (155, N'EventId', 3, NULL, 1, CAST(N'2024-02-23T19:40:14.067' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (156, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:50:12.047' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (157, N'ContactId', 2, NULL, 2, CAST(N'2024-02-23T19:50:25.157' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (158, N'ContactId', 2, NULL, 2, CAST(N'2024-02-23T19:51:50.423' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (159, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:51:54.760' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (160, N'PostId', 1, NULL, NULL, CAST(N'2024-02-23T19:51:59.450' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (161, N'EventId', 1, NULL, 2, CAST(N'2024-02-23T19:52:07.370' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (162, NULL, NULL, NULL, NULL, CAST(N'2024-02-23T19:54:51.990' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (163, N'PostId', 3, NULL, NULL, CAST(N'2024-02-23T19:54:55.597' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (164, N'PostId', 3, NULL, 2, CAST(N'2024-02-23T19:55:30.510' AS DateTime), NULL, 6)
GO
SET IDENTITY_INSERT [dbo].[ActionLog] OFF
GO
SET IDENTITY_INSERT [dbo].[ActionType] ON 
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (1, N'Busqueda')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (2, N'Crear Evento')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (3, N'Modificar Evento')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (4, N'Eliminar Evento')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (5, N'Crear Contenido')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (6, N'Modificar Contenido')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (7, N'Eliminar Contenido')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (8, N'Crear Usuario')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (9, N'Modificar Datos del Usuario')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (10, N'Eliminar Usuario')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (11, N'Ver Evento')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (12, N'Ver Contenido')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (13, N'Ver Perfil')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (14, N'Recuperar Contraseña')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (15, N'Cambiar Contraseña')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (16, N'Rechzar Evento')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (17, N'Rechzar Contenido')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (18, N'Inicio de Sesión')
GO
SET IDENTITY_INSERT [dbo].[ActionType] OFF
GO
SET IDENTITY_INSERT [dbo].[Contacts] ON 
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (1, N'Administrador', N'ParImpar', CAST(N'2024-02-21T20:42:28.987' AS DateTime), N'comunidadparimpar@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'Administrador', CAST(N'2024-02-21' AS Date), 1, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (2, N'Julieta', N'Dagostino', CAST(N'2024-02-21T20:46:31.160' AS DateTime), N'judagostino96@gmail.com', N'a1o/xEasBjA8QDYqSne74A==', N'jdagostino', CAST(N'1996-09-02' AS Date), 0, 1, 1, 1, N'D074E634-237E-4B58-A1A8-B89A839FC567', CAST(N'2024-02-23T23:28:39.557' AS DateTime), N'3DF35066-BB65-43C2-B599-EC063438AD65', N'http://comunidad-parimpar.com.ar/Profiles/ContactId_2.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-21T22:02:30.457' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (3, N'Gaston Luis', N'Vottero', CAST(N'2024-02-23T19:05:03.143' AS DateTime), N'gastonlvottero@gmail.com', N'8uJ1KuYptsyl1f23upSNXw==', N'glvottero', NULL, NULL, 1, NULL, 0, N'8B3861C2-C3CD-4AF9-B380-B6881F705ECD', NULL, NULL, NULL, CAST(N'2024-02-23T19:31:13.450' AS DateTime), NULL, CAST(N'2024-02-23T19:31:37.180' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Contacts] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactXEvent] ON 
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (1, 2, 1, CAST(N'2024-02-21T21:52:33.340' AS DateTime), CAST(N'2024-02-21T21:52:37.573' AS DateTime))
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (2, 2, 1, CAST(N'2024-02-21T21:52:41.510' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (3, 3, 1, CAST(N'2024-02-23T19:10:52.000' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (4, 3, 3, CAST(N'2024-02-23T19:10:58.800' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[ContactXEvent] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactXTypeImplairment] ON 
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (1, 2, 2, CAST(N'2024-02-21T22:02:11.483' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (2, 2, 5, CAST(N'2024-02-21T22:02:11.483' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (3, 2, 8, CAST(N'2024-02-21T22:02:11.483' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (4, 3, 5, CAST(N'2024-02-23T19:30:59.823' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (5, 3, 7, CAST(N'2024-02-23T19:30:59.823' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[ContactXTypeImplairment] OFF
GO
SET IDENTITY_INSERT [dbo].[DenyObject] ON 
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'EventId', 2, N'No cumple con políticas de contenido', NULL, 1)
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'PostId', 2, N'no cumple políticas de privacidad', NULL, 2)
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'PostId', 3, N'no visualiza correctamente la imagen del post', NULL, 3)
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'EventId', 4, N'no tiene imagen', NULL, 4)
GO
SET IDENTITY_INSERT [dbo].[DenyObject] OFF
GO
SET IDENTITY_INSERT [dbo].[Events] ON 
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (1, N'¡Bienvenidos al evento ''Inclusión a través del Arte''! Este evento busca promover la participación activa de personas con discapacidad en el mundo artístico. Contaremos con talleres de pintura, escultura y música adaptados para diferentes habilidades. Únete a nosotros para celebrar la diversidad y la creatividad. ¡Esperamos verlos allí!<br><br>Detalles del evento:<br><br>Talleres de pintura inclusivos.<br>Sesiones de música adaptada.<br>Escultura con enfoque en la accesibilidad.<br>Conferencias sobre la importancia de la inclusión en las artes.<br><br><br><br>¡No te pierdas esta oportunidad de conectarte a través del arte y crear recuerdos inolvidables juntos!', N'Inclusión a través del Arte', CAST(N'2024-02-21T20:55:11.340' AS DateTime), CAST(N'2024-03-01T02:53:00.000' AS DateTime), CAST(N'2024-03-03T22:53:00.000' AS DateTime), 2, 1, 2, CAST(N'2024-02-21T21:33:19.530' AS DateTime), N'http://comunidad-parimpar.com.ar/Events/EventId_1.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (2, N'"Te invitamos a nuestra conferencia sobre ''Tecnologías Accesibles''. Exploraremos las últimas innovaciones que facilitan la vida de las personas con discapacidad. Desde aplicaciones móviles hasta dispositivos de asistencia, este evento abordará cómo la tecnología puede crear un mundo más inclusivo. ¡Acompáñanos para aprender, compartir y conectarnos!<br><br>Temas destacados:<br><br>Aplicaciones móviles para la accesibilidad.<br>Dispositivos de asistencia y su impacto.<br>Desarrollo de tecnologías inclusivas.<br>Experiencias de usuarios con tecnologías adaptativas.<br><br>¡Esperamos que esta conferencia inspire nuevas ideas y colaboraciones para un futuro más accesible para todos!"', N'Conferencia sobre Tecnologías Accesibles', CAST(N'2024-02-21T20:57:13.940' AS DateTime), CAST(N'2024-04-15T18:00:00.000' AS DateTime), CAST(N'2024-04-16T18:00:00.000' AS DateTime), 2, 1, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_2.jpeg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (3, N'Te invitamos a participar en nuestro Taller de Empleabilidad, diseñado específicamente para personas con discapacidad. Exploraremos estrategias para superar desafíos laborales y fomentar la inclusión en el ámbito profesional. ¡Aprende, conecta y prepárate para el éxito!<br><br>Aspectos destacados:<br><br>Consejos para la búsqueda de empleo.<br>Desarrollo de habilidades profesionales.<br>Experiencias de éxito en el mundo laboral.<br>Oportunidades de networking inclusivo.<br><br>¡Juntos construiremos un camino hacia la igualdad de oportunidades en el mundo laboral!', N'Taller de Empleabilidad para Personas con Discapacidad', CAST(N'2024-02-21T21:03:55.633' AS DateTime), CAST(N'2024-06-10T09:00:00.000' AS DateTime), CAST(N'1996-06-11T17:00:00.000' AS DateTime), 2, 1, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_3.png', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (4, N'Únete a nuestra Jornada Deportiva Inclusiva, un evento dedicado a promover la actividad física para personas con discapacidad. Participa en emocionantes competiciones adaptadas y descubre la importancia del deporte en la inclusión social. ¡Ven y celebra la diversidad a través del movimiento!<br><br>Actividades destacadas:<br><br>Carreras inclusivas.<br>Juegos adaptados para todas las edades.<br>Clases de yoga accesible.<br>Exhibiciones de deportes adaptados.<br>¡Nos esforzamos por crear un espacio donde todos puedan disfrutar del deporte sin barreras ni limitaciones!', N'Jornada Deportiva Inclusiva', CAST(N'2024-02-23T19:08:16.200' AS DateTime), CAST(N'2024-05-20T09:00:00.000' AS DateTime), CAST(N'2024-05-21T20:00:00.000' AS DateTime), 3, 1, 3, NULL, NULL, CAST(N'2024-02-23T19:31:37.180' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Events] OFF
GO
INSERT [dbo].[MailExecutions] ([Send], [LastExecution]) VALUES (N'SendNotificy', CAST(N'2024-02-21T22:03:04.407' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (1, N'En esta publicación, exploraremos los últimos avances en tecnología diseñada para mejorar la calidad de vida de las personas con discapacidad visual. Desde dispositivos de asistencia hasta aplicaciones innovadoras, descubre cómo la tecnología está desempeñando un papel crucial en la inclusión y el empoderamiento de la comunidad con discapacidad visual. Acompáñanos en este viaje hacia un mundo más accesible e inclusivo.<br><br>', N'En el ámbito de la discapacidad visual, la tecnología ha emergido como una herramienta revolucionaria para superar barreras. A lo largo de esta investigación, exploraremos dispositivos como lectores de pantalla, sistemas de navegación por voz y aplicaciones móviles diseñadas específicamente para mejorar la independencia y la participación en la sociedad de las personas con discapacidad visual.<br><br>La evolución de la inteligencia artificial ha permitido la creación de tecnologías cada vez más sofisticadas. Analizaremos cómo los algoritmos de reconocimiento de objetos y la realidad aumentada están siendo implementados para facilitar tareas diarias, desde identificar objetos hasta navegar por entornos desconocidos. Estos avances no solo brindan nuevas oportunidades, sino que también fomentan la autonomía y la igualdad de oportunidades.<br><br>Además, nos sumergiremos en proyectos de investigación que buscan desarrollar interfaces cerebro-máquina para personas con discapacidad visual. Estas interfaces tienen el potencial de traducir la actividad cerebral en comandos ejecutables, abriendo nuevas posibilidades para la interacción con dispositivos y entornos digitales.<br><br>En el contexto de la educación, examinaremos plataformas educativas accesibles que utilizan tecnologías de voz y braille digital para garantizar que las personas con discapacidad visual tengan acceso equitativo a la información. Destacaremos programas pioneros que promueven la inclusión educativa y la capacitación laboral para mejorar las perspectivas de empleo.<br><br>Esta publicación también abordará los desafíos éticos asociados con el uso de tecnologías asistivas, destacando la importancia de la privacidad y la seguridad en el diseño de estas soluciones. Al mismo tiempo, reflexionaremos sobre cómo la sociedad puede avanzar hacia un futuro más inclusivo, donde la tecnología se utilice como una herramienta para derribar barreras y fomentar la diversidad.<br><br>En resumen, este análisis exhaustivo busca arrojar luz sobre la intersección entre la tecnología y la discapacidad visual, destacando tanto los logros actuales como las oportunidades futuras para mejorar la calidad de vida de las personas con esta discapacidad. Acompáñanos en este viaje hacia un mundo más inclusivo, donde la innovación tecnológica se convierte en un catalizador para el cambio positivo.', N'Avances en la Integración Tecnológica para Personas con Discapacidad Visual', CAST(N'2024-02-21T21:37:09.403' AS DateTime), CAST(N'2024-02-23T19:01:41.370' AS DateTime), 2, 1, N'http://comunidad-parimpar.com.ar/Posts/PostId_1.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (2, N'Exploraremos en profundidad estrategias innovadoras y prácticas efectivas para apoyar a estudiantes con Trastorno del Espectro Autista (TEA) en entornos educativos. Desde adaptaciones curriculares hasta programas de intervención temprana, descubre cómo podemos crear ambientes inclusivos que potencien el aprendizaje y el desarrollo social de estos estudiantes. Únete a nosotros para promover la igualdad educativa.', N'La inclusión educativa es un aspecto crucial de la igualdad para todos los estudiantes, y en este artículo, nos enfocaremos en abordar específicamente las necesidades de aquellos con Trastorno del Espectro Autista (TEA). Examincaremos estrategias efectivas que van desde la adaptación de material didáctico hasta la implementación de programas de intervención temprana.<br><br>Comenzaremos destacando la importancia de crear entornos de aprendizaje que sean visualmente estructurados y predecibles, proporcionando a los estudiantes con TEA un marco que facilite su comprensión del entorno escolar. Analizaremos cómo la implementación de rutinas y horarios visuales puede contribuir a la reducción de la ansiedad y mejorar la participación activa en el aula.<br><br>La colaboración entre docentes, profesionales de la salud y familias será un punto central en nuestra exploración. Discutiremos modelos exitosos de trabajo en equipo que promueven una comprensión profunda de las necesidades individuales de cada estudiante con TEA. Además, examinaremos estrategias para fomentar la comunicación efectiva, tanto verbal como no verbal, dentro del entorno escolar.<br><br>Nos sumergiremos en investigaciones recientes que destacan la eficacia de las intervenciones conductuales y terapias centradas en el juego para mejorar las habilidades sociales y emocionales de los estudiantes con TEA. Además, exploraremos la implementación de tecnologías asistivas y aplicaciones diseñadas para apoyar el aprendizaje y la comunicación.<br><br>En el ámbito de la capacitación del personal educativo, discutiremos programas de formación que promueven la conciencia y la comprensión del TEA. Destacaremos la importancia de la empatía y la flexibilidad en la enseñanza, reconociendo la diversidad de estilos de aprendizaje y adaptándose a las necesidades individuales.<br><br>En conclusión, este artículo busca proporcionar a educadores, padres y profesionales de la salud herramientas prácticas y conocimientos fundamentales para crear ambientes educativos inclusivos y apoyar el desarrollo pleno de estudiantes con Trastorno del Espectro Autista. Únete a nosotros en este viaje hacia una educación más equitativa y comprensiva para todos.', N'Inclusión Educativa: Estrategias para Apoyar a Estudiantes con Trastorno del Espectro Autista (TEA)', CAST(N'2024-02-21T21:42:42.757' AS DateTime), CAST(N'2024-02-23T18:47:51.120' AS DateTime), 2, 1, N'http://comunidad-parimpar.com.ar/Posts/PostId_2.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (3, N'Exploraremos estrategias inclusivas y programas innovadores diseñados para apoyar a personas que enfrentan discapacidades físicas o motoras junto con discapacidades sensoriales. Desde el diseño de entornos accesibles hasta la implementación de tecnologías táctiles, descubre cómo podemos construir puentes hacia una sociedad más inclusiva para todos.', N'En este estudio, nos enfocaremos en la intersección de las discapacidades físicas o motoras y sensoriales, reconociendo la diversidad de experiencias que enfrentan las personas que viven con estas condiciones. Abordaremos estrategias y soluciones que buscan superar las barreras existentes y promover la inclusión activa.<br><br>Comenzaremos explorando el diseño de entornos accesibles que no solo consideran las necesidades de movilidad, sino también las de percepción sensorial. Analizaremos cómo la arquitectura inclusiva y la disposición de elementos táctiles pueden facilitar la orientación y la movilidad para personas con discapacidades múltiples, proporcionando independencia y seguridad.<br><br>En el ámbito de la tecnología, examinaremos dispositivos innovadores que combinan funcionalidades táctiles con comandos motoros, permitiendo a las personas con discapacidades físicas o motoras y sensoriales interactuar de manera más efectiva con el entorno digital. Esta convergencia tecnológica tiene el potencial de abrir nuevas oportunidades de comunicación y participación.<br><br>Nos sumergiremos en proyectos de investigación que aborden desafíos específicos enfrentados por aquellos con discapacidades múltiples, desde la adaptación de vehículos accesibles hasta el desarrollo de sistemas de comunicación táctiles. Destacaremos cómo la colaboración interdisciplinaria es esencial para abordar las complejidades y singularidades de cada individuo.<br><br>En el ámbito educativo, discutiremos estrategias para la inclusión efectiva en aulas que atienden a estudiantes con discapacidades físicas o motoras y sensoriales. Desde materiales didácticos adaptados hasta tecnologías de apoyo, analizaremos enfoques que fomenten la participación activa y el aprendizaje significativo.<br><br>Finalmente, reflexionaremos sobre la importancia de una sociedad que reconozca y valore la diversidad de habilidades y experiencias. Abogaremos por la construcción de puentes de comprensión y apoyo que lleven a una comunidad más inclusiva y respetuosa con las personas que enfrentan discapacidades múltiples. Únete a nosotros en este viaje hacia la construcción de un mundo donde todos tengan la oportunidad de participar plenamente.', N'Construyendo Puentes de Inclusión: Apoyando a Personas con Discapacidades Múltiples', CAST(N'2024-02-21T21:44:21.407' AS DateTime), CAST(N'2024-02-23T19:55:30.507' AS DateTime), 2, 1, N'http://comunidad-parimpar.com.ar/Posts/PostId_3.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (4, N'Esta publicación se sumerge en estrategias holísticas para mejorar la calidad de vida de personas que enfrentan discapacidades psíquicas, auditivas y del espectro autista. Desde enfoques terapéuticos innovadores hasta programas de apoyo comunitario, exploraremos cómo la integración de múltiples perspectivas puede crear entornos más inclusivos y enriquecedores.', N'Enfocándonos en la complejidad de las discapacidades múltiples, exploraremos estrategias integrales que aborden las dimensiones psíquicas, auditivas y del espectro autista. Nuestra investigación abarcará desde terapias personalizadas hasta iniciativas comunitarias que fomenten el bienestar y la participación activa.<br><br>Comenzaremos explorando enfoques terapéuticos innovadores diseñados para abordar las necesidades específicas de personas con discapacidades psíquicas, auditivas y del espectro autista. Desde terapias cognitivas hasta programas de intervención conductual, analizaremos cómo la atención centrada en la persona puede mejorar la autonomía y la calidad de vida.<br><br>Nos adentraremos en el ámbito de la comunicación, examinando estrategias adaptativas que se ajusten a las distintas formas de expresión presentes en las discapacidades auditivas y del espectro autista. Discutiremos la importancia de entornos inclusivos que fomenten la comunicación efectiva, utilizando lenguajes visuales, táctiles y alternativos.<br><br>En el contexto de la comunidad, analizaremos programas que buscan crear redes de apoyo para personas con discapacidades múltiples. Desde grupos de autoayuda hasta eventos inclusivos, destacaremos cómo la conexión social y la comprensión mutua son fundamentales para el bienestar emocional y la integración en la sociedad.<br><br>Exploraremos investigaciones que examinan la intersección de estas discapacidades en el ámbito educativo, identificando estrategias para adaptar ambientes de aprendizaje y garantizar la participación plena de estudiantes con discapacidades múltiples. Analizaremos la importancia de profesionales capacitados y de un enfoque individualizado en la educación inclusiva.<br><br>En resumen, esta publicación busca proporcionar una visión completa de las experiencias de las personas que enfrentan discapacidades psíquicas, auditivas y del espectro autista. Al hacerlo, abogamos por un enfoque integral que reconozca la singularidad de cada individuo y promueva la construcción de una sociedad más inclusiva y comprensiva. Acompáñanos en este viaje hacia la mejora significativa de la calidad de vida para todos.', N'Un Enfoque Integral: Mejorando la Calidad de Vida para Personas con Discapacidades Múltiples', CAST(N'2024-02-23T19:10:19.503' AS DateTime), NULL, 3, NULL, N'http://comunidad-parimpar.com.ar/Posts/PostId_4.png', 1, CAST(N'2024-02-23T19:31:37.180' AS DateTime))
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (5, N'Exploraremos en esta publicación estrategias integralmente diseñadas para apoyar a individuos que enfrentan discapacidades intelectuales, psíquicas y del habla. Desde programas inclusivos de desarrollo cognitivo hasta terapias innovadoras del habla, descubre cómo se pueden construir comunidades más comprensivas y solidarias.<br>', N'Este artículo se sumergirá en el complejo mundo de las discapacidades, abordando específicamente las áreas de discapacidad intelectual, psíquica y del habla. Nos enfocaremos en estrategias holísticas que reconocen la diversidad de necesidades y fortalezas de cada individuo.<br><br>Comenzaremos explorando programas de desarrollo cognitivo que buscan potenciar las habilidades intelectuales de personas con discapacidad intelectual. Analizaremos enfoques inclusivos que van más allá de la educación tradicional, fomentando el aprendizaje experiencial y la participación activa en la comunidad.<br><br>En el ámbito de la discapacidad psíquica, examinaremos terapias innovadoras que buscan mejorar la salud mental y emocional. Discutiremos cómo la combinación de terapias cognitivas, arte terapia y enfoques centrados en la atención plena puede contribuir a la estabilidad emocional y al bienestar general.<br><br>Abordaremos la discapacidad del habla desde perspectivas diversas, explorando terapias logopédicas que van desde métodos tradicionales hasta tecnologías de comunicación asistida. Destacaremos la importancia de adaptar las estrategias de intervención a las necesidades individuales, reconociendo la singularidad de cada persona.<br><br>Nos sumergiremos en investigaciones que examinan las intersecciones entre estas discapacidades, reconociendo la complejidad de las experiencias de aquellos que enfrentan múltiples desafíos. Exploraremos modelos de atención integral que buscan proporcionar apoyo global, considerando aspectos físicos, emocionales y sociales.<br><br>En el contexto de la inclusión social, discutiremos programas comunitarios que promueven la participación activa de personas con discapacidades variadas. Analizaremos cómo la sensibilización y la educación pueden ser herramientas poderosas para construir comunidades más comprensivas y solidarias.<br><br>En conclusión, este artículo busca ser una guía integral para aquellos que buscan comprender y apoyar a personas con discapacidades intelectuales, psíquicas y del habla. Únete a nosotros en este viaje hacia la creación de entornos que empoderen vidas y celebren la diversidad en todas sus formas.', N'Empoderando Vidas: Estrategias Holísticas para Personas con Discapacidades Variadas', CAST(N'2024-02-23T19:34:29.327' AS DateTime), CAST(N'2024-02-23T19:35:31.797' AS DateTime), 2, NULL, N'http://comunidad-parimpar.com.ar/Posts/PostId_5.jpg', 2, CAST(N'2024-02-23T19:39:17.967' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Posts] OFF
GO
SET IDENTITY_INSERT [dbo].[PostsXTypesImpairment] ON 
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (1, 1, 5)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (2, 2, 7)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (3, 3, 2)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (4, 3, 1)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (8, 3, 5)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (9, 4, 7)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (10, 4, 6)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (11, 4, 4)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (12, 5, 8)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (13, 5, 4)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (14, 5, 3)
GO
SET IDENTITY_INSERT [dbo].[PostsXTypesImpairment] OFF
GO
SET IDENTITY_INSERT [dbo].[States] ON 
GO
INSERT [dbo].[States] ([StateId], [Description]) VALUES (1, N'En Espera')
GO
INSERT [dbo].[States] ([StateId], [Description]) VALUES (2, N'Aprobar')
GO
INSERT [dbo].[States] ([StateId], [Description]) VALUES (3, N'Rechazar')
GO
SET IDENTITY_INSERT [dbo].[States] OFF
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'599f86e5-fd7c-4cbe-94f4-f430ab58523e', N'd0e868a7-7aac-4bfc-86f0-7e06b0c3b84f', N'fI1LeUB5-KhLV_UNy9qyZ1xbYuuSyc8ZiW6u2GakSVs', N'l_Dcs7kfBnps1AGXeq1SP6nR_Avh48lfhmirXoUlxuM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1OTlmODZlNS1mZDdjLTRjYmUtOTRmNC1mNDMwYWI1ODUyM2UiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVUbmI5Z0JCM0toYmY4bUt3T3Eyc29zUTNGV0wzQzJtcnVaSzNMUmhPY05kVGtBVkpCRjlMRjROM2ttNjE1YXQ5RlBtUE54MzVuTHhnSmNRWTRyY09EYk83NVBuR1dBU09RdUZYRjRVMGdBREFRNytzU1ZWMDl0QUlRUHhDa3lGbDdJRnBuNmJsZ0JSN1h3RzU1Q2E0cnpLdy9ObkFJcjVXRy9kK1Bzc0Fkb2hzUWJKeEt4OUxaRmpiZ0I1ejNaR1lIalY4NjV0NHFMeFdOdlJ6OVhhMzJiVWV2V2tMKzhwSGdETVU4TldIQWhPRmt0NS9yOGJJMzNQZGtncHgyV2tiTVdTS24vSUp1SGV5ditYRVJmWGpuOD0iLCJuYmYiOjE3MDg3Mjg1MTQsImV4cCI6MTcwODgxNDkxNCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.fI1LeUB5-KhLV_UNy9qyZ1xbYuuSyc8ZiW6u2GakSVs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkMGU4NjhhNy03YWFjLTRiZmMtODZmMC03ZTA2YjBjM2I4NGYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODUxNCwiZXhwIjoxNzA4NzI5NDE0LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.l_Dcs7kfBnps1AGXeq1SP6nR_Avh48lfhmirXoUlxuM', CAST(N'2024-02-24T19:48:34.573' AS DateTime), CAST(N'2024-02-23T20:03:34.573' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:48:34.573' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'5d4565de-0a2b-46d2-842e-0d8ae6476d32', N'73739b4b-9e9d-4c6f-8a7b-4ee12e0281bc', N'8svlR6KRIWfuv50Ta3TVkzH6PGRYEi8DRUOh1Ps95to', N'5MdYyaNqLnl-EJzkfMxKHHfUNInnGXWI_t5hyH0IMNo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1ZDQ1NjVkZS0wYTJiLTQ2ZDItODQyZS0wZDhhZTY0NzZkMzIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVRlhKSzJ1Q2ZmaXN1Skh5eG53Sm9MS1lCWEZqMkxrUDJveGdWU0I2dVpiWElwL2hQem81NVZ6SHQwOXhRQjZoNjNTRkVtaS9iVlVDVjFwckVpR2NrR0xXdXNtMFpPbEVTQWg2eWY5T014UUhwYTV2aGU4bDBhaXdqZ21FMDJ5K28zM2RaYUd4UUpRSGJNWUhHVHJad0hmM3Urek5hbWM5NDBJNUx5K2dPRWhkeEpjQm9kWEhsZ215TXJuQzhBOEtGNUNyYlJvWUlWV2xuY1RWZ2VzSndUWWMyZUpwL0Z4dHlnNHhhVnIwT29objZFNTUrVDQ2NFltMTloQW5VYklGbm1TcnFhL0l6T3hoWWtVMUpGVDl2VT0iLCJuYmYiOjE3MDg3MjQyOTEsImV4cCI6MTcwODgxMDY5MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.8svlR6KRIWfuv50Ta3TVkzH6PGRYEi8DRUOh1Ps95to', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3MzczOWI0Yi05ZTlkLTRjNmYtOGE3Yi00ZWUxMmUwMjgxYmMiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNDI5MSwiZXhwIjoxNzA4NzI1MTkxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.5MdYyaNqLnl-EJzkfMxKHHfUNInnGXWI_t5hyH0IMNo', CAST(N'2024-02-24T18:38:11.627' AS DateTime), CAST(N'2024-02-23T18:53:11.627' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T18:38:11.630' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'607a9d3d-fe6c-49a0-85bf-c764c69739d7', N'daad8c88-5a32-48a7-9777-c32f58386e86', N'8DX2oN0NmaNi_VQUHKqxsqbvxCD5aV12zZWsx5EJOMU', N'4Fy7pUehtjeDxqNF2hboaXJUzvE5OGiLOVfoxU5qx6s', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MDdhOWQzZC1mZTZjLTQ5YTAtODViZi1jNzY0YzY5NzM5ZDciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVTaTFmK0NlUitaeHdETU00ekF4bEhUR3MyRnFOd3lUYkFxdlpUNEdDbGhtUHFsWnJ2OWhnanR5VUFiQUk3V3ltSEZPWlVtYk8wVlo2THdOa0tNNERLUkxYT05vZThlQmZ2SFZmU0pmS0lmNC9ra2V2NUxwdzNaMVE5YjBTL3FEK3VTZFRyOEt4ZU5uSUx6TGF2YjU3WllOWGN0OVNZWnhCYWdSeFArL1A2YSs3ckhKQTh2NXZacmIxRTdJaWdmVkZhSFRlVUNya1FoTWkwb1dUMWJJK2doMGFqWU1tTVZtajdNMXhJNUtxR1o3SWlMU1o2a1dBcERqZkRlRGZRT1U2YngxRWFjVU1ZQUV6U0FoSHhRYU41VT0iLCJuYmYiOjE3MDg3Mjg3MTAsImV4cCI6MTcwODgxNTExMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.8DX2oN0NmaNi_VQUHKqxsqbvxCD5aV12zZWsx5EJOMU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkYWFkOGM4OC01YTMyLTQ4YTctOTc3Ny1jMzJmNTgzODZlODYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODcxMCwiZXhwIjoxNzA4NzI5NjEwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.4Fy7pUehtjeDxqNF2hboaXJUzvE5OGiLOVfoxU5qx6s', CAST(N'2024-02-24T19:51:50.427' AS DateTime), CAST(N'2024-02-23T20:06:50.427' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:51:50.427' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7e189f7c-0afb-4e8b-93d7-c25857d30eac', N'd571047a-d524-4604-8603-8f7a3513a360', N'gnas_SAbCtlHFFZ-ZPT3mWSeMMpi2jkj_Y-oSHDLBo0', N'XKmoIX_V_3JzDqypUx5R8FzVRSeDpNbZSzDzEH6zA5k', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ZTE4OWY3Yy0wYWZiLTRlOGItOTNkNy1jMjU4NTdkMzBlYWMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYZTlFQi9sbXRwSU5JTDJoSzRlSWFUVFVtN21yRU5FcGZpc0RrcjdFRXRaKytuang2eXVscURqWW5GeDZjTDNYTlpVaGtwNk92NUc5UGNRWnhFSEt4eGpMN3lwazFWSkIxVzNLUVY0dE4rdmlKRE5BeUdyN043TWIyTTV4d1FucFBNMmRlQWhnNzBJaHVXSVRtOTJTTm5aZ0orUmtMSXJOdEUzR0lKWVNQRGZiZzRVVlR0dWs2bnNDQ0s5OVp1Ykt0R3lzdHRVRWRNZUgwQUFVcmRLSEVrNUpTN0J0SUdROUlEKzlVelFTRWtVVTdnd0pmcmNTWlltTzN5aWd5VzNXVTdaZTVXMk1LYm1hcENXc0t0SW5UZz0iLCJuYmYiOjE3MDg3Mjc0NjUsImV4cCI6MTcwODgxMzg2NSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.gnas_SAbCtlHFFZ-ZPT3mWSeMMpi2jkj_Y-oSHDLBo0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkNTcxMDQ3YS1kNTI0LTQ2MDQtODYwMy04ZjdhMzUxM2EzNjAiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNzQ2NSwiZXhwIjoxNzA4NzI4MzY1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.XKmoIX_V_3JzDqypUx5R8FzVRSeDpNbZSzDzEH6zA5k', CAST(N'2024-02-24T19:31:05.053' AS DateTime), CAST(N'2024-02-23T19:46:05.053' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:31:05.057' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7e935d6d-e5d4-4978-b1f2-7c04c9c0e265', N'f345cf8f-f483-4716-8596-0fb8e68a3cb4', N'go8Y3ZaQOBpfl7lVefCZQoLT7p35JsuujBpdVrUrET4', N'5SPUkgKwoQ8sF5tMuvXKpDILZvc4wfIwfvL3ZmS4abQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ZTkzNWQ2ZC1lNWQ0LTQ5NzgtYjFmMi03YzA0YzljMGUyNjUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVlL3JoeER2aW5XQk93aitldW56THozRnV6NkZwNFk5dU13aFF2U2Fad0RzSGNERGJLN21BbDcwam1XK0hVTFUzdHdCSHBrTW5TOXd4Mi95blNlZWxPaStvRHdZVTdOMm5xTGFQNHpWM3l4YXgrUWw2NGJPR3A3Mk5Mb3dmcjdzQlJjVjcyYVRuVFRscGpzNUtOQ3ZBOGdUOTdhdXppR0dQQTBKWlVyU0FqalQ4TnRSZmVWZnQrQ0R6cWpSaitrL2hhdC95cklrRlQvTTFuN3EydHJTVm02TEY4R0NVc2UxYmFFU21CYUIweHZVaENJNG1VR0ZvWlpQVGN3bzduemJBVUpTa2Jnd1I0dzE2b2dIN2RoSFhaVmdTYTZkdXZ6MUpFN0t3KzZjakhObSIsIm5iZiI6MTcwODcyODY5NiwiZXhwIjoxNzA4ODE1MDk2LCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.go8Y3ZaQOBpfl7lVefCZQoLT7p35JsuujBpdVrUrET4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmMzQ1Y2Y4Zi1mNDgzLTQ3MTYtODU5Ni0wZmI4ZTY4YTNjYjQiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODY5NiwiZXhwIjoxNzA4NzI5NTk2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.5SPUkgKwoQ8sF5tMuvXKpDILZvc4wfIwfvL3ZmS4abQ', CAST(N'2024-02-24T19:51:36.733' AS DateTime), CAST(N'2024-02-23T20:06:36.733' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0', CAST(N'2024-02-23T19:51:36.753' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7f997626-38ff-4e93-b9de-e2a64b0d6426', N'b64660c9-6c31-476b-a94d-b336a09d4b18', N'KG0v5VPtXfCOgZZF52m6_ffiMGVpZCbhVJng8SB-voI', N'gaVnjrk6TlW4Fowy5AO7Q8jviHAsK4MZ89RA6xUXSAY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3Zjk5NzYyNi0zOGZmLTRlOTMtYjlkZS1lMmE2NGIwZDY0MjYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRcjJVZjdoRmYwc05RNzhZNmpBeksrR3FuMWp3ZXhlT09KU1ZUWXR3Rkg5aFh6N3p1RjZtc2lqL094OFJxem04WGQzZHVySy92R0pVMUZOTGZITmVaQXp3bC9rdjdtckY1WFArTEFMVWlSM3M2ZmpaNFcxbGo4bW5zbkJueHV4Ti9LajNBRmM0UVo4NzlCYWNocmxPUEEyTDkzcG9LNjFybUVtd2huOGFvNG9zME4vZEJlU1E5REN1dFdrTkVtdFZDU0lRU1EvTExKcnduV0FFdzJsZTd2S2M4NkQ1NnppbGYzMjgzWk9CQ3lHdTY4Ukc4TDVzZjlUMnVTSXE1OGFqUTVvUWdGNzRkTlI0dHk5akVpdkNyMD0iLCJuYmYiOjE3MDg3MjU4MDYsImV4cCI6MTcwODgxMjIwNiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.KG0v5VPtXfCOgZZF52m6_ffiMGVpZCbhVJng8SB-voI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiNjQ2NjBjOS02YzMxLTQ3NmItYTk0ZC1iMzM2YTA5ZDRiMTgiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNTgwNiwiZXhwIjoxNzA4NzI2NzA2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.gaVnjrk6TlW4Fowy5AO7Q8jviHAsK4MZ89RA6xUXSAY', CAST(N'2024-02-24T19:03:26.717' AS DateTime), CAST(N'2024-02-23T19:18:26.717' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:03:26.720' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'91adf169-ef13-4303-bd5c-938b6eaa1728', N'e51ce532-ad73-445a-a26f-2b8986996aea', N'hRfjDNhxd3B99AnsWJtL2xh1JKpymLzUPBAbrFrS3Nw', N'98wJIMWBr0d7G0R4EhfbyvQar97g53iCW28rGGVybLE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5MWFkZjE2OS1lZjEzLTQzMDMtYmQ1Yy05MzhiNmVhYTE3MjgiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVL2lxdHNRZkRESmJ6ayt0aFR4b3ZaZjV0cjlYTGZUdnJPTnk4WHBCRVkvS1I5QUhYaGZRanhUNGVqbjRaZGo5QWlkSnlndHZvbkFpUzIyZ1NUUHQ5QWF4cXY4MjNwa0xKTkxwRCtobVo1WHgwN09pME1DVVJCWUh4UU9MZGI5clVEK0hVMHZaeVBWQ1FGeTZkWFFBS0grOUpLYTBYNWlvYmxzVDZBcVNCeG5yVm41U0w3ZjBNQ01CTWhabFVOeG56cmhGL3NzZnYyT0NsUXNaVElZVmcvNDdOQlNVZUNHUDRvVlJtQVlPYVZERXZDd0l0VnpZTlh1NHc5bjFEVFJtWDFxMjlMRExMK1JrUVZ0ZG0xbHRwVUhVWk5GMG90MHIwRWhsbnN2TlRjcCIsIm5iZiI6MTcwODU2NDExMiwiZXhwIjoxNzA4NjUwNTEyLCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.hRfjDNhxd3B99AnsWJtL2xh1JKpymLzUPBAbrFrS3Nw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTFjZTUzMi1hZDczLTQ0NWEtYTI2Zi0yYjg5ODY5OTZhZWEiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODU2NDExMiwiZXhwIjoxNzA4NTY1MDEyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.98wJIMWBr0d7G0R4EhfbyvQar97g53iCW28rGGVybLE', CAST(N'2024-02-22T22:08:32.517' AS DateTime), CAST(N'2024-02-21T22:23:32.517' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0', CAST(N'2024-02-21T22:08:32.517' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ccc86000-37c3-4c1a-bcb5-016f55a7e158', N'd876db90-27ac-4abd-a443-6e6b79b1b261', N'NIP1TEXf2wOGZYTw3yt7AUJPBOwxxXQJ2by1_CQ5BU0', N'Z7O20gZHSUS5DJZGTrUwRShcig-W3ErBDSf1P-zqaWU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjY2M4NjAwMC0zN2MzLTRjMWEtYmNiNS0wMTZmNTVhN2UxNTgiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVL3E3VTU1RWFTTWFoMXBYQklYU2RvMjZmM09JM0RvcW51UTRNUTFYcWxzM2xxUm9EK3FTTjhXMW4yRnZyU2RSMzQxRmgrMnAvTE9VU2ZvcEQzV2VXZWt5YW9GSEVhRlBHSHYzU0lqeGZvZWFkbERoNndTVHdBWFd1QnRtSXpwbzJEbG44MG1JbjJJTGpxdCtYbi9Ga2s1REFoenJoaWM0ZjlLT2IzTUQrR1FQNmxJSmsxc1pQMlRVNUhEcmwzeWJPOTZONkRqRjBzN2RPZGtHYTFjai9xbkpBaWxUeDBuSE5QeTlvaThaMzNGaHZvOW9UeVRZaU5UMkwzWXhCM0trTStnN2EvTGpjVXVSMHRKMWsyQVJFZz0iLCJuYmYiOjE3MDg3MjY3NjEsImV4cCI6MTcwODgxMzE2MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.NIP1TEXf2wOGZYTw3yt7AUJPBOwxxXQJ2by1_CQ5BU0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkODc2ZGI5MC0yN2FjLTRhYmQtYTQ0My02ZTZiNzliMWIyNjEiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNjc2MSwiZXhwIjoxNzA4NzI3NjYxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.Z7O20gZHSUS5DJZGTrUwRShcig-W3ErBDSf1P-zqaWU', CAST(N'2024-02-24T19:19:21.337' AS DateTime), CAST(N'2024-02-23T19:34:21.337' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:19:21.340' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'd060652d-26a4-4f4c-ae8b-4e98ab45cab7', N'fd96b282-482f-498d-b47f-2f6bb68749e4', N'h-ks-_vFQsTSE5daoh9DcddCCXeGeoKIW_amSWQNdO4', N'4LTx3BDky6mpZMBgp7o97PQoYFlRG38Vw9dBMohUJ78', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkMDYwNjUyZC0yNmE0LTRmNGMtYWU4Yi00ZTk4YWI0NWNhYjciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVTckJlRjZPK05OYlRMTDFjRytjYWtYNStHZWxoSXJOdUFhN20ycVkrbU5hd3dHVzhPVEl1OGdRUFRwUVZsOTY0UlJUK0wxZ2hFb1lSZHNwczFpZnBjS0NrT1E3azJBbmVnN3l4bUZ4Kzl3YWZqNURuQnpaYmdHREhCZjVsWWwxdVRUYlZnQk9ZSmFCT1RWRFZDRm05UnFwZFBjMG9UZlFvN3FwZGNGaFozalpjRmdDS3pkOG80aU41UFhJZGFGakxLanFndWZrL1NyUFZJTnkyWnJ4NnVObXBtSWY1RmNYTVQxdCtHRjJYeDg4NzFYUGllVGV3K0FPdDIxZDBHbVFNOHB4RStKZzhJQlVGemhQYWp0Yi9nND0iLCJuYmYiOjE3MDg3MjcyNzAsImV4cCI6MTcwODgxMzY3MCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.h-ks-_vFQsTSE5daoh9DcddCCXeGeoKIW_amSWQNdO4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmZDk2YjI4Mi00ODJmLTQ5OGQtYjQ3Zi0yZjZiYjY4NzQ5ZTQiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNzI3MCwiZXhwIjoxNzA4NzI4MTcwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.4LTx3BDky6mpZMBgp7o97PQoYFlRG38Vw9dBMohUJ78', CAST(N'2024-02-24T19:27:50.523' AS DateTime), CAST(N'2024-02-23T19:42:50.523' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:27:50.520' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'e04ba7a2-0713-4e56-bb29-6bdaf00be74c', N'62bc80a0-a395-4f65-8d7d-c481190c774c', N'FI2MHXlyjRmnSi-DqZ00vcmnK6MaAQEHrbkaKldxZNQ', N'mUewyK_E1tMDy0JBBTbIQNM2Br5HvNgksLl3WCjE3R8', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlMDRiYTdhMi0wNzEzLTRlNTYtYmIyOS02YmRhZjAwYmU3NGMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWNkRHM0YrdUlPU2tiZURtTFBaalRTRytSU1puYW81OGxRTUFDbnY2dW1yaXVSMlFWZmxhRzJBM0dWNzJIWnVpOEI0c2NvSDBaUDd5TTlDMjIzWGY3WEcvVW5iTEVHemRyUkhhSG94WHE3ZXR1cjdFV2lNTDQ4WnZiUlhEK2Z1WGw0ejRabE0xMUxyNlFGTC9PQW5QL00zckVlZU9yWlNaRUQ0QXI1blo5M3B1UnJqaDZINGJIMWNISDY5MG9iYkxpL0ZCclFwZlJrVTZLNnhTZzlnMU1sNWt2VkY3UXVTVldrVXR1QUdGRTlaREdhWk12aUdPQjV3aWtJVHlVNU0vRkI0b2lYcGVySDIyZWRoZUdncTlsTT0iLCJuYmYiOjE3MDg3Mjg2NzMsImV4cCI6MTcwODgxNTA3MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.FI2MHXlyjRmnSi-DqZ00vcmnK6MaAQEHrbkaKldxZNQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MmJjODBhMC1hMzk1LTRmNjUtOGQ3ZC1jNDgxMTkwYzc3NGMiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODY3MywiZXhwIjoxNzA4NzI5NTczLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.mUewyK_E1tMDy0JBBTbIQNM2Br5HvNgksLl3WCjE3R8', CAST(N'2024-02-24T19:51:13.600' AS DateTime), CAST(N'2024-02-23T20:06:13.600' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:51:13.600' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ee0a2d3d-8462-47cf-b1aa-f300170560b7', N'ab44e0cc-f71d-4b41-9b54-2bfa11ee0f25', N'F4oFUGcQaV-4pz44UnSnXN4JcRrcEV7ck3OYTQTD2rQ', N'C6JiMLrcwtPWblblk2uCi9pDTbK00N-__QcdM3P8nRI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlZTBhMmQzZC04NDYyLTQ3Y2YtYjFhYS1mMzAwMTcwNTYwYjciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmak5FZ0Q1MVNiajU0YWd3aEVnQTJSRmY1TTZnUkF1N2pNelZsN2thOElIWXR4U2xFM2ZaNUxWNjQ2N2VBaDJyMzNDR25jMm03OXZyc2xwZTVPckxXYzBoZGl3VnExeDllZW1kZWcwTDF0cU5IeDU0WUxUc0FhWEtpdi9JNUxjM2FTb2NsQ216ZWJSTEh5bFp4RkNZTDUzcTlQQTlJb1ZFcG50QndBMmg1UkMwdzhjOGlWdVl6WnJ3UEI2dFcyRzhreGd6aWZacWh2RXN2SjdDUnE2T0lDNUtUYjJxUTJKVEZKMk4zKzF4TkZZYnVEOWFnNDBrS04zclN5djF5Vm1XZG5zTXNMSi9TK04xM1JpQ2pDUUY4WT0iLCJuYmYiOjE3MDg3MjQ2NzEsImV4cCI6MTcwODgxMTA3MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.F4oFUGcQaV-4pz44UnSnXN4JcRrcEV7ck3OYTQTD2rQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhYjQ0ZTBjYy1mNzFkLTRiNDEtOWI1NC0yYmZhMTFlZTBmMjUiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNDY3MSwiZXhwIjoxNzA4NzI1NTcxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.C6JiMLrcwtPWblblk2uCi9pDTbK00N-__QcdM3P8nRI', CAST(N'2024-02-24T18:44:31.163' AS DateTime), CAST(N'2024-02-23T18:59:31.163' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T18:44:31.163' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TypesImpairment] ON 
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (1, N'Discapacidad Física o Motora')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (2, N'Discapacidad Sensorial')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (3, N'Discapacidad Intelectual')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (4, N'Discapacidad Psíquica')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (5, N'Discapacidad Visual')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (6, N'Discapacidad Auditiva')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (7, N'Trastorno del Espectro Autista')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (8, N'Discapacidad del Habla')
GO
SET IDENTITY_INSERT [dbo].[TypesImpairment] OFF
GO
ALTER TABLE [dbo].[ActionLog]  WITH CHECK ADD  CONSTRAINT [FK_ActionLog_ActionType] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ActionType] ([ActionTypeId])
GO
ALTER TABLE [dbo].[ActionLog] CHECK CONSTRAINT [FK_ActionLog_ActionType]
GO
ALTER TABLE [dbo].[ActionLog]  WITH CHECK ADD  CONSTRAINT [FK_ActionLog_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[ActionLog] CHECK CONSTRAINT [FK_ActionLog_Contacts]
GO
ALTER TABLE [dbo].[ContactXEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContactXEvent_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[ContactXEvent] CHECK CONSTRAINT [FK_ContactXEvent_Contacts]
GO
ALTER TABLE [dbo].[ContactXEvent]  WITH CHECK ADD  CONSTRAINT [FK_ContactXEvent_event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[ContactXEvent] CHECK CONSTRAINT [FK_ContactXEvent_event]
GO
ALTER TABLE [dbo].[ContactXTypeImplairment]  WITH CHECK ADD  CONSTRAINT [FK_ContactXTypeImplairment_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[ContactXTypeImplairment] CHECK CONSTRAINT [FK_ContactXTypeImplairment_Contacts]
GO
ALTER TABLE [dbo].[ContactXTypeImplairment]  WITH CHECK ADD  CONSTRAINT [FK_ContactXTypeImplairment_TypeImplairment] FOREIGN KEY([TypeId])
REFERENCES [dbo].[TypesImpairment] ([TypeId])
GO
ALTER TABLE [dbo].[ContactXTypeImplairment] CHECK CONSTRAINT [FK_ContactXTypeImplairment_TypeImplairment]
GO
ALTER TABLE [dbo].[DenyObject]  WITH CHECK ADD  CONSTRAINT [FK_DenyObject_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[DenyObject] CHECK CONSTRAINT [FK_DenyObject_Contacts]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK__Events__ContactA__5FB337D6] FOREIGN KEY([ContactAudit])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK__Events__ContactA__5FB337D6]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK__Events__StateId__5EBF139D] FOREIGN KEY([ContacCreate])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK__Events__StateId__5EBF139D]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_States] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([StateId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_Events_States]
GO
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD  CONSTRAINT [FK__Posts__ContactAu__7E37BEF6] FOREIGN KEY([ContactAudit])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK__Posts__ContactAu__7E37BEF6]
GO
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD  CONSTRAINT [FK__Posts__StateId__7D439ABD] FOREIGN KEY([ContacCreate])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK__Posts__StateId__7D439ABD]
GO
ALTER TABLE [dbo].[Posts]  WITH CHECK ADD  CONSTRAINT [FK_Posts_States] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([StateId])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK_Posts_States]
GO
ALTER TABLE [dbo].[PostsXTypesImpairment]  WITH CHECK ADD  CONSTRAINT [FK_PostsXTypesImpairment_Posts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([PostId])
GO
ALTER TABLE [dbo].[PostsXTypesImpairment] CHECK CONSTRAINT [FK_PostsXTypesImpairment_Posts]
GO
ALTER TABLE [dbo].[PostsXTypesImpairment]  WITH CHECK ADD  CONSTRAINT [FK_PostsXTypesImpairment_TypesImpairment] FOREIGN KEY([TypeId])
REFERENCES [dbo].[TypesImpairment] ([TypeId])
GO
ALTER TABLE [dbo].[PostsXTypesImpairment] CHECK CONSTRAINT [FK_PostsXTypesImpairment_TypesImpairment]
GO
/****** Object:  StoredProcedure [dbo].[ActionLog_GetActions]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActionLog_GetActions]
(
	@ContactId INT,
	@ResultCode INT OUTPUT
)
AS

/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		-- Tabla de actiones de usuario
			SELECT 
				AL.ActionLogId,
				AL.DateEntered,
				AT.[Description],
				dbo.SearchTypesImpairment(AL.filters) 'FiltersDescription',
				AL.SearchText,
				CASE ObjectKey
					-- contacts
					WHEN 'ContactId' THEN C.LastName + ', ' + C.FirstName
					-- Events
					WHEN 'EventId' THEN E.Title
					-- Posts
					WHEN 'PostId' THEN P.Title
					-- Busqueda
					ELSE 'Texto buscardo: ' + AL.SearchText
				END 'ActionDone',
				CASE WHEN ISNULL(AL.ContactId,0) <> 0 THEN AC.LastName + ', ' + AC.FirstName ELSE NULL END 'ContactAction'
			FROM ActionLog (NOLOCK) AL
				INNER JOIN ActionType (NOLOCK) AT
				 ON AL.ActionTypeId = AT.ActionTypeId
				LEFT JOIN [Events] (NOLOCK) E
					ON E.EventId = AL.ObjectId AND AL.ObjectKey = 'EventId'
				LEFT JOIN [Posts] (NOLOCK) P
					ON P.PostId = AL.ObjectId AND AL.ObjectKey = 'PostId'
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId= AL.ObjectId AND AL.ObjectKey = 'ContactId'
				LEFT JOIN [Contacts] (NOLOCK) AC
					ON AC.ContactId = AL.ContactId
			ORDER BY AL.DateEntered DESC

			-- Tabla de los 5 post con mas visitas
			SELECT TOP 5
				AL.ObjectKey,
				COUNT(AL.ObjectId) 'Viewrs',
				AL.ObjectId,
				P.Title,
				C.LastName + ', ' + C.FirstName AS 'name'
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN [Posts] (NOLOCK) P
					ON P.PostId = AL.ObjectId
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId = P.ContacCreate
			WHERE AL.ActionTypeId = 12
			GROUP BY AL.ObjectId, P.Title, C.LastName, C.FirstName, AL.ObjectKey 
			ORDER BY 2 DESC

			-- Tabla de los 5 events con mas visitas
			SELECT TOP 5
				AL.ObjectKey,
				COUNT(AL.ObjectId) 'Viewrs',
				AL.ObjectId,
				E.Title,
				C.LastName + ', ' + C.FirstName AS 'name'
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN [Events] (NOLOCK) E
					ON E.EventId = AL.ObjectId
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId = E.ContacCreate
			WHERE AL.ActionTypeId = 11
			GROUP BY AL.ObjectId, E.Title, C.LastName, C.FirstName, AL.ObjectKey
			ORDER BY 2 DESC

			-- Tabla de los 5 perfiles con mas visitas
			SELECT TOP 5
				AL.ObjectKey,
				COUNT(AL.ObjectId) 'Viewrs',
				AL.ObjectId,
				C.LastName + ', ' + C.FirstName AS 'name'
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId = AL.ObjectId
			WHERE AL.ActionTypeId = 13
			GROUP BY AL.ObjectId, C.LastName, C.FirstName, AL.ObjectKey
			ORDER BY 2 DESC

			-- Grafico de tipos de discapacidad mas buscados
			SELECT
				COUNT(TI.TypeId) 'CountSearchs',
				TI.TypeId,
				TI.[Description]
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN TypesImpairment (NOLOCK) TI
				 ON TypeId IN (SELECT value FROM STRING_SPLIT(AL.filters , ','))
			WHERE AL.ActionTypeId = 1 AND al.filters IS NOT NULL
			GROUP BY TI.TypeId, TI.[Description]
			ORDER BY 1 DESC

		SET @ResultCode = 200
	END
  ELSE
	BEGIN
		SET @ResultCode = 401
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Blocked]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Blocked]
(
	@ContactId INT,
	@ContactLoggedId INT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @ContactLoggedId INT = 1
*/

IF (
	SELECT TOP 1 
		C.ContactId 
	FROM Contacts (NOLOCK) C 
	WHERE C.ContactId = @ContactLoggedId AND ISNULL(C.Auditor, 'False') <> 'False') IS NOT NULL
	BEGIN
		IF (
			SELECT TOP 1 
				C.ContactId 
			FROM Contacts (NOLOCK) C 
			WHERE C.ContactId = @ContactId) IS NOT NULL
			BEGIN
				UPDATE Contacts 
				SET Blocked = 'True' 
				WHERE ContactId = @ContactId AND ISNULL(Confirm, 'False') <> 'False'
				
				IF @@ROWCOUNT = 0
					BEGIN 
						SET @ResultCode = 404 
					END
				  ELSE
					BEGIN 
						DELETE FROM Tokens 
						WHERE JSON_VALUE(Claims, '$[0].Value') = CAST(@contactId AS NVARCHAR(255))
							AND JSON_VALUE(Claims, '$[0].Key') = 'ContactId';
						SET @ResultCode = 200
					END
			END
		  ELSE 
			BEGIN
				SET @ResultCode = 404
			END
	END
  ELSE 
	BEGIN
		SET @ResultCode = 401
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Change_Recover_Password]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Change_Recover_Password]
(
	@ContactId INT,
	@CodeRecover VARCHAR(100),
	@Password VARCHAR(100),
	@ResultCode INT OUTPUT
)
AS

SET @ResultCode = 200

IF (SELECT COUNT(ContactId) 
	FROM Contacts (NOLOCK) 
	WHERE 
		CodeRecover = @CodeRecover 
		AND
		ContactId = @ContactId
		AND
		ExpiredRecover IS NOT NULL
		AND
		GETDATE() <= ExpiredRecover) > 0
	BEGIN

		UPDATE Contacts
		SET
			[Password] = @Password,
			ExpiredRecover = GETDATE()
		WHERE ContactId = @ContactId

		IF @@ROWCOUNT = 0 
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'ContactId', 
					@ContactId,
					@ContactId,
					14,
					GETDATE()
				)


				SET @ResultCode = 200
			END
	END
  ELSE 
	BEGIN

		SET @ResultCode = 5912

	END

GO
/****** Object:  StoredProcedure [dbo].[Contact_ChangePassword]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_ChangePassword]
(
	@ContactId INT,
	@LastPassword VARCHAR(100),
	@NewPassword VARCHAR(100),
	@ResultCode INT OUTPUT
)
AS


/*
-- Para testing
DECLARE @ContactId INT = 1
DECLARE @LastPassword VARCHAR(100) = 'ed78vWPkU9hDRVUf10qkfA=='
DECLARE	@NewPassword VARCHAR(100) = 'OAqUPf+4PtAiey0+UVBDkA=='
DECLARE @ResultCode INT
*/


SET @ResultCode = 200

IF (SELECT COUNT(ContactId) FROM Contacts (NOLOCK) WHERE ContactId = @ContactId AND [Password] = @NewPassword ) <> 0
	BEGIN
		SET @ResultCode = 5911
	END
	
IF @ResultCode = 200 AND (SELECT COUNT(ContactId) FROM Contacts (NOLOCK) WHERE ContactId = @ContactId AND [Password] != @LastPassword ) <> 0
	BEGIN
		SET @ResultCode = 5909
	END


IF @ResultCode = 200
	BEGIN
		UPDATE Contacts 
		SET [Password] = @NewPassword
		WHERE ContactId = @ContactId

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE 
			BEGIN
				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'ContactId', 
					@ContactId,
					@ContactId,
					15,
					GETDATE()
				)
				SET @ResultCode = 200 
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Confirm]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Confirm]
(
	@ContactId INT,
	@ConfirmCode VARCHAR(100) OUTPUT,
	@ResultCode INT OUTPUT
)
AS

SET @ResultCode = 200

UPDATE Contacts 
		SET [Confirm] = 'True'
		WHERE 
			ContactId = @ContactId
			AND
			ConfirmCode = @ConfirmCode

GO
/****** Object:  StoredProcedure [dbo].[Contact_CredentialsLogin]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Contact_CredentialsLogin]
(
	@Email VARCHAR(100),
	@UserPassword VARCHAR(MAX),
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @Email VARCHAR(100)
SET @Email = 'gastonvottero@hotmail.com'
DECLARE @UserPassword VARCHAR(100)
SET @UserPassword = 'ed78vWPkU9hDRVUf10qkfA=='
DECLARE @ResultCode INT
*/

DECLARE @ContactId INT
SET @ResultCode = 200

SELECT TOP 1 @ContactId = ContactId 
FROM Contacts (NOLOCK) C
WHERE @Email = C.Email 
	AND @UserPassword = C.Password
	AND DateDeleted IS NULL


IF (@ContactId IS NULL) 
	BEGIN 
		SET @ResultCode = 404
	END

IF @ResultCode = 200 AND (SELECT TOP 1 ISNULL([Confirm], 'False') FROM Contacts (NOLOCK) C WHERE ContactId = @ContactId AND @ContactId IS NOT NULL) = 'False'
	BEGIN 
		SET @ResultCode = 5919
	END

IF @ResultCode = 200 AND (SELECT TOP 1 ISNULL(Blocked, 'False') FROM Contacts (NOLOCK) C WHERE ContactId = @ContactId AND @ContactId IS NOT NULL  ) = 'True'
	BEGIN 
		SET @ResultCode = 5920
	END

IF @ResultCode = 200 
	BEGIN

		SELECT @ContactId AS 'ContactId'


		INSERT INTO ActionLog 
		(
			ObjectKey, 
			ObjectId,
			ContactId,
			ActionTypeId,
			DateEntered
		) 
		VALUES 
		(
			'ContactId', 
			@ContactId,
			@ContactId,
			18,
			GETDATE()
		)
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Delete]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Contact_Delete]
(
    @ContactId INT,
	@Password VARCHAR(MAX),
	@ResultCode INT OUTPUT
)
AS


/*
--para test
DECLARE @ContactId INT
DECLARE	@Password VARCHAR(MAX)
DECLARE @ResultCode AS INT

SET @ContactId = 2
SET @Password = 'ed78vWPkU9hDRVUf10qkfA==' 

*/

DECLARE @Now DATETIME = GETDATE()
DECLARE @ContentAux TABLE 
(
	[Key] VARCHAR(100),
	Id INT
)


SET @ResultCode = 5921

IF (
	SELECT ContactId
	FROM Contacts (NOLOCK)
	WHERE 
		ContactId = @ContactId 
		AND DateDeleted IS NULL 
		AND @Password = [Password]
		AND ISNULL(Confirm, 'False') <> 'False' 
		AND ISNULL(Blocked, 'False') <> 'True'
	) IS NOT NULL
	BEGIN
		SET @ResultCode = 200
	END


IF @ResultCode = 200
	BEGIN 
		INSERT INTO @ContentAux
		SELECT 'PostId', PostId FROM Posts (NOLOCK) WHERE ContacCreate = @ContactId

		INSERT INTO @ContentAux
		SELECT 'EventId', EventId FROM [Events] (NOLOCK) WHERE ContacCreate = @ContactId


		UPDATE [Posts] SET DateDeleted = @Now WHERE PostId IN (SELECT Id FROM @ContentAux WHERE [Key] = 'PostId')
		UPDATE [Events] SET DateDeleted = @Now WHERE EventId  IN (SELECT Id FROM @ContentAux WHERE [Key] = 'EventId')
		UPDATE [Contacts] SET DateDeleted = @Now, Notifications = 'False' WHERE ContactId = @ContactId

		-- Repetir por todos los elementos que hay en @ContentAux 
		DECLARE curContentAux CURSOR FOR
		SELECT [Key], Id FROM @ContentAux

		DECLARE @ObjectKey VARCHAR(100)
		DECLARE @ObjectId INT
		OPEN curContentAux
		FETCH NEXT FROM curContentAux INTO @ObjectKey, @ObjectId

		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					@ObjectKey, 
					@ObjectId,
					@ContactId,
					10,
					GETDATE()
				)

				FETCH NEXT FROM curContentAux INTO @ObjectKey, @ObjectId
			END

		CLOSE curContentAux
		DEALLOCATE curContentAux

	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Deny_Recover]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Deny_Recover]
(
	@ContactId INT,
	@CodeRecover VARCHAR(100),
	@ResultCode INT OUTPUT
)
AS

SET @ResultCode = 200


UPDATE Contacts
SET
	ExpiredRecover = GETDATE()
WHERE 
	ContactId = @ContactId
	AND 
	CodeRecover IS NOT NULL
	AND 
	CodeRecover = @CodeRecover

IF @@ROWCOUNT > 0
	BEGIN 
		SET @ResultCode = 200 
	END
  ELSE 
	BEGIN
		SET @ResultCode = 404
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_GetAll]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Contact_GetAll]
(
	@ContactId INT,
	@ResultCode INT OUTPUT
)

AS

/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		SET @ResultCode = 200

		SELECT
			ContactId,
			FirstName,
			LastName,
			UserName,
			LastName + ', ' + FirstName 'Name',
			email,
			ISNULL(Auditor, 'False') 'Auditor',
			ISNULL(Trusted, 'False') 'Trusted',
			ISNULL(Blocked, 'False') 'Blocked',
			Notifications,
			DateBrirth,
			ImageUrl
		FROM Contacts (NOLOCK) 
		WHERE ISNULL(Confirm, 'False') <> 'False'
		AND DateDeleted IS NULL

	END
  ELSE
	BEGIN
		SET @ResultCode = 5910
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_GetById]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_GetById]
(
	@ContactId INT,
	@ActionLog INT
)

AS


/*
--para test
DECLARE @ContactId INT = 1
DECLARE @ActionLog INT = 0
*/


SELECT
	ContactId,
	FirstName,
	LastName,
	UserName,
	LastName + ', ' + FirstName 'Name',
	email,
	ISNULL(Auditor, 'False') 'Auditor',
	ISNULL(Trusted, 'False') 'Trusted',
	ISNULL(Notifications, 'True') AS 'Notifications',
	DateBrirth,
	ImageUrl
FROM Contacts (NOLOCK) 
WHERE ContactId = @ContactId

IF EXISTS (SELECT ContactId FROM Contacts (NOLOCK)WHERE ContactId = @ContactId) AND @ActionLog = 1
	BEGIN
		INSERT INTO ActionLog 
		(
			ObjectKey, 
			ObjectId,
			ContactId,
			ActionTypeId,
			DateEntered
		) 
		VALUES 
		(
			'ContactId', 
			@ContactId,
			@ContactId,
			13,
			GETDATE()
		)
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_GetByIdInformation]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Contact_GetByIdInformation]
(
	@ContactLoggedId INT,
	@ContactId INT,
	@ResultCode INT OUTPUT
)

AS

/*
-- para trest
DECLARE @ContactLoggedId INT = 1
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		SET @ResultCode = 404 
		
		SELECT
			ContactId,
			FirstName,
			LastName,
			UserName,
			LastName + ', ' + FirstName 'Name',
			email,
			ISNULL(Auditor, 'False') 'Auditor',
			ISNULL(Trusted, 'False') 'Trusted',
			ISNULL(Notifications, 'True') AS 'Notifications',
			DateBrirth,
			ImageUrl
		FROM Contacts (NOLOCK) 
		WHERE 
			ContactId = @ContactId
			AND
			ISNULL(Confirm, 'False') <> 'False'
	END
  ELSE
	BEGIN
		SET @ResultCode = 5910
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_RecoverPassword]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Contact_RecoverPassword]
(
	@Email VARCHAR(100),
	@CodeRecover VARCHAR(100) OUTPUT,
	@FirstName VARCHAR(100) OUTPUT,
	@UserName VARCHAR(100) OUTPUT,
	@ContactId INT OUTPUT,
	@ResultCode INT OUTPUT
)

AS

SET @ResultCode = 200
SET @CodeRecover = NEWID()

SET @ContactId = 0

SELECT TOP 1 
	@ContactId = ContactId,
	@UserName = ISNULL(UserName,''),
	@FirstName = ISNULL(FirstName,'')
FROM Contacts WHERE Email = @Email

IF @ContactId <> 0
	BEGIN
		UPDATE Contacts 
			SET [CodeRecover] = @CodeRecover,
			ExpiredRecover = DATEADD(hh, 4, GETDATE())
			WHERE ContactId = @ContactId
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Regisrter]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Regisrter]
(
	@Email VARCHAR(100),
	@UserName VARCHAR(100),
	@LastName VARCHAR(100),
	@FirstName VARCHAR(100),
	@Password VARCHAR(100),
	@DateBrirth Date,
	@Notifications BIT,
	@ConfirmCode VARCHAR(100) OUTPUT,
	@ResultCode INT OUTPUT,
	@ContactId INT OUTPUT
)

AS

/*
--para test
DECLARE @Email VARCHAR(100)
DECLARE @Password VARCHAR(100)
DECLARE @LastName VARCHAR(100)
DECLARE @UserName VARCHAR(100)
DECLARE @FistName VARCHAR(100)
DECLARE @DateBrirth Date
DECLARE @ResultCode INT
DECLARE @Notifications BIT

SET @Email = 'Gastonvottero@gmail.com'
SET @Password = 'GQfx8ucJ62jDe7AbgeEW5A=='
SET @LastName = 'Test'
SET @FistName = 'Test'
SET @UserName = 'Test'
SET @DateBrirth = GETDATE()
*/

SET @ConfirmCode = NEWID()
SET @ResultCode = 200
DECLARE @ContactAux INT = 0;

IF (@UserName IS NULL OR @UserName = '')
	BEGIN
		SET @ResultCode = 5001
	END

IF (@Password IS NULL OR @Password = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5002
	END

IF (@Email IS NULL OR @Email = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5003
	END

IF (@FirstName IS NULL OR @FirstName = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5004
	END

IF (@LastName IS NULL OR @LastName = '') AND @ResultCode = 200
	BEGIN
		SET @ResultCode = 5005
	END


IF (SELECT  COUNT(ContactId) FROM Contacts (NOLOCK) WHERE Email = @Email AND ISNULL([Confirm], 'False') <> 'False') > 0 AND @ResultCode = 200
	BEGIN
		SET @ResultCode = 5906
	END

IF @ResultCode = 200
	BEGIN
		SELECT TOP 1 @ContactAux = ISNULL(ContactId,0) FROM Contacts (NOLOCK) WHERE Email = @Email AND ISNULL([Confirm], 'False') = 'False'
		IF @ContactAux <> 0
			BEGIN
				UPDATE Contacts
				SET
					FirstName = @FirstName, 
					LastName = @LastName, 
					Email = @Email, 
					[Password] = @Password, 
					UserName = @UserName, 
					DateBrirth =  @DateBrirth, 
					[Confirm] = 'False',
					ConfirmCode = @ConfirmCode, 
					Notifications = @Notifications,
					dateEntered = GETDATE()
				WHERE ContactId = @ContactAux

				SET @ContactId = @ContactAux
			END
		  ELSE
			BEGIN
				INSERT INTO Contacts (FirstName, LastName, Email, [Password], UserName, DateBrirth, [Confirm], ConfirmCode, dateEntered) 
				VALUES (@FirstName, @LastName, @Email,@Password, @UserName, @DateBrirth, 'False', @ConfirmCode, GETDATE())

				SET @ContactId = @@IDENTITY;

				IF @@ROWCOUNT = 0 
					BEGIN 
						SET @ResultCode = 500 
					END
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_TrustedUntrusted]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_TrustedUntrusted]
(
	@ContactId INT,
	@ContactLoggedId INT,
	@Trusted BIT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @ContactLoggedId INT = 1
DECLARE @Trusted BIT = 'True'
*/

IF (
	SELECT TOP 1 
		C.ContactId 
	FROM Contacts (NOLOCK) C 
	WHERE C.ContactId = @ContactLoggedId AND ISNULL(C.Auditor, 'False') <> 'False') IS NOT NULL
	BEGIN
		IF (
			SELECT TOP 1 
				C.ContactId 
			FROM Contacts (NOLOCK) C 
			WHERE C.ContactId = @ContactId) IS NOT NULL
			BEGIN
				UPDATE Contacts 
				SET Trusted = @Trusted 
				WHERE ContactId = @ContactId AND ISNULL(Confirm, 'False') <> 'False'
				
				IF @@ROWCOUNT = 0
					BEGIN 
						SET @ResultCode = 404 
					END
				  ELSE
					BEGIN 
						SET @ResultCode = 200
					END
			END
		  ELSE 
			BEGIN
				SET @ResultCode = 404
			END
	END
  ELSE 
	BEGIN
		SET @ResultCode = 401
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Unblocked]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Unblocked]
(
	@ContactId INT,
	@ContactLoggedId INT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @ContactLoggedId INT = 1
*/

IF (
	SELECT TOP 1 
		C.ContactId 
	FROM Contacts (NOLOCK) C 
	WHERE C.ContactId = @ContactLoggedId AND ISNULL(C.Auditor, 'False') <> 'False') IS NOT NULL
	BEGIN
		IF (
			SELECT TOP 1 
				C.ContactId 
			FROM Contacts (NOLOCK) C 
			WHERE C.ContactId = @ContactId) IS NOT NULL
			BEGIN
				UPDATE Contacts 
				SET Blocked = 'False' 
				WHERE ContactId = @ContactId AND ISNULL(Confirm, 'False') <> 'False'
				
				IF @@ROWCOUNT = 0
					BEGIN 
						SET @ResultCode = 404 
					END
				  ELSE
					BEGIN 
						SET @ResultCode = 200
					END
			END
		  ELSE 
			BEGIN
				SET @ResultCode = 404
			END
	END
  ELSE 
	BEGIN
		SET @ResultCode = 401
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Update]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Update]
(
	@UserName VARCHAR(100),
	@LastName VARCHAR(100),
	@FirstName VARCHAR(100),
	@ContactId INT,
	@Notifications BIT,
	@DateBrirth Date,
	@ResultCode INT OUTPUT
)

AS

/*
--para test
DECLARE @LastName VARCHAR(100)
DECLARE @UserName VARCHAR(100)
DECLARE @FirstName VARCHAR(100)
DECLARE @DateBrirth Date
DECLARE @@Notifications BIT
DECLARE @ResultCode INT
DECLARE @ContactId INT

SET @LastName = 'Da Vinci'
SET @FirstName = 'Leonardo'
SET @UserName = 'Pintureria la Mona'
SET @DateBrirth = GETDATE()
SET @ContactId = 1010
*/


SET @ResultCode = 200

IF (@UserName IS NULL OR @UserName = '')
	BEGIN
		SET @ResultCode = 5001
	END


IF (@FirstName IS NULL OR @FirstName = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5004
	END

IF (@LastName IS NULL OR @LastName = '') AND @ResultCode = 200
	BEGIN
		SET @ResultCode = 5005
	END



IF @ResultCode = 200
	BEGIN
		UPDATE Contacts
		SET
			FirstName = @FirstName, 
			LastName = @LastName, 
			UserName = @UserName, 
			DateBrirth =  @DateBrirth,
			Notifications = @Notifications,
			DateModify = GETDATE()
		WHERE ContactId = @ContactId

		IF @@ROWCOUNT = 0 
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE 
			BEGIN
				INSERT INTO ActionLog 
					(
						ObjectKey, 
						ObjectId,
						ContactId,
						ActionTypeId,
						DateEntered
					) 
					VALUES 
					(
						'ContactId', 
						@ContactId,
						@ContactId,
						9,
						GETDATE()
					)
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_UpdateAuditor]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Contact_UpdateAuditor]
(
	@ContactId INT,
	@ContactLoggedId INT,
	@Auditor BIT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @ContactLoggedId INT = 1
DECLARE @Auditor BIT = 'True'
*/

IF (
	SELECT TOP 1 
		C.ContactId 
	FROM Contacts (NOLOCK) C 
	WHERE C.ContactId = @ContactLoggedId AND ISNULL(C.Auditor, 'False') <> 'False') IS NOT NULL
	BEGIN
		IF (
			SELECT TOP 1 
				C.ContactId 
			FROM Contacts (NOLOCK) C 
			WHERE C.ContactId = @ContactId) IS NOT NULL
			BEGIN
				UPDATE Contacts 
				SET Auditor = @Auditor 
				WHERE ContactId = @ContactId AND ISNULL(Confirm, 'False') <> 'False'
				
				IF @@ROWCOUNT = 0
					BEGIN 
						SET @ResultCode = 404 
					END
				  ELSE
					BEGIN 
						SET @ResultCode = 200
					END
			END
		  ELSE 
			BEGIN
				SET @ResultCode = 404
			END
	END
  ELSE 
	BEGIN
		SET @ResultCode = 401
	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Validate_Recover]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Contact_Validate_Recover]
(
	@ContactId INT,
	@CodeRecover VARCHAR(100),
	@ResultCode INT OUTPUT
)
AS

SET @ResultCode = 200

IF (SELECT COUNT(ContactId) 
	FROM Contacts (NOLOCK) 
	WHERE 
		CodeRecover = @CodeRecover 
		AND
		ContactID = @ContactId
		AND
		ExpiredRecover IS NOT NULL
		AND
		GETDATE() <= ExpiredRecover) > 0
	BEGIN
		SET @ResultCode = 200
	END
  ELSE 
	BEGIN
		SET @ResultCode = 5912
	END

GO
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Canllation]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactXEvent_Canllation]
(
	@ContactId INT,
	@EventId INT,
	@ResultCode INT OUTPUT
)
AS

/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 2
DECLARE @ResultCode INT
*/

SET @ResultCode = 200
	
IF @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200 AND @EventId IS NULL
	BEGIN
		SET @ResultCode = 5006
	END

-- Verificar si la cancelación se realiza con al menos 48 horas de antelación
IF @ResultCode = 200 AND (DATEDIFF(HOUR, GETDATE(), (SELECT TOP 1 StartDate FROM [Events] (NOLOCK) WHERE EventId = @EventId)) < 48)
	BEGIN
		SET @ResultCode = 5916
	END

IF @ResultCode = 200
	BEGIN
		IF (
		SELECT ContactEventId 
		FROM ContactXEvent (NOLOCK)
		WHERE ContactId = @ContactId AND EventId = @EventId AND DateCancellation IS NULL) IS NOT NULL
		BEGIN
			UPDATE ContactXEvent 
			SET DateCancellation = GETDATE() 
			WHERE 
				ContactId = @ContactId 
				AND EventId = @EventId
				AND DateCancellation IS NULL
		END
	  ELSE 
		BEGIN
			SET @ResultCode = 404
		END

	END
GO
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetAll]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactXEvent_GetAll]
(
	@ContactId INT,
	@ResultCode INT OUTPUT
)
AS



/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
*/

SET @ResultCode = 200
	
IF @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200
	BEGIN
		SELECT ContactEventId, ContactId, EventId, DateEntered  
		FROM ContactXEvent (NOLOCK) 
		WHERE ContactId = @ContactId AND DateCancellation IS NULL
	END
GO
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetById]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ContactXEvent_GetById]
(
	@ContactId INT,
	@EventId INT,
	@ResultCode INT OUTPUT
)
AS

/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 2
DECLARE @ResultCode INT
*/

SET @ResultCode = 200
	
IF @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200 AND @EventId IS NULL
	BEGIN
		SET @ResultCode = 5006
	END

IF @ResultCode = 200
	BEGIN
		SELECT ContactEventId, ContactId, EventId, DateEntered 
		FROM ContactXEvent (NOLOCK) CE
		WHERE ContactId = @ContactId AND EventId = @EventId AND DateCancellation IS NULL
	
		IF @@ROWCOUNT = 0
			BEGIN
				SET @ResultCode = 404
			END

	END
GO
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Insert]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ContactXEvent_Insert]
(
	@ContactId INT,
	@EventId INT,
	@ResultCode INT OUTPUT
)
AS

/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 8
DECLARE @ResultCode INT
*/

SET @ResultCode = 200
	
IF @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200 AND @EventId IS NULL
	BEGIN
		SET @ResultCode = 5006
	END


-- Verificar si la cancelación se realiza con al menos 48 horas de antelación
IF @ResultCode = 200 AND (DATEDIFF(HOUR, GETDATE(), (SELECT TOP 1 StartDate FROM [Events] (NOLOCK) WHERE EventId = @EventId)) < 48)
	BEGIN
		SET @ResultCode = 5916
	END

-- Verificar si El evento esta activo
IF @ResultCode = 200 AND (SELECT TOP 1 EventId FROM [Events] (NOLOCK) WHERE EventId = @EventId AND StateId <> 2 ) IS NOT NULL
	BEGIN
		SET @ResultCode = 5918
	END

IF @ResultCode = 200
	BEGIN
		IF (
			SELECT ContactEventId 
			FROM ContactXEvent (NOLOCK)
			WHERE ContactId = @ContactId AND EventId = @EventId AND DateCancellation IS NULL ) IS NULL
			BEGIN
				INSERT INTO ContactXEvent (ContactId, EventId, DateEntered) 
				VALUES (@ContactId, @EventId, GETDATE())
			END
		  ELSE 
			BEGIN 
				SET @ResultCode = 5917
			END
	END

GO
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Delete]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactXTypeImplairment_Delete]
(
	@ContactId INT,
	@ContactTypeImplairmentId INT,
	@ResultCode INT OUTPUT
)
AS


/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @ContactTypeImplairmentId AS INT = 1
*/

SET @ResultCode = 200

IF @ContactTypeImplairmentId IS NULL
	BEGIN
		SET @ResultCode = 5913
	END
	
IF @ResultCode = 200 AND @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200
	BEGIN

		IF (SELECT TOP 1 ContactTypeImplairmentId 
			FROM ContactXTypeImplairment (NOLOCK)
			WHERE ContactTypeImplairmentId = @ContactTypeImplairmentId AND DateDelete IS NULL) IS NOT NULL
			BEGIN
				UPDATE ContactXTypeImplairment 
				SET DateDelete = GETDATE()
				WHERE ContactTypeImplairmentId = @ContactTypeImplairmentId AND DateDelete IS NULL
			END
		  ELSE
			BEGIN
				SET @ResultCode = 404
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_GetAll]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactXTypeImplairment_GetAll]
(
	@ContactId INT,
	@ResultCode INT OUTPUT
)
AS


/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
*/

SET @ResultCode = 200
	
IF @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200
	BEGIN
		SELECT ContactTypeImplairmentId, ContactId, TypeId, DateEntered
		FROM ContactXTypeImplairment (NOLOCK) 
		WHERE ContactId = @ContactId AND DateDelete IS NULL
	END
GO
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Insert]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactXTypeImplairment_Insert]
(
	@ContactId INT,
	@Types AS VARCHAR(MAX),
	@ResultCode INT OUTPUT
)
AS


/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @Types AS VARCHAR(MAX) = '1,2,3,4'
*/

SET @ResultCode = 200

IF @Types IS NULL OR @Types = ''
	BEGIN
		SET @ResultCode = 5913
	END
	
IF @ResultCode = 200 AND @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200
	BEGIN

		-- Insertar datos en la tabla ContactXTypeImplairment
		INSERT INTO ContactXTypeImplairment (ContactId, DateEntered, TypeId)
		SELECT @ContactId, GETDATE(), [value]
		FROM STRING_SPLIT(@Types , ',')
	END
GO
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Update]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ContactXTypeImplairment_Update]
(
	@ContactId INT,
	@Types AS VARCHAR(MAX),
	@ResultCode INT OUTPUT
)
AS


/*
-- para test
DECLARE @ContactId INT = 1
DECLARE @ResultCode INT
DECLARE @Types AS VARCHAR(MAX) = ''
*/

SET @ResultCode = 200

	
IF @ResultCode = 200 AND @ContactId IS NULL
	BEGIN
		SET @ResultCode = 5015
	END

IF @ResultCode = 200
	BEGIN

		IF (SELECT TOP 1 ContactTypeImplairmentId FROM ContactXTypeImplairment (NOLOCK) WHERE ContactId = @ContactId AND DateDelete IS NULL) IS NOT NULL
			BEGIN
				UPDATE ContactXTypeImplairment 
				SET DateDelete = GETDATE()
				WHERE ContactId = @ContactId AND DateDelete IS NULL
			END

		-- Insertar datos en la tabla ContactXTypeImplairment
		IF @Types IS NULL OR @Types <> ''
			BEGIN
				INSERT INTO ContactXTypeImplairment (ContactId, DateEntered, TypeId)
				SELECT @ContactId, GETDATE(), [value]
				FROM STRING_SPLIT(@Types , ',')
			END
		
	END
GO
/****** Object:  StoredProcedure [dbo].[DenyObject_GetByKeyAndId]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DenyObject_GetByKeyAndId]
(
	@ObjectKey VARCHAR(255),
	@ObjectId INT
)
AS

/*
-- Para testing
DECLARE @ObjectKey VARCHAR(255) = 'EventId'
DECLARE @ObjectId INT = 5
*/

SELECT Reason FROM DenyObject WHERE ObjectKey = @ObjectKey AND ObjectId = @ObjectId
GO
/****** Object:  StoredProcedure [dbo].[Events_Authorize]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_Authorize]
(
	@ContactId INT,
	@EventId INT,
	@ResultCode INT OUTPUT
)
AS

/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		UPDATE [Events] 
		SET 
		StateId = 2,
		ContactAudit = @ContactId
		WHERE EventId = @EventId
		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE 
			BEGIN
				SET @ResultCode = 200 
			END
	END
  ELSE
	BEGIN
		SET @ResultCode = 5910
	END
GO
/****** Object:  StoredProcedure [dbo].[Events_Delete]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Events_Delete]
(
    @EventId INT,
    @ContactId INT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @ContactId INT
DECLARE @EventId INT
DECLARE @ResultCode AS INT

SET @EventId = 1020
SET @ContactId = 1
*/

IF (SELECT TOP 1 EventId FROM [Events] (NOLOCK) WHERE EventId = @EventId AND ContacCreate = @ContactId) IS NOT NULL
	BEGIN
		UPDATE [Events] SET DateDeleted = GETDATE() WHERE EventId = @EventId AND ContacCreate = @ContactId

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'EventId', 
					@EventId,
					@ContactId,
					4,
					GETDATE()
				)
				SET @ResultCode = 200 
			END
	END
  ELSE 
	BEGIN
		SET @ResultCode = 404
	END
GO
/****** Object:  StoredProcedure [dbo].[Events_Deny]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_Deny]
(
	@ContactId INT,
	@EventId INT,
	@Reason VARCHAR(255),
	@ResultCode INT OUTPUT
)
AS

/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		UPDATE [Events] 
		SET 
		StateId = 3,
		ContactAudit = @ContactId
		WHERE EventId = @EventId
		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE 
			BEGIN
				IF EXISTS (SELECT ObjectId FROM DenyObject WHERE ObjectKey = 'EventId' AND ObjectId = @EventId)
					BEGIN
						UPDATE DenyObject SET Reason = @Reason WHERE ObjectKey = 'EventId' AND ObjectId = @EventId
					END
				  ELSE 
					BEGIN
						INSERT INTO DenyObject (ObjectKey, ObjectId, Reason) 
						VALUES ('EventId', @EventId, @Reason)
					END

					INSERT INTO ActionLog 
					(
						ObjectKey, 
						ObjectId,
						ContactId,
						ActionTypeId,
						DateEntered
					) 
					VALUES 
					(
						'EventId', 
						@EventId,
						@ContactId,
						16,
						GETDATE()
					)

				SET @ResultCode = 200 
			END
	END

  ELSE
	BEGIN
		SET @ResultCode = 5910
	END
GO
/****** Object:  StoredProcedure [dbo].[Events_GetAll]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_GetAll]
(
	@ContactId INT,
	@audit INT = NULL
)
AS

 
 /*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @audit INT = 0
*/

DECLARE @IsAuditor BIT = 'False'

IF (@audit IS NOT NULL AND @audit = 1) 
	BEGIN
		SELECT 
			@IsAuditor = ISNULL(Auditor, 'False')
		FROM Contacts 
		WHERE ContactId = @ContactId 
	END

SELECT 
	E.EventId,
	E.EndDate,
	E.StartDate,
	E.[Description],
	E.Title,
	E.DateEntered,
	E.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	E.ContactAudit,
	CASE WHEN E.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	E.StateId,
	E.ImageUrl,
	s.[Description] 'DescriptionState',
	(SELECT COUNT(*) FROM ContactXEvent WHERE EventId = E.EventId AND DateCancellation IS NULL) AS 'AttendeesCount'
FROM [Events] (NOLOCK) E
	INNER JOIN Contacts (NOLOCK) CC
	ON CC.ContactId = E.ContacCreate
	INNER JOIN States (NOLOCK) S
	ON S.StateId = E.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
	ON CA.ContactId = E.ContactAudit
WHERE
		(
			@ContactId = E.ContacCreate
			OR
			@IsAuditor = 'True'
		)
		AND E.DateDeleted IS NULL
		
GO
/****** Object:  StoredProcedure [dbo].[Events_GetAllAssist]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_GetAllAssist]
(
	@ContactId INT,
	@EventId INT
)
AS


/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 6
*/


SELECT TOP 1 E.EventId, E.Title, E.StartDate, E.EndDate 
FROM [Events] (NOLOCK) E
WHERE
	E.EventId = @EventId
	AND E.ContacCreate = @ContactId
	AND E.StateId = 2


SELECT C.LastName + ', ' + C.FirstName AS 'Name'
FROM ContactXEvent (NOLOCK) CE
	LEFT JOIN [Events] (NOLOCK) E
		ON E.EventId = CE.EventId
	INNER JOIN Contacts (NOLOCK) C
		ON C.ContactId = CE.ContactId
WHERE
	E.EventId = @EventId
	AND E.ContacCreate = @ContactId
	AND E.StateId = 2
	AND CE.DateCancellation IS NULL
	AND E.DateDeleted IS NULL
GO
/****** Object:  StoredProcedure [dbo].[Events_GetByDate]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_GetByDate]
(
	@ContactId INT = NULL,
	@Date Datetime
)
AS


/*
-- para trest
DECLARE @Date Datetime = '2024-1-2'
DECLARE @ContactId INT = 3
*/


DECLARE @EventAssist TABLE 
(
	[EventId] INT,
	Assist BIT
)

INSERT INTO @EventAssist
SELECT EventId, 'True'
FROM ContactXEvent (NOLOCK) CE
WHERE @ContactId IS NOT NULL AND ContactId = @ContactId AND DateCancellation IS NULL


SELECT 
	E.EventId,
	E.EndDate,
	E.StartDate,
	E.[Description],
	E.Title,
	E.DateEntered,
	E.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	E.ContactAudit,
	CASE WHEN E.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	E.StateId,
	E.ImageUrl,
	s.[Description] 'DescriptionState',
	ISNULL(EA.Assist, 'False') Assist
FROM [Events] E (NOLOCK)
	INNER JOIN Contacts (NOLOCK) CC
		ON CC.ContactId = E.ContacCreate
	INNER JOIN States (NOLOCK) S
		ON S.StateId = E.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
		ON CA.ContactId = E.ContactAudit
	LEFT JOIN  @EventAssist  EA
		ON EA.EventId = E.EventId
WHERE 
		MONTH(e.StartDate) = MONTH(@Date)
	 AND
		YEAR(e.StartDate) = YEAR(@Date)
	 AND
		e.StateId = 2
	AND E.DateDeleted IS NULL
GO
/****** Object:  StoredProcedure [dbo].[Events_GetById]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Events_GetById]
(
	@ContactId INT,
	@EventId INT
)
AS


/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @EventId INT = 2
*/

DECLARE @IsAuditor BIT
DECLARE @AttendeesCount INT = 0


SELECT @AttendeesCount = COUNT(*) 
FROM ContactXEvent 
WHERE EventId = @EventId AND  DateCancellation IS NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

SELECT 
	E.EventId,
	E.EndDate,
	E.StartDate,
	E.[Description],
	E.Title,
	E.DateEntered,
	E.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	E.ContactAudit,
	CASE WHEN E.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	E.StateId,
	E.ImageUrl,
	s.[Description] AS 'DescriptionState',
	@AttendeesCount AS 'AttendeesCount'
FROM [Events] E (NOLOCK)
	INNER JOIN Contacts (NOLOCK) CC
		ON CC.ContactId = E.ContacCreate
	INNER JOIN States (NOLOCK) S
		ON S.StateId = E.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
		ON CA.ContactId = E.ContactAudit
WHERE 
	EventId = @EventId
	AND 
		(
			@ContactId = E.ContacCreate
			OR
			@IsAuditor = 'True'
		)
	AND E.DateDeleted IS NULL
GO
/****** Object:  StoredProcedure [dbo].[Events_GetByIdMoreInfo]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_GetByIdMoreInfo]
(
	@ContactId INT = NULL,
	@EventId INT
)
AS


/*
-- para trest
DECLARE @EventId INT = 6
DECLARE @ContactId INT = 1
*/

DECLARE @AttendeesCount INT = 0

SELECT @AttendeesCount = COUNT(EventId) 
FROM ContactXEvent 
WHERE EventId = @EventId AND  DateCancellation IS NULL



SELECT 
	E.EventId,
	E.EndDate,
	E.StartDate,
	E.[Description],
	E.Title,
	E.DateEntered,
	E.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	E.ContactAudit,
	CASE WHEN E.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	E.StateId,
	E.ImageUrl,
	s.[Description] 'DescriptionState',
	CAST( 
	 CASE
        WHEN EXISTS (
			SELECT 1 
			FROM ContactXEvent (NOLOCK) CE 
			WHERE @ContactId IS NOT NULL AND CE.ContactId = @ContactId AND CE.EventId = @EventId AND CE.DateCancellation IS NULL
			) 
		THEN 'True'
        ELSE 'False'
    END 
	AS BIT)
	AS 'Assist',
	@AttendeesCount AS 'AttendeesCount'
FROM [Events] E (NOLOCK)
	INNER JOIN Contacts (NOLOCK) CC
		ON CC.ContactId = E.ContacCreate
	INNER JOIN States (NOLOCK) S
		ON S.StateId = E.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
		ON CA.ContactId = E.ContactAudit
WHERE 
	EventId = @EventId
	AND E.StateId = 2
	AND E.DateDeleted IS NULL

	
IF EXISTS (SELECT E.EventId FROM [Events] E (NOLOCK) WHERE EventId = @EventId AND E.StateId = 2)
	BEGIN
		INSERT INTO ActionLog 
		(
			ObjectKey, 
			ObjectId,
			ActionTypeId,
			ContactId,
			DateEntered
		) 
		VALUES 
		(
			'EventId', 
			@EventId,
			11,
			@ContactId,
			GETDATE()
		)
	END
GO
/****** Object:  StoredProcedure [dbo].[Events_Insert]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_Insert]
(
    @StartDate Datetime,
    @EndDate Datetime,
    @Title VARCHAR(1000),
    @Description VARCHAR(MAX),
    @ContactCreateId INT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @StartDate AS Date
DECLARE @EndDate AS Date
DECLARE @Title AS VARCHAR(255)
DECLARE @Description AS VARCHAR(255)
DECLARE @ContactCreateId AS INT
DECLARE @ResultCode AS INT

SET @StartDate = GETDATE()
SET @EndDate = GETDATE()
SET @Title = 'este es una prueba'
SET @Description = 'este es una prueba'
SET @ContactCreateId = 1
*/



DECLARE @EventId AS INT


SET @ResultCode = 200

IF (@Title IS NULL OR @Title = '')
	BEGIN
		SET @ResultCode = 5008
	END

IF (@StartDate IS NULL OR @StartDate = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5007
	END

IF @ResultCode = 200
	BEGIN
		INSERT INTO [Events] (
			Title, 
			[Description], 
			StartDate, 
			EndDate, 
			ContacCreate, 
			StateId, 
			dateEntered
		) 
		VALUES (
			@Title, 
			@Description, 
			@StartDate, 
			ISNULL(@EndDate, @StartDate),
			@ContactCreateId,
			1, 
			GETDATE()
		)

		IF @@ROWCOUNT = 0  AND @@Identity <> 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				SET @EventId = @@Identity

				-- si es de confianza entonces se aprueba automaticamente
				IF (SELECT Trusted FROM Contacts WHERE ContactId = @ContactCreateId) = 'True' 
					BEGIN
						UPDATE [Events] 
						SET 
						StateId = 2,
						ContactAudit = @ContactCreateId
						WHERE EventId = @EventId
					END
				
				-- si obtienen los datos a devolver
				SELECT 
					E.EventId,
					E.EndDate,
					E.StartDate,
					E.[Description],
					E.Title,
					E.DateEntered,
					E.ContacCreate,
					CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
					E.ContactAudit,
					E.ImageUrl,
					CASE WHEN E.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
					E.StateId,
					s.[Description] 'DescriptionState'
				FROM [Events] E
				 INNER JOIN Contacts CC
				   ON CC.ContactId = E.ContacCreate
				    INNER JOIN States S
				   ON S.StateId = E.StateId
				 LEFT JOIN Contacts CA 
					ON CA.ContactId = E.ContactAudit
				WHERE EventId = @EventId

				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'EventId', 
					@EventId,
					@ContactCreateId,
					2,
					GETDATE()
				)
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Events_Update]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Events_Update]
(
	@EventId INT,
    @StartDate Datetime,
    @EndDate Datetime,
    @Title VARCHAR(1000),
    @Description VARCHAR(MAX),
    @ContactId INT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @EventId INT
DECLARE @StartDate AS Datetime
DECLARE @EndDate AS Datetime
DECLARE @Title AS VARCHAR(255)
DECLARE @Description AS VARCHAR(255)
DECLARE @ContactId AS INT
DECLARE @ResultCode AS INT

SET @EventId = 10
SET @StartDate = GETDATE()
SET @Title = 'este es una prueba'
SET @Description = 'este es una prueba'
SET @ContactId = 1
*/

SET @ResultCode = 200

IF @EventId IS NULL 
	BEGIN
		SET @ResultCode = 5006
	END

IF (@Title IS NULL OR @Title = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5008
	END

IF (@StartDate IS NULL OR @StartDate = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5007
	END

IF (SELECT TOP 1 EventId FROM [Events] (NOLOCK) WHERE EventId = @EventId AND ContacCreate = @ContactId) IS NULL
	BEGIN
		SET @ResultCode = 404 
	END


IF @ResultCode = 200
	BEGIN
		IF ISNULL(@EndDate, @StartDate) >= CAST(GETDATE() AS datetime)
			BEGIN
				UPDATE [Events] 
				SET
					Title = @Title, 
					[Description] = @Description, 
					StartDate = @StartDate, 
					EndDate = ISNULL(@EndDate, @StartDate),
					StateId = 1,
					ContactAudit = NULL,
					DateModify = GETDATE()
				WHERE EventId = @EventId AND ContacCreate = @ContactId
			END
		  ELSE
			BEGIN
				UPDATE [Events] 
				SET
						Title = @Title, 
						[Description] = @Description, 
						StartDate = @StartDate, 
						EndDate = ISNULL(@EndDate, @StartDate),
						DateModify = GETDATE()
				WHERE EventId = @EventId AND ContacCreate = @ContactId
			END

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN

				-- si es de confianza entonces se aprueba automaticamente
				IF (SELECT Trusted FROM Contacts WHERE ContactId = @ContactId) = 'True' 
					BEGIN
						UPDATE [Events] 
						SET 
						StateId = 2,
						ContactAudit = @ContactId
						WHERE EventId = @EventId
					END

				SELECT 
					E.EventId,
					E.EndDate,
					E.StartDate,
					E.[Description],
					E.Title,
					E.DateEntered,
					E.ContacCreate,
					CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
					E.ContactAudit,
					E.ImageUrl,
					CASE WHEN E.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
					E.StateId,
					s.[Description] 'DescriptionState'
				FROM [Events] E
				 INNER JOIN Contacts CC
				   ON CC.ContactId = E.ContacCreate
				    INNER JOIN States S
				   ON S.StateId = E.StateId
				 LEFT JOIN Contacts CA 
					ON CA.ContactId = E.ContactAudit
				WHERE EventId = @EventId

				DECLARE @ContactCreateId INT
				
				SELECT 
				 @ContactCreateId = ContacCreate
				FROM [Events] (NOLOCK) E
				WHERE EventId = @EventId

				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'EventId', 
					@@Identity,
					@ContactCreateId,
					3,
					GETDATE()
				)
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Notify_NewEventsAndPosts]    Script Date: 23/2/2024 19:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Notify_NewEventsAndPosts]
(
	@ResultCode INT OUTPUT
)

AS

/*
--para test
DECLARE @ResultCode INT
*/

-- Declaro variables necesarias
DECLARE @LimitDate DATETIME
DECLARE @Now DATETIME = GETDATE()
DECLARE @HasContacts BIT = 'False'
DECLARE @HasEvents BIT = 'False'
DECLARE @HasPosts BIT = 'False'

CREATE TABLE #ContactNotification (
	ContactId INT, 
	FirstName VARCHAR(100), 
	Email VARCHAR(100)
)


-- Busco la fecha de la ultima Ejecucion
SELECT @LimitDate = LastExecution FROM MailExecutions WHERE [Send] = 'SendNotificy'

-- Busco los contactos que desean ser notificados
INSERT INTO #ContactNotification
SELECT ContactId, FirstName, Email 
FROM Contacts (NOLOCK)
WHERE ISNULL(Confirm, 'False') <> 'False' AND ISNULL(Notifications, 'true') <> 'False'

IF (SELECT TOP 1 ContactId FROM #ContactNotification) IS NOT NULL 
	BEGIN
		SELECT * FROM #ContactNotification
		SET @HasContacts = 'True'
	END

IF @HasContacts = 'True'
	BEGIN
		-- Busco los nuevos eventos a notificar de la ultima vez y que no se incluyeron en la ultima notificacion y que esten aprobados.
		SELECT CN.ContactId, CE.EventId, E.Title, E.StartDate, E.EndDate
		FROM ContactXEvent (NOLOCK) CE
			LEFT JOIN [Events] (NOLOCK) E 
			ON E.EventId = CE.EventId
			INNER JOIN #ContactNotification CN
			ON CE.ContactId = CN.ContactId
		WHERE 
			CE.DateCancellation IS NULL
			AND E.StateId = 2
			AND E.DateDeleted IS NULL
			AND (
					@LimitDate IS NULL
					OR 
					(
						@LimitDate IS NOT NULL
						AND
						(E.DateModify IS NOT NULL AND E.DateModify > @LimitDate AND E.DateModify <= @Now)
						OR 
						(E.DateModify IS NULL AND E.DateEntered > @LimitDate AND E.DateEntered <= @Now)
						OR 
						(E.DateModify IS NULL AND E.DateEntered <= @LimitDate AND E.DateEntered <= @Now AND E.DateEntered = E.DateModify)
					)
				)
		GROUP BY CN.ContactId, CE.EventId, E.Title, E.StartDate, E.EndDate
		ORDER BY CN.ContactId

		IF @@ROWCOUNT > 0
			BEGIN
				SET @hasEvents = 'True'
			END


		SELECT CN.ContactId,  P.PostId, P.Title
		FROM Posts (NOLOCK) P
			LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
			ON P.PostId = PTI.PostId
			INNER JOIN ContactXTypeImplairment (NOLOCK) CTI
			ON PTI.TypeId = CTI.TypeId
			INNER JOIN #ContactNotification CN
			ON CTI.ContactId = CN.ContactId
		WHERE 
			P.StateId = 2
			AND P.DateDeleted IS NULL
			AND (
					@LimitDate IS NULL
						OR 
						(
							P.DateModify BETWEEN ISNULL(@LimitDate, P.DateModify) AND @Now
							OR 
							P.DateEntered BETWEEN ISNULL(@LimitDate, P.DateEntered) AND @Now
						)
				)
		GROUP BY CN.ContactId, P.PostId, P.Title
		ORDER BY CN.ContactId

		IF @@ROWCOUNT > 0
			BEGIN
				SET @HasPosts = 'True'
			END
	END

-- Se actualiza la fecha de Guardado.
IF @LimitDate IS NULL
	BEGIN
		INSERT INTO MailExecutions ([Send], LastExecution) VALUES ('SendNotificy', @Now)
	END
  ELSE 
	BEGIN
		UPDATE MailExecutions SET LastExecution = @Now WHERE [Send] = 'SendNotificy'
	END

-- Se limpia la tabla temporal
DROP TABLE #ContactNotification

IF @HasContacts = 'True' AND (@HasEvents = 'True' OR @HasPosts = 'True')
	BEGIN
		SET @ResultCode = 200
	END
  ELSE
	BEGIN
		SET @ResultCode = 404
	END

GO
/****** Object:  StoredProcedure [dbo].[Object_UpdateImage]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Object_UpdateImage]
(
	@objectId INT,
    @objectKey VARCHAR(100),
	@urlImage VARCHAR(255),
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @objectId INT
DECLARE @objectKey AS VARCHAR(100)
DECLARE @urlImage AS VARCHAR(255)
DECLARE @ResultCode AS INT

SET @objectId = 1
SET @objectKey = 'ContactId'
SET @urlImage = ''
*/

SET @ResultCode = 0

IF @objectId IS NULL 
	BEGIN
		SET @ResultCode = 5006
	END

IF (@objectKey IS NULL OR @objectKey = '') AND  @ResultCode = 0
	BEGIN
		SET @ResultCode = 5915
	END

IF (@urlImage IS NULL OR @urlImage = '') AND  @ResultCode = 0
	BEGIN
		SET @ResultCode = 5011
	END

	-- Event
IF (@objectKey LIKE 'EventId') AND  @ResultCode = 0
	BEGIN

		UPDATE [Events] 
		SET ImageUrl = @urlImage
		WHERE EventId = @objectId

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE
			BEGIN
				SET @ResultCode = 200
			END
	END

	--Posts
IF (@objectKey LIKE 'PostId') AND  @ResultCode = 0
	BEGIN

		UPDATE [Posts] 
		SET ImageUrl = @urlImage
		WHERE PostId = @objectId

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				SET @ResultCode = 200
			END
	END

	--Profile
IF (@objectKey LIKE 'ContactId') AND  @ResultCode = 0
	BEGIN

		UPDATE [Contacts] 
		SET ImageUrl = @urlImage
		WHERE ContactId = @objectId
		
		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE
			BEGIN
				SET @ResultCode = 200
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Posts_Authorize]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Posts_Authorize]
(
	@ContactId INT,
	@PostId INT,
	@ResultCode INT OUTPUT
)
AS

/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @PostId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		UPDATE [Posts] 
		SET 
		StateId = 2,
		ContactAudit = @ContactId
		WHERE PostId = @PostId
		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE 
			BEGIN
				SET @ResultCode = 200 
			END
	END
  ELSE
	BEGIN
		SET @ResultCode = 5910
	END
GO
/****** Object:  StoredProcedure [dbo].[Posts_Delete]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Posts_Delete]
(
    @PostId INT,
    @ContactId INT,
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @ContactId INT
DECLARE @EventId INT
DECLARE @ResultCode AS INT

SET @PostId = 4
SET @ContactId = 2
*/

IF (SELECT TOP 1 PostId FROM [Posts] (NOLOCK) WHERE PostId = @PostId AND ContacCreate = @ContactId) IS NOT NULL
	BEGIN
		UPDATE [Posts] SET DateDeleted = GETDATE() WHERE PostId = @PostId AND ContacCreate = @ContactId

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				
				INSERT INTO ActionLog 
					(
						ObjectKey, 
						ObjectId,
						ContactId,
						ActionTypeId,
						DateEntered
					) 
					VALUES 
					(
						'PostId', 
						@PostId,
						@ContactId,
						7,
						GETDATE()
					)
				SET @ResultCode = 200 
			END
	END
  ELSE 
	BEGIN
		SET @ResultCode = 404
	END
GO
/****** Object:  StoredProcedure [dbo].[Posts_Deny]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Posts_Deny]
(
	@ContactId INT,
	@PostId INT,
	@Reason VARCHAR(255),
	@ResultCode INT OUTPUT
)
AS

/*
-- para trest
DECLARE @ContactId INT = 1
DECLARE @PostId INT = 1
DECLARE @ResultCode INT
*/

DECLARE @IsAuditor BIT
SET @ResultCode = NULL

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

IF @IsAuditor = 'True'
	BEGIN
		UPDATE [Posts] 
		SET 
		StateId = 3,
		ContactAudit = @ContactId
		WHERE PostId = @PostId
		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 404 
			END
		  ELSE 
			BEGIN
				IF EXISTS (SELECT ObjectId FROM DenyObject WHERE ObjectKey = 'PostId' AND ObjectId = @PostId)
					BEGIN
						UPDATE DenyObject SET Reason = @Reason WHERE ObjectKey = 'PostId' AND ObjectId = @PostId
					END
			 	  ELSE 
					BEGIN
						INSERT INTO DenyObject (ObjectKey, ObjectId, Reason) 
						VALUES ('PostId', @PostId, @Reason)
					END

					INSERT INTO ActionLog 
					(
						ObjectKey, 
						ObjectId,
						ContactId,
						ActionTypeId,
						DateEntered
					) 
					VALUES 
					(
						'PostId', 
						@PostId,
						@ContactId,
						17,
						GETDATE()
					)
				SET @ResultCode = 200 
			END
	END

	

  ELSE
	BEGIN
		SET @ResultCode = 5910
	END
GO
/****** Object:  StoredProcedure [dbo].[Posts_GetAll]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Posts_GetAll]
(
	@ContactId INT,
	@audit INT = NULL
)
AS

/*
-- para trest
DECLARE @ContactId INT = 1012
DECLARE @audit INT = 0
*/

DECLARE @IsAuditor BIT

IF (@audit IS NOT NULL AND @audit = 1) 
	BEGIN
		SELECT 
			@IsAuditor = ISNULL(Auditor, 'False')
		FROM Contacts 
		WHERE ContactId = @ContactId 
	END

SELECT 
	P.PostId,
	P.[Description],
	P.Text,
	P.Title,
	P.DateEntered,
	P.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	P.ContactAudit,
	CASE WHEN P.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	P.StateId,
	P.ImageUrl,
	s.[Description] 'DescriptionState',
	PTI.TypeId,
	TI.Description 'DescriptionTypeImpairment'
FROM [Posts] (NOLOCK) P
	INNER JOIN Contacts (NOLOCK) CC
		ON CC.ContactId = P.ContacCreate
	INNER JOIN States (NOLOCK) S
		ON S.StateId = P.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
		ON CA.ContactId = P.ContactAudit
	LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
		ON PTI.PostId = P.PostId
	LEFT JOIN TypesImpairment (NOLOCK) TI
		ON PTI.TypeId = TI.TypeId
WHERE
		(
			@ContactId = P.ContacCreate
			OR
			@IsAuditor = 'True'
		)
	AND P.DateDeleted IS NULL
ORDER BY P.PostId
GO
/****** Object:  StoredProcedure [dbo].[Posts_GetById]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Posts_GetById]
(
	@ContactId INT,
	@PostId INT
)
AS


/*
-- para trest
DECLARE @ContactId INT = 4
DECLARE @PostId INT = 1
*/

DECLARE @IsAuditor BIT

SELECT 
	@IsAuditor = ISNULL(Auditor, 'False')
FROM Contacts 
WHERE ContactId = @ContactId 

SELECT 
	P.PostId,
	P.[Description],
	P.Text,
	P.Title,
	P.DateEntered,
	P.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	P.ContactAudit,
	CASE WHEN P.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	P.StateId,
	P.ImageUrl,
	s.[Description] 'DescriptionState',
	PTI.TypeId,
	TI.Description 'DescriptionTypeImpairment'
FROM [Posts] (NOLOCK) P
	INNER JOIN Contacts (NOLOCK) CC
		ON CC.ContactId = P.ContacCreate
	INNER JOIN States (NOLOCK) S
		ON S.StateId = P.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
		ON CA.ContactId = P.ContactAudit
	LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
		ON PTI.PostId = P.PostId
	LEFT JOIN TypesImpairment (NOLOCK) TI
		ON PTI.TypeId = TI.TypeId
WHERE
	P.PostId = @PostId
	AND 
		(
			@ContactId = P.ContacCreate
			OR
			@IsAuditor = 'True'
		)
	AND P.DateDeleted IS NULL
GO
/****** Object:  StoredProcedure [dbo].[Posts_GetByIdMoreInfo]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Posts_GetByIdMoreInfo]
(
	@PostId INT
)
AS


/*
-- para trest
DECLARE @ContactId INT = 4
DECLARE @PostId INT = 1
*/

SELECT 
	P.PostId,
	P.[Description],
	P.Text,
	P.Title,
	P.DateEntered,
	P.ContacCreate,
	CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
	P.ContactAudit,
	CASE WHEN P.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
	P.StateId,
	P.ImageUrl,
	s.[Description] 'DescriptionState',
	PTI.TypeId,
	TI.Description 'DescriptionTypeImpairment'
FROM [Posts] (NOLOCK) P
	INNER JOIN Contacts (NOLOCK) CC
		ON CC.ContactId = P.ContacCreate
	INNER JOIN States (NOLOCK) S
		ON S.StateId = P.StateId
	LEFT JOIN Contacts (NOLOCK) CA 
		ON CA.ContactId = P.ContactAudit
	INNER JOIN PostsXTypesImpairment (NOLOCK) PTI
		ON PTI.PostId = P.PostId
	LEFT JOIN TypesImpairment (NOLOCK) TI
		ON PTI.TypeId = TI.TypeId
WHERE
	P.PostId = @PostId
	AND P.StateId = 2
	AND P.DateDeleted IS NULL

IF EXISTS (SELECT P.PostId FROM [Posts] (NOLOCK) P WHERE P.PostId = @PostId AND P.StateId = 2) 
	INSERT INTO ActionLog 
	(
		ObjectKey, 
		ObjectId,
		ActionTypeId,
		DateEntered
	) 
	VALUES 
	(
		'PostId', 
		@PostId,
		12,
		GETDATE()
)
GO
/****** Object:  StoredProcedure [dbo].[Posts_Insert]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Posts_Insert]
(
    @Title VARCHAR(1000),
    @Description VARCHAR(MAX),
	@Text VARCHAR(MAX),
    @ContactCreateId INT,
	@Types AS VARCHAR(MAX),
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @StartDate AS Date
DECLARE @EndDate AS Date
DECLARE @Title AS VARCHAR(255)
DECLARE @Description AS VARCHAR(255)
DECLARE @Types AS VARCHAR(MAX)
DECLARE @Text AS VARCHAR(MAX)
DECLARE @ContactCreateId AS INT
DECLARE @ResultCode AS INT

SET @StartDate = GETDATE()
SET @EndDate = GETDATE()
SET @Title = 'este es una prueba'
SET @Description = 'este es una prueba'
SET @Text = 'este es una prueba'
SET @ContactCreateId = 1
SET @Types = '1,2'
*/

DECLARE @PostId INT = 0
DECLARE @StateId INT = 1

SET @ResultCode = 200

IF (@Title IS NULL OR @Title = '')
	BEGIN
		SET @ResultCode = 5008
	END

IF (@Description IS NULL OR @Description = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5013
	END

IF (@Text IS NULL OR @Text = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5014
	END

IF @ResultCode = 200
	BEGIN
		IF (SELECT Trusted FROM Contacts WHERE ContactId = @ContactCreateId) = 'True'
			BEGIN
				SET @StateId = 2 
			END

		INSERT INTO [Posts] (
			Title, 
			[Description], 
			Text,
			ContacCreate, 
			StateId, 
			dateEntered
		) 
		VALUES (
			@Title, 
			@Description, 
			@Text,
			@ContactCreateId,
			@StateId , 
			GETDATE()
		)

		SET @PostId = @@Identity

		IF @@ROWCOUNT = 0  AND @PostId <> 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				IF (@Types IS NOT NULL)
					BEGIN
						INSERT INTO PostsXTypesImpairment
						SELECT @PostId 'PostId ', value 'TypeId'
						FROM STRING_SPLIT(@Types , ',')
					END


				IF (SELECT ISNULL(Auditor, 'False')
					FROM Contacts 
					WHERE ContactId = @ContactCreateId) = 'True'
					BEGIN
						UPDATE [Posts] 
						SET 
						StateId = 2,
						ContactAudit = @ContactCreateId
						WHERE PostId = @PostId
					END

				SELECT 
					P.PostId,
					P.[Description],
					P.Text,
					P.Title,
					P.DateEntered,
					P.ContacCreate,
					CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
					P.ContactAudit,
					CASE WHEN P.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
					P.StateId,
					P.ImageUrl,
					s.[Description] 'DescriptionState',
					PTI.TypeId,
					TI.Description 'DescriptionTypeImpairment'
				FROM [Posts] (NOLOCK) P
					INNER JOIN Contacts (NOLOCK) CC
						ON CC.ContactId = P.ContacCreate
					INNER JOIN States (NOLOCK) S
						ON S.StateId = P.StateId
					LEFT JOIN Contacts (NOLOCK) CA 
						ON CA.ContactId = P.ContactAudit
					INNER JOIN PostsXTypesImpairment (NOLOCK) PTI
						ON PTI.PostId = P.PostId
					LEFT JOIN TypesImpairment (NOLOCK) TI
						ON PTI.TypeId = TI.TypeId
				WHERE P.PostId = @PostId


				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'PostId', 
					@PostId,
					@ContactCreateId,
					5,
					GETDATE()
				)

			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Posts_Update]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Posts_Update]
(
	@PostId INT,
    @Title VARCHAR(1000),
    @Description VARCHAR(MAX),
    @Text VARCHAR(MAX),
	@ContactId INT,
	@Types AS VARCHAR(MAX),
	@ResultCode INT OUTPUT
)

AS


/*
--para test
DECLARE @PostId INT
DECLARE @Title AS VARCHAR(255)
DECLARE @Description AS VARCHAR(255)
DECLARE @Text AS VARCHAR(MAX)
DECLARE @Types AS VARCHAR(MAX)
DECLARE @ContactId AS INT
DECLARE @ResultCode AS INT

SET @PostId = 1013
SET @Text = 'este es una prueba'
SET @Title = 'este es una prueba'
SET @Description = 'este es una prueba'
SET @Types = '2'
SET @ContactId = 1
*/

DECLARE @StateId INT = 1
SET @ResultCode = 200


IF @PostId IS NULL 
	BEGIN
		SET @ResultCode = 5006
	END

IF (@Title IS NULL OR @Title = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5008
	END

IF (@Description IS NULL OR @Description = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5013
	END

IF (@Text IS NULL OR @Text = '') AND  @ResultCode = 200
	BEGIN
		SET @ResultCode = 5014
	END

IF (SELECT TOP 1 PostId FROM [Posts] (NOLOCK) WHERE PostId = @PostId AND ContacCreate = @ContactId) IS NULL
	BEGIN
		SET @ResultCode = 404 
	END

IF @ResultCode = 200
	BEGIN
		IF (SELECT Trusted FROM Contacts WHERE ContactId = @ContactId) = 'True'
			BEGIN
				SET @StateId = 2 
			END

		UPDATE [Posts] 
				SET
					Title = @Title, 
					[Description] = @Description, 
					[Text] = @Text,
					StateId = @StateId,
					DateModify = GETDATE()
			WHERE PostId = @PostId AND ContacCreate = @ContactId

		IF @@ROWCOUNT = 0
			BEGIN 
				SET @ResultCode = 500 
			END
		  ELSE
			BEGIN
				DELETE FROM PostsXTypesImpairment
				WHERE PostId = @PostId 
				AND TypeId NOT IN 
						(
							SELECT value 'TypeId'
							FROM STRING_SPLIT(@Types , ',')
						)

				IF (@Types IS NOT NULL)
					BEGIN
						INSERT INTO PostsXTypesImpairment
						SELECT @PostId 'PostId ', value 'TypeId'
						FROM STRING_SPLIT(@Types , ',')
						WHERE value NOT IN 
							(
								SELECT TypeId
								FROM PostsXTypesImpairment
								WHERE PostId = @PostId
							)
					END

				IF (SELECT ISNULL(Auditor, 'False')
					FROM Contacts 
					WHERE ContactId = @ContactId) = 'True'
					BEGIN
						UPDATE [Posts] 
						SET 
						StateId = 2,
						ContactAudit = @ContactId
						WHERE PostId = @PostId
					END

				SELECT 
					P.PostId,
					P.[Description],
					P.Text,
					P.Title,
					P.DateEntered,
					P.ContacCreate,
					CC.LastName + ', ' + CC.FirstName AS 'NameCreate',
					P.ContactAudit,
					CASE WHEN P.ContactAudit IS NOT NULL THEN  CA.LastName + ', ' + CA.FirstName ELSE NULL END 'NameAudit',
					P.StateId,
					P.ImageUrl,
					s.[Description] 'DescriptionState',
					PTI.TypeId,
					TI.Description 'DescriptionTypeImpairment'
				FROM [Posts] (NOLOCK) P
					INNER JOIN Contacts (NOLOCK) CC
						ON CC.ContactId = P.ContacCreate
					INNER JOIN States (NOLOCK) S
						ON S.StateId = P.StateId
					LEFT JOIN Contacts (NOLOCK) CA 
						ON CA.ContactId = P.ContactAudit
					LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
						ON PTI.PostId = P.PostId
					LEFT JOIN TypesImpairment (NOLOCK) TI
						ON PTI.TypeId = TI.TypeId
				WHERE P.PostId = @PostId

				DECLARE @ContactCreatId INT

				SELECT @ContactCreatId = P.PostId
				FROM [Posts] (NOLOCK) P
				WHERE P.PostId = @PostId

				INSERT INTO ActionLog 
				(
					ObjectKey, 
					ObjectId,
					ContactId,
					ActionTypeId,
					DateEntered
				) 
				VALUES 
				(
					'PostId', 
					@PostId,
					@ContactId,
					6,
					GETDATE()
				)
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[Search_GetSearch]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Search_GetSearch]
(
	@SearchText AS VARCHAR(MAX),
	@Filters AS VARCHAR(MAX)
)

AS

/*
-- para trest
DECLARE	@SearchText AS VARCHAR(MAX) = 'aca evento con saltos de linea'
DECLARE	@Filters AS VARCHAR(MAX) = null
*/
DECLARE @TableFilters TABLE 
(
	[filter] INT
)

DECLARE @TableSearchText TABLE 
(
	TextFilter varchar(60)
)

DECLARE @PostsAux TABLE 
(
	PostId INT,
	DateOrder DateTime
)

DECLARE @TableSearchAux TABLE
(
	[Key]  VARCHAR(250),
	Id INT,
	StartDate DATETIME,
	NameCreate  VARCHAR(500),
	ContacCreateId INT,
	Description  VARCHAR(MAX),
	Title  VARCHAR(1000),
	ImageUrl VARCHAR(500),
	TypeId  VARCHAR(250),
	TypeDescription VARCHAR(500),
	DateOrder DateTime
)

IF (@SearchText IS NOT NULL)
	BEGIN
		INSERT INTO @TableSearchText
		SELECT value
		FROM STRING_SPLIT(@SearchText , ' ')
	END

INSERT INTO @TableSearchAux
SELECT DISTINCT TOP 10
	'EventId' AS 'Key',
	E.EventId AS 'Id',
	E.StartDate,
	C.LastName + ', ' + C.FirstName AS 'NameCreate',
	C.ContactId AS 'ContacCreateId',
	E.[Description],
	E.Title,
	E.ImageUrl,
	NULL 'TypeId',
	NULL 'TypeDescription',
	ISNULL(ISNULL(ISNULL(E.EndDate, E.StartDate),E.DateModify), E.DateEntered)
FROM [Events] (NOLOCK) E
	INNER JOIN Contacts (NOLOCK) C
		ON C.ContactId = E.ContacCreate
WHERE 
	(
		EXISTS (
				SELECT TextFilter 
				FROM @TableSearchText AUX
				WHERE 
				E.Title LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
				OR
				E.Description LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
			)
		OR (@SearchText IS NULL)
	)
	AND E.StateId = 2
	AND E.DateDeleted IS NULL
ORDER BY ISNULL(ISNULL(ISNULL(E.EndDate, E.StartDate),E.DateModify), E.DateEntered) DESC

IF (@Filters IS NOT NULL)
	BEGIN
		INSERT INTO @TableFilters
		SELECT value
		FROM STRING_SPLIT(@Filters , ',')

		IF EXISTS(SELECT * FROM @TableFilters) 
			BEGIN
				INSERT INTO @PostsAux
				SELECT DISTINCT TOP 50
					PTI.PostId,
					ISNULL(P.DateModify, P.DateEntered)
				FROM [Posts] (NOLOCK) P
					LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
						ON PTI.PostId = P.PostId 
				WHERE 
					( 
						PTI.TypeId IN (SELECT * FROM @TableFilters)
					) 
					AND P.StateId = 2
					AND P.DateDeleted IS NULL
				ORDER BY ISNULL(P.DateModify, P.DateEntered) DESC
			END
		  ELSE 
			BEGIN
				INSERT INTO @PostsAux
				SELECT DISTINCT TOP 50
					PTI.PostId,
					ISNULL(P.DateModify, P.DateEntered)
				FROM [Posts] (NOLOCK) P
					LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
						ON PTI.PostId = P.PostId 
				WHERE  P.StateId = 2
					AND P.DateDeleted IS NULL
				ORDER BY ISNULL(P.DateModify, P.DateEntered) DESC
			END
	END
  ELSE 
	BEGIN
		INSERT INTO @PostsAux
		SELECT DISTINCT TOP 50
			PTI.PostId,
			ISNULL(P.DateModify, P.DateEntered)
		FROM [Posts] (NOLOCK) P
			LEFT JOIN PostsXTypesImpairment (NOLOCK) PTI
				ON PTI.PostId = P.PostId 
		WHERE  P.StateId = 2
				AND P.DateDeleted IS NULL
		ORDER BY ISNULL(P.DateModify, P.DateEntered) DESC
	END

IF @Filters IS NOT NULL
	BEGIN
		INSERT INTO @PostsAux
		SELECT DISTINCT TOP 50
			P.PostId,
			ISNULL(P.DateModify, P.DateEntered)
		FROM [Posts] (NOLOCK) P
			INNER JOIN @PostsAux PA
				ON P.PostId = PA.PostId
		WHERE EXISTS (
					SELECT TextFilter 
					FROM @TableSearchText AUX
					WHERE 
					P.Title LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
					OR
					P.Description LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
					OR
					P.Text LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
				)
			OR (@SearchText IS NULL)
			AND P.StateId = 2
				AND P.DateDeleted IS NULL
		ORDER BY ISNULL(P.DateModify, P.DateEntered) DESC
	END
  ELSE 
	BEGIN
		INSERT INTO @PostsAux
		SELECT DISTINCT TOP 50
			P.PostId,
			ISNULL(P.DateModify, P.DateEntered)
		FROM [Posts] (NOLOCK) P
			INNER JOIN @PostsAux PA
				ON P.PostId = PA.PostId
		WHERE EXISTS (
					SELECT TextFilter 
					FROM @TableSearchText AUX
					WHERE 
					P.Title LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
					OR
					P.Description LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
					OR
					P.Text LIKE (SELECT CONCAT('%', AUX.TextFilter ,'%'))
				)
			OR (@SearchText IS NULL)
			AND P.StateId = 2
			AND P.DateDeleted IS NULL
	END
	
INSERT INTO @TableSearchAux
	SELECT
		'PostId' AS 'Key',
		P.PostId AS 'Id',
		NULL 'StartDate',
		C.LastName + ', ' + C.FirstName AS 'NameCreate',
		C.ContactId AS 'ContacCreateId',
		P.[Description],
		P.Title,
		P.ImageUrl,
		PTI.TypeId,
		TI.Description 'TypeDescription',
		ISNULL(P.DateModify, P.DateEntered)
	FROM [Posts] (NOLOCK) P
		INNER JOIN Contacts (NOLOCK) C
			ON C.ContactId = P.ContacCreate
		INNER JOIN PostsXTypesImpairment (NOLOCK) PTI
			ON PTI.PostId = P.PostId
		INNER JOIN TypesImpairment (NOLOCK) TI
			ON PTI.TypeId = TI.TypeId
		INNER JOIN @PostsAux PA
			ON PA.PostId = P.PostId

			
SELECT DISTINCT * FROM @TableSearchAux ORDER BY [Key], Id, DateOrder DESC

INSERT INTO ActionLog 
(
	filters,
	SearchText,
	ActionTypeId,
	DateEntered
) 
VALUES 
(
	@Filters,
	@SearchText,
	1,
	GETDATE()
)
GO
/****** Object:  StoredProcedure [dbo].[Tokens_Change]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Tokens_Change]
(
	@RefreshTokenIdOld AS VARCHAR(50),
	@AccessTokenIdOld AS VARCHAR(50),
	@RefreshTokenSignatureOld AS VARCHAR(100),
	@AccessTokenSignatureOld AS VARCHAR(100),
	@RefreshTokenId AS VARCHAR(50),
	@AccessTokenId AS VARCHAR(50),
	@RefreshTokenSignature AS VARCHAR(100),
	@AccessTokenSignature AS VARCHAR(100),
	@RefreshToken AS VARCHAR(2000),
	@AccessToken AS VARCHAR(2000),
	@RefreshTokenExpirationDate AS DATETIME,
	@AccessTokenExpirationDate AS DATETIME,
	@Claims AS VARCHAR(2000)
)

AS

UPDATE Tokens
SET
	RefreshTokenId = @RefreshTokenId
	,AccessTokenId = @AccessTokenId
	,RefreshTokenSignature = @RefreshTokenSignature
	,AccessTokenSignature = @AccessTokenSignature
	,RefreshToken = @RefreshToken
	,AccessToken = @AccessToken
	,RefreshTokenExpirationDate = @RefreshTokenExpirationDate
	,AccessTokenExpirationDate = @AccessTokenExpirationDate
	,Claims = @Claims
	,DateEntered = GETDATE()
WHERE RefreshTokenId = @RefreshTokenIdOld
	AND AccessTokenId = @AccessTokenIdOld
	AND RefreshTokenSignature = @RefreshTokenSignatureOld
	AND AccessTokenSignature = @AccessTokenSignatureOld
GO
/****** Object:  StoredProcedure [dbo].[Tokens_Insert]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Tokens_Insert]
(
	@RefreshTokenId AS VARCHAR(50),
	@AccessTokenId AS VARCHAR(50),
	@RefreshTokenSignature AS VARCHAR(100),
	@AccessTokenSignature AS VARCHAR(100),
	@RefreshToken AS VARCHAR(2000),
	@AccessToken AS VARCHAR(2000),
	@RefreshTokenExpirationDate AS DATETIME,
	@AccessTokenExpirationDate AS DATETIME,
	@Claims AS VARCHAR(2000),
	@KeepLoggedIn AS BIT,
	@IpAddress AS VARCHAR(50),
	@Client AS VARCHAR(1000) = NULL
)

AS

INSERT INTO Tokens
	(
		RefreshTokenId
		,AccessTokenId
		,RefreshTokenSignature
		,AccessTokenSignature
		,RefreshToken
		,AccessToken
		,RefreshTokenExpirationDate
		,AccessTokenExpirationDate
		,Claims
		,KeepLoggedIn
		,IpAddress
		,Client
		,DateEntered
	)
VALUES
	(
		@RefreshTokenId
		,@AccessTokenId
		,@RefreshTokenSignature
		,@AccessTokenSignature
		,@RefreshToken
		,@AccessToken
		,@RefreshTokenExpirationDate
		,@AccessTokenExpirationDate
		,@Claims
		,@KeepLoggedIn
		,@IpAddress
		,@Client
		,GETDATE()
	)
GO
/****** Object:  StoredProcedure [dbo].[Tokens_Regenerate]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Tokens_Regenerate]
(
	@RefreshTokenIdOld AS VARCHAR(50),
	@RefreshTokenSignatureOld AS VARCHAR(100),
	@RefreshTokenId AS VARCHAR(50),
	@AccessTokenId AS VARCHAR(50),
	@RefreshTokenSignature AS VARCHAR(100),
	@AccessTokenSignature AS VARCHAR(100),
	@RefreshToken AS VARCHAR(2000),
	@AccessToken AS VARCHAR(2000),
	@RefreshTokenExpirationDate AS DATETIME,
	@AccessTokenExpirationDate AS DATETIME,
	@IpAddress AS VARCHAR(50)
)

AS

UPDATE Tokens
SET
	RefreshTokenId = @RefreshTokenId
	,AccessTokenId = @AccessTokenId
	,RefreshTokenSignature = @RefreshTokenSignature
	,AccessTokenSignature = @AccessTokenSignature
	,RefreshToken = @RefreshToken
	,AccessToken = @AccessToken
	,RefreshTokenExpirationDate = @RefreshTokenExpirationDate
	,AccessTokenExpirationDate = @AccessTokenExpirationDate
	,IpAddress = @IpAddress
	,DateEntered = GETDATE()
WHERE  RefreshTokenId = @RefreshTokenIdOld
	AND RefreshTokenSignature = @RefreshTokenSignatureOld
GO
/****** Object:  StoredProcedure [dbo].[Tokens_Update]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Tokens_Update]
(
	@RefreshTokenIdOld AS VARCHAR(50),
	@AccessTokenIdOld AS VARCHAR(50),
	@RefreshTokenSignatureOld AS VARCHAR(100),
	@AccessTokenSignatureOld AS VARCHAR(100),
	@RefreshTokenId AS VARCHAR(50),
	@AccessTokenId AS VARCHAR(50),
	@RefreshTokenSignature AS VARCHAR(100),
	@AccessTokenSignature AS VARCHAR(100),
	@RefreshToken AS VARCHAR(2000),
	@AccessToken AS VARCHAR(2000),
	@RefreshTokenExpirationDate AS DATETIME,
	@AccessTokenExpirationDate AS DATETIME,
	@IpAddress AS VARCHAR(50)
)

AS

UPDATE Tokens
SET
	RefreshTokenId = @RefreshTokenId
	,AccessTokenId = @AccessTokenId
	,RefreshTokenSignature = @RefreshTokenSignature
	,AccessTokenSignature = @AccessTokenSignature
	,RefreshToken = @RefreshToken
	,AccessToken = @AccessToken
	,RefreshTokenExpirationDate = @RefreshTokenExpirationDate
	,AccessTokenExpirationDate = @AccessTokenExpirationDate
	,IpAddress = @IpAddress
	,DateEntered = GETDATE()
WHERE RefreshTokenId = @RefreshTokenIdOld
	AND AccessTokenId = @AccessTokenIdOld
	AND RefreshTokenSignature = @RefreshTokenSignatureOld
	AND AccessTokenSignature = @AccessTokenSignatureOld
GO
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateChange]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Tokens_ValidateChange]
(
	@AccessTokenId AS VARCHAR(50),
	@AccessTokenSignature AS VARCHAR(100)
)

AS


/*
-- Para testing
DECLARE @AccessTokenId AS VARCHAR(50),
DECLARE @AccessTokenSignature AS VARCHAR(100),
SET @AccessTokenId = ''
SET @AccessTokenSignature = ''
*/

SELECT
	RefreshTokenId
	,RefreshTokenSignature
	,Claims
	,Client
	,KeepLoggedIn
	,IpAddress
FROM Tokens (NOLOCK)
WHERE  AccessTokenId = @AccessTokenId
	AND AccessTokenSignature = @AccessTokenSignature
GO
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateUpdate]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Tokens_ValidateUpdate]
(
	@RefreshTokenId AS VARCHAR(50),
	@AccessTokenId AS VARCHAR(50),
	@RefreshTokenSignature AS VARCHAR(100),
	@AccessTokenSignature AS VARCHAR(100)
)

AS


/*
-- Para testing
DECLARE @RefreshTokenId AS VARCHAR(50),
DECLARE @AccessTokenId AS VARCHAR(50),
DECLARE @RefreshTokenSignature AS VARCHAR(100),
DECLARE @AccessTokenSignature AS VARCHAR(100)
SET @RefreshTokenId = ''
SET @AccessTokenId = ''
SET @RefreshTokenSignature = ''
SET @AccessTokenSignature = ''
*/

SELECT
	Claims
	,Client
	,KeepLoggedIn
FROM Tokens (NOLOCK)
WHERE
	RefreshTokenId = @RefreshTokenId
	AND AccessTokenId = @AccessTokenId
	AND RefreshTokenSignature = @RefreshTokenSignature
	AND AccessTokenSignature = @AccessTokenSignature
GO
/****** Object:  StoredProcedure [dbo].[TypesImpairment_GetAll]    Script Date: 23/2/2024 19:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TypesImpairment_GetAll]

AS


/*
-- para trest
*/


SELECT 
	TI.TypeId,
	TI.Description
FROM TypesImpairment (NOLOCK) TI 
GO
