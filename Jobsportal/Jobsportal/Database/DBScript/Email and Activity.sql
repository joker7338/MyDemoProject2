USE [Jobsportal]
GO
/****** Object:  StoredProcedure [dbo].[sp_EmailServer_Save]    Script Date: 06  /29  /2019 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[sp_EmailServer_Save](@Host nvarchar(max),@Port nvarchar(50),@SSL bit,@Email nvarchar(max),@Password nvarchar(max))
as

update EmailServer SET Host=@Host,Port=@Port,SSL=@SSL,Email=@Email,[Password]=@Password




GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmailConfig]    Script Date: 06  /29  /2019 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_GetEmailConfig]
as
Select Host,Port,[SSL],Email,[Password] from EmailServer



GO
/****** Object:  Table [dbo].[ActivityLog]    Script Date: 06  /29  /2019 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Timestamp] [datetime] NULL,
	[Session] [nvarchar](max) NULL,
	[IP] [nvarchar](200) NULL,
	[Browser] [nvarchar](200) NULL,
	[Device] [nvarchar](200) NULL,
	[Message] [nvarchar](max) NULL,
	[PageName] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmailServer]    Script Date: 06  /29  /2019 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailServer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[host] [nvarchar](max) NULL,
	[port] [nvarchar](50) NULL,
	[ssl] [bit] NULL,
	[email] [nvarchar](max) NULL,
	[password] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
