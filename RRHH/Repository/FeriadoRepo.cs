using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class FeriadoRepo: IFeriadoRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Feriado feriado)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@fecha", feriado.fecha);
                parameters.Add("@tipo", feriado.tipo);
                parameters.Add("@descripcion", feriado.descripcion);


                icantFilas = con.Execute("spFeriadoInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Feriado feriado)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", feriado.id);
                parameters.Add("@fecha", feriado.fecha);
                parameters.Add("@tipo", feriado.tipo);
                parameters.Add("@descripcion", feriado.descripcion);


                con.Execute("spFeriadoModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Feriado> ObtenerTodos(int iAnio, string sTipo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@anio", iAnio);
                parameters.Add("@tipo", sTipo);

                return con.Query<Feriado>("spFeriadoObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Feriado Obtener(int iFeriado)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iFeriado);

                return con.QuerySingle<Feriado>("spFeriadoObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public IEnumerable<int> ObtenerAnios()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<int>("spFeriadoObtenerAnios", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public string Eliminar(int iFeriado)
        {

            int icantFilas;
            try
            {
                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@id", iFeriado);

                    icantFilas = con.Execute("spFeriadoEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar el feriado. Existen datos cargados asociados al mismo.";
                else
                    return "Error en la base de datos.";

            }

            return "";
        }
    }
}
