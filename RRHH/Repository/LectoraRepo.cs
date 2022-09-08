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
    }
}
