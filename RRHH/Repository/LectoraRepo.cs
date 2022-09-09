using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class LectoraRepo:ILectoraRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public IEnumerable<Lectora> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
           


                return con.Query<Lectora>("spLectoraObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public int ObtenerAjuste(int lectora_id, DateTime fecha)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@lectora_id", lectora_id);
                parameters.Add("@fecha", fecha);


                var res =  con.QuerySingleOrDefault("spLectorAjusteObtenerPorFecha", parameters, commandType: CommandType.StoredProcedure);

                if (res == null)
                    return 0;
                else
                    return res.delta;
                     
            }

        }

    }
}
