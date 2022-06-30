using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class FichadaRepo : IFichadaRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();


        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int tipo_listado)
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
                parameter.Add("@tipo_listado", tipo_listado);

                parameter.Add("@empresa_id", empresa_id);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector_id", sector_id);



                IEnumerable<Fichada> lFichadas;
                lFichadas = con.Query<Fichada>("spFichadaAgrupadaObtener", parameter, commandType: CommandType.StoredProcedure).ToList();

                foreach(Fichada item in lFichadas)
                {



                    if (item.tipo1 == null)
                    {
                        if (item.justificacion == "")
                            item.estado = "NO";
                        else
                            item.estado = "JUS";
                    }
                    else
                        item.estado = "OK";

                    if (item.tipo1=="E" && item.tipo2=="S")
                    {
                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;

                        DateTime entrada1 = DateTime.Parse(item.lec1);
                        DateTime salida1 = DateTime.Parse(item.lec2);

                        TimeSpan span1 = salida1.Subtract(entrada1);

                     

                        TimeSpan? span2=null;

                        if (item.tipo3 == "E" && item.tipo4 == "S")
                        {

                            item.hora_entrada_2 = item.lec3;
                            item.hora_salida_2 = item.lec4;


                            DateTime entrada2 = DateTime.Parse(item.lec3);
                            DateTime salida2 = DateTime.Parse(item.lec4);

                            span2 = salida2.Subtract(entrada2);


                        }
                        else
                        {
                            if (item.tipo3 == "E" && item.tipo4 != "S" ||
                                item.tipo4 == "S" && item.tipo3 != "E")
                            {
                                item.estado = "ERR";
                            }

                        }

                        if (span2!=null)
                        {
                            span1 += span2.Value;
                        }

                        item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');

                    }

                    else
                    {
                        if (item.tipo1 == "E" && item.tipo2 != "S" ||
                            item.tipo2 == "S" && item.tipo1 != "E")
                        {
                            item.estado = "ERR";
                        }

                    }

                   

                }

                return lFichadas;
            }

        }
    }
}
