/****** Object:  Table [dbo].[categoria]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[categoria_novedad]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[legajo]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[novedad]    Script Date: 27/5/2022 17:04:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[novedad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nro_legajo] [int] NOT NULL,
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
/****** Object:  Table [dbo].[responsable]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[sector]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[tipo_novedad]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[tipo_resolucion]    Script Date: 27/5/2022 17:04:42 ******/
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
/****** Object:  Table [dbo].[usuario]    Script Date: 27/5/2022 17:04:42 ******/
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

INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (1, N'Categoría 1')
SET IDENTITY_INSERT [dbo].[categoria] OFF
GO
SET IDENTITY_INSERT [dbo].[categoria_novedad] ON 

INSERT [dbo].[categoria_novedad] ([id], [descripcion]) VALUES (1, N'Sanciones')
INSERT [dbo].[categoria_novedad] ([id], [descripcion]) VALUES (2, N'Felicitaciones')
SET IDENTITY_INSERT [dbo].[categoria_novedad] OFF
GO
INSERT [dbo].[legajo] ([nro_legajo], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta]) VALUES (1889, N'Fabian', N'Ariel', 1, 1, 1, CAST(N'2022-05-23T17:00:27.960' AS DateTime))
INSERT [dbo].[legajo] ([nro_legajo], [apellido], [nombre], [sector_id], [categoria_id], [activo], [fecha_alta]) VALUES (1990, N'Perez', N'Juan', 1, 1, 1, CAST(N'2022-05-23T16:08:37.537' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[novedad] ON 

INSERT [dbo].[novedad] ([id], [nro_legajo], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (1, 1889, 1, 2, 1, 6, N'med1', N'obs1', 1, CAST(N'2022-05-27T16:49:56.690' AS DateTime), CAST(N'2022-05-27T16:49:56.690' AS DateTime), CAST(N'2022-05-27T16:49:44.977' AS DateTime))
INSERT [dbo].[novedad] ([id], [nro_legajo], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (2, 1990, 2, 2, 1, 2, NULL, NULL, 2, CAST(N'2022-05-27T17:02:06.650' AS DateTime), CAST(N'2022-05-27T17:02:06.650' AS DateTime), CAST(N'2022-05-27T16:50:55.317' AS DateTime))
INSERT [dbo].[novedad] ([id], [nro_legajo], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [medio_recepcion], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta]) VALUES (4, 1990, 2, NULL, NULL, NULL, NULL, N'Congrats!', NULL, CAST(N'2022-05-27T16:54:31.193' AS DateTime), CAST(N'2022-05-27T16:54:31.197' AS DateTime), CAST(N'2022-05-27T16:55:07.390' AS DateTime))
SET IDENTITY_INSERT [dbo].[novedad] OFF
GO
SET IDENTITY_INSERT [dbo].[responsable] ON 

INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (1, N'Cossettini', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (2, N'Galletti', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (3, N'Perilli
', NULL)
SET IDENTITY_INSERT [dbo].[responsable] OFF
GO
SET IDENTITY_INSERT [dbo].[sector] ON 

INSERT [dbo].[sector] ([id], [descripcion]) VALUES (1, N'Sector 1')
SET IDENTITY_INSERT [dbo].[sector] OFF
GO
SET IDENTITY_INSERT [dbo].[tipo_novedad] ON 

INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (1, N'Descargo')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (2, N'Mail')
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (3, N'Llegada Tarde')
SET IDENTITY_INSERT [dbo].[tipo_novedad] OFF
GO
SET IDENTITY_INSERT [dbo].[tipo_resolucion] ON 

INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (1, N'Notificación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (2, N'Amonestación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (3, N'Capacitación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (4, N'Suspensión')
SET IDENTITY_INSERT [dbo].[tipo_resolucion] OFF
GO
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'admin', N'$2a$11$nwvwgKPC7D5gClFbg6L4ie3sJH5fF0tkIrMVZN6fs.czFbg8Dg3km', N'Admin', N'Admin', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'ale', N'$2a$11$GOR9eH2EUkuf/FUs3jFpvOjNA9ORyE7sFZYYOTzEBpvffAs9vJHua', N'Goral', N'Alejandro', 1)
INSERT [dbo].[usuario] ([UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (N'ari', N'$2a$11$721HZiAYh8gAr6KgKn9mj.kgSlIQl31r2J1DaIkTFolSFFMmAoBVG', N'Fabian', N'Ariel', 1)
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
/****** Object:  StoredProcedure [dbo].[spCategoriaEliminar]    Script Date: 27/5/2022 17:04:43 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaInsertar]    Script Date: 27/5/2022 17:04:43 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaModificar]    Script Date: 27/5/2022 17:04:43 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtener]    Script Date: 27/5/2022 17:04:43 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtenerTodos]    Script Date: 27/5/2022 17:04:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria]

GO
/****** Object:  StoredProcedure [dbo].[spLegajoEliminar]    Script Date: 27/5/2022 17:04:43 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoInsertar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoModificar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtener]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerTodos]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerTodos] 
AS


select l.*,
       s.descripcion as sector,
       c.descripcion as categoria
from legajo l
left join sector s on l.sector_id = s.id 
left join categoria c ON l.categoria_id = c.id 
order by nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLogin]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadEliminar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadInsertar]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadInsertar] 
@nro_legajo int,
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

if @c<>1return

INSERT INTO novedad
(
 nro_legajo, 
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
GO
/****** Object:  StoredProcedure [dbo].[spNovedadModificar]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadModificar] 
@id int,
@nro_legajo int,
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

if @c<>1 return

UPDATE novedad
SET nro_legajo=@nro_legajo, 
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
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtener]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerTodos]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerTodos] 
@categoria_novedad_id int, 
@tipo_novedad_id int,
@tipo_resolucion_id int

AS
Select nov.*,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
where (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or tipo_resolucion_id = @tipo_resolucion_id)
order by fecha_novedad desc 
GO
/****** Object:  StoredProcedure [dbo].[spSectorEliminar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorInsertar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorModificar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtener]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtenerTodos]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[sector]

GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadEliminar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadInsertar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadModificar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtener]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtenerTodos]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoNovedadObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[tipo_novedad]

GO
/****** Object:  StoredProcedure [dbo].[spTipoResolucionEliminar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionInsertar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionModificar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtener]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtenerTodos]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoResolucionObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[tipo_resolucion]

GO
/****** Object:  StoredProcedure [dbo].[spUsuarioCambiarClave]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioEliminar]    Script Date: 27/5/2022 17:04:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioEliminar] 
@UsuarioID varchar(255)
AS

delete from usuario where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioInsertar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioModificar]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtener]    Script Date: 27/5/2022 17:04:44 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerTodos]    Script Date: 27/5/2022 17:04:44 ******/
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
