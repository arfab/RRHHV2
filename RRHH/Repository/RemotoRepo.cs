using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class RemotoRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Remoto remoto, int usuario_id)
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
                parameters.Add("@dia_semana", remoto.dia_semana);
                parameters.Add("@usuario_id", usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spRemotoInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Las fechas se solapan";


            }
            return "";
        }

        public string Modificar(Remoto remoto, int usuario_id)
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
                parameters.Add("@dia_semana", remoto.dia_semana);
                parameters.Add("@usuario_id", usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spRemotoModificar", parameters, commandType: CommandType.StoredProcedure);

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

                icantFilas = con.Execute("spRemotoEliminar", parameters2, commandType: CommandType.StoredProcedure);


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

                return con.QuerySingleOrDefault<Remoto>("spRemotoObtener", parameter, commandType: CommandType.StoredProcedure);
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


                return con.Query<Remoto>("spRemotoObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<Remoto> ObtenerTodos(int empresa_id, int dia_semana, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@dia_semana", dia_semana);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? null : fecha_desde);
                parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? null : fecha_hasta);


                return con.Query<Remoto>("spRemotoObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
