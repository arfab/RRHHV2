using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class LectoraRepo:ILectoraRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public IEnumerable<Lectora> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
           


                return con.Query<Lectora>("spLectoraObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public int ObtenerAjustePorFecha(int lectora_id, DateTime fecha)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@lectora_id", lectora_id);
                parameters.Add("@fecha", fecha);


                var res =  con.QuerySingleOrDefault("spLectorAjusteObtenerPorFecha", parameters, commandType: CommandType.StoredProcedure);

                if (res == null)
                    return 0;
                else
                    return res.delta;
                     
            }

        }


        public AjusteLectora ObtenerAjuste(int iId)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iId);

                return con.QuerySingle<AjusteLectora>("spAjusteLecturaObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public IEnumerable<AjusteLectora> ObtenerAjustes(string fecha, int lectora_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@fecha", fecha);
                parameters.Add("@lectora_id", lectora_id);
    


                return con.Query<AjusteLectora>("spAjusteLectoraObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }

        }


        public string InsertarAjuste(AjusteLectora ajuste)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@fecha", ajuste.fecha);
                parameters.Add("@lectora_id", ajuste.lectora_id);
                parameters.Add("@desde", ajuste.desde);
                parameters.Add("@hasta", ajuste.hasta);
                parameters.Add("@delta", ajuste.delta);


                icantFilas = con.Execute("spAjusteLectoraInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string ModificarAjuste(AjusteLectora ajuste)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", ajuste.id);
                parameters.Add("@desde", ajuste.desde);
                parameters.Add("@hasta", ajuste.hasta);
                parameters.Add("@delta", ajuste.delta);


                con.Execute("spAjusteLectoraModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public string EliminarAjuste(int iAjuste)
        {

            int icantFilas;

            try
            {

                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@id", iAjuste);

                    icantFilas = con.Execute("spAjusteLectoraEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar el ajuste. Existen datos cargados asociados a la misma.";
                else
                    return "Error en la base de datos.";

            }

            return "";
        }

    }
}
