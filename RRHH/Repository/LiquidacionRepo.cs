using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class LiquidacionRepo:ILiquidacionRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public Liquidacion Obtener(Int64 id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Liquidacion>("spLiquidacionObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }

        public IEnumerable<Liquidacion> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();

                return con.Query<Liquidacion>("spLiquidacionObtenerTodos",  commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public IEnumerable<LiquidacionDetalle> ObtenerDetalle(int anio, int mes, int empresa_id, int ubicacion_id, int sector_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@anio", anio);
                parameter.Add("@mes", mes);
                parameter.Add("@empresa_id", (empresa_id == 0) ? -1 : empresa_id);
                parameter.Add("@ubicacion_id", (ubicacion_id == 0) ? -1 : ubicacion_id);
                parameter.Add("@sector_id", (sector_id == 0) ? -1 : sector_id);
                parameter.Add("@legajo_id", (legajo_id == 0) ? -1 : legajo_id);
                //parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? DateTime.Now : fecha_desde);
                //parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? DateTime.Now : fecha_hasta);

                return con.Query<LiquidacionDetalle>("spLiquidacionDetalleObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }



        public string Generar(int empresa_id, int ubicacion_id, int sector_id, int legajo_id, int usuario_id)
        {
            int icantFilas;

            try
            {
                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters = new DynamicParameters();
                    parameters.Add("@empresa_id", (empresa_id == 0) ? -1 : empresa_id);
                    parameters.Add("@ubicacion_id", (ubicacion_id == 0) ? -1 : ubicacion_id);
                    parameters.Add("@sector_id", (sector_id == 0) ? -1 : sector_id);
                    parameters.Add("@legajo_id", (legajo_id == 0) ? -1 : legajo_id);
                    parameters.Add("@usuario_id", (usuario_id == 0) ? -1 :usuario_id);
                    parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                    icantFilas = con.Execute("spGenerarLiquidacion", parameters, commandType: CommandType.StoredProcedure);
                    if (parameters.Get<int>("@retValue") < 0) return "Error al generar la liquidación";


                }
            }
            catch (SqlException e)
            {
                return "Error";
            }
            return "";
        }


        public string Cerrar(int usuario_id)
        {
            int icantFilas;

            try
            {
                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters = new DynamicParameters();
                    parameters.Add("@usuario_id", (usuario_id == 0) ? -1 : usuario_id);
                    parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                    icantFilas = con.Execute("spCerrarLiquidacion", parameters, commandType: CommandType.StoredProcedure);
                    if (parameters.Get<int>("@retValue") == -2) return "No se puede cerrar la liquidacion del mes en curso";
                    if (parameters.Get<int>("@retValue") < 0) return "Error al cerrar la liquidacion";


                }
            }
            catch (SqlException e)
            {
                return "Error";
            }
            return "";
        }


        public string Modificar(Liquidacion liquidacion)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", liquidacion.id);
                parameters.Add("@desde", liquidacion.desde);
                parameters.Add("@hasta", liquidacion.hasta);

                con.Execute("spLiquidacionModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

    }
}
