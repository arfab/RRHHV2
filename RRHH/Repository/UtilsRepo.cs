using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class UtilsRepo:IUtilsRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string ObtenerParametro(string codigo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@codigo", codigo);

                var res = con.QuerySingleOrDefault("spParametroObtener", parameters, commandType: CommandType.StoredProcedure);

                if (res == null)
                    return "";
                else
                    return res.valor;

            }

        }
    }
}
