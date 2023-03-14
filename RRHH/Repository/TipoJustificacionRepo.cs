using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class TipoJustificacionRepo:ITipoJustificacionRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(TipoJustificacion tipoJustificacion)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", tipoJustificacion.descripcion);
                parameters.Add("@observacion", tipoJustificacion.observacion);
                parameters.Add("@pago", tipoJustificacion.pago);
                parameters.Add("@mes_completo", tipoJustificacion.mes_completo);
                parameters.Add("@pre_presentismo", tipoJustificacion.pre_presentismo);
                parameters.Add("@pre_puntualidad", tipoJustificacion.pre_puntualidad);
                parameters.Add("@pre_horas", tipoJustificacion.pre_horas);

                icantFilas = con.Execute("spTipoJustificacionInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(TipoJustificacion tipoJustificacion)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", tipoJustificacion.id);
                parameters.Add("@descripcion", tipoJustificacion.descripcion);
                parameters.Add("@observacion", tipoJustificacion.observacion);
                parameters.Add("@pago", tipoJustificacion.pago);
                parameters.Add("@mes_completo", tipoJustificacion.mes_completo);
                parameters.Add("@pre_presentismo", tipoJustificacion.pre_presentismo);
                parameters.Add("@pre_puntualidad", tipoJustificacion.pre_puntualidad);
                parameters.Add("@pre_horas", tipoJustificacion.pre_horas);

                con.Execute("spTipoJustificacionModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<TipoJustificacion> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<TipoJustificacion>("spTipoJustificacionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public TipoJustificacion Obtener(int iTipoJustificacion)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iTipoJustificacion);

                return con.QuerySingle<TipoJustificacion>("spTipoJustificacionObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iTipoJustificacion)
        {

            int icantFilas;

            try
            {

                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@id", iTipoJustificacion);

                    icantFilas = con.Execute("spTipoJustificacionEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar el tipo de justificación. Existen datos cargados asociados al mismo.";
                else
                    return "Error en la base de datos.";

            }

            return "";
        }

    }
}
