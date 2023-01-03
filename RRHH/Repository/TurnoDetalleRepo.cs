using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class TurnoDetalleRepo:ITurnoDetalleRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        public string Insertar(int turno_id, TurnoDetalle turnoDetalle)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@turno_id", turno_id);
                parameters.Add("@tipo_hora_id", turnoDetalle.tipo_hora_id);
                parameters.Add("@tipo_dia_semana_id", turnoDetalle.tipo_dia_semana_id);
                parameters.Add("@hora_desde", turnoDetalle.hora_desde);
                parameters.Add("@hora_hasta", turnoDetalle.hora_hasta);
                parameters.Add("@almuerzo", turnoDetalle.almuerzo);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spTurnoDetalleInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar el detalle del turno";


            }
            return "";
        }


        public string Modificar(TurnoDetalle turnoDetalle)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", turnoDetalle.id);
                parameters.Add("@tipo_hora_id", turnoDetalle.tipo_hora_id);
                parameters.Add("@tipo_dia_semana_id", turnoDetalle.tipo_dia_semana_id);
                parameters.Add("@hora_desde", turnoDetalle.hora_desde);
                parameters.Add("@hora_hasta", turnoDetalle.hora_hasta);
                parameters.Add("@almuerzo", turnoDetalle.almuerzo);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spTurnoDetalleModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al modificar el detalle del turno";


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

                icantFilas = con.Execute("spTurnoDetalleEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public TurnoDetalle Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<TurnoDetalle>("spTurnoDetalleObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<TurnoDetalle> ObtenerTodos(int turno_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@turno_id", turno_id);

                return con.Query<TurnoDetalle>("spTurnoDetalleObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
