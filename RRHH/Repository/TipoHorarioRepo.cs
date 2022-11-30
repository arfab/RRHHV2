using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class TipoHorarioRepo: ITipoHorarioRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

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
