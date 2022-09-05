﻿using Dapper;
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

                foreach (Fichada item in lFichadas)
                {

                    // Ver fichadas dobles

                    if (item.lec1 != null && item.lec2 != null)
                    {
                        var difLec = (DateTime.Parse(item.lec2) - DateTime.Parse(item.lec1)).TotalSeconds;

                        if (difLec< 200)
                        {
                            item.lec2 = item.lec3;
                            item.lec3 = item.lec4;
                            item.lec4 = item.lec5;
                            item.lec5 = item.lec6;
                            item.lec6 = null;
                            item.tipo2 = item.tipo3;
                            item.tipo3 = item.tipo4;
                            item.tipo4 = item.tipo5;
                            item.tipo5 = item.tipo6;
                            item.tipo6 = null;
                        }
                    }

                    if (item.lec2 != null && item.lec3 != null)
                    {
                        var difLec = (DateTime.Parse(item.lec3) - DateTime.Parse(item.lec2)).TotalSeconds;

                        if (difLec < 200)
                        {
                            item.lec3 = item.lec4;
                            item.lec4 = item.lec5;
                            item.lec5 = item.lec6;
                            item.lec6 = null;
                            item.tipo3 = item.tipo4;
                            item.tipo4 = item.tipo5;
                            item.tipo5 = item.tipo6;
                            item.tipo6 = null;
                        }
                    }

                    if (item.lec3 != null && item.lec4 != null)
                    {
                        var difLec = (DateTime.Parse(item.lec4) - DateTime.Parse(item.lec3)).TotalSeconds;

                        if (difLec < 200)
                        {
                            item.lec4 = item.lec5;
                            item.lec5 = item.lec6;
                            item.lec6 = null;
                            item.tipo4 = item.tipo5;
                            item.tipo5 = item.tipo6;
                            item.tipo6 = null;
                        }
                    }

                    if (item.lec4 != null && item.lec5 != null)
                    {
                        var difLec = (DateTime.Parse(item.lec5) - DateTime.Parse(item.lec4)).TotalSeconds;

                        if (difLec < 200)
                        {
                            item.lec5 = item.lec6;
                            item.lec6 = null;
                            item.tipo5 = item.tipo6;
                            item.tipo6 = null;
                        }
                    }

                    if (item.lec5 != null && item.lec6 != null)
                    {
                        var difLec = (DateTime.Parse(item.lec6) - DateTime.Parse(item.lec5)).TotalSeconds;

                        if (difLec < 200)
                        {
                            item.lec6 = null;
                            item.tipo6 = null;
                        }
                    }

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
                        item.estado = "ERR";
                    }

                  

                }

                return lFichadas;
                
            }

        }
    }
}
