using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class LegajoFichadaRepo:ILegajoFichadaRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(LegajoFichada legajoFichada)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajoFichada.legajo_id);
                parameters.Add("@lectora_id", legajoFichada.lectora_id);
                parameters.Add("@fecha", legajoFichada.fecha);
                parameters.Add("@entrada1", legajoFichada.entrada_1);
                parameters.Add("@salida1", legajoFichada.salida_1);
                parameters.Add("@entrada2", legajoFichada.entrada_2);
                parameters.Add("@salida2", legajoFichada.salida_2);
                parameters.Add("@entrada3", legajoFichada.entrada_3);
                parameters.Add("@salida3", legajoFichada.salida_3);
                parameters.Add("@entrada4", legajoFichada.entrada_4);
                parameters.Add("@salida4", legajoFichada.salida_4);
                parameters.Add("@horas_normales", legajoFichada.horas_normales);
                parameters.Add("@horas_50", legajoFichada.horas_50);
                parameters.Add("@horas_100", legajoFichada.horas_100);
                parameters.Add("@validado", legajoFichada.validado);

                icantFilas = con.Execute("spLegajoFichadaInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(LegajoFichada legajoFichada)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", legajoFichada.id);
                parameters.Add("@fecha", legajoFichada.fecha);
                parameters.Add("@entrada1", legajoFichada.entrada_1);
                parameters.Add("@salida1", legajoFichada.salida_1);
                parameters.Add("@entrada2", legajoFichada.entrada_2);
                parameters.Add("@salida2", legajoFichada.salida_2);
                parameters.Add("@entrada3", legajoFichada.entrada_3);
                parameters.Add("@salida3", legajoFichada.salida_3);
                parameters.Add("@entrada4", legajoFichada.entrada_4);
                parameters.Add("@salida4", legajoFichada.salida_4);
                parameters.Add("@horas_normales", legajoFichada.horas_normales);
                parameters.Add("@horas_50", legajoFichada.horas_50);
                parameters.Add("@horas_100", legajoFichada.horas_100);

                con.Execute("spLegajoFichadaModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public string Eliminar(int iID)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

               

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", iID);

                con.Execute("spLegajoFichadaEliminar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<LegajoFichada> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<LegajoFichada>("spLegajoFichadaObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public LegajoFichada Obtener(int iID)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iID);

                return con.QuerySingle<LegajoFichada>("spLegajoFichadaObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }


        public LegajoFichada ObtenerPorLegajo(int legajo_id, String fecha)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);
                parameter.Add("@fecha", Convert.ToDateTime(fecha));

                return con.QuerySingleOrDefault<LegajoFichada>("spLegajoFichadaObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure);
            }

        }


    }
}
