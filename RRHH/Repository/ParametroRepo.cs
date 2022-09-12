using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class ParametroRepo:IParametroRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

      
        public string Insertar(Parametro parametro)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@codigo", parametro.codigo);
                parameters.Add("@descripcion", parametro.descripcion);
                parameters.Add("@valor", parametro.valor);
                
                icantFilas = con.Execute("spParametroInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Parametro parametro)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@codigo", parametro.codigo);
                parameters.Add("@descripcion", parametro.descripcion);
                parameters.Add("@valor", parametro.valor);

                con.Execute("spParametroModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Parametro> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Parametro>("spParametroObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Parametro Obtener(string codigo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@codigo", codigo);

                return con.QuerySingle<Parametro>("spParametroObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string ObtenerValor(string codigo)
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

        public string Eliminar(string codigo)
        {

            int icantFilas;

            try
            {

                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@codigo", codigo);

                    icantFilas = con.Execute("spParametroEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar el tipo de justificación. Existen datos cargados asociados al mismo.";
                else
                    return "Error en la base de datos.";

            }

            return "";
        }

    }
}
