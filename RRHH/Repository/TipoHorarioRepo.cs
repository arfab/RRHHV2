using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class TipoHorarioRepo: ITipoHorarioRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();


        public string Insertar(TipoHorario tipoHorario)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@ubicacion_id", tipoHorario.ubicacion_id == -1 ? null : tipoHorario.ubicacion_id);
                parameters.Add("@sector_id", tipoHorario.sector_id == -1 ? null : tipoHorario.sector_id);
                parameters.Add("@local_id", tipoHorario.local_id == -1 ? null : tipoHorario.local_id);
                parameters.Add("@legajo_id", tipoHorario.legajo_id == -1 ? null : tipoHorario.legajo_id);
                parameters.Add("@tipo_hora_id", tipoHorario.tipo_hora_id);
                parameters.Add("@tipo_dia_semana_id", tipoHorario.tipo_dia_semana_id);
                parameters.Add("@hora_desde", tipoHorario.hora_desde);
                parameters.Add("@hora_hasta", tipoHorario.hora_hasta);
                parameters.Add("@fecha_desde", tipoHorario.fecha_desde);
                parameters.Add("@fecha_hasta", tipoHorario.fecha_hasta);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spTipoHorarioInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar el horario";


            }
            return "";
        }


        public string Modificar(TipoHorario tipoHorario)
        {
           
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", tipoHorario.id);
                parameters.Add("@ubicacion_id", tipoHorario.ubicacion_id == -1 ? null : tipoHorario.ubicacion_id);
                parameters.Add("@sector_id", tipoHorario.sector_id == -1 ? null : tipoHorario.sector_id);
                parameters.Add("@local_id", tipoHorario.local_id == -1 ? null : tipoHorario.local_id);
                parameters.Add("@legajo_id", tipoHorario.legajo_id==-1?null:tipoHorario.legajo_id);
                parameters.Add("@tipo_hora_id", tipoHorario.tipo_hora_id);
                parameters.Add("@tipo_dia_semana_id", tipoHorario.tipo_dia_semana_id);
                parameters.Add("@hora_desde", tipoHorario.hora_desde);
                parameters.Add("@hora_hasta", tipoHorario.hora_hasta);
                parameters.Add("@fecha_desde", tipoHorario.fecha_desde);
                parameters.Add("@fecha_hasta", tipoHorario.fecha_hasta);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


               con.Execute("spTipoHorarioModificar", parameters, commandType: CommandType.StoredProcedure);

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

                icantFilas = con.Execute("spTipoHorarioEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public TipoHorario Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<TipoHorario>("spTipoHorarioObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<TipoHorario> ObtenerTodos(int? ubicacion_id, int? sector_id, int? legajo_id, int? tipo_hora_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@ubicacion_id", (ubicacion_id==null)?-1:ubicacion_id.Value);
                parameter.Add("@sector_id", (sector_id == null) ? -1 : sector_id.Value);
                parameter.Add("@legajo_id", (legajo_id == null) ? -1 : legajo_id.Value);
                parameter.Add("@tipo_hora_id", (tipo_hora_id == null) ? -1 : tipo_hora_id.Value);

                return con.Query<TipoHorario>("spTipoHorarioObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }




    }
}
