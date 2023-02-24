using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class ReporteRepo:IReporteRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();


        public IEnumerable<Viatico> ReporteViaticos(int empresa_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@legajo_id", legajo_id);
                parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? DateTime.Now : fecha_desde);
                parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? DateTime.Now : fecha_hasta);


                return con.Query<Viatico>("spReporteViaticos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
