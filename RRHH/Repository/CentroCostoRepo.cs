using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class CentroCostoRepo : ICentroCostoRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(CentroCosto centroCosto)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", centroCosto.descripcion);


                icantFilas = con.Execute("spCentroCostoInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(CentroCosto centroCosto)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", centroCosto.id);
                parameters.Add("@descripcion", centroCosto.descripcion);


                con.Execute("spCentroCostoModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<CentroCosto> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<CentroCosto>("spCentroCostoObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public CentroCosto Obtener(int iCentroCosto)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iCentroCosto);

                return con.QuerySingle<CentroCosto>("spCentroCostoObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iCentroCosto)
        {

            int icantFilas;
            try
            {

                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@id", iCentroCosto);

                    icantFilas = con.Execute("spCentroCostoEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar el centro de costo. Existen datos cargados asociados al mismo.";
                else
                    return "Error en la base de datos.";

            }

            return "";
        }
    }
}