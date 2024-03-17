USE [ParImpar]
GO
/****** Object:  User [user_api]    Script Date: 17/3/2024 11:55:09 ******/
CREATE USER [user_api] FOR LOGIN [user_api] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[SearchTypesImpairment]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[ActionLog]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[ActionType]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[Contacts]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[ContactXEvent]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[ContactXTypeImplairment]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[DenyObject]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[Events]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[MailExecutions]    Script Date: 17/3/2024 11:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MailExecutions](
	[Send] [varchar](500) NULL,
	[LastExecution] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Posts]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[PostsXTypesImpairment]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[States]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[Tokens]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  Table [dbo].[TypesImpairment]    Script Date: 17/3/2024 11:55:09 ******/
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
INSERT [dbo].[Contacts] ([ContactId], [FirstName], [LastName], [dateEntered], [Email], [Password], [UserName], [DateBrirth], [Auditor], [Confirm], [Trusted], [Notifications], [ConfirmCode], [ExpiredRecover], [CodeRecover], [ImageUrl], [DateModify], [Blocked], [DateDeleted], [FoundationName], [Address], [UrlWeb], [Description], [UserFacebook], [UserInstagram], [UserLinkedin], [UserX]) VALUES (3, N'Moly', N'Simone', CAST(N'2024-03-17T11:19:03.187' AS DateTime), N'molysimone13@gmail.com', N'ed78vWPkU9hDRVUf10qkfA==', N'msimone13', NULL, NULL, 1, NULL, 1, N'4EB2AB32-61EE-46A9-AB22-0EE6F4D56A5B', NULL, NULL, N'http://comunidad-parimpar.com.ar/Profiles/ContactId_3.jpeg', CAST(N'2024-03-17T11:46:40.657' AS DateTime), NULL, NULL, N'Fundación Inmula', N'Buchardo 1250', NULL, N'En la Fundación Inmula, creemos en el poder transformador del potencial humano. Nos dedicamos a brindar oportunidades de desarrollo integral a personas con discapacidades, permitiéndoles brillar con todo su esplendor. A través de programas educativos, culturales y deportivos, ayudamos a nuestros beneficiarios a descubrir y potenciar sus talentos únicos. Nuestro objetivo es guiar a cada estrella en ascenso hacia un futuro lleno de logros y realización personal, demostrando que el cielo no es el límite cuando se trata de alcanzar sus sueños.', NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Contacts] OFF
GO
INSERT [dbo].[MailExecutions] ([Send], [LastExecution]) VALUES (N'SendNotificy', CAST(N'2024-02-21T22:03:04.407' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 
GO
INSERT [dbo].[Posts] ([PostId], [Description], [Text], [Title], [DateEntered], [DateModify], [ContacCreate], [ContactAudit], [ImageUrl], [StateId], [DateDeleted]) VALUES (1, N'En esta publicación, exploraremos los últimos avances en tecnología diseñada para mejorar la calidad de vida de las personas con discapacidad visual. Desde dispositivos de asistencia hasta aplicaciones innovadoras, descubre cómo la tecnología está desempeñando un papel crucial en la inclusión y el empoderamiento de la comunidad con discapacidad visual. Acompáñanos en este viaje hacia un mundo más accesible e inclusivo.', N'En el ámbito de la discapacidad visual, la tecnología ha emergido como una herramienta revolucionaria para superar barreras. A lo largo de esta investigación, exploraremos dispositivos como lectores de pantalla, sistemas de navegación por voz y aplicaciones móviles diseñadas específicamente para mejorar la independencia y la participación en la sociedad de las personas con discapacidad visual.<br><br>La evolución de la inteligencia artificial ha permitido la creación de tecnologías cada vez más sofisticadas. Analizaremos cómo los algoritmos de reconocimiento de objetos y la realidad aumentada están siendo implementados para facilitar tareas diarias, desde identificar objetos hasta navegar por entornos desconocidos. Estos avances no solo brindan nuevas oportunidades, sino que también fomentan la autonomía y la igualdad de oportunidades.Además, nos sumergiremos en proyectos de investigación que buscan desarrollar interfaces cerebro-máquina para personas con discapacidad visual. Estas interfaces tienen el potencial de traducir la actividad cerebral en comandos ejecutables, abriendo nuevas posibilidades para la interacción con dispositivos y entornos digitales.<br><br>En el contexto de la educación, examinaremos plataformas educativas accesibles que utilizan tecnologías de voz y braille digital para garantizar que las personas con discapacidad visual tengan acceso equitativo a la información. Destacaremos programas pioneros que promueven la inclusión educativa y la capacitación laboral para mejorar las perspectivas de empleo.Esta publicación también abordará los desafíos éticos asociados con el uso de tecnologías asistivas, destacando la importancia de la privacidad y la seguridad en el diseño de estas soluciones. <br>Al mismo tiempo, reflexionaremos sobre cómo la sociedad puede avanzar hacia un futuro más inclusivo, donde la tecnología se utilice como una herramienta para derribar barreras y fomentar la diversidad.<br><br>En resumen, este análisis exhaustivo busca arrojar luz sobre la intersección entre la tecnología y la discapacidad visual, destacando tanto los logros actuales como las oportunidades futuras para mejorar la calidad de vida de las personas con esta discapacidad. Acompáñanos en este viaje hacia un mundo más inclusivo, donde la innovación tecnológica se convierte en un catalizador para el cambio positivo.', N'Avances en la Integración Tecnológica para Personas con Discapacidad Visual', CAST(N'2024-03-17T11:22:08.600' AS DateTime), NULL, 3, 2, N'http://comunidad-parimpar.com.ar/Posts/PostId_1.jpg', 2, NULL)
GO
SET IDENTITY_INSERT [dbo].[Posts] OFF
GO
SET IDENTITY_INSERT [dbo].[PostsXTypesImpairment] ON 
GO
INSERT [dbo].[PostsXTypesImpairment] ([PostXTypesImpairmentId], [PostId], [TypeId]) VALUES (1, 1, 1)
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
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'23700e32-be65-4262-b6e2-cb7ea197e38a', N'a651d110-fc00-415f-970f-e38f1736bcf0', N'Th8kZH5qLkXX7WWurpSTBEIwN4Byl3Kf168KMlMr6To', N'96QaV1FcXn97bM0aAg6KiXHq7k0_qarV9RhBTgjM4Wg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIyMzcwMGUzMi1iZTY1LTQyNjItYjZlMi1jYjdlYTE5N2UzOGEiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVSdjdidmFTRXM5ejB0R045aFgxMmNPeWlWeU9VR0J2b1dERzcveWdQVE1TWmlCYnlhN042VVRBUlNZWWZLTjhsVS9XSWxJN2dLTTQ1V1JYU0s3OSt4c3FidXRIT2RwbXZpSjNlaW1UVzRhV1l0dVlXTXZPUXRYU3RBb1p1QnhNaWpNd0d3d052V3VmS3QraDV5eXZRTjVaZ0xCNWI0QnJhcHdtT2lSRXVPSkcwTHdzVjZiUkxoU0JIK0dlbXorTHdCSWpNWmZUdVZXVzFnTU5wRmkxUit6QTlkMDZWZGZsMFRDQmFnc2paZGQ2SGFNT0Z4cUdtRlh6NU01K3E1K3ZYN0NTN2xIY1JxZlh3L3Qzb3J6MDhTZz0iLCJuYmYiOjE3MTA2ODUwNDMsImV4cCI6MTcxMDc3MTQ0MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Th8kZH5qLkXX7WWurpSTBEIwN4Byl3Kf168KMlMr6To', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhNjUxZDExMC1mYzAwLTQxNWYtOTcwZi1lMzhmMTczNmJjZjAiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4NTA0MywiZXhwIjoxNzEwNjg1OTQzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.96QaV1FcXn97bM0aAg6KiXHq7k0_qarV9RhBTgjM4Wg', CAST(N'2024-03-18T11:17:23.457' AS DateTime), CAST(N'2024-03-17T11:32:23.457' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:17:23.453' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'524e0225-dc19-425d-90f9-5b46fb7986a2', N'adeab402-2d75-4a71-acbc-b436872728bc', N'vAVAltjMQrLDFzKEF7Aly4PwBv-AbtrHf9pO6ZCxgFw', N'BKelABUhM97fhFhrNgJXO8GwQ4fPqVqMzZSXAqYpnOg', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1MjRlMDIyNS1kYzE5LTQyNWQtOTBmOS01YjQ2ZmI3OTg2YTIiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVmV3hJWnppZnVCSjZpUUhaRktkbHhKQVR4cm9IYy9KMnVCbUIwWlJEblRzSUtDbXEzc0c2Rkt5cHplUnhUZU92MFNmM1E1K1BUOG5hVGRiRndjWGhRYmpuOFRrc01YMll3Z25IWllHVUZPVGkyMlBRMjhkNWFrZUJLd3FSMmlBRmY4WjFWakRucHFvMDZsRTl3S0JkajFzWjdoWDB6ekZvUEFNUHlEQVZoRUE5SHY5L1UzZTdPbVFDNFF2bnJlTmk0S1BEWXVsM2ordmdjQUErNHVVUWNBZitMYUJiVTBFcDJRNHY2VFVLQ0FiZjFRcGNlTHNrWkowM2VFcDdsQ0Z6ZWt5SVlvNllIQ0R0VDFWVWtYWEtUcz0iLCJuYmYiOjE3MTA2ODUxODMsImV4cCI6MTcxMDc3MTU4MywiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.vAVAltjMQrLDFzKEF7Aly4PwBv-AbtrHf9pO6ZCxgFw', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJhZGVhYjQwMi0yZDc1LTRhNzEtYWNiYy1iNDM2ODcyNzI4YmMiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4NTE4MywiZXhwIjoxNzEwNjg2MDgzLCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.BKelABUhM97fhFhrNgJXO8GwQ4fPqVqMzZSXAqYpnOg', CAST(N'2024-03-18T11:19:43.130' AS DateTime), CAST(N'2024-03-17T11:34:43.130' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:19:43.130' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'853734bd-eb0d-4a79-b721-1af3124848c7', N'68eb93ad-2d5f-4ff2-9f51-19446e679bcb', N'2XSLbXdRoV6F7fb_UeC7zCNjmCN7oJnBE4EwTrJ4KgE', N'58E-sFdcRxUKuzybKOZ4mITJxH2faLSL2Q7JRqS1Qww', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4NTM3MzRiZC1lYjBkLTRhNzktYjcyMS0xYWYzMTI0ODQ4YzciLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVkRkNpaFlEYzdxNUV6NDlEcWp2TFBxbDFlZ1pEc0Uza295U2hmYi9EVkdNZG9DWnVIMld5UStsMlg2VnBNWU1oM1dvSHY3ZFZkN3d1ZVFoS3hpTlpzbEpDZkpLOUJ4M0ZyVGJWNEhvUDRGMDEvUW93UVJjSXFSRTVMbk9GcUZqbXRNS1pjV1VNOEVEL2RZRkcvd1ZiaytUc2R5Q3phSmpPRWVKWXhVM01ScUFTVzhWcUtjNXNuTUZ3K0FtbGVLSGp5R2ZaV3hDY05jbk5CL0U3U1d5bmk0YmNoYmRubDVwQlh2c200bGVFNGFSRUdJaHhlOS9SSDg4NllwM0JKcXRJZ0k1NStFdC9FU1g3dWRUcXo5WWZxST0iLCJuYmYiOjE3MTA2ODUzNTYsImV4cCI6MTcxMDc3MTc1NiwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.2XSLbXdRoV6F7fb_UeC7zCNjmCN7oJnBE4EwTrJ4KgE', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI2OGViOTNhZC0yZDVmLTRmZjItOWY1MS0xOTQ0NmU2NzliY2IiLCJDb250YWN0SWQiOiIyIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4NTM1NiwiZXhwIjoxNzEwNjg2MjU2LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.58E-sFdcRxUKuzybKOZ4mITJxH2faLSL2Q7JRqS1Qww', CAST(N'2024-03-18T11:22:36.003' AS DateTime), CAST(N'2024-03-17T11:37:36.003' AS DateTime), N'[{"Key":"ContactId","Value":"2"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:22:36.000' AS DateTime))
GO
INSERT [dbo].[Tokens] ([RefreshTokenId], [AccessTokenId], [RefreshTokenSignature], [AccessTokenSignature], [RefreshToken], [AccessToken], [RefreshTokenExpirationDate], [AccessTokenExpirationDate], [Claims], [KeepLoggedIn], [IpAddress], [Client], [DateEntered]) VALUES (N'c6193d91-81fd-4d95-899c-104966cbee30', N'c8bb6f15-7d0f-4e8b-b87e-46f113aef3b2', N'Adq50BuTSWIsI2YVbIQxpv5GlnmC8bGTVIWvLjf-tMI', N'8ZeBuF1V5KcTu0UH3MYWpbqwxgPyrbjx_qSpRWZm-5Q', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjNjE5M2Q5MS04MWZkLTRkOTUtODk5Yy0xMDQ5NjZjYmVlMzAiLCJrZXkiOiJSVmJ4bTh1d2cxdlJHcUltVzlQTkVYR0R2cGU2bUlyRXptNXFzRjY4QVJwN3JiZ0xyNXJxWisxQ3BiYzM1MGVJUE0vVUlXMm1PeHNqTDJCbmlMSWFvcXRCRHpjaUVkdFBaV0JzYzN2UnJXY3M4QmlnKzQ3UnBMZ29tVC9UeEdWSlR2VnhnMGNmVXowRUpuUUxOejJVN3VJZFBRUmo1Vy9FWWlJTDl5YVZJenl4NWVlbHZBMm9NWFd6dEcySFJSUXJMUy9IZk9OcmJ1bFBXRnlURjhhNGU5N2RsWnVkUGdKa3RmV0pXNmFOV0xteGo5KzBUWThOU0RDR0gzMzhuMmJBajE3aHIzK2tCZ0NxT2xsSk5qalRjeURYTWRkTm9UdlRnckF4MkRpbGdGOD0iLCJuYmYiOjE3MTA2ODY3NDgsImV4cCI6MTcxMDc3MzE0OCwiaXNzIjoiUGFySW1wYXJSZWZyZXNoIiwiYXVkIjoiUGFySW1wYXJSZWZyZXNoIn0.Adq50BuTSWIsI2YVbIQxpv5GlnmC8bGTVIWvLjf-tMI', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjOGJiNmYxNS03ZDBmLTRlOGItYjg3ZS00NmYxMTNhZWYzYjIiLCJDb250YWN0SWQiOiIzIiwiU3RhdHVzIjoiU3VjY2VzcyIsIm5iZiI6MTcxMDY4Njc0OCwiZXhwIjoxNzEwNjg3NjQ4LCJpc3MiOiJQYXJJbXBhciIsImF1ZCI6IlBhckltcGFyIn0.8ZeBuF1V5KcTu0UH3MYWpbqwxgPyrbjx_qSpRWZm-5Q', CAST(N'2024-03-18T11:45:48.423' AS DateTime), CAST(N'2024-03-17T12:00:48.423' AS DateTime), N'[{"Key":"ContactId","Value":"3"},{"Key":"Status","Value":"Success"}]', 1, N'127.0.0.1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', CAST(N'2024-03-17T11:45:48.423' AS DateTime))
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
/****** Object:  StoredProcedure [dbo].[ActionLog_GetActions]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Blocked]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Change_Recover_Password]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_ChangePassword]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Confirm]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_CredentialsLogin]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Delete]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_DeleteFoundation]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Deny_Recover]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_GetAll]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_GetById]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_GetByIdInformation]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_RecoverPassword]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Regisrter]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_TrustedUntrusted]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Unblocked]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Update]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_UpdateAuditor]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_UpdateFoundation]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Contact_Validate_Recover]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Canllation]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetAll]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_GetById]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXEvent_Insert]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Delete]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_GetAll]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Insert]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[ContactXTypeImplairment_Update]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[DenyObject_GetByKeyAndId]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Authorize]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Delete]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Deny]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetAll]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetAllAssist]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetByDate]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetById]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_GetByIdMoreInfo]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Insert]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Events_Update]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Notify_NewEventsAndPosts]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Object_UpdateImage]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Authorize]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Delete]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Deny]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetAll]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetById]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_GetByIdMoreInfo]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Insert]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Posts_Update]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Search_GetSearch]    Script Date: 17/3/2024 11:55:09 ******/
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

			
SELECT DISTINCT * FROM @TableSearchAux ORDER BY [Key], DateOrder DESC

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
/****** Object:  StoredProcedure [dbo].[Tokens_Change]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Insert]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Regenerate]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_Update]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateChange]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[Tokens_ValidateUpdate]    Script Date: 17/3/2024 11:55:09 ******/
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
/****** Object:  StoredProcedure [dbo].[TypesImpairment_GetAll]    Script Date: 17/3/2024 11:55:09 ******/
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
