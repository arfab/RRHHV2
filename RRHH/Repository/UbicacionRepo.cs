using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class UbicacionRepo:IUbicacionRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public IEnumerable<Ubicacion> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Ubicacion>("spUbicacionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Ubicacion Obtener(int iUbicacion)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@codigo", iUbicacion);

                return con.QuerySingle<Ubicacion>("spUbicacionObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

    }
}
