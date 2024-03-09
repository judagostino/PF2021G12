USE [ParImpar]
GO
/****** Object:  User [user_api]    Script Date: 9/3/2024 18:06:21 ******/
CREATE USER [user_api] FOR LOGIN [user_api] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[SearchTypesImpairment]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[ActionLog]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[ActionType]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[Contacts]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[ContactXEvent]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[ContactXTypeImplairment]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[DenyObject]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[Events]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[MailExecutions]    Script Date: 9/3/2024 18:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MailExecutions](
	[Send] [varchar](500) NULL,
	[LastExecution] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Posts]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[PostsXTypesImpairment]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[States]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[Tokens]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  Table [dbo].[TypesImpairment]    Script Date: 9/3/2024 18:06:21 ******/
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
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (165, N'EventId', 1, NULL, NULL, CAST(N'2024-02-24T17:47:24.977' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (166, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T17:54:14.060' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (167, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T18:04:57.637' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (168, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T18:32:05.567' AS DateTime), N'educacion', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (169, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T18:32:09.380' AS DateTime), N'educacion', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (170, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T18:32:26.320' AS DateTime), N'inclusión', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (171, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T18:32:40.257' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (172, NULL, NULL, N'5', NULL, CAST(N'2024-02-24T18:33:06.480' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (173, N'EventId', 3, NULL, NULL, CAST(N'2024-02-24T18:37:01.547' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (174, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T18:39:08.900' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (175, N'EventId', 1, NULL, NULL, CAST(N'2024-02-24T19:07:45.210' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (176, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T19:07:52.530' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (177, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T19:08:20.423' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (178, N'PostId', 1, NULL, NULL, CAST(N'2024-02-24T19:08:31.537' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (179, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T19:08:57.493' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (180, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T19:11:31.947' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (181, NULL, NULL, NULL, NULL, CAST(N'2024-02-24T19:12:54.260' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (182, N'ContactId', 1, NULL, 1, CAST(N'2024-02-24T19:13:32.373' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (183, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T19:15:42.707' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (184, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T20:15:18.507' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (185, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T20:32:08.617' AS DateTime), NULL, 14)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (186, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T20:44:40.857' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (187, N'EventId', 5, NULL, 2, CAST(N'2024-02-24T20:48:51.447' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (188, N'ContactId', 1, NULL, 1, CAST(N'2024-02-24T21:00:44.167' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (189, N'ContactId', 1, NULL, 1, CAST(N'2024-02-24T21:19:13.227' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (190, N'ContactId', 2, NULL, 2, CAST(N'2024-02-24T21:39:03.640' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (199, N'ContactId', 1, NULL, 1, CAST(N'2024-02-25T13:27:57.483' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (200, N'ContactId', 1, NULL, 1, CAST(N'2024-02-25T13:33:43.250' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (201, NULL, NULL, NULL, NULL, CAST(N'2024-02-25T13:34:28.250' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (202, NULL, NULL, NULL, NULL, CAST(N'2024-02-25T13:34:35.010' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (203, N'ContactId', 1, NULL, 1, CAST(N'2024-02-26T18:20:49.303' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (204, NULL, NULL, NULL, NULL, CAST(N'2024-02-26T18:28:45.510' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (205, N'EventId', 1, NULL, 1, CAST(N'2024-02-26T18:28:59.390' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (206, N'EventId', 1, NULL, 1, CAST(N'2024-02-26T18:29:16.373' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (207, N'EventId', 2, NULL, 1, CAST(N'2024-02-26T18:29:33.597' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (208, NULL, NULL, NULL, NULL, CAST(N'2024-02-26T18:29:40.380' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (209, N'PostId', 1, NULL, NULL, CAST(N'2024-02-26T18:29:44.053' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (210, N'ContactId', 1, NULL, 1, CAST(N'2024-02-26T18:29:59.343' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (211, N'ContactId', 1, NULL, 1, CAST(N'2024-02-26T18:30:49.363' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (212, N'ContactId', 1, NULL, 1, CAST(N'2024-02-26T18:32:57.960' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (213, N'ContactId', 1, NULL, 1, CAST(N'2024-02-27T15:55:25.200' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (214, N'EventId', 1, NULL, 1, CAST(N'2024-02-27T15:55:37.490' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (215, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T15:55:44.403' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (216, N'ContactId', 2, NULL, 2, CAST(N'2024-02-27T15:57:39.063' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (217, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T16:12:21.020' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (218, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T16:12:33.280' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (219, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T16:13:38.133' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (220, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T16:13:52.837' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (221, N'EventId', 1, NULL, 2, CAST(N'2024-02-27T16:13:58.530' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (222, N'EventId', 5, NULL, 2, CAST(N'2024-02-27T16:14:06.480' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (223, N'EventId', 2, NULL, 2, CAST(N'2024-02-27T16:14:14.237' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (224, N'ContactId', 2, NULL, 2, CAST(N'2024-02-27T18:59:40.500' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (225, N'ContactId', 2, NULL, 2, CAST(N'2024-02-27T19:05:23.430' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (226, N'EventId', 1, NULL, 2, CAST(N'2024-02-27T19:05:29.227' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (227, N'EventId', 5, NULL, 2, CAST(N'2024-02-27T19:05:39.333' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (228, N'EventId', 2, NULL, 2, CAST(N'2024-02-27T19:05:51.180' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (229, N'EventId', 1, NULL, 2, CAST(N'2024-02-27T19:12:17.770' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (230, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T19:12:32.167' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (231, N'EventId', 2, NULL, 2, CAST(N'2024-02-27T19:12:52.643' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (232, N'EventId', 2, NULL, 2, CAST(N'2024-02-27T19:13:04.853' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (233, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T19:14:15.503' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (234, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T19:20:17.123' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (235, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T19:20:21.790' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (236, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T19:22:12.420' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (237, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T19:22:21.413' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (238, N'EventId', 2, NULL, 2, CAST(N'2024-02-27T19:22:27.397' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (239, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T19:24:19.333' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (240, N'EventId', NULL, NULL, 2, CAST(N'2024-02-27T19:24:34.023' AS DateTime), NULL, 3)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (241, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T19:24:43.170' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (242, N'PostId', 1, NULL, 2, CAST(N'2024-02-27T19:38:03.763' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (243, N'PostId', 2, NULL, 2, CAST(N'2024-02-27T19:39:10.640' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (244, N'PostId', 3, NULL, 2, CAST(N'2024-02-27T19:41:04.627' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (245, N'PostId', 5, NULL, 2, CAST(N'2024-02-27T19:42:26.447' AS DateTime), NULL, 6)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (246, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T19:42:31.293' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (247, N'ContactId', 6, NULL, 6, CAST(N'2024-02-27T19:50:12.710' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (248, N'ContactId', 1, NULL, 1, CAST(N'2024-02-27T19:50:26.413' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (249, N'ContactId', 2, NULL, 2, CAST(N'2024-02-27T20:07:37.420' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (250, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:07:49.680' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (251, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:12:13.007' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (252, N'ContactId', 5, NULL, 5, CAST(N'2024-02-27T20:23:49.993' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (253, N'ContactId', 5, NULL, 5, CAST(N'2024-02-27T20:24:28.187' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (254, N'ContactId', 6, NULL, 6, CAST(N'2024-02-27T20:25:12.433' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (255, N'ContactId', 6, NULL, 6, CAST(N'2024-02-27T20:25:21.100' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (256, N'ContactId', 7, NULL, 7, CAST(N'2024-02-27T20:25:36.833' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (257, N'ContactId', 7, NULL, 7, CAST(N'2024-02-27T20:26:06.230' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (258, N'ContactId', 8, NULL, 8, CAST(N'2024-02-27T20:26:19.000' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (259, N'ContactId', 8, NULL, 8, CAST(N'2024-02-27T20:26:35.993' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (260, N'ContactId', 9, NULL, 9, CAST(N'2024-02-27T20:26:49.553' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (261, N'ContactId', 9, NULL, 9, CAST(N'2024-02-27T20:27:22.593' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (262, N'ContactId', 9, NULL, 9, CAST(N'2024-02-27T20:28:12.290' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (263, N'ContactId', 10, NULL, 10, CAST(N'2024-02-27T20:29:03.787' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (264, N'ContactId', 10, NULL, 10, CAST(N'2024-02-27T20:30:06.157' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (265, N'ContactId', 6, NULL, 6, CAST(N'2024-02-27T20:33:47.523' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (266, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:33:49.950' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (267, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:33:54.713' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (268, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:34:35.980' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (269, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:35:22.910' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (270, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:35:40.673' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (271, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:36:05.233' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (272, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:36:25.937' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (273, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:36:40.470' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (274, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:38:15.467' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (275, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:38:37.423' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (276, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:39:00.537' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (277, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:39:53.237' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (278, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:40:33.807' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (279, N'EventId', 1, NULL, 6, CAST(N'2024-02-27T20:41:40.097' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (280, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:41:44.977' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (281, N'PostId', 2, NULL, NULL, CAST(N'2024-02-27T20:41:49.130' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (282, N'PostId', 2, NULL, NULL, CAST(N'2024-02-27T20:42:38.433' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (283, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:42:45.683' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (284, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:44:44.663' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (285, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:45:02.557' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (286, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:45:26.170' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (287, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:45:39.460' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (288, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:46:41.313' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (289, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:46:57.063' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (290, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:47:40.130' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (291, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:48:01.767' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (292, NULL, NULL, NULL, NULL, CAST(N'2024-02-27T20:48:30.473' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (293, N'ContactId', 1, NULL, 1, CAST(N'2024-02-27T20:49:59.510' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (294, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T14:21:25.593' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (295, NULL, NULL, NULL, NULL, CAST(N'2024-02-28T14:21:34.433' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (296, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T14:23:19.603' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (297, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T14:31:48.860' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (298, N'EventId', 5, NULL, 2, CAST(N'2024-02-28T14:39:44.537' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (299, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T14:40:08.550' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (300, NULL, NULL, NULL, NULL, CAST(N'2024-02-28T14:40:58.540' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (301, NULL, NULL, NULL, NULL, CAST(N'2024-02-28T14:42:04.703' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (302, N'PostId', 2, NULL, NULL, CAST(N'2024-02-28T14:42:21.577' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (303, NULL, NULL, NULL, NULL, CAST(N'2024-02-28T14:42:34.597' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (304, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T14:45:46.380' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (305, N'EventId', 1, NULL, 2, CAST(N'2024-02-28T14:51:52.390' AS DateTime), NULL, 4)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (306, N'ContactId', 4, NULL, 4, CAST(N'2024-02-28T14:57:05.583' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (307, N'PostId', 6, NULL, 4, CAST(N'2024-02-28T14:58:10.090' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (308, N'ContactId', 6, NULL, 6, CAST(N'2024-02-28T14:58:44.590' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (309, N'PostId', 7, NULL, 6, CAST(N'2024-02-28T14:59:01.550' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (310, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T15:06:10.427' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (311, N'EventId', 2, NULL, 2, CAST(N'2024-02-28T15:08:51.680' AS DateTime), NULL, 16)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (312, N'PostId', 1, NULL, NULL, CAST(N'2024-02-28T15:25:18.660' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (313, N'ContactId', 2, NULL, 2, CAST(N'2024-02-28T20:39:45.010' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1294, N'ContactId', 2, NULL, 2, CAST(N'2024-02-29T18:32:35.650' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1295, N'ContactId', 2, NULL, 2, CAST(N'2024-02-29T19:44:20.940' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1296, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:07:40.460' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1297, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:08:12.577' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1298, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:08:54.553' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1299, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:08:57.540' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1300, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:12:15.717' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1301, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:12:27.130' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1302, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:12:34.367' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1303, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:12:41.847' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1304, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:12:45.840' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1305, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:15:29.250' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1306, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:15:37.487' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1307, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:15:39.243' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1308, NULL, NULL, NULL, NULL, CAST(N'2024-02-29T20:15:42.940' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1309, N'ContactId', 2, NULL, 2, CAST(N'2024-03-05T19:27:01.733' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1310, NULL, NULL, NULL, NULL, CAST(N'2024-03-05T19:42:45.773' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1311, NULL, NULL, NULL, NULL, CAST(N'2024-03-05T19:42:46.990' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1312, NULL, NULL, NULL, NULL, CAST(N'2024-03-05T19:42:47.667' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1313, NULL, NULL, NULL, NULL, CAST(N'2024-03-05T19:43:04.380' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1314, NULL, NULL, NULL, NULL, CAST(N'2024-03-05T19:43:04.870' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1315, N'ContactId', 2, NULL, 2, CAST(N'2024-03-09T17:31:23.233' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1316, NULL, NULL, NULL, NULL, CAST(N'2024-03-09T17:40:14.327' AS DateTime), NULL, 1)
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
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (2, N'Julieta', N'Dagostino', CAST(N'2024-02-21T20:46:31.160' AS DateTime), N'judagostino96@gmail.com', N'0PIbyqRgqPXy680FQyzzZg==', N'jdagostino', CAST(N'1996-09-02' AS Date), 1, 1, 1, 0, N'D074E634-237E-4B58-A1A8-B89A839FC567', CAST(N'2024-02-24T20:32:08.613' AS DateTime), N'23A48771-8C1E-4083-8CAE-13C4B27322A8', N'http://comunidad-parimpar.com.ar/Profiles/ContactId_2.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-21T22:02:30.457' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (3, N'Gaston Luis', N'Vottero', CAST(N'2024-02-23T19:05:03.143' AS DateTime), N'gastonlvottero@gmail.com', N'8uJ1KuYptsyl1f23upSNXw==', N'glvottero', NULL, NULL, 1, NULL, 0, N'8B3861C2-C3CD-4AF9-B380-B6881F705ECD', NULL, NULL, NULL, CAST(N'2024-02-23T19:31:13.450' AS DateTime), NULL, CAST(N'2024-02-23T19:31:37.180' AS DateTime))
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (4, N'Macarena', N'Vaca', CAST(N'2024-02-24T20:03:09.230' AS DateTime), N'macarenavaca.mv@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'mvaca', NULL, 0, 1, 1, NULL, N'F3E7F5E5-8501-47AB-92C3-2E4208207FDF', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (5, N'Pedro', N'Gómez', CAST(N'2024-02-27T19:47:54.730' AS DateTime), N'pedro.gomez_123@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'PedroG', CAST(N'1992-10-05' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_5.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-27T20:24:28.187' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (6, N'Ana', N'Martínez', CAST(N'2024-02-27T19:47:54.733' AS DateTime), N'ana.martinez-87@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'AnaM', CAST(N'1987-06-15' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_6.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-27T20:25:21.100' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (7, N'Luis', N'Fernández', CAST(N'2024-02-27T19:47:54.733' AS DateTime), N'luis_fernandez.1995@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'LuisF', CAST(N'1995-02-20' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_7.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-27T20:26:06.230' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (8, N'Sofía', N'Rodríguez', CAST(N'2024-02-27T19:47:54.733' AS DateTime), N'sofia.rodriguez123@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'SofiaR', CAST(N'1983-09-25' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_8.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-27T20:26:35.993' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (9, N'Javier', N'Díaz', CAST(N'2024-02-27T19:47:54.733' AS DateTime), N'javier-diaz1990@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'JavierD', CAST(N'1990-12-12' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_9.jpg                                                                                                                                                                                                      ', CAST(N'2024-02-27T20:28:12.290' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (10, N'Laura', N'López', CAST(N'2024-02-27T19:47:54.737' AS DateTime), N'laura.lopez_88@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'LauraL', CAST(N'1988-07-30' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_10.jpg                                                                                                                                                                                                     ', CAST(N'2024-02-27T20:30:06.157' AS DateTime), 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (11, N'Carlos', N'Hernández', CAST(N'2024-02-27T19:47:54.737' AS DateTime), N'carlos_hernandez-98@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'CarlosH', CAST(N'1998-04-18' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (12, N'Elena', N'García', CAST(N'2024-02-27T19:47:54.737' AS DateTime), N'elena.garcia.1993@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'ElenaG', CAST(N'1993-01-08' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (13, N'David', N'Martín', CAST(N'2024-02-27T19:47:54.737' AS DateTime), N'david.martin85@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'DavidM', CAST(N'1985-11-22' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted]) VALUES (14, N'María', N'González', CAST(N'2024-02-27T19:47:54.740' AS DateTime), N'maria-gonzalez91@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'MariaG', CAST(N'1991-06-07' AS Date), 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[Contacts] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactXEvent] ON 
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (1, 2, 1, CAST(N'2024-02-21T21:52:33.340' AS DateTime), CAST(N'2024-02-21T21:52:37.573' AS DateTime))
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (2, 2, 1, CAST(N'2024-02-21T21:52:41.510' AS DateTime), CAST(N'2024-02-24T18:16:42.660' AS DateTime))
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (3, 3, 1, CAST(N'2024-02-23T19:10:52.000' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (4, 3, 3, CAST(N'2024-02-23T19:10:58.800' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (5, 2, 1, CAST(N'2024-02-24T19:09:52.087' AS DateTime), CAST(N'2024-02-24T19:10:02.173' AS DateTime))
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (6, 2, 5, CAST(N'2024-02-28T14:46:11.223' AS DateTime), NULL)
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
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'EventId', 2, N'no cumple con politicas', NULL, 1)
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
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (1, N'¡Bienvenidos al evento ''Inclusión a través del Arte''! Este evento busca promover la participación activa de personas con discapacidad en el mundo artístico. Contaremos con talleres de pintura, escultura y música adaptados para diferentes habilidades. Únete a nosotros para celebrar la diversidad y la creatividad. ¡Esperamos verlos allí!<br><br>Detalles del evento:<br><br>Talleres de pintura inclusivos.<br>Sesiones de música adaptada.<br>Escultura con enfoque en la accesibilidad.<br>Conferencias sobre la importancia de la inclusión en las artes.<br><br><br><br>¡No te pierdas esta oportunidad de conectarte a través del arte y crear recuerdos inolvidables juntos!', N'Inclusión a través del Arte', CAST(N'2024-02-21T20:55:11.340' AS DateTime), CAST(N'2024-03-01T02:53:00.000' AS DateTime), CAST(N'2024-03-03T22:53:00.000' AS DateTime), 2, 2, 2, CAST(N'2024-02-27T19:24:34.020' AS DateTime), N'http://comunidad-parimpar.com.ar/Events/EventId_1.jpg', CAST(N'2024-02-28T14:51:52.390' AS DateTime))
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (2, N'"Te invitamos a nuestra conferencia sobre ''Tecnologías Accesibles''. Exploraremos las últimas innovaciones que facilitan la vida de las personas con discapacidad. Desde aplicaciones móviles hasta dispositivos de asistencia, este evento abordará cómo la tecnología puede crear un mundo más inclusivo. ¡Acompáñanos para aprender, compartir y conectarnos!<br><br>Temas destacados:<br><br>Aplicaciones móviles para la accesibilidad.<br>Dispositivos de asistencia y su impacto.<br>Desarrollo de tecnologías inclusivas.<br>Experiencias de usuarios con tecnologías adaptativas.<br><br>¡Esperamos que esta conferencia inspire nuevas ideas y colaboraciones para un futuro más accesible para todos!"', N'Conferencia sobre Tecnologías Accesibles', CAST(N'2024-02-21T20:57:13.940' AS DateTime), CAST(N'2024-04-15T18:00:00.000' AS DateTime), CAST(N'2024-04-16T18:00:00.000' AS DateTime), 2, 2, 3, CAST(N'2024-02-27T19:22:12.420' AS DateTime), N'http://comunidad-parimpar.com.ar/Events/EventId_2.png', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (3, N'Te invitamos a participar en nuestro Taller de Empleabilidad, diseñado específicamente para personas con discapacidad. Exploraremos estrategias para superar desafíos laborales y fomentar la inclusión en el ámbito profesional. ¡Aprende, conecta y prepárate para el éxito!<br><br>Aspectos destacados:<br><br>Consejos para la búsqueda de empleo.<br>Desarrollo de habilidades profesionales.<br>Experiencias de éxito en el mundo laboral.<br>Oportunidades de networking inclusivo.<br><br>¡Juntos construiremos un camino hacia la igualdad de oportunidades en el mundo laboral!', N'Taller de Empleabilidad para Personas con Discapacidad', CAST(N'2024-02-21T21:03:55.633' AS DateTime), CAST(N'2024-06-10T09:00:00.000' AS DateTime), CAST(N'1996-06-11T17:00:00.000' AS DateTime), 2, 2, 2, CAST(N'2024-02-27T19:20:17.120' AS DateTime), N'http://comunidad-parimpar.com.ar/Events/EventId_3.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (4, N'Únete a nuestra Jornada Deportiva Inclusiva, un evento dedicado a promover la actividad física para personas con discapacidad. Participa en emocionantes competiciones adaptadas y descubre la importancia del deporte en la inclusión social. ¡Ven y celebra la diversidad a través del movimiento!<br><br>Actividades destacadas:<br><br>Carreras inclusivas.<br>Juegos adaptados para todas las edades.<br>Clases de yoga accesible.<br>Exhibiciones de deportes adaptados.<br>¡Nos esforzamos por crear un espacio donde todos puedan disfrutar del deporte sin barreras ni limitaciones!', N'Jornada Deportiva Inclusiva', CAST(N'2024-02-23T19:08:16.200' AS DateTime), CAST(N'2024-05-20T09:00:00.000' AS DateTime), CAST(N'2024-05-21T20:00:00.000' AS DateTime), 3, 1, 3, NULL, NULL, CAST(N'2024-02-23T19:31:37.180' AS DateTime))
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (5, N'¡Únete a nosotros para un fin de semana emocionante lleno de creatividad y fotografía! En este taller de dos días, exploraremos las técnicas y conceptos detrás de la fotografía creativa y aprenderemos a capturar momentos únicos de manera innovadora.<br><br>Durante este evento, los participantes aprenderán:<br><br>Conceptos básicos de composición y encuadre.<br>Cómo jugar con la luz y las sombras para crear efectos dramáticos.<br>Técnicas de fotografía de larga exposición para capturar movimiento y crear efectos impresionantes.<br>Cómo utilizar accesorios y elementos inesperados para añadir interés visual a tus fotografías.<br>Consejos prácticos para mejorar tu creatividad y desarrollar tu propio estilo fotográfico.<br>Detalles del Evento:<br><br>Fecha y Hora:<br>Sábado, 10 de Marzo de 2024, de 9:00 a.m. a 5:00 p.m.<br>Domingo, 11 de Marzo de 2024, de 10:00 a.m. a 4:00 p.m.<br>Ubicación: Estudio de Fotografía Creativa "Captura tus Sueños", Calle Principal #123, Ciudad Creativa.<br>Costo de Inscripción: $100 por participante. (Incluye materiales y refrigerios).<br>Requisitos: No se requiere experiencia previa en fotografía. ¡Todos son bienvenidos a unirse y explorar su creatividad!<br>Cómo Registrarse:<br>Para registrarte, envía un correo electrónico a [correo electrónico de contacto] con tu nombre completo y número de teléfono antes del [fecha límite de inscripción]. El pago se realizará en el lugar el primer día del taller.<br><br>¡No te pierdas esta oportunidad de sumergirte en el mundo de la fotografía creativa y aprender nuevas habilidades que te inspirarán en tus futuros proyectos fotográficos!', N'Taller de Fotografía Creativa: Capturando Momentos Únicos', CAST(N'2024-02-24T20:48:51.447' AS DateTime), CAST(N'2024-03-10T09:00:00.000' AS DateTime), CAST(N'2024-03-11T18:00:00.000' AS DateTime), 2, 2, 2, CAST(N'2024-02-27T16:12:21.017' AS DateTime), N'http://comunidad-parimpar.com.ar/Events/EventId_5.jpg', NULL)
GO
SET IDENTITY_INSERT [dbo].[Events] OFF
GO
INSERT [dbo].[MailExecutions] ([Send], [LastExecution]) VALUES (N'SendNotificy', CAST(N'2024-02-21T22:03:04.407' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (1, N'En esta publicación, exploraremos los últimos avances en tecnología diseñada para mejorar la calidad de vida de las personas con discapacidad visual. Desde dispositivos de asistencia hasta aplicaciones innovadoras, descubre cómo la tecnología está desempeñando un papel crucial en la inclusión y el empoderamiento de la comunidad con discapacidad visual. Acompáñanos en este viaje hacia un mundo más accesible e inclusivo.<br><br>', N'En el ámbito de la discapacidad visual, la tecnología ha emergido como una herramienta revolucionaria para superar barreras. A lo largo de esta investigación, exploraremos dispositivos como lectores de pantalla, sistemas de navegación por voz y aplicaciones móviles diseñadas específicamente para mejorar la independencia y la participación en la sociedad de las personas con discapacidad visual.<br><br>La evolución de la inteligencia artificial ha permitido la creación de tecnologías cada vez más sofisticadas. Analizaremos cómo los algoritmos de reconocimiento de objetos y la realidad aumentada están siendo implementados para facilitar tareas diarias, desde identificar objetos hasta navegar por entornos desconocidos. Estos avances no solo brindan nuevas oportunidades, sino que también fomentan la autonomía y la igualdad de oportunidades.<br><br>Además, nos sumergiremos en proyectos de investigación que buscan desarrollar interfaces cerebro-máquina para personas con discapacidad visual. Estas interfaces tienen el potencial de traducir la actividad cerebral en comandos ejecutables, abriendo nuevas posibilidades para la interacción con dispositivos y entornos digitales.<br><br>En el contexto de la educación, examinaremos plataformas educativas accesibles que utilizan tecnologías de voz y braille digital para garantizar que las personas con discapacidad visual tengan acceso equitativo a la información. Destacaremos programas pioneros que promueven la inclusión educativa y la capacitación laboral para mejorar las perspectivas de empleo.<br><br>Esta publicación también abordará los desafíos éticos asociados con el uso de tecnologías asistivas, destacando la importancia de la privacidad y la seguridad en el diseño de estas soluciones. Al mismo tiempo, reflexionaremos sobre cómo la sociedad puede avanzar hacia un futuro más inclusivo, donde la tecnología se utilice como una herramienta para derribar barreras y fomentar la diversidad.<br><br>En resumen, este análisis exhaustivo busca arrojar luz sobre la intersección entre la tecnología y la discapacidad visual, destacando tanto los logros actuales como las oportunidades futuras para mejorar la calidad de vida de las personas con esta discapacidad. Acompáñanos en este viaje hacia un mundo más inclusivo, donde la innovación tecnológica se convierte en un catalizador para el cambio positivo.', N'Avances en la Integración Tecnológica para Personas con Discapacidad Visual', CAST(N'2024-02-21T21:37:09.403' AS DateTime), CAST(N'2024-02-27T19:38:03.760' AS DateTime), 2, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_1.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (2, N'Exploraremos en profundidad estrategias innovadoras y prácticas efectivas para apoyar a estudiantes con Trastorno del Espectro Autista (TEA) en entornos educativos. Desde adaptaciones curriculares hasta programas de intervención temprana, descubre cómo podemos crear ambientes inclusivos que potencien el aprendizaje y el desarrollo social de estos estudiantes. Únete a nosotros para promover la igualdad educativa.', N'La inclusión educativa es un aspecto crucial de la igualdad para todos los estudiantes, y en este artículo, nos enfocaremos en abordar específicamente las necesidades de aquellos con Trastorno del Espectro Autista (TEA). Examincaremos estrategias efectivas que van desde la adaptación de material didáctico hasta la implementación de programas de intervención temprana.<br><br>Comenzaremos destacando la importancia de crear entornos de aprendizaje que sean visualmente estructurados y predecibles, proporcionando a los estudiantes con TEA un marco que facilite su comprensión del entorno escolar. Analizaremos cómo la implementación de rutinas y horarios visuales puede contribuir a la reducción de la ansiedad y mejorar la participación activa en el aula.<br><br>La colaboración entre docentes, profesionales de la salud y familias será un punto central en nuestra exploración. Discutiremos modelos exitosos de trabajo en equipo que promueven una comprensión profunda de las necesidades individuales de cada estudiante con TEA. Además, examinaremos estrategias para fomentar la comunicación efectiva, tanto verbal como no verbal, dentro del entorno escolar.<br><br>Nos sumergiremos en investigaciones recientes que destacan la eficacia de las intervenciones conductuales y terapias centradas en el juego para mejorar las habilidades sociales y emocionales de los estudiantes con TEA. Además, exploraremos la implementación de tecnologías asistivas y aplicaciones diseñadas para apoyar el aprendizaje y la comunicación.<br><br>En el ámbito de la capacitación del personal educativo, discutiremos programas de formación que promueven la conciencia y la comprensión del TEA. Destacaremos la importancia de la empatía y la flexibilidad en la enseñanza, reconociendo la diversidad de estilos de aprendizaje y adaptándose a las necesidades individuales.<br><br>En conclusión, este artículo busca proporcionar a educadores, padres y profesionales de la salud herramientas prácticas y conocimientos fundamentales para crear ambientes educativos inclusivos y apoyar el desarrollo pleno de estudiantes con Trastorno del Espectro Autista. Únete a nosotros en este viaje hacia una educación más equitativa y comprensiva para todos.', N'Inclusión Educativa: Estrategias para Apoyar a Estudiantes con Trastorno del Espectro Autista (TEA)', CAST(N'2024-02-21T21:42:42.757' AS DateTime), CAST(N'2024-02-27T19:39:10.640' AS DateTime), 2, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_2.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (3, N'Exploraremos estrategias inclusivas y programas innovadores diseñados para apoyar a personas que enfrentan discapacidades físicas o motoras junto con discapacidades sensoriales. Desde el diseño de entornos accesibles hasta la implementación de tecnologías táctiles, descubre cómo podemos construir puentes hacia una sociedad más inclusiva para todos.', N'En este estudio, nos enfocaremos en la intersección de las discapacidades físicas o motoras y sensoriales, reconociendo la diversidad de experiencias que enfrentan las personas que viven con estas condiciones. Abordaremos estrategias y soluciones que buscan superar las barreras existentes y promover la inclusión activa.<br><br>Comenzaremos explorando el diseño de entornos accesibles que no solo consideran las necesidades de movilidad, sino también las de percepción sensorial. Analizaremos cómo la arquitectura inclusiva y la disposición de elementos táctiles pueden facilitar la orientación y la movilidad para personas con discapacidades múltiples, proporcionando independencia y seguridad.<br><br>En el ámbito de la tecnología, examinaremos dispositivos innovadores que combinan funcionalidades táctiles con comandos motoros, permitiendo a las personas con discapacidades físicas o motoras y sensoriales interactuar de manera más efectiva con el entorno digital. Esta convergencia tecnológica tiene el potencial de abrir nuevas oportunidades de comunicación y participación.<br><br>Nos sumergiremos en proyectos de investigación que aborden desafíos específicos enfrentados por aquellos con discapacidades múltiples, desde la adaptación de vehículos accesibles hasta el desarrollo de sistemas de comunicación táctiles. Destacaremos cómo la colaboración interdisciplinaria es esencial para abordar las complejidades y singularidades de cada individuo.<br><br>En el ámbito educativo, discutiremos estrategias para la inclusión efectiva en aulas que atienden a estudiantes con discapacidades físicas o motoras y sensoriales. Desde materiales didácticos adaptados hasta tecnologías de apoyo, analizaremos enfoques que fomenten la participación activa y el aprendizaje significativo.<br><br>Finalmente, reflexionaremos sobre la importancia de una sociedad que reconozca y valore la diversidad de habilidades y experiencias. Abogaremos por la construcción de puentes de comprensión y apoyo que lleven a una comunidad más inclusiva y respetuosa con las personas que enfrentan discapacidades múltiples. Únete a nosotros en este viaje hacia la construcción de un mundo donde todos tengan la oportunidad de participar plenamente.', N'Construyendo Puentes de Inclusión: Apoyando a Personas con Discapacidades Múltiples', CAST(N'2024-02-21T21:44:21.407' AS DateTime), CAST(N'2024-02-27T19:41:04.623' AS DateTime), 2, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_3.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (4, N'Esta publicación se sumerge en estrategias holísticas para mejorar la calidad de vida de personas que enfrentan discapacidades psíquicas, auditivas y del espectro autista. Desde enfoques terapéuticos innovadores hasta programas de apoyo comunitario, exploraremos cómo la integración de múltiples perspectivas puede crear entornos más inclusivos y enriquecedores.', N'Enfocándonos en la complejidad de las discapacidades múltiples, exploraremos estrategias integrales que aborden las dimensiones psíquicas, auditivas y del espectro autista. Nuestra investigación abarcará desde terapias personalizadas hasta iniciativas comunitarias que fomenten el bienestar y la participación activa.<br><br>Comenzaremos explorando enfoques terapéuticos innovadores diseñados para abordar las necesidades específicas de personas con discapacidades psíquicas, auditivas y del espectro autista. Desde terapias cognitivas hasta programas de intervención conductual, analizaremos cómo la atención centrada en la persona puede mejorar la autonomía y la calidad de vida.<br><br>Nos adentraremos en el ámbito de la comunicación, examinando estrategias adaptativas que se ajusten a las distintas formas de expresión presentes en las discapacidades auditivas y del espectro autista. Discutiremos la importancia de entornos inclusivos que fomenten la comunicación efectiva, utilizando lenguajes visuales, táctiles y alternativos.<br><br>En el contexto de la comunidad, analizaremos programas que buscan crear redes de apoyo para personas con discapacidades múltiples. Desde grupos de autoayuda hasta eventos inclusivos, destacaremos cómo la conexión social y la comprensión mutua son fundamentales para el bienestar emocional y la integración en la sociedad.<br><br>Exploraremos investigaciones que examinan la intersección de estas discapacidades en el ámbito educativo, identificando estrategias para adaptar ambientes de aprendizaje y garantizar la participación plena de estudiantes con discapacidades múltiples. Analizaremos la importancia de profesionales capacitados y de un enfoque individualizado en la educación inclusiva.<br><br>En resumen, esta publicación busca proporcionar una visión completa de las experiencias de las personas que enfrentan discapacidades psíquicas, auditivas y del espectro autista. Al hacerlo, abogamos por un enfoque integral que reconozca la singularidad de cada individuo y promueva la construcción de una sociedad más inclusiva y comprensiva. Acompáñanos en este viaje hacia la mejora significativa de la calidad de vida para todos.', N'Un Enfoque Integral: Mejorando la Calidad de Vida para Personas con Discapacidades Múltiples', CAST(N'2024-02-23T19:10:19.503' AS DateTime), NULL, 3, NULL, N'http://comunidad-parimpar.com.ar/Posts/PostId_4.png', 1, CAST(N'2024-02-23T19:31:37.180' AS DateTime))
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (5, N'Exploraremos en esta publicación estrategias integralmente diseñadas para apoyar a individuos que enfrentan discapacidades intelectuales, psíquicas y del habla. Desde programas inclusivos de desarrollo cognitivo hasta terapias innovadoras del habla, descubre cómo se pueden construir comunidades más comprensivas y solidarias.<br>', N'Este artículo se sumergirá en el complejo mundo de las discapacidades, abordando específicamente las áreas de discapacidad intelectual, psíquica y del habla. Nos enfocaremos en estrategias holísticas que reconocen la diversidad de necesidades y fortalezas de cada individuo.<br><br>Comenzaremos explorando programas de desarrollo cognitivo que buscan potenciar las habilidades intelectuales de personas con discapacidad intelectual. Analizaremos enfoques inclusivos que van más allá de la educación tradicional, fomentando el aprendizaje experiencial y la participación activa en la comunidad.<br><br>En el ámbito de la discapacidad psíquica, examinaremos terapias innovadoras que buscan mejorar la salud mental y emocional. Discutiremos cómo la combinación de terapias cognitivas, arte terapia y enfoques centrados en la atención plena puede contribuir a la estabilidad emocional y al bienestar general.<br><br>Abordaremos la discapacidad del habla desde perspectivas diversas, explorando terapias logopédicas que van desde métodos tradicionales hasta tecnologías de comunicación asistida. Destacaremos la importancia de adaptar las estrategias de intervención a las necesidades individuales, reconociendo la singularidad de cada persona.<br><br>Nos sumergiremos en investigaciones que examinan las intersecciones entre estas discapacidades, reconociendo la complejidad de las experiencias de aquellos que enfrentan múltiples desafíos. Exploraremos modelos de atención integral que buscan proporcionar apoyo global, considerando aspectos físicos, emocionales y sociales.<br><br>En el contexto de la inclusión social, discutiremos programas comunitarios que promueven la participación activa de personas con discapacidades variadas. Analizaremos cómo la sensibilización y la educación pueden ser herramientas poderosas para construir comunidades más comprensivas y solidarias.<br><br>En conclusión, este artículo busca ser una guía integral para aquellos que buscan comprender y apoyar a personas con discapacidades intelectuales, psíquicas y del habla. Únete a nosotros en este viaje hacia la creación de entornos que empoderen vidas y celebren la diversidad en todas sus formas.', N'Empoderando Vidas: Estrategias Holísticas para Personas con Discapacidades Variadas', CAST(N'2024-02-23T19:34:29.327' AS DateTime), CAST(N'2024-02-27T19:42:26.443' AS DateTime), 2, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_5.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (6, N'prueba', N'prueba', N'prueba', CAST(N'2024-02-28T14:58:10.087' AS DateTime), NULL, 4, NULL, NULL, 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (7, N'prueba2', N'prueba2', N'prueba2', CAST(N'2024-02-28T14:59:01.547' AS DateTime), NULL, 6, 2, NULL, 2, NULL)
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
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (15, 6, 8)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (16, 6, 6)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (17, 7, 1)
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
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'02181bee-a162-4f08-8bda-f78aaf300cd2', N'd7875f88-b797-40a0-94cc-0458a5f360c5', N'IoyVpjEtlqE-EF8KLvIlxlpP291AsglrvBeZb87r33k', N'aJskYJ2liCZgHe-Yu6NHxSmQzVeSkWt4y845r88hYSA', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwMjE4MWJlZS1hMTYyLTRmMDgtOGJkYS1mNzhhYWYzMDBjZDIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViQ3lMeDdubmgvS3F4KzBJZHdEQnJIaWcydGFzVjFLNVI4eHlsckJiWFFRbFpnR3R2V3pyOUNhQVhIdjQwKzhZa2l5MDB2MFkrcUc0cm5ZR2I0aVArdmd2MW02bGQ5dk82UzE5Zi9TWk5kSjNYdFFZdEwvREVmL0pPaUR1NlBpcVBvSEpSR2k2MXVBeHNOMWQ1MHhVS2tQYkpjL1pLdGE5M0wvNFpYNERXYkZGczRnRytTYUNmTTBMTDB4eXBJN1JEODdFZkhpTWIzbUZRREFLenFldDRRdlozaGtLUzhlZC9mZnZOUjJ3T0dhNWNrQ0oyZXpWNGdXZ0pZcUNCYUJCQ2h0bi81NlFkRnd2KytLZmFQMnoyVT0iLCJuYmYiOjE3MDkwNzM0NzEsImV4cCI6MTcwOTE1OTg3MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.IoyVpjEtlqE-EF8KLvIlxlpP291AsglrvBeZb87r33k', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkNzg3NWY4OC1iNzk3LTQwYTAtOTRjYy0wNDU4YTVmMzYwYzUiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3MzQ3MSwiZXhwIjoxNzA5MDc0MzcxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.aJskYJ2liCZgHe-Yu6NHxSmQzVeSkWt4y845r88hYSA', CAST(N'2024-02-28T19:37:51.087' AS DateTime), CAST(N'2024-02-27T19:52:51.087' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T19:37:51.093' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'104647d8-69ee-43da-b080-28090d70b853', N'23ba8735-9153-4eea-8c5f-18b9b9b0fc0b', N'LEF9iUH6mcBXNO6HQv1mniKEaG5NVAklYHgkiPFY_Vw', N'sY6-tlOP4DWpckuXL2UOt83QQN3wsAyQGCJff4BZw4Q', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxMDQ2NDdkOC02OWVlLTQzZGEtYjA4MC0yODA5MGQ3MGI4NTMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVaUjYrVmlWcnkyaWNqQU1wbU96anFjbU5nNHlmWXZ2anp4a0lMT3d4L1VoK0h1cjJSd2JrT04rS0MxMUJSK2VTbitLbUZOZEdoNG9kUU9rRXhTdUVsbkUwMFAzNllxVm1Hb3BkYitBM01SWk02SlhsZ0RJKytpQnZDSEpnRk92N2phVU1PRllSMkZoQkc4aitRK1hoeWI4ZTJxRUFrOWVWSHZ1enZXSDVEZ2FRSWdLWUx5aVBPS1Z1RnRjaGNPM2NZY3VSQmNBMnYrdUlSTTM0cFhDUHc2TFF5N0xNM2h5d0hESmpaNG9vczRpanBZQzRPMmlZaEJNV2NQTjMvUDl3YkhzRTNpcWV6WUU3blhsRDZXZlVDYz0iLCJuYmYiOjE3MDkwNzExODAsImV4cCI6MTcwOTE1NzU4MCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.LEF9iUH6mcBXNO6HQv1mniKEaG5NVAklYHgkiPFY_Vw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyM2JhODczNS05MTUzLTRlZWEtOGM1Zi0xOGI5YjliMGZjMGIiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3MTE4MCwiZXhwIjoxNzA5MDcyMDgwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.sY6-tlOP4DWpckuXL2UOt83QQN3wsAyQGCJff4BZw4Q', CAST(N'2024-02-28T18:59:40.637' AS DateTime), CAST(N'2024-02-27T19:14:40.637' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T18:59:40.657' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'16d80656-8fb4-4a55-b770-23ce9fde9deb', N'32bae758-b203-4eca-b4d0-509c2473d0f7', N'PWGlXbXNnx2vx2YUjHqSUXuLhf1h0A93xWUkROfw1Aw', N'6tVPjhj_M5okEQPcenQPxBocHckKdfEWgoeFhpbsw44', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxNmQ4MDY1Ni04ZmI0LTRhNTUtYjc3MC0yM2NlOWZkZTlkZWIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVeG4wSWFpSm02M2VjSnY1emJnQkZtdlVjZkFvai81Qmova2lVemNjdmFKajhtVXlQSXJwLzVPR2dVbW1xdXNlWm92dDB4R1NoSW1GSnRQWWpLNGJiYXJzbll3bmF1S3FlUXZCRjBhNFVQQUZnN2FZdW5QVlpmZ3ZURFd5Unh2ZFlncW8xelQ4cHBsZ0pCMUJ4YUhhaDE4K3hHbnl5UU5MaEdGeWJ5ZEdiTW5ZaXRsV0dJSWtyaDNwK002SE00MW1LYkVIK3hINUs0ZkwySysyYkZEMVZSU25uZnRzSVRoWE9YYmdYR0F4a05MWmRMVkQwbi9GT2cvNW9jQXlFWjBNQ3MrUUlTdURCT1JIaTBjaGpWK1M2ND0iLCJuYmYiOjE3MDg4MjAxNjMsImV4cCI6MTcwODkwNjU2MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.PWGlXbXNnx2vx2YUjHqSUXuLhf1h0A93xWUkROfw1Aw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMmJhZTc1OC1iMjAzLTRlY2EtYjRkMC01MDljMjQ3M2QwZjciLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgyMDE2MywiZXhwIjoxNzA4ODIxMDYzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.6tVPjhj_M5okEQPcenQPxBocHckKdfEWgoeFhpbsw44', CAST(N'2024-02-25T21:16:03.697' AS DateTime), CAST(N'2024-02-24T21:31:03.697' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T21:16:03.700' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'1bb79b24-82d7-4bd1-a929-43000aca2ea0', N'd8578bf2-3c50-4d3a-983f-6d40fe8de688', N'obABgxpzgtGk1VX31kdj9zn9Gbp0Y2slgNkj0E6AVl0', N'4xrsYc2klxqKNsyfrzo41p699nOf4vZc9lwTnCuErKs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxYmI3OWIyNC04MmQ3LTRiZDEtYTkyOS00MzAwMGFjYTJlYTAiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRNFZJa1NMdFNCRzQrS2FjNHJOWCttcVcvejJUNXJ3Vm1zdUw4ZHpFS0ZLdnVIaEprVzZvaWhEMUhLTWxGeTRLNjBValJCYVplR04rUW12Y0kxQys4UlFvUk10RzhGb1F5amkrbzRlR3F0UXRLRE4wWWQvNlEyNzlOd2IzQ21CbUNnbGJnZFhidDNNSnFkWGhnakdLZzZYQUZMWG9Qc0tRbmlNNEtXei94ejVUdE91S0xmL0VXUGxFcDEzRVJiMkoxejRISXJ5TVIzdjAvTktxaStvcCtPd1NPb0E2Sm1hbHFmMUFyOGZwSzNpeHoyZXF1YWhLWHJMV2lUL0IzKzZXYWduTFYyZWE2Q2tFc1RPU3Y3UzMwWT0iLCJuYmYiOjE3MDkwNzY0MDksImV4cCI6MTcwOTE2MjgwOSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.obABgxpzgtGk1VX31kdj9zn9Gbp0Y2slgNkj0E6AVl0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkODU3OGJmMi0zYzUwLTRkM2EtOTgzZi02ZDQwZmU4ZGU2ODgiLCJDb250YWN0SWQiOiI5IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NjQwOSwiZXhwIjoxNzA5MDc3MzA5LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.4xrsYc2klxqKNsyfrzo41p699nOf4vZc9lwTnCuErKs', CAST(N'2024-02-28T20:26:49.567' AS DateTime), CAST(N'2024-02-27T20:41:49.567' AS DateTime), N'[{"Key":"ContactId","Value":"9"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:26:49.563' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'21caffed-c44b-4e07-9aef-6eaa4cef0e99', N'606c7853-1972-4786-a9ec-b8c0e69d62ef', N'OmDIs2Msb3rbxe16KLUCy0gYD82NhMdIGCNH6A3iOec', N'O7ePl7QV7h6cesK5bqRpR5oKx8ztPQp_3GCkdybHGiI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyMWNhZmZlZC1jNDRiLTRlMDctOWFlZi02ZWFhNGNlZjBlOTkiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVhd20xd3NiQ1pEQmFJZXhnR3Rqd09DUnExSGE2VGxERGpEbXMvMTlFL1ZIcS9rdWo1UnJqUHBuWFpqTVI0bWpBWnFqZFFqTnU5YVZMUWpzMVRZQzFOS0VSbm5SU3dtRnpncmJwK1hFWDNhWEt1SUpjTjlIQ2t1S3pob0x4ZDRDdlBFemRNamtibFB2SWFKS2hOTHdsRmhqODJwOFl4SGdreTF2UlJBbG1oM0xaYmdHZkZxbUJ2L1piZHlMcW9qVSthdWx3NStmemRyWDVpSHVMVXZGSHVQbGhUOEZualhHTHBpMVdxck0wUFJ0bkVOemczMUR3NFY0NjlCK0d6OEZHOVljMVkrS2YyelhvZERVQm5IQ2tHdz0iLCJuYmYiOjE3MDkwNzYyMzAsImV4cCI6MTcwOTE2MjYzMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.OmDIs2Msb3rbxe16KLUCy0gYD82NhMdIGCNH6A3iOec', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MDZjNzg1My0xOTcyLTQ3ODYtYTllYy1iOGMwZTY5ZDYyZWYiLCJDb250YWN0SWQiOiI1IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NjIyOSwiZXhwIjoxNzA5MDc3MTI5LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.O7ePl7QV7h6cesK5bqRpR5oKx8ztPQp_3GCkdybHGiI', CAST(N'2024-02-28T20:23:50.003' AS DateTime), CAST(N'2024-02-27T20:38:50.003' AS DateTime), N'[{"Key":"ContactId","Value":"5"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:23:50.003' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'223c8a3a-983a-4231-be65-e9179bd5592a', N'a4c61ce6-345a-4ccb-9f5b-6e6e59541e31', N'VEZZSjjPOvhraWUJ0DmRVOyWENLKSrx-qDH1x6IWm_4', N'c91R_AQ4qRn7Y-SduSknIjkuaOCZivx1w_AQP35AMWU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyMjNjOGEzYS05ODNhLTQyMzEtYmU2NS1lOTE3OWJkNTU5MmEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRSmorTkdIS1V4UHh3V0ZzaTcwWkdtZEh5ZElPeEhqbFZ3MDhnMEoycVJTQm5aUVp5YW1kNmtPRGRodFdUbG43TkNrMEJ2dXNWTXB1RGFrYzVnQnh5NWUxVlFqRjdESzV3MmFldzlJZzNjN2phSDh5cklHbjlKVHRoZndwVTNranRidGd1bEVPeWJLcmQvSUJPTGVMc1JQT1VlbzJlSUlaeTJ6MUx6M0JWS1VUb0JnOFNzSHJGVFY3dDVESXloeEJIVWQ0Nmh5WTg0eWdFNFFjbmkrV21aV2pMS2xPVmQxenIrRWw5UnVNdUY1V0w3M1JqekZtazJFK1lnaFRiN2JBNlZpeVVLUmo4c0pPSUt6MkdSUmJmOD0iLCJuYmYiOjE3MDkwNjAxNTQsImV4cCI6MTcwOTE0NjU1NCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.VEZZSjjPOvhraWUJ0DmRVOyWENLKSrx-qDH1x6IWm_4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhNGM2MWNlNi0zNDVhLTRjY2ItOWY1Yi02ZTZlNTk1NDFlMzEiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA2MDE1NCwiZXhwIjoxNzA5MDYxMDU0LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.c91R_AQ4qRn7Y-SduSknIjkuaOCZivx1w_AQP35AMWU', CAST(N'2024-02-28T15:55:54.013' AS DateTime), CAST(N'2024-02-27T16:10:54.013' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T15:55:54.017' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'3008d9f3-73ae-4e8b-af79-1ad2868acd8f', N'd6ecd07f-b382-46e4-b8b2-f905daddd28d', N'nsqw3puBzt0wnvdwS9a9NY3En5nmrt_gTig_ZaYpN8M', N'h91OxdRy41aO899AvlzLM18CHMi6UpVCrLLQRwm5jqs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDA4ZDlmMy03M2FlLTRlOGItYWY3OS0xYWQyODY4YWNkOGYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVZMHZTQVNwVTdHWmJQNkhCOTIxNE9vTlNwcHRNeThtNTBZc2pFWFdMWGVOODlQd0d5SEpyWnhYRUJ4WVFJVW12bDJXbWRYUnFIVTdJWFdLMFZpRTRKUkVaOHc1ZFFvV21sZEFZZnBDcXVjd0g2cUF0OHA4TlVlSzdJZ1d1VjZhN1Z2ejI5UG9nb0FTeTBUTzZMUGxjeDlaV3VueHdMaGZIUHNSa3ZLZ0dkblQxNzJqZzA3U1JkeHZuZUxlN0RiQnRUZ2RqYkliL1piVmVzZmhGV25jMmFZNGRZNENOTThtUnY4TzB1NVlmaC8xdFRkWTd6NE9kckV1REtzMDE4SENDbGVuUERGK3A0cjRnbi9JditCZWdWST0iLCJuYmYiOjE3MDg5ODMxNzcsImV4cCI6MTcwOTA2OTU3NywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.nsqw3puBzt0wnvdwS9a9NY3En5nmrt_gTig_ZaYpN8M', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkNmVjZDA3Zi1iMzgyLTQ2ZTQtYjhiMi1mOTA1ZGFkZGQyOGQiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODk4MzE3NywiZXhwIjoxNzA4OTg0MDc3LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.h91OxdRy41aO899AvlzLM18CHMi6UpVCrLLQRwm5jqs', CAST(N'2024-02-27T18:32:57.967' AS DateTime), CAST(N'2024-02-26T18:47:57.967' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-26T18:32:57.963' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'3666a7f1-7ae5-4890-9c80-832d0d4beeff', N'3f4c0bd6-a15c-4955-aa70-a98adfda3a05', N'eGHJqSSd6ylVO5GtFm2S4tawmhKjEI_bd3vqWzyYc7A', N'2Apcul2belZtqcgEAuXq1BskvOSLsWgG5voMiuxmXsY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzNjY2YTdmMS03YWU1LTQ4OTAtOWM4MC04MzJkMGQ0YmVlZmYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmRTlLT0JycXhNUjA3WlJvZXhQZHhWNitFWmt0UWNZWkt5bXg4S2Y5YnJaZ1p3cnB5bnp0SmhsM1BBQkVWeWlSdXphcWJaL3NHTXhMNWF5T3lFanpZVUxJQ2dLdXFIb3VoSnp6Skd4Nkd2OElrVStFaEoxam0vNEZvcFBaajJsS1VLNGh6N1MvcWtMU0RHT3Y2QlhFZU4vUTFXMlJ6akVJeDhOaitqanlUWEtIT0dGQXNDdEs5VnRYdVNvL1BRS3VZWnE4OXJxUjJVY0FtUlB1NFREaGwvRklVcTRQMzN2SWJUMThpazQwQlRVa1o1Sit6WVhySmFhZ3NvY05QZ2xpOG1STHdFNmdQcURITWgyYkRmN1VHUT0iLCJuYmYiOjE3MDg4MTI5MzUsImV4cCI6MTcwODg5OTMzNSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.eGHJqSSd6ylVO5GtFm2S4tawmhKjEI_bd3vqWzyYc7A', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzZjRjMGJkNi1hMTVjLTQ5NTUtYWE3MC1hOThhZGZkYTNhMDUiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgxMjkzNSwiZXhwIjoxNzA4ODEzODM1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.2Apcul2belZtqcgEAuXq1BskvOSLsWgG5voMiuxmXsY', CAST(N'2024-02-25T19:15:35.083' AS DateTime), CAST(N'2024-02-24T19:30:35.083' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T19:15:35.083' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'36971771-044e-4546-a9a5-1109055ba4eb', N'7e01523f-1e44-41f4-9624-894196db6694', N'dWXTocBFRUU5fMuR73_5dAwkdVFQM4CQWIKOM3xqhl4', N'T3Wp-8eY0y8hK7utDRzXkRuKKUchT3vxHnHrGl9HyfE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzNjk3MTc3MS0wNDRlLTQ1NDYtYTlhNS0xMTA5MDU1YmE0ZWIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViRjJLZ2J3QWpVeXAyK0pDYi8xTEV5WTZLcHRoc09FaEVZclRZN2hrSURQM0hBZllIVGpGclBibmxONnA3cjVGSGErclh6OGFqcWMxRUNna0huRjZNZmFsd0IzVjVoK3I5UktPbFYzeFhJSlM1Ry9qOVVSRFJ2aXoxMWNjRnZZdy9IUzFjVERaNk5KeTlGOE50bWNvdU5Ec0xXbVZZR01NM1dtVmlkMzkvM01MaG52U2VnVmVLNG1PTm05czNxVitrbkI2SnJwbGVaNHdXOEFxTVcxb01FTjc3QkVIYmFnQlMyVzNHYzMzbk4wanVCWC9pd081bDZZdnV2WkoyZEZuOG85NTllclQ5TDN5OStuc2JyS2EzOD0iLCJuYmYiOjE3MDkxNDE1MTMsImV4cCI6MTcwOTIyNzkxMywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.dWXTocBFRUU5fMuR73_5dAwkdVFQM4CQWIKOM3xqhl4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ZTAxNTIzZi0xZTQ0LTQxZjQtOTYyNC04OTQxOTZkYjY2OTQiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0MTUxMywiZXhwIjoxNzA5MTQyNDEzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.T3Wp-8eY0y8hK7utDRzXkRuKKUchT3vxHnHrGl9HyfE', CAST(N'2024-02-29T14:31:53.443' AS DateTime), CAST(N'2024-02-28T14:46:53.443' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T14:31:53.457' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'3a6341b3-9933-4fc8-b88a-638b4425a657', N'6cadb7a8-4ba3-47b5-801f-c380e379e519', N'mcRAOkH0G5vg0B5NpKcaw47OiuZq_TBIRTNff8RGU04', N'oT5IrQGVZb2Vn_rkjOhEqP19-i0mprdaB6_9MdFMP3c', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzYTYzNDFiMy05OTMzLTRmYzgtYjg4YS02MzhiNDQyNWE2NTciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmT3ZoSnY2dWdieXh1THNRTDFiMlBzWlk1WkdrU3k0WmkxamllTnpOSnJlZmxpUXRTclZPV3NOV2g4dTQ5ZklBS2lKRHZiL3gyY0F4ci9uZ0xHZjNDZHdVdDNmK3ZTemYxUkZad3NXVzRzbnNQV0QzbXB5VkRKYmpobzJ1eEpkOG10NlJXRWIxZlRkWUJLdGtoK2s3cGR6OWRZOEwwdWVXcWUyNXlqRk5jWTNnSkRzaERwUkphYVBhOTZOVWExRGJDOVRyOGRSc3h6TEczZ3RJT1hROG9RSTVOK2p0Y3J6c25FWm5RTHYyZS9HcTdRL0EzRkFpODQ5VDFiazU3NmZveFhDdlJ1UFJYM0x4QTA1YStzNm9URT0iLCJuYmYiOjE3MDkwNzgwMjMsImV4cCI6MTcwOTE2NDQyMywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.mcRAOkH0G5vg0B5NpKcaw47OiuZq_TBIRTNff8RGU04', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2Y2FkYjdhOC00YmEzLTQ3YjUtODAxZi1jMzgwZTM3OWU1MTkiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3ODAyMywiZXhwIjoxNzA5MDc4OTIzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.oT5IrQGVZb2Vn_rkjOhEqP19-i0mprdaB6_9MdFMP3c', CAST(N'2024-02-28T20:53:43.103' AS DateTime), CAST(N'2024-02-27T21:08:43.103' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:53:43.110' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'45e22a47-6f32-48bc-b0bb-27ce071d7aba', N'2de49498-1b2f-4576-adb4-ab7025d62cbc', N'2dGXegNnoBUzm8WFFwaJansGclrc9PN5H-Un-VCnb-s', N'WvWjdRWBRr-2WRjp-ICU8HtT7q3mVFz96F4dmxeRkCc', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NWUyMmE0Ny02ZjMyLTQ4YmMtYjBiYi0yN2NlMDcxZDdhYmEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVjYStuUnpXb1EzU3kveEFndnFzRXc1SlpGa1B6b3lGb09qSTl0Qi9yclNsUlZpZGxrUWk0OWI5ejZDRmo4OFA2eFNJajZsUW9OWlUrVmMxbFNlVjBiY0kzTHhJTG9VRGlicXI1ZmFVaHhMdFMwS3V5Szd3N0RQb2J1a0ljbnk1VTNhem43eTJKYTgrM0xMUjF6eFUwNTdib0xzRml6Z28wSlY3OFJ2SGhING05V2pIZmF2S0dyNXVOZ3ZWbUFFS0lGYzZnM3ZUc1J3L3JPMzlVMmJpZ244SURKUE9uMTFqRGs1bnkvanFWSENvbTFFZUhMZ0dHQm4vZW9abVVEbTRkMElFeThqdFhFVTRrZVU1UW5VeWdCOD0iLCJuYmYiOjE3MDg4MjE1NDYsImV4cCI6MTcwODkwNzk0NiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.2dGXegNnoBUzm8WFFwaJansGclrc9PN5H-Un-VCnb-s', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyZGU0OTQ5OC0xYjJmLTQ1NzYtYWRiNC1hYjcwMjVkNjJjYmMiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgyMTU0NiwiZXhwIjoxNzA4ODIyNDQ2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.WvWjdRWBRr-2WRjp-ICU8HtT7q3mVFz96F4dmxeRkCc', CAST(N'2024-02-25T21:39:06.770' AS DateTime), CAST(N'2024-02-24T21:54:06.770' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T21:39:06.770' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'4983e147-f4ad-487b-9814-64e8bedeb0ed', N'003b7fd5-195c-4bca-9daa-2a2b57db1d7e', N'42C3rzGULPs5ywcYNJm7VPw-PEzmj5K2WYc6d2i3akw', N'SVOOWFdqIn7z3jmaf8SvPRmWIELQ5GqwnbqYD0v-Sfk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0OTgzZTE0Ny1mNGFkLTQ4N2ItOTgxNC02NGU4YmVkZWIwZWQiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViZzl1WWJQdndqYXJVcWJLQlFLZHpiL3hoOWc2bXZzd2RJWTc4TzU1WFI3ZkYrdU9UTGFrYm8yM3FzK2hWZjRNUTF3RURHRjlDQmVXaVBmNG9HMllqOHJjNTRnL2xxN21DS0xqeDkzTGROUCt1R05hZThOMjRuRklrRFBWVDBIR3VqcXQ1WGxqNHd4WVNtbGxGdkVISGlQSDJiQ3oyTXQ0TUt1V0dta0trM1BnUFhEZkpNZzg0c0tkdzRrRGk5emVTTVpYL2NlelpNVy80dDk2b0lmanh5SVZvbytVbzBTcUdrdGV2cmNyZXBYRTB3WVBXWmtoOWNPV2Z4NGlxVm9kTko4SlZNSHJyQ2FkbXNtcXBQUHNNTT0iLCJuYmYiOjE3MDkwNjAzODYsImV4cCI6MTcwOTE0Njc4NiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.42C3rzGULPs5ywcYNJm7VPw-PEzmj5K2WYc6d2i3akw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwMDNiN2ZkNS0xOTVjLTRiY2EtOWRhYS0yYTJiNTdkYjFkN2UiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA2MDM4NiwiZXhwIjoxNzA5MDYxMjg2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.SVOOWFdqIn7z3jmaf8SvPRmWIELQ5GqwnbqYD0v-Sfk', CAST(N'2024-02-28T15:59:46.527' AS DateTime), CAST(N'2024-02-27T16:14:46.527' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T15:59:46.530' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'4bae2536-5384-4814-b3af-32b22e247dd5', N'45d84329-5b2c-4ad6-9b28-b2fa2f8a6986', N'u3j0DfCH8_W95wPPX-zYy9cSycc1AzeEGDunYcs11lw', N'cbOVgUH69wVBElPbYyj0Sa8Fnjp8K4b7lMlzvwn7LNA', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0YmFlMjUzNi01Mzg0LTQ4MTQtYjNhZi0zMmIyMmUyNDdkZDUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYMEk3blZUZk94Mi9tcTc4WnVBZEtHTkZSdU1VaHBZODUzSFRTc0NEeHZJckJKTnI1OEVIaVNjRzA1WFFqVjYxMU4wbG5DOFFrQ0MrcFIyU1NZU1dkajJHUEJBZE1tYXFDeHNrdllNQVdickZIaUpBYzRGc0VxSHlFZUUySTR2aEczbEJkZGY5MlVqbkR0NGxMN2JJbFVSK2oyTXRVR2h5YjZXM3lvOUJSYWpYL1IwdnFnVXFrV2pKZFMxanZ0RGtsOTA3N0NJbW9EWjZ3TTN3WVRBMjh0QVlmREx1Q053RitJeWp6QnVacGxGbzZzbmpoSGRaMDVXRDNLRHpMOGo3aUVVK2Z3MGxNYWtORk9WSEpCbVJUTT0iLCJuYmYiOjE3MDkwNzU1MzAsImV4cCI6MTcwOTE2MTkzMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.u3j0DfCH8_W95wPPX-zYy9cSycc1AzeEGDunYcs11lw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NWQ4NDMyOS01YjJjLTRhZDYtOWIyOC1iMmZhMmY4YTY5ODYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NTUzMCwiZXhwIjoxNzA5MDc2NDMwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.cbOVgUH69wVBElPbYyj0Sa8Fnjp8K4b7lMlzvwn7LNA', CAST(N'2024-02-28T20:12:10.673' AS DateTime), CAST(N'2024-02-27T20:27:10.673' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:12:10.673' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'4be5e870-f46b-497d-bba3-49ff3427ca12', N'dba85a6a-1bcd-4f63-9684-3628ce52ab73', N'Py8eVFVvd_6-4HRgsMXHInzkLuHpJogxAVgOU0ml4r0', N'KvfYdS4aZ4QXcNPpQTnfa4e505W-Nhrk0Lw5NScmHJg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0YmU1ZTg3MC1mNDZiLTQ5N2QtYmJhMy00OWZmMzQyN2NhMTIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRTFVRakVGTkF4dEJvNmM5ZmpTQnJzekEzc0pyaVRDeUxseVRkcXU4L1hWRGtUVGFDdTBibVkzczE2V3pTTm5zY2l0KzN5NEp2ZXZCa0txR1R1b3lrZzBVRFRseHFQK0VUSXREQW16VWpvWDJDaVlkeXVSUFU0QjZNMmlCTG8xOUUyT2NxYUsrNVYwak9hRnk4MjlnQlJGS0xzclJwZGNnMEg0ZzdQdFZVYVNQUWNsUm1hOGhXTDQyd2gzeHk0eUIxQlFIZWlvbUNObHRIYStnNW1lUXJqZ1VqTGxHSDJuTnJ1OXk3VXZ2Z0RlQVpTU1RjWkwrUXFHQWxWUGw5cno0TnR3L2pTWSs1REFOcyt5dlcwS3FRST0iLCJuYmYiOjE3MDg4MTI5NTUsImV4cCI6MTcwODg5OTM1NSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Py8eVFVvd_6-4HRgsMXHInzkLuHpJogxAVgOU0ml4r0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkYmE4NWE2YS0xYmNkLTRmNjMtOTY4NC0zNjI4Y2U1MmFiNzMiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgxMjk1NSwiZXhwIjoxNzA4ODEzODU1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.KvfYdS4aZ4QXcNPpQTnfa4e505W-Nhrk0Lw5NScmHJg', CAST(N'2024-02-25T19:15:55.500' AS DateTime), CAST(N'2024-02-24T19:30:55.500' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T19:15:55.500' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'51a49b01-89d0-4c41-b8a6-30f147b7a8c5', N'60e1bca6-8370-43c7-bc44-24f69e275fe6', N'7T-xIhQ2P_dXXjj03ppV-P9zLKjX-B40ccZ1kmM-Zyc', N'ZxxyvvPpnB7Rm_U-n1ax6sZJu7cV-4dbiq_SStWg6f8', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1MWE0OWIwMS04OWQwLTRjNDEtYjhhNi0zMGYxNDdiN2E4YzUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVXZXg1cExPYk1xQ2ZIZk10VmJLUHo2UGU1MnRaN1NjTkxta1Q2MFpJZ1VtWmVicVdtb3RGMHdOaTJPQ1pUZlZvZW1wNUF4ZDZta2phZWprajJwZ2JOWTVwdXZ1SGJEUVBqdVA5OUhYeFhjSWREd2g3elRXRktBOXZEZzM0SGVCSWFEdkxJdVpuRW9zTTlZS09mcnZrZFVQR2RpaUQwUzNyUlFmUGY3TlVXb2ZabmYvN0tGUzZEdkZCM3JIU1lXSHB0SU9DQks5elVBdDhoYlU1U29RM2lSb2R2bEdLcEpMS3k3blNJb09qUmN4b0dJc3l5TUFLVFRRa3NaRXI4TWlSTUU1bU5Nd2p0WXZ6VFpPajBJNi8wVT0iLCJuYmYiOjE3MDg4MTY1MTgsImV4cCI6MTcwODkwMjkxOCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.7T-xIhQ2P_dXXjj03ppV-P9zLKjX-B40ccZ1kmM-Zyc', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MGUxYmNhNi04MzcwLTQzYzctYmM0NC0yNGY2OWUyNzVmZTYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgxNjUxOCwiZXhwIjoxNzA4ODE3NDE4LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.ZxxyvvPpnB7Rm_U-n1ax6sZJu7cV-4dbiq_SStWg6f8', CAST(N'2024-02-25T20:15:18.643' AS DateTime), CAST(N'2024-02-24T20:30:18.643' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T20:15:18.660' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'599f86e5-fd7c-4cbe-94f4-f430ab58523e', N'd0e868a7-7aac-4bfc-86f0-7e06b0c3b84f', N'fI1LeUB5-KhLV_UNy9qyZ1xbYuuSyc8ZiW6u2GakSVs', N'l_Dcs7kfBnps1AGXeq1SP6nR_Avh48lfhmirXoUlxuM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1OTlmODZlNS1mZDdjLTRjYmUtOTRmNC1mNDMwYWI1ODUyM2UiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVUbmI5Z0JCM0toYmY4bUt3T3Eyc29zUTNGV0wzQzJtcnVaSzNMUmhPY05kVGtBVkpCRjlMRjROM2ttNjE1YXQ5RlBtUE54MzVuTHhnSmNRWTRyY09EYk83NVBuR1dBU09RdUZYRjRVMGdBREFRNytzU1ZWMDl0QUlRUHhDa3lGbDdJRnBuNmJsZ0JSN1h3RzU1Q2E0cnpLdy9ObkFJcjVXRy9kK1Bzc0Fkb2hzUWJKeEt4OUxaRmpiZ0I1ejNaR1lIalY4NjV0NHFMeFdOdlJ6OVhhMzJiVWV2V2tMKzhwSGdETVU4TldIQWhPRmt0NS9yOGJJMzNQZGtncHgyV2tiTVdTS24vSUp1SGV5ditYRVJmWGpuOD0iLCJuYmYiOjE3MDg3Mjg1MTQsImV4cCI6MTcwODgxNDkxNCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.fI1LeUB5-KhLV_UNy9qyZ1xbYuuSyc8ZiW6u2GakSVs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkMGU4NjhhNy03YWFjLTRiZmMtODZmMC03ZTA2YjBjM2I4NGYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODUxNCwiZXhwIjoxNzA4NzI5NDE0LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.l_Dcs7kfBnps1AGXeq1SP6nR_Avh48lfhmirXoUlxuM', CAST(N'2024-02-24T19:48:34.573' AS DateTime), CAST(N'2024-02-23T20:03:34.573' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:48:34.573' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'5d4565de-0a2b-46d2-842e-0d8ae6476d32', N'73739b4b-9e9d-4c6f-8a7b-4ee12e0281bc', N'8svlR6KRIWfuv50Ta3TVkzH6PGRYEi8DRUOh1Ps95to', N'5MdYyaNqLnl-EJzkfMxKHHfUNInnGXWI_t5hyH0IMNo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1ZDQ1NjVkZS0wYTJiLTQ2ZDItODQyZS0wZDhhZTY0NzZkMzIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVRlhKSzJ1Q2ZmaXN1Skh5eG53Sm9MS1lCWEZqMkxrUDJveGdWU0I2dVpiWElwL2hQem81NVZ6SHQwOXhRQjZoNjNTRkVtaS9iVlVDVjFwckVpR2NrR0xXdXNtMFpPbEVTQWg2eWY5T014UUhwYTV2aGU4bDBhaXdqZ21FMDJ5K28zM2RaYUd4UUpRSGJNWUhHVHJad0hmM3Urek5hbWM5NDBJNUx5K2dPRWhkeEpjQm9kWEhsZ215TXJuQzhBOEtGNUNyYlJvWUlWV2xuY1RWZ2VzSndUWWMyZUpwL0Z4dHlnNHhhVnIwT29objZFNTUrVDQ2NFltMTloQW5VYklGbm1TcnFhL0l6T3hoWWtVMUpGVDl2VT0iLCJuYmYiOjE3MDg3MjQyOTEsImV4cCI6MTcwODgxMDY5MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.8svlR6KRIWfuv50Ta3TVkzH6PGRYEi8DRUOh1Ps95to', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3MzczOWI0Yi05ZTlkLTRjNmYtOGE3Yi00ZWUxMmUwMjgxYmMiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNDI5MSwiZXhwIjoxNzA4NzI1MTkxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.5MdYyaNqLnl-EJzkfMxKHHfUNInnGXWI_t5hyH0IMNo', CAST(N'2024-02-24T18:38:11.627' AS DateTime), CAST(N'2024-02-23T18:53:11.627' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T18:38:11.630' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'5f186aba-94a1-4f7e-84f6-e53caba90e75', N'e87948ae-399e-4784-9bd2-d21f093234ea', N'TqnejqwP44GFIppk7vx4meFTiyDzvSIymdbAdJu26Yo', N'IOwoc5KnlHL4wOrrcP7lyNrpOrYoqW4ArDGKKpLOyjo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1ZjE4NmFiYS05NGExLTRmN2UtODRmNi1lNTNjYWJhOTBlNzUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVhUyt4SzMrMjh2cHR5SGVFYVRsZkhCYUluMHZrQkVvYnZtQjZjdjdHUnVrMnJrQXJ1VEhOYnBDR3l4UFZwa1RYMk5wVWFUaGFwdHlzZGkvQ0FQRW4xN242M0RVS2h1WCtaRXR6M3pqcmRWcjVudm1ORWlxSkt3TXVmdDlwWTFWQmRueVdGL29qYTlmWkhITUkwRkxQYzlndUNpMzdJV21uOU9MTitLeGk3dVlVd2gxUE1hak4ybXdxbjYzNTBkNmxRZzVmcmQyVnhzWldJWkFDZjlsdWVKb2dKUG03QVpGTERIblI5RHlnWm1sU05FYnp6cjdvZVh5VlJ3U1dqb3FQYlpaOHYzd3pUSG9janorZStyVDdDcz0iLCJuYmYiOjE3MDkxNDQ0MDAsImV4cCI6MTcwOTIzMDgwMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.TqnejqwP44GFIppk7vx4meFTiyDzvSIymdbAdJu26Yo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlODc5NDhhZS0zOTllLTQ3ODQtOWJkMi1kMjFmMDkzMjM0ZWEiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0NDQwMCwiZXhwIjoxNzA5MTQ1MzAwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.IOwoc5KnlHL4wOrrcP7lyNrpOrYoqW4ArDGKKpLOyjo', CAST(N'2024-02-29T15:20:00.873' AS DateTime), CAST(N'2024-02-28T15:35:00.873' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T15:20:00.877' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'62ba5614-d46a-4baa-9033-4f06d1ad92b7', N'f38e471d-e63c-4adf-9efc-88c0fdfc9822', N'3ArEzTALbRC90ebSwcszzfKDZoUhpc7o-bc5C5hzzww', N'ba0UnmAGm1OaaikGjVyZeZVqLdQ2N9A_ENfQEyl0yVQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MmJhNTYxNC1kNDZhLTRiYWEtOTAzMy00ZjA2ZDFhZDkyYjciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVjN3VVVnplUUdpSEQwMXlCTElUQkt5SDY0TjczU3hheUdYQjVVeDVaNlNtS3lmQmFxQXMvUU9uSDRuaVltT1hsQUJZYWlLY2x2dllBTFY5Y0VSNExQR2p6OUNacGhndUg2cE9Qd3B0VXpxemZCNXZDM3c2d0FMMWo2aW9mNW5DMXdBZXdNTkpaUGFyeUdZUktBKzBPeXNaM0N3d285S1JNRVRLam10dWRYbXRpWWVKaUMvc3IvMk1FV0NsNy8rM1ZOVFJuMFBKZjdKdjV2MUp5K2V5RzB6Mjg3RmhCUzN6blMxN0U2V2haMDNnZTlkY0hTQitNNkpqRnd5Q2hGdGpZQk5iaVpBVE81aE9TaWdSVTRNZ1hkZz0iLCJuYmYiOjE3MDg4Nzg4MjMsImV4cCI6MTcwODk2NTIyMywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.3ArEzTALbRC90ebSwcszzfKDZoUhpc7o-bc5C5hzzww', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmMzhlNDcxZC1lNjNjLTRhZGYtOWVmYy04OGMwZmRmYzk4MjIiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODg3ODgyMywiZXhwIjoxNzA4ODc5NzIzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.ba0UnmAGm1OaaikGjVyZeZVqLdQ2N9A_ENfQEyl0yVQ', CAST(N'2024-02-26T13:33:43.270' AS DateTime), CAST(N'2024-02-25T13:48:43.270' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-25T13:33:43.273' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'63756cae-d7f9-49de-a2e2-f39a6940ba43', N'1f6ace6e-fc0d-4c44-82ca-f1688f0eddf3', N'2r52Q4b_CmLJMOlOPll8FnqkLTy6vveyoEfzl5QNUkE', N'FbPQPbK6zYsXI7mXJ0yo7Csck-RcFGV2nCGmnEkY8rM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2Mzc1NmNhZS1kN2Y5LTQ5ZGUtYTJlMi1mMzlhNjk0MGJhNDMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVZcVFOVTI0Sm01b3FiWWJNcnJvemg2ZG5YTytONGtKUzJhMzcwMEdvSnpnSEhkaXJ5dUkyY1dqd045SE1XbjkxV3JMRnFoRFBpYitNK3hBYTNzWnZaTzQ2SXVWallmbVJ2NkxBM3lKZVdjTzNrUEtQQUFtcFo2WWUwSXZFb2E1ZUVmTGh3SHkzUGNDTnZ4ZGVaVEhzT1pMdkZKem1nL2tZU1Vtd29TemJncDdIaUtWVkpzaWFhRDYzNE41dE5Sbks1NWNndEljZGlyM2pJajM0YkRzbGo2N1YvN05KcUg4eW1BSklaV1NkL1VkOFdubkJvbXc5bGtpdmFCV2lGajZDNEZQaFdCbm80ckQ5bjNVRHp4bmlzYz0iLCJuYmYiOjE3MDkxNDMxMDcsImV4cCI6MTcwOTIyOTUwNywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.2r52Q4b_CmLJMOlOPll8FnqkLTy6vveyoEfzl5QNUkE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxZjZhY2U2ZS1mYzBkLTRjNDQtODJjYS1mMTY4OGYwZWRkZjMiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0MzEwNywiZXhwIjoxNzA5MTQ0MDA3LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.FbPQPbK6zYsXI7mXJ0yo7Csck-RcFGV2nCGmnEkY8rM', CAST(N'2024-02-29T14:58:27.127' AS DateTime), CAST(N'2024-02-28T15:13:27.127' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T14:58:27.133' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'6ae7a5ae-151a-4bdd-888f-1585beb811c6', N'f3fe491b-53da-4659-98d0-1ba9a8a2584e', N'vLuh45fej4AZumXCDeh3Cv8LT95qGbkIlmpZKCSTQuU', N'7POcH9zbM_Tl8TWxzCR_museIrL1iQbGVU9dftpHZFY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2YWU3YTVhZS0xNTFhLTRiZGQtODg4Zi0xNTg1YmViODExYzYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYZjRDV0ZyVkJNcGd5cjU5ako5SWxmeGdUTlZHS25DamhQRGVnWXZ4Qjl2eGZ6U2RiYWM2eGYva2hxRVhBVjVjUGYvYTZSaDI2UENmbjg5R2tmcjlyZCszb1laNW1ubys3bVZRc1p0YWd3MXhrZ3RwQmJBU01oMFR6S1dYODNpeFRBUDZ3dHVpT3QzV0ZwVDRMYTNuS3Rkb1hLYlc4L3JnMEhMbjJlaHBBWWpMKzVsQ2dLZDJyTHVkOXNhcWJjanVaVStaWFFpV0RoVXNGUW1rQ0pNYngwK1g0M3BqMkMzNzkrc0d1VkNQVC9JVzJEYVp0TzZGTUR3Z0Nia3o5Z0p2cWxJc3hMQ2Ewd1VJUlc4cTZtbHhEQT0iLCJuYmYiOjE3MDk2ODMyOTIsImV4cCI6MTcwOTc2OTY5MiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.vLuh45fej4AZumXCDeh3Cv8LT95qGbkIlmpZKCSTQuU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmM2ZlNDkxYi01M2RhLTQ2NTktOThkMC0xYmE5YThhMjU4NGUiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTY4MzI5MiwiZXhwIjoxNzA5Njg0MTkyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.7POcH9zbM_Tl8TWxzCR_museIrL1iQbGVU9dftpHZFY', CAST(N'2024-03-06T21:01:32.147' AS DateTime), CAST(N'2024-03-05T21:16:32.147' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-05T21:01:32.147' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'6d315bfb-1447-418d-934a-bb3f9aab988f', N'ca9e3280-5884-4910-b79a-23dc6a63b549', N'iazOLO_PhaNGXlmoT_pVsK7EIsthzKzg9sudAYtnEtI', N'uQYms62Gs8D22JCj6Yp8r301bqtAp4hld1GvK7ASAGw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2ZDMxNWJmYi0xNDQ3LTQxOGQtOTM0YS1iYjNmOWFhYjk4OGYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVbTU5NVd4a1lOZzVMNitVN1REYjJMSjZaTGs5NldIWlRyTG9oY0tKL3FXYmVDRFB6R250d0NnUmxmcEdMRGNPaEliOHlsODRleE0rM21oeHFjaHFKcDlQNFJsVi9kL1A2NEZJaGxOUkg3dGVXKzBsbUo3RXJvaC96ME0vQ2hCbTgxc2ZwdFF0cnY3azArTWQ1WkVDdzBhcVRsZDcrY3Y4MGtmcjlaSFBHUWZsK2Q0MDZKSDhWYy9LZGdlMFlDZVQvK2s0MkZGT1ZFUVJVZ3kwSU5jcnl0VXZFVHM4SnNLcEpOdmpFZkZybnM3S01HcTNPZlhDWXR1TnZqb0ZOejlJS0ZmSTFSVmlBZXk3T3cyUVIxWjVNRT0iLCJuYmYiOjE3MDg5ODI5MjMsImV4cCI6MTcwOTA2OTMyMywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.iazOLO_PhaNGXlmoT_pVsK7EIsthzKzg9sudAYtnEtI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjYTllMzI4MC01ODg0LTQ5MTAtYjc5YS0yM2RjNmE2M2I1NDkiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODk4MjkyMywiZXhwIjoxNzA4OTgzODIzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.uQYms62Gs8D22JCj6Yp8r301bqtAp4hld1GvK7ASAGw', CAST(N'2024-02-27T18:28:43.447' AS DateTime), CAST(N'2024-02-26T18:43:43.447' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-26T18:28:43.443' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'6eef6f50-82b8-48dc-9563-891feadbc88c', N'cdbc6572-1ecd-49eb-b00f-0272a8fcf61d', N'_JwW7BxguTXaFNF_BqrcYSDtWc1ZxNQU4cUHiRYrEsk', N'1EV-5f8IVROiHACs8ywut8SA9Ox0Sif_hrBP4gy-AHs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2ZWVmNmY1MC04MmI4LTQ4ZGMtOTU2My04OTFmZWFkYmM4OGMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRZ0hMTjdsUFE4U2VUa0dxZFRoSFMzWVpBSS9kdmN2VFBkWVlGK0E3L2tqcUlNOCtxNFJtdDBrNGJCVEJGVjM3eGx3LzRUU1dLQTFOTlplaTM0UCtGRTk5Q0JTZkI4TUg1SmdvcFZCbmhCRXBPekczVDhPWU4zRlNtdUhMYzRkWmNJaUdnQldDaWxZNXZiM0F2N1kwb0RyNERSV0lHejFnN1BzVlp2ZEk3VW1Qc2lBc3EwUGFMNUNOMXNqcW9FdisxUDc4YUZSbCtHbGw0c0d4RTlxbU1XOE8xbHJvYXZzK1dEWkpHMUlFY3I2RWlORkNORUpnOXd5SkNkdEMzelo0L1hiMTVKWXR5S0Z3b3RxaXNiak9MZz0iLCJuYmYiOjE3MDg4MTA3NTQsImV4cCI6MTcwODg5NzE1NCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0._JwW7BxguTXaFNF_BqrcYSDtWc1ZxNQU4cUHiRYrEsk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjZGJjNjU3Mi0xZWNkLTQ5ZWItYjAwZi0wMjcyYThmY2Y2MWQiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgxMDc1NCwiZXhwIjoxNzA4ODExNjU0LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.1EV-5f8IVROiHACs8ywut8SA9Ox0Sif_hrBP4gy-AHs', CAST(N'2024-02-25T18:39:14.613' AS DateTime), CAST(N'2024-02-24T18:54:14.613' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T18:39:14.620' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'72bb8c2e-6d35-4c56-9493-29fc43915631', N'97421416-3e32-4156-ae2b-e5f721bdbfc2', N'2pYSNneLRi0HmT8BdB4pPeZbo0NBFpFic6tNdql_sjY', N'fj4KtI1sgEWLfJocaBYjw5RTqntfdx92zoxXW2rHCC0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3MmJiOGMyZS02ZDM1LTRjNTYtOTQ5My0yOWZjNDM5MTU2MzEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVSR09TQnZiU2VVRUpvT1p0alZzWmVNYlJwb3BjRzFGZE9Ia0tXYUxSVFlkSmdEWEY2NjJnYW1MeGxPU3N4dHN1MlZ2dVVZWCsyR3VMZkZuN3ZpRHc3WmFva094TmZIS1Y5ay96OEcvSWVhNSt2bGoycDczd1lwQTBSR0V4Z2djRGpiOEdUWVdXZWtzckU0empiVDhSRnA1bjJUZGV2MEN1UHpLOGYySUQ5RDViaHlLbmtETjR0RHZOSWlrVVRHVnlEOVhmY0VibTdTTGE1Z2dlR1hNQW85dVRyMFFNaFRiOW5ubzdWdk82NElKcWJtT0g3Qld4NmJYWVN4V0dObXJkSXVyd0JQZFZqMXJURTdhbWRHZW1OYz0iLCJuYmYiOjE3MTAwMTc1MzcsImV4cCI6MTcxMDEwMzkzNywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.2pYSNneLRi0HmT8BdB4pPeZbo0NBFpFic6tNdql_sjY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5NzQyMTQxNi0zZTMyLTQxNTYtYWUyYi1lNWY3MjFiZGJmYzIiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDAxNzUzNywiZXhwIjoxNzEwMDE4NDM3LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.fj4KtI1sgEWLfJocaBYjw5RTqntfdx92zoxXW2rHCC0', CAST(N'2024-03-10T17:52:17.430' AS DateTime), CAST(N'2024-03-09T18:07:17.430' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-09T17:52:17.427' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7b64898b-5d43-47e0-a036-1d544b0bce09', N'3dd7fa7d-ba51-462c-a5e0-0e86663342f2', N'QxuC_uoB5q6ro7DVXkHRbNB4aMa9jzJ2ftKlkN5JALo', N'xqpIJBCud0PJD7CAi_mZql21Nwjflv9MXGYC28WFOIw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3YjY0ODk4Yi01ZDQzLTQ3ZTAtYTAzNi0xZDU0NGIwYmNlMDkiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVjVDZZbDhWVWJLUjEwTWNaSjRWZXRIa2s5VzROQlJNY292cTdxT3BlNVVYSDY1MnhCSHAyK0dTUFlaSkRod21GNkE2eGFkTHcwM0Y0NE1SRm1TQTE1dCtJK284MmVYWDBuK3M3enhCdTBKOWJCcXljZXFJOEp0RVZ3K2V6NnZUTzl0cFZRYnQrRDh2WllJUVN5RDVYbGJTQUV5dngweWdhLzNxbGI5RWYyblloVmFDSUxEdG0vZFNzTjY0cDA4TE5aV1BSUVRaVzNPQTJVUnF4OGJoMUI1U1hGc2h3WHI4NFIwbUovY3YxQUdUeDFmOWN4THpzZmVxM1dhUUlPUmtBaWxWcFZ4ckJoN0pmRTZ4a0FRMEhkYz0iLCJuYmYiOjE3MDkxNjYwNTgsImV4cCI6MTcwOTI1MjQ1OCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.QxuC_uoB5q6ro7DVXkHRbNB4aMa9jzJ2ftKlkN5JALo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzZGQ3ZmE3ZC1iYTUxLTQ2MmMtYTVlMC0wZTg2NjYzMzQyZjIiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE2NjA1OCwiZXhwIjoxNzA5MTY2OTU4LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.xqpIJBCud0PJD7CAi_mZql21Nwjflv9MXGYC28WFOIw', CAST(N'2024-02-29T21:20:58.787' AS DateTime), CAST(N'2024-02-28T21:35:58.787' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T21:20:58.790' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7b7930b2-510d-4664-be7f-697d78d33000', N'fd95551c-7110-44c7-a963-ad90ee26aa1e', N'1lSL7b9nx4ujzHZte3B5iIHJnUANSUHzn0QgmCjNabM', N'_QYbJN0ASndDN-NeaNvLxsCbFE5laadFZvPJkPjuRg4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3Yjc5MzBiMi01MTBkLTQ2NjQtYmU3Zi02OTdkNzhkMzMwMDAiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVSaTZLcDdtU09QenFzb3dIbEJJZmIvMU5WYnY0RFppaDNONTBDd0xteU9TVE4vT3p3Wi9DWEZyUzZmbGJxcHNVSFFKazREUWpwTzdncWZUZStXSlJGbm1DK2xmdEFybEM3aklieGQ2b05qcklMUHNWbGRuSDlRcGZlRDVNV2N3WC9kQkl1OEhUdFU2SzdjWHV0UVc3d1hZQXh6RjZIVkdzUENtS3NsL1BwNXk1YWFOYm9PaDVZdlAzSDVSeUJNUTZkMDVoSkVXb2F1UndocVIzaHREZnpvcWxEMFpQZEJoY2szS3pTbjhxaHB1cXkzVFdUaWpnMGRxaTViQWF2L2tZdk1RZmhwM1lXeWQvcXVadU4xUGp6ST0iLCJuYmYiOjE3MDg5ODMwMDUsImV4cCI6MTcwOTA2OTQwNSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.1lSL7b9nx4ujzHZte3B5iIHJnUANSUHzn0QgmCjNabM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmZDk1NTUxYy03MTEwLTQ0YzctYTk2My1hZDkwZWUyNmFhMWUiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODk4MzAwNSwiZXhwIjoxNzA4OTgzOTA1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0._QYbJN0ASndDN-NeaNvLxsCbFE5laadFZvPJkPjuRg4', CAST(N'2024-02-27T18:30:05.600' AS DateTime), CAST(N'2024-02-26T18:45:05.600' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-26T18:30:05.600' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7e189f7c-0afb-4e8b-93d7-c25857d30eac', N'd571047a-d524-4604-8603-8f7a3513a360', N'gnas_SAbCtlHFFZ-ZPT3mWSeMMpi2jkj_Y-oSHDLBo0', N'XKmoIX_V_3JzDqypUx5R8FzVRSeDpNbZSzDzEH6zA5k', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ZTE4OWY3Yy0wYWZiLTRlOGItOTNkNy1jMjU4NTdkMzBlYWMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYZTlFQi9sbXRwSU5JTDJoSzRlSWFUVFVtN21yRU5FcGZpc0RrcjdFRXRaKytuang2eXVscURqWW5GeDZjTDNYTlpVaGtwNk92NUc5UGNRWnhFSEt4eGpMN3lwazFWSkIxVzNLUVY0dE4rdmlKRE5BeUdyN043TWIyTTV4d1FucFBNMmRlQWhnNzBJaHVXSVRtOTJTTm5aZ0orUmtMSXJOdEUzR0lKWVNQRGZiZzRVVlR0dWs2bnNDQ0s5OVp1Ykt0R3lzdHRVRWRNZUgwQUFVcmRLSEVrNUpTN0J0SUdROUlEKzlVelFTRWtVVTdnd0pmcmNTWlltTzN5aWd5VzNXVTdaZTVXMk1LYm1hcENXc0t0SW5UZz0iLCJuYmYiOjE3MDg3Mjc0NjUsImV4cCI6MTcwODgxMzg2NSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.gnas_SAbCtlHFFZ-ZPT3mWSeMMpi2jkj_Y-oSHDLBo0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkNTcxMDQ3YS1kNTI0LTQ2MDQtODYwMy04ZjdhMzUxM2EzNjAiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNzQ2NSwiZXhwIjoxNzA4NzI4MzY1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.XKmoIX_V_3JzDqypUx5R8FzVRSeDpNbZSzDzEH6zA5k', CAST(N'2024-02-24T19:31:05.053' AS DateTime), CAST(N'2024-02-23T19:46:05.053' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:31:05.057' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7e935d6d-e5d4-4978-b1f2-7c04c9c0e265', N'f345cf8f-f483-4716-8596-0fb8e68a3cb4', N'go8Y3ZaQOBpfl7lVefCZQoLT7p35JsuujBpdVrUrET4', N'5SPUkgKwoQ8sF5tMuvXKpDILZvc4wfIwfvL3ZmS4abQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ZTkzNWQ2ZC1lNWQ0LTQ5NzgtYjFmMi03YzA0YzljMGUyNjUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVlL3JoeER2aW5XQk93aitldW56THozRnV6NkZwNFk5dU13aFF2U2Fad0RzSGNERGJLN21BbDcwam1XK0hVTFUzdHdCSHBrTW5TOXd4Mi95blNlZWxPaStvRHdZVTdOMm5xTGFQNHpWM3l4YXgrUWw2NGJPR3A3Mk5Mb3dmcjdzQlJjVjcyYVRuVFRscGpzNUtOQ3ZBOGdUOTdhdXppR0dQQTBKWlVyU0FqalQ4TnRSZmVWZnQrQ0R6cWpSaitrL2hhdC95cklrRlQvTTFuN3EydHJTVm02TEY4R0NVc2UxYmFFU21CYUIweHZVaENJNG1VR0ZvWlpQVGN3bzduemJBVUpTa2Jnd1I0dzE2b2dIN2RoSFhaVmdTYTZkdXZ6MUpFN0t3KzZjakhObSIsIm5iZiI6MTcwODcyODY5NiwiZXhwIjoxNzA4ODE1MDk2LCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.go8Y3ZaQOBpfl7lVefCZQoLT7p35JsuujBpdVrUrET4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmMzQ1Y2Y4Zi1mNDgzLTQ3MTYtODU5Ni0wZmI4ZTY4YTNjYjQiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODY5NiwiZXhwIjoxNzA4NzI5NTk2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.5SPUkgKwoQ8sF5tMuvXKpDILZvc4wfIwfvL3ZmS4abQ', CAST(N'2024-02-24T19:51:36.733' AS DateTime), CAST(N'2024-02-23T20:06:36.733' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0', CAST(N'2024-02-23T19:51:36.753' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7f997626-38ff-4e93-b9de-e2a64b0d6426', N'b64660c9-6c31-476b-a94d-b336a09d4b18', N'KG0v5VPtXfCOgZZF52m6_ffiMGVpZCbhVJng8SB-voI', N'gaVnjrk6TlW4Fowy5AO7Q8jviHAsK4MZ89RA6xUXSAY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3Zjk5NzYyNi0zOGZmLTRlOTMtYjlkZS1lMmE2NGIwZDY0MjYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRcjJVZjdoRmYwc05RNzhZNmpBeksrR3FuMWp3ZXhlT09KU1ZUWXR3Rkg5aFh6N3p1RjZtc2lqL094OFJxem04WGQzZHVySy92R0pVMUZOTGZITmVaQXp3bC9rdjdtckY1WFArTEFMVWlSM3M2ZmpaNFcxbGo4bW5zbkJueHV4Ti9LajNBRmM0UVo4NzlCYWNocmxPUEEyTDkzcG9LNjFybUVtd2huOGFvNG9zME4vZEJlU1E5REN1dFdrTkVtdFZDU0lRU1EvTExKcnduV0FFdzJsZTd2S2M4NkQ1NnppbGYzMjgzWk9CQ3lHdTY4Ukc4TDVzZjlUMnVTSXE1OGFqUTVvUWdGNzRkTlI0dHk5akVpdkNyMD0iLCJuYmYiOjE3MDg3MjU4MDYsImV4cCI6MTcwODgxMjIwNiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.KG0v5VPtXfCOgZZF52m6_ffiMGVpZCbhVJng8SB-voI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiNjQ2NjBjOS02YzMxLTQ3NmItYTk0ZC1iMzM2YTA5ZDRiMTgiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNTgwNiwiZXhwIjoxNzA4NzI2NzA2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.gaVnjrk6TlW4Fowy5AO7Q8jviHAsK4MZ89RA6xUXSAY', CAST(N'2024-02-24T19:03:26.717' AS DateTime), CAST(N'2024-02-23T19:18:26.717' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:03:26.720' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'8cbb4530-eadd-4005-bd2b-410531b10044', N'de273ed8-5a9a-4ae5-ae4f-c3a1151b6c3d', N'kFZzEnC3mM3tn3A9kVO__yxvS5pfY866bnWN-LjCsHM', N'Bjw5J64aUu_RXM59niTPFVNWxdb0CuP6BSvadoj7rbs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4Y2JiNDUzMC1lYWRkLTQwMDUtYmQyYi00MTA1MzFiMTAwNDQiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVlZ0FJL1YyQ2RxVUl2ejk1emhvaS8xd1VCM0xRUWtpZEdXTERVV2dkZlF1d1kyeTc5dlpRTy9sN0ZiRnlCSFE4dFM1ZWhnQ3pwWWtkWWVQT3hCK0JkSGlkb0Y4TXp4QVVReUFqZWhTczdianlYbFRoTG56NkpkSm0zYXMrcVJ5anpyMzBaSkRsMzhKc0FoMGdVUG83bWE3WG5aY3dLdUVOanc0QzVOemtuSHlKYjk1M3JSVlR1Yys4Q0lDSGFzMVExSURmVnAyd2JNVFpuRHhxTldhNUpHc1hiNmhtcFBrcmc5cklVR3R3U2lTMjd4cURUdTcxUlpBTU1aL3ExcEhwdVhQaEhTTXNXYko4VjdVRU5RZldTZz0iLCJuYmYiOjE3MDkwNzQyMjYsImV4cCI6MTcwOTE2MDYyNiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.kFZzEnC3mM3tn3A9kVO__yxvS5pfY866bnWN-LjCsHM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZTI3M2VkOC01YTlhLTRhZTUtYWU0Zi1jM2ExMTUxYjZjM2QiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NDIyNiwiZXhwIjoxNzA5MDc1MTI2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.Bjw5J64aUu_RXM59niTPFVNWxdb0CuP6BSvadoj7rbs', CAST(N'2024-02-28T19:50:26.423' AS DateTime), CAST(N'2024-02-27T20:05:26.423' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T19:50:26.420' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'8f2058db-8e4e-4fc2-8f7b-a8004cb84cfc', N'a66c72a3-fadf-4504-a7bb-957d34cb0c1c', N'_svh0A04o8KRCU8T6K4S3tXxt8eJfM9wGkM1DwKN0mw', N'm50RygYx-pCNkCivRJXjPjeD5bCGKPV3uF_ugMgiih4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4ZjIwNThkYi04ZTRlLTRmYzItOGY3Yi1hODAwNGNiODRjZmMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViSzVsY0R2cXlsQmRrTWZjQ1p4V2lKRm53ZXhkdkJZK2hLSlBwdmN2MmJJSCtONHkvRmdmR291REFzRlJnWXFLOVFZbDZLQUZ6R20wcVRYSkRKNVNyVmdlbFJuM09Sd1dHa1ZXNWQvT2JkYkw1azBLb3hsYk43WmpqcUhIM3phL1orTDNLWnZ0REF5R0xHSWRqa3FjaEVaOXJ5Q2l0Zlc4eWFJQ0YvVzZ3azNkb1JWZ2Vyb250Q1g2UHZUQnE5MXVOKzVLakhiS3RPbGVDWGpkRTFUTkhTdFJXTVd1U3VZczQ2Rll3cUZRc2p2MkRWaE1Bb0xlbERSMVc4Sk1qcHlpaTBCcG9FbjBwYnJoaUVtMm1KaEtwMD0iLCJuYmYiOjE3MDkxNDM1NjMsImV4cCI6MTcwOTIyOTk2MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0._svh0A04o8KRCU8T6K4S3tXxt8eJfM9wGkM1DwKN0mw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhNjZjNzJhMy1mYWRmLTQ1MDQtYTdiYi05NTdkMzRjYjBjMWMiLCJDb250YWN0SWQiOiI2IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0MzU2MywiZXhwIjoxNzA5MTQ0NDYzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.m50RygYx-pCNkCivRJXjPjeD5bCGKPV3uF_ugMgiih4', CAST(N'2024-02-29T15:06:03.873' AS DateTime), CAST(N'2024-02-28T15:21:03.873' AS DateTime), N'[{"Key":"ContactId","Value":"6"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T15:06:03.880' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'91adf169-ef13-4303-bd5c-938b6eaa1728', N'e51ce532-ad73-445a-a26f-2b8986996aea', N'hRfjDNhxd3B99AnsWJtL2xh1JKpymLzUPBAbrFrS3Nw', N'98wJIMWBr0d7G0R4EhfbyvQar97g53iCW28rGGVybLE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5MWFkZjE2OS1lZjEzLTQzMDMtYmQ1Yy05MzhiNmVhYTE3MjgiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVL2lxdHNRZkRESmJ6ayt0aFR4b3ZaZjV0cjlYTGZUdnJPTnk4WHBCRVkvS1I5QUhYaGZRanhUNGVqbjRaZGo5QWlkSnlndHZvbkFpUzIyZ1NUUHQ5QWF4cXY4MjNwa0xKTkxwRCtobVo1WHgwN09pME1DVVJCWUh4UU9MZGI5clVEK0hVMHZaeVBWQ1FGeTZkWFFBS0grOUpLYTBYNWlvYmxzVDZBcVNCeG5yVm41U0w3ZjBNQ01CTWhabFVOeG56cmhGL3NzZnYyT0NsUXNaVElZVmcvNDdOQlNVZUNHUDRvVlJtQVlPYVZERXZDd0l0VnpZTlh1NHc5bjFEVFJtWDFxMjlMRExMK1JrUVZ0ZG0xbHRwVUhVWk5GMG90MHIwRWhsbnN2TlRjcCIsIm5iZiI6MTcwODU2NDExMiwiZXhwIjoxNzA4NjUwNTEyLCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.hRfjDNhxd3B99AnsWJtL2xh1JKpymLzUPBAbrFrS3Nw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTFjZTUzMi1hZDczLTQ0NWEtYTI2Zi0yYjg5ODY5OTZhZWEiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODU2NDExMiwiZXhwIjoxNzA4NTY1MDEyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.98wJIMWBr0d7G0R4EhfbyvQar97g53iCW28rGGVybLE', CAST(N'2024-02-22T22:08:32.517' AS DateTime), CAST(N'2024-02-21T22:23:32.517' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0', CAST(N'2024-02-21T22:08:32.517' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'967422fa-6d2c-41f4-9be1-550a5816c733', N'd082205b-9dc2-48fb-861c-7db45217008c', N'S0-LDuUywADcAC-zne6mMKNPtFbe1xaGPB-un4fd6OY', N'yZAXAEKOS_faXVM-VWNELukptN3UItCNBoVNJyOhVTQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5Njc0MjJmYS02ZDJjLTQxZjQtOWJlMS01NTBhNTgxNmM3MzMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVXM1Z2L0NBb0dKT09JWWc0MXoyUXBlTDB5OTBmNEUzNzV2anZHTlZiU1kzcFg1UnpNVlF5azJ0Mks3eXVZRmRKSFhWYVV3Tm45V25SUnZOUS9Ma2xPSUFwOURLRkxReUQrYi80Tk4wenRKT1phZ3ZTbkhtNVh3S3pVdmVpQVFGMFR2WVRBK2Y5TXhIMmc4dW9jREZTYmpJTHdjS1pDSHYzc2RrUWNQdVh4QmlZenJUOGJ5amF0Tk04VURhSXR1VmJEL2NaUlJLTHBvOUkyS3M1czBld1N3V2JIN3NEWWdpVGNuOU5qWGFJSmhKUkJNUldWV1NyN1hoa1BnYTkvR0dOOHQ0eEs0eHQ3bnErK3lZWUU5TDRaOD0iLCJuYmYiOjE3MDkwNzY1NDMsImV4cCI6MTcwOTE2Mjk0MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.S0-LDuUywADcAC-zne6mMKNPtFbe1xaGPB-un4fd6OY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkMDgyMjA1Yi05ZGMyLTQ4ZmItODYxYy03ZGI0NTIxNzAwOGMiLCJDb250YWN0SWQiOiIxMCIsIlN0YXR1cyI6IlN1Y2Nlc3MiLCJuYmYiOjE3MDkwNzY1NDMsImV4cCI6MTcwOTA3NzQ0MywiaXNzIjoiUGFySW1wYXIiLCJhdWQiOiJQYXJJbXBhciJ9.yZAXAEKOS_faXVM-VWNELukptN3UItCNBoVNJyOhVTQ', CAST(N'2024-02-28T20:29:03.803' AS DateTime), CAST(N'2024-02-27T20:44:03.803' AS DateTime), N'[{"Key":"ContactId","Value":"10"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:29:03.797' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'9a4c514a-de4f-4e5b-a209-dfc5c5ee06dc', N'91ab189c-d954-4471-a395-aecfd13d81ca', N'QdIOt0h8n3xZ8j-whsGyrSMn6vFnaOX_N1hQYJMsacs', N'9oT1oj4QmvuQz-xJLC9goSn7pL_-chdEAJRJpNgPnoE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5YTRjNTE0YS1kZTRmLTRlNWItYTIwOS1kZmM1YzVlZTA2ZGMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVhOUFiKzlrQ3dGRnpiRjFnaGxtSW96RURmcktaY1dqdUJ1dDVSUGNzRHFrZUY1UEcyRUNsTk4yM2hsOGMvT2lEN0I5NDYyQW1PUHN4VFRYQUlTVnpHaUs5ZXpBbmVXRHViNkV1ZEsrNGkweHRrWlFqbWZzZWVmRzFzd0gvMGpPWExNMUJMQU1rU3Z0QjF5b2J1bWRjeGg5MUE0L21OVWJocmN4V0tuRGtxRFgyalNnYUgwcmQzYnR4eGVBVER6bVNIcmVGM2FzVTdmWlhoeGdSYlFpMWxsbDRlRWNZL0RnOGVFNytHNm00a1FvQ2N1OTkxaTJhZExkeU83R3U2bjc4TThrdktGZ040N00vM2gzY3NoQ2xPYz0iLCJuYmYiOjE3MDkxNDI5ODMsImV4cCI6MTcwOTIyOTM4MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.QdIOt0h8n3xZ8j-whsGyrSMn6vFnaOX_N1hQYJMsacs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5MWFiMTg5Yy1kOTU0LTQ0NzEtYTM5NS1hZWNmZDEzZDgxY2EiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0Mjk4MywiZXhwIjoxNzA5MTQzODgzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.9oT1oj4QmvuQz-xJLC9goSn7pL_-chdEAJRJpNgPnoE', CAST(N'2024-02-29T14:56:23.780' AS DateTime), CAST(N'2024-02-28T15:11:23.780' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T14:56:23.790' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'9c3aac67-dbb1-4952-b5c8-e549b88bfb05', N'962875ab-bc5f-42ba-abae-3c4f13282ec9', N'374C27C-VqZMHSUTgUroeqSG9WMfQaAe5iKbif4b-S4', N'YDltRLX1SC8a_walHLdfWEUe7KFLCd-5rLd5SBo7z0k', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5YzNhYWM2Ny1kYmIxLTQ5NTItYjVjOC1lNTQ5Yjg4YmZiMDUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViZnBheFBlS1BDdGpPK1Y5LzRvY01qeGROM2JrWkhPRHk5NSsvYXBCeWF5MUQzY25MdDgrcUFFVXlpREEya1AyVXFnRzVjMUV1a2kzZnNYSlVzOFFwdnJhM0FYUWpxQ0Vubkp3NTY2SnRycHZ6aDJKN05OcmhFRjRCcnphNkRoSnBQdCtjVjZwMmlsUTd6SmhtM3JJRnlTczNDNUpSUFBxbEdrV0xrQnNlckQ0MG44bmFYYlBSMTRxdldTb1hvdHBBb1piTUJuZ004MTk2NDVaOFZENjFxUVQwaURGalhtajdWUzF2cU1Rc1R1Ky9lMG9wdnltQVhwU0FSMGtBYS9WektoN1RGYktpU0tMVm9sUlNiK2t4TT0iLCJuYmYiOjE3MDkyNDU3OTIsImV4cCI6MTcwOTMzMjE5MiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.374C27C-VqZMHSUTgUroeqSG9WMfQaAe5iKbif4b-S4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5NjI4NzVhYi1iYzVmLTQyYmEtYWJhZS0zYzRmMTMyODJlYzkiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTI0NTc5MiwiZXhwIjoxNzA5MjQ2NjkyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.YDltRLX1SC8a_walHLdfWEUe7KFLCd-5rLd5SBo7z0k', CAST(N'2024-03-01T19:29:52.460' AS DateTime), CAST(N'2024-02-29T19:44:52.460' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-29T19:29:52.467' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'a1f7afb8-caf8-40ab-951f-35ec7501369d', N'ecbf00ad-c939-4b51-9d7c-0b4b88a64ed9', N'xm00UpFPXZ9yAgG8_rRQm5AVLcTN1z0g62mjPaEbkes', N'R-7luHofnifRltI3ciCU71CgfB3TO0ysVo_s-n64jY0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhMWY3YWZiOC1jYWY4LTQwYWItOTUxZi0zNWVjNzUwMTM2OWQiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWWkNCVjZUS3V4a1h6bkxMb1Y0WExiSkYvSy8xcGlzVlpGR1ZQcDN4RDR2UDV6UVhQTGFuMjFIRG1seENqTzJkY3pPWTJnZm5aR3g5VGlTZzVCVVRTQXR1L3V0V3dSeTJSdDFHdis1SzFTNG81dGVVakpNYWJBTmhwM1JTVlBxNGJKa2xBRzdJVTk1N045b3RUYUxpNGNYSTlQSjFZTks2Mkh4b1NRVnNlL2lQSkdyeGd0d2pPVzFvRHp3cHErNFlTdXN6cnFCK0pSSFBTclAyQUZja0dHVTVMd09acCtTSWRDd05sTEl6YTc1UjJQNms3R2MybDl3VTNXS2NhTUloVUVITkdoRW9VNkYvWVRXcHVWK3E0UT0iLCJuYmYiOjE3MDkwNzYzMTIsImV4cCI6MTcwOTE2MjcxMiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.xm00UpFPXZ9yAgG8_rRQm5AVLcTN1z0g62mjPaEbkes', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlY2JmMDBhZC1jOTM5LTRiNTEtOWQ3Yy0wYjRiODhhNjRlZDkiLCJDb250YWN0SWQiOiI2IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NjMxMiwiZXhwIjoxNzA5MDc3MjEyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.R-7luHofnifRltI3ciCU71CgfB3TO0ysVo_s-n64jY0', CAST(N'2024-02-28T20:25:12.447' AS DateTime), CAST(N'2024-02-27T20:40:12.447' AS DateTime), N'[{"Key":"ContactId","Value":"6"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:25:12.443' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'a37fb917-c376-4c68-90f9-88e7dd21f3c1', N'df69dcd5-1424-47f1-b6e2-d9512a32e2c8', N'aDa9-DEquJObwkou2bs-qKGhYRKjw4d6c56mlFtSrR4', N'xsrq0LF9hbqS2lVRh5ECT50qX9hAVIQ1mUu-r75Xxkc', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhMzdmYjkxNy1jMzc2LTRjNjgtOTBmOS04OGU3ZGQyMWYzYzEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVTLzNmc05OT0s4MzJJRy9FZ0xkaVpsOGptekZrK01YR1IyOFg3QXBrbTA0NHlxVFQzaFBtWjVxNk5ydHBRZW5yRWhRK2gxTVZyZlJDSWU4V05lVG9OUHlxbXplNGorMlF0SFE0OCtQWUtzbnZpcFMvM0VOWXlTVVBaWU42NXFrcjdqSzV6UHM4VEkrbVlMS0dxS2tydWFuTTd4M3ZWTG5QUjVtNURFYTFYMC9TalkxS2hNZFdMOGdoeXZ5dlkrVjM4SU9yTmd0UHJMclJPZXFDRGNFdGpZRUYyaWJNSkUzTVNlSG1INVRncVM5QUVmN2hSbmhNWmZweW52UUorbm41ZXpqS1ZCdGNmc2JGTGNsLzdOS3pRVT0iLCJuYmYiOjE3MDg4MTI1NDMsImV4cCI6MTcwODg5ODk0MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.aDa9-DEquJObwkou2bs-qKGhYRKjw4d6c56mlFtSrR4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZjY5ZGNkNS0xNDI0LTQ3ZjEtYjZlMi1kOTUxMmEzMmUyYzgiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgxMjU0MywiZXhwIjoxNzA4ODEzNDQzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.xsrq0LF9hbqS2lVRh5ECT50qX9hAVIQ1mUu-r75Xxkc', CAST(N'2024-02-25T19:09:03.623' AS DateTime), CAST(N'2024-02-24T19:24:03.623' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T19:09:03.627' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'a8f79d82-48f3-4f65-87bc-ee88e44ea5ac', N'1eda4cff-13fd-4a38-ba96-72d7b9e59903', N'jHUXuVFROujdz1hpRuFGwBSuL5zCOZzUOv4KFj_IPL8', N'I53ZuiF5Sw8XQRzeQzMIry2u1OJFTG7j767S5CW9nG4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhOGY3OWQ4Mi00OGYzLTRmNjUtODdiYy1lZTg4ZTQ0ZWE1YWMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVUb2toTkxaS3lLd24rU3FTdENmL0JiZXRDb256RXdRMUxYeHIxZ3FnRUNhL0lLbWdZZGd2S29mZkk2Z2VlWXZPb3puMlNVclFTZDB0RGxZZldJMHAwZmx0WkwxcFllNncrSDZaMUlIRm9VZEFySFhxMmZOLzdhOFY3VXpTdU5Ca0tFS0o3RTNLRGFnV3dJQ09Bd3dEdndlN1p5aExiUmdKaDFUY2VOS1VlYWU2SkxhUWY3eEVmclBHL0NtN1Vud3FnZHBFSHNGd3dxMjFmYVNXS1lqOFRZd0tvSy95RmRvWkpBL0NOWnJPUmdqdFNvTnU4SDNYRXFpdXYyMkZLMjhTb0NDbVJoRUdUZERZWWo1ZXl4VnN5az0iLCJuYmYiOjE3MDkxNDE1MDQsImV4cCI6MTcwOTIyNzkwNCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.jHUXuVFROujdz1hpRuFGwBSuL5zCOZzUOv4KFj_IPL8', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxZWRhNGNmZi0xM2ZkLTRhMzgtYmE5Ni03MmQ3YjllNTk5MDMiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0MTUwNCwiZXhwIjoxNzA5MTQyNDA0LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.I53ZuiF5Sw8XQRzeQzMIry2u1OJFTG7j767S5CW9nG4', CAST(N'2024-02-29T14:31:44.517' AS DateTime), CAST(N'2024-02-28T14:46:44.517' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T14:31:44.527' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'aeb5b207-7bd6-4bb3-95e9-be0169199784', N'3f5b2249-2f7e-4c61-be72-c1f99ab63275', N'SeqqF4M0ZERCeDNQeePqqZS7dfH2dzN-C6VtYUql4cM', N'x-krud-wXME6hPba3SeKvCzZEu8PLoqKzD0DeGUFGSM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhZWI1YjIwNy03YmQ2LTRiYjMtOTVlOS1iZTAxNjkxOTk3ODQiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVSZnpvK0NRMnBsZlZLUXMyaDBpSDZWeG5rTUhFRnBqTU4wOW42Rmp5UVpPZEhNYUJQVWM3Vk52Z3FTR3Q1QlZNQlBqcFlFaU5yVlBnZGZMMFlrVkxyRXlvckJDaGJjeVI1ZG9UVkpZaHc0dThEMWUzRFFyVkdaWkd2bGVCSk1BY3V3WmNwRjI3YTkwY3pBcC9TOEZ5YXMzWG9FeXNrcllYWmNIS0dpVHY2N3VrZ0ZTT1FEcEVuUDVROXYrNVVoVTFZaHdubmV5MlZPQzg0UW1NNm9jV1Q4UmtOV3JiUlBzQkdaZjhWYzcrNS96c2lKZUhUQ1BxOXZOVjNGeWxwaGJ5anp1N2pRYTlUWWZzYWJBWi9GcGNmST0iLCJuYmYiOjE3MDg4MjE1MzAsImV4cCI6MTcwODkwNzkzMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.SeqqF4M0ZERCeDNQeePqqZS7dfH2dzN-C6VtYUql4cM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzZjViMjI0OS0yZjdlLTRjNjEtYmU3Mi1jMWY5OWFiNjMyNzUiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgyMTUzMCwiZXhwIjoxNzA4ODIyNDMwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.x-krud-wXME6hPba3SeKvCzZEu8PLoqKzD0DeGUFGSM', CAST(N'2024-02-25T21:38:50.130' AS DateTime), CAST(N'2024-02-24T21:53:50.130' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T21:38:50.130' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'b25df344-1721-4c2f-bc4d-2a4ac682a3f1', N'45849529-64cc-4402-a11f-78923d00c7f0', N'QDXZNx9zB1CykcWkp2Mah3TSB1mLCmyxbq1bammqiQA', N'77bfoI9_4zopGnnD0I14rwF2M7fVU0QzqXEizKq9xkA', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiMjVkZjM0NC0xNzIxLTRjMmYtYmM0ZC0yYTRhYzY4MmEzZjEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVhd1hqeUFzM1Z5ZDVpdDJzZHhSVXZFaEJFcEdib2ZRZHJxM3RLR0UxQTl6bFNxdFhDUWlIUWVSajVhUVBvUjlUbVNCeUN6L1RKOURlUm5GdUltRUhvTUNoTUVGUVRhUzJHSU9Ea3BkalNic2M0UXlPbDZpY3NWdG8rcmIxVmpReWpWRmNyaUVIZXBTaDFqbkxhem5CVEF6czdsdU4zbkc0RElxSm9Pejk1emxsVXJFekRNenJVS0txTzh5S2kxSWFzUzhiS2VwblFBZnhsT2ZaRUNvemNNNGNFRk5BQk9MVXl0QlhXLzRTV3pkektBWFpQdkFTSVQ0UmVROWF1U05IK2NWdVhjaWZ0ancyVHltOTlLRFdKUT0iLCJuYmYiOjE3MDkyNDg1NDAsImV4cCI6MTcwOTMzNDk0MCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.QDXZNx9zB1CykcWkp2Mah3TSB1mLCmyxbq1bammqiQA', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NTg0OTUyOS02NGNjLTQ0MDItYTExZi03ODkyM2QwMGM3ZjAiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTI0ODU0MCwiZXhwIjoxNzA5MjQ5NDQwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.77bfoI9_4zopGnnD0I14rwF2M7fVU0QzqXEizKq9xkA', CAST(N'2024-03-01T20:15:40.673' AS DateTime), CAST(N'2024-02-29T20:30:40.673' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-29T20:15:40.673' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'b35e4a3c-da3f-445f-a342-8e203c213f22', N'1e6f05e8-169d-4eda-889b-9040d2123da2', N'dyfJuaZx1Af-urFuXGFjlDYrqnMCLwVx9dbIneP_Umk', N'NpFxsP5qXpIvC5pDwYfDTnsWfVhmXiYhJK6My5csgBc', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiMzVlNGEzYy1kYTNmLTQ0NWYtYTM0Mi04ZTIwM2MyMTNmMjIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViZW5vTGlleXRiR29Dd2FZVU9WZGphcFF2R0pkcEdONURnajJrUUJPNmJVRkFpSVQzTGFBQXNGdFZ2Vkt3Qzc2SnNNczAzWm9LbWdpbzBzbEtCeVc3NnROdFFVUW4vTGl4czFKYXNpdUIzNGtnODlsRUtwb0Vkc0dsZDZJdjBCTWRrbHdjc0kzS0xSMjZaS0l4U244NnQ3WWI4QUdqNGRnU2pxRTVEV213RE5rYjZreDFRTTRqNENEZkVPUElmSDlhcXdxZ1Q0T2cwbGFQdWd5MWNyeEhlY0RMcHVsVjlBYW1Md2Y4UHRxZm5VZmFmc3gxczM4WFFCbTQ1V0tkNUYrN1NzM2hZK1pSWHU5RUhKbDBnVFJFZz0iLCJuYmYiOjE3MDg4Nzg0NzcsImV4cCI6MTcwODk2NDg3NywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.dyfJuaZx1Af-urFuXGFjlDYrqnMCLwVx9dbIneP_Umk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxZTZmMDVlOC0xNjlkLTRlZGEtODg5Yi05MDQwZDIxMjNkYTIiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODg3ODQ3NywiZXhwIjoxNzA4ODc5Mzc3LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.NpFxsP5qXpIvC5pDwYfDTnsWfVhmXiYhJK6My5csgBc', CAST(N'2024-02-26T13:27:57.573' AS DateTime), CAST(N'2024-02-25T13:42:57.573' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-25T13:27:57.603' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'c25ad515-baf2-4719-aada-79735bce493d', N'e9028755-7a72-49fd-accf-cf13946d31a8', N't4h8nPxFh2u4ErIGscux2vs-s_YLD8wygxT6kYL-a18', N'3kningt7fU7g3UFXuDx_flig0PDPUplC4qqY0YsMJcw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjMjVhZDUxNS1iYWYyLTQ3MTktYWFkYS03OTczNWJjZTQ5M2QiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYOTl1bWJTc2pESEtQUnA2dVVoWkpQMTd0MVFva3RVWHZrd3kzTGxoQzZkaTJ1QVE1Q1EzRTMvTHVvWnJLdVd3ZThJbmFOTWtiNTlDaWR2ZWZ1dTV4czBSNER4TGtxOE40WnE5YUxnNGdOOEJuMmlWeUI5UXVyN293c0pLVUd1em1EeVBlbU1lU21xem9VOUs1RGpjdW1SZU9JNjRScHhGcHBUdFlKcWQ1dlpHOUNGRHAvODhWQ1UrNzV1LytiUEZmeHpqb2haQzlweWcxODJKbll6RzBocm1HTVpDWVQ2WXNoUCsvMHlqMS9GQnZwVTM0S0FGa1dPY2Y1Q0hkbXJCZngxd1FWdEZDd0l6V04xcDU0STdyYz0iLCJuYmYiOjE3MDg4MTgyODAsImV4cCI6MTcwODkwNDY4MCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.t4h8nPxFh2u4ErIGscux2vs-s_YLD8wygxT6kYL-a18', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlOTAyODc1NS03YTcyLTQ5ZmQtYWNjZi1jZjEzOTQ2ZDMxYTgiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgxODI4MCwiZXhwIjoxNzA4ODE5MTgwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.3kningt7fU7g3UFXuDx_flig0PDPUplC4qqY0YsMJcw', CAST(N'2024-02-25T20:44:40.867' AS DateTime), CAST(N'2024-02-24T20:59:40.867' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T20:44:40.870' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ccc86000-37c3-4c1a-bcb5-016f55a7e158', N'd876db90-27ac-4abd-a443-6e6b79b1b261', N'NIP1TEXf2wOGZYTw3yt7AUJPBOwxxXQJ2by1_CQ5BU0', N'Z7O20gZHSUS5DJZGTrUwRShcig-W3ErBDSf1P-zqaWU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjY2M4NjAwMC0zN2MzLTRjMWEtYmNiNS0wMTZmNTVhN2UxNTgiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVL3E3VTU1RWFTTWFoMXBYQklYU2RvMjZmM09JM0RvcW51UTRNUTFYcWxzM2xxUm9EK3FTTjhXMW4yRnZyU2RSMzQxRmgrMnAvTE9VU2ZvcEQzV2VXZWt5YW9GSEVhRlBHSHYzU0lqeGZvZWFkbERoNndTVHdBWFd1QnRtSXpwbzJEbG44MG1JbjJJTGpxdCtYbi9Ga2s1REFoenJoaWM0ZjlLT2IzTUQrR1FQNmxJSmsxc1pQMlRVNUhEcmwzeWJPOTZONkRqRjBzN2RPZGtHYTFjai9xbkpBaWxUeDBuSE5QeTlvaThaMzNGaHZvOW9UeVRZaU5UMkwzWXhCM0trTStnN2EvTGpjVXVSMHRKMWsyQVJFZz0iLCJuYmYiOjE3MDg3MjY3NjEsImV4cCI6MTcwODgxMzE2MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.NIP1TEXf2wOGZYTw3yt7AUJPBOwxxXQJ2by1_CQ5BU0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkODc2ZGI5MC0yN2FjLTRhYmQtYTQ0My02ZTZiNzliMWIyNjEiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNjc2MSwiZXhwIjoxNzA4NzI3NjYxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.Z7O20gZHSUS5DJZGTrUwRShcig-W3ErBDSf1P-zqaWU', CAST(N'2024-02-24T19:19:21.337' AS DateTime), CAST(N'2024-02-23T19:34:21.337' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:19:21.340' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'd060652d-26a4-4f4c-ae8b-4e98ab45cab7', N'fd96b282-482f-498d-b47f-2f6bb68749e4', N'h-ks-_vFQsTSE5daoh9DcddCCXeGeoKIW_amSWQNdO4', N'4LTx3BDky6mpZMBgp7o97PQoYFlRG38Vw9dBMohUJ78', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkMDYwNjUyZC0yNmE0LTRmNGMtYWU4Yi00ZTk4YWI0NWNhYjciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVTckJlRjZPK05OYlRMTDFjRytjYWtYNStHZWxoSXJOdUFhN20ycVkrbU5hd3dHVzhPVEl1OGdRUFRwUVZsOTY0UlJUK0wxZ2hFb1lSZHNwczFpZnBjS0NrT1E3azJBbmVnN3l4bUZ4Kzl3YWZqNURuQnpaYmdHREhCZjVsWWwxdVRUYlZnQk9ZSmFCT1RWRFZDRm05UnFwZFBjMG9UZlFvN3FwZGNGaFozalpjRmdDS3pkOG80aU41UFhJZGFGakxLanFndWZrL1NyUFZJTnkyWnJ4NnVObXBtSWY1RmNYTVQxdCtHRjJYeDg4NzFYUGllVGV3K0FPdDIxZDBHbVFNOHB4RStKZzhJQlVGemhQYWp0Yi9nND0iLCJuYmYiOjE3MDg3MjcyNzAsImV4cCI6MTcwODgxMzY3MCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.h-ks-_vFQsTSE5daoh9DcddCCXeGeoKIW_amSWQNdO4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmZDk2YjI4Mi00ODJmLTQ5OGQtYjQ3Zi0yZjZiYjY4NzQ5ZTQiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNzI3MCwiZXhwIjoxNzA4NzI4MTcwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.4LTx3BDky6mpZMBgp7o97PQoYFlRG38Vw9dBMohUJ78', CAST(N'2024-02-24T19:27:50.523' AS DateTime), CAST(N'2024-02-23T19:42:50.523' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:27:50.520' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'd4a83a49-eb9d-43e9-90ed-8d4c2f93e102', N'680c4313-1c67-49a2-8b0e-7e12f5eb77ca', N'fsWWTiiz1pvme5QjgCarjrUowOcm2kpnwhz7i_G0FfY', N'UwcE7Q0GTwkwaNKNoX0r8x3B_ckGkDXh781tAYFSK6o', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkNGE4M2E0OS1lYjlkLTQzZTktOTBlZC04ZDRjMmY5M2UxMDIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVXRzRTUXVUZDBtdTZEdVB2aklkdE9sWWg2T3hoUEVyRVRaNHVLTGVCOERXMmgvZEJuWXNOcDdjV0ZHUVl0R3p4bGN2eXJuM2Y3ZzNmNEJuQnBXbjFzZkdyQm95ZVhQemUzK2xUSitOcVJWSmljaXBFR2VtaFhNeW1iY1BWS2E1Rm5iUVZ3dWJqMmdtS3N0ZWRac3JXUXZoWjFZVlp5OWFLOVJEQitWQkdoQ1VIWEhvQ2JZUnlyR2pwVHByNzRlbEJ5OHpLT0VnWUhlVnZFN2lqUzhQcmpYS2NrU1NDZDQyZE9TYWw5MTVxbTQzTGthaThqKzlPcXA3Y1BWWmUvek55Um1yNElENGFucnhLTDNEZldvS0VSQT0iLCJuYmYiOjE3MDg3MjkyNTMsImV4cCI6MTcwODgxNTY1MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.fsWWTiiz1pvme5QjgCarjrUowOcm2kpnwhz7i_G0FfY', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2ODBjNDMxMy0xYzY3LTQ5YTItOGIwZS03ZTEyZjVlYjc3Y2EiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyOTI1MywiZXhwIjoxNzA4NzMwMTUzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.UwcE7Q0GTwkwaNKNoX0r8x3B_ckGkDXh781tAYFSK6o', CAST(N'2024-02-24T20:00:53.337' AS DateTime), CAST(N'2024-02-23T20:15:53.337' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T20:00:53.337' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'd8b1ad2e-26aa-48ee-981d-92ebef343e5a', N'c9fa1fd1-a810-4175-8ebd-7d227f3e87a2', N'AiKYM_A1w_dRbUB9rbf5g2cU71jRNATQ3LQ-10tr-KU', N'cAaBK5TwjGzoq-e_k_FehIKX2BqAF8fHDg6kp4rLoNk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkOGIxYWQyZS0yNmFhLTQ4ZWUtOTgxZC05MmViZWYzNDNlNWEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVlSnphV0krVEZsYlN4M1hDWlliWU16ZGRQYldKR3pBMWZTSTJkZENsSk5sdFFVcGl4NFNQYXlFcFRXRGNhdUk4Yy9oMzlXb0tkZFFpTVI1LzdFRlRZaVkwTmpVckpmYmZIdGZJR3locjNKRUZYUHB5Z3JzMHhodXZGWUpiQUtKNDJPTkZ3bFRoQURjb1NiTlVnYjZxWnJsU2NxcHZDMHB2dURQK2pvd1JhcERlWXY2WUtCV3EybjVONWhTTkc3RzRJSUVCOW14Njg1QmYzdENkUkgzNDlXaFJpWHdsUFh2MFprMlJ0eGJ1SFdrY0ZRamFZUmE3LzlkenErZGNJWHhHYm9zemFtWjNRK1J5eTdNR3lDcndKND0iLCJuYmYiOjE3MDkwNzYzNzksImV4cCI6MTcwOTE2Mjc3OSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.AiKYM_A1w_dRbUB9rbf5g2cU71jRNATQ3LQ-10tr-KU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjOWZhMWZkMS1hODEwLTQxNzUtOGViZC03ZDIyN2YzZTg3YTIiLCJDb250YWN0SWQiOiI4IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NjM3OSwiZXhwIjoxNzA5MDc3Mjc5LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.cAaBK5TwjGzoq-e_k_FehIKX2BqAF8fHDg6kp4rLoNk', CAST(N'2024-02-28T20:26:19.010' AS DateTime), CAST(N'2024-02-27T20:41:19.010' AS DateTime), N'[{"Key":"ContactId","Value":"8"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:26:19.013' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'e005d623-0c66-480a-8bb8-2e8cc9dfee6a', N'fb9a61fc-9b37-492e-af44-0b94912e25a0', N'RFvjx3rkivdSxfYT7eiWcUjKab1Lc4INZuUfHmTD2DI', N'aCbNVOKelHgAp9N3Yep5T15MjKzUTb8YMKTazhcRIJE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlMDA1ZDYyMy0wYzY2LTQ4MGEtOGJiOC0yZThjYzlkZmVlNmEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVZMGNmZ1Bud1BPT2ZQbUlVSmkxNTVLc0xGK1V0T04yMnBlS3pWY2dMTm1GbGUzNFBJZ0NDNkFmd0F1OEkzaXh0R0lzYVJjODRlaVB6OEpuNjRXU3J1c1lzM2FJLzNwK1V2blVFaGxOc1lhZkN3b0g1Snd0eXZqSkI2RlFGM3ZyczlMbEFkKzdlNGxiRG93RCtYRkpFR0Myb2NOUFJuK2RKcGl1dVQzL2FYS2lyMW9wRC9CbFhnckV3V2Q5TkwwMmtLaHc4MHNoa0hlQlZ1cXYwQzFOcWljS1I4ZDlVSTUwTUlEWjk0UUJ5azFtUVg1N0hkTHpTUTRBYU93ZUhCWEsrUEFPdHdZMWZCY3JXaHpQclk1bVg3cz0iLCJuYmYiOjE3MDkwNzQyMTIsImV4cCI6MTcwOTE2MDYxMiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.RFvjx3rkivdSxfYT7eiWcUjKab1Lc4INZuUfHmTD2DI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmYjlhNjFmYy05YjM3LTQ5MmUtYWY0NC0wYjk0OTEyZTI1YTAiLCJDb250YWN0SWQiOiI2IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NDIxMiwiZXhwIjoxNzA5MDc1MTEyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.aCbNVOKelHgAp9N3Yep5T15MjKzUTb8YMKTazhcRIJE', CAST(N'2024-02-28T19:50:12.720' AS DateTime), CAST(N'2024-02-27T20:05:12.720' AS DateTime), N'[{"Key":"ContactId","Value":"6"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T19:50:12.720' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'e04ba7a2-0713-4e56-bb29-6bdaf00be74c', N'62bc80a0-a395-4f65-8d7d-c481190c774c', N'FI2MHXlyjRmnSi-DqZ00vcmnK6MaAQEHrbkaKldxZNQ', N'mUewyK_E1tMDy0JBBTbIQNM2Br5HvNgksLl3WCjE3R8', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlMDRiYTdhMi0wNzEzLTRlNTYtYmIyOS02YmRhZjAwYmU3NGMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWNkRHM0YrdUlPU2tiZURtTFBaalRTRytSU1puYW81OGxRTUFDbnY2dW1yaXVSMlFWZmxhRzJBM0dWNzJIWnVpOEI0c2NvSDBaUDd5TTlDMjIzWGY3WEcvVW5iTEVHemRyUkhhSG94WHE3ZXR1cjdFV2lNTDQ4WnZiUlhEK2Z1WGw0ejRabE0xMUxyNlFGTC9PQW5QL00zckVlZU9yWlNaRUQ0QXI1blo5M3B1UnJqaDZINGJIMWNISDY5MG9iYkxpL0ZCclFwZlJrVTZLNnhTZzlnMU1sNWt2VkY3UXVTVldrVXR1QUdGRTlaREdhWk12aUdPQjV3aWtJVHlVNU0vRkI0b2lYcGVySDIyZWRoZUdncTlsTT0iLCJuYmYiOjE3MDg3Mjg2NzMsImV4cCI6MTcwODgxNTA3MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.FI2MHXlyjRmnSi-DqZ00vcmnK6MaAQEHrbkaKldxZNQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MmJjODBhMC1hMzk1LTRmNjUtOGQ3ZC1jNDgxMTkwYzc3NGMiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyODY3MywiZXhwIjoxNzA4NzI5NTczLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.mUewyK_E1tMDy0JBBTbIQNM2Br5HvNgksLl3WCjE3R8', CAST(N'2024-02-24T19:51:13.600' AS DateTime), CAST(N'2024-02-23T20:06:13.600' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T19:51:13.600' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'e881120f-71ef-4cd6-abcf-acc865391301', N'0de1ac7a-8f62-48af-8a7f-f85f29c2d87b', N'S2kogsQuFkFvNDf7J4QgRk9JV_VowM3z8MzjBIWeltI', N'HZkmCNVpKUqwHzpeCSrI7HbWD2nKATtJqr6Qt2J5WSo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlODgxMTIwZi03MWVmLTRjZDYtYWJjZi1hY2M4NjUzOTEzMDEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmbjZrOWNEajI3K3dSSEZtdEVzdDFjSmZkMjd5Qm1WK3JTMnVkdWZMNExmYVM0Qk9sdUZrbTArZnZTQVNLK2c0NmtodHYvdndVWTJTZEoyV3FpMVZTa1RsNTZSdTB6L0xQeDBrNkxtY2RkUTYzWm9lM2o5K0d6cXpKbUFkSlhRdXllY2NGMjRqV1ZaT1NqWGtjVjc2M084Z0ZOV09PTFRaQnM4dFZhT2oySkE0b1l2WDVzTmhCeW9xRGh0aFhkRVRzajF5bFN6NWtnWXZKY0d6VUhLYmZhM1luUkRnaGswbjlheElYQ01sWmlNYUg3MW5JcDc3a05oUVJGRmxiWTBPYVNlVFJVZXMxODRsTGlqdDZMVnUxND0iLCJuYmYiOjE3MDkxNDA4ODUsImV4cCI6MTcwOTIyNzI4NSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.S2kogsQuFkFvNDf7J4QgRk9JV_VowM3z8MzjBIWeltI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwZGUxYWM3YS04ZjYyLTQ4YWYtOGE3Zi1mODVmMjljMmQ4N2IiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTE0MDg4NSwiZXhwIjoxNzA5MTQxNzg1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.HZkmCNVpKUqwHzpeCSrI7HbWD2nKATtJqr6Qt2J5WSo', CAST(N'2024-02-29T14:21:25.827' AS DateTime), CAST(N'2024-02-28T14:36:25.830' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-28T14:21:25.847' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ebd0325e-c5c1-4dd9-94ed-4e022ebe8f75', N'8802c482-ac21-4308-813d-d9f1c8d337d4', N'kyebjZyrZkX1b7DnjUb2GvYqYXr3IWVfNAwW-bdafhw', N'ljbeePLuTIGzjhAnpQ6xuViNr9zSAZ0Qe4odEAWx1_Y', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlYmQwMzI1ZS1jNWMxLTRkZDktOTRlZC00ZTAyMmViZThmNzUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViSUxGNTY3SWRQSlg2M1hwbUFBeDg3Sk02UlJ2NU95dVFtVHhSU2ZONW1DVmYzTEFCeWNtbW40RlhmVGl1UGtuU3dwZS9NOTZXZGY5dUprSUxZUkpPV29YUVdZVUV5cnVaQ2FIUm05bEJ4aE5oTmtxUjVrQWFjUThRSVB4S2ZuRjB0WkpCMnRPQ2YyVGE5czI4SzI3KzUzWk9OTElnajVMbldlNW84V1BrOUhIcGR1bVNCRGFlYWd6UjZqOUNPM2U0cmR6SFRsNTZQTXZLYmgrNG51VlhrTUlSYTJrbVc5RHAzMVlrWmRiOW5XYTA2NUJaQVhNN0Q5Lzc5YzFCZmxTVkRwY2Jpa3cvejJ1NE83SXhYajluOD0iLCJuYmYiOjE3MDg5ODMxNzMsImV4cCI6MTcwOTA2OTU3MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.kyebjZyrZkX1b7DnjUb2GvYqYXr3IWVfNAwW-bdafhw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4ODAyYzQ4Mi1hYzIxLTQzMDgtODEzZC1kOWYxYzhkMzM3ZDQiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODk4MzE3MywiZXhwIjoxNzA4OTg0MDczLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.ljbeePLuTIGzjhAnpQ6xuViNr9zSAZ0Qe4odEAWx1_Y', CAST(N'2024-02-27T18:32:53.207' AS DateTime), CAST(N'2024-02-26T18:47:53.207' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-26T18:32:53.203' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ed05ffa5-ced4-44be-96b0-428994f8d879', N'4829978c-44ab-407a-9e29-347ac83dcca0', N'mKZkQYuj1aT3WaCYTY1CfPasAOvkkIa_KaX358M4_iE', N'sMpEucN5cwEgKDPipMkL1uV4c8gbcdUEW0EFyc7N6EM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlZDA1ZmZhNS1jZWQ0LTQ0YmUtOTZiMC00Mjg5OTRmOGQ4NzkiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVTMWNBWVFnZ3l4T1FZOEoyRUIvN0hjdTN1b1oxSVZqaVJrcU5FNHRxaUF0Wk9aWGozOVVGMjdoU0hubTJXQnc5a0pjTGcybExtQWQxZ0JSbXB1N0tNRkZ0RUVzajUvYmJsY0tyZUczK21uK3NtcDByOVRMRTJmdCtWT1BaUW5Ka1ZMdnhIK2d5enJvWGxUa250d0QvSXJYMGdCdGF1c0VBWXZjbG50eHpNWDZRWVRwbEVTQTg1U1FlTzUySFdvb3RmMWVSTmVOamUyYzIrR1FRWm1LVW1rVm16Mmx4MGlMTVlTRzR2RldUUEpkNWxBU2puYVVIYzRld1ZWRkdlZnJCN0M1UGVHVVZpaUcxdkpPZnZvZkp2WT0iLCJuYmYiOjE3MDkwNzc3OTAsImV4cCI6MTcwOTE2NDE5MCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.mKZkQYuj1aT3WaCYTY1CfPasAOvkkIa_KaX358M4_iE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0ODI5OTc4Yy00NGFiLTQwN2EtOWUyOS0zNDdhYzgzZGNjYTAiLCJDb250YWN0SWQiOiI2IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3Nzc5MCwiZXhwIjoxNzA5MDc4NjkwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.sMpEucN5cwEgKDPipMkL1uV4c8gbcdUEW0EFyc7N6EM', CAST(N'2024-02-28T20:49:50.337' AS DateTime), CAST(N'2024-02-27T21:04:50.337' AS DateTime), N'[{"Key":"ContactId","Value":"6"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:49:50.340' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ed508f1a-363f-440a-8e04-9b68423026a3', N'94e29171-9903-4b3b-808a-a4a1288b1cf4', N'aaV2VKh4wM7kjmVNxA4W3xyHJxGkIE0RqhRaF_D-UBA', N'At6axAiYwzIWMyxCafPa1VaztUpSgImaxCcqo2o84hk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlZDUwOGYxYS0zNjNmLTQ0MGEtOGUwNC05YjY4NDIzMDI2YTMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVaTExkeUxKVGthQVk0My9FaUFVWVdOU09vaFV1bUR2K0ZXZVpxektYeENvRWJnZXZLTDFheElicjRVUTZrRzV2Y29qWFRNSUQ3dVBMRXNoOXB3eVplc0Q0a1g5VGhzZ3h2YjNock9sWGpNUmVvZXBLUjVBUi83Q2dZZlZ1V3p0elFMTFVZWTBqcUs1TTBkN1FLN29yTVZBaGVmWDNrdlBqQVp2SldubzZOZ2tva0t1ZHFjazNKdGNrbUY3L3B5U0NUK242RS9kTnc2enRUTWR1RlNCR0FnbkV5aTlqZ1lUTWY1bHhUZk1SblR4dGlhK3FlQ1pQc0cyeCs0VnNMOWQ1dDdZb1BiZHoxeXNpSVJGRE5tRXRvcz0iLCJuYmYiOjE3MDg4MDg2OTgsImV4cCI6MTcwODg5NTA5OCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.aaV2VKh4wM7kjmVNxA4W3xyHJxGkIE0RqhRaF_D-UBA', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5NGUyOTE3MS05OTAzLTRiM2ItODA4YS1hNGExMjg4YjFjZjQiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODgwODY5NywiZXhwIjoxNzA4ODA5NTk3LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.At6axAiYwzIWMyxCafPa1VaztUpSgImaxCcqo2o84hk', CAST(N'2024-02-25T18:04:58.033' AS DateTime), CAST(N'2024-02-24T18:19:58.033' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-24T18:04:58.063' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'ee0a2d3d-8462-47cf-b1aa-f300170560b7', N'ab44e0cc-f71d-4b41-9b54-2bfa11ee0f25', N'F4oFUGcQaV-4pz44UnSnXN4JcRrcEV7ck3OYTQTD2rQ', N'C6JiMLrcwtPWblblk2uCi9pDTbK00N-__QcdM3P8nRI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlZTBhMmQzZC04NDYyLTQ3Y2YtYjFhYS1mMzAwMTcwNTYwYjciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmak5FZ0Q1MVNiajU0YWd3aEVnQTJSRmY1TTZnUkF1N2pNelZsN2thOElIWXR4U2xFM2ZaNUxWNjQ2N2VBaDJyMzNDR25jMm03OXZyc2xwZTVPckxXYzBoZGl3VnExeDllZW1kZWcwTDF0cU5IeDU0WUxUc0FhWEtpdi9JNUxjM2FTb2NsQ216ZWJSTEh5bFp4RkNZTDUzcTlQQTlJb1ZFcG50QndBMmg1UkMwdzhjOGlWdVl6WnJ3UEI2dFcyRzhreGd6aWZacWh2RXN2SjdDUnE2T0lDNUtUYjJxUTJKVEZKMk4zKzF4TkZZYnVEOWFnNDBrS04zclN5djF5Vm1XZG5zTXNMSi9TK04xM1JpQ2pDUUY4WT0iLCJuYmYiOjE3MDg3MjQ2NzEsImV4cCI6MTcwODgxMTA3MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.F4oFUGcQaV-4pz44UnSnXN4JcRrcEV7ck3OYTQTD2rQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhYjQ0ZTBjYy1mNzFkLTRiNDEtOWI1NC0yYmZhMTFlZTBmMjUiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwODcyNDY3MSwiZXhwIjoxNzA4NzI1NTcxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.C6JiMLrcwtPWblblk2uCi9pDTbK00N-__QcdM3P8nRI', CAST(N'2024-02-24T18:44:31.163' AS DateTime), CAST(N'2024-02-23T18:59:31.163' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', CAST(N'2024-02-23T18:44:31.163' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'f8dc6b6d-2419-49d6-a949-0843c29a2b03', N'fbc4e980-3b22-47ea-8ba0-55cad371f307', N'iSEhA-_pDmsLpZPxZdHbam7u3HM1_h85dgXblLBlSb4', N'EeWIz_6GoFVkq9rA38RzjKQFh0YXj7Gm-kPxUUs2caw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmOGRjNmI2ZC0yNDE5LTQ5ZDYtYTk0OS0wODQzYzI5YTJiMDMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVURTdPdy9qd3Jib2szSjVBc1U1M3FvSmxhZStQbUxNeXNJcnZPdzRtRHc2cFVJYjFBN2pTcXJRTVZuUmtjL1k5L0RkcUQzZmxDZ08wR3Z1cUdQbVZpdlJkQitCNE5vYkFOcklwRkNsWkRIMTdpdGR0bEJER1ZEU0hPZmkwdzkzYlZMVkNFSjVhSFdjS2lRRCtlT3g3Sm50Vjd5bS9aT2h6RjM1Q1dKWnBZU0J2b3VFRFRKNzJXYmg1SmRKbFQ0a2t2RFl1dzlZWHVhMWVZL1hwQ2FOYXZ4c1JSU0xoeHdCcW1xZ2Q0VUdwRllGZjhVVEFLYmVoelRkZzBsVnNZVHlINERUN2I1YU9jbkcxOHd2empLQWZUYz0iLCJuYmYiOjE3MDkwNzYzMzYsImV4cCI6MTcwOTE2MjczNiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.iSEhA-_pDmsLpZPxZdHbam7u3HM1_h85dgXblLBlSb4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmYmM0ZTk4MC0zYjIyLTQ3ZWEtOGJhMC01NWNhZDM3MWYzMDciLCJDb250YWN0SWQiOiI3IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcwOTA3NjMzNiwiZXhwIjoxNzA5MDc3MjM2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.EeWIz_6GoFVkq9rA38RzjKQFh0YXj7Gm-kPxUUs2caw', CAST(N'2024-02-28T20:25:36.847' AS DateTime), CAST(N'2024-02-27T20:40:36.847' AS DateTime), N'[{"Key":"ContactId","Value":"7"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-02-27T20:25:36.840' AS DateTime))
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
/****** Object:  StoredProcedure [dbo].[ActionLog_GetActions]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Blocked]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Change_Recover_Password]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_ChangePassword]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Confirm]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_CredentialsLogin]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Delete]    Script Date: 9/3/2024 18:06:21 ******/
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
					10,
					GETDATE()
				)

	END
GO
/****** Object:  StoredProcedure [dbo].[Contact_Deny_Recover]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_GetAll]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_GetById]    Script Date: 9/3/2024 18:06:21 ******/
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
	FirstName + ' ' + LastName 'Name',
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
/****** Object:  StoredProcedure [dbo].[Contact_GetByIdInformation]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_RecoverPassword]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Regisrter]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_TrustedUntrusted]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Unblocked]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Update]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_UpdateAuditor]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Validate_Recover]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Canllation]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetAll]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetById]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Insert]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Delete]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_GetAll]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Insert]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Update]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[DenyObject_GetByKeyAndId]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Authorize]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Delete]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Deny]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetAll]    Script Date: 9/3/2024 18:06:21 ******/
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
ORDER BY E.StartDate DESC
		
GO
/****** Object:  StoredProcedure [dbo].[Events_GetAllAssist]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetByDate]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetById]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetByIdMoreInfo]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Insert]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Update]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Notify_NewEventsAndPosts]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Object_UpdateImage]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Authorize]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Delete]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Deny]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetAll]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetById]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetByIdMoreInfo]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Insert]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Update]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Search_GetSearch]    Script Date: 9/3/2024 18:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Search_GetSearch]
(
	@SearchText AS VARCHAR(MAX),
	@Filters AS VARCHAR(MAX),
	@inclusivePosts AS BIT = NULL,
	@inclusiveEvents AS BIT = NULL
)

AS

/*
-- para trest
DECLARE	@SearchText AS VARCHAR(MAX) = null
DECLARE	@Filters AS VARCHAR(MAX) = null
DECLARE @inclusivePosts AS BIT = 'True'
DECLARE @inclusiveEvents AS BIT = 'False'
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
	DateOrder DateTime,
	DateEntered  DateTime
)

IF (@SearchText IS NOT NULL)
	BEGIN
		INSERT INTO @TableSearchText
		SELECT value
		FROM STRING_SPLIT(@SearchText , ' ')
	END


IF ISNULL(@inclusiveEvents, 'True') = 'True'
	BEGIN
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
			ISNULL(ISNULL(ISNULL(E.EndDate, E.StartDate),E.DateModify), E.DateEntered),
			E.StartDate
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
		ORDER BY E.StartDate DESC
	END


IF ISNULL(@inclusivePosts, 'True') = 'True'
	BEGIN
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
				ISNULL(P.DateModify, P.DateEntered),
				P.DateEntered
			FROM [Posts] (NOLOCK) P
				INNER JOIN Contacts (NOLOCK) C
					ON C.ContactId = P.ContacCreate
				INNER JOIN PostsXTypesImpairment (NOLOCK) PTI
					ON PTI.PostId = P.PostId
				INNER JOIN TypesImpairment (NOLOCK) TI
					ON PTI.TypeId = TI.TypeId
				INNER JOIN @PostsAux PA
					ON PA.PostId = P.PostId
		END

			
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
/****** Object:  StoredProcedure [dbo].[Tokens_Change]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Insert]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Regenerate]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Update]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateChange]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateUpdate]    Script Date: 9/3/2024 18:06:21 ******/
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
/****** Object:  StoredProcedure [dbo].[TypesImpairment_GetAll]    Script Date: 9/3/2024 18:06:21 ******/
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
