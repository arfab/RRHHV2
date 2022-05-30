/****** Object:  Table [dbo].[categoria]    Script Date: 30/5/2022 17:12:29 ******/
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
/****** Object:  Table [dbo].[categoria_novedad]    Script Date: 30/5/2022 17:12:29 ******/
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
/****** Object:  Table [dbo].[legajo]    Script Date: 30/5/2022 17:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo](
	[nro_legajo] [int] NOT NULL,
	[apellido] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
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
/****** Object:  Table [dbo].[novedad]    Script Date: 30/5/2022 17:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[novedad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nro_legajo] [int] NOT NULL,
	[ubicacion_id] [int] NULL,
	[responsable_id] [int] NULL,
	[categoria_novedad_id] [int] NOT NULL,
	[tipo_novedad_id] [int] NULL,
	[tipo_resolucion_id] [int] NULL,
	[concepto] [int] NULL,
	[medio_recepcion] [varchar](100) NULL,
	[observacion] [text] NULL,
	[dias] [int] NULL,
	[fecha_novedad] [datetime] NOT NULL,
	[fecha_resolucion] [datetime] NOT NULL,
	[fecha_alta] [datetime] NOT NULL,
 CONSTRAINT [PK_legajo_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[responsable]    Script Date: 30/5/2022 17:12:29 ******/
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
/****** Object:  Table [dbo].[sector]    Script Date: 30/5/2022 17:12:29 ******/
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
/****** Object:  Table [dbo].[tipo_novedad]    Script Date: 30/5/2022 17:12:29 ******/
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
/****** Object:  Table [dbo].[tipo_resolucion]    Script Date: 30/5/2022 17:12:29 ******/
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
/****** Object:  Table [dbo].[ubicacion]    Script Date: 30/5/2022 17:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ubicacion](
	[codigo] [int] NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ubicacion] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario]    Script Date: 30/5/2022 17:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario](
	[UsuarioID] [varchar](255) NOT NULL,
	[clave] [varchar](255) NOT NULL,
	[apellido] [varchar](100) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[perfil_id] [int] NULL,
 CONSTRAINT [PK_usuario] PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[categoria] ON 

INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (1, N'Oficial')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (2, N'No calificado')
SET IDENTITY_INSERT [dbo].[categoria] OFF
GO
SET IDENTITY_INSERT [dbo].[categoria_novedad] ON 

INSERT [dbo].[categoria_novedad] ([id], [descripcion]) VALUES (1, N'Sanciones')
INSERT [dbo].[categoria_novedad] ([id], [descripcion]) VALUES (2, N'Felicitaciones')
SET IDENTITY_INSERT [dbo].[categoria_novedad] OFF
GO
INSERT [dbo].[legajo] ([nro_legajo], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta]) VALUES (1889, N'Fabian', N'Ariel', 1, 1, 1, CAST(N'2022-05-23T17:00:27.960' AS DateTime))
INSERT [dbo].[legajo] ([nro_legajo], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta]) VALUES (1990, N'Perez', N'Juan', 1, 1, 1, CAST(N'2022-05-23T16:08:37.537' AS DateTime))
INSERT [dbo].[legajo] ([nro_legajo], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta]) VALUES (1991, N'Benitez', N'Micaela', 1, 1, 1, CAST(N'2022-05-30T14:50:02.287' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[novedad] ON 

INSERT [dbo].[novedad] ([id], [nro_legajo], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (1, 1990, 0, 1, 1, 2, -1, NULL, NULL, N'Prueba', NULL, CAST(N'2022-05-04T00:00:00.000' AS DateTime), CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T14:28:27.770' AS DateTime))
INSERT [dbo].[novedad] ([id], [nro_legajo], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (2, 1990, 129, 1, 2, -1, -1, NULL, NULL, N'asdasewd3', NULL, CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T14:53:25.257' AS DateTime))
INSERT [dbo].[novedad] ([id], [nro_legajo], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (3, 1990, -1, -1, -1, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T15:56:48.937' AS DateTime))
INSERT [dbo].[novedad] ([id], [nro_legajo], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (4, 1990, 0, 2, 1, 3, NULL, 6, NULL, N'Llegó tarde', 1, CAST(N'2022-05-27T00:00:00.000' AS DateTime), CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T15:58:21.563' AS DateTime))
INSERT [dbo].[novedad] ([id], [nro_legajo], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (5, 1990, 0, 1, 1, 1, 1, NULL, NULL, N'HJHJ', NULL, CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T00:00:00.000' AS DateTime), CAST(N'2022-05-30T16:52:40.667' AS DateTime))
SET IDENTITY_INSERT [dbo].[novedad] OFF
GO
SET IDENTITY_INSERT [dbo].[responsable] ON 

INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (1, N'Cossettini', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (2, N'Galletti', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (3, N'Perilli', NULL)
SET IDENTITY_INSERT [dbo].[responsable] OFF
GO
SET IDENTITY_INSERT [dbo].[sector] ON 

INSERT [dbo].[sector] ([id], [descripcion]) VALUES (1, N'Sector 1')
SET IDENTITY_INSERT [dbo].[sector] OFF
GO
SET IDENTITY_INSERT [dbo].[tipo_novedad] ON 

INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (1, N'Descargo')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (2, N'Mail')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (3, N'Falta puntualidad')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (4, N'Informe')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (5, N'Inasistencia')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (6, N'Web')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (7, N'Libro de quejas')
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
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (0, N'FABRICA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (104, N'CORDOBA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (107, N'FLORIDA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (109, N'ABASTO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (111, N'CENTENERA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (117, N'CABILDO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (121, N'PARANA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (129, N'ALTO PALERMO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (131, N'PQE. BROWN')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (136, N'ONCE')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (138, N'ARCOS')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (142, N'SANTA FE')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (146, N'FOREST')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (148, N'CABILDO NUEVO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (150, N'CUENCA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (152, N'LACROZE')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (257, N'SAN ISIDRO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (300, N'RNW CENTRAL')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (301, N'ROSARIO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (303, N'CBA RANAWELL')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (305, N'ALTO AVELLANEDA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (307, N'RNW BARILOCHE')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (309, N'RNW PORTAL')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (311, N'MARTINEZ')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (313, N'MARDEL')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (315, N'COMODORO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (318, N'RNW LAINEZ')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (324, N'RNWMENDOZA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (326, N'LOMAS DE ZAMORA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (328, N'RNWWEB')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (330, N'TERRAZAS')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (332, N'SANJUSTO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (334, N'PLA_MENDOZA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (336, N'PTAL ROSARIO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (338, N'SALTA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (340, N'SHOPPING CORDOBA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (342, N'NINE SHOPPING')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (344, N'UNICENTER')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (346, N'ALTO ROSARIO SHOPPING')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (348, N'RNW JUJUY')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (350, N'TUCUMAN')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (354, N'MARTINEZ NUEVO')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (356, N'CORDOBA CITYMALL')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (501, N'FRL USHUAIA')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (504, N'FRL RIO 1')
INSERT [dbo].[ubicacion] ([codigo], [descripcion]) VALUES (506, N'FRL PASEO DEL FUEGO')
GO
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'admin', N'$2a$11$nwvwgKPC7D5gClFbg6L4ie3sJH5fF0tkIrMVZN6fs.czFbg8Dg3km', N'Admin', N'Admin', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'ale', N'$2a$11$GOR9eH2EUkuf/FUs3jFpvOjNA9ORyE7sFZYYOTzEBpvffAs9vJHua', N'Goral', N'Alejandro', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'ari', N'$2a$11$721HZiAYh8gAr6KgKn9mj.kgSlIQl31r2J1DaIkTFolSFFMmAoBVG', N'Fabian', N'Ariel', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'flor', N'$2a$11$xtBSMYVhXrtv6.g7LCJxbu./EYa6MzSK0UB1lZkBA9R23MN3AkXea', N'Ardanaz', N'Florencia', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'Gustavo', N'$2a$11$X1.TB2hNkYYtxz5FPEP2AeOn8Qa6Ok7MX0.jWgKrGfQcLKL5/yr8q', N'Fernandez', N'Gustavo', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'martin', N'$2a$11$7EDfpme8OPdwV7HaB2GCpeRuLlqBOPVakfGg7vA.JolxKog4stQ/i', N'Pais', N'Martín', 2)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'mati', N'$2a$11$MXVnjJBKSlGY/vzvLyQjO.sbYvlvO0fbaQFX6aoRXPS5wNavmTkIG', N'Sperk', N'Matias', 2)
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD  CONSTRAINT [legajo_categoria_FK] FOREIGN KEY([categoria_id])
REFERENCES [dbo].[categoria] ([id])
GO
ALTER TABLE [dbo].[legajo] CHECK CONSTRAINT [legajo_categoria_FK]
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD  CONSTRAINT [legajo_sector_FK] FOREIGN KEY([sector_id])
REFERENCES [dbo].[sector] ([id])
GO
ALTER TABLE [dbo].[legajo] CHECK CONSTRAINT [legajo_sector_FK]
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaEliminar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaInsertar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaModificar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtener]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria]

GO
/****** Object:  StoredProcedure [dbo].[spLegajoEliminar]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoEliminar] 
@nro_legajo int
AS

delete 
from legajo 
where nro_legajo =  @nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLegajoInsertar]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoInsertar] 
@nro_legajo int,
@apellido varchar(50),
@nombre varchar(50),
@sector_id int,
@categoria_id int,
@activo bit,
@fecha_alta datetime
AS

declare @c as int 

select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c>0 return

INSERT INTO legajo
(
   nro_legajo, 
   apellido, 
   nombre, 
   sector_id, 
   categoria_id, 
   activo, 
   fecha_alta
 )
VALUES
(
   @nro_legajo, 
   @apellido, 
   @nombre, 
   @sector_id, 
   @categoria_id, 
   @activo, 
   @fecha_alta
)

GO
/****** Object:  StoredProcedure [dbo].[spLegajoModificar]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoModificar] 
@nro_legajo int,
@apellido varchar(50),
@nombre varchar(50),
@sector_id int,
@categoria_id int,
@activo bit,
@fecha_alta datetime
AS

declare @c as int 

select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c<>1 return

UPDATE legajo
SET  apellido=@apellido, 
     nombre=@nombre, 
     sector_id=@sector_id, 
     categoria_id=@categoria_id, 
     activo=@activo, 
     fecha_alta=@fecha_alta
where nro_legajo =  @nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtener]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtener] 
@nro_legajo int
AS

select l.*,
       s.descripcion as sector,
       c.descripcion as categoria
from legajo l
left join sector s on l.sector_id = s.id 
left join categoria c ON l.categoria_id = c.id 
where nro_legajo =  @nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
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
left join sector s on l.sector_id = s.id 
left join categoria c ON l.categoria_id = c.id 
where  (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and    (@apellido='' or l.apellido like '%'+ @apellido +'%')
order by nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLogin]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLogin] 
@UsuarioID varchar(255)
AS

select UsuarioID,
       clave,      
       Apellido,
       Nombre,
	   perfil_id
from usuario
where UsuarioID=@UsuarioID;
GO
/****** Object:  StoredProcedure [dbo].[spNovedadEliminar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadInsertar]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadInsertar] 
@nro_legajo int,
@ubicacion_id int,
@responsable_id int,
@categoria_novedad_id int,
@tipo_novedad_id int,
@tipo_resolucion_id int,
@concepto int,
@dias int,
@medio_recepcion varchar(100),
@observacion text,
@fecha_novedad datetime, 
@fecha_resolucion datetime

AS

declare @c as int 

select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c<>1 return -1

INSERT INTO novedad
(
 nro_legajo, 
 ubicacion_id,
 responsable_id,
 categoria_novedad_id, 
 tipo_novedad_id, 
 tipo_resolucion_id, 
 concepto, 
 dias, 
 medio_recepcion, 
 observacion, 
 fecha_novedad, 
 fecha_resolucion, 
 fecha_alta
 )

VALUES
(
 @nro_legajo, 
 @ubicacion_id,
 @responsable_id,
 @categoria_novedad_id, 
 @tipo_novedad_id, 
 @tipo_resolucion_id, 
 @concepto, 
 @dias, 
 @medio_recepcion, 
 @observacion, 
 @fecha_novedad, 
 @fecha_resolucion, 
 getdate()
)

return 0
GO
/****** Object:  StoredProcedure [dbo].[spNovedadModificar]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadModificar] 
@id int,
@nro_legajo int,
@ubicacion_id int,
@responsable_id int,
@categoria_novedad_id int,
@tipo_novedad_id int,
@tipo_resolucion_id int,
@concepto int,
@dias int,
@medio_recepcion varchar(100),
@observacion text,
@fecha_novedad datetime, 
@fecha_resolucion datetime

AS

declare @c as int 

select @c = (Select count(*) from legajo where nro_legajo=@nro_legajo)

if @c<>1 return -1

UPDATE novedad
SET nro_legajo=@nro_legajo, 
    ubicacion_id=@ubicacion_id, 
    responsable_id=@responsable_id, 
    categoria_novedad_id=@categoria_novedad_id, 
    tipo_novedad_id=@tipo_novedad_id, 
    tipo_resolucion_id=@tipo_resolucion_id, 
    concepto=@concepto, 
    dias=@dias, 
    medio_recepcion=@medio_recepcion, 
    observacion=@observacion, 
    fecha_novedad=@fecha_novedad, 
    fecha_resolucion=@fecha_resolucion
WHERE id = @id

return 0
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtener]    Script Date: 30/5/2022 17:12:30 ******/
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
       tr.descripcion as tipo_resolucion
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
where nov.id = @id 
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerTodos] 
@categoria_novedad_id int, 
@tipo_novedad_id int,
@tipo_resolucion_id int,
@nro_legajo int,
@fecha_novedad_desde datetime,
@fecha_novedad_hasta datetime

AS
Select nov.*,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion,
       l.apellido,
       l.nombre,
       u.descripcion as ubicacion,
       r.apellido as responsable
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.nro_legajo = l.nro_legajo 
left join ubicacion u on nov.ubicacion_id = u.codigo  
left join responsable r on nov.responsable_id = r.id
where (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or nov.nro_legajo = @nro_legajo)
and   (nov.fecha_novedad  >= @fecha_novedad_desde)
and   (nov.fecha_novedad  <= @fecha_novedad_hasta)
order by fecha_novedad desc 
GO
/****** Object:  StoredProcedure [dbo].[spSectorEliminar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorInsertar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorModificar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtener]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[sector]

GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadEliminar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadInsertar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadModificar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtener]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionEliminar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionInsertar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionModificar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtener]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[tipo_resolucion]

GO
/****** Object:  StoredProcedure [dbo].[spUsuarioCambiarClave]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioEliminar]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioEliminar] 
@UsuarioID varchar(255)
AS

delete from usuario where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioInsertar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioModificar]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtener]    Script Date: 30/5/2022 17:12:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerTodos]    Script Date: 30/5/2022 17:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioObtenerTodos] 
AS

select a.*, perfil_id as perfil_descripcion 
from usuario a  
order by apellido, nombre
GO
