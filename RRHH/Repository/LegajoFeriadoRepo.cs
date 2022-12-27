using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;



namespace RRHH.Repository
{
    public class LegajoFeriadoRepo:ILegajoFeriadoRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(LegajoFeriado legajoFeriado)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajoFeriado.legajo_id);
                parameters.Add("@feriado_id", legajoFeriado.feriado_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spLegajoFeriadoInsertar", parameters, commandType: CommandType.StoredProcedure);


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

                icantFilas = con.Execute("spLegajoFeriadoEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

      

        public IEnumerable<LegajoFeriado> ObtenerTodos(int feriado_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@feriado_id", feriado_id);


                return con.Query<LegajoFeriado>("spLegajoFeriadoObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
