using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class TurnoHorasRepo: ITurnoHorasRepo
    {


        static readonly string strConnectionString = Tools.GetConnectionString();


        public string Insertar(int turno_id, TurnoHoras turnoHoras)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@turno_id", turno_id);
                parameters.Add("@fecha_desde", turnoHoras.fecha_desde);
                parameters.Add("@fecha_hasta", turnoHoras.fecha_hasta);
                parameters.Add("@tipo", turnoHoras.tipo);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spTurnoHorasInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar la autorización de horas extra del turno";


            }
            return "";
        }


        public string Modificar(TurnoHoras turnoHoras)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", turnoHoras.id);
                parameters.Add("@fecha_desde", turnoHoras.fecha_desde);
                parameters.Add("@fecha_hasta", turnoHoras.fecha_hasta);
                parameters.Add("@tipo", turnoHoras.tipo);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spTurnoHorasModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al modificar la autorización de horas extra del turno";


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

                icantFilas = con.Execute("spTurnoHorasEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public TurnoHoras Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<TurnoHoras>("spTurnoHorasObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<TurnoHoras> ObtenerTodos(int turno_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@turno_id", turno_id);

                return con.Query<TurnoHoras>("spTurnoHorasObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

    }
}
