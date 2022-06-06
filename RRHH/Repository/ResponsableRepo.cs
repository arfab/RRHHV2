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

        public string Insertar(Responsable responsable)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@nombre", responsable.nombre);
                parameters.Add("@apellido", responsable.apellido);


                icantFilas = con.Execute("spResponsableInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Responsable responsable)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", responsable.id);
                parameters.Add("@nombre", responsable.nombre);
                parameters.Add("@apellido", responsable.apellido);


                con.Execute("spResponsableModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Eliminar(int iResponsable)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iResponsable);

                icantFilas = con.Execute("spResponsableEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

    }
}
