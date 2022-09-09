using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class JustificacionRepo:IJustificacionRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Justificacion justificacion, int usuario_id)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", justificacion.legajo_id);
                parameters.Add("@fecha_desde", justificacion.fecha_desde);
                parameters.Add("@fecha_hasta", justificacion.fecha_hasta);
                parameters.Add("@categoria_id", justificacion.categoria_id);
                parameters.Add("@descripcion", justificacion.descripcion);
                parameters.Add("@usuario_id", usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spJustificacionInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1 ) return "Las fechas se solapan con otra justificacion";


            }
            return "";
        }

        public string Modificar(Justificacion justificacion, int usuario_id)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", justificacion.id);
                parameters.Add("@legajo_id", justificacion.legajo_id);
                parameters.Add("@fecha_desde", justificacion.fecha_desde);
                parameters.Add("@fecha_hasta", justificacion.fecha_hasta);
                parameters.Add("@categoria_id", justificacion.categoria_id);
                parameters.Add("@descripcion", justificacion.descripcion);
                parameters.Add("@usuario_id", usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spJustificacionModificar", parameters, commandType: CommandType.StoredProcedure);

               // if (parameters.Get<int>("@retValue") < 0) return "El legajo no existe";

            }
            return "";
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

                icantFilas = con.Execute("spJustificacionEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public Justificacion Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Justificacion>("spJustificacionObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<Justificacion> ObtenerPorLegajo(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);
               

                return con.Query<Justificacion>("spJustificacionObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<Justificacion> ObtenerTodos(int empresa_id, int categoria_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@categoria_id", categoria_id);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? null : fecha_desde);
                parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? null : fecha_hasta);


                return con.Query<Justificacion>("spJustificacionObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
