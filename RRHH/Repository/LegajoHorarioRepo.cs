using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class LegajoHorarioRepo: ILegajoHorarioRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(int legajo_id, LegajoHorario legajoHorario)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajoHorario.legajo_id);
                parameters.Add("@fecha", legajoHorario.fecha);
                parameters.Add("@desde", legajoHorario.desde);
                parameters.Add("@hasta", legajoHorario.hasta);
                parameters.Add("@estado", legajoHorario.estado);
                parameters.Add("@usuario_id", legajoHorario.usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spLegajoHorarioInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar";


            }
            return "";
        }

        public string Modificar(LegajoHorario legajoHorario)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", legajoHorario.id);
                parameters.Add("@fecha", legajoHorario.fecha);
                parameters.Add("@desde", legajoHorario.desde);
                parameters.Add("@hasta", legajoHorario.hasta);
                parameters.Add("@estado", legajoHorario.estado);
                parameters.Add("@usuario_id", legajoHorario.usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spLegajoHorarioModificar", parameters, commandType: CommandType.StoredProcedure);

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

                icantFilas = con.Execute("spLegajoHorarioEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public LegajoHorario Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<LegajoHorario>("spLegajoHorarioObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<LegajoHorario> ObtenerPorLegajo(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);


                return con.Query<LegajoHorario>("spLegajoHorarioObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
