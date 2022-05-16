USE [MontagneProduccionTest]
GO
/****** Object:  Table [dbo].[legajo]    Script Date: 16/5/2022 16:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo](
	[nro_legajo] [int] NOT NULL,
	[apellidos] [nvarchar](50) NOT NULL,
	[nombres] [nvarchar](50) NOT NULL,
	[sector_id] [int] NULL,
	[categoria_id] [int] NULL,
	[activo] [bit] NOT NULL,
	[fecha_alta] [datetime] NULL,
 CONSTRAINT [PK_Legajo] PRIMARY KEY CLUSTERED 
(
	[nro_legajo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legajo_novedad]    Script Date: 16/5/2022 16:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo_novedad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nro_legajo] [int] NOT NULL,
	[tipo_novedad_id] [int] NULL,
	[descripcion] [text] NULL,
	[fecha] [datetime] NULL,
 CONSTRAINT [PK_legajo_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legajo_tipo_novedad]    Script Date: 16/5/2022 16:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo_tipo_novedad](
	[id] [int] NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_legajo_tipo_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legajo_usuario]    Script Date: 16/5/2022 16:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo_usuario](
	[UsuarioID] [varchar](255) NOT NULL,
	[clave] [varchar](255) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[perfil_id] [int] NULL,
 CONSTRAINT [PK_legajo_usuario] PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([categoria_id])
REFERENCES [dbo].[CategoriasEmpleados] ([IdCategoria])
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([sector_id])
REFERENCES [dbo].[Sectores] ([Idsec])
GO
ALTER TABLE [dbo].[legajo_novedad]  WITH CHECK ADD FOREIGN KEY([tipo_novedad_id])
REFERENCES [dbo].[legajo_tipo_novedad] ([id])
GO
