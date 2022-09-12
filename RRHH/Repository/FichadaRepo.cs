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

                IUtilsRepo iUtilsRepo;
                iUtilsRepo = new UtilsRepo();

                string valor = iUtilsRepo.ObtenerParametro("MINUTOS_DOBLE_FICHADA");

                int minutos_doble = valor == "" ? 0 : Int32.Parse(valor);



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

                foreach (Fichada item in lFichadas)
                {


                    ILectoraRepo iLectoraRepo;
                    iLectoraRepo = new LectoraRepo();

                    // Se obtiene el valor del delta en el caso de que la lectora tenga una ajuste en la fecha
                    // Por ahora lo comento
                    // int iDelta = iLectoraRepo.ObtenerAjuste(item.lectora_id.Value, item.fecha.Value);
                    // Ojo porque solo debería ajustarse para los valores originales. No si se hace una edición!


                    // Ver fichadas dobles

                    String[] vLectura = new String[6];
                    String[] vTipo = new String[6];
                    vLectura[0] = item.lec1;
                    vLectura[1] = item.lec2;
                    vLectura[2] = item.lec3;
                    vLectura[3] = item.lec4;
                    vLectura[4] = item.lec5;
                    vLectura[5] = item.lec6;
                    vTipo[0] = item.tipo1;
                    vTipo[1] = item.tipo2;
                    vTipo[2] = item.tipo3;
                    vTipo[3] = item.tipo4;
                    vTipo[4] = item.tipo5;
                    vTipo[5] = item.tipo6;


                  

                         
                    for (int i=0; i < 5; i++)
                    {
                        if (vLectura[i] == null || vLectura[i + 1] == null ||  vLectura[i] == "" || vLectura[i+1] == "") continue;

                        var dif = (DateTime.Parse(vLectura[i+1]) - DateTime.Parse(vLectura[i])).TotalSeconds;
                        if (dif < minutos_doble*60)
                        {
                            for (int j = i+1; j < 5; j++)
                            {
                                if (vLectura[j] != null)
                                {
                                    vLectura[j] = vLectura[j + 1];
                                    vTipo[j] = vTipo[j + 1];
                                }
                               
                            }
                            vLectura[5] = "";
                            vTipo[5] = "";
                            i = 0;
                        }

                    }

                    //item.lec1 = vLectura[0]==""?null:vLectura[0];                  
                    //item.lec2 = vLectura[1] == "" ? null : vLectura[1];
                    //item.lec3 = vLectura[2] == "" ? null : vLectura[2];
                    //item.lec4 = vLectura[3] == "" ? null : vLectura[3];
                    //item.lec5 = vLectura[4] == "" ? null : vLectura[4];
                    //item.lec6 = vLectura[5] == "" ? null : vLectura[5];


                    item.lec1 = CalcularHora(vLectura[0], item.delta.Value);
                    item.lec2 = CalcularHora(vLectura[1], item.delta.Value);
                    item.lec3 = CalcularHora(vLectura[2], item.delta.Value);
                    item.lec4 = CalcularHora(vLectura[3], item.delta.Value);
                    item.lec5 = CalcularHora(vLectura[4], item.delta.Value);
                    item.lec6 = CalcularHora(vLectura[5], item.delta.Value);


                    item.tipo1 = vTipo[0] == "" ? null : vTipo[0];
                    item.tipo2 = vTipo[1] == "" ? null : vTipo[1];
                    item.tipo3 = vTipo[2] == "" ? null : vTipo[2];
                    item.tipo4 = vTipo[3] == "" ? null : vTipo[3];
                    item.tipo5 = vTipo[4] == "" ? null : vTipo[4];
                    item.tipo6 = vTipo[5] == "" ? null : vTipo[5];


                    //if (item.lec1 != null && item.lec2 != null)
                    //{
                    //    var difLec = (DateTime.Parse(item.lec2) - DateTime.Parse(item.lec1)).TotalSeconds;

                    //    if (difLec< 120)
                    //    {
                    //        item.lec2 = item.lec3;
                    //        item.lec3 = item.lec4;
                    //        item.lec4 = item.lec5;
                    //        item.lec5 = item.lec6;
                    //        item.lec6 = null;
                    //        item.tipo2 = item.tipo3;
                    //        item.tipo3 = item.tipo4;
                    //        item.tipo4 = item.tipo5;
                    //        item.tipo5 = item.tipo6;
                    //        item.tipo6 = null;
                    //    }
                    //}

                    //if (item.lec2 != null && item.lec3 != null)
                    //{
                    //    var difLec = (DateTime.Parse(item.lec3) - DateTime.Parse(item.lec2)).TotalSeconds;

                    //    if (difLec < 120)
                    //    {
                    //        item.lec3 = item.lec4;
                    //        item.lec4 = item.lec5;
                    //        item.lec5 = item.lec6;
                    //        item.lec6 = null;
                    //        item.tipo3 = item.tipo4;
                    //        item.tipo4 = item.tipo5;
                    //        item.tipo5 = item.tipo6;
                    //        item.tipo6 = null;
                    //    }
                    //}

                    //if (item.lec3 != null && item.lec4 != null)
                    //{
                    //    var difLec = (DateTime.Parse(item.lec4) - DateTime.Parse(item.lec3)).TotalSeconds;

                    //    if (difLec < 120)
                    //    {
                    //        item.lec4 = item.lec5;
                    //        item.lec5 = item.lec6;
                    //        item.lec6 = null;
                    //        item.tipo4 = item.tipo5;
                    //        item.tipo5 = item.tipo6;
                    //        item.tipo6 = null;
                    //    }
                    //}

                    //if (item.lec4 != null && item.lec5 != null)
                    //{
                    //    var difLec = (DateTime.Parse(item.lec5) - DateTime.Parse(item.lec4)).TotalSeconds;

                    //    if (difLec < 120)
                    //    {
                    //        item.lec5 = item.lec6;
                    //        item.lec6 = null;
                    //        item.tipo5 = item.tipo6;
                    //        item.tipo6 = null;
                    //    }
                    //}

                    //if (item.lec5 != null && item.lec6 != null)
                    //{
                    //    var difLec = (DateTime.Parse(item.lec6) - DateTime.Parse(item.lec5)).TotalSeconds;

                    //    if (difLec < 120)
                    //    {
                    //        item.lec6 = null;
                    //        item.tipo6 = null;
                    //    }
                    //}

                    if (item.tipo1 == null)
                    {
                        if (item.justificacion == "")
                            item.estado = "NO";
                        else
                            item.estado = "JUS";
                    }
                    else
                        item.estado = "OK";


                    if (item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null)
                    {
                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;
                        item.hora_entrada_2 = item.lec3;
                        item.hora_salida_2 = item.lec4;

                        DateTime entrada1 = DateTime.Parse(item.lec1);
                        DateTime salida1 = DateTime.Parse(item.lec2);

                        TimeSpan span1 = salida1.Subtract(entrada1);

                        DateTime entrada2 = DateTime.Parse(item.lec3);
                        DateTime salida2 = DateTime.Parse(item.lec4);

                        TimeSpan span2 = salida2.Subtract(entrada2);
                        span1 += span2;
                        item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');



                    }
                    else if (item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 == null)
                    {
                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;

                        DateTime entrada1 = DateTime.Parse(item.lec1);
                        DateTime salida1 = DateTime.Parse(item.lec2);

                        TimeSpan span1 = salida1.Subtract(entrada1);


                        DateTime entradaAux = DateTime.Parse(item.lec2);
                        DateTime salidaAux = DateTime.Parse(item.lec3);

                        TimeSpan spanAux = salidaAux.Subtract(entradaAux);

                        if (spanAux.Hours < 2)
                            item.hora_entrada_2 = item.lec3;
                        else
                            item.hora_salida_2 = item.lec3;

                        item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');

                        item.estado = "ERR";

                    }
                    else if (item.tipo1 != null && item.tipo2 != null && item.tipo3 == null && item.tipo4 == null)
                    {
                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;

                        DateTime entrada1 = DateTime.Parse(item.lec1);
                        DateTime salida1 = DateTime.Parse(item.lec2);

                        TimeSpan span1 = salida1.Subtract(entrada1);


                        item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');


                    }
                    else if (item.tipo1 != null && item.tipo2 == null && item.tipo3 == null && item.tipo4 == null)
                    {
                        if (item.tipo1 == "E")
                            item.hora_entrada_1 = item.lec1;
                        else
                            item.hora_salida_1 = item.lec1;

                        item.estado = "ERR";

                    }

                    else
                    {
                        if (item.estado!="NO" && item.estado != "JUS")
                            item.estado = "ERR";
                    }

                  

                }

                return lFichadas;
                
            }

        }

        string? CalcularHora(string hora, int delta)
        {
            if (hora == "" || hora==null) return null;

            if (delta==0) return hora;

            DateTime d;
            DateTime.TryParse(hora, out d);
            d = d.AddMinutes(delta);
            return d.ToString("HH:mm:ss");

        }
    }
}
