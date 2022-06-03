/****** Object:  Table [dbo].[categoria]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_categoria] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[categoria_novedad]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categoria_novedad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_categoria_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empresa]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empresa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](100) NULL,
	[nomenclatura] [varchar](50) NULL,
 CONSTRAINT [PK_empresa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[funcion]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[funcion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NULL,
 CONSTRAINT [PK_funcion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legajo]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nro_legajo] [int] NOT NULL,
	[empresa_id] [int] NULL,
	[apellido] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[sector_id] [int] NULL,
	[categoria_id] [int] NULL,
	[activo] [bit] NOT NULL,
	[fecha_alta] [datetime] NULL,
	[fecha_baja] [datetime] NULL,
	[funcion_id] [int] NULL,
	[observacion] [text] NULL,
 CONSTRAINT [PK_Legajo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[novedad]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[novedad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[legajo_id] [int] NOT NULL,
	[ubicacion_id] [int] NULL,
	[responsable_id] [int] NULL,
	[categoria_novedad_id] [int] NOT NULL,
	[tipo_novedad_id] [int] NULL,
	[tipo_resolucion_id] [int] NULL,
	[concepto] [int] NULL,
	[observacion] [text] NULL,
	[dias] [int] NULL,
	[fecha_novedad] [datetime] NOT NULL,
	[fecha_resolucion] [datetime] NULL,
	[fecha_alta] [datetime] NOT NULL,
	[sector_id] [int] NULL,
	[usuario_id] [int] NULL,
	[local_id] [int] NULL,
 CONSTRAINT [PK_legajo_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[perfil]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[perfil](
	[id] [int] NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_perfil] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[responsable]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[responsable](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[apellido] [varchar](100) NULL,
	[nombre] [varchar](100) NULL,
 CONSTRAINT [PK_responsable] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sector]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sector](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_sector] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipo_novedad]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipo_novedad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_legajo_tipo_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipo_resolucion]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipo_resolucion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_legajo_tipo_resolucion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ubicacion]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ubicacion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ubicacion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario]    Script Date: 3/6/2022 11:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [varchar](255) NOT NULL,
	[clave] [varchar](255) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[perfil_id] [int] NULL,
 CONSTRAINT [PK_usuario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[categoria] ON 

INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (1, N'Oficial')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (2, N'No calificado')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (3, N'Desarrollo')
SET IDENTITY_INSERT [dbo].[categoria] OFF
GO
SET IDENTITY_INSERT [dbo].[categoria_novedad] ON 

INSERT [dbo].[categoria_novedad] ([id], [descripcion]) VALUES (1, N'Sanciones')
INSERT [dbo].[categoria_novedad] ([id], [descripcion]) VALUES (2, N'Felicitaciones')
SET IDENTITY_INSERT [dbo].[categoria_novedad] OFF
GO
SET IDENTITY_INSERT [dbo].[empresa] ON 

INSERT [dbo].[empresa] ([id], [descripcion], [nomenclatura]) VALUES (1, N'MONTAGNE', N'MTG')
INSERT [dbo].[empresa] ([id], [descripcion], [nomenclatura]) VALUES (2, N'RANAWEL', N'RNW')
INSERT [dbo].[empresa] ([id], [descripcion], [nomenclatura]) VALUES (3, N'RF TEXTURE', N'RFT')
INSERT [dbo].[empresa] ([id], [descripcion], [nomenclatura]) VALUES (4, N'Fireland Outdoors', N'FRL')
INSERT [dbo].[empresa] ([id], [descripcion], [nomenclatura]) VALUES (5, N'Marcelo De Martino', N'MDM')
INSERT [dbo].[empresa] ([id], [descripcion], [nomenclatura]) VALUES (6, N'Nellida Esmir Martinez', N'NEM')
SET IDENTITY_INSERT [dbo].[empresa] OFF
GO
SET IDENTITY_INSERT [dbo].[funcion] ON 

INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (1, N'COSTURERO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (2, N'TS. VARIAS')
SET IDENTITY_INSERT [dbo].[funcion] OFF
GO
SET IDENTITY_INSERT [dbo].[legajo] ON 

INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (1, 1889, 1, N'Fabian', N'Ariel', 20, 1, 1, CAST(N'2022-06-09T00:00:00.000' AS DateTime), NULL, NULL, N'adasd')
INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (2, 4100, 1, N'ACEVAL', N'NORBERTO DANIEL', 3, 1, 1, CAST(N'2015-07-02T00:00:00.000' AS DateTime), NULL, 1, N'')
INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (3, 4501, 1, N'HERRERO', N'LEANDRO', 2, 2, 1, CAST(N'2022-05-04T00:00:00.000' AS DateTime), NULL, 2, N'')
INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (4, 4502, 1, N'LLANOS', N'JONATHAN LEONEL', 2, 2, 1, CAST(N'2022-05-04T00:00:00.000' AS DateTime), NULL, 2, N'')
INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (5, 4503, 1, N'MAMANI TAPIA ', N'JUAN EZEQUIEL', 2, 2, 1, CAST(N'2022-05-10T00:00:00.000' AS DateTime), NULL, 2, N'')
INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (6, 4504, 1, N'GALEANO ', N'SERGIO DAMIAN', 2, 2, 1, CAST(N'2022-05-10T00:00:00.000' AS DateTime), NULL, 2, N'')
INSERT [dbo].[legajo] ([id], [nro_legajo], [empresa_id], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta], [fecha_baja], [funcion_id], [observacion]) VALUES (7, 4506, 1, N'BALAZAR VILCA', N'JUAN CARLOS', 7, 2, 1, CAST(N'2022-05-11T00:00:00.000' AS DateTime), NULL, 2, N'')
SET IDENTITY_INSERT [dbo].[legajo] OFF
GO
SET IDENTITY_INSERT [dbo].[novedad] ON 

INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (1, 1, 2, 1, 2, 3, NULL, NULL, N'asdas', NULL, CAST(N'2022-06-03T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-03T11:11:11.900' AS DateTime), NULL, 3, NULL)
SET IDENTITY_INSERT [dbo].[novedad] OFF
GO
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (1, N'Administrador')
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (2, N'RRHH')
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (3, N'Responsable')
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (4, N'Consulta')
GO
SET IDENTITY_INSERT [dbo].[responsable] ON 

INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (1, N'Cossettini', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (2, N'Galletti', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (3, N'Perilli', NULL)
SET IDENTITY_INSERT [dbo].[responsable] OFF
GO
SET IDENTITY_INSERT [dbo].[sector] ON 

INSERT [dbo].[sector] ([id], [descripcion]) VALUES (1, N'Costura')
INSERT [dbo].[sector] ([id], [descripcion]) VALUES (2, N'Bordado')
INSERT [dbo].[sector] ([id], [descripcion]) VALUES (3, N'Transfer')
INSERT [dbo].[sector] ([id], [descripcion]) VALUES (4, N'Sistemas')
SET IDENTITY_INSERT [dbo].[sector] OFF
GO
SET IDENTITY_INSERT [dbo].[tipo_novedad] ON 

INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (1, N'Descargo')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (2, N'Mail')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (3, N'Falta puntualidad')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (4, N'Informe')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (5, N'Inasistencia')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (6, N'Web')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (7, N'Libro de quejas / sugerencias')
SET IDENTITY_INSERT [dbo].[tipo_novedad] OFF
GO
SET IDENTITY_INSERT [dbo].[tipo_resolucion] ON 

INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (1, N'Notificación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (2, N'Amonestación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (3, N'Capacitación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (4, N'Suspensión')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (5, N'Archivo')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (6, N'Apercibimiento')
SET IDENTITY_INSERT [dbo].[tipo_resolucion] OFF
GO
SET IDENTITY_INSERT [dbo].[ubicacion] ON 

INSERT [dbo].[ubicacion] ([id], [descripcion]) VALUES (1, N'FABRICA')
INSERT [dbo].[ubicacion] ([id], [descripcion]) VALUES (2, N'EDIFICIO')
INSERT [dbo].[ubicacion] ([id], [descripcion]) VALUES (3, N'LOCAL')
SET IDENTITY_INSERT [dbo].[ubicacion] OFF
GO
SET IDENTITY_INSERT [dbo].[usuario] ON 

INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (1, N'admin', N'$2a$11$nwvwgKPC7D5gClFbg6L4ie3sJH5fF0tkIrMVZN6fs.czFbg8Dg3km', N'Admin', N'Admin', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (2, N'ale', N'$2a$11$zuLDamkC94Bc7sUwcjhHBesVXQ7IYlYnsLpVIFM36plHQp7zLJrS2', N'Goral', N'Alejandro', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (3, N'ari', N'$2a$11$721HZiAYh8gAr6KgKn9mj.kgSlIQl31r2J1DaIkTFolSFFMmAoBVG', N'Fabian', N'Ariel', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (4, N'flor', N'$2a$11$xtBSMYVhXrtv6.g7LCJxbu./EYa6MzSK0UB1lZkBA9R23MN3AkXea', N'Ardanaz', N'Florencia', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (5, N'Gustavo', N'$2a$11$X1.TB2hNkYYtxz5FPEP2AeOn8Qa6Ok7MX0.jWgKrGfQcLKL5/yr8q', N'Fernandez', N'Gustavo', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (6, N'martin', N'$2a$11$7EDfpme8OPdwV7HaB2GCpeRuLlqBOPVakfGg7vA.JolxKog4stQ/i', N'Pais', N'Martín', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (7, N'mati', N'$2a$11$MXVnjJBKSlGY/vzvLyQjO.sbYvlvO0fbaQFX6aoRXPS5wNavmTkIG', N'Sperk', N'Matias', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (12, N'test', N'$2a$11$lK40nRYPpu9ts5G8/b.mK..4sL9dDlfLD8az5ZrP1qe8fCAYevBDK', N'test', N'test', 2)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (13, N'Resp', N'$2a$11$DWvSDgiKjAupyU50OF9tCe0zOMgRXHe5f6LIP7kijjhjIcsQEH4R6', N'resp', N'resp', 3)
SET IDENTITY_INSERT [dbo].[usuario] OFF
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaEliminar] 
@id int
AS

DELETE FROM  [dbo].[categoria]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCategoriaInsertar] 
@descripcion varchar(100)
AS

INSERT INTO [dbo].[categoria]
(
 descripcion 
)
VALUES
(
 @descripcion
)

GO
/****** Object:  StoredProcedure [dbo].[spCategoriaModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCategoriaModificar] 
@id int,
@descripcion varchar(100)
AS

UPDATE [dbo].[categoria]
SET descripcion = @descripcion
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaNovedadObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaNovedadObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria_novedad]
order by id
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[categoria]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria]

GO
/****** Object:  StoredProcedure [dbo].[spEmpresaObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEmpresaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[empresa]
order by id 
GO
/****** Object:  StoredProcedure [dbo].[spFuncionObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFuncionObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[funcion]
order by descripcion 
GO
/****** Object:  StoredProcedure [dbo].[spLegajoEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoEliminar] 
@id int
AS

delete 
from legajo 
where id =  @id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoInsertar] 
@nro_legajo int,
@apellido varchar(50),
@nombre varchar(50),
@empresa_id int,
@sector_id int,
@categoria_id int,
@funcion_id int,
@observacion text,
@activo bit,
@fecha_alta datetime,
@fecha_baja datetime
AS

declare @c as int 

select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c>0 return

INSERT INTO legajo
(
   nro_legajo, 
   apellido, 
   nombre, 
   empresa_id,
   sector_id, 
   categoria_id, 
   funcion_id,
   observacion,
   activo, 
   fecha_alta,
   fecha_baja
 )
VALUES
(
   @nro_legajo, 
   @apellido, 
   @nombre, 
   @empresa_id,
   @sector_id, 
   @categoria_id, 
   @funcion_id,
   @observacion,
   @activo, 
   @fecha_alta,
   @fecha_baja
)

GO
/****** Object:  StoredProcedure [dbo].[spLegajoModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoModificar] 
@id int,
@nro_legajo int,
@apellido varchar(50),
@nombre varchar(50),
@empresa_id int,
@sector_id int,
@categoria_id int,
@funcion_id int,
@observacion text,
@activo bit,
@fecha_alta datetime,
@fecha_baja datetime
AS

declare @c as int 

select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c<>1 return

UPDATE legajo
SET  apellido=@apellido, 
     nombre=@nombre, 
     empresa_id=@empresa_id, 
     sector_id=@sector_id, 
     categoria_id=@categoria_id,
     funcion_id=@funcion_id,
     observacion=@observacion, 
     activo=@activo, 
     fecha_alta=@fecha_alta,
     fecha_baja=@fecha_baja
where id =  @id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtener] 
@id int
AS

select l.*,
       s.descripcion as sector,
       c.descripcion as categoria
from legajo l
left join MontagneProduccion.dbo.Sectores s on l.sector_id = s.Idsec 
left join categoria c ON l.categoria_id = c.id 
where l.id = @id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerDeImportacion]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerDeImportacion] 
@nro_legajo varchar(50),
@apellido varchar(100),
@nombre varchar(100),
@empresa varchar(100),
@sector varchar(100),
@categoria varchar(100),
@funcion varchar(100),
@str_fecha_ingreso varchar(10),
@str_fecha_baja varchar(10),
@observacion text

AS

declare @c int
declare @empresa_id int
declare @sector_id int 
declare @categoria_id int 
declare @funcion_id int 

select @empresa_id= e.id
from empresa e 
where e.Descripcion = @empresa
or e.nomenclatura = @empresa

if @empresa_id is null return -2


select @c=count(*)
from legajo l 
where l.empresa_id = @empresa_id
and   l.nro_legajo = @nro_legajo

if @c>0 return -1



select @sector_id=s.Idsec 
from MontagneProduccion.dbo.Sectores s
where s.Descripcion = @sector

if @sector_id is null return -3

select @categoria_id= c.id
from categoria c
where c.Descripcion = @categoria

if @categoria_id is null return -4

select @funcion_id=f.id
from funcion f 
where f.Descripcion = @funcion

if @funcion_id is null return -5

select @nro_legajo as nro_legajo,
       @empresa_id as empresa_id,
       @sector_id as sector_id,
       @categoria_id as categoria_id,
       @funcion_id as funcion_id,
       @apellido as apellido,
       @nombre as nombre,
       @observacion as observacion,
       case when @str_fecha_ingreso = '' then null else @str_fecha_ingreso end  as fecha_alta,
       case when  @str_fecha_baja = '' then null else  @str_fecha_baja end as fecha_baja
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorNro]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerPorNro] 
@empresa_id int,
@nro_legajo int
AS

select l.*,
       s.descripcion as sector,
       c.descripcion as categoria
from legajo l
left join MontagneProduccion.dbo.Sectores s on l.sector_id = s.Idsec 
left join categoria c ON l.categoria_id = c.id 
where empresa_id=@empresa_id 
and nro_legajo =  @nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerTodos] 
@nro_legajo int,
@apellido varchar(50)
AS


select l.*,
       s.descripcion as sector,
       c.descripcion as categoria
from legajo l
left join MontagneProduccion.dbo.Sectores s on l.sector_id = s.Idsec 
left join categoria c ON l.categoria_id = c.id 
where  (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and    (@apellido='' or l.apellido like '%'+ @apellido +'%')
order by nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLogin]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLogin] 
@UsuarioID varchar(255)
AS

select a.id,
       a.UsuarioID,
       a.clave,      
       a.Apellido,
       a.Nombre,
	   a.perfil_id,
	   p.descripcion  as perfil_descripcion 
from usuario a
inner join perfil p on a.perfil_id = p.id
where a.UsuarioID=@UsuarioID;
GO
/****** Object:  StoredProcedure [dbo].[spNovedadEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadEliminar] 
@id int

AS
Delete from novedad 
WHERE id = @id
GO
/****** Object:  StoredProcedure [dbo].[spNovedadInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadInsertar] 
@legajo_id int,
@ubicacion_id int,
@sector_id int,
@responsable_id int,
@categoria_novedad_id int,
@tipo_novedad_id int,
@tipo_resolucion_id int,
@concepto int,
@dias int,
@observacion text,
@fecha_novedad datetime, 
@fecha_resolucion datetime,
@usuario_id int

AS

declare @c as int 

/*select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c<>1 return -1
*/

INSERT INTO novedad
(
 legajo_id, 
 ubicacion_id,
 sector_id,
 responsable_id,
 categoria_novedad_id, 
 tipo_novedad_id, 
 tipo_resolucion_id, 
 concepto, 
 dias, 
 observacion, 
 fecha_novedad, 
 fecha_resolucion, 
 fecha_alta,
 usuario_id 
 )

VALUES
(
 @legajo_id, 
 @ubicacion_id,
 @sector_id,
 @responsable_id,
 @categoria_novedad_id, 
 @tipo_novedad_id, 
 @tipo_resolucion_id, 
 @concepto, 
 @dias, 
 @observacion, 
 @fecha_novedad, 
 @fecha_resolucion, 
 getdate(),
 @usuario_id
)

return 0
GO
/****** Object:  StoredProcedure [dbo].[spNovedadModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadModificar] 
@id int,
@legajo_id int,
@ubicacion_id int,
@sector_id int,
@responsable_id int,
@categoria_novedad_id int,
@tipo_novedad_id int,
@tipo_resolucion_id int,
@concepto int,
@dias int,
@observacion text,
@fecha_novedad datetime, 
@fecha_resolucion datetime,
@usuario_id int

AS

declare @c as int 

/*
select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c<>1 return -1
*/

UPDATE novedad
SET legajo_id=@legajo_id, 
    ubicacion_id=@ubicacion_id, 
    sector_id=@sector_id, 
    responsable_id=@responsable_id, 
    categoria_novedad_id=@categoria_novedad_id, 
    tipo_novedad_id=@tipo_novedad_id, 
    tipo_resolucion_id=@tipo_resolucion_id, 
    concepto=@concepto, 
    dias=@dias, 
    observacion=@observacion, 
    fecha_novedad=@fecha_novedad, 
    fecha_resolucion=@fecha_resolucion,
    usuario_id =@usuario_id,
    fecha_alta = getdate()
WHERE id = @id

return 0
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtener] 
@id int

AS
Select nov.*,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion,
       l.empresa_id,
       l.nro_legajo,
       l.apellido,
       l.nombre,
         case when nov.ubicacion_id=0 then 
          isnull((select Descripcion 
           from MontagneProduccion.dbo.Sectores s 
           where s.Idsec=nov.sector_id
           ),'') else '' end as sector,
        u.apellido + ', ' + u.nombre as usuario
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join usuario u  on nov.usuario_id  = u.id 
where nov.id = @id 
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerTodos] 
@categoria_novedad_id int, 
@tipo_novedad_id int,
@tipo_resolucion_id int,
@nro_legajo int,
@apellido varchar(50),
@fecha_novedad_desde datetime,
@fecha_novedad_hasta datetime

AS
Select nov.*,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion,
       l.nro_legajo,
       l.apellido,
       l.nombre,
       u.descripcion as ubicacion,
       r.apellido as responsable,
              case when nov.ubicacion_id=0 then 
          isnull((select Descripcion 
           from MontagneProduccion.dbo.Sectores s 
           where s.Idsec=nov.sector_id
           ),'') else '' end as sector  
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join ubicacion u on nov.ubicacion_id = u.id  
left join responsable r on nov.responsable_id = r.id
where (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and   (nov.fecha_novedad  >= @fecha_novedad_desde)
and   (nov.fecha_novedad  <= @fecha_novedad_hasta)
order by fecha_novedad desc 
GO
/****** Object:  StoredProcedure [dbo].[spPerfilObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPerfilObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[perfil]
order by id
GO
/****** Object:  StoredProcedure [dbo].[spResponsableObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spResponsableObtenerTodos] 
AS

SELECT id,
        apellido,
        nombre 
FROM  [dbo].[responsable] 
order by apellido , nombre



GO
/****** Object:  StoredProcedure [dbo].[spSectorEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorEliminar] 
@id int
AS

DELETE FROM  [dbo].[sector]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spSectorInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorInsertar] 
@descripcion varchar(100)
AS

INSERT INTO [dbo].[sector]
(
 descripcion 
)
VALUES
(
 @descripcion
)

GO
/****** Object:  StoredProcedure [dbo].[spSectorModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorModificar] 
@id int,
@descripcion varchar(100)
AS

UPDATE [dbo].[sector]
SET descripcion = @descripcion
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spSectorObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[sector]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spSectorObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorObtenerTodos] 
AS



select Idsec as id ,
       Descripcion as Descripcion 
from MontagneProduccion.dbo.Sectores
order by Descripcion 

GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoNovedadEliminar] 
@id int
AS

DELETE FROM  [dbo].[tipo_novedad]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoNovedadInsertar] 
@descripcion varchar(100)
AS

INSERT INTO [dbo].tipo_novedad 
(
 descripcion 
)
VALUES
(
 @descripcion
)
GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoNovedadModificar] 
@id int,
@descripcion varchar(100)
AS

UPDATE [dbo].[tipo_novedad]
SET descripcion = @descripcion
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoNovedadObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[tipo_novedad]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoNovedadObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[tipo_novedad]
order by descripcion
GO
/****** Object:  StoredProcedure [dbo].[spTipoResolucionEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionEliminar] 
@id int
AS

DELETE FROM  [dbo].[tipo_resolucion]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spTipoResolucionInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionInsertar] 
@descripcion varchar(100)
AS

INSERT INTO [dbo].tipo_resolucion 
(
 descripcion 
)
VALUES
(
 @descripcion
)
GO
/****** Object:  StoredProcedure [dbo].[spTipoResolucionModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionModificar] 
@id int,
@descripcion varchar(100)
AS

UPDATE [dbo].[tipo_resolucion]
SET descripcion = @descripcion
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[tipo_resolucion]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[tipo_resolucion]
order by descripcion 
GO
/****** Object:  StoredProcedure [dbo].[spUbicacionObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUbicacionObtenerTodos] 
AS

SELECT u.id,
      u.descripcion as descripcion  
FROM  [dbo].[ubicacion] u
order by u.descripcion



GO
/****** Object:  StoredProcedure [dbo].[spUsuarioCambiarClave]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioCambiarClave] 
@UsuarioID varchar(255),
@clave varchar(255)

AS


UPDATE [dbo].[usuario]
SET    clave=@clave
where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioEliminar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioEliminar] 
@UsuarioID varchar(255)
AS

delete from usuario where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioInsertar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioInsertar] 
@UsuarioID varchar(255),
@clave varchar(255),
@nombre varchar(100),
@apellido varchar(100),
@perfil_id int
AS

declare @c as int 

select @c = (Select count(*) from usuario where UsuarioID=@UsuarioID)

if @c>0 return

INSERT INTO [dbo].[usuario]
           (
             UsuarioID,
             clave,
             nombre,
             apellido,
			 perfil_id
            )
     VALUES
           (
             @UsuarioID,
             @clave,
             @nombre,
             @apellido,
			 @perfil_id
   	       )

GO
/****** Object:  StoredProcedure [dbo].[spUsuarioModificar]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioModificar] 
@UsuarioID varchar(255),
@nombre varchar(100),
@apellido varchar(100),
@perfil_id int
AS


UPDATE [dbo].[usuario]
SET    nombre=@nombre,
       apellido=@apellido,
	   perfil_id=@perfil_id
where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioObtener]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioObtener] 
@UsuarioID varchar(255)
AS

select a.*, perfil_id as perfil_descripcion 
from usuario a 
where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerTodos]    Script Date: 3/6/2022 11:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioObtenerTodos] 
AS

select a.*, 
       p.descripcion  as perfil_descripcion 
from usuario a  
inner join perfil p on a.perfil_id = p.id
order by apellido, nombre
GO
