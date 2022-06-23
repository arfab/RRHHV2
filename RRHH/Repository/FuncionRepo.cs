using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class FuncionRepo:IFuncionRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Funcion funcion)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", funcion.descripcion);


                icantFilas = con.Execute("spFuncionInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Funcion funcion)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", funcion.id);
                parameters.Add("@descripcion", funcion.descripcion);


                con.Execute("spFuncionModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Funcion> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Funcion>("spFuncionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Funcion Obtener(int iFuncion)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iFuncion);

                return con.QuerySingle<Funcion>("spFuncionObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iFuncion)
        {

            int icantFilas;
            try
            {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iFuncion);

                icantFilas = con.Execute("spFuncionEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar la tarea. Existen datos cargados asociados al mismo.";
                else
                    return "Error en la base de datos.";

            }

            return "";
        }
    }
}

