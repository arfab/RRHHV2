using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class ImportacionRepo:IImportacionRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Importacion importacion)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@tipo", importacion.tipo);
                parameters.Add("@nombre_archivo", importacion.nombre_archivo);
                parameters.Add("@cantidad", importacion.cantidad);
                parameters.Add("@errores", importacion.errores);


                icantFilas = con.Execute("spImportacionInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public IEnumerable<Importacion> ObtenerTodos(string tipo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@tipo", tipo);


                return con.Query<Importacion>("spImportacionObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

    }
}
