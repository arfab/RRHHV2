using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class RemotoExcepcionRepo : IRemotoExcepcionRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Remoto remoto)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", remoto.legajo_id);
                parameters.Add("@fecha_desde", remoto.fecha_desde);
                parameters.Add("@fecha_hasta", remoto.fecha_hasta);
                parameters.Add("@remoto", remoto.remoto);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spRemotoExcepcionInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Las fechas se solapan";


            }
            return "";
        }

        public string Modificar(Remoto remoto)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", remoto.id);
                parameters.Add("@legajo_id", remoto.legajo_id);
                parameters.Add("@fecha_desde", remoto.fecha_desde);
                parameters.Add("@fecha_hasta", remoto.fecha_hasta);
                parameters.Add("@remoto", remoto.remoto);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spRemotoExcepcionModificar", parameters, commandType: CommandType.StoredProcedure);

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

                icantFilas = con.Execute("spRemotoExcepcionEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public Remoto Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Remoto>("spRemotoExcepcionObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<Remoto> ObtenerPorLegajo(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);


                return con.Query<Remoto>("spRemotoExcepcionObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<Remoto> ObtenerTodos(int empresa_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta, string apellido)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@legajo_id", legajo_id);
                parameter.Add("@apellido", apellido);
                parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? null : fecha_desde);
                parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? null : fecha_hasta);


                return con.Query<Remoto>("spRemotoExcepcionObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

    }
}
