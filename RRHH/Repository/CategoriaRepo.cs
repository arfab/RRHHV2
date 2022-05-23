using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class CategoriaRepo:ICategoriaRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Categoria categoria)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", categoria.descripcion);


                icantFilas = con.Execute("spCategoriaInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Categoria categoria)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", categoria.id);
                parameters.Add("@descripcion", categoria.descripcion);


                con.Execute("spCategoriaModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Categoria> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Categoria>("spCategoriaObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Categoria Obtener(int iCategoria)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iCategoria);

                return con.QuerySingle<Categoria>("spCategoriaObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iCategoria)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iCategoria);

                icantFilas = con.Execute("spCategoriaEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }
    }
}
