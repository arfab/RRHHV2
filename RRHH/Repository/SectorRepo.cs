using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Repository
{
    public class SectorRepo:ISectorRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public string Insertar(Sector sector)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@descripcion", sector.descripcion);
                parameters.Add("@ubicacion_id", sector.ubicacion_id);


                icantFilas = con.Execute("spSectorInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string Modificar(Sector sector)
        {
       
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@id", sector.id);
                parameters.Add("@descripcion", sector.descripcion);
                parameters.Add("@ubicacion_id", sector.ubicacion_id);

                con.Execute("spSectorModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Sector> ObtenerTodos(int ubicacion_id)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@ubicacion_id", ubicacion_id);


                return con.Query<Sector>("spSectorObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();
            }

        }

        public Sector Obtener(int iSector)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@id", iSector);

                return con.QuerySingle<Sector>("spSectorObtener", parameter, commandType: CommandType.StoredProcedure);
            }

        }

        public string Eliminar(int iSector)
        {

            int icantFilas;
            try
            {
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iSector);

                icantFilas = con.Execute("spSectorEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }
            }
            catch (SqlException e)
            {
                if (e.Number == 547)
                    return "No se puede borrar al sector. Existen datos cargados asociados al mismo.";
                else
                    return "Error en la base de datos.";

            }
            return "";
        }

    }
}
