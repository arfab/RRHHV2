using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class FichadaRepo : IFichadaRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();


        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@equipo_id", -1);
                parameter.Add("@nro_legajo", nro_legajo);
                parameter.Add("@tipo", "");
                parameter.Add("@fecha_desde", (fecha_desde.Year < 1000) ? null : fecha_desde);
                parameter.Add("@fecha_hasta", (fecha_hasta.Year < 1000) ? null : fecha_hasta);

                IEnumerable<Fichada> lFichadas;
                lFichadas = con.Query<Fichada>("spFichadaAgrupadaObtener", parameter, commandType: CommandType.StoredProcedure).ToList();

                foreach(Fichada item in lFichadas)
                {
                    if (item.tipo1=="E" && item.tipo2=="S")
                    {
                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;
                    }

                    if (item.tipo3 == "E" && item.tipo4 == "S")
                    {
                        item.hora_entrada_2 = item.lec3;
                        item.hora_salida_2 = item.lec4;
                    }

                }

                return lFichadas;
            }

        }
    }
}
