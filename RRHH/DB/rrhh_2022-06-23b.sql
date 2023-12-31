/****** Object:  UserDefinedFunction [dbo].[fn_cpa_obtenercategoria]    Script Date: 23/6/2022 12:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_cpa_obtenercategoria]
(
@tipo varchar (1), 
@hr1 time, 
@hr2 time, 
@hr3 time, 
@hr4 time, 
@fh date
)
RETURNS varchar(3)
AS 
begin
	declare @difhr int
	declare @v_cat varchar(3)
  	declare @v_catE varchar(3)
  	declare @v_catS varchar(3)
  	declare @v_catF varchar(3)
  	
  	if @tipo = 'E' begin
  		if isnull(@hr2, cast('00:00:00' as time)) <> cast('00:00:00' as time) begin
			-- set @hr1 = DATEADD(MINUTE ,1,@hr1) 
			set @difhr = DATEDIFF(MINUTE,@hr1, @hr2) 
			if @difhr > 0 BEGIN  
				set @v_cat	= 'LT'
			end	
			else begin
				set @v_cat	= 'EC' 
			end 
  		end
  		else begin
  			if @fh = GETDATE() begin
				if DATEDIFF(MINUTE,GETDATE(),@hr1) < 0 begin
					set @v_cat	= 'ATR'
				end	
				else begin
					set @v_cat	= 'NE' 
				end 
			end	
			else begin
				set @v_cat	= 'NE' 
			end
  		end
  	end
  	
    if @tipo = 'S' begin 
		if isnull(@hr2, cast('00:00:00' as time)) <> cast('00:00:00' as time) begin -- set hrso = timestampadd(minute, 3, hrso) ;
			set @difhr = DATEDIFF(MINUTE,@hr1, @hr2) 
			if @difhr < 0 begin 
				set @v_cat	= 'RA' 
			end	
			else begin 
				set @v_cat	= 'SC' 
			end 
		end
		else begin
			-- return 'NE' ;
			if @fh = GETDATE() begin
				if DATEDIFF(MINUTE,GETDATE(),@hr1) < 0 begin
					set @v_cat	= 'ATR' 
				end	
				else begin
					set @v_cat	= 'NS'					
				end 
			end	
			else begin
				set @v_cat	= 'NS' 
			end
		end  
  	end 	
  	
 	if @tipo = 'F' begin
		-- Entrada:
		if isnull(@hr2, cast('00:00:00' as time)) <> cast('00:00:00' as time) begin 
			-- set @hr1 = DATEADD(MINUTE ,1,@hr1)  
			set @difhr = DATEDIFF(MINUTE,@hr1, @hr2)
			if @difhr > 0 begin 
				set @v_catE =  'LT' 
			end	
			else begin 
				set @v_catE =  'EC' 
			end
		end	
		else begin
			-- return 'NE' ;
			if @fh = getdate() begin
				if DATEDIFF(MINUTE,getdate(), @hr2)< 0 begin
					set @v_catE =  'ATR' 
				end
				else begin
					set @v_catE =  'NE' 
				end
			end	
			else begin
				set @v_catE =  'NE' 
			end 
		end
	
	
		-- Salida:
		if isnull(@hr4, cast('00:00:00' as time)) <> cast('00:00:00' as time) begin -- set hrso = timestampadd(minute, 3, hrso) ;
			set @difhr = DATEDIFF(MINUTE,@hr3, @hr4)
			if @difhr < 0 begin 
				set @v_catS =  'RA'
			end	
			else begin 
				set @v_catS =  'SC' 
			end
		end	
		else begin
			-- return 'NE' ;
			if @fh = getdate() begin
				if DATEDIFF(MINUTE,getdate(),@hr3) < 0 begin
					set @v_catS =  'ATR' 
				end	
			end	
			else begin
				set @v_catS =  'NS' 
			end
		end	
		
	end	
	else begin
		set @v_catS =  'NS' 
	end
	 
	
	
	
	if @v_catE = 'EC' begin
		if @v_catS = 'SC' begin
			set @v_cat	 =  'HC'
		end	
		else begin  
			if @v_catS = 'ATR' begin
				set @v_cat	 =  'HP'
			end	
			else begin
				if  @v_catS = 'NS' begin
					set @v_cat	 =  'NC'
				end	
				else begin
					if @v_catS = 'RA' begin
						set @v_cat	 =  'HP'
					end	
				end
			END 
		end	
	end
		
	if @v_catE = 'LT' begin
		set @v_cat	 =  'HP'
	end
	
	if @v_catE = 'NE' begin
		if @v_catS = 'NS' begin
			set @v_cat	 =  'AU'	
		end	
		else begin
			if  @v_catS = 'ATR' begin
				set @v_cat	 =  'AU'		
			end
		end
				-- NS - no se da
				-- RA - no se da
	end
	
	if @v_catE = 'ATR' begin
		set @v_cat	 =  'ATR'
	end
  
 	
  return @v_cat	
  	
  	
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_obtenerelprimerafechadeldiabycoddiayperiodo]    Script Date: 23/6/2022 12:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_obtenerelprimerafechadeldiabycoddiayperiodo]
(@p_coddia int, 
@p_periodo date)
RETURNS date
AS 
begin
  declare @w1 int 
  declare @v_fecha date 
  set @w1 = 1 
  set @v_fecha = cast(dbo.udf_PrimerDia(month(@p_periodo), year(@p_periodo)) as date) 
  while (@w1 <= 7) begin 
  	if DATEPART(WEEKDAY, @v_fecha) = @p_coddia begin 
  		set @w1 = 8 
  	end	
    else begin 
   		set @v_fecha = dateadd(day,1,@v_fecha) 
    end  
    set @w1 = @w1 + 1 
  end
  return @v_fecha
END 
GO
/****** Object:  UserDefinedFunction [dbo].[udf_obtenerelultimofechadeldiabycoddiayperiodo]    Script Date: 23/6/2022 12:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_obtenerelultimofechadeldiabycoddiayperiodo]
(
@p_coddia int, 
@p_periodo date
)
RETURNS date
AS 
begin
  declare @w1 int 
  declare @v_fecha date 
  set @w1 = 7 
  set @v_fecha = cast(
    dbo.udf_UltimoDia(month(@p_periodo), year(@p_periodo)) as date
  ) 
  while (@w1 > 0) begin 
  	if DATEPART(WEEKDAY, @v_fecha) = @p_coddia begin 
  		set @w1 = 1 
  	end	
    else begin 
   		set @v_fecha = dateadd(day,-1,@v_fecha) 
    end
    set @w1 = @w1 - 1 
  end
  return @v_fecha 
end
GO
/****** Object:  UserDefinedFunction [dbo].[udf_PrimerDia]    Script Date: 23/6/2022 12:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_PrimerDia](
@i_mes int,
@i_anio int)
 RETURNS datetime
 as
BEGIN 
	DECLARE @v_fecha datetime
	
	SET @v_fecha =   CAST(concat(	cast(@i_anio as char(4)), 	cast(		concat(	REPLICATE('0',(2-len(@i_mes))), 	cast(@i_mes as char(2))) as char(2)),		'01')  AS datetime)

	RETURN @v_fecha
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_UltimoDia]    Script Date: 23/6/2022 12:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_UltimoDia]
(
	@i_mes int,
	@i_anio int
) RETURNS datetime
AS 
BEGIN
	declare @v_fecha datetime;
	set @v_fecha = EOMONTH(
	CAST(concat(	cast(@i_anio as char(4)), 	cast(		concat(	REPLICATE('0',(2-len(@i_mes))), 	cast(@i_mes as char(2))) as char(2)),		'01')  AS datetime)
	
	)
	RETURN @v_fecha;
END
GO
/****** Object:  Table [dbo].[categoria]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[categoria_novedad]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[empresa]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[funcion]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[genero]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[importacion]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[legajo]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[novedad]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[perfil]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[responsable]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[sector]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[tipo_novedad]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[tipo_resolucion]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[ubicacion]    Script Date: 23/6/2022 12:04:07 ******/
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
/****** Object:  Table [dbo].[usuario]    Script Date: 23/6/2022 12:04:07 ******/
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

INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (1, N'ADMINIST. B')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (2, N'ADMINIST. E')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (3, N'ADMINIST. F')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (4, N'AUXILIAR (enc)')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (5, N'AUXILIAR A')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (6, N'AUXILIAR B')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (7, N'CALIFICADO')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (8, N'DIRECTOR')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (9, N'EMPLEADO A')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (10, N'EMPLEADO B')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (11, N'EMPLEADO C')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (12, N'EMPLEADO D')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (13, N'EMPLEADO E')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (14, N'ENCARGADO')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (15, N'GERENTE')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (16, N'INTERMEDIARIO')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (17, N'MAEST. Y SERV. "B"')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (18, N'MEDIO OFICIAL')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (19, N'NO CALIFICADO')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (20, N'OFICIAL')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (21, N'OFICIAL 1º')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (22, N'OFICIAL 2°')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (23, N'OPER. ESPEC.')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (24, N'SEMICALIFICADO')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (25, N'SUPERVISOR B')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (26, N'TALLERISTA')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (27, N'TRAB. DOMICILIO')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (28, N'VENDEDOR B')
INSERT [dbo].[categoria] ([id], [descripcion]) VALUES (29, N'VENDEDOR D')
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

INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (1, N'A. ACOND.')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (2, N'ADM. DISEÑO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (3, N'ADM. MODELISTA')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (4, N'ADM. PART TIME')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (5, N'ADM.COM.EXT.')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (6, N'ADMIN E-COMMERCE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (7, N'ADMIN. PRODUCTO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (8, N'ADMIN. VENTAS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (9, N'ADMINISTRATIVO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (10, N'ANALISTA MKT')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (11, N'ANALISTA MKT DIGITAL')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (12, N'ARCHIVOS Y PROTOCOLOS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (13, N'AT. AL CLIENTE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (14, N'BRAND MANAGER')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (15, N'CADETE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (16, N'CAJERO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (17, N'CAJERO / VEND')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (18, N'CARPINTERO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (19, N'CHOFER')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (20, N'COMERCIAL')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (21, N'CONFECCION')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (22, N'CORTADOR')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (23, N'COST.EXTERNO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (24, N'COSTURERO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (25, N'CREADOR DE CONTENIDO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (26, N'DEPOSITO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (27, N'DESARROLLADOR WEB')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (28, N'DIR. ADMIN. Y FINANZAS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (29, N'DIR. PRODUCCION')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (30, N'DIR.DISEÑO Y PRODUCTO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (31, N'DIRECTOR')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (32, N'DIS.GRAFICO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (33, N'DISEÑO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (34, N'DISEÑO Jr')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (35, N'DISEÑO Sr')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (36, N'E-COMMERCE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (37, N'ELECTRIC.')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (38, N'ENCARG. LOCAL')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (39, N'ENCARGADO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (40, N'ESTAMPADO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (41, N'HERRERIA')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (42, N'ING. TEXTIL')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (43, N'INTERMEDIARIO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (44, N'LIQ. SUELDOS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (45, N'LOGISTICA E-COMMERCE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (46, N'MANTENIMIENTO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (47, N'MAQ. BORDADO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (48, N'MAQUINISTA')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (49, N'MKT / ECOMMERCE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (50, N'MKT COMERCIAL')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (51, N'MKT DIGITAL y PERFORMANCE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (52, N'MODELISTA')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (53, N'PROD. DE MODA')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (54, N'PRODUCCION')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (55, N'PROGRAMADOR')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (56, N'RRHH')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (57, N'SECT. CORTE')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (58, N'SEGURIDAD')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (59, N'SISTEMAS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (60, N'SUPERV. LOCAL')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (61, N'TAREAS GRALES')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (62, N'TAREAS VARIAS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (63, N'TECNICO')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (64, N'VEND. PART-TIME')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (65, N'VENDEDOR')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (66, N'VENTAS')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (67, N'VENTAS J. REDUC')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (69, N'STOCK')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (70, N'AUXILIAR')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (71, N'CAJ / VEND. - PART-TIME')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (72, N'ENCARG. 1ra')
INSERT [dbo].[funcion] ([id], [descripcion]) VALUES (73, N'ENCARG. 2da')
SET IDENTITY_INSERT [dbo].[funcion] OFF
GO
SET IDENTITY_INSERT [dbo].[genero] ON 

INSERT [dbo].[genero] ([id], [descripcion]) VALUES (1, N'Femenino')
INSERT [dbo].[genero] ([id], [descripcion]) VALUES (2, N'Masculino')
SET IDENTITY_INSERT [dbo].[genero] OFF
GO
SET IDENTITY_INSERT [dbo].[importacion] ON 

INSERT [dbo].[importacion] ([id], [tipo], [nombre_archivo], [fecha], [cantidad], [errores]) VALUES (5, N'L', N'\Uploads\Test Legajos_2119ce47-49d3-4804-8fba-c2325c574a98.xlsm', CAST(N'2022-06-23T11:53:16.593' AS DateTime), 2, 2)
INSERT [dbo].[importacion] ([id], [tipo], [nombre_archivo], [fecha], [cantidad], [errores]) VALUES (6, N'L', N'\Uploads\Test Legajos_42fb45a7-494b-4235-a95f-674400c4df72.xlsm', CAST(N'2022-06-23T11:57:08.747' AS DateTime), 2, 0)
SET IDENTITY_INSERT [dbo].[importacion] OFF
GO
SET IDENTITY_INSERT [dbo].[legajo] ON 

INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (7, 1, 5, NULL, 2, 2, 31, NULL, N'LAGO GONZALEZ', N'JOSE DANIEL', 11, 9, 1, CAST(N'1998-12-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (8, 1, 213, NULL, 1, 2, 31, NULL, N'DIACO', N'NOELIA LEANDRA', 12, 9, 1, CAST(N'2005-06-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (9, 1, 294, NULL, 2, 2, 42, NULL, N'FERNANDEZ', N'EDGARDO GUSTAVO', 15, 56, 1, CAST(N'2006-06-05T00:00:00.000' AS DateTime), NULL, N'A')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (10, 1, 311, NULL, 2, 2, 31, NULL, N'ACOSTA', N'RODRIGO', 11, 9, 1, CAST(N'2006-08-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (11, 1, 329, NULL, 2, 2, 45, NULL, N'BONANNO', N'PABLO LUCIANO', 11, 67, 1, CAST(N'2006-12-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (12, 1, 358, NULL, 2, 3, NULL, 111, N'JACQUET', N'ALEXIS EZEQUIEL', 14, 38, 1, CAST(N'2007-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (13, 1, 413, NULL, 1, 2, 31, NULL, N'PEREZ', N'LOURDES CLAUDIA', 14, 9, 1, CAST(N'2007-07-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (14, 1, 443, NULL, 2, 3, NULL, 138, N'SENDRA', N'JULIO ANTONIO', 14, 38, 1, CAST(N'2007-09-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (15, 1, 446, NULL, 2, 2, 42, NULL, N'REYES', N'JUAN LEON', 14, 44, 1, CAST(N'2007-09-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (16, 1, 454, NULL, 2, 1, 16, NULL, N'CACERES', N'NESTOR LEONARDO', 13, 26, 1, CAST(N'2007-09-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (17, 1, 507, NULL, 2, 3, NULL, 131, N'GOMEZ ', N'SEBASTIAN JUAN', 14, 38, 1, CAST(N'2008-01-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (18, 1, 573, NULL, 2, 2, 33, NULL, N'MARTIN', N'NORBERTO OMAR', 15, 49, 1, CAST(N'2008-05-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (19, 1, 609, NULL, 2, 2, 43, NULL, N'GORAL', N'MIGUEL ALEJANDRO', 15, 59, 1, CAST(N'2008-07-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (20, 1, 641, NULL, 1, 2, 42, NULL, N'GOMEZ ', N'MIRIAM BEATRIZ', 11, 56, 1, CAST(N'2008-10-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (21, 1, 645, NULL, 1, 2, 41, NULL, N'MEDINA', N'DEBORA ELIZABETH', 13, 9, 1, CAST(N'2008-10-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (22, 1, 720, NULL, 2, 2, 33, NULL, N'FREEDMAN', N'SANTIAGO ANDRES', 11, 49, 1, CAST(N'2009-08-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (23, 1, 736, NULL, 1, 2, 32, NULL, N'BASUALDO', N'MARIA DEL MAR', 11, 32, 1, CAST(N'2009-10-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (24, 1, 789, NULL, 2, 3, NULL, 121, N'GUILINO', N'JEREMIAS RICARDO', 11, 65, 1, CAST(N'2010-03-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (25, 1, 825, NULL, 2, 3, NULL, 146, N'BENITEZ', N'JORGE DARIO', 14, 38, 1, CAST(N'2010-06-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (26, 1, 836, NULL, 2, 2, 45, NULL, N'FAGNANO', N'MATIAS NICOLAS', 10, 67, 1, CAST(N'2010-07-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (27, 1, 840, NULL, 1, 2, 35, NULL, N'CHERVONKO', N'LORENA EUGENIA', 13, 9, 1, CAST(N'2010-07-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (28, 1, 1002, NULL, 1, 1, 21, NULL, N'ARRAYARAN RODRIGUEZ', N'MEDARDA GLADYS', 27, 23, 1, CAST(N'1994-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (29, 1, 1005, NULL, 2, 1, 21, NULL, N'BUSTILLOS', N'FLORENCIO ALFREDO', 27, 23, 1, CAST(N'1992-05-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (30, 1, 1018, NULL, 1, 1, 21, NULL, N'PAYLLAFIL', N'LIDIA NOEMI', 27, 23, 1, CAST(N'1993-08-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (31, 1, 1021, NULL, 2, 1, 21, NULL, N'ZAYAS RODRIGUEZ', N'JORGE', 27, 23, 1, CAST(N'2005-07-30T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (32, 1, 1022, NULL, 2, 1, 21, NULL, N'VILLA LIMACHI', N'MIGUEL ANGEL', 27, 23, 1, CAST(N'2005-07-30T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (33, 1, 1038, NULL, 1, 1, 21, NULL, N'JUAREZ', N'ROSA ESTHER', 27, 23, 1, CAST(N'2005-11-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (34, 1, 1043, NULL, 1, 1, 21, NULL, N'MATTA CALLISAYA', N'ROSA', 27, 23, 1, CAST(N'2006-06-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (35, 1, 1049, NULL, 1, 1, 21, NULL, N'CAÑETE ORTEGA', N'LIZ BARBARA', 27, 23, 1, CAST(N'2013-10-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (36, 1, 1051, NULL, 1, 1, 21, NULL, N'RAMIREZ', N'YESICA CINTIA', 27, 23, 1, CAST(N'2014-06-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (37, 1, 1052, NULL, 1, 1, 21, NULL, N'GARCIA MOLINA', N'MARIA LAURA', 27, 23, 1, CAST(N'2014-12-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (38, 1, 1112, NULL, 1, 2, 31, NULL, N'AGUILAR', N'MARIELA MARCELA', 11, 16, 1, CAST(N'2011-08-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (39, 1, 1163, NULL, 2, 3, NULL, 111, N'PATO', N'PABLO JOSE', 11, 65, 1, CAST(N'2012-01-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (40, 1, 1250, NULL, 2, 3, NULL, 152, N'ORELLANA', N'CRISTIAN DAVID', 14, 38, 1, CAST(N'2012-10-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (41, 1, 1283, NULL, 2, 2, 42, NULL, N'CABRERA', N'IVAN DANIEL', 14, 56, 1, CAST(N'2013-02-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (42, 1, 1290, NULL, 2, 2, 31, NULL, N'GIMENEZ', N'BRIAN OMAR', 11, 9, 1, CAST(N'2013-03-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (43, 1, 1307, NULL, 2, 3, NULL, 138, N'BELMONTE', N'MATIAS DAMIAN', 11, 66, 1, CAST(N'2013-05-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (44, 1, 1335, NULL, 2, 3, NULL, 117, N'ROPERO TORRES', N'ANDERSON', 11, 17, 1, CAST(N'2013-08-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (45, 1, 1357, NULL, 2, 3, NULL, 107, N'CEJAS', N'FERNANDO MATIAS', 11, 17, 1, CAST(N'2013-10-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (46, 1, 1368, NULL, 2, 2, 45, NULL, N'LAYES BAPTISTA', N'LEONARDO GUSTAVO', 11, 8, 1, CAST(N'2013-11-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (47, 1, 1372, NULL, 2, 2, 41, NULL, N'GREGORETTI', N'PAULO', 15, 54, 1, CAST(N'2013-12-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (48, 1, 1378, NULL, 1, 2, 34, NULL, N'CARRIZO BRONDO', N'MANUELA', 14, 33, 1, CAST(N'2014-01-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (49, 1, 1383, NULL, 1, 2, 44, NULL, N'SALAMONE CROFT', N'MARIA GUADALUPE', 10, 66, 1, CAST(N'2014-02-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (50, 1, 1389, NULL, 1, 2, 44, NULL, N'QUEIROLO', N'YESICA DANIELA', 10, 66, 1, CAST(N'2014-03-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (51, 1, 1391, NULL, 1, 2, 44, NULL, N'CELIZ', N'SAMIRA AMALIA', 11, 9, 1, CAST(N'2014-04-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (52, 1, 1392, NULL, 1, 1, 11, NULL, N'CRISTOVAO', N'SILVINA MARIEL', 20, 62, 1, CAST(N'2014-06-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (53, 1, 1412, NULL, 2, 3, NULL, 109, N'NICORA', N'LEONARDO EMMANUEL', 14, 38, 1, CAST(N'2014-09-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (54, 1, 1420, NULL, 1, 2, 44, NULL, N'LOPEZ PELLOZO', N'MACARENA SOL', 11, 17, 1, CAST(N'2014-10-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (55, 1, 1439, NULL, 1, 1, 23, NULL, N'MATIUSHENKO', N'TETYANA', 13, 58, 1, CAST(N'2015-01-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (56, 1, 1416, NULL, 2, 3, NULL, 107, N'CLARO BAYONA', N'EDIXON FABIAN', 11, 65, 1, CAST(N'2015-02-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (57, 1, 1456, NULL, 2, 3, NULL, 117, N'LOPEZ', N'CHRISTIAN MAURICIO', 14, 38, 1, CAST(N'2015-03-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (58, 1, 1469, NULL, 2, 2, 45, NULL, N'ROSSI', N'PABLO DAVID', 10, 67, 1, CAST(N'2015-05-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (59, 1, 1488, NULL, 1, 3, NULL, 131, N'DELBARBA', N'PAULA ANDREA', 11, 17, 1, CAST(N'2015-06-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (60, 1, 1491, NULL, 1, 2, 33, NULL, N'BISULCA', N'DAMARIS GISELLE', 11, 6, 1, CAST(N'2015-06-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (61, 1, 1522, NULL, 1, 2, 40, NULL, N'PAIS BUSTINZA', N'JENNIFER NATALIA', 11, 9, 1, CAST(N'2015-10-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (62, 1, 1525, NULL, 1, 3, NULL, 136, N'PENAYO', N'ROMINA NATALIA', 11, 17, 1, CAST(N'2015-11-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (63, 1, 1528, NULL, 2, 2, 43, NULL, N'FERREYRA', N'JUAN CARLOS', 11, 55, 1, CAST(N'2015-11-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (64, 1, 1541, NULL, 1, 2, 46, NULL, N'GIUFFRE', N'BETIANA SOLANGE', 10, 67, 1, CAST(N'2016-02-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (65, 1, 1550, NULL, 2, 3, NULL, 150, N'DIAZ', N'CRISTIAN GABRIEL', 14, 38, 1, CAST(N'2016-03-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (66, 1, 1571, NULL, 1, 2, 33, NULL, N'SALAS LLORENTE', N'ARIANA AYELEN', 11, 45, 1, CAST(N'2016-06-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (67, 1, 1583, NULL, 1, 2, 41, NULL, N'SARNO', N'SOFIA LAURA', 11, 9, 1, CAST(N'2016-08-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (68, 1, 1588, NULL, 2, 2, 43, NULL, N'SPERK', N'MATIAS NICOLAS', 12, 59, 1, CAST(N'2016-08-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (69, 1, 1596, NULL, 1, 3, NULL, 121, N'MOLEIRO', N'VERONICA MARINA', 14, 38, 1, CAST(N'2016-09-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (70, 1, 1599, NULL, 1, 3, NULL, 121, N'SENDRA', N'MICAELA TERESA', 11, 65, 1, CAST(N'2016-09-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (71, 1, 1602, NULL, 1, 2, 45, NULL, N'SALAMONE CROFT', N'SUSANA DENISE', 11, 67, 1, CAST(N'2016-09-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (72, 1, 1613, NULL, 2, 2, 31, NULL, N'MARTINEZ', N'LUCIANO AGUSTIN', 11, 9, 1, CAST(N'2017-01-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (73, 1, 1618, NULL, 2, 1, 23, NULL, N'SANCHEZ', N'DARIO FERNANDO', 14, 58, 1, CAST(N'2017-03-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (74, 1, 1621, NULL, 1, 3, NULL, 146, N'PRETER ISCOLNIC', N'ILEANA GRISEL', 11, 65, 1, CAST(N'2017-03-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (75, 1, 1622, NULL, 2, 3, NULL, 136, N'LOBERCHO', N'MATIAS EZEQUIEL', 11, 17, 1, CAST(N'2017-03-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (76, 1, 1624, NULL, 1, 2, 31, NULL, N'OLIVA', N'VIVIANA GABRIELA', 11, 9, 1, CAST(N'2017-04-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (77, 1, 1634, NULL, 2, 2, 43, NULL, N'LOPEZ', N'MARCELO NICOLAS', 11, 59, 1, CAST(N'2017-05-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (78, 1, 1636, NULL, 1, 2, 33, NULL, N'PANIAGUA ', N'SABRINA', 11, 32, 1, CAST(N'2017-05-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (79, 1, 1639, NULL, 1, 2, 45, NULL, N'BRETTO', N'LAURA DANIELA', 10, 67, 1, CAST(N'2017-05-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (80, 1, 1647, NULL, 1, 3, NULL, 109, N'OJEDA HANAYA', N'BIANCA', 11, 64, 1, CAST(N'2017-05-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (81, 1, 1654, NULL, 1, 2, 46, NULL, N'BURSZTYN', N'ROMINA', 10, 66, 1, CAST(N'2017-06-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (82, 1, 1670, NULL, 2, 2, 31, NULL, N'VENTURA TINEO', N'GUSTAVO ADOLFO', 11, 9, 1, CAST(N'2017-08-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (83, 1, 1672, NULL, 2, 3, NULL, 152, N'HINOJOSA BECERRA', N'OSCAR OMAR', 11, 17, 1, CAST(N'2017-08-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (84, 1, 1680, NULL, 2, 3, NULL, 109, N'MOYANO', N'FARID MICAEL', 11, 65, 1, CAST(N'2017-08-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (85, 1, 1684, NULL, 2, 3, NULL, 107, N'SANCHEZ CUBILLAS', N'JOEL JESUS', 11, 17, 1, CAST(N'2017-08-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (86, 1, 1705, NULL, 2, 3, NULL, 107, N'ORTCHANIAN', N'JUAN MARCELO', 14, 38, 1, CAST(N'2015-06-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (87, 1, 1707, NULL, 1, 2, 33, NULL, N'VERDIELL', N'SOFIA   ', 11, 10, 1, CAST(N'2018-01-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (88, 1, 1720, NULL, 2, 2, 47, NULL, N'SANTILLAN', N'FACUNDO MANUEL', 11, 8, 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (89, 1, 1728, NULL, 1, 3, NULL, 117, N'FERNANDEZ', N'MARIA GABRIELA', 11, 64, 1, CAST(N'2018-05-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (90, 1, 1730, NULL, 1, 2, 31, NULL, N'RIVAS', N'MARIA FLORENCIA', 11, 9, 1, CAST(N'2018-05-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (91, 1, 1732, NULL, 2, 3, NULL, 117, N'MAC DONALD', N'LUCAS MARTIN', 11, 17, 1, CAST(N'2018-06-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (92, 1, 1737, NULL, 1, 2, 47, NULL, N'ROSENVOLT ', N'GISELLE SOLANGE', 11, 9, 1, CAST(N'2018-06-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (93, 1, 1740, NULL, 1, 3, NULL, 109, N'VEGA BENITEZ', N'MONICA AIDEE', 11, 64, 1, CAST(N'2018-07-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (94, 1, 1748, NULL, 2, 2, 42, NULL, N'CASTILLO LOPEZ', N'PEDRO JOSE', 11, 56, 1, CAST(N'2018-11-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (95, 1, 1749, NULL, 1, 2, 45, NULL, N'BRONSTEIN', N'VALERIA SOLEDAD', 11, 67, 1, CAST(N'2018-11-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (96, 1, 1753, NULL, 2, 3, NULL, 146, N'DELGADO BARRIOS', N'LANDYS AMAUDY', 11, 65, 1, CAST(N'2019-01-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (97, 1, 1754, NULL, 2, 3, NULL, 150, N'CASTELAO BRAVO', N'JUAN MANUEL', 11, 65, 1, CAST(N'2019-01-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (98, 1, 1759, NULL, 2, 2, 31, NULL, N'TOLENTINO GOMEZ', N'ROSELLA CORALI', 11, 9, 1, CAST(N'2019-03-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (99, 1, 1765, NULL, 2, 2, 47, NULL, N'BERENGUER', N'LEANDRO HECTOR', 11, 6, 1, CAST(N'2019-04-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (100, 1, 1768, NULL, 1, 2, 34, NULL, N'DUCID', N'MARIANELA', 11, 9, 1, CAST(N'2019-06-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (101, 1, 1771, NULL, 2, 3, NULL, 104, N'SOSA', N'GABRIEL MATIAS', 11, 65, 1, CAST(N'2019-06-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (102, 1, 1777, NULL, 1, 2, 30, NULL, N'LEON TACHON', N'BETTY CAROLINA', 11, 9, 1, CAST(N'2019-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (103, 1, 1778, NULL, 2, 2, 31, NULL, N'DURAND ESCOBAR', N'LEWIS GERARDO', 11, 9, 1, CAST(N'2019-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (104, 1, 1779, NULL, 2, 2, 43, NULL, N'ROSSO', N'CLAUDIO PATRICIO', 11, 59, 1, CAST(N'2019-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (105, 1, 1782, NULL, 1, 2, 33, NULL, N'GIUSSO ', N'SOFIA', 10, 32, 1, CAST(N'2019-07-22T00:00:00.000' AS DateTime), NULL, N'')
GO
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (106, 1, 1790, NULL, 1, 2, 41, NULL, N'YUJRA MEDINA', N'PATRICIA CRISTINA', 11, 9, 1, CAST(N'2019-09-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (107, 1, 1791, NULL, 2, 2, 31, NULL, N'GASPES', N'JUAN AGUSTIN', 10, 9, 1, CAST(N'2019-09-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (108, 1, 1795, NULL, 1, 2, 33, NULL, N'FOX CARRILLO', N'CATHERINE JOHANNA', 11, 51, 1, CAST(N'2019-10-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (109, 1, 1796, NULL, 2, 2, 40, NULL, N'PAIS BUSTINZA', N'KEVIN MARTIN', 11, 9, 1, CAST(N'2019-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (110, 1, 1799, NULL, 2, 1, 27, NULL, N'SALAZAR', N'JOSE DANIEL', 25, 46, 1, CAST(N'2013-07-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (111, 1, 1800, NULL, 1, 2, 33, NULL, N'HAASE', N'LARA', 11, 53, 1, CAST(N'2019-11-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (112, 1, 1804, NULL, 2, 3, NULL, 104, N'DUFAU', N'AXEL IVAN', 11, 65, 1, CAST(N'2019-12-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (113, 1, 1808, NULL, 1, 2, 28, NULL, N'BRENNI', N'MARA ALEJANDRA', 11, 9, 1, CAST(N'2020-01-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (114, 1, 1810, NULL, 2, 3, NULL, 111, N'NUÑEZ ', N'MAXIMILIANO NAHUEL', 11, 65, 1, CAST(N'2020-01-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (115, 1, 1812, NULL, 1, 2, 30, NULL, N'GARCIA MOYANO', N'NAYLA', 10, 9, 1, CAST(N'2020-02-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (116, 1, 1817, NULL, 2, 2, 33, NULL, N'ROBLEDO', N'LUIS ALBERTO', 11, 11, 1, CAST(N'2020-06-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (117, 1, 1819, NULL, 1, 2, 33, NULL, N'GENAVER', N'MELISA PAOLA', 10, 6, 1, CAST(N'2020-07-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (118, 1, 1820, NULL, 1, 2, 31, NULL, N'D''ERAMO', N'FLORENCIA GIOVANNA', 11, 9, 1, CAST(N'2020-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (119, 1, 1821, NULL, 1, 2, 35, NULL, N'MENDIETA', N'TAMARA SOLANGE', 11, 3, 1, CAST(N'2020-09-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (120, 1, 1824, NULL, 2, 2, 29, NULL, N'ACEDEDO TOVAR', N'ABRAHAM GUILLERMO', 11, 5, 1, CAST(N'2020-10-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (121, 1, 1825, NULL, 2, 2, 33, NULL, N'DUBAL', N'FERNANDO', 11, 27, 1, CAST(N'2020-11-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (122, 1, 1829, NULL, 2, 2, 47, NULL, N'MALDONADO', N'ADRIAN EZEQUIEL', 11, 65, 1, CAST(N'2020-12-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (123, 1, 2, NULL, 1, 2, 46, NULL, N'CARREY', N'SUSANA BEATRIZ', 15, 66, 1, CAST(N'1996-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (124, 1, 1835, NULL, 1, 2, 47, NULL, N'ACOSTA', N'AYLEN NADIA', 11, 13, 1, CAST(N'2021-01-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (125, 1, 1836, NULL, 2, 1, 27, NULL, N'COVIELLO ', N'EMILIANO MARTIN', 25, 46, 1, CAST(N'2021-01-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (126, 1, 1838, NULL, 1, 2, 36, NULL, N'SILVA', N'DAIANA YAEL', 11, 36, 1, CAST(N'2021-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (127, 1, 1841, NULL, 1, 2, 35, NULL, N'VALDES', N'JULIETA ROCIO', 11, 7, 1, CAST(N'2021-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (128, 1, 1842, NULL, 1, 3, NULL, 138, N'HUSACZUK', N'ARGENTINA ANDREA', 11, 65, 1, CAST(N'2021-03-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (129, 1, 1843, NULL, 1, 2, 48, NULL, N'DI BLASE HUSACZUK', N'LOURDES STEFANIA', 10, 9, 1, CAST(N'2021-03-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (130, 1, 1848, NULL, 2, 2, 41, NULL, N'COLMENARES RODRIGUEZ', N'JORGE ALEXIS', 11, 42, 1, CAST(N'2021-05-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (131, 1, 1849, NULL, 2, 2, 43, NULL, N'DIAZ ', N'HERNAN GABRIEL', 11, 55, 1, CAST(N'2021-05-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (132, 1, 1852, NULL, 1, 2, 34, NULL, N'BOUZA ', N'MARIA DOLORES', 11, 2, 1, CAST(N'2021-06-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (133, 1, 1855, NULL, 1, 1, 11, NULL, N'NOVOA HUAMAN', N'GILARRRY ALEXIS', 19, 62, 1, CAST(N'2021-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (134, 1, 1856, NULL, 2, 1, 27, NULL, N'SOTO FUENMAYOR', N'FRANCISCO JESUS', 10, 46, 1, CAST(N'2021-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (135, 1, 1859, NULL, 1, 3, NULL, 138, N'ACEVEDO ', N'GIMENA PAOLA', 11, 64, 1, CAST(N'2021-07-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (136, 1, 1861, NULL, 1, 2, 43, NULL, N'GRAUB', N'YAMILA DENISE', 11, 55, 1, CAST(N'2021-08-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (137, 1, 1862, NULL, 1, 2, 47, NULL, N'BUSTAMANTE ', N'TAMARA  ', 13, 13, 1, CAST(N'2021-08-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (138, 1, 1865, NULL, 2, 2, 31, NULL, N'DITTA SARMIENTO', N'SEBASTIAN DAVID', 10, 9, 1, CAST(N'2021-08-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (139, 1, 1866, NULL, 1, 2, 47, NULL, N'ZENONI', N'AMPARO', 10, 6, 1, CAST(N'2021-08-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (140, 1, 1867, NULL, 1, 2, 30, NULL, N'HABIB', N'LORENA ELIZABET', 11, 9, 1, CAST(N'2021-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (141, 1, 1868, NULL, 1, 3, NULL, 150, N'ROMERO', N'DAIANA AILEN', 11, 65, 1, CAST(N'2021-09-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (142, 1, 1871, NULL, 1, 3, NULL, 131, N'TORRICO', N'ASTRID LORENA', 11, 64, 1, CAST(N'2021-09-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (143, 1, 1873, NULL, 1, 2, 34, NULL, N'GOMEZ QUIJADA', N'DANIELA JOSE', 10, 2, 1, CAST(N'2021-09-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (144, 1, 1875, NULL, 1, 3, NULL, 121, N'BARRAZA ', N'JESSICA BELEN', 11, 65, 1, CAST(N'2021-10-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (145, 1, 1880, NULL, 2, 2, 34, NULL, N'CAMUSSO', N'MARTIN MIGUEL', 11, 9, 1, CAST(N'2021-11-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (146, 1, 1884, NULL, 2, 3, NULL, 111, N'GOMEZ', N'JORGE ALFREDO', 11, 65, 1, CAST(N'2021-11-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (147, 1, 1803, NULL, 2, 3, NULL, 111, N'QUEIROLO', N'FRANCO DAVID', 11, 65, 1, CAST(N'2021-12-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (148, 1, 1885, NULL, 1, 3, NULL, 138, N'BENITEZ', N'ABIGAIL DAIANA', 11, 65, 1, CAST(N'2021-12-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (149, 1, 1886, NULL, 2, 2, 32, NULL, N'VIEGAS GAGO', N'MARIANO', 11, 14, 1, CAST(N'2021-12-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (150, 1, 1889, NULL, 2, 2, 43, NULL, N'FABIAN', N'ARIEL ERNESTO', 11, 59, 1, CAST(N'2021-12-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (151, 1, 1891, NULL, 2, 3, NULL, 131, N'GONZALEZ VARGAS', N'JUAN MANUEL', 11, 65, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (152, 1, 1893, NULL, 1, 2, 38, NULL, N'GIANETTI ', N'MARIA JULIA', 11, 4, 1, CAST(N'2021-12-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (153, 1, 1896, NULL, 1, 2, 39, NULL, N'FRATTINI', N'VALERIA NOELY', 11, 50, 1, CAST(N'2021-12-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (154, 1, 1897, NULL, 1, 2, 36, NULL, N'CABRERA', N'YANEL NAHIR', 11, 12, 1, CAST(N'2021-12-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (155, 1, 1904, NULL, 1, 3, NULL, 138, N'FABIANO IBARRA', N'CAMILA', 11, 65, 1, CAST(N'2022-01-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (156, 1, 1905, NULL, 2, 2, 29, NULL, N'MOURE MODICA', N'CARLOS GUSTAVO', 11, 5, 1, CAST(N'2022-02-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (157, 1, 1906, NULL, 2, 2, 42, NULL, N'VALDEZ MOLINA', N'ELIZABETH CAROLINA', 11, 56, 1, CAST(N'2022-02-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (158, 1, 1907, NULL, 2, 2, 31, NULL, N'RICCARDI', N'LUCIANO IGNACIO', 9, 15, 1, CAST(N'2022-02-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (159, 1, 1909, NULL, 1, 2, 39, NULL, N'SCHIAVONI', N'STEFANIA CAROLINA', 11, 10, 1, CAST(N'2022-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (160, 1, 1910, NULL, 1, 2, 42, NULL, N'GUIMAREY VILLALBA', N'ANALIA BELLEN', 11, 56, 1, CAST(N'2022-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (161, 1, 1912, NULL, 1, 3, NULL, 104, N'GUILLEN ', N'BARBARA ESTEFANIA', 14, 38, 1, CAST(N'2022-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (162, 1, 1913, NULL, 2, 3, NULL, 152, N'RASCOVICH', N'MAURO ADRIAN', 11, 65, 1, CAST(N'2022-03-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (163, 1, 1914, NULL, 2, 3, NULL, 104, N'SALAZAR ', N'LUIS ALFREDO', 11, 65, 1, CAST(N'2022-03-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (164, 1, 1915, NULL, 1, 2, 29, NULL, N'CALARAME', N'ALEJANDRA DANIELA', 11, 5, 1, CAST(N'2022-03-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (165, 1, 1916, NULL, 2, 2, 41, NULL, N'ALCARAZ', N'MAXIMILIANO OMAR', 11, 9, 1, CAST(N'2022-03-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (166, 1, 1917, NULL, 1, 2, 47, NULL, N'VAGLIVIELLO', N'ANTONELLA JAZMIN', 11, 13, 1, CAST(N'2022-03-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (167, 1, 1918, NULL, 2, 2, 31, NULL, N'RE', N'TOBIAS DANIEL', 9, 15, 1, CAST(N'2022-03-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (168, 1, 1921, NULL, 1, 2, 34, NULL, N'GENTILE', N'FLORENCIA GISELLE', 11, 35, 1, CAST(N'2022-04-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (169, 1, 1922, NULL, 1, 2, 34, NULL, N'MIGUENS', N'JOSEFINA', 11, 34, 1, CAST(N'2022-04-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (170, 1, 1923, NULL, 1, 3, NULL, 152, N'SANCHEZ', N'MARIA FLORENCIA', 11, 65, 1, CAST(N'2022-04-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (171, 1, 1925, NULL, 1, 3, NULL, 107, N'BRAVO', N'JOHANA AYELEN', 11, 65, 1, CAST(N'2022-04-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (172, 1, 1926, NULL, 1, 2, 42, NULL, N'FERREYRA', N'ELIANA', 11, 56, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (173, 1, 1927, NULL, 1, 2, 43, NULL, N'ARDANAZ', N'MARIA FLORENCIA', 11, 59, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (174, 1, 1928, NULL, 2, 2, 35, NULL, N'AMARILLA', N'ABEL ANGEL', 10, 2, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (175, 1, 1929, NULL, 2, 3, NULL, 131, N'TOSCANO', N'EMMANUEL NICOLAS', 11, 65, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (176, 1, 1931, NULL, 2, 3, NULL, 117, N'GONZALEZ', N'JULIAN GASTON', 11, 65, 1, CAST(N'2022-04-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (177, 1, 1933, NULL, 2, 3, NULL, 107, N'GALELLA', N'JONATHAN EZEQUIEL', 11, 65, 1, CAST(N'2022-05-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (178, 1, 1934, NULL, 1, 2, 41, NULL, N'MINASIAN', N'SILVIA KARINA', 11, 9, 1, CAST(N'2022-05-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (179, 1, 1935, NULL, 1, 2, 34, NULL, N'FELDMANN', N'LUACIANA MANON', 11, 34, 1, CAST(N'2022-05-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (180, 1, 1936, NULL, 1, 2, 39, NULL, N'NIEVES CACERES', N'LUZ DEL VALLE', 10, 10, 1, CAST(N'2022-05-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (181, 1, 1937, NULL, 2, 3, NULL, 136, N'BARBALASSE ALMADA', N'FERNANDO GABRIEL', 11, 64, 1, CAST(N'2022-05-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (182, 1, 1938, NULL, 1, 3, NULL, 117, N'ARCURI', N'CHIARA AILEN', 11, 64, 1, CAST(N'2022-05-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (183, 1, 1939, NULL, 2, 2, 32, NULL, N'BELVEDERE', N'NICOLAS', 11, 25, 1, CAST(N'2022-05-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (184, 1, 1940, NULL, 2, 2, 47, NULL, N'GERACE FERNANDEZ', N'FRANCO  ', 11, 13, 1, CAST(N'2022-05-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (185, 1, 1941, NULL, 2, 2, 31, NULL, N'CESPI ', N'FACUNDO ALEJO', 9, 15, 1, CAST(N'2022-05-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (186, 1, 1942, NULL, 2, 3, NULL, 117, N'GAZZOLO ', N'JULIAN  ', 11, 64, 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (187, 1, 2004, NULL, 2, 1, 1, NULL, N'ACOSTA DURAN', N'GROVER', 20, 48, 1, CAST(N'1997-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (188, 1, 2005, NULL, 2, 1, 17, NULL, N'ACOSTA', N'JUAN CARLOS', 20, 62, 1, CAST(N'1989-12-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (189, 1, 2007, NULL, 2, 1, 5, NULL, N'AGUILAR VALLEJOS', N'ROLANDO', 20, 48, 1, CAST(N'1997-10-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (190, 1, 2010, NULL, 2, 1, 11, NULL, N'AGUIRRE QUILO', N'OSCAR', 20, 48, 1, CAST(N'1997-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (191, 1, 2015, NULL, 2, 1, 12, NULL, N'BRICEÑO CALDERON', N'JOSE JESUS', 20, 40, 1, CAST(N'1997-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (192, 1, 2019, NULL, 2, 1, 6, NULL, N'CAÑETE', N'REINERIO', 20, 48, 1, CAST(N'1998-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (193, 1, 2023, NULL, 2, 1, 3, NULL, N'CORONEL PAREDES', N'JUAN BUENAVENTURA', 20, 48, 1, CAST(N'1994-11-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (194, 1, 2027, NULL, 1, 1, 11, NULL, N'GALVEZ GALVEZ', N'ROSARIO URSULA', 20, 62, 1, CAST(N'1996-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (195, 1, 2031, NULL, 2, 2, 41, NULL, N'LAMAS', N'FLABIANO', 25, 24, 1, CAST(N'1994-11-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (196, 1, 2032, NULL, 2, 1, 12, NULL, N'LEDESMA', N'MANUEL ARMANDO', 20, 40, 1, CAST(N'1989-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (197, 1, 2033, NULL, 2, 1, 9, NULL, N'LEDESMA', N'MAURICIO GUIDO', 20, 22, 1, CAST(N'1988-11-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (198, 1, 2036, NULL, 2, 1, 4, NULL, N'MAMANI MAMANI', N'VALENTIN', 20, 48, 1, CAST(N'1994-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (199, 1, 2037, NULL, 2, 1, 3, NULL, N'MENDEZ NINA', N'JUAN DE DIOS', 20, 48, 1, CAST(N'2000-10-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (200, 1, 2049, NULL, 2, 1, 4, NULL, N'SOTELO', N'FERNANDO ELIAS', 20, 48, 1, CAST(N'1998-09-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (201, 1, 2053, NULL, 2, 1, 7, NULL, N'TICONA MAMANI', N'VICTOR', 20, 48, 1, CAST(N'1999-10-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (202, 1, 2069, NULL, 2, 1, 27, NULL, N'RUIZ ECHEVARRIA', N'ERMILIO MIGUEL', 21, 63, 1, CAST(N'2001-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (203, 1, 2085, NULL, 2, 1, 14, NULL, N'DE LA CRUZ CAYHUALLA', N'ALEJANDRO HUMBERTO', 20, 62, 1, CAST(N'2000-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (204, 1, 2120, NULL, 2, 1, 2, NULL, N'CARABAJAL', N'CARLOS ALBERTO', 20, 48, 1, CAST(N'2000-10-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (205, 1, 2124, NULL, 2, 1, 9, NULL, N'ZORIO', N'NESTOR', 20, 48, 1, CAST(N'2000-12-27T00:00:00.000' AS DateTime), NULL, N'')
GO
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (206, 1, 2128, NULL, 2, 1, 9, NULL, N'COTARELO', N'CHRISTIAN', 14, 57, 1, CAST(N'2001-03-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (207, 1, 2142, NULL, 2, 1, 27, NULL, N'DECO', N'RUBEN DANIEL', 21, 63, 1, CAST(N'2001-10-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (208, 1, 2144, NULL, 2, 1, 3, NULL, N'VERA NAMAY', N'JUAN JORGE', 20, 62, 1, CAST(N'2002-01-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (209, 1, 2149, NULL, 2, 1, 2, NULL, N'VISCARRA', N'JESUS FERNANDO', 20, 48, 1, CAST(N'2002-05-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (210, 1, 2151, NULL, 2, 1, 2, NULL, N'APAZA MAMANI', N'BLAS NASARIO', 20, 48, 1, CAST(N'2002-05-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (211, 1, 2160, NULL, 2, 1, 5, NULL, N'ZAPATA', N'JOSE OSCAR', 20, 48, 1, CAST(N'2002-07-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (212, 1, 2166, NULL, 2, 1, 3, NULL, N'NINA', N'RUBEN', 20, 48, 1, CAST(N'2002-07-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (213, 1, 2171, NULL, 2, 1, 3, NULL, N'MENA CHINO', N'PABLO ISMAEL', 20, 48, 1, CAST(N'2002-07-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (214, 1, 2181, NULL, 1, 2, 35, NULL, N'ANDICOECHEA', N'MARIA JOSE', 14, 52, 1, CAST(N'2005-10-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (215, 1, 2190, NULL, 2, 1, 9, NULL, N'HERRERA', N'JORGE DAVID', 20, 22, 1, CAST(N'2002-10-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (216, 1, 2192, NULL, 2, 1, 3, NULL, N'RODRIGUEZ ACOSTA', N'JHONNY HUMBERTO', 20, 48, 1, CAST(N'2002-11-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (217, 1, 2202, NULL, 2, 1, 4, NULL, N'TORREZ FERNANDEZ', N'RUBEN', 20, 48, 1, CAST(N'2002-11-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (218, 1, 2219, NULL, 1, 1, 4, NULL, N'ANGULO SALVATIERRA', N'MARTHA ROSMERY', 20, 48, 1, CAST(N'2003-01-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (219, 1, 2234, NULL, 2, 1, 4, NULL, N'ALIAGA HUAYCHO', N'FREDDY FERNANDO', 20, 48, 1, CAST(N'2003-02-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (220, 1, 2258, NULL, 2, 1, 9, NULL, N'SALTO', N'JULIO RENATO', 20, 48, 1, CAST(N'2003-04-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (221, 1, 2311, NULL, 2, 1, 1, NULL, N'JIMENEZ CARRILLO', N'VICTOR JUAN', 20, 48, 1, CAST(N'2003-07-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (222, 1, 2315, NULL, 1, 1, 4, NULL, N'TUBIAS', N'PATRICIA ALEJANDRA', 20, 48, 1, CAST(N'2003-07-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (223, 1, 2316, NULL, 1, 1, 1, NULL, N'GONZALEZ', N'MARCELA VERONICA', 20, 48, 1, CAST(N'2003-07-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (224, 1, 2338, NULL, 2, 1, 1, NULL, N'ALBARRACIN ALVAREZ', N'CELEDONIO', 20, 48, 1, CAST(N'2003-08-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (225, 1, 2362, NULL, 1, 1, 4, NULL, N'CASTAÑO', N'GLADYS ELIZABETH', 20, 48, 1, CAST(N'2003-10-30T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (226, 1, 2363, NULL, 2, 1, 9, NULL, N'SANCHEZ ALPAS', N'HEBERT HOMER', 20, 22, 1, CAST(N'2003-10-31T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (227, 1, 2381, NULL, 2, 1, 9, NULL, N'FLORES', N'BELARMINO', 20, 22, 1, CAST(N'2003-12-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (228, 1, 2396, NULL, 2, 1, 1, NULL, N'PAXI TIÑINI', N'GUILLERMO ELOY', 20, 48, 1, CAST(N'2004-01-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (229, 1, 2401, NULL, 1, 1, 4, NULL, N'AGUIRRE', N'MIRIAM RAMONA', 20, 48, 1, CAST(N'2004-01-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (230, 1, 2412, NULL, 2, 1, 3, NULL, N'ENRIQUEZ BARRANCOS', N'OSCAR GUSTAVO', 20, 48, 1, CAST(N'2004-01-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (231, 1, 2430, NULL, 2, 1, 9, NULL, N'ESPINOZA SARMIENTO', N'JESUS ALEX', 20, 62, 1, CAST(N'2004-02-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (232, 1, 2447, NULL, 2, 1, 1, NULL, N'OVALLE', N'VICENTE', 20, 48, 1, CAST(N'2004-02-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (233, 1, 2479, NULL, 1, 1, 2, NULL, N'TALABERA', N'SUSANA CRISTINA', 20, 48, 1, CAST(N'2004-05-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (234, 1, 2531, NULL, 2, 1, 5, NULL, N'FALCON', N'HUGO ORLANDO', 20, 48, 1, CAST(N'2004-08-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (235, 1, 2571, NULL, 1, 1, 2, NULL, N'CAUCOTA', N'SILVIA AMANDA', 20, 48, 1, CAST(N'2004-12-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (236, 1, 2637, NULL, 2, 1, 9, NULL, N'MURILLO CARHUAZ', N'JOSE JESUS', 20, 48, 1, CAST(N'2005-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (237, 1, 2639, NULL, 1, 1, 11, NULL, N'ALVA GONZALEZ', N'SANDRA LIZBETT', 20, 62, 1, CAST(N'2005-03-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (238, 1, 2664, NULL, 2, 1, 15, NULL, N'YOVERA SILVA', N'MIGUEL', 20, 62, 1, CAST(N'2005-04-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (239, 1, 2687, NULL, 1, 1, 4, NULL, N'ORTEGA', N'ELBA GABRIELA', 20, 48, 1, CAST(N'2005-07-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (240, 1, 2691, NULL, 2, 1, 4, NULL, N'VELEZ MAMANI', N'ANGEL', 20, 48, 1, CAST(N'2005-07-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (241, 1, 2695, NULL, 2, 1, 4, NULL, N'CHURA ARANDA', N'GROVER ANGEL', 20, 24, 1, CAST(N'2005-08-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (242, 1, 2712, NULL, 2, 1, 3, NULL, N'MAMANI QUISPE', N'GUIDO TITO', 20, 48, 1, CAST(N'2005-12-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (243, 1, 2737, NULL, 2, 1, 1, NULL, N'GONGORA VELIZ', N'ELIAS RODRIGO', 20, 48, 1, CAST(N'2006-01-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (244, 1, 2739, NULL, 1, 1, 11, NULL, N'LATORRE', N'GABRIELA ELIZABETH', 20, 48, 1, CAST(N'2006-01-31T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (245, 1, 2741, NULL, 2, 1, 3, NULL, N'QUISPE AZQUICHO', N'DOMINGO', 20, 24, 1, CAST(N'2006-02-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (246, 1, 2744, NULL, 2, 1, 4, NULL, N'QUISPE HUAYLLAS', N'GERARDO', 20, 24, 1, CAST(N'2006-03-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (247, 1, 2753, NULL, 1, 1, 7, NULL, N'SANCHEZ OBREGON', N'ROSSMERY E.', 20, 48, 1, CAST(N'2006-04-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (248, 1, 2768, NULL, 1, 1, 10, NULL, N'MANSILLA', N'PATRICIA ALEJANDRA', 20, 48, 1, CAST(N'2006-05-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (249, 1, 2773, NULL, 2, 1, 1, NULL, N'VILLA CUTILE', N'SANTIAGO', 20, 24, 1, CAST(N'2006-06-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (250, 1, 2776, NULL, 2, 1, 1, NULL, N'CASTILLO HUANCA', N'JESUS ALBERTO', 20, 24, 1, CAST(N'2006-07-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (251, 1, 2780, NULL, 2, 1, 2, NULL, N'POMA KASA', N'JAVIER', 20, 24, 1, CAST(N'2006-07-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (252, 1, 2827, NULL, 2, 1, 1, NULL, N'HUIZA SONCO', N'DAVID SANDRO', 20, 24, 1, CAST(N'2006-10-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (253, 1, 2866, NULL, 2, 1, 1, NULL, N'GALLARDO SALAZAR', N'ULISES', 20, 24, 1, CAST(N'2007-04-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (254, 1, 2872, NULL, 2, 1, 27, NULL, N'DIAZ', N'RICARDO ALBERTO', 21, 41, 1, CAST(N'2007-04-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (255, 1, 2904, NULL, 2, 1, 1, NULL, N'LEYVA VELASQUEZ', N'ODAR MANRIQUE', 20, 62, 1, CAST(N'2007-06-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (256, 1, 2913, NULL, 2, 1, 16, NULL, N'ESPINOZA FERRER', N'YONATHAN ALEXANDER', 20, 62, 1, CAST(N'2007-06-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (257, 1, 2933, NULL, 1, 1, 11, NULL, N'PERREGRINI', N'CLAUDIA ELIZABETH', 20, 62, 1, CAST(N'2007-08-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (258, 1, 2941, NULL, 1, 1, 11, NULL, N'ALEGRIA MIRANDA', N'JACQUELINE', 20, 62, 1, CAST(N'2007-08-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (259, 1, 2954, NULL, 2, 1, 1, NULL, N'FLORES MIRANDA', N'MILTON', 20, 24, 1, CAST(N'2007-08-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (260, 1, 2960, NULL, 1, 1, 2, NULL, N'DIAZ CHOQUE', N'ELIZABET', 20, 62, 1, CAST(N'2007-09-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (261, 1, 2978, NULL, 2, 1, 3, NULL, N'CHAVEZ MAMANI', N'FREDDY SEVERO', 20, 24, 1, CAST(N'2007-10-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (262, 1, 2988, NULL, 2, 1, 20, NULL, N'MARTINEZ  ', N'SERGIO LUJAN', 21, 19, 1, CAST(N'2007-11-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (263, 1, 2990, NULL, 1, 1, 1, NULL, N'FRIAS', N'MIRTHA DEL CARMEN', 20, 48, 1, CAST(N'2007-11-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (264, 1, 2994, NULL, 2, 1, 6, NULL, N'JARA DE LA CRUZ', N'REYNERIO CARMELO', 20, 22, 1, CAST(N'2007-11-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (265, 1, 3002, NULL, 1, 1, 7, NULL, N'QUISPE CAYAMPI', N'YANE   ', 20, 48, 1, CAST(N'2007-11-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (266, 1, 3006, NULL, 2, 1, 4, NULL, N'CALATAYUD', N'HECTOR HUGO', 20, 24, 1, CAST(N'2007-12-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (267, 1, 3028, NULL, 2, 1, 3, NULL, N'ALIAGA HUAYCHO', N'CRISTOBAL', 20, 24, 1, CAST(N'2007-12-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (268, 1, 3034, NULL, 2, 1, 14, NULL, N'ZAVALA GARCIA', N'ELOY', 20, 62, 1, CAST(N'2008-01-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (269, 1, 3039, NULL, 2, 1, 1, NULL, N'LUYO GUEVARA', N'JUAN ISMAEL', 20, 62, 1, CAST(N'2008-01-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (270, 1, 3041, NULL, 2, 1, 5, NULL, N'CHAMBI MAMANI', N'RICHARD NELSON', 20, 24, 1, CAST(N'2008-01-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (271, 1, 3084, NULL, 1, 1, 3, NULL, N'ACUÑA', N'JULIA ROSA', 20, 62, 1, CAST(N'2008-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (272, 1, 3085, NULL, 2, 1, 4, NULL, N'SALGUERO SEGALES', N'DANIEL OVER', 20, 24, 1, CAST(N'2008-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (273, 1, 3117, NULL, 1, 1, 7, NULL, N'ROBLEDO', N'GLADYS', 20, 48, 1, CAST(N'2008-05-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (274, 1, 3120, NULL, 2, 1, 16, NULL, N'FERNANDEZ', N'CRISTIAN MAXIMILIANO', 20, 62, 1, CAST(N'2008-05-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (275, 1, 3147, NULL, 2, 1, 1, NULL, N'GONGORA VELIZ', N'EFRAIN', 20, 24, 1, CAST(N'2008-06-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (276, 1, 3149, NULL, 2, 1, 16, NULL, N'TENORIO VERGARAY', N'ELVIN NEYDER', 20, 62, 1, CAST(N'2008-06-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (277, 1, 3157, NULL, 2, 1, 2, NULL, N'SILVA LIZANO', N'NILTON', 20, 62, 1, CAST(N'2008-06-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (278, 1, 3164, NULL, 2, 1, 20, NULL, N'ORTIZ', N'OSCAR ALCIDES', 21, 19, 1, CAST(N'2008-06-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (279, 1, 3287, NULL, 1, 1, 4, NULL, N'DORADOR INGA', N'PAMELA', 20, 62, 1, CAST(N'2010-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (280, 1, 3304, NULL, 2, 1, 8, NULL, N'SOLIS RAMIREZ', N'ERLEN ROY', 14, 62, 1, CAST(N'2010-04-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (281, 1, 3308, NULL, 2, 1, 5, NULL, N'QUISPE MAMANI', N'PATRICIO', 20, 24, 1, CAST(N'2010-04-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (282, 1, 3309, NULL, 2, 1, 4, NULL, N'CIROLA CUENTAS', N'ADAM ROGER', 20, 24, 1, CAST(N'2010-04-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (283, 1, 3320, NULL, 2, 1, 9, NULL, N'VALVERDE ARAUJO', N'ROGER SAMUEL', 20, 62, 1, CAST(N'2010-05-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (284, 1, 3333, NULL, 1, 1, 2, NULL, N'PACHECO SARAVIA', N'LINDSAY MERCEDES', 20, 24, 1, CAST(N'2010-05-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (285, 1, 3347, NULL, 2, 1, 12, NULL, N'LANDA CUPITAY', N'JUAN CARLOS', 20, 40, 1, CAST(N'2010-06-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (286, 1, 3358, NULL, 1, 1, 26, NULL, N'TORRES CASTRO', N'ESPERANZA NILDA', 20, 62, 1, CAST(N'2010-06-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (287, 1, 3370, NULL, 1, 1, 11, NULL, N'ARELA QUISPE', N'HERMELINDA', 20, 62, 1, CAST(N'2010-06-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (288, 1, 3401, NULL, 2, 3, NULL, 328, N'JANAMPA AYALA', N'EDWARD MIGUEL', 20, 62, 1, CAST(N'2010-07-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (289, 1, 3403, NULL, 2, 1, 1, NULL, N'CHAVEZ MAMANI', N'RONALD JULIO', 20, 24, 1, CAST(N'2010-07-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (290, 1, 3423, NULL, 1, 1, 4, NULL, N'TREJO', N'SILVIA ERNESTINA', 20, 62, 1, CAST(N'2010-09-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (291, 1, 3436, NULL, 2, 1, 4, NULL, N'VARGAS MENDEZ', N'FRANCISCO', 20, 62, 1, CAST(N'2010-10-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (292, 1, 3443, NULL, 2, 1, 27, NULL, N'SORUCO', N'JUAN JOSE', 21, 61, 1, CAST(N'2010-10-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (293, 1, 3458, NULL, 2, 1, 5, NULL, N'OVANDO CACERES', N'LIDER', 20, 24, 1, CAST(N'2010-11-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (294, 1, 3469, NULL, 2, 1, 17, NULL, N'FAMIGLIETTI', N'JOSE IGNACIO', 20, 62, 1, CAST(N'2010-11-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (295, 1, 3526, NULL, 2, 1, 7, NULL, N'DENEGRI RAMIREZ', N'ALAN ALEXANDER', 20, 22, 1, CAST(N'2011-03-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (296, 1, 3527, NULL, 2, 1, 8, NULL, N'AYLLON', N'EDUARDO IGNACIO', 20, 62, 1, CAST(N'2011-03-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (297, 1, 3559, NULL, 2, 1, 27, NULL, N'CORREA', N'SERGIO DANIEL', 21, 18, 1, CAST(N'2011-04-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (298, 1, 3589, NULL, 1, 1, 11, NULL, N'ESCRIBA POMA', N'PIERINA ELIZABETH', 20, 62, 1, CAST(N'2011-06-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (299, 1, 3590, NULL, 1, 1, 11, NULL, N'ÑAHUIS ECHAJAYA', N'LIZ TANIA', 20, 62, 1, CAST(N'2011-06-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (300, 1, 3622, NULL, 1, 1, 15, NULL, N'MACHADO', N'SABRINA MARIA', 20, 48, 1, CAST(N'2011-09-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (301, 1, 3624, NULL, 2, 1, 27, NULL, N'VARGAS', N'SERGIO GASTON', 21, 37, 1, CAST(N'2011-09-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (302, 1, 3635, NULL, 2, 1, 8, NULL, N'GONZALEZ CARDENAS', N'JOSE', 20, 62, 1, CAST(N'2011-10-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (303, 1, 3643, NULL, 2, 1, 3, NULL, N'MIRANDA FLORES', N'DIEGO ARMANDO', 20, 24, 1, CAST(N'2011-10-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (304, 1, 3645, NULL, 2, 1, 5, NULL, N'POMA ALCON', N'FERNANDO', 20, 24, 1, CAST(N'2011-10-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (305, 1, 3671, NULL, 2, 1, 4, NULL, N'CONDE CONDE', N'SILVERIO SANTIAGO', 20, 24, 1, CAST(N'2012-01-02T00:00:00.000' AS DateTime), NULL, N'')
GO
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (306, 1, 3677, NULL, 1, 1, 11, NULL, N'FERNANDEZ', N'SILVIA CAROLINA', 20, 62, 1, CAST(N'2012-03-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (307, 1, 3681, NULL, 1, 1, 5, NULL, N'CHUMIOQUE REYNA', N'ROSA JENNIFER', 20, 48, 1, CAST(N'2012-03-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (308, 1, 3699, NULL, 1, 1, 15, NULL, N'SANCHEZ OBREGON', N'ERIKA MARINA', 20, 62, 1, CAST(N'2012-03-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (309, 1, 3704, NULL, 1, 1, 1, NULL, N'JARA ITURBE', N'CELIA CAROLINA', 20, 62, 1, CAST(N'2012-04-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (310, 1, 3707, NULL, 1, 1, 3, NULL, N'TROCHE JAUREGUI', N'CONSUELO', 20, 48, 1, CAST(N'2012-04-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (311, 1, 3742, NULL, 2, 1, 12, NULL, N'VALLE LOPEZ', N'CARLOS', 20, 62, 1, CAST(N'2012-06-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (312, 1, 3750, NULL, 2, 1, 1, NULL, N'GUERRERO CALDERON', N'EDGAR GUIDO', 20, 62, 1, CAST(N'2012-06-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (313, 1, 3752, NULL, 1, 1, 1, NULL, N'TERRONES PISCO', N'SONIA LUZ', 20, 24, 1, CAST(N'2012-06-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (314, 1, 3755, NULL, 2, 1, 7, NULL, N'SOTO', N'ADRIAN', 20, 48, 1, CAST(N'2012-06-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (315, 1, 3763, NULL, 2, 1, 5, NULL, N'MAMANI GUARACHI', N'JHONNY LUIS', 20, 24, 1, CAST(N'2012-07-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (316, 1, 3771, NULL, 1, 1, 11, NULL, N'ARANDA', N'MAIDA LILIANA', 20, 62, 1, CAST(N'2012-07-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (317, 1, 3777, NULL, 2, 1, 12, NULL, N'FLORES CALDERON', N'CARLOS FRANCISCO', 20, 40, 1, CAST(N'2012-07-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (318, 1, 3778, NULL, 2, 1, 27, NULL, N'FERNANDEZ', N'ANDRES SEBASTIAN', 21, 37, 1, CAST(N'2012-07-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (319, 1, 3782, NULL, 1, 2, 41, NULL, N'BITO BUSTINZA', N'JESSICA RUBI', 11, 9, 1, CAST(N'2012-07-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (320, 1, 3833, NULL, 2, 1, 15, NULL, N'SOLIS RAMIREZ', N'ADAM GINO', 20, 62, 1, CAST(N'2013-01-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (321, 1, 3842, NULL, 2, 1, 14, NULL, N'ANDINO', N'JUAN CARLOS', 20, 62, 1, CAST(N'2013-01-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (322, 1, 3845, NULL, 2, 1, 27, NULL, N'CORREA', N'JORGE GASTON', 21, 18, 1, CAST(N'2013-01-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (323, 1, 3846, NULL, 2, 1, 3, NULL, N'CHUQUIMIA RAMOS', N'WILFREDO', 20, 24, 1, CAST(N'2013-01-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (324, 1, 3847, NULL, 2, 1, 4, NULL, N'CONDORPOCCO LIMA', N'DAVID', 20, 24, 1, CAST(N'2013-01-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (325, 1, 3879, NULL, 2, 1, 27, NULL, N'ZARATE', N'CARLOS ALBERTO', 21, 18, 1, CAST(N'2013-03-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (326, 1, 3894, NULL, 2, 1, 9, NULL, N'LOPEZ VALLADARES', N'PEDRO LUIS', 20, 62, 1, CAST(N'2013-04-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (327, 1, 3897, NULL, 2, 1, 3, NULL, N'FLORES FERNANDEZ', N'ANTONIO', 20, 24, 1, CAST(N'2013-05-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (328, 1, 3941, NULL, 2, 1, 1, NULL, N'BRITOS ARZAMENDIA', N'EMILIO ANDRES', 20, 62, 1, CAST(N'2013-09-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (329, 1, 3945, NULL, 1, 1, 3, NULL, N'GARCIA', N'CINTHIA LORENA', 20, 62, 1, CAST(N'2013-09-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (330, 1, 3947, NULL, 1, 1, 26, NULL, N'LUJAN DELGADO', N'CRIS ANABEL', 20, 62, 1, CAST(N'2013-09-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (331, 1, 3975, NULL, 1, 1, 26, NULL, N'CUELLAR', N'LILIANA JIMENA', 20, 62, 1, CAST(N'2014-05-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (332, 1, 3994, NULL, 2, 1, 27, NULL, N'VENTURO PADILLA', N'JOHAN LUIS', 22, 61, 1, CAST(N'2014-10-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (333, 1, 4002, NULL, 2, 1, 5, NULL, N'TINTA TACACHIRA', N'BLADIMIR', 20, 24, 1, CAST(N'2014-11-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (334, 1, 4007, NULL, 2, 1, 3, NULL, N'POMA ALEGRE', N'PEDRO', 20, 24, 1, CAST(N'2014-11-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (335, 1, 4009, NULL, 2, 1, 27, NULL, N'GUTIERREZ', N'JORGE LUIS', 21, 61, 1, CAST(N'2014-10-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (336, 1, 4013, NULL, 2, 1, 1, NULL, N'CAMPOS URQUIOLA', N'HERBERTH', 20, 24, 1, CAST(N'2015-01-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (337, 1, 4017, NULL, 2, 1, 27, NULL, N'MENDIETA ', N'WALTER DAMASO', 21, 61, 1, CAST(N'2015-01-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (338, 1, 4025, NULL, 2, 1, 1, NULL, N'TORRES', N'FLORENCIO', 20, 24, 1, CAST(N'2015-01-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (339, 1, 4043, NULL, 2, 1, 3, NULL, N'NOGUERA', N'CRISTIAN RODRIGO', 20, 62, 1, CAST(N'2015-03-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (340, 1, 4055, NULL, 2, 1, 7, NULL, N'DOMINGUEZ', N'CLAUDIO FERNANDO', 20, 24, 1, CAST(N'2015-04-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (341, 1, 4076, NULL, 1, 1, 7, NULL, N'SARAVIA CARRILLO', N'EMILDA', 20, 24, 1, CAST(N'2015-05-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (342, 1, 4078, NULL, 2, 1, 9, NULL, N'PINILLA QUISPE', N'RAFAEL ANGEL', 20, 22, 1, CAST(N'2015-05-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (343, 1, 4083, NULL, 2, 1, 5, NULL, N'VALDIVIA QUEZADA', N'FELIX JAVIER', 20, 62, 1, CAST(N'2015-06-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (344, 1, 4085, NULL, 2, 1, 27, NULL, N'GODOY', N'LORENZO ENRIQUE', 21, 41, 1, CAST(N'2015-06-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (345, 1, 4090, NULL, 1, 1, 4, NULL, N'CHOQUE CHURA', N'VIVIANA', 20, 24, 1, CAST(N'2015-06-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (346, 1, 4092, NULL, 1, 1, 1, NULL, N'BENITEZ', N'MYRIAM BEATRIZ', 20, 62, 1, CAST(N'2015-06-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (347, 1, 4095, NULL, 1, 1, 5, NULL, N'PERALTA', N'YANINA GISELA', 20, 48, 1, CAST(N'2015-06-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (348, 1, 4100, NULL, 2, 1, 3, NULL, N'ACEVAL', N'NORBERTO DANIEL', 20, 62, 1, CAST(N'2015-07-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (349, 1, 4102, NULL, 2, 1, 2, NULL, N'MARTINEZ VILLAROEL', N'BEIMAR', 20, 24, 1, CAST(N'2015-07-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (350, 1, 4114, NULL, 2, 1, 7, NULL, N'SARABIA GARAY', N'OSVALDO', 20, 62, 1, CAST(N'2011-08-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (351, 1, 4121, NULL, 2, 1, 4, NULL, N'VELASCO QUISPE', N'ZENON PEDRO', 20, 24, 1, CAST(N'2015-08-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (352, 1, 4127, NULL, 1, 1, 10, NULL, N'RIQUELME NARVAEZ', N'CINTHIA ALEXANDRA', 20, 62, 1, CAST(N'2015-08-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (353, 1, 4137, NULL, 1, 1, 4, NULL, N'GOMEZ', N'MONICA EMILIA', 20, 24, 1, CAST(N'2015-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (354, 1, 4162, NULL, 2, 1, 5, NULL, N'VALDEZ ZARATE', N'CARLOS YERAL', 20, 62, 1, CAST(N'2015-09-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (355, 1, 4191, NULL, 2, 1, 16, NULL, N'GUERRERO GODOY', N'HENRY LUIS', 20, 62, 1, CAST(N'2015-11-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (356, 1, 4217, NULL, 2, 1, 27, NULL, N'PAGEZ', N'JAVIER GUSTAVO', 21, 18, 1, CAST(N'2016-01-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (357, 1, 4231, NULL, 1, 1, 11, NULL, N'DIAZ ROSADO', N'HELEN ELIZABETH', 20, 62, 1, CAST(N'2016-04-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (358, 1, 4232, NULL, 1, 1, 11, NULL, N'CAMACO CHAGUA', N'ROCIO MAGALY', 20, 62, 1, CAST(N'2016-04-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (359, 1, 4239, NULL, 1, 1, 11, NULL, N'VIERA ALARCON', N'JUSTINA', 20, 47, 1, CAST(N'2016-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (360, 1, 4247, NULL, 2, 1, 8, NULL, N'CESPEDES SAMANIEGO', N'DILSON GUSTAVO', 20, 62, 1, CAST(N'2016-05-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (361, 1, 4258, NULL, 1, 1, 11, NULL, N'JAIME', N'ANA DEL MILAGRO', 20, 62, 1, CAST(N'2016-06-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (362, 1, 4259, NULL, 2, 1, 8, NULL, N'ROCHA FERNANDEZ', N'JOSE MIGUEL', 20, 62, 1, CAST(N'2016-06-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (363, 1, 4267, NULL, 1, 1, 1, NULL, N'DE LA CRUZ GALLARDO', N'KATIA ELIZABETH', 20, 62, 1, CAST(N'2016-07-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (364, 1, 4295, NULL, 1, 1, 11, NULL, N'PACHAS BARBOZA', N'KEIKO MARUSHKA', 20, 48, 1, CAST(N'2017-02-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (365, 1, 4296, NULL, 1, 1, 11, NULL, N'LEGUIZAMON GENEZ', N'MARIA CLOTILDE', 20, 48, 1, CAST(N'2017-03-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (366, 1, 4314, NULL, 2, 1, 1, NULL, N'ENCINAS BASCOPE', N'NELSON FERNANDO', 20, 24, 1, CAST(N'2018-05-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (367, 1, 4320, NULL, 2, 1, 27, NULL, N'CAYOJA TEMO', N'RENZO', 22, 61, 1, CAST(N'2018-07-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (368, 1, 4321, NULL, 2, 1, 4, NULL, N'SAENZ SAUCEDA', N'RENE YVAN', 20, 24, 1, CAST(N'2018-08-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (369, 1, 4325, NULL, 2, 1, 4, NULL, N'MAMANI COPATITI', N'FAUSTINO OMAR', 20, 24, 1, CAST(N'2018-09-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (370, 1, 4329, NULL, 2, 1, 1, NULL, N'CONDORI MARCA', N'ROMAN', 20, 24, 1, CAST(N'2018-11-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (371, 1, 4331, NULL, 2, 1, 4, NULL, N'DELGADO CASTILLO', N'JUAN DANIEL', 20, 24, 1, CAST(N'2018-11-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (372, 1, 4332, NULL, 2, 1, 5, NULL, N'HUARACHI LOPEZ', N'JOSE LUIS', 20, 24, 1, CAST(N'2018-11-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (373, 1, 4333, NULL, 2, 1, 27, NULL, N'AGUILAR CALZADA', N'MARCO ANTONIO', 21, 61, 1, CAST(N'2018-11-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (374, 1, 4334, NULL, 2, 1, 16, NULL, N'ARMOA ', N'ANGEL SEBASTIAN', 20, 62, 1, CAST(N'2019-03-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (375, 1, 4338, NULL, 2, 1, 7, NULL, N'TAPIA HINOJOSA', N'ALVARO', 18, 62, 1, CAST(N'2019-03-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (376, 1, 4339, NULL, 2, 1, 16, NULL, N'JARA AMARILLA', N'SERGIO DAVID', 18, 62, 1, CAST(N'2019-05-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (377, 1, 4340, NULL, 1, 1, 4, NULL, N'TREJO', N'CARMEN CAROLINA', 20, 24, 1, CAST(N'2019-05-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (378, 1, 4342, NULL, 2, 1, 3, NULL, N'MURUCHI CALIZAYA', N'OMAR MILTON', 20, 24, 1, CAST(N'2019-05-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (379, 1, 4345, NULL, 2, 1, 16, NULL, N'GAMBARTE ', N'BRIAN ANDRES', 7, 62, 1, CAST(N'2019-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (380, 1, 4346, NULL, 2, 1, 16, NULL, N'CABRERA TORRES', N'RONI YAMIL', 7, 62, 1, CAST(N'2019-07-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (381, 1, 4351, NULL, 2, 1, 10, NULL, N'YÑIGUEZ ', N'HERNAN SANTIAGO', 20, 48, 1, CAST(N'2019-08-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (382, 1, 4352, NULL, 2, 1, 16, NULL, N'CAMPOS URQUIOLA', N'MARCELO ', 7, 62, 1, CAST(N'2019-08-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (383, 1, 4361, NULL, 1, 1, 10, NULL, N'FLOR REYES', N'CELIA GRACIELA', 7, 48, 1, CAST(N'2019-09-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (384, 1, 4362, NULL, 1, 1, 26, NULL, N'GUANES CARRIZO', N'MARIA AMALIA', 7, 62, 1, CAST(N'2019-09-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (385, 1, 4365, NULL, 2, 1, 11, NULL, N'CARDENAS', N'NICOLAS AGUSTIN', 7, 62, 1, CAST(N'2019-11-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (386, 1, 4369, NULL, 1, 1, 11, NULL, N'ORTMANN', N'AYELEN LUCIA', 7, 62, 1, CAST(N'2020-01-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (387, 1, 4370, NULL, 1, 1, 7, NULL, N'POBLETE ', N'ANDREA VERONICA', 18, 62, 1, CAST(N'2020-01-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (388, 1, 4371, NULL, 2, 1, 27, NULL, N'GUTIERREZ MALLON', N'ARIEL', 22, 61, 1, CAST(N'2020-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (389, 1, 4373, NULL, 2, 1, 6, NULL, N'ACOSTA', N'FERNANDO MIGUEL', 7, 62, 1, CAST(N'2020-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (390, 1, 4374, NULL, 2, 1, 7, NULL, N'JESUS FLORES', N'HEYDER ALBERTO', 7, 62, 1, CAST(N'2020-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (391, 1, 4375, NULL, 2, 1, 4, NULL, N'PEREZ CHAMBILLA', N'BERNABE WILLIAM', 18, 24, 1, CAST(N'2020-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (392, 1, 4376, NULL, 2, 1, 1, NULL, N'GARCIA PADRON', N'JAIME JOSE', 7, 62, 1, CAST(N'2020-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (393, 1, 3101, NULL, 1, 3, NULL, 328, N'FERNANDEZ', N'MONICA CECILIA', 20, 62, 1, CAST(N'2008-03-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (394, 1, 3960, NULL, 1, 3, NULL, 328, N'SALAZAR', N'MARIA LUCILA', 20, 62, 1, CAST(N'2013-11-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (395, 1, 4377, NULL, 1, 1, 2, NULL, N'CLAROS CAMACHO', N'MAGALI', 7, 24, 1, CAST(N'2021-03-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (396, 1, 4378, NULL, 2, 1, 2, NULL, N'POLO SANCHEZ', N'JUAN JULIO', 7, 24, 1, CAST(N'2021-03-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (397, 1, 4379, NULL, 1, 1, 2, NULL, N'PATON PORCO', N'CLARIBEL', 7, 24, 1, CAST(N'2021-03-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (398, 1, 4382, NULL, 2, 1, 2, NULL, N'MENDOZA MAMANI', N'OMAR WILSON', 7, 24, 1, CAST(N'2021-03-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (399, 1, 4385, NULL, 1, 1, 2, NULL, N'TORRES', N'ALICIA BEATRIZ', 7, 24, 1, CAST(N'2021-03-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (400, 1, 4387, NULL, 2, 1, 2, NULL, N'TORREZ VERA', N'ALEJO', 7, 24, 1, CAST(N'2021-03-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (401, 1, 4397, NULL, 2, 1, 27, NULL, N'SEQUEIRA', N'PABLO ANDRES', 23, 62, 1, CAST(N'2021-08-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (402, 1, 4400, NULL, 2, 1, 16, NULL, N'FERNANDEZ BARRIENTOS', N'DAVID', 19, 62, 1, CAST(N'2021-09-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (403, 1, 4401, NULL, 2, 1, 2, NULL, N'SAMANIEGO RUIZ DIAZ', N'FABIO', 24, 24, 1, CAST(N'2021-09-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (404, 1, 4402, NULL, 2, 1, 16, NULL, N'CAMPOS URQUIOLA', N'ANDY', 19, 62, 1, CAST(N'2021-09-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (405, 1, 4406, NULL, 1, 1, 2, NULL, N'CABRERA CAVERO', N'BELEN DE LOS ANGELES', 19, 62, 1, CAST(N'2021-11-01T00:00:00.000' AS DateTime), NULL, N'')
GO
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (406, 1, 4407, NULL, 2, 1, 10, NULL, N'MENDOZA   ', N'DANIEL', 19, 62, 1, CAST(N'2021-11-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (407, 1, 4415, NULL, 1, 1, 5, NULL, N'SUNI SARAYASI', N'CRISEL GREGORIA', 24, 24, 1, CAST(N'2021-12-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (408, 1, 4418, NULL, 1, 1, 11, NULL, N'SALAS', N'FLORENCIA', 19, 62, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (409, 1, 4421, NULL, 2, 1, 5, NULL, N'YARASCA', N'JORGE RICARDO', 24, 24, 1, CAST(N'2021-12-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (410, 1, 4426, NULL, 1, 1, 11, NULL, N'INSFRAN ALCARAZ', N'LINDA LORENA', 19, 62, 1, CAST(N'2022-01-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (411, 1, 4427, NULL, 1, 1, 11, NULL, N'RUFINEZ', N'ROCIO DAIANA', 19, 62, 1, CAST(N'2022-01-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (412, 1, 4430, NULL, 2, 1, 16, NULL, N'ARTEAGA ESTRADA', N'ALONSO', 19, 62, 1, CAST(N'2022-01-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (413, 1, 4431, NULL, 2, 1, 16, NULL, N'VILLALBA', N'RICARDO LIONEL', 19, 62, 1, CAST(N'2022-01-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (414, 1, 4432, NULL, 1, 1, 2, NULL, N'HERRERA', N'MABEL MARIELA', 24, 24, 1, CAST(N'2022-01-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (415, 1, 4436, NULL, 1, 1, 7, NULL, N'PACHAS BARBOZA', N'CLARIZA CRISTINA', 19, 62, 1, CAST(N'2022-01-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (416, 1, 4442, NULL, 2, 1, 27, NULL, N'SARAVIA', N'RUBEN MARCELO', 23, 1, 1, CAST(N'2022-01-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (417, 1, 4444, NULL, 2, 1, 16, NULL, N'GIMENEZ ', N'PATRICIO OLEGARIO', 19, 62, 1, CAST(N'2022-02-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (418, 1, 4445, NULL, 1, 1, 11, NULL, N'RUSSO ', N'VICTORIA MERCEDES', 19, 62, 1, CAST(N'2022-02-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (419, 1, 4448, NULL, 2, 1, 16, NULL, N'OSORES', N'MARTIN NICOLAS', 19, 62, 1, CAST(N'2022-02-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (420, 1, 4451, NULL, 1, 1, 11, NULL, N'RUIZ', N'ROCIO VANESSA', 19, 62, 1, CAST(N'2022-02-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (421, 1, 4452, NULL, 1, 1, 11, NULL, N'SANCHEZ BEJARANO', N'ANA MELIZA', 19, 62, 1, CAST(N'2022-02-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (422, 1, 4455, NULL, 2, 1, 2, NULL, N'GARCIA', N'NESTOR', 24, 24, 1, CAST(N'2022-02-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (423, 1, 4456, NULL, 2, 1, 16, NULL, N'BENITEZ', N'RAFAEL ANTONIO', 19, 62, 1, CAST(N'2022-02-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (424, 1, 4457, NULL, 2, 1, 16, NULL, N'MAZZINI MENACHO', N'ENRRIQUE GUILLERMO', 19, 62, 1, CAST(N'2022-02-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (425, 1, 4465, NULL, 1, 1, 11, NULL, N'DIAZ', N'YAEL BELEN', 19, 62, 1, CAST(N'2022-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (426, 1, 4467, NULL, 1, 1, 11, NULL, N'AMEZAGUE', N'ANGELICA VANESA', 19, 62, 1, CAST(N'2022-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (427, 1, 4470, NULL, 1, 1, 11, NULL, N'VEGA  ', N'CARLA ROMINA', 19, 62, 1, CAST(N'2022-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (428, 1, 4471, NULL, 2, 1, 1, NULL, N'RAMOS SIFUENTES', N'RODRIGO JOAN ARIEL', 19, 62, 1, CAST(N'2022-03-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (429, 1, 4473, NULL, 2, 1, 1, NULL, N'OVANDO  ', N'ADRIAN DANIEL', 19, 62, 1, CAST(N'2022-03-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (430, 1, 4474, NULL, 1, 1, 2, NULL, N'MACUAGA', N'MARLENE INES', 24, 24, 1, CAST(N'2022-03-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (431, 1, 4475, NULL, 2, 1, 1, NULL, N'ALARCON ', N'ANA LAURA', 19, 62, 1, CAST(N'2022-03-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (432, 1, 4476, NULL, 1, 1, 5, NULL, N'ASCASIBAR VASQUEZ', N'DIANA YESSICA', 19, 62, 1, CAST(N'2022-03-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (433, 1, 4477, NULL, 1, 3, NULL, 328, N'DENEGRI QUIJANO', N'KAROL MAYTE', 19, 62, 1, CAST(N'2022-03-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (434, 1, 4480, NULL, 2, 1, 16, NULL, N'ROMAN VELEZ', N'CARLOS ERWIN', 19, 62, 1, CAST(N'2022-03-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (435, 1, 4481, NULL, 2, 1, 2, NULL, N'GARCIA AROTINCO', N'MANUEL JOSE', 19, 62, 1, CAST(N'2022-03-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (436, 1, 4482, NULL, 1, 1, 2, NULL, N'PANIAGUA ORTIZ', N'LICETH', 24, 24, 1, CAST(N'2022-03-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (437, 1, 4484, NULL, 2, 1, 2, NULL, N'GUAYMAS', N'MAURO DENIS', 19, 62, 1, CAST(N'2022-04-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (438, 1, 4485, NULL, 2, 1, 2, NULL, N'TORRES SANCHEZ', N'MATIAS SEBASTIAN', 24, 24, 1, CAST(N'2022-04-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (439, 1, 4486, NULL, 2, 1, 2, NULL, N'GAJARDO', N'SEBASTIAN RODRIGO', 19, 62, 1, CAST(N'2022-04-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (440, 1, 4489, NULL, 1, 1, 7, NULL, N'CORDOVA SOPOMOYO', N'GERALDINE BARBARA', 19, 62, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (441, 1, 4490, NULL, 2, 1, 2, NULL, N'PEREZ', N'GABRIEL IGNACIO BASILIO', 19, 62, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (442, 1, 4487, NULL, 2, 1, 2, NULL, N'RIVERO', N'DANIEL ALBERTO', 19, 62, 1, CAST(N'2022-04-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (443, 1, 4491, NULL, 2, 1, 2, NULL, N'RODRIGUEZ', N'ANDREA PAOLA', 19, 62, 1, CAST(N'2022-04-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (444, 1, 4492, NULL, 1, 1, 2, NULL, N'CUEVAS', N'EMILY KATE AILYN', 24, 24, 1, CAST(N'2022-04-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (445, 1, 4493, NULL, 1, 1, 2, NULL, N'ZARATE QUISPE', N'ROSINA PILAR', 24, 24, 1, CAST(N'2022-04-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (446, 1, 4494, NULL, 2, 1, 16, NULL, N'MAYA VILCHEZ', N'DENIS JESUS', 19, 62, 1, CAST(N'2022-04-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (447, 1, 4495, NULL, 2, 1, 9, NULL, N'PINARDI ASIN', N'PABLO ADRIAN', 19, 62, 1, CAST(N'2022-04-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (448, 1, 4497, NULL, 2, 1, 7, NULL, N'RAO', N'ALEX GABRIEL', 19, 62, 1, CAST(N'2022-04-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (449, 1, 4498, NULL, 1, 1, 7, NULL, N'BRITOS ARZAMENDIA', N'JOHANA MICAELA', 19, 62, 1, CAST(N'2022-04-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (450, 1, 4499, NULL, 2, 1, 9, NULL, N'ITURRIA', N'ALAN RUBEN', 19, 62, 1, CAST(N'2022-04-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (451, 1, 4500, NULL, 2, 1, 10, NULL, N'RUPAY BELLIDO', N'ANGEL ABDUL', 19, 62, 1, CAST(N'2022-04-27T00:00:00.000' AS DateTime), CAST(N'2022-06-22T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (452, 1, 4502, NULL, 2, 1, 2, NULL, N'LLANOS', N'JONATHAN LEONEL', 19, 62, 1, CAST(N'2022-05-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (453, 1, 4503, NULL, 2, 1, 2, NULL, N'MAMANI TAPIA ', N'JUAN EZEQUIEL', 19, 62, 1, CAST(N'2022-05-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (454, 1, 4505, NULL, 2, 1, 16, NULL, N'VIÑAS', N'IGNACIO', 19, 62, 1, CAST(N'2022-05-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (455, 1, 4506, NULL, 2, 1, 7, NULL, N'BALAZAR VILCA', N'JUAN CARLOS', 19, 62, 1, CAST(N'2022-05-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (456, 1, 4508, NULL, 1, 1, 2, NULL, N'GARAY ESPINOLA', N'DELIA MARCELA', 24, 24, 1, CAST(N'2022-05-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (457, 1, 4510, NULL, 2, 1, 7, NULL, N'CORDOVA SOPAMOYO', N'MISAEL FREDY', 19, 62, 1, CAST(N'2022-05-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (458, 1, 4511, NULL, 1, 1, 2, NULL, N'MENDEZ  ', N'ANA DELIA', 7, 24, 1, CAST(N'2022-05-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (459, 1, 5023, NULL, 1, 1, 24, NULL, N'MARTINEZ', N'NELIDA ESMIR', 16, 43, 1, CAST(N'2008-08-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (460, 1, 5038, NULL, 1, 1, 24, NULL, N'ROSALES SARAVIA', N'NANCY F.', 26, 21, 1, CAST(N'2011-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (461, 1, 5045, NULL, 2, 1, 24, NULL, N'MENDOZA LIMACHI', N'MARCOS', 26, 21, 1, CAST(N'2012-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (462, 1, 5047, NULL, 1, 1, 24, NULL, N'LOPEZ ZENTENO', N'ROBERTO', 26, 21, 1, CAST(N'2012-05-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (463, 1, 5050, NULL, 1, 1, 24, NULL, N'SAICO QUISPE', N'DAVID', 26, 21, 1, CAST(N'2012-11-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (464, 1, 5052, NULL, 2, 1, 24, NULL, N'RAMOS ZAMORA', N'JORGE FREDDY', 26, 21, 1, CAST(N'2013-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (465, 1, 5069, NULL, 1, 1, 24, NULL, N'ALAVI ALAVI ', N'MAXIMA EMELIANA (ZUMMA SRL)', 26, 21, 1, CAST(N'2019-02-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (466, 1, 5056, NULL, 1, 1, 24, NULL, N'BLANCO CONDORI', N'MARGARITA', 26, 21, 1, CAST(N'2019-02-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (467, 1, 5070, NULL, 1, 1, 24, NULL, N'BUSS', N'CATALINA', 26, 21, 1, CAST(N'2019-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (468, 1, 5071, NULL, 2, 1, 24, NULL, N'LUPA ZENTENO', N'BASILIO (Rep. MONTELUSA)', 26, 21, 1, CAST(N'2019-02-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (469, 1, 5073, NULL, 1, 1, 24, NULL, N'VELAZQUEZ RAMOS', N'MARISOL (Rep. SMVIVELTEX SRL)', 26, 21, 1, CAST(N'2019-05-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (470, 1, 5074, NULL, 2, 1, 24, NULL, N'CAMAÑO', N'LUCAS ALFREDO (Rep.STAR-FOX S.A)', 26, 21, 1, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (471, 1, 5076, NULL, 2, 1, 24, NULL, N'FLORES NAVARRETE', N'ALEF ISRAEL', 26, 21, 1, CAST(N'2021-11-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (472, 1, 9001, NULL, 1, 2, 25, NULL, N'LATTARULO', N'MONICA CLARA', 8, 28, 1, CAST(N'2006-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (473, 1, 9003, NULL, 2, 2, 25, NULL, N'PAIS RAMIREZ', N'D. MARTIN', 8, 29, 1, CAST(N'2006-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (474, 1, 9004, NULL, 1, 2, 25, NULL, N'FERNANDEZ', N'ROXANA ANALIA', 8, 30, 1, CAST(N'2006-03-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (475, 1, 9006, NULL, 2, 2, 25, NULL, N'FERRARI', N'ARIEL WALDEMAR', 8, 20, 1, CAST(N'2009-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (476, 1, 9007, NULL, 2, 2, 25, NULL, N'SALAZAR', N'MIRTA SUSANA', 8, 31, 1, CAST(N'2019-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (477, 2, 124, NULL, 1, 3, NULL, 332, N'MALCERVELLI ', N'GABRIELA TERESA', 14, 39, 1, CAST(N'2011-10-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (478, 2, 131, NULL, 1, 3, NULL, 301, N'VILLARROEL', N'CARLA LORENA', 28, 17, 1, CAST(N'2011-11-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (479, 2, 135, NULL, 2, 3, NULL, 330, N'CORDOBA', N'CRISTIAN NAHUEL', 28, 17, 1, CAST(N'2011-12-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (480, 2, 136, NULL, 2, 3, NULL, 305, N'MOYA', N'NICOLAS GABRIEL', 14, 39, 1, CAST(N'2012-01-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (481, 2, 156, NULL, 2, 3, NULL, 309, N'RIOS VALLEJOS', N'AMERICO ALEJANDRO', 28, 65, 1, CAST(N'2012-04-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (482, 2, 164, NULL, 2, 3, NULL, 301, N'STRANIERI', N'BRIAN', 14, 39, 1, CAST(N'2012-07-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (483, 2, 267, NULL, 1, 3, NULL, 344, N'MALTISOTTO', N'MONICA MABEL', 14, 38, 1, CAST(N'2010-09-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (484, 2, 290, NULL, 1, 3, NULL, 330, N'ROTELLA', N'ADRIANA MARCELA', 14, 39, 1, CAST(N'2013-11-13T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (485, 2, 348, NULL, 2, 3, NULL, 336, N'CACERES', N'GERMAN', 14, 39, 1, CAST(N'2013-12-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (486, 2, 371, NULL, 1, 2, 31, NULL, N'LATTARULO', N'ALICIA BEATRIZ', 8, 31, 1, CAST(N'2020-09-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (487, 2, 429, NULL, 1, 3, NULL, 326, N'COBASPEÑA', N'FABIANA BEATRIZ', 14, 39, 1, CAST(N'2014-07-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (488, 2, 430, NULL, 2, 3, NULL, 326, N'BRIZUEÑA', N'RICARDO', 28, 17, 1, CAST(N'2006-10-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (489, 2, 431, NULL, 1, 3, NULL, 326, N'VENTURA ', N'BARBARA YAMILA', 28, 65, 1, CAST(N'2009-01-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (490, 2, 436, NULL, 2, 2, 31, NULL, N'SEGOVIA', N'RICARDO FIDEL', 4, 69, 1, CAST(N'2014-09-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (491, 2, 504, NULL, 2, 3, NULL, 309, N'SAN MARTIN', N'OSCAR EMILIANO', 14, 39, 1, CAST(N'2015-02-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (492, 2, 506, NULL, 2, 3, NULL, 104, N'BURNEO', N'HUGO GABRIEL', 28, 65, 1, CAST(N'2015-02-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (493, 2, 580, NULL, 2, 3, NULL, 315, N'FERNANDEZ', N'CECILIA BELEN', 14, 39, 1, CAST(N'2015-06-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (494, 2, 601, NULL, 2, 3, NULL, 330, N'DOLDAN PEREZ', N'CARLOS SEBASTIAN', 28, 17, 1, CAST(N'2015-10-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (495, 2, 666, NULL, 2, 3, NULL, 324, N'SUONI', N'MAURICIO ALEJANDRO', 14, 39, 1, CAST(N'2016-02-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (496, 2, 667, NULL, 1, 3, NULL, 334, N'FERNANDEZ', N'PATRICIA ELENA', 14, 39, 1, CAST(N'2016-02-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (497, 2, 669, NULL, 2, 3, NULL, 332, N'PADILLA', N'PABLO DAMIAN', 28, 65, 1, CAST(N'2016-03-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (498, 2, 720, NULL, 2, 3, NULL, 334, N'RODRIGUEZ', N'JONATHAN DANIEL', 28, 64, 1, CAST(N'2016-05-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (499, 2, 736, NULL, 2, 3, NULL, 336, N'CAPORALE', N'CRISTIAN MARTIN', 28, 17, 1, CAST(N'2016-06-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (500, 2, 737, NULL, 2, 3, NULL, 344, N'HERRERA', N'PABLO EZEQUIEL', 28, 65, 1, CAST(N'2016-06-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (501, 2, 740, NULL, 2, 3, NULL, 346, N'AYMO', N'JUAN MANUEL', 28, 65, 1, CAST(N'2016-07-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (502, 2, 744, NULL, 2, 1, 16, NULL, N'CONTRERAS BERROSPI', N'JENRY', 6, 26, 1, CAST(N'2016-08-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (503, 2, 749, NULL, 2, 1, 16, NULL, N'TRASCIERRA', N'CHRISTIAN GABRIEL', 6, 26, 1, CAST(N'2016-08-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (504, 2, 750, NULL, 2, 1, 16, NULL, N'OGANDO', N'FRANCIS NAHUEL', 6, 26, 1, CAST(N'2016-08-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (505, 2, 751, NULL, 2, 3, NULL, 104, N'MACAGNO', N'MAURICIO HERNAN', 29, 39, 1, CAST(N'2016-08-29T00:00:00.000' AS DateTime), NULL, N'')
GO
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (506, 2, 753, NULL, 2, 3, NULL, 330, N'SCHAFINO', N'RODRIGO JAVIER', 28, 65, 1, CAST(N'2016-09-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (507, 2, 772, NULL, 2, 3, NULL, 336, N'POISOT', N'MARIANA SOLEDAD', 28, 65, 1, CAST(N'2016-12-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (508, 2, 783, NULL, 1, 3, NULL, 356, N'CASTRO', N'CINTIA BELEN', 28, 17, 1, CAST(N'2017-02-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (509, 2, 786, NULL, 2, 3, NULL, 340, N'GALLEGUILLO', N'PAUL MATIAS', 28, 17, 1, CAST(N'2017-02-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (510, 2, 792, NULL, 2, 3, NULL, 305, N'FERREIRA MARTINEZ', N'LUCAS DAVID', 28, 65, 1, CAST(N'2017-03-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (511, 2, 794, NULL, 2, 1, 16, NULL, N'NOVOA MANRIQUE', N'JUAN GRAVIEL', 6, 70, 1, CAST(N'2017-03-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (512, 2, 795, NULL, 1, 3, NULL, 318, N'RAVIRU', N'ALEJANDRA MARIEL', 28, 17, 1, CAST(N'2017-03-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (513, 2, 804, NULL, 1, 3, NULL, 344, N'PAGEZ', N'ROMINA MARICEL', 28, 17, 1, CAST(N'2017-05-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (514, 2, 806, NULL, 2, 3, NULL, 301, N'CORIA', N'DAMIAN MARCELO', 28, 65, 1, CAST(N'2017-05-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (515, 2, 819, NULL, 1, 3, NULL, 305, N'ANDRADA', N'SILVANA EUGENIA', 28, 17, 1, CAST(N'2017-07-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (516, 2, 822, NULL, 2, 3, NULL, 342, N'BATTILANA', N'JULIO ALBERTO', 14, 39, 1, CAST(N'2017-07-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (517, 2, 823, NULL, 2, 3, NULL, 342, N'CUTULI', N'LEANDRO AGUSTIN', 28, 65, 1, CAST(N'2017-08-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (518, 2, 827, NULL, 1, 3, NULL, 342, N'VIOLA', N'MONICA NOEMI', 28, 17, 1, CAST(N'2017-08-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (519, 2, 831, NULL, 2, 3, NULL, 342, N'MOLINA', N'EDGARDO ARIEL', 28, 65, 1, CAST(N'2017-09-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (520, 2, 840, NULL, 1, 3, NULL, 340, N'REYES', N'NADIA SOLEDAD', 29, 39, 1, CAST(N'2017-11-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (521, 2, 846, NULL, 2, 3, NULL, 356, N'LEMA ', N'MATIAS NICOLAS', 28, 65, 1, CAST(N'2017-11-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (522, 2, 853, NULL, 2, 3, NULL, 334, N'CASTERAN ', N'FEDERICO SANTIAGO', 28, 65, 1, CAST(N'2017-12-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (523, 2, 855, NULL, 2, 3, NULL, 338, N'ARIAS', N'IGNACIO', 28, 17, 1, CAST(N'2017-12-28T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (524, 2, 860, NULL, 2, 3, NULL, 315, N'LEVIÑANCO', N'RICARDO GONZALO', 28, 65, 1, CAST(N'2018-01-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (525, 2, 868, NULL, 2, 3, NULL, 338, N'PALAVECINO', N'RICARDO JAVIER', 14, 39, 1, CAST(N'2018-01-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (526, 2, 875, NULL, 2, 3, NULL, 338, N'CARTRON', N'LUCAS EZEQUIEL', 28, 65, 1, CAST(N'2018-02-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (527, 2, 881, NULL, 2, 3, NULL, 315, N'CARDOZO', N'RUBEN ALEJANDRO', 28, 65, 1, CAST(N'2018-03-07T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (528, 2, 896, NULL, 2, 3, NULL, 309, N'AGÜERO ', N'JONATHAN LUIS ANDRES', 28, 65, 1, CAST(N'2018-04-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (529, 2, 900, NULL, 2, 3, NULL, 318, N'PEÑA', N'DARIO ROBERTO', 28, 65, 1, CAST(N'2018-04-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (530, 2, 914, NULL, 2, 1, 16, NULL, N'DELGADO JARA', N'JOSE ESTEBAN', 6, 26, 1, CAST(N'2018-07-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (531, 2, 915, NULL, 2, 3, NULL, 354, N'PASTRANA', N'MAXIMILIANO ANDRES', 14, 39, 1, CAST(N'2018-10-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (532, 2, 916, NULL, 2, 3, NULL, 346, N'TOLEDO', N'GONZALO ALBERTO', 14, 39, 1, CAST(N'2018-10-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (533, 2, 918, NULL, 1, 3, NULL, 346, N'GIORGIO', N'YAMILA MAGALI', 28, 64, 1, CAST(N'2018-10-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (534, 2, 924, NULL, 2, 3, NULL, 324, N'CARRIZO', N'ARIEL LEONARDO', 28, 17, 1, CAST(N'2019-01-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (535, 2, 927, NULL, 2, 3, NULL, 305, N'MAYER ', N'FACUNDO HERNAN', 28, 65, 1, CAST(N'2019-03-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (536, 2, 931, NULL, 2, 3, NULL, 324, N'NAVARRETE ', N'GONZALO MATIAS', 28, 65, 1, CAST(N'2019-04-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (537, 2, 932, NULL, 2, 3, NULL, 334, N'ESPEJO', N'YAMIL EZEQUIEL', 28, 65, 1, CAST(N'2019-04-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (538, 2, 935, NULL, 2, 3, NULL, 326, N'YAÑEZ', N'MATIAS GABRIEL', 28, 64, 1, CAST(N'2019-05-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (539, 2, 938, NULL, 2, 3, NULL, 332, N'ACOSTA ', N'DARDO ALEXIS', 28, 17, 1, CAST(N'2019-06-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (540, 2, 939, NULL, 1, 3, NULL, 318, N'AÑAHUAL', N'DAHIANA ISABEL', 14, 39, 1, CAST(N'2019-06-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (541, 2, 947, NULL, 2, 3, NULL, 354, N'GARCIA MOYANO', N'AMILCAR', 28, 71, 1, CAST(N'2019-10-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (542, 2, 957, NULL, 2, 3, NULL, 338, N'BOUHID ', N'AGUSTIN', 28, 65, 1, CAST(N'2020-01-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (543, 2, 958, NULL, 2, 3, NULL, 348, N'MAZA MUSTAFA', N'MAURO LAUTARO', 14, 38, 1, CAST(N'2020-02-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (544, 2, 963, NULL, 2, 3, NULL, 350, N'PARDO', N'DANTE RODRIGO', 28, 65, 1, CAST(N'2020-03-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (545, 2, 964, NULL, 1, 3, NULL, 350, N'NAVARRO ', N'NOELIA SOLEDAD DE JESUS', 28, 64, 1, CAST(N'2020-03-12T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (546, 2, 965, NULL, 1, 3, NULL, 350, N'LOTO', N'EDUARDO RODRIGO', 14, 39, 1, CAST(N'2020-03-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (547, 2, 967, NULL, 2, 3, NULL, 309, N'AREVALO ', N'LEONARDO EZEQUIEL', 28, 65, 1, CAST(N'2021-06-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (548, 2, 969, NULL, 2, 3, NULL, 344, N'FARIAS', N'FERNANDO DANIEL', 28, 65, 1, CAST(N'2020-12-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (549, 2, 970, NULL, 1, 3, NULL, 350, N'QUIROGA ', N'LISA', 28, 65, 1, CAST(N'2021-12-22T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (550, 2, 973, NULL, 1, 3, NULL, 348, N'MALDONADO', N'ANDREA SOLEDAD', 28, 65, 1, CAST(N'2021-01-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (551, 2, 974, NULL, 2, 3, NULL, 344, N'SLIMMENS', N'ADRIAN RICARDO', 28, 65, 1, CAST(N'2021-01-20T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (552, 2, 975, NULL, 1, 1, 16, NULL, N'CRUZ', N'PATRICIA LILIANA', 17, 58, 1, CAST(N'2021-04-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (553, 2, 976, NULL, 2, 3, NULL, 315, N'RIVAS', N'MATIAS MARTIN', 28, 65, 1, CAST(N'2021-04-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (554, 2, 977, NULL, 2, 3, NULL, 309, N'VALLEJOS', N'EMILIANO DANIEL', 28, 64, 1, CAST(N'2021-06-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (555, 2, 978, NULL, 2, 3, NULL, 336, N'CROSSA', N'VALENTINO', 28, 65, 1, CAST(N'2022-01-05T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (556, 2, 979, NULL, 2, 3, NULL, 354, N'ABDALLAH', N'ROBERTO RICARDO', 28, 65, 1, CAST(N'2021-07-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (557, 2, 980, NULL, 2, 3, NULL, 318, N'CAÑUMIL', N'RODRIGO DANIEL', 28, 65, 1, CAST(N'2022-01-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (558, 2, 981, NULL, 1, 3, NULL, 354, N'GAUNA DURAND', N'VANINA', 28, 65, 1, CAST(N'2021-07-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (559, 2, 984, NULL, 2, 3, NULL, 313, N'AREBALO ', N'AGUSTIN GONZALO', 14, 39, 1, CAST(N'2021-08-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (560, 2, 985, NULL, 2, 3, NULL, 313, N'RODRIGUEZ SANDOVAL', N'TOMAS EZEQUIEL', 28, 65, 1, CAST(N'2021-08-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (561, 2, 988, NULL, 2, 1, 16, NULL, N'TORRES SANCHEZ', N'DIEGO RAUL', 5, 26, 1, CAST(N'2021-08-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (562, 2, 989, NULL, 2, 1, 16, NULL, N'ALMIRON', N'ESTEBAN DARIO', 5, 26, 1, CAST(N'2021-08-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (563, 2, 990, NULL, 1, 3, NULL, 340, N'BURNEO', N'ROCIO ANAHI', 28, 65, 1, CAST(N'2022-01-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (564, 2, 992, NULL, 2, 3, NULL, 301, N'OLIVERO', N'HERNÁN MATÍAS', 28, 65, 1, CAST(N'2021-11-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (565, 2, 994, NULL, 2, 1, 16, NULL, N'DE ANGELIS', N'CLAUDIO OMAR', 5, 26, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (566, 2, 995, NULL, 1, 3, NULL, 313, N'MAMONDE ', N'ADRIANA PATRICIA', 28, 64, 1, CAST(N'2021-11-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (567, 2, 996, NULL, 2, 3, NULL, 313, N'MUSLERA CORREA', N'EDGAR JONATAN', 28, 65, 1, CAST(N'2021-12-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (568, 2, 998, NULL, 2, 3, NULL, 104, N'BERNAL ', N'JOSE TOMAS', 28, 65, 1, CAST(N'2021-12-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (569, 2, 999, NULL, 2, 3, NULL, 356, N'BUSTAMANTE', N'CRISTIAN DARIO', 28, 65, 1, CAST(N'2021-12-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (570, 2, 1000, NULL, 2, 3, NULL, 315, N'LEVIÑANCO', N'PABLO SEBASTIAN', 28, 65, 1, CAST(N'2021-12-06T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (571, 2, 1002, NULL, 2, 3, NULL, 332, N'MARTIN ', N'MANUEL   ', 28, 64, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (572, 2, 1003, NULL, 1, 3, NULL, 305, N'MARTINEZ ', N'AYELEN PAOLA', 28, 65, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (573, 2, 1004, NULL, 2, 1, 16, NULL, N'SANCHEZ  ', N'GONZALO JOAQUIN', 5, 26, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (574, 2, 1005, NULL, 2, 1, 16, NULL, N'PANDO BALAZAR', N'NICOLAS ANDRE', 5, 26, 1, CAST(N'2021-12-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (575, 2, 1010, NULL, 1, 3, NULL, 344, N'JORGENSEN', N'ANALIA LUJAN', 28, 64, 1, CAST(N'2021-12-23T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (576, 2, 1012, NULL, 2, 3, NULL, 340, N'GUTIERREZ', N'ABIGAIL DEL VALLE', 28, 65, 1, CAST(N'2022-01-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (577, 2, 1013, NULL, 2, 3, NULL, 313, N'FIORE ', N'MATIAS', 28, 65, 1, CAST(N'2022-01-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (578, 2, 1014, NULL, 1, 3, NULL, 324, N'GUTIERREZ', N'DANIELA FERNANDA', 28, 65, 1, CAST(N'2022-01-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (579, 2, 1015, NULL, 2, 3, NULL, 334, N'TORO', N'CRISTIAN EMANUEL', 28, 65, 1, CAST(N'2022-01-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (580, 2, 1016, NULL, 1, 3, NULL, 326, N'RIQUELME', N'MARIA ALEJANDRA', 28, 65, 1, CAST(N'2022-01-21T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (581, 2, 1020, NULL, 2, 1, 16, NULL, N'VARGAS RODRIGUEZ', N'BRYAN STEVENS', 5, 26, 1, CAST(N'2022-03-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (582, 2, 1021, NULL, 2, 1, 16, NULL, N'GAUNA ', N'BRIAN ALEXIS', 5, 26, 1, CAST(N'2022-03-29T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (583, 2, 1022, NULL, 1, 3, NULL, 330, N'ECHEVARRIA', N'GABIELA ROSA', 28, 64, 1, CAST(N'2022-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (584, 2, 1023, NULL, 1, 3, NULL, 348, N'GOMEZ ARMOA', N'DANIELA ROMINA', 28, 64, 1, CAST(N'2022-04-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (585, 2, 1024, NULL, 1, 3, NULL, 332, N'RODRIGUEZ', N'MARIA BELEN', 28, 65, 1, CAST(N'2022-04-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (586, 2, 1025, NULL, 1, 3, NULL, 324, N'MARTINEZ ', N'ARIADNA CECILIA', 28, 64, 1, CAST(N'2022-04-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (587, 2, 1026, NULL, 2, 2, 31, NULL, N'AMOROS', N'MAURO NESTOR', 3, 9, 1, CAST(N'2022-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (588, 2, 1027, NULL, 2, 3, NULL, 342, N'PALACIOS', N'JOEL MARTIN', 28, 65, 1, CAST(N'2022-05-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (589, 2, 1028, NULL, 2, 3, NULL, 324, N'CARRIZO', N'MIGUEL ALBERTO', 28, 65, 1, CAST(N'2022-05-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (590, 2, 1029, NULL, 2, 3, NULL, 344, N'ORELLANA', N'VICTOR RAFAEL', 28, 65, 1, CAST(N'2022-05-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (591, 2, 1030, NULL, 2, 3, NULL, 301, N'SLUYS', N'JOSUE', 28, 65, 1, CAST(N'2022-05-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (592, 2, 2301, NULL, 2, 1, 16, NULL, N'BENITEZ', N'JOSE LUIS', 6, 26, 1, CAST(N'2003-06-30T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (593, 2, 2558, NULL, 1, 1, 16, NULL, N'TOLABA', N'PAULA RAQUEL', 1, 9, 1, CAST(N'2004-11-16T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (594, 2, 2688, NULL, 2, 1, 16, NULL, N'SANCHEZ ALPAS', N'ALEXANDER JUAN', 2, 73, 1, CAST(N'2005-07-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (595, 2, 2891, NULL, 2, 1, 16, NULL, N'DOMINGUEZ', N'RICARDO DIEGO', 2, 73, 1, CAST(N'2007-05-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (596, 2, 3043, NULL, 2, 1, 16, NULL, N'LOZA', N'EDUARDO ALEJANDRO', 3, 72, 1, CAST(N'2008-01-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (597, 2, 3096, NULL, 2, 1, 16, NULL, N'PALOMINO RIVAS', N'ALCIDES MARCELINO', 6, 26, 1, CAST(N'2008-03-25T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (598, 2, 3270, NULL, 2, 1, 16, NULL, N'FIPPI', N'ROMULO EDGARDO', 6, 26, 1, CAST(N'2010-01-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (599, 2, 3281, NULL, 2, 1, 16, NULL, N'JURADO CHOQUE', N'MANUEL WILFREDO', 6, 26, 1, CAST(N'2010-02-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (600, 2, 3286, NULL, 2, 1, 16, NULL, N'MOLINA', N'EUGENIO CESAR', 6, 26, 1, CAST(N'2010-02-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (601, 2, 3375, NULL, 2, 1, 16, NULL, N'GALAN ROJAS', N'JUAN ANTONIO', 6, 26, 1, CAST(N'2010-07-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (602, 2, 3457, NULL, 2, 1, 16, NULL, N'SALINAS', N'CARLOS MARIA', 6, 70, 1, CAST(N'2010-11-03T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (603, 2, 3556, NULL, 1, 1, 16, NULL, N'JARA ITURBE', N'MARIA LUISA', 3, 72, 1, CAST(N'2011-04-18T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (604, 2, 3986, NULL, 2, 1, 16, NULL, N'BAQUEL', N'EMMANUEL ALEJANDRO', 6, 26, 1, CAST(N'2014-07-10T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (605, 2, 4037, NULL, 2, 1, 16, NULL, N'VILLCA', N'RAUL ALBERTO', 6, 46, 1, CAST(N'2015-03-10T00:00:00.000' AS DateTime), NULL, N'')
GO
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (606, 2, 4254, NULL, 2, 1, 16, NULL, N'PINTOS ', N'MATIAS FACUNDO', 6, 26, 1, CAST(N'2016-06-08T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (607, 3, 41, NULL, 2, 1, 16, NULL, N'URIBE MONTEVERDE', N'ROBERTO CARLOS', 3, 39, 1, CAST(N'2010-08-26T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (608, 3, 48, NULL, 2, 1, 16, NULL, N'SALAZAR', N'ANGEL RICARDO', 6, 62, 1, CAST(N'2014-10-01T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (609, 3, 57, NULL, 2, 1, 16, NULL, N'REIJERES ALVARADO', N'MICHAEL GASTON', 5, 62, 1, CAST(N'2019-05-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (610, 3, 58, NULL, 2, 1, 16, NULL, N'CHAVEZ ', N'NICOLAS ADRIAN', 5, 62, 1, CAST(N'2019-10-17T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (611, 3, 60, NULL, 2, 1, 16, NULL, N'DOMINGOS', N'PAPILSON ANTONIO', 5, 62, 1, CAST(N'2021-08-02T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (612, 4, 69, NULL, 2, 3, NULL, 504, N'AGÜERO', N'SERGIO RAMIRO', 14, 38, 1, CAST(N'2012-11-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (613, 4, 90, NULL, 2, 3, NULL, 504, N'VIVAR PAREDES', N'JUAN CARLOS', 28, 17, 1, CAST(N'2013-05-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (614, 4, 124, NULL, 2, 3, NULL, 506, N'GALLEGOS', N'KEVIN FERNANDO', 14, 38, 1, CAST(N'2014-12-24T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (615, 4, 128, NULL, 2, 3, NULL, 501, N'ALVAREZ FONTI', N'NICOLAS EMILIANO', 14, 38, 1, CAST(N'2015-04-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (616, 4, 162, NULL, 2, 3, NULL, 501, N'MACHADO ', N'PABLO DANIEL', 28, 65, 1, CAST(N'2020-06-04T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (617, 4, 163, NULL, 1, 3, NULL, 501, N'FERRARI', N'CAMILA', 28, 65, 1, CAST(N'2021-12-27T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (618, 4, 164, NULL, 2, 3, NULL, 501, N'DIAZ', N'LUCAS FERNANDO', 28, 65, 1, CAST(N'2020-12-19T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (619, 4, 1816, NULL, 2, 2, 37, NULL, N'SALAZAR', N'LUIS ABEL', 8, 31, 1, CAST(N'2021-01-11T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (620, 4, 166, NULL, 2, 3, NULL, 504, N'SANCHEZ PEDROZO', N'JORGE ANDRES', 28, 64, 1, CAST(N'2021-06-09T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (621, 4, 169, NULL, 2, 3, NULL, 506, N'AUSELLO', N'ANDRES', 28, 64, 1, CAST(N'2021-11-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (622, 4, 171, NULL, 2, 3, NULL, 501, N'RIOS ', N'GUSTAVO JAVIER', 28, 65, 1, CAST(N'2021-11-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (623, 4, 172, NULL, 1, 3, NULL, 506, N'CARO', N'ANDREA BELEN', 28, 65, 1, CAST(N'2021-11-15T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (624, 4, 173, NULL, 2, 3, NULL, 504, N'AGUERO ', N'HECTOR NICOLAS', 28, 65, 1, CAST(N'2021-12-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (625, 4, 175, NULL, 2, 3, NULL, 506, N'DI CESARE', N'EDUARDO EMANUEL', 28, 65, 1, CAST(N'2022-01-14T00:00:00.000' AS DateTime), NULL, N'')
INSERT [dbo].[legajo] ([id], [empresa_id], [nro_legajo], [dni], [genero_id], [ubicacion_id], [sector_id], [local_id], [apellido], [nombre], [categoria_id], [funcion_id], [activo], [fecha_alta], [fecha_baja], [observacion]) VALUES (626, 4, 176, NULL, 2, 3, NULL, 501, N'CABEZAS', N'FABRIZIO FRANCO', 28, 65, 1, CAST(N'2022-02-11T00:00:00.000' AS DateTime), NULL, N'')
SET IDENTITY_INSERT [dbo].[legajo] OFF
GO
SET IDENTITY_INSERT [dbo].[novedad] ON 

INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (7, 173, 2, 1, 2, 6, NULL, 7, N'TESTING', NULL, CAST(N'2022-06-07T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-07T11:47:03.530' AS DateTime), NULL, 4, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (10, 348, 1, NULL, 1, 1, 1, 6, N'Dia 19/04/22 se observa nichos hidrantes y matafuegos obstruidos', NULL, CAST(N'2022-03-10T00:00:00.000' AS DateTime), CAST(N'2022-03-15T00:00:00.000' AS DateTime), CAST(N'2022-06-08T15:15:01.490' AS DateTime), NULL, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (11, 431, 1, NULL, 1, 1, 2, 6, N'Ausencia sin aviso ni justificacion el día 27/04/2022', NULL, CAST(N'2022-04-19T00:00:00.000' AS DateTime), CAST(N'2022-04-22T00:00:00.000' AS DateTime), CAST(N'2022-06-08T15:15:36.443' AS DateTime), NULL, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (12, 236, 3, NULL, 1, 2, 3, 7, N'Murillo no dio aviso que salieron piezas mal cortadas por el robot de corte(el es operario del robot de corte)', NULL, CAST(N'2022-04-21T00:00:00.000' AS DateTime), CAST(N'2022-04-21T00:00:00.000' AS DateTime), CAST(N'2022-06-08T15:15:36.490' AS DateTime), NULL, 14, 104)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (13, 69, 3, 1, 1, 3, 4, 6, N'Realiza apertura con 15 min. Demora', 1, CAST(N'2022-04-25T00:00:00.000' AS DateTime), CAST(N'2022-04-29T00:00:00.000' AS DateTime), CAST(N'2022-06-08T15:15:36.543' AS DateTime), NULL, 14, 107)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (14, 176, 3, 2, 1, 3, 3, 9, N'Falta de puntualidad 22/04/22- 07 min', NULL, CAST(N'2022-04-29T00:00:00.000' AS DateTime), CAST(N'2022-04-29T00:00:00.000' AS DateTime), CAST(N'2022-06-08T15:15:36.583' AS DateTime), NULL, 14, 109)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (15, 69, 3, 1, 1, 2, 3, 6, N'Tema a mejorar:  revision  de calzados antes de facturar', NULL, CAST(N'2022-05-24T00:00:00.000' AS DateTime), CAST(N'2022-05-24T00:00:00.000' AS DateTime), CAST(N'2022-06-08T15:15:36.743' AS DateTime), NULL, 14, 107)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (16, 69, 3, 1, 2, 7, NULL, 7, N'Felicitacion de cliente por buena atencion…', NULL, CAST(N'2022-05-24T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-08T15:15:36.813' AS DateTime), NULL, 14, 107)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (18, 19, 2, NULL, 2, 7, NULL, NULL, N'Test', NULL, CAST(N'2022-06-10T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-10T16:56:00.697' AS DateTime), 43, 3, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (19, 19, 2, 1, 1, 5, 6, NULL, N'Test2', NULL, CAST(N'2022-06-10T00:00:00.000' AS DateTime), CAST(N'2022-06-10T00:00:00.000' AS DateTime), CAST(N'2022-06-10T16:03:36.830' AS DateTime), 43, 3, 0)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (20, 69, 3, 1, 1, 3, NULL, NULL, N'Test2', NULL, CAST(N'2022-06-10T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-10T16:31:04.200' AS DateTime), NULL, 3, 121)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (21, 150, 2, 2, 2, 7, NULL, NULL, N'ssadsa', NULL, CAST(N'2022-06-13T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-13T11:59:34.730' AS DateTime), 43, 3, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (24, 19, 2, 1, 1, 6, 5, 5, N'test', NULL, CAST(N'2022-06-16T00:00:00.000' AS DateTime), CAST(N'2022-06-16T00:00:00.000' AS DateTime), CAST(N'2022-06-16T11:35:03.380' AS DateTime), 43, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (25, 173, 2, 1, 2, 2, NULL, 10, N'Prueba flor', NULL, CAST(N'2022-06-16T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-16T11:38:02.430' AS DateTime), 43, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (26, 19, 2, NULL, 1, 5, 4, 4, N'.', 5, CAST(N'2022-06-21T00:00:00.000' AS DateTime), CAST(N'2022-06-21T00:00:00.000' AS DateTime), CAST(N'2022-06-21T16:44:46.093' AS DateTime), 43, 2, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (29, 19, 3, NULL, 2, 3, NULL, 7, N'jjj', NULL, CAST(N'2022-06-22T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-22T10:32:02.033' AS DateTime), NULL, 4, 344)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (30, 41, 2, 2, 1, 1, 5, 8, N'No realizo seguimiento obra social domesticas', NULL, CAST(N'2022-06-22T00:00:00.000' AS DateTime), CAST(N'2022-06-22T00:00:00.000' AS DateTime), CAST(N'2022-06-22T12:03:17.513' AS DateTime), 42, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (32, 69, 3, 1, 2, 1, 4, 5, N'falta puntualidad dia 21/06', 1, CAST(N'2022-06-22T00:00:00.000' AS DateTime), CAST(N'2022-06-23T00:00:00.000' AS DateTime), CAST(N'2022-06-23T10:47:38.040' AS DateTime), NULL, 16, 121)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (33, 41, 2, 5, 2, 2, NULL, 9, N'aflaldf df aldfkj la dfdkljas df v', NULL, CAST(N'2022-06-22T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-22T12:42:12.877' AS DateTime), 42, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (34, 41, 2, 5, 1, 1, 4, 8, N'falta puntualidad 22/6', 1, CAST(N'2022-06-22T00:00:00.000' AS DateTime), CAST(N'2022-06-23T00:00:00.000' AS DateTime), CAST(N'2022-06-22T12:43:40.390' AS DateTime), 42, 14, NULL)
INSERT [dbo].[novedad] ([id], [legajo_id], [ubicacion_id], [responsable_id], [categoria_novedad_id], [tipo_novedad_id], [tipo_resolucion_id], [concepto], [observacion], [dias], [fecha_novedad], [fecha_resolucion], [fecha_alta], [sector_id], [usuario_id], [local_id]) VALUES (35, 41, 2, NULL, 1, 1, NULL, NULL, N'a afad a ag f gdasf g', NULL, CAST(N'2022-06-23T00:00:00.000' AS DateTime), NULL, CAST(N'2022-06-23T11:06:43.140' AS DateTime), 42, 17, NULL)
SET IDENTITY_INSERT [dbo].[novedad] OFF
GO
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (1, N'Sistemas')
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (2, N'Admistrador RRHH')
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (3, N'Empleado RRHH')
INSERT [dbo].[perfil] ([id], [descripcion]) VALUES (4, N'Consulta')
GO
SET IDENTITY_INSERT [dbo].[responsable] ON 

INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (1, N'Cossettini', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (2, N'Galletti', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (3, N'Perilli', NULL)
INSERT [dbo].[responsable] ([id], [apellido], [nombre]) VALUES (5, N'F', N'Gustavo')
SET IDENTITY_INSERT [dbo].[responsable] OFF
GO
SET IDENTITY_INSERT [dbo].[sector] ON 

INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (1, N'Costura 1', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (2, N'Costura 2', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (3, N'Costura 3', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (4, N'Costura 4', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (5, N'Costura 5 / Ojal y botón', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (6, N'Costura 6', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (7, N'Costura 7', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (8, N'Compaginado', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (9, N'Corte', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (10, N'Bordado', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (11, N'Revisado', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (12, N'Estampado', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (13, N'Transfer', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (14, N'Avíos', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (15, N'Broche', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (16, N'Telas', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (17, N'Avio/Broche', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (18, N'Maestranza', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (19, N'Mantenimiento', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (20, N'Chofer', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (21, N'Cost.Externo', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (22, N'Reparaciones', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (23, N'Seguridad', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (24, N'Taller Externo', 1)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (25, N'Director', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (26, N'Maestranza', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (27, N'Mantenimiento', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (28, N'Adm-Admint', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (29, N'Adm-Com.Ext.', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (30, N'Adm-Comercial', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (31, N'Adm-Cont', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (32, N'Adm-Dis.Grafico', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (33, N'Adm-Dis.Web', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (34, N'Adm-Diseño.I.', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (35, N'Adm-Diseño.P.', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (36, N'Adm-Ecommerce', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (37, N'Administ.', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (38, N'Adm-Legales', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (39, N'Adm-Marketing', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (40, N'Adm-Presid', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (41, N'Adm-Producc', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (42, N'Adm-Rrhh', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (43, N'Adm-Sistemas', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (44, N'Adm-Vtas.', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (45, N'Adm-Vtas.Corp', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (46, N'Adm-Vtas.Mayor', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (47, N'Adm-Vtas.Telef', 2)
INSERT [dbo].[sector] ([id], [descripcion], [ubicacion_id]) VALUES (48, N'Asist. Adm.', 2)
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
INSERT [dbo].[tipo_novedad] ([id], [descripcion]) VALUES (8, N'Prueba')
SET IDENTITY_INSERT [dbo].[tipo_novedad] OFF
GO
SET IDENTITY_INSERT [dbo].[tipo_resolucion] ON 

INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (1, N'Notificación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (2, N'Amonestación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (3, N'Capacitación')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (4, N'Suspensión')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (5, N'Archivo')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (6, N'Apercibimiento')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (7, N'Nada')
INSERT [dbo].[tipo_resolucion] ([id], [descripcion]) VALUES (8, N'Prueba')
SET IDENTITY_INSERT [dbo].[tipo_resolucion] OFF
GO
SET IDENTITY_INSERT [dbo].[ubicacion] ON 

INSERT [dbo].[ubicacion] ([id], [descripcion]) VALUES (1, N'FABRICA')
INSERT [dbo].[ubicacion] ([id], [descripcion]) VALUES (2, N'EDIFICIO')
INSERT [dbo].[ubicacion] ([id], [descripcion]) VALUES (3, N'LOCAL')
SET IDENTITY_INSERT [dbo].[ubicacion] OFF
GO
SET IDENTITY_INSERT [dbo].[usuario] ON 

INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (2, N'AGORAL', N'$2a$11$zuLDamkC94Bc7sUwcjhHBesVXQ7IYlYnsLpVIFM36plHQp7zLJrS2', N'Goral', N'Alejandro', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (3, N'AFABIAN', N'$2a$11$721HZiAYh8gAr6KgKn9mj.kgSlIQl31r2J1DaIkTFolSFFMmAoBVG', N'Fabian', N'Ariel', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (4, N'FARDANAZ', N'$2a$11$xtBSMYVhXrtv6.g7LCJxbu./EYa6MzSK0UB1lZkBA9R23MN3AkXea', N'Ardanaz', N'Florencia', 1)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (14, N'GFERNANDEZ', N'$2a$11$iJi7/ZxAcUK5Ec/Yhv6VSOEyjJJG1kXqPPW0RXFihJYBHJ1EonLuC', N'Fernandez', N'Gustavo', 2)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (16, N'SUPERVISOR', N'$2a$11$OeNOWeAHpltXtJD5I7sk2uzA1PNdPbGVnIFw7A3lZvjz3ME6N3FFu', N'Supervisores', N'Supervisores', 4)
INSERT [dbo].[usuario] ([id], [UsuarioID], [clave], [apellido], [nombre], [perfil_id]) VALUES (17, N'PCASTILLO', N'$2a$11$av78Lx18AbDWBUqIO9Aic.2TYVrFLt63RKxR1j573LLQMX39r/BgS', N'Castillo', N'Pedro', 3)
SET IDENTITY_INSERT [dbo].[usuario] OFF
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
/****** Object:  StoredProcedure [dbo].[sp_lectores_abm]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lectores_abm]
	@i_accion varchar(4),
	@io_ltr_id int OUTPUT,
	@i_ltr_descripcion varchar(100),
	@i_ltr_ip varchar(100),
	@i_ltr_nro_equipo int,
	@i_ltr_ult_fecha_actualizacion datetime,
	@i_em_id int,
	@o_rv int OUTPUT
AS 
if @i_accion = 'A' 
		BEGIN

			INSERT INTO [dbo].[lectores]
				(
					[ltr_descripcion],
					[ltr_ip],				
					[ltr_nro_equipo],
					[ltr_ult_fecha_actualizacion],
					[em_id]
				)
			VALUES
				(
					@i_ltr_descripcion,
					@i_ltr_ip,				
					@i_ltr_nro_equipo,
					@i_ltr_ult_fecha_actualizacion,
					@i_em_id
				)



			set @io_ltr_id = @@IDENTITY 
		END
	else if @i_accion = 'B' 
		BEGIN
			DELETE FROM [dbo].[lectores]		  
			WHERE [ltr_id] = @io_ltr_id

			set @o_rv = @@ROWCOUNT 
		END

	-- ----////
	else if @i_accion = 'M' 
		BEGIN
			UPDATE [dbo].[lectores]
			SET 
					[ltr_descripcion] = @i_ltr_descripcion,
					[ltr_ip] = @i_ltr_ip,
					[ltr_nro_equipo] = @i_ltr_nro_equipo,
					[ltr_ult_fecha_actualizacion]=@i_ltr_ult_fecha_actualizacion,
					[em_id] = @i_em_id
			WHERE [ltr_id] = @io_ltr_id

			set @o_rv = @@ROWCOUNT 
		END

	-- ----////
	else if @i_accion = 'ME1' 
		BEGIN
			UPDATE [dbo].[lectores]
			SET 
				[ltr_ult_fecha_actualizacion]=@i_ltr_ult_fecha_actualizacion	
			WHERE [ltr_nro_equipo] = @i_ltr_nro_equipo

			set @o_rv = @@ROWCOUNT 
		END

	-- ----////

GO
/****** Object:  StoredProcedure [dbo].[sp_lectores_get]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lectores_get]
@i_ltr_id int,
@i_ltr_nro_equipo int
AS 
SELECT * from lectores rhlec
where 
(
	(
		ISNULL(@i_ltr_id, 0)<>0
		and
		rhlec.ltr_id = @i_ltr_id
	)
	or
	ISNULL(@i_ltr_id,0 )=0
) AND 
(
	(
		ISNULL(@i_ltr_nro_equipo, 0)<>0
		and
		rhlec.ltr_nro_equipo = @i_ltr_nro_equipo
	)
	or
	ISNULL(@i_ltr_nro_equipo,0 )=0
) 

GO
/****** Object:  StoredProcedure [dbo].[sp_rrhh_control_ayp_get]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- drop procedure sp_rrhh_control_ayp_get

create PROCEDURE [dbo].[sp_rrhh_control_ayp_get]
@i_emp_nro_legajo int,
@i_periodo date,
@i_contbtemp bit
AS 
BEGIN	
  	declare @ce_nomenclatura varchar(3) 
  	declare @ce_us_id varchar(20) 
  	declare @ce_fchhr_ini datetime
  	declare @ce_fchhr_fin datetime
  	declare @ce_precert bit
  	declare @ce_reqcert bit
  	declare @ce_hora_ini time 
  	declare @ce_hora_fin time 
  	declare @w_inserto bit 
  	declare @w_ci_Ehs time 
  	declare @w_ci_Shs time 
  	declare @w_emp_nro_legajo int
  	declare @w1 int 
  	declare @finidia date 
 	declare @ffindia date 
  	declare @pos int 
  	declare @v_EsConAlt bit
 	declare @v_EsConHOff bit
  	declare @v_fechainialt date 
  	declare @v_suc varchar(45)
  	declare @v_are varchar(45)
    -- -----------------------
	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '##rrhh_tbtmp_control_inicial_detodoslos_usuarios%') 
	BEGIN
	   DROP TABLE ##rrhh_tbtmp_control_inicial_detodoslos_usuarios
	end
	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios%') 
	BEGIN
	   DROP TABLE ##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios 
	END
/*	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '##rrhh_tbtmp_control%') 
	BEGIN
	   DROP TABLE ##rrhh_tbtmp_control 
	END*/
	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados%') 
	BEGIN
	   DROP TABLE ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados 
	END
	-- -----------------------
 	create table ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
	(
	    ci_nro_legajo int,
	    ci_dia int,
	    ci_fecha date,
	    ci_he time,
	    ci_hs time,
	    ci_Ehs time,
	    ci_Shs time,
	    ci_catIE varchar (3),
	    ci_catIS varchar (3),
	    ci_catIF varchar (3),
	    ci_tienesoloexp bit default 0,
	    ci_EsFeriado bit default 0,
	    ci_precert bit default 0
  	)
  	-- ----------------------- 		
/* 	create table ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados
	(
	    emp_nro_legajo int,
	    ehth_dia int,
	    th_hora_inc time,
	    th_hora_fin time,
	    ehth_alternancia bit default 0,
	    ehth_fecha_inicio date
  	) */ 	
	-- ----------------------- 	
	select 
	    e.nro_legajo,
	    ehtdh.ehth_dia ,
	    tdh.th_hora_inc ,
	    tdh.th_hora_fin ,
	    ehtdh.ehth_alternancia ,
	    ehtdh.ehth_fecha_inicio
	 INTO ##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios
	  from
	    legajos_has_tipos_de_horarios ehtdh  
	    inner join tipos_de_horarios tdh 
	      on ehtdh.th_id  = tdh.th_id 
	    inner join legajo e 
	      on ehtdh.emp_id = e.id 
	  where 
	     ehtdh.ehth_fecha_inicio  = 
	    (
	    
		    select 
		      max(ehtdh1.ehth_fecha_inicio) 
		    from
		      legajos_has_tipos_de_horarios ehtdh1  
		    where cast(
		        ehtdh1.ehth_fecha_inicio  as date
		      ) < cast(
		        dbo.udf_PrimerDia(month(@i_periodo), year(@i_periodo)) as date
		      ) 
		      and ehtdh1.emp_id  = ehtdh.emp_id 
		      and ehtdh1.ehth_dia  = ehtdh.ehth_dia
	      
	      ) 
	    and (
	      (
	        e.nro_legajo = @i_emp_nro_legajo 
	        and isnull(@i_emp_nro_legajo , 0) <> 0
	      ) 
	      or isnull(@i_emp_nro_legajo , 0) = 0
	    ) 
	  order by e.nro_legajo, ehtdh.ehth_dia desc
	-- -----------------------
  	-- insert into ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados 
	select 
	    e.nro_legajo ,
	    ehtdh.ehth_dia ,
	    tdh.th_hora_inc ,
	    tdh.th_hora_fin ,
	    ehtdh.ehth_alternancia ,
	    ehtdh.ehth_fecha_inicio,
	    ehtdh.ehth_home_office
	    into ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados 
	  from
	    legajos_has_tipos_de_horarios ehtdh  
	    inner join tipos_de_horarios tdh  
	      on ehtdh.th_id = tdh.th_id 
	    inner join legajo e 
	      on ehtdh.emp_id = e.id 
	  where cast(ehtdh.ehth_fecha_inicio  as date) between cast(
	      dbo.udf_PrimerDia(month(@i_periodo), year(@i_periodo)) as date
	    ) 
	    and cast(
	      dbo.udf_UltimoDia(month(@i_periodo), year(@i_periodo)) as date
	    ) 
	  order by e.nro_legajo , ehtdh.ehth_dia 
  	-- -----------------------
	DECLARE cUs CURSOR FOR  
	select
		e.nro_legajo
	from
		legajo e
	inner join legajos_has_tipos_de_horarios ehtdh  
	      on
		ehtdh.emp_id = e.id
	where
		(
	      (
	        e.nro_legajo = @i_emp_nro_legajo
			and isnull(@i_emp_nro_legajo,0) <> 0
	   )
			or isnull(@i_emp_nro_legajo,0) = 0
	    )
	group by
		e.nro_legajo 
	-- -----------------------
	OPEN cUs 
	FETCH NEXT FROM cUs   
	INTO @w_emp_nro_legajo
	WHILE @@FETCH_STATUS = 0  
	BEGIN
		-- ----------
		/*     
 		'D:1
        'L:2
        'Ma:3
        'M:4
        'J:5
        'V:6
        'S:7
        */
	    set @w1 = 1
	    -- empiezo del lunes(domingo descartado:1)
	    set @w_ci_Ehs = null 
	    set @w_ci_Shs = null 
	   
		WHILE(@w1 <= 7) BEGIN
			-- select @w1
	   		set @finidia = dbo.udf_obtenerelprimerafechadeldiabycoddiayperiodo(@w1, @i_periodo)
	    	set @ffindia = dbo.udf_obtenerelultimofechadeldiabycoddiayperiodo(@w1, @i_periodo)
	     	
	     	WHILE(@finidia <= @ffindia) BEGIN
		     	-- select @finidia
		    	-- ----------
		        select 
		          @w_ci_Ehs = isnull(min(cast(rcf.fcd_fchr  as time)),convert(time,'00:00:00')) 
		        from
		          fichadas rcf   
		        where 
		          -- rcf.taes_id  = 'E' and 
		          rcf.lgj_nro_legajo  = @w_emp_nro_legajo 
		          and cast(rcf.fcd_fchr  as date) = @finidia ;
		         
		        select 
		          @w_ci_Shs = isnull(max(cast(rcf.fcd_fchr  as time)),convert(time,'00:00:00')) 
		        from
		          fichadas rcf   
		        where 
		          -- rcf.taes_id  = 'S' and 
		          rcf.lgj_nro_legajo  = @w_emp_nro_legajo 
		          and cast(rcf.fcd_fchr  as date) = @finidia ;
	        
				if exists (select 1 from ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 where cast(tb1.ehth_fecha_inicio as date) = @finidia and tb1.nro_legajo = @w_emp_nro_legajo 	and tb1.ehth_dia = @w1) begin 
		        	set @v_EsConAlt = 0 
					set @v_fechainialt = null 
					set @v_EsConHOff = 0
					
					select 
					  @v_fechainialt = tb1.ehth_fecha_inicio,
					  @v_EsConAlt  = tb1.ehth_alternancia,
					  @v_EsConHOff = tb1.ehth_home_office
					from
					  ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 
					where cast(tb1.ehth_fecha_inicio as date) = @finidia 
					  and tb1.nro_legajo = @w_emp_nro_legajo 
					  and tb1.ehth_dia = @w1 
					  
					set @w_inserto = 0
					
					if isnull(@v_fechainialt, CAST('1973-01-01' AS DATE)) <> CAST('1973-01-01' AS DATE) begin
						if @v_EsConAlt = 1 begin 
							if dbo.fn_habilitofechasegunalternancia(@v_fechainialt, @finidia)=1 begin 
								set @w_inserto = 1 
							end
							else begin
								set @w_inserto = 0 
							end
						end
						else begin
							set @w_inserto = 1
						end
					end		
					else begin
						set @w_inserto = 0 		
					end 
						
					if @w_inserto = 1 BEGIN
						INSERT INTO ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
						(
					  		ci_nro_legajo, ci_dia, ci_fecha, ci_he, ci_hs, ci_Ehs, ci_Shs, ci_catIE, ci_catIS, ci_catIF
						) 
						select 
					  		@w_emp_nro_legajo, @w1, @finidia, tb1.th_hora_inc, tb1.th_hora_fin, @w_ci_Ehs, @w_ci_Shs, 
					  		dbo.fn_cpa_obtenercategoria('E',tb1.th_hora_inc,@w_ci_Ehs,null,null,@finidia),
					  		dbo.fn_cpa_obtenercategoria('S',tb1.th_hora_fin,@w_ci_Shs,null,null,@finidia),
					  		dbo.fn_cpa_obtenercategoria('F',tb1.th_hora_inc,@w_ci_Ehs,tb1.th_hora_fin,@w_ci_Shs,@finidia) 
						from
						  ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 
						where cast(tb1.ehth_fecha_inicio as date) = @finidia 
						  and tb1.nro_legajo = @w_emp_nro_legajo 
						  and tb1.ehth_dia = @w1	
					END				
					ELSE BEGIN
						insert into ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
						(
					  		ci_nro_legajo, ci_dia, ci_fecha, ci_he, ci_hs, ci_Ehs, ci_Shs, ci_catIE, ci_catIS, ci_catIF
						) 
						select 
					  		@w_emp_nro_legajo, @w1, @finidia, convert(time,'00:00:00'), convert(time,'00:00:00'), @w_ci_Ehs, @w_ci_Shs, 'EC', 'SC', 'HC' 				
					END
				END
		        ELSE BEGIN 
		        	if exists (select 1 from ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 where cast(tb1.ehth_fecha_inicio as date) < @finidia and tb1.nro_legajo = @w_emp_nro_legajo and tb1.ehth_dia = @w1) BEGIN
	      				set @v_EsConAlt = 0 
						set @v_fechainialt = null 
					
						select 
						  @v_fechainialt = tb1.ehth_fecha_inicio,
						  @v_EsConAlt = tb1.ehth_alternancia	   
						from
						  ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 
						where tb1.nro_legajo = @w_emp_nro_legajo 
						  and tb1.ehth_dia = @w1 
						  and tb1.ehth_fecha_inicio = 
						  (select 
						    max(tb1.ehth_fecha_inicio) 
						  from
						    ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 
						  where cast(tb1.ehth_fecha_inicio as date) < @finidia 
						    and tb1.nro_legajo = @w_emp_nro_legajo 
						    and tb1.ehth_dia = @w1)
						
						    
						set @w_inserto = 0 
						 
				 		if ISNULL(@v_fechainialt, CAST('1973-01-01' AS DATE)) <> CAST('1973-01-01' AS DATE) begin			
							if @v_EsConAlt = 1 begin 
								if dbo.fn_habilitofechasegunalternancia(@v_fechainialt, @finidia)=1 begin						
									set @w_inserto = 1 
								end
								else begin
									set @w_inserto = 0 
								end
							end  
							else begin 
								set @w_inserto = 1
							end
						end
						else BEGIN
							set @w_inserto = 0
			        	end 
				        
				        if @w_inserto = 1 begin
							insert into ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
						        (
						  			ci_nro_legajo, ci_dia, ci_fecha, ci_he, ci_hs, ci_Ehs, ci_Shs, ci_catIE, ci_catIS, ci_catIF
								) 
							select 
						  		@w_emp_nro_legajo, @w1, @finidia, tb1.th_hora_inc, tb1.th_hora_fin, @w_ci_Ehs, @w_ci_Shs, 
						  		dbo.fn_cpa_obtenercategoria('E',tb1.th_hora_inc,@w_ci_Ehs,null,null,@finidia),
						  		dbo.fn_cpa_obtenercategoria('S',tb1.th_hora_fin,@w_ci_Shs,null,null,@finidia),
						  		dbo.fn_cpa_obtenercategoria('F',tb1.th_hora_inc,@w_ci_Ehs,tb1.th_hora_fin,@w_ci_Shs,@finidia) 
							from
						  		##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 
							where tb1.nro_legajo = @w_emp_nro_legajo 
						  		and tb1.ehth_dia = @w1 
						  		and tb1.ehth_fecha_inicio = 
						  		(
						  			select 
						    			max(tb1.ehth_fecha_inicio) 
						  			from
						    			##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados tb1 
						  			where cast(tb1.ehth_fecha_inicio as date) < @finidia 
						    			and tb1.nro_legajo = @w_emp_nro_legajo 
						    			and tb1.ehth_dia = @w1
				    			)
			        	end
						else BEGIN						
							insert into ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
								(
								  ci_nro_legajo, ci_dia, ci_fecha, ci_he, ci_hs, ci_Ehs, ci_Shs, ci_catIE, ci_catIS, ci_catIF
								) 
								select 
								  @w_emp_nro_legajo, @w1, @finidia, convert(time,'00:00:00'), convert(time,'00:00:00'), @w_ci_Ehs, @w_ci_Shs, 'EC', 'SC', 'HC'
						END	
					end	
					else begin 
						set @v_EsConAlt = 0 
						set @v_fechainialt = null 
			
						select 
						  @v_fechainialt = tb1.ehth_fecha_inicio,
						  @v_EsConAlt = tb1.ehth_alternancia 				   
						from
						  ##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios tb1 
						where tb1.nro_legajo = @w_emp_nro_legajo 
						  and tb1.ehth_dia = @w1 
					
						set @w_inserto = 0 
					
						if isnull(@v_fechainialt, CAST('1973-01-01' AS DATE)) <> CAST('1973-01-01' AS DATE) begin -- if not v_fechainialt is null then						
							if @v_EsConAlt = 1 begin
								if dbo.fn_habilitofechasegunalternancia(@v_fechainialt, @finidia) =1 begin 
									set @w_inserto = 1 
								end	
								else begin 
									set @w_inserto = 0 						
								end
							end	
							else begin
								set @w_inserto = 1 
							end	
						end	
						else begin 
							set @w_inserto = 0 							
						end
					
						if @w_inserto = 1 BEGIN
							insert into ##rrhh_tbtmp_control_inicial_detodoslos_usuarios (
							  ci_nro_legajo,  ci_dia, ci_fecha, ci_he, ci_hs, ci_Ehs, ci_Shs,  ci_catIE, ci_catIS, ci_catIF
							) 
							select 
								@w_emp_nro_legajo, @w1, @finidia, tb1.th_hora_inc, tb1.th_hora_fin, @w_ci_Ehs, @w_ci_Shs, 
								dbo.fn_cpa_obtenercategoria('E',tb1.th_hora_inc,@w_ci_Ehs,null,null,@finidia),
							  	dbo.fn_cpa_obtenercategoria('S',tb1.th_hora_fin,@w_ci_Shs,null,null,@finidia),
							  	dbo.fn_cpa_obtenercategoria('F',tb1.th_hora_inc,@w_ci_Ehs,tb1.th_hora_fin,@w_ci_Shs,@finidia) 
							from
								##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios tb1 
							where tb1.nro_legajo = @w_emp_nro_legajo 
								and tb1.ehth_dia = @w1
						end
						else begin						
							insert into ##rrhh_tbtmp_control_inicial_detodoslos_usuarios (
							  ci_nro_legajo, ci_dia, ci_fecha, ci_he, ci_hs, ci_Ehs, ci_Shs, ci_catIE, ci_catIS, ci_catIF
							) 
							select 
							  	@w_emp_nro_legajo, @w1, @finidia, convert(time,'00:00:00'), convert(time,'00:00:00'), @w_ci_Ehs, @w_ci_Shs, 'EC', 'SC', 'HC' 
		
						END
					END
	          	END
	          	-- ----------
      		    set @w_ci_Ehs = null 
		    	set @w_ci_Shs = null 
		    	set @finidia = dateadd(day,7,@finidia)
			END
			-- ----------
			set @w1 = @w1 + 1 
	 	END 
		-- ----------
		FETCH NEXT FROM cUs   
		INTO @w_emp_nro_legajo
	END   
	CLOSE cUs;  
	DEALLOCATE cUs;  
	-- -----------------------
	/*DECLARE cSE cursor for 	
		select 
		    rcc.cpacat_nomenclatura ,
		    e.emp_nro_legajo ,
		    rcs.cpasol_fecha_inicio ,
		    rcs.cpasol_fecha_final ,
		    rcs.cpasol_presento_certificado ,
		   	tdh.th_hora_inc ,
		    tdh.th_hora_fin  
		  from
		    rrhh_cpa_solicitudes rcs  
		    inner join cpa_categorias rcc  
		      on (
		        rcc.cpacat_id  = rcs.cpacat_id 
		      ) 
		    left join tipos_de_horarios tdh  
		      on (
		        tdh.th_id = rcs.th_id 
		      ) 
		    inner join legajo e  
		      on (
		        rcs.emp_id = e.emp_id 
		      ) 
		  where 
		    (
		      (
		        cast(
		          rcs.cpasol_fecha_inicio  as date
		        ) >= dbo.udf_PrimerDia(month(@i_periodo), year(@i_periodo)) 
		        and cast(
		          rcs.cpasol_fecha_final  as date
		        ) <= dbo.udf_UltimoDia(month(@i_periodo), year(@i_periodo))
		      ) 
		      or (
		        cast(
		          rcs.cpasol_fecha_inicio as date
		        ) >= dbo.udf_PrimerDia(month(@i_periodo), year(@i_periodo)) 
		        and cast(
		          rcs.cpasol_fecha_inicio as date
		        ) <= dbo.udf_UltimoDia(month(@i_periodo), year(@i_periodo))
		      ) 
		      or (
		        cast(
		          rcs.cpasol_fecha_final as date
		        ) >= dbo.udf_PrimerDia(month(@i_periodo), year(@i_periodo)) 
		        and cast(
		          rcs.cpasol_fecha_final as date
		        ) <= dbo.udf_UltimoDia(month(@i_periodo), year(@i_periodo))
		      )
		    ) 
		    and (
		      (
		        rcs.cpasoles_id  = 4 
		        and rcc.cpacat_aprobacionrequerida  = 'R'
		      ) 
		      or (
		        rcs.cpasoles_id = 4 
		        and rcc.cpacat_aprobacionrequerida = 'SR'
		      ) 
		      or (
		        rcs.cpasoles_id = 3 
		        and rcc.cpacat_aprobacionrequerida = 'S'
		      )
		    ) 
	-- ----------------------- 

  	OPEN cSE 	
	FETCH NEXT FROM cSE   
	INTO @ce_nomenclatura, @ce_us_id, @ce_fchhr_ini, @ce_fchhr_fin, @ce_precert, @ce_hora_ini, @ce_hora_fin
	  
	WHILE @@FETCH_STATUS = 0  
	BEGIN 
		-- ----------
		    if @ce_nomenclatura = 'CH' begin -- cambio de horario es excepcion
			    update 
				  ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
				set
				  ci_catIE = dbo.fn_cpa_obtenercategoria (
				    'E',
				    @ce_hora_ini,
				    ci_Ehs,
				    null,
				    null,
				    ci_fecha
				  ),
				  ci_catIS = dbo.fn_cpa_obtenercategoria (
				    'S',
				    @ce_hora_fin,
				    ci_Shs,
				    null,
				    null,
				    ci_fecha
				  ),
				  ci_catIF = dbo.fn_cpa_obtenercategoria (
				    'F',
				    @ce_hora_ini,
				    ci_Ehs,
				   @ce_hora_fin,
				    ci_Shs,
				    ci_fecha
				  ),
				  ci_tienesoloexp = 1,
				  ci_he = @ce_hora_ini,
				  ci_hs = @ce_hora_fin 
				where ci_usuario = @ce_us_id 
				  and (ci_fecha between convert(date,@ce_fchhr_ini,103) and convert(date,@ce_fchhr_fin,103) )
		    end
	
		-- ----------
	    FETCH NEXT FROM cSE   
	    INTO @ce_nomenclatura, @ce_us_id, @ce_fchhr_ini, @ce_fchhr_fin, @ce_precert, @ce_hora_ini, @ce_hora_fin
	END   
	CLOSE cSE;  
	-- DEALLOCATE cSE;
	-- -----------------------
	OPEN cSE 
	
	FETCH NEXT FROM cSE   
	INTO @ce_nomenclatura, @ce_us_id, @ce_fchhr_ini, @ce_fchhr_fin, @ce_precert, @ce_hora_ini, @ce_hora_fin
	  
	WHILE @@FETCH_STATUS = 0  
	BEGIN 
		-- ----------
		if @ce_nomenclatura <> 'LT' and @ce_nomenclatura <> 'NE' and @ce_nomenclatura <> 'RA' 
			and @ce_nomenclatura <> 'NS' and @ce_nomenclatura <> 'CH' BEGIN
				update 
				  ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
				set
				  ci_catIE = @ce_nomenclatura,
				  ci_catIS = @ce_nomenclatura,
				  ci_catIF = @ce_nomenclatura,
				  ci_tienesoloexp = 1,
				  ci_precert = @ce_precert 
				where ci_usuario = @ce_us_id 
				  and (
				    ci_fecha between convert(date,@ce_fchhr_ini,103) and convert(date,@ce_fchhr_fin,103)
				  )
		end
		else BEGIN
			if @ce_nomenclatura = 'LT' or @ce_nomenclatura = 'NE' BEGIN
				update 
				  ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
				set
				  ci_catIE = 'EC',
				  ci_tienesoloexp = 1,
				  ci_catIF = 
				  case ci_catIS 
				    when 'SC' then 'HC' 
					when 'NS' then 'HP' 
					when 'RA' then 'HP' 
				  end 
				where ci_usuario = @ce_us_id 
				  and (
				    ci_fecha between cast(@ce_fchhr_ini as date) 
				    and cast(@ce_fchhr_fin as date)
				  )
			end		
		end
	
		if @ce_nomenclatura = 'RA' or @ce_nomenclatura = 'NS' begin
			update 
			  ##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
			set
			  ci_catIS = 'SC',
			  ci_catIF = 
			  case ci_catIS 
			    when 'EC' then 'HC' 
				when 'NE' then 'HP' 
				when 'LT' then 'HP' 
			  end,
			  ci_tienesoloexp = 1 
			where ci_usuario = @ce_us_id 
			  and (
			    ci_fecha between cast(@ce_fchhr_ini as date) 
			    and cast(@ce_fchhr_fin as date)
			  )
		end
		-- ----------
	    FETCH NEXT FROM cSE   
	    INTO @ce_nomenclatura, @ce_us_id, @ce_fchhr_ini, @ce_fchhr_fin, @ce_precert, @ce_hora_ini, @ce_hora_fin 
	END   
	CLOSE cSE;  
	DEALLOCATE cSE;*/

	-- -----------------------
	update 
		##rrhh_tbtmp_control_inicial_detodoslos_usuarios 
	set
	    ci_EsFeriado = 1,
	    ci_catIE = 'FD',
		ci_catIS = 'FD',
		ci_catIF = 'FD' 
  	where ci_fecha in 
	    (select 
	      frd_fecha 
	    from
	      feriados 
	    where year(frd_fecha) = year(@i_periodo)) 
   	-- -----------------------
	--if @i_contbtemp = 0 begin
		select 
			tci.ci_nro_legajo,
		    -- tci.ci_dia,
		    tci.ci_fecha,
		    tci.ci_he,
		    tci.ci_hs,
		    tci.ci_Ehs,
		    tci.ci_Shs,
		    tci.ci_catIE,
		    tci.ci_catIS,
		    tci.ci_catIF,
		    tci.ci_tienesoloexp,
		    rccE.cpacat_color as ci_catColorE,
		    rccE.cpacat_color_fondo  as ci_catColorFE,
		    rccE.cpacat_descripcion  as ci_cat_descrp_E,
		    rccE.cpagc_id  as ci_cat_grup_E,
		    rccS.cpacat_color  as ci_catColorS,
		    rccS.cpacat_color_fondo  as ci_catColorFS,
		    rccS.cpacat_descripcion  as ci_cat_descrp_S,
		    rccS.cpagc_id  as ci_cat_grup_S,
		    rccF.cpacat_color  as ci_catColorF,
		    rccF.cpacat_color_fondo  as ci_catColorFF,
		    rccF.cpacat_descripcion  as ci_cat_descrp_F,
		    rccF.cpacat_requierecertificado  as ci_cat_reqcertF,
		    rccF.cpagc_id  as ci_cat_grupoF,
		    e.id as emp_id ,
		    e.nro_legajo as emp_nro_legajo,
		    tci.ci_EsFeriado,
		    e.nombre as emp_nombre,
		    e.apellido as emp_apellido,
		    tci.ci_precert,
		    0 as ci_nro_neotel,
-- 		    ar.ar_id ,
		   -- ar.ar_descripcion,
		    e.sector_id  ,
		    sec.descripcion as sector_descripcion
		  from
		    ##rrhh_tbtmp_control_inicial_detodoslos_usuarios tci 
		    inner join cpa_categorias rccE  
		      on (
		        tci.ci_catIE = rccE.cpacat_nomenclatura 
		      ) 
		    inner join cpa_categorias rccS 
		      on (
		        tci.ci_catIS = rccS.cpacat_nomenclatura
		      ) 
		    inner join cpa_categorias rccF 
		      on (
		        tci.ci_catIF = rccF.cpacat_nomenclatura
		      ) 
		    inner join legajo e  
		      on (e.nro_legajo = tci.ci_nro_legajo)
		    inner join sector sec
		    	on sec.id = e.sector_id 		    	
		  order by tci.ci_nro_legajo ,
		    tci.ci_fecha
/*	end
	else begin	
		select 
		    ci_usuario,
		    ci_dia,
		    ci_fecha,
		    ci_he,
		    ci_hs,
		    ci_Ehs,
		    ci_Shs,
		    ci_catIE,
		    ci_catIS,
		    ci_catIF,
		    ci_tienesoloexp,
		    rccE.cpacat_color as ci_catColorE,
		    rccE.cpacat_color_fondo  as ci_catColorFE,
		    rccE.cpacat_descripcion  as ci_cat_descrp_E,
		    rccE.cpagc_id  as ci_cat_grup_E,
		    rccS.cpacat_color  as ci_catColorS,
		    rccS.cpacat_color_fondo  as ci_catColorFS,
		    rccS.cpacat_descripcion  as ci_cat_descrp_S,
		    rccS.cpagc_id  as ci_cat_grup_S,
		    rccF.cpacat_color  as ci_catColorF,
		    rccF.cpacat_color_fondo  as ci_catColorFF,
		    rccF.cpacat_descripcion  as ci_cat_descrp_F,
		    rccF.cpacat_requierecertificado  as ci_cat_reqcertF,
		    rccF.cpagc_id  as ci_cat_grupoF,
		    e.emp_id ,
		    e.emp_nro_legajo,
		    ci_EsFeriado,
		    e.emp_nombre,
		    e.emp_apellido,
		    ci_precert,
		    0 as ci_nro_neotel ,
		    ar.ar_id ,
		    ar.ar_descripcion,
		    sec.sec_id ,
		    sec.sec_descripcion 
		    into ##rrhh_tbtmp_control
	  	from
			##rrhh_tbtmp_control_inicial_detodoslos_usuarios tci 
			    inner join cpa_categorias rccE 
			      on (
			        tci.ci_catIE = rccE.cpacat_nomenclatura 
			      ) 
			    inner join cpa_categorias rccS 
			      on (
			        tci.ci_catIS = rccS.cpacat_nomenclatura
			      ) 
			    inner join cpa_categorias rccF 
			      on (
			        tci.ci_catIF = rccF.cpacat_nomenclatura
			      ) 
			    inner join legajo e  
			      on (e.emp_nro_legajo  = tci.ci_usuario)  
				inner join sectores sec
		    		on sec.sec_id = e.sec_id 
			    inner join areas ar
			    	on ar.ar_id = sec.ar_id 
			  order by e.emp_apellido ,
			    e.emp_nombre ,
			    ci_fecha 
		
	end*/
	-- -----------------------
/*	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios%') 
	BEGIN
	   DROP TABLE ##rrhh_tbtmp_horarios_inicial_detodoslos_usuarios
	end
	IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados%') 
	BEGIN
	   DROP TABLE ##rrhh_tbtmp_horario_del_periodo_detodoslos_empleados 
	END*/
END
GO
/****** Object:  StoredProcedure [dbo].[spCategoriaEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaNovedadObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria]

GO
/****** Object:  StoredProcedure [dbo].[spEmpresaObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spGeneroObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spImportacionInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spImportacionObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
       loca.Descripcion as local,
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerCantidad]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerCantidad] 
@empresa_id int, 
@nro_legajo int,
@ubicacion_id int,
@sector_id int,
@apellido varchar(50)
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
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerDeImportacion]    Script Date: 23/6/2022 12:04:09 ******/
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


if  @ubicacion_id=1 or @ubicacion_id=2
begin
  select @sector_id=s.id
  from sector   s
  where s.Descripcion = @sector
  
   set @local_id=NULL 
   
  if @sector_id is null return -3
end
ELSE 
BEGIN 
  select @local_id=l.Codigo 
  from MontagneProduccion.dbo.Locales l 
  where l.Descripcion = @sector
  
  set @sector_id=NULL 
  
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPag]    Script Date: 23/6/2022 12:04:09 ******/
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
@apellido varchar(50)
AS


select  TOP 25 * FROM
(
   select  ROW_NUMBER() OVER (       
     order by nro_legajo 
         ) AS RowNumber,
		l.*,
       g.descripcion as genero,
       s.descripcion as sector,
       loca.Descripcion as local,
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
) _myResults
where rownumber >= (@pag-1)*25+1
order by  RowNumber
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorFiltro]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorNro]    Script Date: 23/6/2022 12:04:09 ******/
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
       loca.Descripcion as local,
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLegajoObtenerTodos] 
@empresa_id int, 
@nro_legajo int,
@ubicacion_id int,
@sector_id int,
@apellido varchar(50)
AS


select l.*,
       g.descripcion as genero,
       s.descripcion as sector,
       loca.Descripcion as local,
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
order by nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLocalObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLocalObtenerTodos] 
AS



select Codigo as id ,
       Descripcion as Descripcion 
from MontagneProduccion.dbo.Locales
order by Descripcion 
GO
/****** Object:  StoredProcedure [dbo].[spLogin]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadInsertar]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spNovedadInsertar] 
@legajo_id int,
@ubicacion_id int,
@sector_id int,
@local_id int,
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
 local_id,
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
 @local_id,
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
/****** Object:  StoredProcedure [dbo].[spNovedadModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
    local_id=@local_id, 
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerCantidad]    Script Date: 23/6/2022 12:04:09 ******/
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
@fecha_novedad_hasta datetime

AS

select count(*)
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join empresa e on l.empresa_id = e.id
left join ubicacion u on nov.ubicacion_id = u.id  
left join responsable r on nov.responsable_id = r.id
left join sector s on nov.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on nov.local_id = loca.Codigo 
where (@empresa_id=-1 or empresa_id = @empresa_id)
and   (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and   (@fecha_novedad_desde is null or nov.fecha_novedad  >= @fecha_novedad_desde)
and   (@fecha_novedad_hasta is null or nov.fecha_novedad  <= @fecha_novedad_hasta)
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerDeImportacion]    Script Date: 23/6/2022 12:04:09 ******/
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
@observacion text

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

select @empresa_id= e.id
from empresa e 
where e.Descripcion = @empresa
or e.nomenclatura = @empresa

if @empresa_id is null return -2

select @legajo_id = l.id
from legajo l 
where l.empresa_id = @empresa_id
and   l.nro_legajo = @nro_legajo

if  @legajo_id is null return -2

/*
select @categoria_id= cn.id
from categoria_novedad  cn  
where cn.descripcion  = @categoria_novedad
*/

select @usuario_id= u.id
from usuario u  
where u.UsuarioID  =   'GFERNANDEZ'

if  @ubicacion_id=1 or @ubicacion_id=2
begin
  select @sector_id=s.id
  from sector   s
  where s.Descripcion = @sector
  
   set @local_id=NULL 
   
  --if @sector_id is null return -3
end
ELSE 
BEGIN 
  select @local_id=l.Codigo 
  from MontagneProduccion.dbo.Locales l 
  where l.Descripcion = @sector
  
  set @sector_id=NULL 
  
  if @local_id is null return -3
end

select @responsable_id= r.id
from responsable r  
where r.apellido  = @responsable

select @tipo_novedad_id=n.id
from tipo_novedad n   
where n.descripcion  = @tipo_novedad

if @tipo_novedad_id is null return -4

select @tipo_resolucion_id= r.id
from tipo_resolucion r
where r.descripcion = @tipo_resolucion



select @usuario_id as usuario_id,
       @legajo_id as legajo_id,
       @ubicacion_id as ubicacion_id,
       @sector_id as sector_id,
       @local_id as local_id,
       @categoria_novedad as categoria_novedad_id,
       @responsable_id as responsable_id,
       @tipo_novedad_id as tipo_novedad_id,
       @tipo_resolucion_id as tipo_resolucion_id,
       @observacion as observacion,
       case when @concepto = '' then null else @concepto end  as concepto,
       case when @dias = '' then null else @dias end  as dias,
       case when @str_fecha_novedad = '' then null else @str_fecha_novedad end  as fecha_novedad,
       case when  @str_fecha_resolucion = '' then null else  @str_fecha_resolucion end as fecha_resolucion;
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerPag]    Script Date: 23/6/2022 12:04:09 ******/
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
@fecha_novedad_hasta datetime

AS

select  TOP 1000 * FROM
(
   select  ROW_NUMBER() OVER (       
     order by nov.categoria_novedad_id, nov.id desc
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
       r.apellido as responsable,
       s.descripcion as sector,
       loca.Descripcion as local
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join empresa e on l.empresa_id = e.id
left join ubicacion u on nov.ubicacion_id = u.id  
left join responsable r on nov.responsable_id = r.id
left join sector s on nov.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on nov.local_id = loca.Codigo 
where (@empresa_id=-1 or empresa_id = @empresa_id)
and   (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and   (@fecha_novedad_desde is null or nov.fecha_novedad  >= @fecha_novedad_desde)
and   (@fecha_novedad_hasta is null or nov.fecha_novedad  <= @fecha_novedad_hasta)
) _myResults
where rownumber >= (@pag-1)*1000+1
order by  RowNumber

GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
@fecha_novedad_hasta datetime

AS
Select nov.*,
       cn.descripcion as categoria_novedad, 
       tn.descripcion as tipo_novedad,
       tr.descripcion as tipo_resolucion,
       l.nro_legajo,
       l.apellido,
       l.nombre,
       e.descripcion as empresa,
       u.descripcion as ubicacion,
       r.apellido as responsable,
       s.descripcion as sector,
       loca.Descripcion as local
from novedad nov 
left join categoria_novedad cn on nov.categoria_novedad_id = cn.id 
left join tipo_novedad tn on nov.tipo_novedad_id  = tn.id
left join tipo_resolucion tr on nov.tipo_resolucion_id  = tr.id
left join legajo l on nov.legajo_id = l.id 
left join empresa e on l.empresa_id = e.id
left join ubicacion u on nov.ubicacion_id = u.id  
left join responsable r on nov.responsable_id = r.id
left join sector s on nov.sector_id = s.id
left join MontagneProduccion.dbo.Locales loca on nov.local_id = loca.Codigo 
where (@empresa_id=-1 or empresa_id = @empresa_id)
and   (@categoria_novedad_id=-1 or categoria_novedad_id = @categoria_novedad_id)
and   (@tipo_novedad_id=-1 or tipo_novedad_id = @tipo_novedad_id)
and   (@tipo_resolucion_id=-1 or tipo_resolucion_id = @tipo_resolucion_id)
and   (@nro_legajo=-1 or l.nro_legajo = @nro_legajo)
and   (@apellido='' or l.apellido like '%'+ @apellido +'%')
and   (@fecha_novedad_desde is null or nov.fecha_novedad  >= @fecha_novedad_desde)
and   (@fecha_novedad_hasta is null or nov.fecha_novedad  <= @fecha_novedad_hasta)
order by fecha_novedad desc 
GO
/****** Object:  StoredProcedure [dbo].[spPerfilObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionEliminar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spUbicacionObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioCambiarClave]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioEliminar]    Script Date: 23/6/2022 12:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioEliminar] 
@UsuarioID varchar(255)
AS

delete from usuario where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioInsertar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioModificar]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtener]    Script Date: 23/6/2022 12:04:09 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerTodos]    Script Date: 23/6/2022 12:04:09 ******/
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
