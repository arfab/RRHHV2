using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class LegajoHorasRepo:ILegajoHorasRepo
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        public string Insertar(int legajo_id, LegajoHoras legajoHoras)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@legajo_id", legajo_id);
                parameters.Add("@fecha_desde", legajoHoras.fecha_desde);
                parameters.Add("@fecha_hasta", legajoHoras.fecha_hasta);
                parameters.Add("@tipo", legajoHoras.tipo);
                parameters.Add("@habilitado", legajoHoras.habilitado);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                icantFilas = con.Execute("spLegajoHorasInsertar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al insertar la autorización de horas extra del legajo";


            }
            return "";
        }


        public string Modificar(LegajoHoras legajoHoras)
        {

            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", legajoHoras.id);
                parameters.Add("@fecha_desde", legajoHoras.fecha_desde);
                parameters.Add("@fecha_hasta", legajoHoras.fecha_hasta);
                parameters.Add("@tipo", legajoHoras.tipo);
                parameters.Add("@habilitado", legajoHoras.habilitado);
                parameters.Add("@retValue", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);


                con.Execute("spLegajoHorasModificar", parameters, commandType: CommandType.StoredProcedure);

                if (parameters.Get<int>("@retValue") == -1) return "Error al modificar la autorización de horas extra del legajo";


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

                icantFilas = con.Execute("spLegajoHorasEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

        public LegajoHoras Obtener(int id)
        {


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", id);

                return con.QuerySingleOrDefault<LegajoHoras>("spLegajoHorasObtener", parameter, commandType: CommandType.StoredProcedure);
            }
        }


        public IEnumerable<LegajoHoras> ObtenerTodos(int legajo_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@legajo_id", legajo_id);

                return con.Query<LegajoHoras>("spLegajoHorasObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

    }
}
