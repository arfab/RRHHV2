using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;



namespace RRHH.Repository
{
    public class TipoNovedadRepo:ITipoNovedadRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(TipoNovedad tipoNovedad)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", tipoNovedad.descripcion);


                icantFilas = con.Execute("spTipoNovedadInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(TipoNovedad tipoNovedad)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", tipoNovedad.id);
                parameters.Add("@descripcion", tipoNovedad.descripcion);


                con.Execute("spTipoNovedadModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<TipoNovedad> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<TipoNovedad>("spTipoNovedadObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public TipoNovedad Obtener(int iTipoNovedad)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iTipoNovedad);

                return con.QuerySingle<TipoNovedad>("spTipoNovedadObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iTipoNovedad)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iTipoNovedad);

                icantFilas = con.Execute("spTipoNovedadEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

    }
}
