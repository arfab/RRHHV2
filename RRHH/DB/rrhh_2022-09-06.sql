USE [RRHH]
GO
/****** Object:  Table [dbo].[calendario]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[calendario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[anio] [smallint] NULL,
	[mes] [smallint] NULL,
	[dia] [smallint] NULL,
	[dia_semana] [varchar](10) NULL,
	[feriado] [smallint] NOT NULL,
 CONSTRAINT [PK_FECHAS] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_FECHAS] UNIQUE NONCLUSTERED 
(
	[fecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[categoria]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[categoria_novedad]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[empresa]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[funcion]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[genero]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[genero](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_genero] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[importacion]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[importacion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [varchar](10) NOT NULL,
	[nombre_archivo] [varchar](200) NOT NULL,
	[fecha] [datetime] NULL,
	[cantidad] [int] NOT NULL,
	[errores] [int] NOT NULL,
 CONSTRAINT [PK_importacion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[justificacion]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[justificacion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nro_legajo] [int] NOT NULL,
	[fecha] [date] NOT NULL,
	[categoria_id] [int] NOT NULL,
	[fecha_alta] [datetime] NOT NULL,
	[usuario_id] [int] NULL,
	[descripcion] [varchar](200) NULL,
 CONSTRAINT [PK_ljustificaion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legajo]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[empresa_id] [int] NOT NULL,
	[nro_legajo] [int] NOT NULL,
	[dni] [int] NULL,
	[genero_id] [int] NULL,
	[ubicacion_id] [int] NOT NULL,
	[sector_id] [int] NULL,
	[local_id] [int] NULL,
	[apellido] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[categoria_id] [int] NULL,
	[funcion_id] [int] NULL,
	[activo] [bit] NOT NULL,
	[fecha_alta] [datetime] NULL,
	[fecha_baja] [datetime] NULL,
	[observacion] [text] NULL,
 CONSTRAINT [PK_Legajo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[legajo_fichada]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[legajo_fichada](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lectora_id] [int] NOT NULL,
	[legajo_id] [int] NOT NULL,
	[fecha] [date] NULL,
	[entrada1] [varchar](8) NULL,
	[salida1] [varchar](8) NULL,
	[entrada2] [varchar](8) NULL,
	[salida2] [varchar](8) NULL,
 CONSTRAINT [PK_legajo_fichada] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mapeo_importacion]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mapeo_importacion](
	[variable] [varchar](50) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
	[codigo] [int] NOT NULL,
 CONSTRAINT [PK_variable] PRIMARY KEY CLUSTERED 
(
	[descripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[novedad]    Script Date: 6/9/2022 17:16:23 ******/
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
	[dias] [int] NULL,
	[fecha_novedad] [datetime] NOT NULL,
	[fecha_resolucion] [datetime] NULL,
	[fecha_alta] [datetime] NOT NULL,
	[sector_id] [int] NULL,
	[usuario_id] [int] NULL,
	[local_id] [int] NULL,
	[descripcion] [varchar](2000) NULL,
	[estado] [varchar](50) NULL,
	[observacion] [varchar](2000) NULL,
	[responsable] [varchar](200) NULL,
 CONSTRAINT [PK_legajo_novedad] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[perfil]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[responsable]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[sector]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sector](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
	[ubicacion_id] [int] NULL,
 CONSTRAINT [PK_sector] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipo_novedad]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[tipo_resolucion]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[ubicacion]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[usuario]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  Table [dbo].[usuario_log]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[accion_id] [int] NOT NULL,
	[UsuarioID] [varchar](255) NULL,
	[sitio_web] [varchar](255) NULL,
 CONSTRAINT [PK_usuario_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuario_web]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuario_web](
	[UsuarioID] [varchar](255) NOT NULL,
	[sitio_web] [varchar](255) NOT NULL,
	[guid] [varchar](255) NULL,
	[perfil_id] [int] NULL,
 CONSTRAINT [PK_usuario_sitio] PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC,
	[sitio_web] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[web]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web](
	[nombre] [varchar](255) NOT NULL,
	[url] [varchar](255) NOT NULL,
	[home_page] [varchar](255) NULL,
 CONSTRAINT [PK_nombre] PRIMARY KEY CLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[web_perfil]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_perfil](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](255) NOT NULL,
	[perfil_id] [int] NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_web_perfil] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[calendario] ADD  DEFAULT ((0)) FOR [feriado]
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([empresa_id])
REFERENCES [dbo].[empresa] ([id])
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([funcion_id])
REFERENCES [dbo].[funcion] ([id])
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([funcion_id])
REFERENCES [dbo].[funcion] ([id])
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([genero_id])
REFERENCES [dbo].[genero] ([id])
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([sector_id])
REFERENCES [dbo].[sector] ([id])
GO
ALTER TABLE [dbo].[legajo]  WITH CHECK ADD FOREIGN KEY([ubicacion_id])
REFERENCES [dbo].[ubicacion] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([categoria_novedad_id])
REFERENCES [dbo].[categoria_novedad] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([legajo_id])
REFERENCES [dbo].[legajo] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([responsable_id])
REFERENCES [dbo].[responsable] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([sector_id])
REFERENCES [dbo].[sector] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([tipo_novedad_id])
REFERENCES [dbo].[tipo_novedad] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([tipo_resolucion_id])
REFERENCES [dbo].[tipo_resolucion] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([ubicacion_id])
REFERENCES [dbo].[ubicacion] ([id])
GO
ALTER TABLE [dbo].[novedad]  WITH CHECK ADD FOREIGN KEY([usuario_id])
REFERENCES [dbo].[usuario] ([id])
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaEliminar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaInsertar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaModificar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaNovedadObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtener]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria]

GO
/****** Object:  StoredProcedure [dbo].[spEmpresaObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spFichadaAgrupadaObtener]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFichadaAgrupadaObtener] 
@equipo_id int, 
@nro_legajo int,
@tipo char(1), 
@fecha_desde datetime,
@fecha_hasta datetime,
@tipo_listado int=1,
@empresa_id int=-1,
@ubicacion_id int=-1,
@sector_id int=-1


AS

select top 15000
    convert(date,fcd_fchr) as fecha,
    lgj_nro_legajo as nro_legajo,
    legajo_id,
    lectora_id,
    ltr_descripcion as lectora,
    ltrim(str(lgj_nro_legajo)) + ' - ' +  apellido + ', ' + nombre + ' (' + nomenclatura + ')' as empleado,
    max(case when rn = 1 then convert(varchar(8),convert(time,fcd_fchr)) end) lec1,
    max(case when rn = 1 then taes_id end) tipo1,
    max(case when rn = 2 then convert(varchar(8),convert(time,fcd_fchr)) end) lec2,
    max(case when rn = 2 then taes_id end) tipo2,
    max(case when rn = 3 then convert(varchar(8),convert(time,fcd_fchr)) end) lec3,
    max(case when rn = 3 then taes_id end) tipo3,
    max(case when rn = 4 then convert(varchar(8),convert(time,fcd_fchr)) end) lec4,
    max(case when rn = 4 then taes_id end) tipo4,
    max(case when rn = 5 then convert(varchar(8),convert(time,fcd_fchr)) end) lec5,
    max(case when rn = 5 then taes_id end) tipo5,
    max(case when rn = 6 then convert(varchar(8),convert(time,fcd_fchr)) end) lec6,
    max(case when rn = 6 then fcd_fchr end) tipo6,
    '' as justificacion    
from (
    select f.*, leg.id as legajo_id, lec.ltr_id  as lectora_id, lec.ltr_descripcion, leg.apellido, leg.nombre , e.nomenclatura,  row_number() over(partition by  convert(date,fcd_fchr),lgj_nro_legajo order by fcd_fchr) rn
    from fichadas f  
    inner join lectores lec on f.ltr_nro_equipo =lec.ltr_nro_equipo 
    --inner join legajo leg on f.lgj_nro_legajo = leg.nro_legajo
    inner join legajo leg on f.lgj_nro_legajo = leg.nro_legajo and 
       (f.ltr_nro_equipo BETWEEN 100 and 299 and  leg.local_id BETWEEN 100 and 299 or 
        f.ltr_nro_equipo BETWEEN 300 and 399 and  leg.local_id BETWEEN 300 and 399 or
        f.ltr_nro_equipo BETWEEN 400 and 499 and  leg.local_id BETWEEN 400 and 499 or 
        f.ltr_nro_equipo BETWEEN 500 and 599 and  leg.local_id BETWEEN 500 and 599 or 
        f.ltr_nro_equipo BETWEEN 600 and 699 and  leg.local_id BETWEEN 600 and 699 or 
        f.ltr_nro_equipo BETWEEN 700 and 799 and  leg.local_id BETWEEN 700 and 799 or 
        f.ltr_nro_equipo in (15) and leg.ubicacion_id =4 or 
        f.ltr_nro_equipo < 100 and f.ltr_nro_equipo not in (15) and  leg.local_id is null 
       )    
    inner join empresa e on leg.empresa_id = e.id
    left join sector s on leg.sector_id = s.id 
    left join MontagneProduccion.dbo.Locales loca on leg.local_id = loca.Codigo 
    left join ubicacion u ON leg.ubicacion_id = u.id 
where (@nro_legajo=-1 or f.lgj_nro_legajo = @nro_legajo)
and   (@fecha_desde is null or convert(date,f.fcd_fchr)  >= convert(date,@fecha_desde))
and   (@fecha_hasta is null or convert(date,f.fcd_fchr) <= convert(date,@fecha_hasta))
and    (@empresa_id=-1 or leg.empresa_id = @empresa_id)
and    (@nro_legajo=-1 or leg.nro_legajo = @nro_legajo)
and    (@ubicacion_id=-1 or u.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2,4) and (@sector_id=-1 or s.id = @sector_id) or @ubicacion_id = 3 and 
          (@sector_id=-1 or  @sector_id = lec.ltr_nro_equipo 
             )  
          )
and not exists (select 1 from legajo_fichada lf where lf.legajo_id=leg.id  and convert(date,f.fcd_fchr)=convert(date,lf.fecha))          
) t
group by convert(date,fcd_fchr ), legajo_id, lgj_nro_legajo, lectora_id, ltr_descripcion, apellido, nombre, nomenclatura
union all
select lf2.fecha,
       l2.nro_legajo,
       l2.id,
       lf2.lectora_id, 
       case when lf2.lectora_id =-1 then 'Manual' else lec2.ltr_descripcion end ,
       ltrim(str(l2.nro_legajo)) + ' - ' +  l2.apellido + ', ' + l2.nombre + ' (' + nomenclatura + ')' as empleado,              
       lf2.entrada1,
       case when lf2.entrada1 is null then null else 'E' end ,
       lf2.salida1,
       case when lf2.salida1 is null then null else 'S' end ,
       lf2.entrada2,
       case when lf2.entrada2 is null then null else 'E' end ,
       lf2.salida2,
       case when lf2.salida2 is null then null else 'S' end ,
       null,null,null,null,
       '' 
from legajo_fichada lf2 
inner join legajo l2 on lf2.legajo_id = l2.id
inner join empresa e2 on l2.empresa_id = e2.id
left join lectores lec2 on lf2.lectora_id  =lec2.ltr_id  
left join sector s2 on l2.sector_id = s2.id 
left join ubicacion u2 ON l2.ubicacion_id = u2.id 
where (@nro_legajo=-1 or l2.nro_legajo = @nro_legajo)
and   (@fecha_desde is null or convert(date,lf2.fecha)  >= convert(date,@fecha_desde))
and   (@fecha_hasta is null or convert(date,lf2.fecha) <= convert(date,@fecha_hasta))
and    (@empresa_id=-1 or l2.empresa_id = @empresa_id)
and    (@ubicacion_id=-1 or u2.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2,4) and (@sector_id=-1 or s2.id = @sector_id) or @ubicacion_id = 3 and 
          (@sector_id=-1 or  @sector_id = lec2.ltr_nro_equipo 
             )  
          )
and   (@tipo_listado=0 or lf2.entrada1 is not null or lf2.salida1 is not null or lf2.entrada2 is not null or lf2.salida2 is not null )
/*union all 
select top 1000
    convert(date,fecha) as fecha,
    legajo as nro_legajo,
    ltrim(str(legajo)) + ' - ' +  apellido + ', ' + nombre + ' (' + nomenclatura + ')' as empleado,
    max(case when rn = 1 then hora end) lec1,
    max(case when rn = 1 then TipoFichada end) tipo1,
    max(case when rn = 2 then hora end) lec2,
    max(case when rn = 2 then TipoFichada end) tipo2,
    max(case when rn = 3 then hora end) lec3,
    max(case when rn = 3 then TipoFichada end) tipo3,
    max(case when rn = 4 then hora end) lec4,
    max(case when rn = 4 then TipoFichada end) tipo4,
max(case when rn = 5 then hora end) lec5,
    max(case when rn = 5 then TipoFichada end) tipo5,
    max(case when rn = 6 then hora end) lec6,
    max(case when rn = 6 then TipoFichada end) tipo6,
    '' as justificacion    
from (
    select f.*, leg.apellido, leg.nombre , e.nomenclatura,  row_number() over(partition by  convert(date,fecha),legajo order by fecha) rn
    from MontagneProduccion.dbo.FichadasRelojes f  
    inner join lectores lec on f.empresa =lec.ltr_nro_equipo 
inner join legajo leg on f.legajo = leg.nro_legajo
    inner join empresa e on leg.empresa_id = e.id
    left join sector s on leg.sector_id = s.id 
    left join MontagneProduccion.dbo.Locales loca on leg.local_id = loca.Codigo 
    left join ubicacion u ON leg.ubicacion_id = u.id 
where (@nro_legajo=-1 or f.legajo = @nro_legajo)
and   (@fecha_desde is null or convert(date,f.fecha)  >= convert(date,@fecha_desde))
and   (@fecha_hasta is null or convert(date,f.fecha) <= convert(date,@fecha_hasta))
and    (@empresa_id=-1 or leg.empresa_id = @empresa_id)
and    (@nro_legajo=-1 or leg.nro_legajo = @nro_legajo)
and    (@ubicacion_id=-1 or u.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2) and (@sector_id=-1 or s.id = @sector_id) or @ubicacion_id = 3 and (@sector_id=-1 or leg.local_id = @sector_id))
) t
group by convert(date,fecha ),legajo, apellido, nombre, nomenclatura*/
union  all
select
    convert(date,c.fecha) as fecha,
    leg.nro_legajo as nro_legajo,
    leg.id,
    -1 as lectora_id,
    '' as lectora,
    ltrim(str(leg.nro_legajo)) + ' - ' +  leg.apellido + ', ' + leg.nombre + ' (' + e.nomenclatura + ')' as empleado,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    case when j.id is null then '' else cc.cpacat_descripcion  end  as justificacion
from calendario c 
left join legajo leg on 1=1
inner join empresa e on leg.empresa_id = e.id
left join sector s on leg.sector_id = s.id 
left join MontagneProduccion.dbo.Locales loca on leg.local_id = loca.Codigo 
left join ubicacion u ON leg.ubicacion_id = u.id 
left join justificacion j on  j.fecha = convert(date, c.fecha) and j.nro_legajo=leg.nro_legajo 
left join cpa_categorias cc on j.categoria_id =cc.cpacat_id 
where  not exists (select 1 from fichadas f3 where convert(date,c.fecha)=convert(date,f3.fcd_fchr) and f3.lgj_nro_legajo=leg.nro_legajo )
and   (convert(date,c.fecha)  >= leg.fecha_alta)
and   (@fecha_desde is null or  convert(date,c.fecha)  >= convert(date,@fecha_desde))
and  (@fecha_hasta is null or convert(date,c.fecha) <= convert(date,@fecha_hasta))
and   (@tipo_listado=0)
and    (@empresa_id=-1 or leg.empresa_id = @empresa_id)
and    (@ubicacion_id=-1 or u.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2,4) and (@sector_id=-1 or s.id = @sector_id) or @ubicacion_id = 3 and (@sector_id=-1 or leg.local_id = @sector_id))
and   (@nro_legajo is not null and @nro_legajo<>-1 and leg.nro_legajo=@nro_legajo or 
       (@nro_legajo is null or @nro_legajo=-1) and @fecha_desde is not null and @fecha_hasta is not null and convert(date,@fecha_desde)=convert(date,@fecha_hasta))
order by convert(date,fcd_fchr), lec1

--convert(date,c.fecha)>=(select min(convert(date,f2.fcd_fchr)) from fichadas f2 where f2.lgj_nro_legajo =leg.nro_legajo ) 
--and convert(date,c.fecha)<=(select max(convert(date,f2.fcd_fchr)) from fichadas f2 where f2.lgj_nro_legajo =leg.nro_legajo ) 
GO
/****** Object:  StoredProcedure [dbo].[spFichadaObtenerCantidad]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFichadaObtenerCantidad] 
@equipo_id int, 
@nro_legajo int,
@tipo char(1), 
@fecha_desde datetime,
@fecha_hasta datetime

AS

select count(*)
from fichadas f 
inner join lectores lec on f.ltr_nro_equipo =lec.ltr_nro_equipo 
inner join legajo leg on f.lgj_nro_legajo = leg.nro_legajo
inner join empresa e on leg.empresa_id = e.id
where (@nro_legajo=-1 or f.lgj_nro_legajo = @nro_legajo)
and   (@fecha_desde is null or f.fcd_fchr  >= @fecha_desde)
and   (@fecha_hasta is null or f.fcd_fchr <= @fecha_hasta)

GO
/****** Object:  StoredProcedure [dbo].[spFichadaObtenerPag]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFichadaObtenerPag] 
@pag as int,
@equipo_id int, 
@nro_legajo int,
@tipo char(1), 
@fecha_desde datetime,
@fecha_hasta datetime

AS

select  TOP 50 * FROM
(
   select  ROW_NUMBER() OVER (       
              order by f.fcd_fchr  desc
           ) AS RowNumber,
        lec.ltr_descripcion,
        leg.apellido,
        leg.nombre,
        leg.empresa_id,
        e.descripcion as empresa, 
        f.* 
from fichadas f 
inner join lectores lec on f.ltr_nro_equipo =lec.ltr_nro_equipo 
inner join legajo leg on f.lgj_nro_legajo = leg.nro_legajo
inner join empresa e on leg.empresa_id = e.id
where (@nro_legajo=-1 or f.lgj_nro_legajo = @nro_legajo)
and   (@fecha_desde is null or f.fcd_fchr  >= @fecha_desde)
and   (@fecha_hasta is null or f.fcd_fchr <= @fecha_hasta)
) _myResults
where rownumber >= (@pag-1)*50+1
order by  RowNumber
GO
/****** Object:  StoredProcedure [dbo].[spFuncionEliminar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFuncionEliminar] 
@id int
AS

DELETE FROM  [dbo].[funcion]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spFuncionInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFuncionInsertar] 
@descripcion varchar(100)
AS

INSERT INTO [dbo].[funcion]
(
 descripcion 
)
VALUES
(
 @descripcion
)
GO
/****** Object:  StoredProcedure [dbo].[spFuncionModificar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFuncionModificar] 
@id int,
@descripcion varchar(100)
AS

UPDATE [dbo].[funcion]
SET descripcion = @descripcion
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spFuncionObtener]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFuncionObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[funcion]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spFuncionObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spGeneroObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGeneroObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[genero]
order by id
GO
/****** Object:  StoredProcedure [dbo].[spImportacionInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportacionInsertar] 
@tipo varchar(10),
@nombre_archivo varchar(200),
@cantidad int,
@errores int
AS

INSERT INTO [dbo].[importacion]
(
 tipo,
 nombre_archivo,
 fecha,
 cantidad,
 errores
)
VALUES
(
 @tipo,
 @nombre_archivo,
 getdate(),
 @cantidad,
 @errores
)
GO
/****** Object:  StoredProcedure [dbo].[spImportacionObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportacionObtenerTodos] 
@tipo varchar(10)
AS

select * 
from importacion 
where (@tipo='' or tipo=@tipo)
order by fecha desc 


GO
/****** Object:  StoredProcedure [dbo].[spLegajoEliminar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoFichadaEliminar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoFichadaEliminar] 
  @id int
AS


Delete 
from  legajo_fichada
where id=@id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoFichadaInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoFichadaInsertar] 
  @legajo_id int,
  @lectora_id int,
  @fecha date,
  @entrada1 time,
  @salida1 time,
  @entrada2 time,
  @salida2 time
  
AS

declare @id as int 

select @id =  id 
from legajo_fichada lf 
where legajo_id=@legajo_id and fecha=@fecha

if @id is not null
begin 
  UPDATE legajo_fichada
  SET fecha=@fecha,
  entrada1= @entrada1,
  salida1=@salida1,
  entrada2=@entrada2,
  salida2=@salida2
where id = @id
end
ELSE 
begin

  INSERT INTO legajo_fichada
  (
  legajo_id,
  lectora_id,
  fecha,
  entrada1,
  salida1,
  entrada2,
  salida2
  )
  VALUES
  (
  @legajo_id,
  @lectora_id,
  @fecha,
  @entrada1,
  @salida1,
  @entrada2,
  @salida2
 )
 end

GO
/****** Object:  StoredProcedure [dbo].[spLegajoFichadaModificar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoFichadaModificar] 
  @id int,
  @fecha date,
  @entrada1 time,
  @salida1 time,
  @entrada2 time,
  @salida2 time
  
AS


UPDATE legajo_fichada
SET
  fecha=@fecha,
  entrada1= @entrada1,
  salida1=@salida1,
  entrada2=@entrada2,
  salida2=@salida2
where id = @id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoFichadaObtener]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoFichadaObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[legajo_fichada]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoFichadaObtenerPorLegajo]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoFichadaObtenerPorLegajo] 
@legajo_id int,
@fecha date
AS

SELECT * 
FROM  [dbo].[legajo_fichada]
WHERE legajo_id = @legajo_id
and   fecha=@fecha
GO
/****** Object:  StoredProcedure [dbo].[spLegajoFichadaObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoFichadaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[legajo_fichada]
order by legajo_id 
GO
/****** Object:  StoredProcedure [dbo].[spLegajoInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoInsertar] 
@empresa_id int,
@nro_legajo int,
@dni int,
@apellido varchar(50),
@nombre varchar(50),
@genero_id int,
@ubicacion_id int,
@sector_id int,
@local_id int,
@categoria_id int,
@funcion_id int,
@observacion text,
@activo bit,
@fecha_alta datetime,
@fecha_baja datetime
AS

declare @c as int 

select @c = (Select count(*) from legajo where empresa_id=@empresa_id and nro_legajo=@nro_legajo)

if @c>0 return

INSERT INTO legajo
(
   empresa_id,
   nro_legajo, 
   dni,
   apellido, 
   nombre, 
   genero_id,
   ubicacion_id,
   sector_id, 
   local_id,
   categoria_id, 
   funcion_id,
   observacion,
   activo, 
   fecha_alta,
   fecha_baja
 )
VALUES
(
   @empresa_id,
   @nro_legajo,
   @dni,
   @apellido, 
   @nombre, 
   @genero_id,
   @ubicacion_id,
   @sector_id, 
   @local_id,
   @categoria_id, 
   @funcion_id,
   @observacion,
   @activo, 
   @fecha_alta,
   @fecha_baja
)

GO
/****** Object:  StoredProcedure [dbo].[spLegajoModificar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoModificar] 
@id int,
@empresa_id int,
@nro_legajo int,
@dni int,
@apellido varchar(50),
@nombre varchar(50),
@genero_id int,
@ubicacion_id int,
@sector_id int,
@local_id int,
@categoria_id int,
@funcion_id int,
@observacion text,
@activo bit,
@fecha_alta datetime,
@fecha_baja datetime
AS

declare @c as int 

select @c = (Select count(*) from legajo where empresa_id=@empresa_id and nro_legajo=@nro_legajo)

if @c<>1 return

UPDATE legajo
SET  empresa_id=@empresa_id,
     dni=@dni, 
     apellido=@apellido, 
     nombre=@nombre, 
     genero_id=@genero_id, 
     ubicacion_id=@ubicacion_id, 
     sector_id=@sector_id, 
     local_id=@local_id, 
     categoria_id=@categoria_id,
     funcion_id=@funcion_id,
     observacion=@observacion, 
     activo=@activo, 
     fecha_alta=@fecha_alta,
     fecha_baja=@fecha_baja
where id =  @id
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtener]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtener] 
@id int
AS

select l.*,
       g.descripcion as genero,
       s.descripcion as sector,
       case when l.local_id =9999 then 'Supervisor' else loca.Descripcion end  as local,
       c.descripcion as categoria,
       e.descripcion as empresa,
       u.descripcion as ubicacion
from legajo l
left join sector s on l.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on l.local_id = loca.Codigo 
left join categoria c ON l.categoria_id = c.id 
left join empresa e ON l.empresa_id = e.id  
left join ubicacion u ON l.ubicacion_id = u.id 
left join genero g ON l.genero_id = g.id
where l.id = @id

GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerCantidad]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerCantidad] 
@empresa_id int, 
@nro_legajo int,
@ubicacion_id int,
@sector_id int,
@apellido varchar(50),
@activo int =-1
AS


select count(*)
from legajo l
left join sector s on l.sector_id = s.id 
left join MontagneProduccion.dbo.Locales loca on l.local_id = loca.Codigo 
left join categoria c ON l.categoria_id = c.id 
left join empresa e ON l.empresa_id = e.id  
left join ubicacion u ON l.ubicacion_id = u.id 
left join genero g ON l.genero_id = g.id
where  (@empresa_id=-1 or empresa_id = @empresa_id)
and    (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and    (@ubicacion_id=-1 or u.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2) and (@sector_id=-1 or s.id = @sector_id) or @ubicacion_id = 3 and (@sector_id=-1 or l.local_id = @sector_id))
and    (@apellido='' or l.apellido like '%'+ @apellido +'%')
and    (@activo=-1 or @activo=1 and fecha_baja is null or @activo=0 and fecha_baja is not null)
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerDeImportacion]    Script Date: 6/9/2022 17:16:23 ******/
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
@genero varchar(100),
@ubicacion_id int,
@observacion text

AS

declare @c int
declare @empresa_id int
declare @sector_id int 
declare @local_id int 
declare @categoria_id int 
declare @funcion_id int 
declare @genero_id int 
declare @variable varchar(50) 

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


if  @ubicacion_id=1 or @ubicacion_id=2 or @ubicacion_id=4
begin
  select @sector_id=s.id
  from sector   s
  where s.Descripcion = @sector
  
   set @local_id=NULL 
   
   if @sector_id is null
  begin 
	  
	if  @ubicacion_id=1
       set @variable = 'fabrica'
    else
      if @ubicacion_id=2
        set @variable='edificio'
      else 
        set @variable='deposito'
      
    select @sector_id=m.codigo 
    from mapeo_importacion m
    where m.Descripcion = @sector
    and   m.variable =@variable
  end    
  
  if @sector_id is null return -3
end
ELSE 
BEGIN 
  IF upper(ltrim(rtrim(@sector)))='SUPERVISOR'
    set @local_id=9999
  ELSE  
    select @local_id=l.Codigo 
    from MontagneProduccion.dbo.Locales l 
    where l.Descripcion = @sector
  
  set @sector_id=NULL 
  
  if @local_id is null
  begin 
	  
    set @variable = 'local'
      
    select @local_id=m.codigo 
    from mapeo_importacion m
    where m.Descripcion = @sector
    and   m.variable =@variable
  end 
  
  if @local_id is null return -3
end



select @categoria_id= c.id
from categoria c
where c.Descripcion = @categoria

if @categoria_id is null return -4

select @funcion_id=f.id
from funcion f 
where f.Descripcion = @funcion

if @funcion_id is null return -5

select @genero_id= g.id
from genero g
where SUBSTRING(g.descripcion,1,1) = @genero

if @genero_id is null return -6

select @nro_legajo as nro_legajo,
       @empresa_id as empresa_id,
       @sector_id as sector_id,
       @local_id as local_id,
       @categoria_id as categoria_id,
       @funcion_id as funcion_id,
       @genero_id as genero_id,
       @apellido as apellido,
       @nombre as nombre,
       @observacion as observacion,
       @ubicacion_id as ubicacion_id,
       case when @str_fecha_ingreso = '' then null else @str_fecha_ingreso end  as fecha_alta,
       case when  @str_fecha_baja = '' then null else  @str_fecha_baja end as fecha_baja

 return 0
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPag]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerPag] 
@pag as int,
@empresa_id int, 
@nro_legajo int,
@ubicacion_id int,
@sector_id int,
@apellido varchar(50),
@activo int =-1
AS


select  TOP 25 * FROM
(
   select  ROW_NUMBER() OVER (       
     order by nro_legajo 
         ) AS RowNumber,
		l.*,
       g.descripcion as genero,
       s.descripcion as sector,
       case when l.local_id =9999 then 'Supervisor' else loca.Descripcion end  as local,
       c.descripcion as categoria,
       e.descripcion as empresa,
       u.descripcion as ubicacion
from legajo l
left join sector s on l.sector_id = s.id 
left join MontagneProduccion.dbo.Locales loca on l.local_id = loca.Codigo  
left join categoria c ON l.categoria_id = c.id 
left join empresa e ON l.empresa_id = e.id  
left join ubicacion u ON l.ubicacion_id = u.id 
left join genero g ON l.genero_id = g.id
where  (@empresa_id=-1 or empresa_id = @empresa_id)
and    (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and    (@ubicacion_id=-1 or u.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2,4) and (@sector_id=-1 or s.id = @sector_id) or @ubicacion_id = 3 and (@sector_id=-1 or l.local_id = @sector_id))
and    (@apellido='' or l.apellido like '%'+ @apellido +'%')
and    (@activo=-1 or @activo=1 and fecha_baja is null or @activo=0 and fecha_baja is not null)
) _myResults
where rownumber >= (@pag-1)*25+1
order by  RowNumber
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorFiltro]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerPorFiltro] 
@filtro varchar(50)
AS


select l.id as id, ltrim(str(l.nro_legajo)) + ' - ' +  l.apellido + ', ' + l.nombre + ' (' + e.nomenclatura + ')' as descripcion
from legajo l
left join sector s on l.sector_id = s.id 
left join MontagneProduccion.dbo.Locales loca on l.local_id = loca.Codigo 
left join categoria c ON l.categoria_id = c.id 
left join empresa e ON l.empresa_id = e.id  
left join ubicacion u ON l.ubicacion_id = u.id 
left join genero g ON l.genero_id = g.id
where    (@filtro='' or 
          isnumeric(@filtro)=1 and ltrim(str(l.nro_legajo)) = ltrim(@filtro) or 
          isnumeric(@filtro)=0 and upper(ltrim(l.apellido)) =  upper(ltrim(@filtro)) 
          )
order by nro_legajo

GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorNro]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerPorNro] 
@empresa_id int,
@nro_legajo int
AS

select l.*,
       g.descripcion as genero,
       s.descripcion as sector,
       case when l.local_id =9999 then 'Supervisor' else loca.Descripcion end  as local,
       c.descripcion as categoria,
       e.descripcion as empresa,
       u.descripcion as ubicacion
from legajo l
left join sector s on l.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on l.local_id = loca.Codigo 
left join categoria c ON l.categoria_id = c.id 
left join empresa e ON l.empresa_id = e.id  
left join ubicacion u ON l.ubicacion_id = u.id 
left join genero g ON l.genero_id = g.id
where nro_legajo =  @nro_legajo
and   (@empresa_id=-1 and 1=(select count(*) from legajo l2 where l2.nro_legajo =  @nro_legajo) or 
       empresa_id=@empresa_id)




GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerTodos] 
@empresa_id int, 
@nro_legajo int,
@ubicacion_id int,
@sector_id int,
@apellido varchar(50),
@activo int =-1
AS


select l.*,
       ltrim(str(l.nro_legajo)) + ' - ' +  l.apellido + ', ' + l.nombre + ' (' + e.nomenclatura + ')' as descripcion,
       g.descripcion as genero,
       s.descripcion as sector,
       case when l.local_id =9999 then 'Supervisor' else loca.Descripcion end  as local,
       c.descripcion as categoria,
       e.descripcion as empresa,
       u.descripcion as ubicacion
from legajo l
left join sector s on l.sector_id = s.id 
left join MontagneProduccion.dbo.Locales loca on l.local_id = loca.Codigo 
left join categoria c ON l.categoria_id = c.id 
left join empresa e ON l.empresa_id = e.id  
left join ubicacion u ON l.ubicacion_id = u.id 
left join genero g ON l.genero_id = g.id
where  (@empresa_id=-1 or empresa_id = @empresa_id)
and    (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and    (@ubicacion_id=-1 or u.id = @ubicacion_id)
and    (@ubicacion_id=-1 or @ubicacion_id in (1,2) and (@sector_id=-1 or s.id = @sector_id) or @ubicacion_id = 3 and (@sector_id=-1 or l.local_id = @sector_id))
and    (@apellido='' or l.apellido like '%'+ @apellido +'%')
and    (@activo=-1 or @activo=1 and fecha_baja is null or @activo=0 and fecha_baja is not null)
order by nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLocalObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLocalObtenerTodos] 
AS



select Codigo as id ,
       Descripcion as Descripcion 
from   MontagneProduccion.dbo.Locales
union 
Select 9999,
       ' SUPERVISOR'
order by Descripcion 
GO
/****** Object:  StoredProcedure [dbo].[spLogin]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadEliminar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadInsertar] 
@legajo_id int,
@ubicacion_id int,
@sector_id int,
@local_id int,
@responsable varchar(200),
@categoria_novedad_id int,
@tipo_novedad_id int,
@tipo_resolucion_id int,
@concepto int,
@dias int,
@descripcion varchar(2000),
@estado varchar(50),
@observacion varchar(200),
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
 local_id,
 responsable,
 categoria_novedad_id, 
 tipo_novedad_id, 
 tipo_resolucion_id, 
 concepto, 
 dias, 
 descripcion, 
 estado, 
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
 @local_id,
 @responsable,
 @categoria_novedad_id, 
 @tipo_novedad_id, 
 @tipo_resolucion_id, 
 @concepto, 
 @dias, 
 @descripcion, 
 @estado, 
 @observacion, 
 @fecha_novedad, 
 @fecha_resolucion, 
 getdate(),
 @usuario_id
)

return 0
GO
/****** Object:  StoredProcedure [dbo].[spNovedadModificar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadModificar] 
@id int,
@legajo_id int,
@ubicacion_id int,
@sector_id int,
@local_id int,
@responsable varchar(200),
@categoria_novedad_id int,
@tipo_novedad_id int,
@tipo_resolucion_id int,
@concepto int,
@dias int,
@descripcion varchar(2000),
@estado varchar(50),
@observacion varchar(200),
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
    local_id=@local_id, 
    responsable=@responsable, 
    categoria_novedad_id=@categoria_novedad_id, 
    tipo_novedad_id=@tipo_novedad_id, 
    tipo_resolucion_id=@tipo_resolucion_id, 
    concepto=@concepto, 
    dias=@dias, 
    descripcion=@descripcion, 
    estado=@estado,
    observacion=@observacion,
    fecha_novedad=@fecha_novedad, 
    fecha_resolucion=@fecha_resolucion,
    usuario_id =@usuario_id,
    fecha_alta = getdate()
WHERE id = @id

return 0
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtener]    Script Date: 6/9/2022 17:16:23 ******/
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
         case when nov.ubicacion_id=1 then 
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerCantidad]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerCantidad] 
@empresa_id int, 
@categoria_novedad_id int, 
@tipo_novedad_id int,
@tipo_resolucion_id int,
@nro_legajo int,
@apellido varchar(50),
@fecha_novedad_desde datetime,
@fecha_novedad_hasta datetime,
@perfil_id int = null

AS

select count(*)
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join empresa e on l.empresa_id = e.id
left join ubicacion u on nov.ubicacion_id = u.id  
left join sector s on nov.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on nov.local_id = loca.Codigo 
where (@empresa_id=-1 or empresa_id = @empresa_id)
and   (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or
       @tipo_resolucion_id=-2 and tipo_resolucion_id is null or   
       @tipo_resolucion_id>0 and tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and (@tipo_resolucion_id>0 and (@fecha_novedad_desde is null or nov.fecha_resolucion  >= @fecha_novedad_desde) or 
     @tipo_resolucion_id<0 and (@fecha_novedad_desde is null or nov.fecha_novedad  >= @fecha_novedad_desde))
and (@tipo_resolucion_id>0 and (@fecha_novedad_hasta is null or nov.fecha_resolucion  <= @fecha_novedad_hasta) or 
     @tipo_resolucion_id<0 and (@fecha_novedad_hasta is null or nov.fecha_novedad  <= @fecha_novedad_hasta))
and (@perfil_id is null or @perfil_id<>4 or @perfil_id=4 and l.ubicacion_id=3)

GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerDeImportacion]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerDeImportacion] 
@empresa varchar(100),
@nro_legajo varchar(50),
@ubicacion_id int,
@sector varchar(100),
@responsable varchar(100),
@concepto varchar(100),
@categoria_novedad varchar(100),
@tipo_novedad varchar(100),
@str_fecha_novedad varchar(10),
@tipo_resolucion varchar(100),
@str_fecha_resolucion varchar(10),
@dias varchar(100),
@descripcion varchar(2000),
@estado varchar(50),
@observacion varchar(200)


AS

declare @c int
declare @usuario_id int
declare @legajo_id int 
declare @sector_id int 
declare @local_id int 
declare @tipo_novedad_id int 
declare @tipo_resolucion_id int 
declare @responsable_id int 
declare @categoria_id int 
declare @empresa_id int 

declare @variable varchar(50) 

select @empresa_id= e.id
from empresa e 
where e.Descripcion = @empresa
or e.nomenclatura = @empresa

if @empresa_id is null return -2

select @legajo_id = l.id
from legajo l 
where l.empresa_id = @empresa_id
and   l.nro_legajo = @nro_legajo

if  @legajo_id is null return -1

/*
select @categoria_id= cn.id
from categoria_novedad  cn  
where cn.descripcion  = @categoria_novedad
*/

select @usuario_id= u.id
from usuario u  
where u.UsuarioID  =   'GFERNANDEZ'

if  @ubicacion_id=1 or @ubicacion_id=2 or @ubicacion_id=4
begin
  select @sector_id=s.id
  from sector   s
  where s.Descripcion = @sector
  
  set @local_id=NULL 
   
  if @sector_id is null
  begin 
	  
	if  @ubicacion_id=1
       set @variable = 'fabrica'
    else
      if @ubicacion_id=2
        set @variable='edificio'
      else 
        set @variable='deposito'
        
    select @sector_id=m.codigo 
    from mapeo_importacion m
    where m.Descripcion = @sector
    and   m.variable =@variable
  end 
  
  if @sector_id is null return -3
  
  
end
ELSE 
BEGIN 
	
  IF upper(ltrim(rtrim(@sector)))='SUPERVISOR'
    set @local_id=9999
  ELSE  
    select @local_id=l.Codigo 
    from MontagneProduccion.dbo.Locales l 
    where l.Descripcion = @sector
  
  set @sector_id=NULL 
  
  if @local_id is null
  begin 
	  
    set @variable = 'local'
      
    select @local_id=m.codigo 
    from mapeo_importacion m
    where m.Descripcion = @sector
    and   m.variable =@variable
  end 
  
  if @local_id is null return -3
end

/*
select @responsable_id= r.id
from responsable r  
where r.apellido  = @responsable

if @responsable_id is null return -4
*/

select @tipo_novedad_id=n.id
from tipo_novedad n   
where n.descripcion  = @tipo_novedad

if @tipo_novedad_id is null return -5

select @tipo_resolucion_id= r.id
from tipo_resolucion r
where r.descripcion = @tipo_resolucion

if @tipo_resolucion_id is null and @tipo_resolucion<>'' return -6

if @tipo_resolucion_id is not null and 
   @tipo_resolucion<>'' and 
   (
    @str_fecha_resolucion is null or
    @str_fecha_resolucion =''
   )   
   return -7

if (@tipo_resolucion_id is null or 
    @tipo_resolucion='') and 
    @str_fecha_resolucion is not null and  
    @str_fecha_resolucion <>''   
   return -7

   
select @usuario_id as usuario_id,
       @legajo_id as legajo_id,
       @ubicacion_id as ubicacion_id,
       @sector_id as sector_id,
       @local_id as local_id,
       @categoria_novedad as categoria_novedad_id,
       @responsable as responsable,
       @tipo_novedad_id as tipo_novedad_id,
       @tipo_resolucion_id as tipo_resolucion_id,
       @descripcion as descripcion,
       @estado as estado,
       @observacion as observacion,
       case when @concepto = '' then null else @concepto end  as concepto,
       case when @dias = '' then null else @dias end  as dias,
       case when @str_fecha_novedad = '' then null else @str_fecha_novedad end  as fecha_novedad,
       case when  @str_fecha_resolucion = '' then null else  @str_fecha_resolucion end as fecha_resolucion;
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerPag]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerPag] 
@pag as int,
@empresa_id int, 
@categoria_novedad_id int, 
@tipo_novedad_id int,
@tipo_resolucion_id int,
@nro_legajo int,
@apellido varchar(50),
@fecha_novedad_desde datetime,
@fecha_novedad_hasta datetime,
@perfil_id int = null

AS

select  TOP 5000 * FROM
(
   select  ROW_NUMBER() OVER (       
     order by nov.categoria_novedad_id, nov.fecha_novedad desc,  nov.id desc
         ) AS RowNumber,
       nov.*,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion,
       l.nro_legajo,
       l.apellido,
       l.nombre,
       e.descripcion as empresa,
       u.descripcion as ubicacion,
       s.descripcion as sector,
       case when nov.local_id =9999 then 'Supervisor' else loca.Descripcion end  as local
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join empresa e on l.empresa_id = e.id
left join ubicacion u on nov.ubicacion_id = u.id  
left join sector s on nov.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on nov.local_id = loca.Codigo 
where (@empresa_id=-1 or empresa_id = @empresa_id)
and   (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or 
       @tipo_resolucion_id=-2 and tipo_resolucion_id is null or   
       @tipo_resolucion_id>0 and tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and (@tipo_resolucion_id>0 and (@fecha_novedad_desde is null or nov.fecha_resolucion  >= @fecha_novedad_desde) or 
     @tipo_resolucion_id<0 and (@fecha_novedad_desde is null or nov.fecha_novedad  >= @fecha_novedad_desde))
and (@tipo_resolucion_id>0 and (@fecha_novedad_hasta is null or nov.fecha_resolucion  <= @fecha_novedad_hasta) or 
     @tipo_resolucion_id<0 and (@fecha_novedad_hasta is null or nov.fecha_novedad  <= @fecha_novedad_hasta))
and (@perfil_id is null or @perfil_id<>4 or @perfil_id=4 and l.ubicacion_id=3)
) _myResults
where rownumber >= (@pag-1)*1000+1
order by  RowNumber

GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadObtenerTodos] 
@empresa_id int, 
@categoria_novedad_id int, 
@tipo_novedad_id int,
@tipo_resolucion_id int,
@nro_legajo int,
@apellido varchar(50),
@fecha_novedad_desde datetime,
@fecha_novedad_hasta datetime,
@perfil_id int = null

AS

Select 
       nov.id, 
       nov.legajo_id, 
       nov.ubicacion_id, 
       nov.responsable_id, 
       nov.categoria_novedad_id, 
       nov.tipo_novedad_id, 
       nov.tipo_resolucion_id, 
       nov.concepto, 
       nov.descripcion,
       nov.responsable,
       nov.estado,
       nov.observacion, 
       nov.dias, 
       nov.fecha_novedad, 
       nov.fecha_resolucion, 
       nov.fecha_alta, 
       nov.sector_id, 
       nov.usuario_id, 
       nov.local_id,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion,
       l.nro_legajo,
       l.apellido,
       l.nombre,
       e.descripcion as empresa,
       u.descripcion as ubicacion,
       s.descripcion as sector,
       case when nov.local_id =9999 then 'Supervisor' else loca.Descripcion end  as local
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join empresa e on l.empresa_id = e.id
left join ubicacion u on nov.ubicacion_id = u.id  
left join sector s on nov.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on nov.local_id = loca.Codigo
where (@empresa_id=-1 or empresa_id = @empresa_id)
and   (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or 
       @tipo_resolucion_id=-2 and tipo_resolucion_id is null or   
       @tipo_resolucion_id>0 and tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and (@tipo_resolucion_id>0 and (@fecha_novedad_desde is null or nov.fecha_resolucion  >= @fecha_novedad_desde) or 
     @tipo_resolucion_id<0 and (@fecha_novedad_desde is null or nov.fecha_novedad  >= @fecha_novedad_desde))
and (@tipo_resolucion_id>0 and (@fecha_novedad_hasta is null or nov.fecha_resolucion  <= @fecha_novedad_hasta) or 
     @tipo_resolucion_id<0 and (@fecha_novedad_hasta is null or nov.fecha_novedad  <= @fecha_novedad_hasta))
and (@perfil_id is null or @perfil_id<>4 or @perfil_id=4 and l.ubicacion_id=3)
order by fecha_novedad desc 
GO
/****** Object:  StoredProcedure [dbo].[spPerfilObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPerfilObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[perfil]
where id<>99
order by id
GO
/****** Object:  StoredProcedure [dbo].[spPerfilWebObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPerfilWebObtenerTodos] 
@web varchar(255)
AS

select * 
from web_perfil wp  
where wp.nombre = @web
order by wp.descripcion 

GO
/****** Object:  StoredProcedure [dbo].[spResponsableEliminar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spResponsableEliminar] 
@id int
AS

DELETE FROM  [dbo].[responsable]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spResponsableInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spResponsableInsertar] 
@nombre varchar(50),
@apellido varchar(50)
AS

INSERT INTO [dbo].[responsable]
(
 nombre,
 apellido
)
VALUES
(
 @nombre,
 @apellido
)
GO
/****** Object:  StoredProcedure [dbo].[spResponsableModificar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spResponsableModificar] 
@id int,
@nombre varchar(50),
@apellido varchar(50)
AS

UPDATE [dbo].[responsable]
SET nombre= @nombre,
    apellido=@apellido
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spResponsableObtener]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spResponsableObtener] 
@id int
AS

SELECT * 
FROM  [dbo].[responsable]
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spResponsableObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorEliminar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorInsertar] 
@descripcion varchar(100),
@ubicacion_id int
AS

INSERT INTO [dbo].[sector]
(
 descripcion,
 ubicacion_id 
)
VALUES
(
 @descripcion,
 @ubicacion_id
)

GO
/****** Object:  StoredProcedure [dbo].[spSectorModificar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorModificar] 
@id int,
@descripcion varchar(100),
@ubicacion_id int
AS

UPDATE [dbo].[sector]
SET descripcion = @descripcion,
    ubicacion_id  = @ubicacion_id
WHERE id=@id
GO
/****** Object:  StoredProcedure [dbo].[spSectorObtener]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorObtener] 
@id int
AS

SELECT s.*,
       u.descripcion as ubicacion
FROM  [dbo].[sector] s
inner join ubicacion u on s.ubicacion_id=u.id
WHERE s.id=@id

GO
/****** Object:  StoredProcedure [dbo].[spSectorObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSectorObtenerTodos] 
@ubicacion_id int
AS



select s.*,
       u.descripcion as ubicacion
from sector s 
inner join ubicacion u on s.ubicacion_id=u.id
where @ubicacion_id=-1 or  ubicacion_id=@ubicacion_id
order by ubicacion_id, Descripcion 

GO
/****** Object:  StoredProcedure [dbo].[spTipoNovedadEliminar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadInsertar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadModificar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtener]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionEliminar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionInsertar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionModificar]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtener]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spUbicacionObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioCambiarClave]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioEliminar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioEliminar] 
@UsuarioID varchar(255)
AS

delete from usuario_web where UsuarioID=@UsuarioID 

delete from usuario where UsuarioID=@UsuarioID


GO
/****** Object:  StoredProcedure [dbo].[spUsuarioGUIDActualizar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioGUIDActualizar] 
@UsuarioID varchar(255),
@sitio_web varchar(255),
@guid varchar(255)
AS

UPDATE [dbo].[usuario_web]
SET GUID=@guid
WHERE UsuarioID = @UsuarioID 
and   sitio_web = @sitio_web

INSERT INTO RRHH.dbo.usuario_log
	(fecha, accion_id, UsuarioID, sitio_web)
VALUES
     (getdate(), 1,@UsuarioID, @sitio_web);
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioInsertar]    Script Date: 6/9/2022 17:16:23 ******/
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

if @perfil_id<>99
begin
  INSERT INTO RRHH.dbo.usuario_web
  (UsuarioID, sitio_web, guid, perfil_id)
  VALUES(@UsuarioID, 'RRHH', null, @perfil_id);
end

GO
/****** Object:  StoredProcedure [dbo].[spUsuarioLoginPorGUID]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioLoginPorGUID] 
@sitio_web varchar(255),
@guid varchar(255)
AS

/*select a.id,
       a.UsuarioID,
       a.clave,      
       a.Apellido,
       a.Nombre,
	   a.perfil_id,
	   p.descripcion  as perfil_descripcion 
from usuario_web uw 
inner join usuario a on uw.UsuarioID = a.UsuarioID 
inner join perfil p on a.perfil_id = p.id
where uw.guid=@guid
and   uw.sitio_web = @sitio_web
*/

select a.id,
       a.UsuarioID,
       a.clave,      
       a.Apellido,
       a.Nombre,
	   p.perfil_id,
	   p.descripcion  as perfil_descripcion 
from usuario_web uw 
inner join usuario a on uw.UsuarioID = a.UsuarioID 
inner join web_perfil  p on  uw.sitio_web = p.nombre and uw.perfil_id = p.perfil_id 
where uw.guid=@guid
and   uw.sitio_web = @sitio_web
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioModificar]    Script Date: 6/9/2022 17:16:23 ******/
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

UPDATE [dbo].[usuario_web]
SET   perfil_id=@perfil_id
where UsuarioID=@UsuarioID
and   sitio_web ='RRHH'
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioObtener]    Script Date: 6/9/2022 17:16:23 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerTodos]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioObtenerTodos] 
@perfil_id int = null
AS

select a.*, 
       p.descripcion  as perfil_descripcion 
from usuario a  
inner join perfil p on a.perfil_id = p.id
where (@perfil_id is null or @perfil_id<>1) and  p.id<>99 or @perfil_id=1
order by apellido, nombre
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerWebs]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioObtenerWebs] 
@UsuarioID varchar(255)
AS

select w.*, uw.perfil_id, wp.descripcion as perfil
from usuario_web uw
inner join web w on uw.sitio_web = w.nombre  
left join web_perfil wp on wp.nombre = w.nombre and  uw.perfil_id = wp.perfil_id 
where uw.UsuarioID=@UsuarioID

GO
/****** Object:  StoredProcedure [dbo].[spUsuarioWebEliminar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioWebEliminar] 
@UsuarioID varchar(255),
@web varchar(255)
AS

  delete 
  from usuario_web 
  where UsuarioId = @UsuarioID 
  and  sitio_web = @web

  if @web='RRHH'
  begin 
  	update usuario 
  	set perfil_id = 99 
  	where UsuarioID = @UsuarioID
  	
  end
  
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioWebInsertar]    Script Date: 6/9/2022 17:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioWebInsertar] 
@UsuarioID varchar(255),
@web varchar(255),
@perfil_id int
AS

declare @c as int 

select @c = (Select count(*) from usuario_web where UsuarioID=@UsuarioID and sitio_web=@web)

if @c=1 
begin
  update usuario_web
  set perfil_id= @perfil_id
  where UsuarioID=@UsuarioID 
  and   sitio_web=@web
  
  
end 
else
begin 
  insert into usuario_web (UsuarioId, sitio_web, perfil_id) values (@UsuarioId, @web, @perfil_id)
end

 if @web='RRHH'
  begin 
  	update usuario 
  	set perfil_id = @perfil_id 
  	where UsuarioID = @UsuarioID  	
  end
  
  

GO
