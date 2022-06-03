using Dapper;
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
                parameters.Add("@sector_id", novedad.sector_id);
                parameters.Add("@local_id", novedad.local_id);
                parameters.Add("@responsable_id", novedad.responsable_id);
                parameters.Add("@categoria_novedad_id", novedad.categoria_novedad_id);
                parameters.Add("@tipo_novedad_id", (novedad.tipo_novedad_id==-1)?null: novedad.tipo_novedad_id);
                parameters.Add("@tipo_resolucion_id", (novedad.tipo_resolucion_id > 0) ? novedad.tipo_resolucion_id : null);
                parameters.Add("@concepto", novedad.concepto);
                parameters.Add("@dias", novedad.dias);
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
                parameters.Add("@sector_id", novedad.sector_id);
                parameters.Add("@local_id", novedad.local_id);
                parameters.Add("@responsable_id", novedad.responsable_id);
                parameters.Add("@categoria_novedad_id", novedad.categoria_novedad_id);
                parameters.Add("@tipo_novedad_id", novedad.tipo_novedad_id);
                parameters.Add("@tipo_resolucion_id", (novedad.tipo_resolucion_id > 0)?novedad.tipo_resolucion_id:null);
                parameters.Add("@concepto", novedad.concepto);
                parameters.Add("@dias", novedad.dias);
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


        public IEnumerable<Novedad> ObtenerTodos(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido )
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
                parameter.Add("@fecha_novedad_desde", fecha_novedad_desde);
                parameter.Add("@fecha_novedad_hasta", fecha_novedad_hasta);

                return con.Query<Novedad>("spNovedadObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
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

                return con.QuerySingle<Novedad>("spNovedadObtener", parameter, commandType: CommandType.StoredProcedure);
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
