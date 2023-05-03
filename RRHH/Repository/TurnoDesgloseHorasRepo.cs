using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class TurnoDesgloseHorasRepo:ITurnoDesgloseHorasRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        public string Insertar(int turno_id, TurnoDesgloseHoras turnoDesgloseHoras)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@turno_id", turno_id);
                parameters.Add("@cantidad_dias", turnoDesgloseHoras.cantidad_dias);
                parameters.Add("@cantidad_horas_dia", turnoDesgloseHoras.cantidad_horas_dia);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spTurnoDesgloseHorasInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar el desglose de horas del turno";


            }
            return "";
        }


        public string Modificar(TurnoDesgloseHoras turnoDesgloseHoras)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", turnoDesgloseHoras.id);
                parameters.Add("@cantidad_dias", turnoDesgloseHoras.cantidad_dias);
                parameters.Add("@cantidad_horas_dia", turnoDesgloseHoras.cantidad_horas_dia);

                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spTurnoDesgloseHorasModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al modificar el desglose de horas del turno";


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

                icantFilas = con.Execute("spTurnoDesgloseHorasEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public TurnoDesgloseHoras Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<TurnoDesgloseHoras>("spTurnoDesgloseHorasObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<TurnoDesgloseHoras> ObtenerTodos(int turno_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@turno_id", turno_id);

                return con.Query<TurnoDesgloseHoras>("spTurnoDesgloseHorasObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

    }
}
