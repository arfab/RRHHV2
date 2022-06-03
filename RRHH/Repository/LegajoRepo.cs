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
                parameters.Add("@dni", legajo.dni);
                parameters.Add("@genero_id", legajo.genero_id);
                parameters.Add("@empresa_id", legajo.empresa_id);
                parameters.Add("@ubicacion_id", legajo.ubicacion_id);
                parameters.Add("@sector_id", legajo.sector_id);
                parameters.Add("@local_id", legajo.local_id);
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
                parameters.Add("@id", legajo.id);
                parameters.Add("@nro_legajo", legajo.nro_legajo);
                parameters.Add("@apellido", legajo.apellido);
                parameters.Add("@nombre", legajo.nombre);
                parameters.Add("@dni", legajo.dni);
                parameters.Add("@genero_id", legajo.genero_id);
                parameters.Add("@empresa_id", legajo.empresa_id);
                parameters.Add("@ubicacion_id", legajo.ubicacion_id);
                parameters.Add("@sector_id", legajo.sector_id);
                parameters.Add("@local_id", legajo.local_id);
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

        public Legajo Obtener(int id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<Legajo>("spLegajoObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public Legajo ObtenerPorNro(int empresa_id, int iNroLegajo)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@nro_legajo", iNroLegajo);
                parameter.Add("@empresa_id", empresa_id);

                return con.QuerySingleOrDefault<Legajo>("spLegajoObtenerPorNro", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public Legajo ObtenerDeImportacion(string nro_legajo, string apellido, string nombre, string empresa, string sector, string categoria, string funcion, string fecha_alta, string fecha_baja, string observacion)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@apellido", apellido);
                parameter.Add("@nombre", nombre);
                parameter.Add("@empresa", empresa);
                parameter.Add("@sector", sector);
                parameter.Add("@categoria", categoria);
                parameter.Add("@funcion", funcion);
                parameter.Add("@str_fecha_ingreso", fecha_alta);
                parameter.Add("@str_fecha_baja", fecha_baja);
                parameter.Add("@observacion", observacion);
                parameter.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                return con.QuerySingleOrDefault<Legajo>("spLegajoObtenerDeImportacion", parameter, commandType: CommandType.StoredProcedure);

               // if (parameter.Get<int>("@retValue") < 0) return "Error al importar";

            }

        }

        public string Eliminar(int id)
        {

            try
            {
                int icantFilas;
                using (var con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameters2 = new DynamicParameters();
                    parameters2.Add("@id", id);

                    icantFilas = con.Execute("spLegajoEliminar", parameters2, commandType: CommandType.StoredProcedure);


                }
            }
            catch
            {
            }
            return "";
        }
    }
}
