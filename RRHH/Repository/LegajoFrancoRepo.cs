using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class LegajoFrancoRepo: ILegajoFrancoRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(int legajo_id, LegajoFranco legajoFranco)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajoFranco.legajo_id);
                parameters.Add("@fecha", legajoFranco.fecha);
                parameters.Add("@completo", legajoFranco.completo);
                parameters.Add("@estado", legajoFranco.estado);
                parameters.Add("@usuario_id", legajoFranco.usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spLegajoFrancoInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar";


            }
            return "";
        }

        public string Modificar(LegajoFranco legajoFranco)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", legajoFranco.id);
                parameters.Add("@fecha", legajoFranco.fecha);
                parameters.Add("@completo", legajoFranco.completo);
                parameters.Add("@estado", legajoFranco.estado);
                parameters.Add("@usuario_id", legajoFranco.usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spLegajoFrancoModificar", parameters, commandType: CommandType.StoredProcedure);

                // if (parameters.Get<int>("@retValue") < 0) return "El legajo no existe";

            }
            return "";
        }

        public string Eliminar(int id)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", id);

                icantFilas = con.Execute("spLegajoFrancoEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public LegajoFranco Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<LegajoFranco>("spLegajoFrancoObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<LegajoFranco> ObtenerPorLegajo(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);


                return con.Query<LegajoFranco>("spLegajoFrancoObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

      


    }
}
