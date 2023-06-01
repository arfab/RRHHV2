using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

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
                parameters.Add("@concepto", legajoHorario.concepto);
                parameters.Add("@fecha", legajoHorario.fecha);
                parameters.Add("@desde", legajoHorario.desde);
                parameters.Add("@hasta", legajoHorario.hasta);
                parameters.Add("@desde2", legajoHorario.desde2 == "" ? null : legajoHorario.desde2);
                parameters.Add("@hasta2", legajoHorario.hasta2 == "" ? null : legajoHorario.hasta2);
                parameters.Add("@cantidad_horas", legajoHorario.cantidad_horas == -1 ? null : legajoHorario.cantidad_horas);

                parameters.Add("@estado", legajoHorario.estado);
                parameters.Add("@usuario_id", legajoHorario.usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spLegajoHorarioInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Ya hay un horario cargado en ese fecha";


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
                parameters.Add("@concepto", legajoHorario.concepto);
                parameters.Add("@fecha", legajoHorario.fecha);
                parameters.Add("@desde", legajoHorario.desde);
                parameters.Add("@hasta", legajoHorario.hasta);
                parameters.Add("@desde2", legajoHorario.desde2 == "" ? null : legajoHorario.desde2);
                parameters.Add("@hasta2", legajoHorario.hasta2 == "" ? null : legajoHorario.hasta2);
                parameters.Add("@cantidad_horas", legajoHorario.cantidad_horas == -1 ? null : legajoHorario.cantidad_horas);


                parameters.Add("@estado", legajoHorario.estado);
                parameters.Add("@usuario_id", legajoHorario.usuario_id);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spLegajoHorarioModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Ya hay un horario cargado en ese fecha";

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


        public string CopiarSemana(int legajo_id, DateTime fecha_desde)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajo_id);
                parameters.Add("@fecha", (fecha_desde.Year < 1000) ? null : fecha_desde);


                icantFilas = con.Execute("spLegajoHorarioCopiarSemana", parameters, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public string ValidarSemana(int legajo_id, DateTime fecha_desde)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajo_id);
                parameters.Add("@fecha", (fecha_desde.Year < 1000) ? null : fecha_desde);


                icantFilas = con.Execute("spLegajoHorarioValidarSemana", parameters, commandType: CommandType.StoredProcedure);


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


        public IEnumerable<LegajoHorario> ObtenerPorLegajo(int legajo_id, DateTime fecha_desde)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);
                parameter.Add("@fecha", (fecha_desde.Year < 1000) ? null : fecha_desde);


                return con.Query<LegajoHorario>("spLegajoHorarioObtenerPorLegajo", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }


        public string Semana(DateTime fecha)
        {
            DayOfWeek fdow = CultureInfo.CurrentCulture.DateTimeFormat.FirstDayOfWeek;
            int offset = fdow - fecha.DayOfWeek;
            DateTime fdowDate = fecha.AddDays(offset+1);

            DateTime ldowDate = fdowDate.AddDays(6);

            return "Semana del " + fdowDate.Day + "/" + fdowDate.Month + " al " + ldowDate.Day + "/" + ldowDate.Month + " de " + fecha.Year;
        }


    }
}
