using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class TipoResolucionRepo: ITipoResolucionRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(TipoResolucion tipoResolucion)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", tipoResolucion.descripcion);


                icantFilas = con.Execute("spTipoResolucionInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(TipoResolucion tipoResolucion)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", tipoResolucion.id);
                parameters.Add("@descripcion", tipoResolucion.descripcion);


                con.Execute("spTipoResolucionModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<TipoResolucion> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<TipoResolucion>("spTipoResolucionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public TipoResolucion Obtener(int iTipoResolucion)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iTipoResolucion);

                return con.QuerySingle<TipoResolucion>("spTipoResolucionObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iTipoResolucion)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iTipoResolucion);

                icantFilas = con.Execute("spTipoResolucionEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

    }
}
