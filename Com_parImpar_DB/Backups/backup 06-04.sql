USE [ParImpar]
GO
/****** Object:  User [user_api]    Script Date: 6/4/2024 19:49:21 ******/
CREATE USER [user_api] FOR LOGIN [user_api] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[SearchTypesImpairment]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[ActionLog]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[ActionType]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[Contacts]    Script Date: 6/4/2024 19:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contacts](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[dateEntered] [datetime] NULL,
	[Email] [varchar](200) NOT NULL,
	[Password] [varchar](max) NOT NULL,
	[UserName] [varchar](200) NULL,
	[DateBrirth] [date] NULL,
	[Auditor] [bit] NULL,
	[Confirm] [bit] NULL,
	[Trusted] [bit] NULL,
	[Notifications] [bit] NULL,
	[ConfirmCode] [varchar](100) NULL,
	[ExpiredRecover] [datetime] NULL,
	[CodeRecover] [varchar](100) NULL,
	[ImageUrl] [varchar](255) NULL,
	[DateModify] [datetime] NULL,
	[Blocked] [bit] NULL,
	[DateDeleted] [datetime] NULL,
	[FoundationName] [varchar](500) NULL,
	[Address] [varchar](500) NULL,
	[UrlWeb] [varchar](500) NULL,
	[Description] [varchar](max) NULL,
	[UserFacebook] [varchar](500) NULL,
	[UserInstagram] [varchar](500) NULL,
	[UserLinkedin] [varchar](500) NULL,
	[UserX] [varchar](500) NULL,
 CONSTRAINT [PK__Contact__CFED658FE377AA2D] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContactXEvent]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[ContactXTypeImplairment]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[DenyObject]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[Events]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[MailExecutions]    Script Date: 6/4/2024 19:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MailExecutions](
	[Send] [varchar](500) NULL,
	[LastExecution] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Posts]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[PostsXTypesImpairment]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[States]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[Tokens]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  Table [dbo].[TypesImpairment]    Script Date: 6/4/2024 19:49:21 ******/
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
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (1, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:17:14.243' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (2, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:17:18.713' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (3, N'ContactId', 2, NULL, 2, CAST(N'2024-03-17T11:17:23.450' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (4, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:19:43.123' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (5, N'PostId', 1, NULL, 3, CAST(N'2024-03-17T11:22:08.603' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (6, N'ContactId', 2, NULL, 2, CAST(N'2024-03-17T11:22:35.997' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (7, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:23:07.983' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (8, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:23:11.737' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (9, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:23:41.013' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (10, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:26:14.383' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (11, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:38:14.533' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (12, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:38:22.363' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (13, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:39:59.800' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (14, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:40:03.737' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (15, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:41:51.640' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (16, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:41:53.613' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (17, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:43:15.350' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (18, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:43:16.440' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (19, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:43:22.090' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (20, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:43:42.867' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (21, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:43:43.770' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (22, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:43:44.550' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (23, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T11:44:45.340' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (24, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:44:46.483' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (25, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:45:48.587' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (26, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T11:46:40.657' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (27, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T13:55:05.750' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (28, N'PostId', 1, NULL, NULL, CAST(N'2024-03-17T13:55:08.740' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (29, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T13:55:11.750' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (30, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T13:55:12.797' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (31, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T13:55:22.920' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (32, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T13:55:34.353' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (33, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T13:55:36.023' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (34, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T13:56:28.313' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (35, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T13:56:32.140' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (36, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T13:56:33.257' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (37, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T13:57:16.217' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (38, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T20:18:11.947' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (39, N'EventId', 1, NULL, 3, CAST(N'2024-03-17T20:20:00.440' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (40, N'EventId', 2, NULL, 3, CAST(N'2024-03-17T20:23:40.343' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (41, N'ContactId', 2, NULL, 2, CAST(N'2024-03-17T20:23:55.673' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (42, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T20:24:59.007' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (43, N'ContactId', 4, NULL, 4, CAST(N'2024-03-17T20:29:21.033' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (44, N'EventId', 3, NULL, 4, CAST(N'2024-03-17T20:31:41.467' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (45, N'EventId', 4, NULL, 4, CAST(N'2024-03-17T20:32:54.743' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (46, N'PostId', 2, NULL, 4, CAST(N'2024-03-17T20:35:26.550' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (47, N'PostId', 3, NULL, 4, CAST(N'2024-03-17T20:36:35.237' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (48, N'ContactId', 4, NULL, 4, CAST(N'2024-03-17T20:42:18.540' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (49, N'ContactId', 2, NULL, 2, CAST(N'2024-03-17T20:42:31.367' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (50, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T20:42:52.950' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (51, N'ContactId', 8, NULL, 8, CAST(N'2024-03-17T20:50:59.753' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (52, N'EventId', 5, NULL, 8, CAST(N'2024-03-17T20:52:39.663' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (53, N'EventId', 6, NULL, 8, CAST(N'2024-03-17T20:54:24.233' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (54, N'EventId', 7, NULL, 8, CAST(N'2024-03-17T20:55:59.347' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (55, N'PostId', 4, NULL, 8, CAST(N'2024-03-17T20:58:45.020' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (56, N'PostId', 5, NULL, 8, CAST(N'2024-03-17T21:00:13.463' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (57, N'ContactId', 8, NULL, 8, CAST(N'2024-03-17T21:01:25.360' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (58, N'ContactId', 8, NULL, 8, CAST(N'2024-03-17T21:01:34.870' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (59, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T21:03:07.287' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (60, N'ContactId', 2, NULL, 2, CAST(N'2024-03-17T21:03:29.223' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (61, N'ContactId', 9, NULL, 9, CAST(N'2024-03-17T21:10:26.097' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (62, N'ContactId', 9, NULL, 9, CAST(N'2024-03-17T21:11:12.053' AS DateTime), NULL, 9)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (63, N'ContactId', 4, NULL, 4, CAST(N'2024-03-17T21:14:32.517' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (64, N'EventId', 1, NULL, 4, CAST(N'2024-03-17T21:19:09.227' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (65, N'ContactId', 3, NULL, 3, CAST(N'2024-03-17T21:19:13.153' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (66, N'ContactId', 2, NULL, 2, CAST(N'2024-03-17T21:22:13.497' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (67, N'ContactId', 4, NULL, 4, CAST(N'2024-03-17T21:26:27.750' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (68, NULL, NULL, NULL, NULL, CAST(N'2024-03-17T21:26:34.753' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (69, N'ContactId', 4, NULL, 4, CAST(N'2024-03-18T14:50:20.240' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (70, N'ContactId', 2, NULL, 2, CAST(N'2024-03-18T14:51:05.433' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (71, N'ContactId', 4, NULL, 4, CAST(N'2024-03-18T15:08:02.157' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (72, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:10:30.883' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (73, N'EventId', 4, NULL, 4, CAST(N'2024-03-18T15:10:57.053' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (74, N'ContactId', 4, NULL, 4, CAST(N'2024-03-18T15:11:07.330' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (75, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:11:23.487' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (76, N'PostId', 2, NULL, NULL, CAST(N'2024-03-18T15:15:10.087' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (77, N'EventId', 7, NULL, 2, CAST(N'2024-03-18T15:16:30.850' AS DateTime), NULL, 16)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (78, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:19:16.370' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (79, NULL, NULL, N'5', NULL, CAST(N'2024-03-18T15:19:22.900' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (80, NULL, NULL, N'3', NULL, CAST(N'2024-03-18T15:19:53.427' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (81, NULL, NULL, N'3', NULL, CAST(N'2024-03-18T15:19:58.757' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (82, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:22:10.707' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (83, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:22:52.203' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (84, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:24:53.590' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (85, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:26:09.160' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (86, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:29:22.247' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (87, NULL, NULL, NULL, NULL, CAST(N'2024-03-18T15:29:48.427' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (88, NULL, NULL, NULL, NULL, CAST(N'2024-03-20T20:13:30.340' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (89, NULL, NULL, NULL, NULL, CAST(N'2024-03-20T20:59:55.207' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (90, NULL, NULL, NULL, NULL, CAST(N'2024-03-20T21:01:01.567' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (91, N'EventId', 2, NULL, NULL, CAST(N'2024-03-20T21:01:13.373' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (92, N'ContactId', 3, NULL, 3, CAST(N'2024-03-20T21:01:50.570' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (93, N'ContactId', 4, NULL, 4, CAST(N'2024-03-20T21:03:12.760' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (94, N'ContactId', 2, NULL, 2, CAST(N'2024-03-20T21:05:33.850' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (95, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:29:00.780' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (96, NULL, NULL, N'5,1', NULL, CAST(N'2024-04-01T15:29:31.007' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (97, NULL, NULL, N'5,1', NULL, CAST(N'2024-04-01T15:29:33.973' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (98, NULL, NULL, N'5,1', NULL, CAST(N'2024-04-01T15:29:35.443' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (99, NULL, NULL, N'5,1', NULL, CAST(N'2024-04-01T15:29:35.997' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (100, NULL, NULL, N'2', NULL, CAST(N'2024-04-01T15:29:43.860' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (101, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:29:54.880' AS DateTime), N'Fundacion', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (102, NULL, NULL, N'6', NULL, CAST(N'2024-04-01T15:30:01.140' AS DateTime), N'Fundacion', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (103, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:30:12.827' AS DateTime), N'Ciego', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (104, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:30:16.080' AS DateTime), N'ayuda', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (105, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:30:26.320' AS DateTime), N'Autista', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (106, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:30:38.613' AS DateTime), N'discapacidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (107, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:30:49.627' AS DateTime), N'eventos', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (108, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:30:56.123' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (109, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:31:08.970' AS DateTime), N'tecnologia+', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (110, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:31:10.797' AS DateTime), N'tecnologia', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (111, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:31:16.840' AS DateTime), N'tec', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (112, N'PostId', 5, NULL, NULL, CAST(N'2024-04-01T15:31:26.240' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (113, N'PostId', 5, NULL, NULL, CAST(N'2024-04-01T15:31:31.470' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (114, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:31:45.727' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (115, N'EventId', 4, NULL, NULL, CAST(N'2024-04-01T15:31:49.503' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (116, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:31:52.057' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (117, N'EventId', 2, NULL, NULL, CAST(N'2024-04-01T15:31:55.987' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (118, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:31:58.097' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (119, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:31:59.290' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (120, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:32:00.763' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (121, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:32:02.440' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (122, N'EventId', 2, NULL, NULL, CAST(N'2024-04-01T15:32:04.887' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (123, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:32:07.590' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (124, N'PostId', 3, NULL, NULL, CAST(N'2024-04-01T15:32:12.073' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (125, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T15:32:14.810' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (126, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T15:32:16.850' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (127, N'ContactId', 1, NULL, 1, CAST(N'2024-04-01T15:32:23.233' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (128, N'ContactId', 1, NULL, 1, CAST(N'2024-04-01T15:32:24.810' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (129, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T15:32:28.513' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (130, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:32:31.547' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (131, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:32:32.860' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (132, N'ContactId', 3, NULL, 3, CAST(N'2024-04-01T15:32:34.133' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (133, N'ContactId', 2, NULL, 2, CAST(N'2024-04-01T15:32:40.360' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (134, N'ContactId', 2, NULL, 2, CAST(N'2024-04-01T15:32:42.520' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (135, N'ContactId', 2, NULL, 2, CAST(N'2024-04-01T15:32:43.783' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (136, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:32:56.063' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (137, N'PostId', 1, NULL, NULL, CAST(N'2024-04-01T15:33:01.150' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (138, N'PostId', 1, NULL, NULL, CAST(N'2024-04-01T15:33:02.693' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (139, N'PostId', 1, NULL, NULL, CAST(N'2024-04-01T15:33:04.193' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (140, N'PostId', 1, NULL, NULL, CAST(N'2024-04-01T15:33:05.680' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (141, N'PostId', 1, NULL, NULL, CAST(N'2024-04-01T15:33:07.207' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (142, N'PostId', 2, NULL, NULL, CAST(N'2024-04-01T15:33:13.497' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (143, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T15:33:17.407' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (144, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T15:33:21.627' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (145, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T15:34:45.643' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (146, N'PostId', 6, NULL, 10, CAST(N'2024-04-01T15:43:26.720' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (147, N'PostId', 7, NULL, 10, CAST(N'2024-04-01T15:47:08.610' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (148, N'PostId', 8, NULL, 10, CAST(N'2024-04-01T15:49:07.930' AS DateTime), NULL, 5)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (149, N'EventId', 3, NULL, 10, CAST(N'2024-04-01T15:49:17.320' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (150, N'EventId', 8, NULL, 10, CAST(N'2024-04-01T15:52:49.130' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (151, N'EventId', 9, NULL, 10, CAST(N'2024-04-01T15:55:12.647' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (152, N'EventId', 10, NULL, 10, CAST(N'2024-04-01T15:58:16.410' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (153, N'EventId', 11, NULL, 10, CAST(N'2024-04-01T16:01:49.117' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (154, N'EventId', 12, NULL, 10, CAST(N'2024-04-01T16:03:24.993' AS DateTime), NULL, 2)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (155, N'ContactId', 1, NULL, 1, CAST(N'2024-04-01T16:04:02.373' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (156, N'PostId', 7, NULL, 1, CAST(N'2024-04-01T16:04:20.893' AS DateTime), NULL, 17)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (157, N'EventId', 8, NULL, 1, CAST(N'2024-04-01T16:04:56.083' AS DateTime), NULL, 16)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (158, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:05:31.190' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (159, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:05:33.093' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (160, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:05:35.320' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (161, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:05:36.713' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (162, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:05:38.127' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (163, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:05:54.070' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (164, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:05:55.143' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (165, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:05:56.900' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (166, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:05:57.943' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (167, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:05:59.327' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (168, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:06:00.417' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (169, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:06:25.883' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (170, N'PostId', 8, NULL, NULL, CAST(N'2024-04-01T16:06:30.940' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (171, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:06:32.967' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (172, N'PostId', 8, NULL, NULL, CAST(N'2024-04-01T16:06:37.420' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (173, N'PostId', 8, NULL, NULL, CAST(N'2024-04-01T16:06:38.983' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (174, N'PostId', 8, NULL, NULL, CAST(N'2024-04-01T16:06:40.057' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (175, N'PostId', 1, NULL, NULL, CAST(N'2024-04-01T16:06:51.420' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (176, N'EventId', 10, NULL, 10, CAST(N'2024-04-01T16:07:26.153' AS DateTime), NULL, 11)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (177, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:07:44.753' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (178, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:07:47.730' AS DateTime), N'Rompiendo ', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (179, N'PostId', 6, NULL, NULL, CAST(N'2024-04-01T16:07:53.330' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (180, N'PostId', 6, NULL, NULL, CAST(N'2024-04-01T16:07:55.337' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (181, N'PostId', 6, NULL, NULL, CAST(N'2024-04-01T16:07:56.377' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (182, N'PostId', 6, NULL, NULL, CAST(N'2024-04-01T16:07:57.543' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (183, N'PostId', 6, NULL, NULL, CAST(N'2024-04-01T16:07:58.950' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (184, N'PostId', 6, NULL, NULL, CAST(N'2024-04-01T16:08:01.520' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (185, N'PostId', 8, NULL, NULL, CAST(N'2024-04-01T16:08:04.570' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (186, N'PostId', 2, NULL, NULL, CAST(N'2024-04-01T16:08:08.233' AS DateTime), NULL, 12)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (187, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:08:19.847' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (188, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:08:22.297' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (189, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:08:24.263' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (190, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:08:25.513' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (191, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:08:26.783' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (192, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:08:27.990' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (193, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:08:55.083' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (194, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:09:35.150' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (195, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:09:36.110' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (196, N'ContactId', 9, NULL, 9, CAST(N'2024-04-01T16:09:41.323' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (197, N'ContactId', 9, NULL, 9, CAST(N'2024-04-01T16:09:42.187' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (198, N'ContactId', 9, NULL, 9, CAST(N'2024-04-01T16:09:43.363' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (199, N'ContactId', 9, NULL, 9, CAST(N'2024-04-01T16:09:44.723' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (200, N'ContactId', 9, NULL, 9, CAST(N'2024-04-01T16:09:46.133' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (201, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T16:09:55.887' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (202, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T16:09:57.143' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (203, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T16:09:58.117' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (204, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T16:09:59.397' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (205, N'ContactId', 4, NULL, 4, CAST(N'2024-04-01T16:10:00.747' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (206, N'ContactId', 8, NULL, 8, CAST(N'2024-04-01T16:10:07.120' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (207, N'ContactId', 8, NULL, 8, CAST(N'2024-04-01T16:10:07.747' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (208, N'ContactId', 8, NULL, 8, CAST(N'2024-04-01T16:10:08.760' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (209, N'ContactId', 8, NULL, 8, CAST(N'2024-04-01T16:10:09.743' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (210, N'ContactId', 8, NULL, 8, CAST(N'2024-04-01T16:10:11.000' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (211, N'ContactId', 8, NULL, 8, CAST(N'2024-04-01T16:10:11.927' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (212, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:14:04.967' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (213, N'ContactId', 10, NULL, 10, CAST(N'2024-04-01T16:14:06.387' AS DateTime), NULL, 13)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (214, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:14:43.317' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (215, NULL, NULL, N'6,5', NULL, CAST(N'2024-04-01T16:14:47.840' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (216, NULL, NULL, N'6,5', NULL, CAST(N'2024-04-01T16:14:50.523' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (217, NULL, NULL, N'6,5', NULL, CAST(N'2024-04-01T16:14:51.010' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (218, NULL, NULL, N'6,5', NULL, CAST(N'2024-04-01T16:14:51.520' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (219, NULL, NULL, N'6', NULL, CAST(N'2024-04-01T16:14:53.730' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (220, NULL, NULL, N'6', NULL, CAST(N'2024-04-01T16:14:53.913' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (221, NULL, NULL, N'6', NULL, CAST(N'2024-04-01T16:14:54.210' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (222, NULL, NULL, N'4', NULL, CAST(N'2024-04-01T16:14:58.597' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (223, NULL, NULL, N'4', NULL, CAST(N'2024-04-01T16:14:59.800' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (224, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:04.687' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (225, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:05.217' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (226, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:07.300' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (227, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:08.070' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (228, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:08.753' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (229, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:09.423' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (230, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:10.000' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (231, NULL, NULL, N'7', NULL, CAST(N'2024-04-01T16:15:11.433' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (232, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:36.717' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (233, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:37.440' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (234, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:37.907' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (235, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:38.410' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (236, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:38.850' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (237, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:39.330' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (238, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:39.817' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (239, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:40.267' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (240, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:40.713' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (241, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:41.153' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (242, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:41.583' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (243, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:42.067' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (244, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:42.640' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (245, NULL, NULL, N'8,7', NULL, CAST(N'2024-04-01T16:15:43.073' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (246, NULL, NULL, N'8', NULL, CAST(N'2024-04-01T16:15:53.187' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (247, NULL, NULL, N'8', NULL, CAST(N'2024-04-01T16:15:53.700' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (248, NULL, NULL, N'4,2', NULL, CAST(N'2024-04-01T16:15:58.787' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (249, NULL, NULL, N'4,2', NULL, CAST(N'2024-04-01T16:15:59.383' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (250, NULL, NULL, N'4,2', NULL, CAST(N'2024-04-01T16:15:59.763' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (251, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:16:38.200' AS DateTime), N'Diversidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (252, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:16:57.070' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (253, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:17:26.260' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (254, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:17:34.400' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (255, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:18:05.493' AS DateTime), N'Diversidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (256, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:18:12.093' AS DateTime), N'Diversidad', 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (257, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:18:29.073' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (258, NULL, NULL, NULL, NULL, CAST(N'2024-04-01T16:18:37.730' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (259, NULL, NULL, NULL, NULL, CAST(N'2024-04-05T20:29:03.520' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (260, NULL, NULL, NULL, NULL, CAST(N'2024-04-05T20:29:57.550' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (261, N'ContactId', 4, NULL, 4, CAST(N'2024-04-05T20:30:40.840' AS DateTime), NULL, 18)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (262, NULL, NULL, NULL, NULL, CAST(N'2024-04-05T20:30:46.137' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (263, NULL, NULL, NULL, NULL, CAST(N'2024-04-05T20:33:55.097' AS DateTime), NULL, 1)
GO
INSERT [dbo].[ActionLog] ([ActionLogId], [ObjectKey], [ObjectId], [filters], [ContactId], [DateEntered], [SearchText], [ActionTypeId]) VALUES (264, N'ContactId', 4, NULL, 4, CAST(N'2024-04-06T19:34:08.840' AS DateTime), NULL, 18)
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
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (16, N'Rechazar Evento')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (17, N'Rechazar Contenido')
GO
INSERT [dbo].[ActionType] ([ActionTypeId], [Description]) VALUES (18, N'Inicio de Sesión')
GO
SET IDENTITY_INSERT [dbo].[ActionType] OFF
GO
SET IDENTITY_INSERT [dbo].[Contacts] ON 
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (1, N'Administrador', N'ParImpar', CAST(N'2024-02-21T20:42:28.987' AS DateTime), N'comunidadparimpar@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'Administrador', CAST(N'2024-02-21' AS Date), 1, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (2, N'Macarena', N'Vaca', CAST(N'2024-02-24T20:03:09.230' AS DateTime), N'macarenavaca.mv@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'mvaca', NULL, 1, 1, 1, NULL, N'F3E7F5E5-8501-47AB-92C3-2E4208207FDF', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (3, N'Moly', N'Simone', CAST(N'2024-03-17T11:19:03.187' AS DateTime), N'molysimone13@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'msimone13', NULL, NULL, 1, NULL, 1, N'4EB2AB32-61EE-46A9-AB22-0EE6F4D56A5B', NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_3.jpeg', CAST(N'2024-03-17T13:57:16.217' AS DateTime), NULL, NULL, N'Fundación Inmula', N'Ciudad Autónoma de Buenos Aires', N'http://fundacioninmula.org', N'En la Fundación Inmula, creemos en el poder transformador del potencial humano. Nos dedicamos a brindar oportunidades de desarrollo integral a personas con discapacidades, permitiéndoles brillar con todo su esplendor. A través de programas educativos, culturales y deportivos, ayudamos a nuestros beneficiarios a descubrir y potenciar sus talentos únicos. Nuestro objetivo es guiar a cada estrella en ascenso hacia un futuro lleno de logros y realización personal, demostrando que el cielo no es el límite cuando se trata de alcanzar sus sueños.', NULL, NULL, N'https://www.linkedin.com/company/fundacioninmula/', NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (4, N'Julieta', N'Dagostino', CAST(N'2024-03-17T20:29:02.817' AS DateTime), N'judagostino96@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'jdagostino', NULL, NULL, 1, NULL, 1, N'6971130B-66AE-4DC2-9181-90C0BD19ECDE', NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_4.png', CAST(N'2024-03-17T20:42:18.540' AS DateTime), NULL, NULL, N'Fundación Cordis', N'Carlos Pellegrini 677', N'http://www.fundacioncordis.com.ar', N'En la Fundacion Cordis construimos puentes hacia un mañana más brillante para las personas con discapacidad. Nos comprometemos a tender una mano solidaria a aquellos que enfrentan desafíos físicos, emocionales y sociales. Nuestros programas se centran en proporcionar apoyo emocional, capacitación laboral y acceso a servicios médicos para promover la autonomía y la inclusión. Con cada puente que construimos, estamos tejiendo una red de esperanza y oportunidades que conecta a personas de todas las habilidades en un viaje hacia un futuro lleno de posibilidades infinitas.<br>', N'https://facebook.com/fundacion-cordis', N'https://instagram.com/fundacion-cordis', NULL, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (8, N'Pedro', N'Gomez', CAST(N'2024-03-17T20:47:13.133' AS DateTime), N'pedro.gomez_123@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'pgomez', CAST(N'1992-10-05' AS Date), NULL, 1, NULL, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_8.png', CAST(N'2024-03-17T21:01:34.867' AS DateTime), NULL, NULL, N'Fundacion Seal', NULL, NULL, N'Creemos en la libertad como un derecho fundamental de todas las personas. Nos dedicamos a empoderar a individuos con discapacidad para que alcancen nuevas alturas y persigan sus sueños con valentía y determinación. A través de programas de capacitación laboral, acceso a la tecnología asistiva y promoción de derechos, estamos liberando el potencial humano y derribando barreras. Nuestro compromiso es ser el impulso que necesitan aquellos que desean volar alto y alcanzar sus metas, demostrando que con alas de libertad, el cielo es el límite.', N'https://www.facebook.com/fundacionseal/', NULL, NULL, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (9, N'Elena', N'García', CAST(N'2024-03-17T19:47:55.000' AS DateTime), N'elena.garcia.1993@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'ElenaG', CAST(N'1993-01-08' AS Date), NULL, 1, NULL, 1, NULL, NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_9.jpg', CAST(N'2024-03-17T21:11:12.053' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (10, N'Gaston', N'Vottero', CAST(N'2024-04-01T15:34:10.017' AS DateTime), N'gastonlvottero@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'GVottero', NULL, NULL, 1, NULL, NULL, N'5BE35911-1ED5-4B56-9439-4BC854075D3F', NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_10.png', NULL, NULL, NULL, N'Horizontes Inclusivos', N'Domingo F. Sarmiento 1500, Córdoba', NULL, N'"Horizontes Inclusivos" es una fundación dedicada a promover la inclusión y el bienestar de las personas con discapacidad en nuestra comunidad. Nuestro compromiso radica en construir un mundo donde todas las personas, independientemente de sus capacidades, tengan igualdad de oportunidades para desarrollarse plenamente. A través de programas de apoyo integral, educación, sensibilización y promoción de políticas inclusivas, trabajamos para derribar barreras y crear un entorno que valore la diversidad y respete los derechos de cada individuo. Juntos, estamos ampliando los horizontes de posibilidades para una sociedad más justa y equitativa.', NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Contacts] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactXEvent] ON 
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (1, 9, 1, CAST(N'2024-03-17T21:10:36.077' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (2, 4, 1, CAST(N'2024-03-17T21:26:31.107' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (3, 10, 3, CAST(N'2024-04-01T15:49:21.027' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (4, 10, 6, CAST(N'2024-04-01T15:49:22.957' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (5, 10, 4, CAST(N'2024-04-01T15:49:26.007' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXEvent] ([ContactEventId], [ContactId], [EventId], [DateEntered], [DateCancellation]) VALUES (6, 10, 10, CAST(N'2024-04-01T16:07:24.223' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[ContactXEvent] OFF
GO
SET IDENTITY_INSERT [dbo].[ContactXTypeImplairment] ON 
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (1, 4, 6, CAST(N'2024-03-17T21:14:42.460' AS DateTime), NULL)
GO
INSERT [dbo].[ContactXTypeImplairment] ([ContactTypeImplairmentId], [ContactId], [TypeId], [DateEntered], [DateDelete]) VALUES (2, 4, 7, CAST(N'2024-03-17T21:14:42.460' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[ContactXTypeImplairment] OFF
GO
SET IDENTITY_INSERT [dbo].[DenyObject] ON 
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'EventId', 7, N'no cumple con politicas', NULL, 1)
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'PostId', 7, N'Imagen muy pequeña', NULL, 2)
GO
INSERT [dbo].[DenyObject] ([ObjectKey], [ObjectId], [Reason], [ContactId], [DenyObject]) VALUES (N'EventId', 8, N'Imagen muy pequeña', NULL, 3)
GO
SET IDENTITY_INSERT [dbo].[DenyObject] OFF
GO
SET IDENTITY_INSERT [dbo].[Events] ON 
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (1, N'Únete a la Empleo Inclusivo Expo 2024, donde empresas comprometidas con la diversidad y la inclusión se conectan con talentosos profesionales con discapacidad. El temario incluirá charlas sobre adaptaciones laborales, programas de inclusión en el lugar de trabajo, estrategias de reclutamiento inclusivo, desarrollo de habilidades profesionales para personas con discapacidad y testimonios inspiradores de empleados con discapacidad.<br>', N'Feria de Empleo para Personas con Discapacidad', CAST(N'2024-03-17T20:20:00.437' AS DateTime), CAST(N'2024-03-20T10:00:00.000' AS DateTime), CAST(N'2024-03-22T18:00:00.000' AS DateTime), 3, 2, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_1.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (2, N'Únete a nuestra caminata anual por la inclusión, donde personas de todas las habilidades se unen para promover la conciencia, la aceptación y la igualdad. El temario incluirá discursos motivacionales, testimonios de personas con discapacidad, actividades de sensibilización, información sobre derechos y recursos para la inclusión y entretenimiento inclusivo para todas las edades.<br>', N'Pasos hacia la Inclusión 2024', CAST(N'2024-03-17T20:23:40.343' AS DateTime), CAST(N'2024-04-09T07:00:00.000' AS DateTime), CAST(N'2024-04-09T17:00:00.000' AS DateTime), 3, 2, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_2.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (3, N'Descubre cómo hacer que el turismo sea accesible para todos en Turismo para Todos 2024. El temario incluirá sesiones sobre diseño de destinos accesibles, transporte adaptado, alojamientos inclusivos, turismo cultural para personas con discapacidad, legislación turística y casos de éxito en la promoción del turismo accesible.<br>', N'Simposio sobre Accesibilidad en el Turismo', CAST(N'2024-03-17T20:31:41.463' AS DateTime), CAST(N'2024-04-11T16:00:00.000' AS DateTime), CAST(N'2024-04-11T20:00:00.000' AS DateTime), 4, 2, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_3.png', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (4, N'Únete a nosotros en TechAccess 2024, donde líderes en tecnología y discapacidad se reúnen para explorar innovaciones, mejores prácticas y soluciones para mejorar la accesibilidad en el mundo digital y físico. El temario incluirá sesiones sobre diseño universal, desarrollo de aplicaciones inclusivas, avances en dispositivos adaptativos, legislación sobre accesibilidad y casos de estudio de proyectos exitosos de inclusión tecnológica.<br>', N'TechAccess 2024', CAST(N'2024-03-17T20:32:54.740' AS DateTime), CAST(N'2024-04-26T10:00:00.000' AS DateTime), CAST(N'2024-04-26T18:00:00.000' AS DateTime), 4, 2, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_4.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (5, N'Sumérgete en el poder del cine para promover la inclusión en el Cine para Todos Festival 2024. El temario incluirá proyecciones de películas con temáticas de discapacidad, paneles de discusión con directores y actores, talleres sobre representación en el cine, accesibilidad en las salas de cine y producción cinematográfica inclusiva.', N' Cine para Todos Festival 2024', CAST(N'2024-03-17T20:52:39.660' AS DateTime), CAST(N'2024-03-25T20:00:00.000' AS DateTime), CAST(N'2024-03-26T00:00:00.000' AS DateTime), 8, NULL, 1, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_5.png', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (6, N'Únete a nosotros para Conciencia CP 2024, una semana dedicada a educar, inspirar y conectar a la comunidad sobre la parálisis cerebral. El temario incluirá charlas médicas sobre diagnóstico y tratamiento, talleres de terapia ocupacional y fisioterapia, testimonios de personas con parálisis cerebral y sus familias, y actividades de sensibilización sobre inclusión.<br>', N'Semana de Concientización sobre la Parálisis Cerebral', CAST(N'2024-03-17T20:54:24.230' AS DateTime), CAST(N'2024-04-15T10:00:00.000' AS DateTime), CAST(N'2024-04-16T18:00:00.000' AS DateTime), 8, 2, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_6.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (7, N'Descubre el poder del arte como herramienta terapéutica en Expresarte, un taller diseñado especialmente para personas con autismo. El temario incluirá sesiones sobre técnicas de arte terapéutico, comunicación a través del arte, expresión emocional, desarrollo de la autoestima y ejercicios prácticos de creación artística adaptados a las necesidades individuales.', N'Taller de Arte Terapéutico para Personas con Autismo', CAST(N'2024-03-17T20:55:59.347' AS DateTime), CAST(N'2024-04-03T16:00:00.000' AS DateTime), CAST(N'2024-04-03T19:00:00.000' AS DateTime), 8, 2, 3, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_7.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (8, N'Esta conferencia se centrará en estrategias y mejores prácticas para fomentar la inclusión laboral de personas con discapacidad en el mercado laboral. Se abordarán temas como adaptaciones en el lugar de trabajo, políticas de contratación inclusivas y el impacto positivo de la diversidad en las organizaciones.', N'Conferencia sobre Inclusión Laboral de Personas con Discapacidad', CAST(N'2024-04-01T15:52:49.130' AS DateTime), CAST(N'2024-05-10T10:00:00.000' AS DateTime), CAST(N'2024-05-10T12:00:00.000' AS DateTime), 10, 1, 3, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_8.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (9, N'Este taller tiene como objetivo aumentar la conciencia sobre las discapacidades invisibles, como las enfermedades mentales, la fibromialgia y el síndrome de fatiga crónica. Se proporcionarán herramientas prácticas para apoyar a personas con discapacidades invisibles en entornos personales y laborales.', N'Taller de Sensibilización sobre Discapacidad Invisible', CAST(N'2024-04-01T15:55:12.647' AS DateTime), CAST(N'2024-05-18T14:00:00.000' AS DateTime), CAST(N'2024-05-18T16:00:00.000' AS DateTime), 10, 1, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_9.png', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (10, N'Únete a nosotros en esta feria dedicada a la tecnología accesible diseñada para mejorar la calidad de vida de personas con discapacidad. Habrá demostraciones de dispositivos y aplicaciones innovadoras, así como oportunidades para interactuar con expertos en tecnología inclusiva y aprender sobre las últimas tendencias en este campo en constante evolución.', N'Feria de Tecnología Accesible para Personas con Discapacidad', CAST(N'2024-04-01T15:58:16.410' AS DateTime), CAST(N'2024-05-25T11:00:00.000' AS DateTime), CAST(N'2024-05-25T15:00:00.000' AS DateTime), 10, 1, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_10.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (11, N'Únete a nuestro seminario web donde expertos en urbanismo y accesibilidad discutirán la importancia de diseñar entornos urbanos accesibles para personas con discapacidad. Se abordarán temas como la accesibilidad peatonal, el diseño de espacios públicos inclusivos y la eliminación de barreras arquitectónicas. Además, se presentarán casos de estudio y se compartirán mejores prácticas para crear ciudades más inclusivas y accesibles para todos.', N'Seminario Web: Accesibilidad en el Diseño Urbano', CAST(N'2024-04-01T16:01:49.117' AS DateTime), CAST(N'2024-06-07T15:00:00.000' AS DateTime), CAST(N'2024-06-07T17:00:00.000' AS DateTime), 10, 1, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_11.jpg', NULL)
GO
INSERT [dbo].[Events] ([EventId], [Description], [Title], [DateEntered], [StartDate], [EndDate], [ContacCreate], [ContactAudit], [StateId], [DateModify], [ImageUrl], [DateDeleted]) VALUES (12, N'Te invitamos a nuestro ciclo de cine dedicado a celebrar la diversidad funcional y explorar las experiencias de personas con discapacidad a través del cine. Proyectaremos una selección de películas que destacan las luchas, triunfos y vivencias de individuos con discapacidad de diversas comunidades y culturas. Tras la proyección, habrá un espacio para discutir y reflexionar sobre las temáticas presentadas en las películas, promoviendo la sensibilización y el entendimiento.', N'Ciclo de Cine: Celebrando la Diversidad Funcional', CAST(N'2024-04-01T16:03:24.990' AS DateTime), CAST(N'2024-06-14T18:30:00.000' AS DateTime), CAST(N'2024-06-14T22:00:00.000' AS DateTime), 10, 1, 2, NULL, N'http://comunidad-parimpar.com.ar/Events/EventId_12.jpeg', NULL)
GO
SET IDENTITY_INSERT [dbo].[Events] OFF
GO
INSERT [dbo].[MailExecutions] ([Send], [LastExecution]) VALUES (N'SendNotificy', CAST(N'2024-03-17T21:26:47.383' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (1, N'En esta publicación, exploraremos los últimos avances en tecnología diseñada para mejorar la calidad de vida de las personas con discapacidad visual. Desde dispositivos de asistencia hasta aplicaciones innovadoras, descubre cómo la tecnología está desempeñando un papel crucial en la inclusión y el empoderamiento de la comunidad con discapacidad visual. Acompáñanos en este viaje hacia un mundo más accesible e inclusivo.', N'En el ámbito de la discapacidad visual, la tecnología ha emergido como una herramienta revolucionaria para superar barreras. A lo largo de esta investigación, exploraremos dispositivos como lectores de pantalla, sistemas de navegación por voz y aplicaciones móviles diseñadas específicamente para mejorar la independencia y la participación en la sociedad de las personas con discapacidad visual.<br><br>La evolución de la inteligencia artificial ha permitido la creación de tecnologías cada vez más sofisticadas. Analizaremos cómo los algoritmos de reconocimiento de objetos y la realidad aumentada están siendo implementados para facilitar tareas diarias, desde identificar objetos hasta navegar por entornos desconocidos. Estos avances no solo brindan nuevas oportunidades, sino que también fomentan la autonomía y la igualdad de oportunidades.Además, nos sumergiremos en proyectos de investigación que buscan desarrollar interfaces cerebro-máquina para personas con discapacidad visual. Estas interfaces tienen el potencial de traducir la actividad cerebral en comandos ejecutables, abriendo nuevas posibilidades para la interacción con dispositivos y entornos digitales.<br><br>En el contexto de la educación, examinaremos plataformas educativas accesibles que utilizan tecnologías de voz y braille digital para garantizar que las personas con discapacidad visual tengan acceso equitativo a la información. Destacaremos programas pioneros que promueven la inclusión educativa y la capacitación laboral para mejorar las perspectivas de empleo.Esta publicación también abordará los desafíos éticos asociados con el uso de tecnologías asistivas, destacando la importancia de la privacidad y la seguridad en el diseño de estas soluciones. <br>Al mismo tiempo, reflexionaremos sobre cómo la sociedad puede avanzar hacia un futuro más inclusivo, donde la tecnología se utilice como una herramienta para derribar barreras y fomentar la diversidad.<br><br>En resumen, este análisis exhaustivo busca arrojar luz sobre la intersección entre la tecnología y la discapacidad visual, destacando tanto los logros actuales como las oportunidades futuras para mejorar la calidad de vida de las personas con esta discapacidad. Acompáñanos en este viaje hacia un mundo más inclusivo, donde la innovación tecnológica se convierte en un catalizador para el cambio positivo.', N'Avances en la Integración Tecnológica para Personas con Discapacidad Visual', CAST(N'2024-03-17T11:22:08.600' AS DateTime), NULL, 3, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_1.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (2, N'En el viaje hacia la inclusión, es esencial entender las diversas realidades que enfrentan las personas con diversidad funcional. Desde desafíos físicos hasta barreras comunicativas, cada experiencia es única y merece ser comprendida. ¡Acompáñanos en este recorrido para conocer más sobre estos aspectos cruciales de la diversidad funcional!<br>', N'En nuestra sociedad, la diversidad funcional abarca una amplia gama de condiciones que afectan la movilidad, la comunicación y la interacción social. Es esencial comprender y apreciar las diversas formas en que estas condiciones impactan la vida diaria de las personas y cómo podemos trabajar juntos para crear entornos más inclusivos.<br><br>La discapacidad motora, por ejemplo, puede presentar desafíos significativos en términos de acceso físico y movilidad. Desde la necesidad de rampas y ascensores hasta adaptaciones en el transporte público, hay una variedad de formas en que podemos mejorar la accesibilidad para aquellos con discapacidades motoras.<br><br>Por otro lado, la discapacidad psíquica puede manifestarse de muchas maneras diferentes, desde trastornos del espectro autista hasta trastornos de ansiedad y depresión. Es crucial desterrar el estigma asociado con estas condiciones y promover la comprensión y el apoyo adecuados.<br><br>La discapacidad auditiva y del habla también presentan desafíos únicos en términos de comunicación y acceso a la información. La disponibilidad de intérpretes de lenguaje de señas y tecnología de asistencia auditiva puede marcar una gran diferencia en la vida de las personas con estas discapacidades.<br><br>Al comprender y abordar las necesidades específicas de cada tipo de discapacidad, podemos avanzar hacia una sociedad más inclusiva y accesible para todos. La diversidad funcional es una parte fundamental de la experiencia humana, y es nuestro deber trabajar juntos para garantizar que todas las personas, independientemente de su capacidad, tengan igualdad de oportunidades y acceso a todos los aspectos de la vida. ¡Juntos, estamos abriendo caminos hacia un futuro más inclusivo y accesible para todos!<br>', N'¡Abriendo Caminos! Explorando la Realidad de las Personas con Diversidad Funcional', CAST(N'2024-03-17T20:35:26.547' AS DateTime), NULL, 4, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_2.png', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (3, N'El autismo es un trastorno del neurodesarrollo que afecta a millones de personas en todo el mundo. En este post, nos sumergiremos en la complejidad y la diversidad del espectro autista, desafiando los estereotipos y explorando cómo podemos apoyar mejor a las personas con autismo en nuestra comunidad.', N'El trastorno del espectro autista (TEA) es un término que engloba una amplia gama de condiciones caracterizadas por desafíos en la comunicación, la interacción social y el comportamiento. Es importante comprender que el autismo se manifiesta de manera diferente en cada persona, lo que refleja la diversidad de la neurodiversidad.<br><br>Uno de los mitos más comunes sobre el autismo es que todas las personas en el espectro tienen habilidades extraordinarias en áreas específicas. Si bien algunas personas con autismo pueden tener talentos excepcionales, no todas las personas en el espectro tienen estas habilidades. Es crucial reconocer y valorar a cada persona en función de sus propias fortalezas y desafíos individuales.<br><br>La inclusión es fundamental para apoyar a las personas con autismo. Esto significa crear entornos que sean accesibles y acogedores para todos, independientemente de sus diferencias neurodiversas. La educación y la concienciación son herramientas poderosas para fomentar la inclusión y la aceptación en nuestra sociedad.<br><br>Es importante recordar que las personas con autismo tienen mucho que ofrecer a nuestra comunidad. Su forma única de ver el mundo puede aportar nuevas perspectivas y enriquecer nuestras vidas de formas inesperadas. Al educarnos y mostrar empatía hacia las experiencias de las personas con autismo, podemos construir un mundo más inclusivo y compasivo para todos.<br>', N' Explorando el Mundo del Autismo: Más Allá de los Estereotipos', CAST(N'2024-03-17T20:36:35.233' AS DateTime), NULL, 4, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_3.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (4, N'¡Descubre las historias que desafían los límites y celebran la fuerza del espíritu humano en nuestro nuevo libro, ''Superando Obstáculos: Historias de Fortaleza y Resiliencia en la Discapacidad Motora''! Sumérgete en relatos inspiradores que narran la vida de personas con discapacidades motoras, destacando su valentía, determinación y capacidad para superar cualquier obstáculo. Desde hazañas deportivas hasta logros profesionales, estas historias iluminan el camino hacia la inclusión y el empoderamiento. ¡Una lectura que te llenará de inspiración y renovará tu fe en el poder del individuo para triunfar sobre la adversidad!', N'Introducción:<br>En el fascinante viaje de la vida, nos encontramos con individuos cuya determinación y coraje nos dejan sin aliento. En este libro, "Superando Obstáculos: Historias de Fortaleza y Resiliencia en la Discapacidad Motora", exploramos las vidas de personas que desafían los límites impuestos por la discapacidad motora, demostrando que el verdadero poder reside en la mente y el espíritu.<br>Capítulo 1: Más allá de las Limitaciones Físicas:<br>Sumérgete en la vida de individuos cuyas historias de triunfo sobre la discapacidad motora inspiran y conmueven. Desde atletas paralímpicos que desafían la gravedad hasta artistas cuya creatividad no conoce fronteras, descubre cómo estas personas convierten los desafíos en oportunidades para brillar.<br>Capítulo 2: Educación, Empleo y Empoderamiento:<br>Exploramos cómo la educación inclusiva y las oportunidades laborales equitativas están transformando la vida de personas con discapacidad motora. A través de testimonios y experiencias personales, observamos cómo el acceso a la educación y al empleo no solo brinda independencia económica, sino que también promueve la igualdad y la diversidad en nuestra sociedad.<br>Capítulo 3: La Fuerza del Apoyo y la Comunidad:<br>Ningún viaje se realiza solo, y estas historias destacan la importancia del apoyo familiar, la comunidad y las organizaciones de apoyo en el camino hacia la superación. Desde padres que desafían las expectativas hasta amigos y vecinos que se unen en solidaridad, estas conexiones humanas fundamentales ilustran el poder transformador del amor y la solidaridad.<br>Capítulo 4: Liderando el Cambio:<br>En este capítulo, exploramos cómo los defensores de los derechos de las personas con discapacidad motora están liderando el cambio en la sociedad. Desde activistas que luchan por la accesibilidad hasta legisladores que promulgan políticas inclusivas, estas historias muestran cómo la determinación individual puede inspirar movimientos sociales y crear un mundo más inclusivo para todos.', N'Superando Obstáculos: Historias de Fortaleza y Resiliencia en la Discapacidad Motora', CAST(N'2024-03-17T20:58:45.017' AS DateTime), NULL, 8, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_4.png', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (5, N'Exploraremos en profundidad estrategias innovadoras y prácticas efectivas para apoyar a estudiantes con Trastorno del Espectro Autista (TEA) en entornos educativos. Desde adaptaciones curriculares hasta programas de intervención temprana, descubre cómo podemos crear ambientes inclusivos que potencien el aprendizaje y el desarrollo social de estos estudiantes. Únete a nosotros para promover la igualdad educativa.', N'La inclusión educativa es un aspecto crucial de la igualdad para todos los estudiantes, y en este artículo, nos enfocaremos en abordar específicamente las necesidades de aquellos con Trastorno del Espectro Autista (TEA). Examincaremos estrategias efectivas que van desde la adaptación de material didáctico hasta la implementación de programas de intervención temprana<br><br>Comenzaremos destacando la importancia de crear entornos de aprendizaje que sean visualmente estructurados y predecibles, proporcionando a los estudiantes con TEA un marco que facilite su comprensión del entorno escolar. Analizaremos cómo la implementación de rutinas y horarios visuales puede contribuir a la reducción de la ansiedad y mejorar la participación activa en el aula.<br><br>La colaboración entre docentes, profesionales de la salud y familias será un punto central en nuestra exploración. Discutiremos modelos exitosos de trabajo en equipo que promueven una comprensión profunda de las necesidades individuales de cada estudiante con TEA. Además, examinaremos estrategias para fomentar la comunicación efectiva, tanto verbal como no verbal, dentro del entorno escolar.<br><br>Nos sumergiremos en investigaciones recientes que destacan la eficacia de las intervenciones conductuales y terapias centradas en el juego para mejorar las habilidades sociales y emocionales de los estudiantes con TEA. Además, exploraremos la implementación de tecnologías asistivas y aplicaciones diseñadas para apoyar el aprendizaje y la comunicación.<br><br>En el ámbito de la capacitación del personal educativo, discutiremos programas de formación que promueven la conciencia y la comprensión del TEA. Destacaremos la importancia de la empatía y la flexibilidad en la enseñanza, reconociendo la diversidad de estilos de aprendizaje y adaptándose a las necesidades individuales.<br><br>En conclusión, este artículo busca proporcionar a educadores, padres y profesionales de la salud herramientas prácticas y conocimientos fundamentales para crear ambientes educativos inclusivos y apoyar el desarrollo pleno de estudiantes con Trastorno del Espectro Autista. Únete a nosotros en este viaje hacia una educación más equitativa y comprensiva para todos.', N'Inclusión Educativa: Estrategias para Apoyar a Estudiantes con Trastorno del Espectro Autista (TEA)', CAST(N'2024-03-17T21:00:13.460' AS DateTime), NULL, 8, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_5.jpg', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (6, N'Esta publicación se adentra en la experiencia de vivir con Trastorno del Espectro Autista (TEA). Explora los desafíos cotidianos, los estigmas sociales y las percepciones erróneas que rodean al autismo. También destaca los éxitos y las contribuciones significativas que las personas con TEA hacen a la sociedad. Desde estrategias de afrontamiento hasta formas de promover la inclusión, esta publicación ofrece una visión completa y compasiva del autismo.', N'Introducción:<br>El Trastorno del Espectro Autista (TEA) es una condición neurobiológica que afecta la forma en que una persona interactúa, se comunica y percibe el mundo que le rodea. Vivir con TEA puede presentar desafíos únicos, pero también está lleno de posibilidades y potencialidades que a menudo pasan desapercibidas por la sociedad en general. Esta publicación se sumerge en la experiencia de vivir con autismo, explorando tanto los aspectos difíciles como los triunfos significativos que acompañan a esta condición.<br><br>Explorando los Desafíos Cotidianos:<br>Las personas con TEA enfrentan una serie de desafíos en su vida diaria, desde la comunicación y la interacción social hasta la sensibilidad sensorial y la adaptación a cambios inesperados. La falta de comprensión y aceptación por parte de la sociedad puede complicar aún más estas dificultades, lo que lleva a sentimientos de aislamiento y marginación. Es fundamental abordar estos desafíos desde una perspectiva empática y comprensiva para construir un entorno más inclusivo y accesible para todos.<br><br>Superando Estigmas Sociales:<br>El autismo ha sido históricamente malinterpretado y estigmatizado, lo que ha llevado a la discriminación y al estigma social hacia las personas con TEA. Romper estos estigmas requiere un esfuerzo conjunto de educación, concienciación y promoción de la aceptación y la diversidad. Celebrar las diferencias y reconocer el valor único que cada persona aporta a la sociedad es fundamental para construir una comunidad más inclusiva y acogedora.<br><br>Destacando las Contribuciones Significativas:<br>A pesar de los obstáculos que enfrentan, las personas con TEA hacen contribuciones valiosas y significativas a la sociedad en diversos campos, desde el arte y la tecnología hasta la ciencia y la educación. Reconocer y celebrar estas contribuciones es esencial para promover la inclusión y el respeto hacia todas las personas, independientemente de su capacidad.<br><br>Promoviendo la Inclusión y la Celebración de la Diversidad:<br>Desde estrategias de afrontamiento hasta formas de promover la inclusión, es crucial abogar por políticas y prácticas que apoyen a las personas con TEA en su búsqueda de una vida plena y significativa. Fomentar la comprensión, la empatía y el respeto mutuo es fundamental para crear un mundo donde todas las personas sean valoradas y respetadas por igual.<br><br>Conclusión:<br>En última instancia, vivir con autismo es una experiencia única y valiosa que merece ser reconocida, respetada y celebrada. Al romper barreras y promover la inclusión, podemos construir un mundo donde todas las personas, independientemente de su capacidad, tengan la oportunidad de florecer y alcanzar su máximo potencial.', N'Viviendo con Autismo: Rompiendo Barreras y Celebrando Diferencias', CAST(N'2024-04-01T15:43:26.717' AS DateTime), NULL, 10, 1, N'http://comunidad-parimpar.com.ar/Posts/PostId_6.png', 2, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (7, N'Esta publicación ilumina la experiencia de vivir con una discapacidad visual, explorando cómo las personas con esta condición navegan por un mundo predominantemente visual. Desde el aprendizaje de habilidades de movilidad hasta el acceso a la tecnología asistencial, se examinan los desafíos y triunfos que acompañan a la pérdida de la vista. Además, se aborda la importancia de la educación pública sobre la inclusión y la accesibilidad para crear un entorno más equitativo.', N'Explorando el Mundo de las Discapacidades Visuales: Más Allá de la Oscuridad<br><br>En nuestra sociedad predominantemente visual, la experiencia de vivir con una discapacidad visual conlleva desafíos únicos y una riqueza de perspectivas que a menudo pasan desapercibidas. En esta publicación, nos sumergimos en el mundo de las personas que enfrentan la pérdida de la vista, explorando cómo navegan por un entorno diseñado principalmente para aquellos que pueden ver.<br><br>Desafíos y Triunfos<br><br>Desde el momento en que se diagnostica una discapacidad visual, comienza un viaje lleno de desafíos y triunfos. La adaptación a la pérdida de la vista implica aprender nuevas habilidades de movilidad, como el uso del bastón o la orientación con la ayuda de guías caninos. Cada paso hacia la independencia y la autonomía representa una victoria sobre las limitaciones impuestas por la discapacidad.<br><br>Sin embargo, estos logros no vienen sin obstáculos. La falta de accesibilidad en entornos públicos y digitales puede dificultar enormemente la participación plena en la sociedad. Desde la falta de rampas adecuadas hasta la ausencia de tecnología asistencial en línea, muchas personas con discapacidades visuales enfrentan barreras significativas en su día a día.<br><br>Tecnología Asistencial y Accesibilidad<br><br>La tecnología juega un papel fundamental en la vida de quienes viven con discapacidades visuales. Desde lectores de pantalla en dispositivos electrónicos hasta sistemas de navegación por voz, las innovaciones tecnológicas han revolucionado la forma en que las personas ciegas o con baja visión interactúan con el mundo que les rodea. Sin embargo, el acceso a estas herramientas sigue siendo limitado para muchos debido a barreras financieras o educativas.<br><br>Educación e Inclusión<br><br>La inclusión y la accesibilidad son elementos fundamentales para garantizar que las personas con discapacidades visuales puedan participar plenamente en la sociedad. La educación pública sobre la importancia de la inclusión y la sensibilización hacia las necesidades de las personas con discapacidades visuales es esencial para crear un entorno más equitativo y accesible para todos.<br><br>En resumen, esta publicación busca arrojar luz sobre la experiencia de vivir con una discapacidad visual, destacando tanto los desafíos como los triunfos que acompañan a la pérdida de la vista. Al explorar temas como la tecnología asistencial, la accesibilidad y la inclusión, esperamos fomentar una mayor comprensión y empatía hacia las personas que enfrentan estas realidades cotidianas.', N'Explorando el Mundo de las Discapacidades Visuales: Más Allá de la Oscuridad', CAST(N'2024-04-01T15:47:08.597' AS DateTime), NULL, 10, 1, N'http://comunidad-parimpar.com.ar/Posts/PostId_7.jpg', 3, NULL)
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (8, N'Esta publicación desmonta los estigmas en torno a las discapacidades intelectuales, destacando las habilidades, talentos y contribuciones significativas de las personas que viven con estas condiciones. Desde el acceso a la educación inclusiva hasta la promoción de oportunidades laborales, se explora cómo la sociedad puede apoyar y celebrar la diversidad de habilidades cognitivas. Además, se examinan las políticas y prácticas necesarias para fomentar un mundo más inclusivo y accesible para todos.', N'<br>En la sociedad actual, persisten numerosos estigmas en torno a las discapacidades intelectuales, que a menudo llevan a la marginación y la discriminación de quienes viven con estas condiciones. Sin embargo, es fundamental desafiar estos estereotipos y reconocer el valor intrínseco de cada individuo, independientemente de sus habilidades cognitivas.<br><br>Esta publicación busca ofrecer una mirada profunda y reflexiva sobre las capacidades de las personas con discapacidades intelectuales, destacando sus habilidades, talentos y contribuciones significativas a la sociedad. A través de una exploración minuciosa, se pretende desmontar los prejuicios arraigados y fomentar un ambiente de aceptación y apoyo.<br><br>En primer lugar, es crucial reconocer que las personas con discapacidades intelectuales poseen una amplia gama de habilidades y talentos. Desde habilidades artísticas y creativas hasta capacidades sociales y emocionales, cada individuo tiene algo único que ofrecer al mundo. Esta publicación destaca ejemplos concretos de personas con discapacidades intelectuales que han sobresalido en diversos campos, desafiando así las expectativas limitadas impuestas por la sociedad.<br><br>Además, se aborda la importancia del acceso a una educación inclusiva y de calidad para todos. La igualdad de oportunidades en el ámbito educativo es esencial para permitir que las personas con discapacidades intelectuales desarrollen todo su potencial y alcancen sus metas. Se examinan tanto los desafíos existentes en el sistema educativo como las mejores prácticas para promover la inclusión y el aprendizaje para todos los estudiantes.<br><br>Asimismo, se destaca la necesidad de promover oportunidades laborales significativas y respetuosas para las personas con discapacidades intelectuales. A través de la eliminación de barreras y la implementación de políticas inclusivas, se puede crear un entorno laboral que valore y aproveche las habilidades únicas de cada individuo. Se presentan estudios de casos y ejemplos de programas exitosos que han demostrado el impacto positivo de la inclusión laboral en la vida de las personas con discapacidades intelectuales.<br><br>En última instancia, esta publicación subraya la importancia de un enfoque holístico y centrado en la persona para abordar las necesidades de aquellos con discapacidades intelectuales. Se examinan las políticas y prácticas necesarias para fomentar un mundo más inclusivo y accesible para todos, reconociendo que la diversidad de habilidades cognitivas enriquece nuestra sociedad y nos hace más fuertes como comunidad.', N'Desafiando Estereotipos: Una Mirada Profunda a las Capacidades de las Personas con Discapacidades Intelectuales', CAST(N'2024-04-01T15:49:07.930' AS DateTime), NULL, 10, 1, N'http://comunidad-parimpar.com.ar/Posts/PostId_8.jpg', 2, NULL)
GO
SET IDENTITY_INSERT [dbo].[Posts] OFF
GO
SET IDENTITY_INSERT [dbo].[PostsXTypesImpairment] ON 
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (1, 1, 1)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (2, 2, 6)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (3, 2, 1)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (4, 3, 7)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (5, 4, 1)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (6, 5, 7)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (7, 6, 7)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (8, 6, 4)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (9, 6, 3)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (10, 7, 5)
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (11, 8, 3)
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
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'01dca962-ea35-4233-80ee-0b90b671c145', N'1fe82154-2ae8-493c-a424-50bebcdce8f4', N'oAIhrigbX0Ld_25szyBpl7FxX0RcOS1JZdHEG7hXFRg', N'SvbRUE8AjC8LnFs7Jw9dBWB420trgFBrYnyg1CquasE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwMWRjYTk2Mi1lYTM1LTQyMzMtODBlZS0wYjkwYjY3MWMxNDUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVXOUlUU0F2M243RjFQNW1Od003UzU4SFN6T3dzRVlnaVVCT3hxSHpsbVljMzdUL1dxRk1qOVpyRkZ6TlkwbDJqQXFEVk9Wdk5MZDJRTXcwSGRWcXZSR3BEZmIxOXVRbmE0T0JtVmEyZDZyc3AyNzBZTzlxMnVwUjg1QW45OU5SeEUvbEEvTXBqamNGRjR0SjlLZEpZRUdqZHdGK1V5eTRwQ2hTazFWRk9abHRKN25XK3J3YURIQ0lUWUVDV0pWeXNEYllIbTMxU1Q1Nmk4UUZIN2FFUUc5WjZtMUQrZEZ2TTBYZzdnM3EyTytYTktCbVBpSHhZTktZUUpQSkUyclVwa0EwbU1MV2NtdFhPdVYvTDg5V2Y3az0iLCJuYmYiOjE3MTA3MTc0OTEsImV4cCI6MTcxMDgwMzg5MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.oAIhrigbX0Ld_25szyBpl7FxX0RcOS1JZdHEG7hXFRg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxZmU4MjE1NC0yYWU4LTQ5M2MtYTQyNC01MGJlYmNkY2U4ZjQiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcxNzQ5MSwiZXhwIjoxNzEwNzE4MzkxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.SvbRUE8AjC8LnFs7Jw9dBWB420trgFBrYnyg1CquasE', CAST(N'2024-03-18T20:18:11.953' AS DateTime), CAST(N'2024-03-17T20:33:11.953' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T20:18:11.953' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'08eab1ae-dd3c-4aa3-a5de-47e0ea485792', N'f78fb4d5-ff7a-4119-be86-021e4c0a9a84', N'IGzSQrXQxabL4f_gYgNnURP_puj1wU1ynRFKGwRIRGg', N'vMNQxhcCdZimGDX0ihf0bTs8itNsSBCF9e7rHskhl9s', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwOGVhYjFhZS1kZDNjLTRhYTMtYTVkZS00N2UwZWE0ODU3OTIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWQWszM0dLblpZbTRFankySmtxbTU0R2ZKeXEyamNYYmRkK3R3V056MjRPOVdUemwwVy9FTXl5TmplbkVzcWtjelY0YmtNY0czMGw5NlZNRGtEdHZPRFF1TzhidTdnYWo0NW9aMmwvL2wyZ202cjJUUWZnbHhtbERadWJMcjZwc3gzcWFrS09WZjBwOGJ1RVZ0RnhER2htN1llNm1lK1ByazN4TjJYYzQ3RnZNMkI0RnhsZ3hUamRhNDNLRi92RkhVNUptY3dMRjZsUmUyM2VYbUxSc3BrVGlEdXNtSDJTZk12VDdFb1RtQWlPSVIwd0YvL1NqYk05L3lPQ1B4QUoyVW03NUx1SGltd3JqTFZ1NG90U3F5dz0iLCJuYmYiOjE3MTA2OTQ1MjIsImV4cCI6MTcxMDc4MDkyMiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.IGzSQrXQxabL4f_gYgNnURP_puj1wU1ynRFKGwRIRGg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmNzhmYjRkNS1mZjdhLTQxMTktYmU4Ni0wMjFlNGMwYTlhODQiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY5NDUyMiwiZXhwIjoxNzEwNjk1NDIyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.vMNQxhcCdZimGDX0ihf0bTs8itNsSBCF9e7rHskhl9s', CAST(N'2024-03-18T13:55:22.933' AS DateTime), CAST(N'2024-03-17T14:10:22.933' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T13:55:22.933' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'12deeecb-b3d6-4d77-a30b-122cf829629a', N'2ce3da47-33c8-4ec8-a7a4-0156d63ffb9c', N'kAZ8XMmPZDRQD_IsqHOT1M_qchZdkA3OCZqCYlviiuI', N'ZHk0WFnnyMubeBJV7CV8k0PH9_Nzwtcza8JSeIrQOV4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxMmRlZWVjYi1iM2Q2LTRkNzctYTMwYi0xMjJjZjgyOTYyOWEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVhZktSNlVkR25FZkdDYktobFhtSTRyaHpRQlhIZSs2TENhTG5oU20zR3ZHR3UveFZxakpHNVdPR1AxeVdDcXpVQ3ozZkxTOFQxUzJRVVZLSlVmNSs0amZKQkovZTlpTkNpUnpERXhFY1dMWFFDMldHVzRMSXgybGoxc3YvVGN5dmhMRUx4ZmpzUnZqZjdMK0pBU2pPUC9mNjBjYVBGT29FeHdIQnpSNnlzZmwxOTl6ZzloVlZpamRlYlVBb2NYU1F5ZjZQOHpkTzVkb0ZsSFFVSDRaM3IvN013RjVVN1pNVkNhcTVNWUFJN1h6TUlCTDIyZ2NKcTJLY1JBSEtmZyt2T3JqVXNxKzNJU0tRc3hvTWExdXJTcz0iLCJuYmYiOjE3MTA3ODY1NjIsImV4cCI6MTcxMDg3Mjk2MiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.kAZ8XMmPZDRQD_IsqHOT1M_qchZdkA3OCZqCYlviiuI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyY2UzZGE0Ny0zM2M4LTRlYzgtYTdhNC0wMTU2ZDYzZmZiOWMiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDc4NjU2MiwiZXhwIjoxNzEwNzg3NDYyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.ZHk0WFnnyMubeBJV7CV8k0PH9_Nzwtcza8JSeIrQOV4', CAST(N'2024-03-19T15:29:22.063' AS DateTime), CAST(N'2024-03-18T15:44:22.063' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-18T15:29:22.060' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'23700e32-be65-4262-b6e2-cb7ea197e38a', N'a651d110-fc00-415f-970f-e38f1736bcf0', N'Th8kZH5qLkXX7WWurpSTBEIwN4Byl3Kf168KMlMr6To', N'96QaV1FcXn97bM0aAg6KiXHq7k0_qarV9RhBTgjM4Wg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyMzcwMGUzMi1iZTY1LTQyNjItYjZlMi1jYjdlYTE5N2UzOGEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVSdjdidmFTRXM5ejB0R045aFgxMmNPeWlWeU9VR0J2b1dERzcveWdQVE1TWmlCYnlhN042VVRBUlNZWWZLTjhsVS9XSWxJN2dLTTQ1V1JYU0s3OSt4c3FidXRIT2RwbXZpSjNlaW1UVzRhV1l0dVlXTXZPUXRYU3RBb1p1QnhNaWpNd0d3d052V3VmS3QraDV5eXZRTjVaZ0xCNWI0QnJhcHdtT2lSRXVPSkcwTHdzVjZiUkxoU0JIK0dlbXorTHdCSWpNWmZUdVZXVzFnTU5wRmkxUit6QTlkMDZWZGZsMFRDQmFnc2paZGQ2SGFNT0Z4cUdtRlh6NU01K3E1K3ZYN0NTN2xIY1JxZlh3L3Qzb3J6MDhTZz0iLCJuYmYiOjE3MTA2ODUwNDMsImV4cCI6MTcxMDc3MTQ0MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Th8kZH5qLkXX7WWurpSTBEIwN4Byl3Kf168KMlMr6To', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhNjUxZDExMC1mYzAwLTQxNWYtOTcwZi1lMzhmMTczNmJjZjAiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4NTA0MywiZXhwIjoxNzEwNjg1OTQzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.96QaV1FcXn97bM0aAg6KiXHq7k0_qarV9RhBTgjM4Wg', CAST(N'2024-03-18T11:17:23.457' AS DateTime), CAST(N'2024-03-17T11:32:23.457' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:17:23.453' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'2f6489d4-6f02-4f76-a1cc-fd7c354cebea', N'96d8bbfb-1fd9-46bc-acc7-0cfa47c9b91d', N'ZDCFlUCii0zGv4j_AUqJWBzUWJKu_v5ixIbIxxQHIvM', N'P-aAg56euRpLaXFbrM2hCKBZ8YDzg4LBhLbogQkmwks', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyZjY0ODlkNC02ZjAyLTRmNzYtYTFjYy1mZDdjMzU0Y2ViZWEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYL0FnS0lFUnN0dlpSTkRsNWhBMy94dEpVRHYvbG1GR1QrU0thbjlWeHpJY1JJTEwwLzFYeHNPRXBSMmwwMlJhcnRFSTNiS09jUTlUMzEzZ1BmOGNxQjB1MnQ1WTgreWpPVi9tN1Z5NzV0V2dOSDdiSjFOY2hKL2xMeHpHZEwyMHo5SkxiNDVhN2pPWmZrTTgvL09nNlROOVB1TjdlYldRZUtjQmZPTDFlY2xpRUQ2YlZiR0tTUlZTWFFMV1FndnlUREprWnhaUW5UQzh6NmFxY0tXdU1mN2w2NTc2MW9YMHVTMTB0VGJXTWwzYzBPL3lVWXB5bXQ4RnVxTTd3M0QwVDROTjJaVFJKcDFKSUtsdUdNN0hUTlFqeUtyMFE3MHpNemNMaVhGVkVSSSIsIm5iZiI6MTcxMTk5ODk2MSwiZXhwIjoxNzEyMDg1MzYxLCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.ZDCFlUCii0zGv4j_AUqJWBzUWJKu_v5ixIbIxxQHIvM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5NmQ4YmJmYi0xZmQ5LTQ2YmMtYWNjNy0wY2ZhNDdjOWI5MWQiLCJDb250YWN0SWQiOiIxIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMTk5ODk2MSwiZXhwIjoxNzExOTk5ODYxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.P-aAg56euRpLaXFbrM2hCKBZ8YDzg4LBhLbogQkmwks', CAST(N'2024-04-02T16:16:01.523' AS DateTime), CAST(N'2024-04-01T16:31:01.523' AS DateTime), N'[{"Key":"ContactId","Value":"1"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 AVG/122.0.0.0', CAST(N'2024-04-01T16:16:01.520' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'404a3d75-b795-4132-880e-c67dfed18f46', N'ddfb3744-89d5-4b87-9ede-240364286747', N'S8H72JWTQkPmbseOfi7-GR44nR5zagLSjaMo61e7Bko', N'WFKXRMhwdequlcXXk9OiWVNV-kSOfEELY97iI_4VAmQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0MDRhM2Q3NS1iNzk1LTQxMzItODgwZS1jNjdkZmVkMThmNDYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWVEJtdHBsOUgyRmFrS0lXdm1xdnhyWkFMTTNuZmRyT3dJdmVQV2VZTVI4Q0xERlJaeEFVdzFwRFZ3SEpaVlV4d0V6TU42c25sM1Q0cUJZKzNvN1FXQjh4a3JNOE9uVHNJTGVvTHh6MW5TYUpNcTdHd3d4TDkwVjNOVTlnYmt0bUZNQnAxWUhkOTZkTDFxUzBhMFBDNE5FdGFWY3haWXZaTmtrUktxK1VLWlZsS2Q5aHd1a1NJd3FFWlhuemNNaG5YOGpHZFpXc1drckJKL1NrNVVKN3ZlU2hKd1NDZUFrVGZpeXlLVmVkbG9DZ1RmVkN0endZblJxSnp4NDlNd090TWoveDJId0hTRFU0dzVlTmQ4RVpjMD0iLCJuYmYiOjE3MTA3MjEzMzMsImV4cCI6MTcxMDgwNzczMywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.S8H72JWTQkPmbseOfi7-GR44nR5zagLSjaMo61e7Bko', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZGZiMzc0NC04OWQ1LTRiODctOWVkZS0yNDAzNjQyODY3NDciLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcyMTMzMywiZXhwIjoxNzEwNzIyMjMzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.WFKXRMhwdequlcXXk9OiWVNV-kSOfEELY97iI_4VAmQ', CAST(N'2024-03-18T21:22:13.503' AS DateTime), CAST(N'2024-03-17T21:37:13.503' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T21:22:13.503' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'461069c3-0cbb-437a-9cf3-204386d3827f', N'd7fb89ce-4aae-4c17-a7d3-44c26ce8d9b1', N'U-ccvyrY8KgOnCB5at7_UgIFxZa6AJrtlYQWJ2dJ-Y8', N'9Rj6c9knUjBOU-Y_zcy8idrKG5z9W-WbTKVAB8q4wXU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0NjEwNjljMy0wY2JiLTQzN2EtOWNmMy0yMDQzODZkMzgyN2YiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVlTGYycE5Ic056V3Q2QmFFcVkyMGEzTXAxTG9IZDhmemF5Rk1wSkswcUEweS9xeFFVR2dKSGxEUmJmeERsOEZmZVF0Z08zZ0luSmlkZ0VGUFQxTVlXcldVWTljenYvK25BYWhHajR3UnlINnFTZXRLK3RMSXhHRmdPMFR0bjMvenJES3Y1K2wzM05IYlpVVTJITnJ3RTR5S2VGbzFwcXdadEgxSXhHMENlamJYNHZ0ZE5OS2VDWERXSWVXdWVEODdaUnpZREV1aU9vaTBEamxWZCt2QUJlbEJBbktqYTZOV1RoY2VVVnFnZW1aQnE0clM2VlgyTjUwZ21BZTRlN3Rqb1Y4ek4wNXF0M1BSLy9USXJSVndXZz0iLCJuYmYiOjE3MTA5NzkzOTMsImV4cCI6MTcxMTA2NTc5MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.U-ccvyrY8KgOnCB5at7_UgIFxZa6AJrtlYQWJ2dJ-Y8', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkN2ZiODljZS00YWFlLTRjMTctYTdkMy00NGMyNmNlOGQ5YjEiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDk3OTM5MywiZXhwIjoxNzEwOTgwMjkzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.9Rj6c9knUjBOU-Y_zcy8idrKG5z9W-WbTKVAB8q4wXU', CAST(N'2024-03-21T21:03:13.190' AS DateTime), CAST(N'2024-03-20T21:18:13.190' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-20T21:03:13.210' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'4932d30a-c949-43ac-94ff-cd51c8906800', N'90d0a3a7-6230-412b-b213-4912dea09929', N'kvXHxlYjHdnQoMpVZ7omkEebKAOPxrJI0R-ZI15bg6Q', N'ZShEO5Q_RnllbOTRzCHYum8GGVj2JzsQCsqP_YP2TcM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0OTMyZDMwYS1jOTQ5LTQzYWMtOTRmZi1jZDUxYzg5MDY4MDAiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVZR0xsZlV5OHRZdVBNdjRSSDIwZDlBUWY3SjdrT0VtUHNmOHQwYWZLbzZPVzRPY2U4VEZJVFc3Qy9LSUFGVVFQNi8rYjRGekVzeDBBazlQRko0RUUyb25IOU9uUkVzUWFyMG0zWmlrWTBiRkVQbUhYRFZvNkpodnE2eEpVREJCOVF6RE9qMFM3TnJudVhlOWE3dXF5S2ZGS3JvZm94RXJFQ01yam1RQjVSNG9UeEljR0FqaHhXenpCYjhHWGtlU3JBV1MzbzRadktNRG5HbnIzeGcwN0YvM1N5bUlBOTdRYzhMQUxqVzI5YTdYMUhXRmEyUGNFV0UwQ0g2NGIrcW44cG02ME4rT25YZmNvOUtFZUFUSmFGS3JGTlRJRm93VnoxNUdOUEZ4ZVgwZiIsIm5iZiI6MTcxMjQ0Mjg0OSwiZXhwIjoxNzEyNTI5MjQ5LCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.kvXHxlYjHdnQoMpVZ7omkEebKAOPxrJI0R-ZI15bg6Q', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5MGQwYTNhNy02MjMwLTQxMmItYjIxMy00OTEyZGVhMDk5MjkiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMjQ0Mjg0OSwiZXhwIjoxNzEyNDQzNzQ5LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.ZShEO5Q_RnllbOTRzCHYum8GGVj2JzsQCsqP_YP2TcM', CAST(N'2024-04-07T19:34:09.167' AS DateTime), CAST(N'2024-04-06T19:49:09.167' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 Edg/123.0.0.0', CAST(N'2024-04-06T19:34:09.183' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'4b3bbf98-6ed0-4016-8ce7-9ede91a2fabf', N'7ce4c3c4-3234-4825-9ae7-6bea5f3c63f9', N'nPVi2Xxdj0uVAr8c9fxWivoOdLUPMfi0GDqubZNYu4Y', N'CSPnmfMCAeIYysSgDH0PGNVhGbjbitq_Ilw_cWOQdC0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI0YjNiYmY5OC02ZWQwLTQwMTYtOGNlNy05ZWRlOTFhMmZhYmYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVXaTBCVzlua203RXpPYnVGN0NCb3JFNHlUY3c3SHFaM2Vvdkg1ektPL25nUndxQ215dW54MG5PZ2ZieG82U05Hb2ozd3lLWUNRNDFGcEdSaDZ1MjFuV1gxblAxdkUzaWV6QWFTYU9UNG91QXp2L2FJWGtEMk9aRFdzejA1VGFZbXJwUlRWK1NxbHZDSm1sQXlDWGlYNWgvTHhBNG9tSnFtMjZqVmFWbVNRZ1Nrc3drTk81MjVSRnJXRFppZGxQK2g0ZzlhclhmYU9CRURneTF3ekxDVmcwRGpJQ25aZVFZcWQraGtHbFBnaE11ZzgyNC9iWUp5VXdZS1ZTNW1yMktFZUhrUURiU1dOenk0T1FkeEhLRmxwUT0iLCJuYmYiOjE3MTA3MjA4NzIsImV4cCI6MTcxMDgwNzI3MiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.nPVi2Xxdj0uVAr8c9fxWivoOdLUPMfi0GDqubZNYu4Y', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3Y2U0YzNjNC0zMjM0LTQ4MjUtOWFlNy02YmVhNWYzYzYzZjkiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcyMDg3MiwiZXhwIjoxNzEwNzIxNzcyLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.CSPnmfMCAeIYysSgDH0PGNVhGbjbitq_Ilw_cWOQdC0', CAST(N'2024-03-18T21:14:32.520' AS DateTime), CAST(N'2024-03-17T21:29:32.520' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T21:14:32.520' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'524e0225-dc19-425d-90f9-5b46fb7986a2', N'adeab402-2d75-4a71-acbc-b436872728bc', N'vAVAltjMQrLDFzKEF7Aly4PwBv-AbtrHf9pO6ZCxgFw', N'BKelABUhM97fhFhrNgJXO8GwQ4fPqVqMzZSXAqYpnOg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1MjRlMDIyNS1kYzE5LTQyNWQtOTBmOS01YjQ2ZmI3OTg2YTIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmV3hJWnppZnVCSjZpUUhaRktkbHhKQVR4cm9IYy9KMnVCbUIwWlJEblRzSUtDbXEzc0c2Rkt5cHplUnhUZU92MFNmM1E1K1BUOG5hVGRiRndjWGhRYmpuOFRrc01YMll3Z25IWllHVUZPVGkyMlBRMjhkNWFrZUJLd3FSMmlBRmY4WjFWakRucHFvMDZsRTl3S0JkajFzWjdoWDB6ekZvUEFNUHlEQVZoRUE5SHY5L1UzZTdPbVFDNFF2bnJlTmk0S1BEWXVsM2ordmdjQUErNHVVUWNBZitMYUJiVTBFcDJRNHY2VFVLQ0FiZjFRcGNlTHNrWkowM2VFcDdsQ0Z6ZWt5SVlvNllIQ0R0VDFWVWtYWEtUcz0iLCJuYmYiOjE3MTA2ODUxODMsImV4cCI6MTcxMDc3MTU4MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.vAVAltjMQrLDFzKEF7Aly4PwBv-AbtrHf9pO6ZCxgFw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhZGVhYjQwMi0yZDc1LTRhNzEtYWNiYy1iNDM2ODcyNzI4YmMiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4NTE4MywiZXhwIjoxNzEwNjg2MDgzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.BKelABUhM97fhFhrNgJXO8GwQ4fPqVqMzZSXAqYpnOg', CAST(N'2024-03-18T11:19:43.130' AS DateTime), CAST(N'2024-03-17T11:34:43.130' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:19:43.130' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'60a1f59a-2630-4aa6-805d-22e4615a48d0', N'95652b24-6b59-4273-b7d8-2c6b1a10a5c9', N'Ouszh0Qnk2oGgcbwN4mO6-19NrIQbZRyTqKlwQnnK1w', N'GuunV6SFUlqi-tVxnfaK86XNKnkuUtvUqziieXZlpuw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MGExZjU5YS0yNjMwLTRhYTYtODA1ZC0yMmU0NjE1YTQ4ZDAiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWZis2OWhPSm1uNEZVTkpYY0RJekRsemJWMk45RGhtQm9tVnJUSEJxTnJnVmN3TUxKN0FrSU9oRWFnK0hLNGl6VUJjeE1oek9KZ3VPdFkwS2dWSTRSaHFLRnFCTGdsN3Z5cGRYTjJwTENEb0k2NSs3WUNRdzVsMTdROGpFQ1ptc1QyZGFpYm1YNVBBYlRqaWRlMUNNUU1rdk81OEFHdXR5cmZQK0JKZXpKalJ5U1dKWGVreFNBSHUxZzNWcHdGWGVsS1o1MURITi9SSTZCWXNqTEZOakgxZGR2ZDdTWjJCcG1XaVJUUzdaajlxQkdXSE1rZjAvWFlUcjNBU3gwdUVhdlpDTEt0ZHQ4L0doVnNoVjRMM0x2UT0iLCJuYmYiOjE3MTA5Nzk1MzMsImV4cCI6MTcxMTA2NTkzMywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Ouszh0Qnk2oGgcbwN4mO6-19NrIQbZRyTqKlwQnnK1w', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5NTY1MmIyNC02YjU5LTQyNzMtYjdkOC0yYzZiMWExMGE1YzkiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDk3OTUzMywiZXhwIjoxNzEwOTgwNDMzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.GuunV6SFUlqi-tVxnfaK86XNKnkuUtvUqziieXZlpuw', CAST(N'2024-03-21T21:05:33.867' AS DateTime), CAST(N'2024-03-20T21:20:33.867' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-20T21:05:33.860' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'60a8a0a3-8d61-4a15-8e29-c7f9081cfbaa', N'37a1e514-1407-4876-863a-dacfee5aac89', N'Qn3-2Il8mIS5p0RecfbuDR-zf-E1CefOKRncscRmPlM', N'Grt9p9yHZnor8bRTMzivXMs0QpxVhSr5ap5sMB2lXzs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2MGE4YTBhMy04ZDYxLTRhMTUtOGUyOS1jN2Y5MDgxY2ZiYWEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVaS2h0d2U2NWZkUVBUM3ltaFdJdUhMbk5yRmEvZHZXaHFHdFJpNkliUUxqTlYvd2M2eUdCZmswMW5xWGxwbldWNU5lRDBJc2dVbnZhVGFSdEsvT2tNaTVXYlh0MUZDdHdhRmxXNU1tdzF3SzlhRHdhbkUyWHhUR0RpeHhMVEJGUUgxWU1YTS9iekJFNkxUbmIxK1M0M3FacktQYW1LUUVhZ3gzcndMMGMwa1NoR3BuOVJubEtvWE15eTNwZzdtL1NwQThaZU5PM0l0dDFIcXhDWmI0dG83a2xZZGVNdVdlRTZMS0E1VXBzNGQyemF5dTc3VXVJeE1meE9ReVUxT2JhSXNDNFlBa05xbzRXekl0OStqK0U5QT0iLCJuYmYiOjE3MTA3MTgxNjEsImV4cCI6MTcxMDgwNDU2MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Qn3-2Il8mIS5p0RecfbuDR-zf-E1CefOKRncscRmPlM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzN2ExZTUxNC0xNDA3LTQ4NzYtODYzYS1kYWNmZWU1YWFjODkiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcxODE2MSwiZXhwIjoxNzEwNzE5MDYxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.Grt9p9yHZnor8bRTMzivXMs0QpxVhSr5ap5sMB2lXzs', CAST(N'2024-03-18T20:29:21.040' AS DateTime), CAST(N'2024-03-17T20:44:21.040' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T20:29:21.040' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'64d8f919-5c64-4bf7-a01a-f8f6d4e13e64', N'34fb7a3a-9bc0-4ccc-b641-886b76dbacc6', N'lbceQ3AIPJsJhCO3KZLj_EKoUiOQ_xZitN9VJKsmDf0', N'W0YNUgjm1xZ-UDYNzXpreBJ_PQ1eiAu7tB3fk3PPHwI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2NGQ4ZjkxOS01YzY0LTRiZjctYTAxYS1mOGY2ZDRlMTNlNjQiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVka1plYjg0dXdjcFN5alNsTXNzYWFpNDNWREFDR2p2REhQOUZYY3AyRkFUZ01CaWs4MlVrS0d5R2J1cG9PY3ZUY2N1S3FJWk1XMGpyaFFSSDNwWElWSDlXdVFDK3NWcTJ1cU5KNXFWQXp6L0tZNVRMS1M5cnRxanZMd05rZlQzWjhkMnJwMDQ2S2FEdkpwN3VDOEpkYzBrVGlyNDc4RVNTZDgzaFpyZDdzN0h2dE5HbXJpeEVZMWhtY0ZNakVjUjhvSXBNa3ZRZjJ4aW1KM1FMTUdpNjE4V054bEp4QkEzeXJYcUUvbzhXYVE3aHdoZUdqbCsyRjVoa09lVEk2ckJWT0RUS01ET0NnSnJzblVhY0FqbDd4Zz0iLCJuYmYiOjE3MTE5OTg2MTEsImV4cCI6MTcxMjA4NTAxMSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.lbceQ3AIPJsJhCO3KZLj_EKoUiOQ_xZitN9VJKsmDf0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzNGZiN2EzYS05YmMwLTRjY2MtYjY0MS04ODZiNzZkYmFjYzYiLCJDb250YWN0SWQiOiIxMCIsIlN0YXR1cyI6IlN1Y2Nlc3MiLCJuYmYiOjE3MTE5OTg2MTEsImV4cCI6MTcxMTk5OTUxMSwiaXNzIjoiUGFySW1wYXIiLCJhdWQiOiJQYXJJbXBhciJ9.W0YNUgjm1xZ-UDYNzXpreBJ_PQ1eiAu7tB3fk3PPHwI', CAST(N'2024-04-02T16:10:11.883' AS DateTime), CAST(N'2024-04-01T16:25:11.883' AS DateTime), N'[{"Key":"ContactId","Value":"10"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36', CAST(N'2024-04-01T16:10:11.880' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'71332f7d-12e7-46fb-ba41-16aaf120afdc', N'e8dc8779-a7f4-4e5f-b136-0efedc17e02b', N'x1345utnYcN7G3w6W8zULXewpuly0J_oPEudCRRLaYc', N'dJSVsD15ZzdZrTFu03AGVo45ve75j5pUc301cvxnqWQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3MTMzMmY3ZC0xMmU3LTQ2ZmItYmE0MS0xNmFhZjEyMGFmZGMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkViTHBFdWJKY2dzd21Oa3hpUkt5WG1tYThObW5UUjEvRUk4SHZic2ZaUDVGL0FDVmdoT2tITFRHaHllOU5qUmVwV2ZHdkpudFJXU1huTURTQUlMVERVNTRTVEVjT2Zsd2JNOG1xdGFLcGEwazFoNXdXZUVBZFI2N1ZVL0MwYVdTNWdtYnZFTXJQa0RKTjhxVGUyL1RlSUpYSG5iNFdvQzl2bEdDeGsvcVEwZFNyTkI2dVRHbGxZdCtVMEU0VmN3S2RIeXp3RWlHck94Znl1VGhEU1ZnSEsyWXl3eXFrd0ErUkZuQUwxQXFna2ZVNm50dkZqbnVhM09NVnJ6WVZrSFZDcU1BU2tnamhlTWlTclIxN09Gd3BCND0iLCJuYmYiOjE3MTA3MTc4OTksImV4cCI6MTcxMDgwNDI5OSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.x1345utnYcN7G3w6W8zULXewpuly0J_oPEudCRRLaYc', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlOGRjODc3OS1hN2Y0LTRlNWYtYjEzNi0wZWZlZGMxN2UwMmIiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcxNzg5OSwiZXhwIjoxNzEwNzE4Nzk5LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.dJSVsD15ZzdZrTFu03AGVo45ve75j5pUc301cvxnqWQ', CAST(N'2024-03-18T20:24:59.013' AS DateTime), CAST(N'2024-03-17T20:39:59.013' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T20:24:59.013' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'78df45a8-2107-4d1a-8ef7-14d04cf31faa', N'787d0bf8-7b22-4e75-be95-5d1e8d29177d', N'fzjRAE5JxWI7A1aCGf67mlrZV75VNfb0b2y8INbFpwE', N'bdQT4s-FGq3ZQmvS9sG1F4vO3v4lm-jmp4eQE0BEpA4', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3OGRmNDVhOC0yMTA3LTRkMWEtOGVmNy0xNGQwNGNmMzFmYWEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVaZCtLVTZoaDdPdlNWeGFuTXl0NVIxZHNQSTkxYXQ1Q0lLU05oVTRMK0dDU1NjdE9VN3dnWVNaMTJXM1V2Ky84eHpoa2xxYlJzanNid1dDRjNDMDRDYlpCblZJYWdVTHgwcWw1TElRU0VsZkNDakZGY0FkOFpKQVJKb2thWDNTT3lzSjI5VFJmd3U3akt2OUhtN3NIVjBuUUdhZkhKa3oxMmQ0RlBScWZqZHdHYmVnWC9hMW04VmYxdDhST0NUUlhadCtIOG1oYWhyRGtoQzlFbVZ5MElVZzJTdW5WdzNIVGZvYWFxNFlXZnNJUGw4Ykl0VjVlTUtzRk5uclRydlZUalI3bHpZc2V5QmkvNXR6Q3FhOVcxVT0iLCJuYmYiOjE3MTA3MjE1ODcsImV4cCI6MTcxMDgwNzk4NywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.fzjRAE5JxWI7A1aCGf67mlrZV75VNfb0b2y8INbFpwE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3ODdkMGJmOC03YjIyLTRlNzUtYmU5NS01ZDFlOGQyOTE3N2QiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcyMTU4NywiZXhwIjoxNzEwNzIyNDg3LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.bdQT4s-FGq3ZQmvS9sG1F4vO3v4lm-jmp4eQE0BEpA4', CAST(N'2024-03-18T21:26:27.760' AS DateTime), CAST(N'2024-03-17T21:41:27.760' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T21:26:27.757' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'7b2b8094-be24-49e7-bd5a-4b152eaf58ca', N'1b64bd69-277e-467a-8dd1-681816475a74', N'_jlfhB2M7P3Dst4nMEjbjIQ-obkWDMJ_wRe-UMWJe8A', N'29b5VHdrWLEpuKrl6AgRAPydaMwILT5mYO9b_UpGY78', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI3YjJiODA5NC1iZTI0LTQ5ZTctYmQ1YS00YjE1MmVhZjU4Y2EiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWNk1pSnVnaWkvaVdOcmZXT2hNUGV6Yi9oUVIxNnV0bFVvelJqZXIxSmdHS0E3Wmo4NTJOdFdiaXVMb21CdUc4SEVvUWh0K3BRMG9jb0hqTzFUdUFSeEMxZGFvbnVOTGoySk45TUVGejMwVzM1UzlSUWhJY1AvWVJRRmFubVNxMkprVW9ra25aaitCY2hTZmZnTmM0bWg4WGFGeU13a0pEMHpwWVZESm5kMytOZmRLOHNPNEtNR3kzeTlJRnJNZVpBckxwSmt1ZHlMOEpuN00velgveTh0L3lhaFVVaFBWM1ViTnFjSUpNZGF2QVIybmRLa2x5L1o3RHJSTkc0SGhhd1FXUWQ3czhuS21mRENFTC9VUENROD0iLCJuYmYiOjE3MTA3MTg5NTEsImV4cCI6MTcxMDgwNTM1MSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0._jlfhB2M7P3Dst4nMEjbjIQ-obkWDMJ_wRe-UMWJe8A', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxYjY0YmQ2OS0yNzdlLTQ2N2EtOGRkMS02ODE4MTY0NzVhNzQiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcxODk1MSwiZXhwIjoxNzEwNzE5ODUxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.29b5VHdrWLEpuKrl6AgRAPydaMwILT5mYO9b_UpGY78', CAST(N'2024-03-18T20:42:31.373' AS DateTime), CAST(N'2024-03-17T20:57:31.373' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T20:42:31.370' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'853734bd-eb0d-4a79-b721-1af3124848c7', N'68eb93ad-2d5f-4ff2-9f51-19446e679bcb', N'2XSLbXdRoV6F7fb_UeC7zCNjmCN7oJnBE4EwTrJ4KgE', N'58E-sFdcRxUKuzybKOZ4mITJxH2faLSL2Q7JRqS1Qww', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4NTM3MzRiZC1lYjBkLTRhNzktYjcyMS0xYWYzMTI0ODQ4YzciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVkRkNpaFlEYzdxNUV6NDlEcWp2TFBxbDFlZ1pEc0Uza295U2hmYi9EVkdNZG9DWnVIMld5UStsMlg2VnBNWU1oM1dvSHY3ZFZkN3d1ZVFoS3hpTlpzbEpDZkpLOUJ4M0ZyVGJWNEhvUDRGMDEvUW93UVJjSXFSRTVMbk9GcUZqbXRNS1pjV1VNOEVEL2RZRkcvd1ZiaytUc2R5Q3phSmpPRWVKWXhVM01ScUFTVzhWcUtjNXNuTUZ3K0FtbGVLSGp5R2ZaV3hDY05jbk5CL0U3U1d5bmk0YmNoYmRubDVwQlh2c200bGVFNGFSRUdJaHhlOS9SSDg4NllwM0JKcXRJZ0k1NStFdC9FU1g3dWRUcXo5WWZxST0iLCJuYmYiOjE3MTA2ODUzNTYsImV4cCI6MTcxMDc3MTc1NiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.2XSLbXdRoV6F7fb_UeC7zCNjmCN7oJnBE4EwTrJ4KgE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OGViOTNhZC0yZDVmLTRmZjItOWY1MS0xOTQ0NmU2NzliY2IiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4NTM1NiwiZXhwIjoxNzEwNjg2MjU2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.58E-sFdcRxUKuzybKOZ4mITJxH2faLSL2Q7JRqS1Qww', CAST(N'2024-03-18T11:22:36.003' AS DateTime), CAST(N'2024-03-17T11:37:36.003' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:22:36.000' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'9a68c71a-55a4-4bc3-aa6f-0c70dfc6216b', N'0c3e7d34-2fa7-4ba0-a9a0-45328c0c9c50', N'HajXKvovlLP4e09SLhTy4sQv5W91pXKNOA7Y-LHtGT0', N'4HcpA5ByNeWr2b_T5_5-Xla2Wl6ooXVhJ1EJ-PNXBvk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5YTY4YzcxYS01NWE0LTRiYzMtYWE2Zi0wYzcwZGZjNjIxNmIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVhQlZhcEpnekI0RCszL1BNek9yZUh4RDdGc0NvLzhuMTQ4blA5MnBueGY0MjZ5c2p3RCtDb3dCTjU3b2ZvQzVvcGtBaVZuUG1ISEFsQXF6Z1lmWXJCa1k4NWptdjVkMERRemJKK2NlZzlpdUxmZ0h0KzhyQ2tHWTRKbk5XLytMTVV6K3kwcGEyS0JmTXk2MFZMMmJRYWpON1pja3pYeDlTMWZ0cFc4MGs0aTBicFU3aEZZRGd6ekIrTDVTSEpubEVHL0dpb0dtRFVtSmd1eFdFcXd5RUdqM3B6S3dnTVlnVU9xT0o3RUUyWGxWWXdEVCsrNUhwbVFNZ0xBa1dyZjdrTXFQUEtzNUQyd2xMTnNVNTROdm53ND0iLCJuYmYiOjE3MTA3MTc4MzUsImV4cCI6MTcxMDgwNDIzNSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.HajXKvovlLP4e09SLhTy4sQv5W91pXKNOA7Y-LHtGT0', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwYzNlN2QzNC0yZmE3LTRiYTAtYTlhMC00NTMyOGMwYzljNTAiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcxNzgzNSwiZXhwIjoxNzEwNzE4NzM1LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.4HcpA5ByNeWr2b_T5_5-Xla2Wl6ooXVhJ1EJ-PNXBvk', CAST(N'2024-03-18T20:23:55.680' AS DateTime), CAST(N'2024-03-17T20:38:55.680' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T20:23:55.680' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'9f49a3af-d408-4cb2-bb43-57b8836fb8b2', N'8a67d0f3-7077-41f3-8ed4-26a1bd5c76f9', N'fe2zMlurPKlboDDLWJ8-DFqz2TM8XhmavRJEhCgZrlM', N'spw5_3mmBRFTzn6KyfP8UeU1PXy7lbam7hu-Y3-20bg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5ZjQ5YTNhZi1kNDA4LTRjYjItYmI0My01N2I4ODM2ZmI4YjIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVRbTRtTmJPVGFTVnYyTWxwOHlGZHcrd01BWFp4bHljYmlXZUw2TWZXLzlOd0VFeVVrREIrM09PVVdvMGU5U0tXNXN4NEJVZElVajAveWVQN2VxM2xoY0lHT2U3NDRQSzdVZXVvZGNGTDNxa0cyR2FTeDFEU2dTOUw3bGNyaFU5anNYaSt3a0RwV0lzTHB3L2Q4dlRNdkREdGFsKzJ0ZytGYnc5SzBuQkFYVU9IMnhTZUhDc2ptMG1SeWVlUlNPOUprd2ZQempodFpXSzNwUU96U3E3QnlGOXladjVDbTdqbmJxSSttNjZMVWU0d01oMzZ3Myt4V0lRWFdua0NwMnlUQVZrTit3L08xekIzMk56WHNMS1FTTT0iLCJuYmYiOjE3MTA3MjA2MjYsImV4cCI6MTcxMDgwNzAyNiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.fe2zMlurPKlboDDLWJ8-DFqz2TM8XhmavRJEhCgZrlM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4YTY3ZDBmMy03MDc3LTQxZjMtOGVkNC0yNmExYmQ1Yzc2ZjkiLCJDb250YWN0SWQiOiI5IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcyMDYyNiwiZXhwIjoxNzEwNzIxNTI2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.spw5_3mmBRFTzn6KyfP8UeU1PXy7lbam7hu-Y3-20bg', CAST(N'2024-03-18T21:10:26.103' AS DateTime), CAST(N'2024-03-17T21:25:26.103' AS DateTime), N'[{"Key":"ContactId","Value":"9"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T21:10:26.100' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'a2102caf-cf4d-4273-b325-61d2f4c74075', N'966c2496-2ffd-4215-ab70-81d475eaf154', N'FgsjMbQPplf_Vq6OjwRgZHr-zE7MQe4ZMJo0jJVnQmQ', N'vQB_pvOKDMo0zVizYPY908uMGkeD2maVr6yIGqs5YXs', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhMjEwMmNhZi1jZjRkLTQyNzMtYjMyNS02MWQyZjRjNzQwNzUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmSUdyN0ZJTVRrRWtEL0dTNStwQkV4OGZSaVZkWm1ZSG55T0xLSmtleUFEZTN6ZWNXb1lFS3JUNEtBeUVsWUd3ejVQMCs4ZzdIdVliSE9zVENtNng0eko5NnFrbXp6RzQ5K3NIZDVPa3R0dDlxdHJvNGQxOXpqRjc2YWhsck4vaWNjUHlubU9qKzRtUE93ekZaNWxEYzJXcnE4S0FrMFBRR25rRWt5elRMNE5NdFdsM203QXIvSEllajJ2OWFlM1hvRzExSTk1bm96WkZoaDBVOW1OY1U3bjgrSmpCVXFqVDZYN3IxQVVuMnA3NmFBaTFGekhUbmsrQ3FRM0RYVDMvT1pPbTgxNDI2VFBmWjBzU2ozc1Z4TT0iLCJuYmYiOjE3MTA3MTk0NTksImV4cCI6MTcxMDgwNTg1OSwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.FgsjMbQPplf_Vq6OjwRgZHr-zE7MQe4ZMJo0jJVnQmQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI5NjZjMjQ5Ni0yZmZkLTQyMTUtYWI3MC04MWQ0NzVlYWYxNTQiLCJDb250YWN0SWQiOiI4IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcxOTQ1OSwiZXhwIjoxNzEwNzIwMzU5LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.vQB_pvOKDMo0zVizYPY908uMGkeD2maVr6yIGqs5YXs', CAST(N'2024-03-18T20:50:59.760' AS DateTime), CAST(N'2024-03-17T21:05:59.760' AS DateTime), N'[{"Key":"ContactId","Value":"8"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T20:50:59.760' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'a92fb62b-dd67-468f-8396-10acc138b743', N'c8ae8d2d-6445-4e63-874b-48b850ccc3d6', N'v1lym59z6OcMGPB_WDMCNz0IOewk2v9s0sNX-s6mCeM', N'iv-8h32Q2CY5EkEbP7EM6OywSntHX2qiXtsFpYok10Q', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhOTJmYjYyYi1kZDY3LTQ2OGYtODM5Ni0xMGFjYzEzOGI3NDMiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWNm13bXJaZGlINVdQWGl3WjZNRDl1Ty9UZFhmWFVZU1doWWVQWTR6SjZyak56cWc0Z3JmN1ZEcHBUZ1JBVUM1SXRFR3FlUkJiWXc4UWttd1ducVVYNUFYcEdKUGUvNWNOdHJQSFRNMzdRYzZxc3M4aXhpTW5ZOGUxdEtBWHNZT2xNRmF2OG5VVjI3VUhOaWdhVWx6RERhMExiQlB1Zmhib0lQcDBwdE9rLzhCTmZoaDI4aWpseHEzeWJWblJ3em80bDIxNDRDZFpvbmdqYnE1ZlNDWGsxTURtZjg2S3U2S01nTzZxRW9RQnlKL0tDR3YzQU9pSUw2Z1N5cCtGVm1lblBNUnpmMDlLOERKVE9KNjJyTDc0WjFDVEhza2ZyZ0VZOG1KV05xZWx1cSIsIm5iZiI6MTcxMDc4NjU1MSwiZXhwIjoxNzEwODcyOTUxLCJpc3MiOiJQYXJJbXBhclJlZnJlc2giLCJhdWQiOiJQYXJJbXBhclJlZnJlc2gifQ.v1lym59z6OcMGPB_WDMCNz0IOewk2v9s0sNX-s6mCeM', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjOGFlOGQyZC02NDQ1LTRlNjMtODc0Yi00OGI4NTBjY2MzZDYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDc4NjU1MSwiZXhwIjoxNzEwNzg3NDUxLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.iv-8h32Q2CY5EkEbP7EM6OywSntHX2qiXtsFpYok10Q', CAST(N'2024-03-19T15:29:11.647' AS DateTime), CAST(N'2024-03-18T15:44:11.647' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0', CAST(N'2024-03-18T15:29:11.647' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'b9084a13-74f5-4067-9af2-0b998f194d46', N'2c7ca639-68ba-46cf-b6ea-1fbe29c89de0', N'yXZNa6i798eJOXy848tYIB1ings6bvkgdhzoOP3TZLo', N'UY_acEUC9UZGaJi9ZDoTCJYGvE3eXuYkNuLpBpWS_UQ', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiOTA4NGExMy03NGY1LTQwNjctOWFmMi0wYjk5OGYxOTRkNDYiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVlUk05ZVJsZm0xbjNBV2dNRU1PQmd5MmpQb3BYTWhpRTg4YkUwVWJGMUlLN3VJMUlvSXdPVThLb21McnhWUnI4L1grb1lacHFSV2oyekttRit1VUhqZjB4aEQ4ZEx3V0RNaDQ2eHRxWjJrVWNXSHdEazFTakF6U0hTOGE4Z2ZLdjlsUitYYjJNQ2hscDJxQUQwN3RFdGpDS0JmNnFzcmhaclVpMFZxdnB0TTk4S1V3OFBvT2R6aGpkMTNSaGRGR2FCNm9HMmFmcFk0WEpTV0VIVmdCYmpuenNFcjM4MEJIMmtJVG50aENGZlZXTlk3MGtUUmV4QW52Qk9uZDh2V3pycTBZNHNvOU9DRlpES0xoZytaUERodz0iLCJuYmYiOjE3MTE5OTg0ODgsImV4cCI6MTcxMjA4NDg4OCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.yXZNa6i798eJOXy848tYIB1ings6bvkgdhzoOP3TZLo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyYzdjYTYzOS02OGJhLTQ2Y2YtYjZlYS0xZmJlMjljODlkZTAiLCJDb250YWN0SWQiOiIxMCIsIlN0YXR1cyI6IlN1Y2Nlc3MiLCJuYmYiOjE3MTE5OTg0ODgsImV4cCI6MTcxMTk5OTM4OCwiaXNzIjoiUGFySW1wYXIiLCJhdWQiOiJQYXJJbXBhciJ9.UY_acEUC9UZGaJi9ZDoTCJYGvE3eXuYkNuLpBpWS_UQ', CAST(N'2024-04-02T16:08:08.197' AS DateTime), CAST(N'2024-04-01T16:23:08.197' AS DateTime), N'[{"Key":"ContactId","Value":"10"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36', CAST(N'2024-04-01T16:08:08.197' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'bb67aaac-6158-4df0-be6e-67fc1e48bdc5', N'bad43b2f-3e42-446c-b1d1-1eaf5f076f92', N'-I517xRrxrH8vAF91CqTowAeuE9ZKNoPo4erdq6H1EE', N'iOmb500a4dv-wQC266_2i9xUMmDD5sI9sFziydhpjH8', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiYjY3YWFhYy02MTU4LTRkZjAtYmU2ZS02N2ZjMWU0OGJkYzUiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVWSllkRFExYmFudk1JcVAyTUk1T1drRVhBQ1dZaTFBZmFDZGFRYjRGN1dlOEpxNTFXL3Z4SGlqVjh1UzloRmY3TDV2aUJzeFhSRFEvNkx0a0VlVzNzZ3lULzlJVVFSdlppV0tnaURud3dVd1ZMSjhiUXVjai9wY2ptK2RvY1A3dHpZVHZGckNURjQ5OEVNMG1PWitLMHNCVEZvM2xSSUR6NDRBQ1NaUnVsbXRzNElVREtEZjU5Nmg2VXZwSGJiWWtqTzQ5WXhhd0lUTm1zMEZDcmZnQlBlYWpFNmxkZkpSZUdaSTIzRlIydmpBdERtSDlsTFI3VTgvSzMwV1YvRFRTbHJxMVpXSWZ2MDVvZ3dxSUxoN3JEYz0iLCJuYmYiOjE3MTA3ODQyMjAsImV4cCI6MTcxMDg3MDYyMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.-I517xRrxrH8vAF91CqTowAeuE9ZKNoPo4erdq6H1EE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiYWQ0M2IyZi0zZTQyLTQ0NmMtYjFkMS0xZWFmNWYwNzZmOTIiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDc4NDIyMCwiZXhwIjoxNzEwNzg1MTIwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.iOmb500a4dv-wQC266_2i9xUMmDD5sI9sFziydhpjH8', CAST(N'2024-03-19T14:50:20.253' AS DateTime), CAST(N'2024-03-18T15:05:20.253' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-18T14:50:20.253' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'c6193d91-81fd-4d95-899c-104966cbee30', N'c8bb6f15-7d0f-4e8b-b87e-46f113aef3b2', N'Adq50BuTSWIsI2YVbIQxpv5GlnmC8bGTVIWvLjf-tMI', N'8ZeBuF1V5KcTu0UH3MYWpbqwxgPyrbjx_qSpRWZm-5Q', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjNjE5M2Q5MS04MWZkLTRkOTUtODk5Yy0xMDQ5NjZjYmVlMzAiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYR0R2cGU2bUlyRXptNXFzRjY4QVJwN3JiZ0xyNXJxWisxQ3BiYzM1MGVJUE0vVUlXMm1PeHNqTDJCbmlMSWFvcXRCRHpjaUVkdFBaV0JzYzN2UnJXY3M4QmlnKzQ3UnBMZ29tVC9UeEdWSlR2VnhnMGNmVXowRUpuUUxOejJVN3VJZFBRUmo1Vy9FWWlJTDl5YVZJenl4NWVlbHZBMm9NWFd6dEcySFJSUXJMUy9IZk9OcmJ1bFBXRnlURjhhNGU5N2RsWnVkUGdKa3RmV0pXNmFOV0xteGo5KzBUWThOU0RDR0gzMzhuMmJBajE3aHIzK2tCZ0NxT2xsSk5qalRjeURYTWRkTm9UdlRnckF4MkRpbGdGOD0iLCJuYmYiOjE3MTA2ODY3NDgsImV4cCI6MTcxMDc3MzE0OCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Adq50BuTSWIsI2YVbIQxpv5GlnmC8bGTVIWvLjf-tMI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjOGJiNmYxNS03ZDBmLTRlOGItYjg3ZS00NmYxMTNhZWYzYjIiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4Njc0OCwiZXhwIjoxNzEwNjg3NjQ4LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.8ZeBuF1V5KcTu0UH3MYWpbqwxgPyrbjx_qSpRWZm-5Q', CAST(N'2024-03-18T11:45:48.423' AS DateTime), CAST(N'2024-03-17T12:00:48.423' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:45:48.423' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'eac7576e-f54f-4f31-9748-625ed9fa9b6a', N'54a72906-98a8-402e-bf31-58b1fd15a20f', N'udCVnEFE3X_1LQoSBcxzltRB3VZ636CIhU-HElqPbUg', N'SNaqWkfbXV6ni3h0bwGF3QREaWljejYvWomrZWpVojU', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlYWM3NTc2ZS1mNTRmLTRmMzEtOTc0OC02MjVlZDlmYTliNmEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVVVDkzTjB4Q2diYTVoNUd4aTQ4Rm1TdU1Kd0t1K1A1L3ZIbGg1VHdDY2RuQnFjRFNrN3dMZUdTYnBlK25rMldGb3BJWkoyYXFqcnM3d2daeUFhY3gva3h6T3kvQlB2d1FTTnVpVFdwRzl5VTYzYTBOdVNaUzVBNGJMZXFqU1h1OHpROSt2MENMUjRPajFSR2FYRFAzMXJpY3VkZlBZVlE2VjhPY2psS243VllJcVNCNVRpRDdqaFBaNkx2NmVWWDFQNjY1VzZFaXRaeFUrQWhkSXdrR3pIRnFZeUZDYTJsUGM1aFpYMGE3ZDIrdlIvUDRtK0sxSXJ1Szl6TGUzT2JZYXNXeGptcXFTUzdhMFNSSXJRUnFkTT0iLCJuYmYiOjE3MTA3MjA2MjAsImV4cCI6MTcxMDgwNzAyMCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.udCVnEFE3X_1LQoSBcxzltRB3VZ636CIhU-HElqPbUg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1NGE3MjkwNi05OGE4LTQwMmUtYmYzMS01OGIxZmQxNWEyMGYiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDcyMDYyMCwiZXhwIjoxNzEwNzIxNTIwLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.SNaqWkfbXV6ni3h0bwGF3QREaWljejYvWomrZWpVojU', CAST(N'2024-03-18T21:10:20.687' AS DateTime), CAST(N'2024-03-17T21:25:20.687' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T21:10:20.687' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'f47cff20-7779-4dbb-83cc-2a13246a17b4', N'e835b343-bcef-4639-b0b7-3b71f96419e3', N'T4DlbR5bXxk9zIPMf6LIjeRLxRxbHazU03C4H6fpGxk', N'4dkUq-n-9-w8B_oXRg6A_joSvsMQz0s-XpmDiBmJ_Ag', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJmNDdjZmYyMC03Nzc5LTRkYmItODNjYy0yYTEzMjQ2YTE3YjQiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmUEFEdC9IK0lycXNUenlHTmw0VU9HKzQvQUZhbDR0RXM4ZmNMMVdXeVF2anJNZG5BbG4yVEpaSWwxRUNvTno5U1Rqd2M2RG41Y1JmdW1VL1oxTnE4MGwrTk5LNXZwbzI2ZXNxcFRvK1Q5T0N4ZDJpcUNoenRpa080cUFyRUtpSW9RWE9EejVqQUFoN1JoS0FjNXZMVy9IY2ZiZGtXa0FYd0FabC9uekpaTXhOMnNob0RhY2lFUUVNbERlTmVTMEpEbk5UMkJ1ZUI5YVI2M0U4SGxwSkc0T2w2QkhHRUpIQ0JSMmk1UDhGS2xUOXVrNFJSNlFCZ1dlZWdVZGRjaHROaHJmVXlLdmxWRSsrWDdBTkc5aXc2WT0iLCJuYmYiOjE3MTIzNjAwMzQsImV4cCI6MTcxMjQ0NjQzNCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.T4DlbR5bXxk9zIPMf6LIjeRLxRxbHazU03C4H6fpGxk', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlODM1YjM0My1iY2VmLTQ2MzktYjBiNy0zYjcxZjk2NDE5ZTMiLCJDb250YWN0SWQiOiI0IiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMjM2MDAzNCwiZXhwIjoxNzEyMzYwOTM0LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.4dkUq-n-9-w8B_oXRg6A_joSvsMQz0s-XpmDiBmJ_Ag', CAST(N'2024-04-06T20:33:54.980' AS DateTime), CAST(N'2024-04-05T20:48:54.980' AS DateTime), N'[{"Key":"ContactId","Value":"4"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36', CAST(N'2024-04-05T20:33:54.990' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TypesImpairment] ON 
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (1, N'Condición Física o Motora')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (2, N'Condición Sensorial')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (3, N'Condición Intelectual')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (4, N'Condición Psíquica')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (5, N'Condición Visual')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (6, N'Condición Auditiva')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (7, N'Trastorno del Espectro Autista')
GO
INSERT [dbo].[TypesImpairment] ([TypeId], [Description]) VALUES (8, N'Condición del Habla')
GO
SET IDENTITY_INSERT [dbo].[TypesImpairment] OFF
GO
ALTER TABLE [dbo].[ActionLog]  WITH NOCHECK ADD  CONSTRAINT [FK_ActionLog_ActionType] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ActionType] ([ActionTypeId])
GO
ALTER TABLE [dbo].[ActionLog] CHECK CONSTRAINT [FK_ActionLog_ActionType]
GO
ALTER TABLE [dbo].[ContactXEvent]  WITH NOCHECK ADD  CONSTRAINT [FK_ContactXEvent_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[ContactXEvent] CHECK CONSTRAINT [FK_ContactXEvent_Contacts]
GO
ALTER TABLE [dbo].[ContactXEvent]  WITH NOCHECK ADD  CONSTRAINT [FK_ContactXEvent_event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[ContactXEvent] CHECK CONSTRAINT [FK_ContactXEvent_event]
GO
ALTER TABLE [dbo].[ContactXTypeImplairment]  WITH NOCHECK ADD  CONSTRAINT [FK_ContactXTypeImplairment_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[ContactXTypeImplairment] CHECK CONSTRAINT [FK_ContactXTypeImplairment_Contacts]
GO
ALTER TABLE [dbo].[ContactXTypeImplairment]  WITH NOCHECK ADD  CONSTRAINT [FK_ContactXTypeImplairment_TypeImplairment] FOREIGN KEY([TypeId])
REFERENCES [dbo].[TypesImpairment] ([TypeId])
GO
ALTER TABLE [dbo].[ContactXTypeImplairment] CHECK CONSTRAINT [FK_ContactXTypeImplairment_TypeImplairment]
GO
ALTER TABLE [dbo].[DenyObject]  WITH NOCHECK ADD  CONSTRAINT [FK_DenyObject_Contacts] FOREIGN KEY([ContactId])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[DenyObject] CHECK CONSTRAINT [FK_DenyObject_Contacts]
GO
ALTER TABLE [dbo].[Events]  WITH NOCHECK ADD  CONSTRAINT [FK__Events__ContactA__5FB337D6] FOREIGN KEY([ContactAudit])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK__Events__ContactA__5FB337D6]
GO
ALTER TABLE [dbo].[Events]  WITH NOCHECK ADD  CONSTRAINT [FK__Events__StateId__5EBF139D] FOREIGN KEY([ContacCreate])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK__Events__StateId__5EBF139D]
GO
ALTER TABLE [dbo].[Events]  WITH NOCHECK ADD  CONSTRAINT [FK_Events_States] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([StateId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_Events_States]
GO
ALTER TABLE [dbo].[Posts]  WITH NOCHECK ADD  CONSTRAINT [FK__Posts__ContactAu__7E37BEF6] FOREIGN KEY([ContactAudit])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK__Posts__ContactAu__7E37BEF6]
GO
ALTER TABLE [dbo].[Posts]  WITH NOCHECK ADD  CONSTRAINT [FK__Posts__StateId__7D439ABD] FOREIGN KEY([ContacCreate])
REFERENCES [dbo].[Contacts] ([ContactId])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK__Posts__StateId__7D439ABD]
GO
ALTER TABLE [dbo].[Posts]  WITH NOCHECK ADD  CONSTRAINT [FK_Posts_States] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([StateId])
GO
ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK_Posts_States]
GO
ALTER TABLE [dbo].[PostsXTypesImpairment]  WITH NOCHECK ADD  CONSTRAINT [FK_PostsXTypesImpairment_Posts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([PostId])
GO
ALTER TABLE [dbo].[PostsXTypesImpairment] CHECK CONSTRAINT [FK_PostsXTypesImpairment_Posts]
GO
ALTER TABLE [dbo].[PostsXTypesImpairment]  WITH NOCHECK ADD  CONSTRAINT [FK_PostsXTypesImpairment_TypesImpairment] FOREIGN KEY([TypeId])
REFERENCES [dbo].[TypesImpairment] ([TypeId])
GO
ALTER TABLE [dbo].[PostsXTypesImpairment] CHECK CONSTRAINT [FK_PostsXTypesImpairment_TypesImpairment]
GO
/****** Object:  StoredProcedure [dbo].[ActionLog_GetActions]    Script Date: 6/4/2024 19:49:21 ******/
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
					WHEN 'ContactId' THEN ISNULL(C.FoundationName, C.LastName + ', ' + C.FirstName)
					-- Events
					WHEN 'EventId' THEN E.Title
					-- Posts
					WHEN 'PostId' THEN P.Title
					-- Busqueda
					ELSE 'Texto buscardo: ' + AL.SearchText
				END 'ActionDone',
				CASE WHEN ISNULL(AL.ContactId,0) <> 0 THEN  ISNULL(AC.FoundationName, AC.LastName + ', ' + AC.FirstName) ELSE NULL END 'ContactAction'
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
				 ISNULL(C.FoundationName, C.LastName + ', ' + C.FirstName) AS 'name'
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN [Posts] (NOLOCK) P
					ON P.PostId = AL.ObjectId
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId = P.ContacCreate
			WHERE AL.ActionTypeId = 12
			GROUP BY AL.ObjectId, P.Title, C.FoundationName, C.LastName, C.FirstName, AL.ObjectKey 
			ORDER BY 2 DESC

			-- Tabla de los 5 events con mas visitas
			SELECT TOP 5
				AL.ObjectKey,
				COUNT(AL.ObjectId) 'Viewrs',
				AL.ObjectId,
				E.Title,
				ISNULL(C.FoundationName, C.LastName + ', ' + C.FirstName) AS 'name'
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN [Events] (NOLOCK) E
					ON E.EventId = AL.ObjectId
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId = E.ContacCreate
			WHERE AL.ActionTypeId = 11
			GROUP BY AL.ObjectId, E.Title, C.FoundationName, C.LastName, C.FirstName, AL.ObjectKey
			ORDER BY 2 DESC

			-- Tabla de los 5 perfiles con mas visitas
			SELECT TOP 5
				AL.ObjectKey,
				COUNT(AL.ObjectId) 'Viewrs',
				AL.ObjectId,
				ISNULL(C.FoundationName, C.LastName + ', ' + C.FirstName) AS 'name'
			FROM ActionLog (NOLOCK) AL
				LEFT JOIN [Contacts] (NOLOCK) C
					ON C.ContactId = AL.ObjectId
			WHERE AL.ActionTypeId = 13
			GROUP BY AL.ObjectId, C.FoundationName, C.LastName, C.FirstName, AL.ObjectKey
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

			-- Tipos de Acciones de usuario
			SELECT [Description] FROM ActionType
		SET @ResultCode = 200
	END
  ELSE
	BEGIN
		SET @ResultCode = 401
	END



-- corrigo campos mal tipiados
UPDATE ActionType SET [Description] = 'Rechazar Evento' WHERE [Description] = 'Rechzar Evento'
UPDATE ActionType SET [Description] = 'Rechazar Contenido' WHERE [Description] = 'Rechzar Contenido'
GO
/****** Object:  StoredProcedure [dbo].[Contact_Blocked]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Change_Recover_Password]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_ChangePassword]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Confirm]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_CredentialsLogin]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Delete]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_DeleteFoundation]    Script Date: 6/4/2024 19:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Contact_DeleteFoundation]
(
	@ContactId INT,
	@ResultCode INT OUTPUT
)
AS

/*
--para test
DECLARE @ContactId INT = 4
DECLARE @ResultCode INT
*/

IF (
	SELECT TOP 1 
		C.ContactId 
	FROM Contacts (NOLOCK) C 
	WHERE C.ContactId = @ContactId) IS NOT NULL
	BEGIN
		UPDATE Contacts 
		SET FoundationName = NULL,
		[Address] = NULL,
		UrlWeb = NULL,
		[Description] = NULL,
		UserFacebook = NULL,
		UserInstagram = NULL,
		UserLinkedin = NULL,
		UserX = NULL
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
GO
/****** Object:  StoredProcedure [dbo].[Contact_Deny_Recover]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_GetAll]    Script Date: 6/4/2024 19:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modificacion de stored agrgando que muestre el nombre de la fundacion

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
			ISNULL(FoundationName, LastName + ', ' + FirstName ) 'Name',
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
/****** Object:  StoredProcedure [dbo].[Contact_GetById]    Script Date: 6/4/2024 19:49:21 ******/
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
	FoundationName,
	email,
	ISNULL(Auditor, 'False') 'Auditor',
	ISNULL(Trusted, 'False') 'Trusted',
	ISNULL(Notifications, 'True') AS 'Notifications',
	DateBrirth,
	ImageUrl,
	[Description],
	UrlWeb,
	[Address],
	UserFacebook,
	UserInstagram,
	UserLinkedin,
	UserX
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
/****** Object:  StoredProcedure [dbo].[Contact_GetByIdInformation]    Script Date: 6/4/2024 19:49:21 ******/
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
			FoundationName,
			email,
			ISNULL(Auditor, 'False') 'Auditor',
			ISNULL(Trusted, 'False') 'Trusted',
			ISNULL(Notifications, 'True') AS 'Notifications',
			DateBrirth,
			ImageUrl,
			[Description],
			UrlWeb,
			[Address],
			UserFacebook,
			UserInstagram,
			UserLinkedin,
			UserX
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
/****** Object:  StoredProcedure [dbo].[Contact_RecoverPassword]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Regisrter]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_TrustedUntrusted]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Unblocked]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Update]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_UpdateAuditor]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_UpdateFoundation]    Script Date: 6/4/2024 19:49:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Contact_UpdateFoundation]
(
	@ContactId INT,
	@FoundationName VARCHAR(500),
	@Address varchar(500),
	@UrlWeb varchar(500),
	@Description varchar(MAX),
	@UserFacebook varchar(500),
	@UserInstagram varchar(500),
	@UserLinkedin varchar(500),
	@UserX varchar(500),
	@ResultCode INT OUTPUT
)
AS
/*
--para test
DECLARE @ContactId INT = 1
DECLARE @FoundationName VARCHAR(500) = 'Gaston Vottero Ayudante'
DECLARE @ResultCode INT
*/

SET @ResultCode = 200

IF (@FoundationName IS NULL OR @FoundationName = '')
	BEGIN
		SET @ResultCode = 5016
	END

IF @ResultCode = 200
	AND (SELECT TOP 1 
        C.ContactId 
    FROM Contacts (NOLOCK) C 
    WHERE C.ContactId = @ContactId) IS NULL
	BEGIN
		SET @ResultCode = 404
	END

IF @ResultCode = 200
	AND (SELECT TOP 1 
			C.ContactId 
		FROM Contacts (NOLOCK) C 
		WHERE 
			ISNULL(C.Confirm, 'False') <> 'False'
			AND C.DateDeleted IS NULL
			AND C.FoundationName = @FoundationName
			AND C.ContactId <> @ContactId
		) IS NOT NULL
	BEGIN 
		SET @ResultCode = 5922
	END

IF @ResultCode = 200
	BEGIN
		UPDATE Contacts 
		SET FoundationName = @FoundationName,
		[Address] = @Address,
		UrlWeb = @UrlWeb,
		[Description] = @Description,
		UserFacebook = @UserFacebook,
		UserInstagram = @UserInstagram,
		UserLinkedin = @UserLinkedin,
		UserX = @UserX
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
GO
/****** Object:  StoredProcedure [dbo].[Contact_Validate_Recover]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Canllation]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetAll]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetById]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Insert]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Delete]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_GetAll]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Insert]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Update]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[DenyObject_GetByKeyAndId]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Authorize]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Delete]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Deny]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetAll]    Script Date: 6/4/2024 19:49:21 ******/
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
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
/****** Object:  StoredProcedure [dbo].[Events_GetAllAssist]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetByDate]    Script Date: 6/4/2024 19:49:21 ******/
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
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
	AND E.StartDate >= GETDATE()
ORDER BY E.StartDate ASC
GO
/****** Object:  StoredProcedure [dbo].[Events_GetById]    Script Date: 6/4/2024 19:49:21 ******/
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
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
/****** Object:  StoredProcedure [dbo].[Events_GetByIdMoreInfo]    Script Date: 6/4/2024 19:49:21 ******/
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
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
/****** Object:  StoredProcedure [dbo].[Events_Insert]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Update]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Notify_NewEventsAndPosts]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Object_UpdateImage]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Authorize]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Delete]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Deny]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetAll]    Script Date: 6/4/2024 19:49:21 ******/
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
DECLARE @ContactId INT = 1
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
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
ORDER BY P.DateEntered DESC
GO
/****** Object:  StoredProcedure [dbo].[Posts_GetById]    Script Date: 6/4/2024 19:49:21 ******/
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
DECLARE @ContactId INT = 1
DECLARE @PostId INT = 2
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
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
/****** Object:  StoredProcedure [dbo].[Posts_GetByIdMoreInfo]    Script Date: 6/4/2024 19:49:21 ******/
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
DECLARE @ContactId INT = 1
DECLARE @PostId INT = 2
*/

SELECT 
	P.PostId,
	P.[Description],
	P.Text,
	P.Title,
	P.DateEntered,
	P.ContacCreate,
	ISNULL(CC.FoundationName, CC.LastName + ', ' + CC.FirstName) AS 'NameCreate',
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
/****** Object:  StoredProcedure [dbo].[Posts_Insert]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Update]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Search_GetSearch]    Script Date: 6/4/2024 19:49:21 ******/
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
DECLARE @inclusiveEvents AS BIT = 'True'
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
			ISNULL(C.FoundationName, C.LastName + ', ' + C.FirstName) AS 'NameCreate',
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
			AND E.StartDate >= GETDATE()
		ORDER BY E.StartDate ASC
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
				ISNULL(C.FoundationName, C.LastName + ', ' + C.FirstName) AS 'NameCreate',
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

			
SELECT * FROM @TableSearchAux ORDER BY [Key] ASC

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
/****** Object:  StoredProcedure [dbo].[Tokens_Change]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Insert]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Regenerate]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Update]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateChange]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateUpdate]    Script Date: 6/4/2024 19:49:21 ******/
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
/****** Object:  StoredProcedure [dbo].[TypesImpairment_GetAll]    Script Date: 6/4/2024 19:49:21 ******/
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
