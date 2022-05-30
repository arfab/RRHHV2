using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
namespace RRHH.Repository
{
    public class ResponsableRepo:IResponsableRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public IEnumerable<Responsable> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Responsable>("spResponsableObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Responsable Obtener(int iResponsable)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iResponsable);

                return con.QuerySingle<Responsable>("spResponsableObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }
    }
}
