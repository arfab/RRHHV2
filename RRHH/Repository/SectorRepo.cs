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


                con.Execute("spSectorModificar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<Sector> ObtenerTodos()
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                return con.Query<Sector>("spSectorObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
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
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters2 = new DynamicParameters();
                parameters2.Add("@id", iSector);

                icantFilas = con.Execute("spSectorEliminar", parameters2, commandType: CommandType.StoredProcedure);


            }

            return "";
        }

    }
}
