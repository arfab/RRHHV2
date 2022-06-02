using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class LegajoRepo:ILegajoRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Legajo legajo)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@nro_legajo", legajo.nro_legajo);
                parameters.Add("@apellido", legajo.apellido);
                parameters.Add("@nombre", legajo.nombre);
                parameters.Add("@empresa_id", legajo.empresa_id);
                parameters.Add("@sector_id", legajo.sector_id);
                parameters.Add("@categoria_id", legajo.categoria_id);
                parameters.Add("@funcion_id", (legajo.funcion_id <= 0) ? null : legajo.funcion_id);
                parameters.Add("@observacion", legajo.observacion);
                parameters.Add("@activo", 1);
                parameters.Add("@fecha_alta", legajo.fecha_alta);
                parameters.Add("@fecha_baja", legajo.fecha_baja);


                icantFilas = con.Execute("spLegajoInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Legajo legajo)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@nro_legajo", legajo.nro_legajo);
                parameters.Add("@apellido", legajo.apellido);
                parameters.Add("@nombre", legajo.nombre);
                parameters.Add("@empresa_id", legajo.empresa_id);
                parameters.Add("@sector_id", legajo.sector_id);
                parameters.Add("@categoria_id", legajo.categoria_id);
                parameters.Add("@funcion_id", (legajo.funcion_id<=0)?null:legajo.funcion_id);
                parameters.Add("@observacion", legajo.observacion);
                parameters.Add("@activo", 1);
                parameters.Add("@fecha_alta", legajo.fecha_alta);
                parameters.Add("@fecha_baja", legajo.fecha_baja);


                con.Execute("spLegajoModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Legajo> ObtenerTodos(int iNroLegajo, string sApellido)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@nro_legajo", iNroLegajo);
                parameter.Add("@apellido", sApellido);


                return con.Query<Legajo>("spLegajoObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Legajo Obtener(int iNroLegajo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@nro_legajo", iNroLegajo);

                return con.QuerySingleOrDefault<Legajo>("spLegajoObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iNroLegajo)
        {

            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@nro_legajo", iNroLegajo);

                icantFilas = con.Execute("spLegajoEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }
    }
}
