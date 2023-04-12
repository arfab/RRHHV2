using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class TurnoRepo: ITurnoRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        public string Insertar(Turno turno)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@ubicacion_id", turno.ubicacion_id == -1 ? null : turno.ubicacion_id);
                parameters.Add("@descripcion", turno.descripcion);
                parameters.Add("@horas_diarias", turno.horas_diarias <= 0 ? null : turno.horas_diarias);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spTurnoInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar el turno";


            }
            return "";
        }


        public string Modificar(Turno turno)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", turno.id);
                parameters.Add("@ubicacion_id", turno.ubicacion_id == -1 ? null : turno.ubicacion_id);
                parameters.Add("@descripcion", turno.descripcion);
                parameters.Add("@horas_diarias", turno.horas_diarias <=0 ? null : turno.horas_diarias);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spTurnoModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al modificar el horario";


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

                icantFilas = con.Execute("spTurnoEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public Turno Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Turno>("spTurnoObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<Turno> ObtenerTodos(int? ubicacion_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@ubicacion_id", (ubicacion_id == null) ? -1 : ubicacion_id.Value);

                return con.Query<Turno>("spTurnoObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


    }
}
