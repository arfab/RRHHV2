﻿using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class LegajoRepo:ILegajoRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Legajo legajo)
        {
            int icantFilas;

            try
            {
                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters = new DynamicParameters();
                    parameters.Add("@nro_legajo", legajo.nro_legajo);
                    parameters.Add("@apellido", legajo.apellido);
                    parameters.Add("@nombre", legajo.nombre);
                    parameters.Add("@dni", legajo.dni);
                    parameters.Add("@genero_id", legajo.genero_id);
                    parameters.Add("@empresa_id", legajo.empresa_id);
                    parameters.Add("@ubicacion_id", legajo.ubicacion_id);
                    parameters.Add("@sector_id", (legajo.sector_id == -1) ? null : legajo.sector_id);
                    parameters.Add("@local_id", (legajo.local_id == -1) ? null : legajo.local_id);
                    parameters.Add("@turno_id", (legajo.turno_id == -1) ? null : legajo.turno_id);
                    parameters.Add("@categoria_id", legajo.categoria_id);
                    parameters.Add("@funcion_id", (legajo.funcion_id <= 0) ? null : legajo.funcion_id);
                    parameters.Add("@observacion", legajo.observacion);
                    parameters.Add("@activo", 1);
                    parameters.Add("@fecha_alta", legajo.fecha_alta);
                    parameters.Add("@fecha_baja", legajo.fecha_baja);
                    parameters.Add("@convenio", legajo.convenio);
                    parameters.Add("@centro_costo_id", (legajo.centro_costo_id == -1) ? null : legajo.centro_costo_id);

                    parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                    icantFilas = con.Execute("spLegajoInsertar", parameters, commandType: CommandType.StoredProcedure);
                    if (parameters.Get<int>("@retValue") < 0) return "Ya existe ese legajo en la misma empresa";


                }
            }
            catch (SqlException e)
            {
                    return "Error";
            }
            return "";
        }

        public string Modificar(Legajo legajo)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", legajo.id);
                parameters.Add("@nro_legajo", legajo.nro_legajo);
                parameters.Add("@apellido", legajo.apellido);
                parameters.Add("@nombre", legajo.nombre);
                parameters.Add("@dni", legajo.dni);
                parameters.Add("@genero_id", legajo.genero_id);
                parameters.Add("@empresa_id", legajo.empresa_id);
                parameters.Add("@ubicacion_id", legajo.ubicacion_id);
                parameters.Add("@sector_id", (legajo.sector_id == -1) ? null : legajo.sector_id);
                parameters.Add("@local_id", (legajo.local_id == -1) ? null : legajo.local_id);
                parameters.Add("@turno_id", (legajo.turno_id == -1) ? null : legajo.turno_id);
                parameters.Add("@categoria_id", legajo.categoria_id);
                parameters.Add("@funcion_id", (legajo.funcion_id<=0)?null:legajo.funcion_id);
                parameters.Add("@observacion", legajo.observacion);
                parameters.Add("@activo", 1);
                parameters.Add("@fecha_alta", legajo.fecha_alta);
                parameters.Add("@fecha_baja", legajo.fecha_baja);
                parameters.Add("@fecha_cambio", legajo.fecha_cambio);
                parameters.Add("@convenio", legajo.convenio);
                parameters.Add("@centro_costo_id", (legajo.centro_costo_id == -1) ? null : legajo.centro_costo_id);

                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spLegajoModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") < 0) return "Ya existe ese legajo en la misma empresa";


            }
            return "";
        }


        public IEnumerable<Legajo> ObtenerTodos(int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido, int activo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@nro_legajo", iNroLegajo);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector_id", sector_id);
                parameter.Add("@apellido", sApellido);
                parameter.Add("@activo", activo);


                return con.Query<Legajo>("spLegajoObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<Legajo> ObtenerPorFiltro(string sFiltro)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@filtro", sFiltro);


                return con.Query<Legajo>("spLegajoObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


        public IEnumerable<Legajo> ObtenerPagina(int pag, int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido, int activo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@pag", pag);
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@nro_legajo", iNroLegajo);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector_id", sector_id);
                parameter.Add("@apellido", sApellido);
                parameter.Add("@activo", activo);


                return con.Query<Legajo>("spLegajoObtenerPag", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public int ObtenerCantidad(int empresa_id, int iNroLegajo, int ubicacion_id, int sector_id, string sApellido, int activo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@nro_legajo", iNroLegajo);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector_id", sector_id);
                parameter.Add("@apellido", sApellido);
                parameter.Add("@activo", activo);


                return con.QuerySingle<int>("spLegajoObtenerCantidad", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public Legajo Obtener(int id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Legajo>("spLegajoObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public Legajo ObtenerPorNro(int empresa_id, int iNroLegajo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@nro_legajo", iNroLegajo);
                parameter.Add("@empresa_id", empresa_id);

                return con.QuerySingleOrDefault<Legajo>("spLegajoObtenerPorNro", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public int ObtenerDeImportacion(string nro_legajo, string apellido, string nombre, string empresa, string sector, string categoria, string funcion, string fecha_alta, string fecha_baja, string genero, string observacion, string ubicacion_id, ref  Legajo legajo )
        {

            try
            {
                using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@nombre", nombre);
                parameter.Add("@empresa", empresa);
                parameter.Add("@sector", sector);
                parameter.Add("@categoria", categoria);
                parameter.Add("@funcion", funcion);
                parameter.Add("@str_fecha_ingreso", fecha_alta);
                parameter.Add("@str_fecha_baja", fecha_baja);
                parameter.Add("@observacion", observacion);
                parameter.Add("@genero", genero);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                legajo = con.QuerySingleOrDefault<Legajo>("spLegajoObtenerDeImportacion", parameter, commandType: CommandType.StoredProcedure);

                return parameter.Get<int>("@retValue");
              

            }
            }
            catch (SqlException e)
            {
                 return -999;

            }


        }

        public string Eliminar(int id)
        {

            try
            {
                int icantFilas;
                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@id", id);

                    icantFilas = con.Execute("spLegajoEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch
            {
            }
            return "";
        }
    }
}
