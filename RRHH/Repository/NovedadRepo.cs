﻿using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class NovedadRepo:INovedadRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Novedad novedad,int usuario_id)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", novedad.legajo_id);
                parameters.Add("@ubicacion_id", novedad.ubicacion_id);
                parameters.Add("@sector_id", (novedad.sector_id == -1) ? null : novedad.sector_id);
                parameters.Add("@local_id", (novedad.local_id == -1) ? null : novedad.local_id);
                parameters.Add("@responsable", novedad.responsable);
                //parameters.Add("@responsable_id", (novedad.responsable_id == -1) ? null : novedad.responsable_id);
                parameters.Add("@categoria_novedad_id", novedad.categoria_novedad_id);
                parameters.Add("@tipo_novedad_id", (novedad.tipo_novedad_id==-1)?null: novedad.tipo_novedad_id);
                parameters.Add("@tipo_resolucion_id", (novedad.tipo_resolucion_id > 0) ? novedad.tipo_resolucion_id : null);
                parameters.Add("@concepto", novedad.concepto);
                parameters.Add("@dias", novedad.dias);
                parameters.Add("@descripcion", novedad.descripcion);
                parameters.Add("@estado", novedad.estado);
                parameters.Add("@observacion", novedad.observacion);
                parameters.Add("@fecha_novedad", novedad.fecha_novedad);
                parameters.Add("@fecha_resolucion", (novedad.tipo_resolucion_id > 0) ? novedad.fecha_resolucion : null);
                parameters.Add("@usuario_id", usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spNovedadInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") < 0) return "El legajo no existe";
                

            }
            return "";
        }

        public string Modificar(Novedad novedad, int usuario_id)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", novedad.id);
                parameters.Add("@legajo_id", novedad.legajo_id);
                parameters.Add("@ubicacion_id", novedad.ubicacion_id);
                parameters.Add("@sector_id", (novedad.sector_id == -1) ? null : novedad.sector_id);
                parameters.Add("@local_id", (novedad.local_id == -1) ? null : novedad.local_id);
                parameters.Add("@responsable", novedad.responsable);
                //parameters.Add("@responsable_id", (novedad.responsable_id == -1) ? null : novedad.responsable_id);
                parameters.Add("@categoria_novedad_id", novedad.categoria_novedad_id);
                parameters.Add("@tipo_novedad_id", (novedad.tipo_novedad_id == -1) ? null : novedad.tipo_novedad_id);
                parameters.Add("@tipo_resolucion_id", (novedad.tipo_resolucion_id > 0) ? novedad.tipo_resolucion_id : null);
                parameters.Add("@concepto", novedad.concepto);
                parameters.Add("@dias", novedad.dias);
                parameters.Add("@descripcion", novedad.descripcion);
                parameters.Add("@estado", novedad.estado);
                parameters.Add("@observacion", novedad.observacion);
                parameters.Add("@fecha_novedad", novedad.fecha_novedad);
                parameters.Add("@fecha_resolucion", (novedad.tipo_resolucion_id>0)?novedad.fecha_resolucion:null);
                parameters.Add("@usuario_id", usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spNovedadModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") < 0) return "El legajo no existe";

            }
            return "";
        }


        public IEnumerable<Novedad> ObtenerTodos(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido, int? perfil_id )
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@categoria_novedad_id", categoria_novedad_id);
                parameter.Add("@tipo_novedad_id", tipo_novedad_id);
                parameter.Add("@tipo_resolucion_id", tipo_resolucion_id);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@fecha_novedad_desde", (fecha_novedad_desde.Year < 1000) ? null : fecha_novedad_desde);
                parameter.Add("@fecha_novedad_hasta", (fecha_novedad_hasta.Year < 1000) ? null : fecha_novedad_hasta);
                parameter.Add("@perfil_id", perfil_id);

                return con.Query<Novedad>("spNovedadObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<Novedad> ObtenerPagina(int pag, int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido, int? perfil_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@pag", pag);
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@categoria_novedad_id", categoria_novedad_id);
                parameter.Add("@tipo_novedad_id", tipo_novedad_id);
                parameter.Add("@tipo_resolucion_id", tipo_resolucion_id);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@fecha_novedad_desde", (fecha_novedad_desde.Year < 1000) ? null : fecha_novedad_desde);
                parameter.Add("@fecha_novedad_hasta", (fecha_novedad_hasta.Year < 1000) ? null : fecha_novedad_hasta);
                parameter.Add("@perfil_id", perfil_id);

                return con.Query<Novedad>("spNovedadObtenerPag", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public int ObtenerCantidad(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido, int? perfil_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@categoria_novedad_id", categoria_novedad_id);
                parameter.Add("@tipo_novedad_id", tipo_novedad_id);
                parameter.Add("@tipo_resolucion_id", tipo_resolucion_id);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@fecha_novedad_desde", (fecha_novedad_desde.Year < 1000) ? null : fecha_novedad_desde);
                parameter.Add("@fecha_novedad_hasta", (fecha_novedad_hasta.Year < 1000) ? null : fecha_novedad_hasta);
                parameter.Add("@perfil_id", perfil_id);

                return con.QuerySingle<int>("spNovedadObtenerCantidad", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public Novedad Obtener(int id)
        {
            

             using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Novedad>("spNovedadObtener", parameter, commandType: CommandType.StoredProcedure);
            }
           

        }


        public int ObtenerDeImportacion(string empresa, string nro_legajo, string ubicacion_id,  string sector, string responsable, string concepto, string categoria_novedad, string tipo_novedad, string fecha_novedad, string tipo_resolucion,  string fecha_resolucion, string dias, string descripcion, string estado, string observacion, ref  Novedad nov)
        {

            try
            {
             using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa", empresa);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector", sector);
                parameter.Add("@responsable", responsable);
                parameter.Add("@concepto", concepto);
                parameter.Add("@categoria_novedad", categoria_novedad);
                parameter.Add("@tipo_novedad", tipo_novedad);
                parameter.Add("@str_fecha_novedad", fecha_novedad);
                parameter.Add("@tipo_resolucion", tipo_resolucion);
                parameter.Add("@str_fecha_resolucion", fecha_resolucion);
                parameter.Add("@dias", dias);
                parameter.Add("@descripcion", descripcion);
                parameter.Add("@estado", estado);
                parameter.Add("@observacion", observacion);

                parameter.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

                nov =  con.QuerySingleOrDefault<Novedad>("spNovedadObtenerDeImportacion", parameter, commandType: CommandType.StoredProcedure);

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

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", id);

                icantFilas = con.Execute("spNovedadEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }
    }
}
