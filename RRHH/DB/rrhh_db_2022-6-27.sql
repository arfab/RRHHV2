/****** Object:  UserDefinedFunction [dbo].[fn_cpa_obtenercategoria]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_obtenerelprimerafechadeldiabycoddiayperiodo]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_obtenerelultimofechadeldiabycoddiayperiodo]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_PrimerDia]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_UltimoDia]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[categoria]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[categoria_novedad]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[empresa]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[funcion]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[genero]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[importacion]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[legajo]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[novedad]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[perfil]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[responsable]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[sector]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[tipo_novedad]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[tipo_resolucion]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[ubicacion]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  Table [dbo].[usuario]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_lectores_abm]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_lectores_get]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_rrhh_control_ayp_get]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaNovedadObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spCategoriaObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCategoriaObtenerTodos] 
AS

SELECT * 
FROM  [dbo].[categoria]

GO
/****** Object:  StoredProcedure [dbo].[spEmpresaObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spFuncionObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spGeneroObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spImportacionInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spImportacionObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerCantidad]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerDeImportacion]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPag]    Script Date: 27/6/2022 15:55:30 ******/
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
and    (@activo=-1 or @activo=1 and fecha_baja is null or @activo=0 and fecha_baja is not null)
) _myResults
where rownumber >= (@pag-1)*25+1
order by  RowNumber
GO
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorFiltro]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerPorNro]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLegajoObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
and    (@activo=-1 or @activo=1 and fecha_baja is null or @activo=0 and fecha_baja is not null)
order by nro_legajo
GO
/****** Object:  StoredProcedure [dbo].[spLocalObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spLogin]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerCantidad]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerDeImportacion]    Script Date: 27/6/2022 15:55:30 ******/
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

if  @legajo_id is null return -1

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

select @responsable_id= r.id
from responsable r  
where r.apellido  = @responsable

if @responsable_id is null return -4

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
       @responsable_id as responsable_id,
       @tipo_novedad_id as tipo_novedad_id,
       @tipo_resolucion_id as tipo_resolucion_id,
       @observacion as observacion,
       case when @concepto = '' then null else @concepto end  as concepto,
       case when @dias = '' then null else @dias end  as dias,
       case when @str_fecha_novedad = '' then null else @str_fecha_novedad end  as fecha_novedad,
       case when  @str_fecha_resolucion = '' then null else  @str_fecha_resolucion end as fecha_resolucion;
GO
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerPag]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spNovedadObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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

Select 
       nov.id, 
       nov.legajo_id, 
       nov.ubicacion_id, 
       nov.responsable_id, 
       nov.categoria_novedad_id, 
       nov.tipo_novedad_id, 
       nov.tipo_resolucion_id, 
       nov.concepto, 
       CAST(nov.observacion  as varchar(200)) as observacion , 
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
/****** Object:  StoredProcedure [dbo].[spPerfilObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spResponsableObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spSectorObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoNovedadObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionEliminar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spTipoResolucionObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUbicacionObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioCambiarClave]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioEliminar]    Script Date: 27/6/2022 15:55:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuarioEliminar] 
@UsuarioID varchar(255)
AS

delete from usuario where UsuarioID=@UsuarioID
GO
/****** Object:  StoredProcedure [dbo].[spUsuarioInsertar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioModificar]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtener]    Script Date: 27/6/2022 15:55:30 ******/
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
/****** Object:  StoredProcedure [dbo].[spUsuarioObtenerTodos]    Script Date: 27/6/2022 15:55:30 ******/
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
