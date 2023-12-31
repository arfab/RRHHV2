﻿using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;


namespace RRHH.Repository
{
    public class FichadaRepo : IFichadaRepo
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

/*
        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int tipo_listado)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                string horas_normal = "";
                string horas_50 = "";
                string horas_100 = "";

                int minutos_normal=0;
                int minutos_50 = 0;
                int minutos_100 = 0;

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



                    if (item.tipo1 == null)
                    {
                        if (item.justificacion == "")
                            item.estado = "NO";
                        else
                            item.estado = "JUS";
                    }
                    else
                        item.estado = "OK";


                    if (item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null )
                    {

                        

                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;
                        item.hora_entrada_2 = item.lec3;
                        item.hora_salida_2 = item.lec4;


                        if (item.tipo5 == null)
                        {
                            CantidadHoras cantidadHoras = ObtenerCantidadHoras(item.hora_entrada_1,
                                                item.hora_salida_1,
                                                item.hora_entrada_2,
                                                item.hora_salida_2,
                                                item.hora_entrada_3,
                                                item.hora_salida_3,
                                                item.ubicacion_id.Value,
                                                item.ubicacion_id.Value == 3 ? item.local_id.Value : item.sector_id.Value,
                                                (int)item.fecha.Value.DayOfWeek + 1);

                            if (cantidadHoras != null)
                            {
                                if (item.horas_normales == null || item.horas_normales == "")
                                    if (cantidadHoras.horas_normales != null) item.horas_normales = cantidadHoras.horas_normales.Trim();

                                if (item.horas_50 == null || item.horas_50 == "")
                                    if (cantidadHoras.horas_50 != null) item.horas_50 = cantidadHoras.horas_50.Trim();

                                if (item.horas_100 == null || item.horas_100 == "")
                                    if (cantidadHoras.horas_100 != null) item.horas_100 = cantidadHoras.horas_100.Trim();
                            }

                            if (item.horas_normales == "" && item.horas_50 == "" && item.horas_100 == "")
                            {


                                DateTime entrada1 = DateTime.Parse(item.lec1);
                                DateTime salida1 = DateTime.Parse(item.lec2);

                                TimeSpan span1 = salida1.Subtract(entrada1);

                                DateTime entrada2 = DateTime.Parse(item.lec3);
                                DateTime salida2 = DateTime.Parse(item.lec4);

                                TimeSpan span2 = salida2.Subtract(entrada2);
                                span1 += span2;
                                item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');
                            }
                            else
                            {
                                TimeSpan spanHs = TimeSpan.Parse("00:00");
                                TimeSpan spanHs50 = TimeSpan.Parse("00:00");
                                TimeSpan spanHs100 = TimeSpan.Parse("00:00");


                                if (item.horas_normales != null && item.horas_normales.Trim() != "")
                                {
                                    spanHs = TimeSpan.Parse(item.horas_normales);
                                }
                                if (item.horas_50 != null && item.horas_50.Trim() != "")
                                {
                                    spanHs50 = TimeSpan.Parse(item.horas_50);
                                }
                                if (item.horas_100 != null && item.horas_100.Trim() != "")
                                {
                                    spanHs100 = TimeSpan.Parse(item.horas_100);
                                }

                                spanHs += spanHs50;
                                spanHs += spanHs100;
                                item.cantidad_horas = spanHs.Hours.ToString() + ":" + spanHs.Minutes.ToString().PadLeft(2, '0');

                            }

                            if (cantidadHoras != null)
                            {
                                if (cantidadHoras.horas_normales != null && cantidadHoras.horas_normales.Trim() != "")
                                    minutos_normal += (int)TimeSpan.Parse(cantidadHoras.horas_normales).TotalMinutes;
                                if (cantidadHoras.horas_50 != null && cantidadHoras.horas_50.Trim() != "")
                                    minutos_50 += (int)TimeSpan.Parse(cantidadHoras.horas_50).TotalMinutes;
                                if (cantidadHoras.horas_100 != null && cantidadHoras.horas_100.Trim() != "")
                                    minutos_100 += (int)TimeSpan.Parse(cantidadHoras.horas_100).TotalMinutes;
                            }
                        }
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

                        CantidadHoras cantidadHoras = ObtenerCantidadHoras(item.hora_entrada_1,
                                      item.hora_salida_1,
                                      item.hora_entrada_2,
                                      item.hora_salida_2,
                                      item.hora_entrada_3, 
                                      item.hora_salida_3,
                                      item.ubicacion_id.Value,
                                      item.ubicacion_id.Value==3?item.local_id.Value:item.sector_id.Value,
                                      (int)item.fecha.Value.DayOfWeek+1);

                        if (cantidadHoras != null)
                        {
                            if (item.horas_normales == null || item.horas_normales=="")
                              if (cantidadHoras.horas_normales != null) item.horas_normales = cantidadHoras.horas_normales.Trim();

                            if (item.horas_50 == null || item.horas_50 == "")
                                if (cantidadHoras.horas_50 != null) item.horas_50 = cantidadHoras.horas_50.Trim();

                            if (item.horas_100 == null || item.horas_100 == "")
                                if (cantidadHoras.horas_100 != null) item.horas_100 = cantidadHoras.horas_100.Trim();
                        }

                        if (item.horas_normales == "" && item.horas_50 == "" && item.horas_100 == "")
                        {
                            DateTime entrada1 = DateTime.Parse(item.lec1);
                            DateTime salida1 = DateTime.Parse(item.lec2);

                            TimeSpan span1 = salida1.Subtract(entrada1);


                            item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');
                        }
                        else
                        {
                            TimeSpan spanHs = TimeSpan.Parse("00:00");
                            TimeSpan spanHs50 = TimeSpan.Parse("00:00");
                            TimeSpan spanHs100 = TimeSpan.Parse("00:00");


                            if (item.horas_normales != null && item.horas_normales.Trim() != "")
                            {
                                spanHs = TimeSpan.Parse(item.horas_normales);
                            }
                            if (item.horas_50 != null && item.horas_50.Trim() != "")
                            {
                                spanHs50 = TimeSpan.Parse(item.horas_50);
                            }
                            if (item.horas_100!=null && item.horas_100.Trim() != "")
                            {
                                spanHs100 = TimeSpan.Parse(item.horas_100);
                            }

                            spanHs += spanHs50;
                            spanHs += spanHs100;

                            item.cantidad_horas = spanHs.Hours.ToString() + ":" + spanHs.Minutes.ToString().PadLeft(2, '0');

                        }


                        if (cantidadHoras != null)
                        {
                            if (cantidadHoras.horas_normales != null && cantidadHoras.horas_normales.Trim() != "")
                                minutos_normal += (int)TimeSpan.Parse(cantidadHoras.horas_normales).TotalMinutes;
                            if (cantidadHoras.horas_50 != null && cantidadHoras.horas_50.Trim() != "")
                                minutos_50 += (int)TimeSpan.Parse(cantidadHoras.horas_50).TotalMinutes;
                            if (cantidadHoras.horas_100 != null && cantidadHoras.horas_100.Trim() != "")
                                minutos_100 += (int)TimeSpan.Parse(cantidadHoras.horas_100).TotalMinutes;
                        }

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


                    if (item.estado != "ERR" && item.tipo5 != null && item.tipo6 != null)
                    {


                        item.hora_entrada_3 = item.lec5;
                        item.hora_salida_3 = item.lec6;

                        CantidadHoras cantidadHoras = ObtenerCantidadHoras(
                                      item.hora_entrada_1,
                                      item.hora_salida_1,
                                      item.hora_entrada_2,
                                      item.hora_salida_2,
                                      item.hora_entrada_3,
                                      item.hora_salida_3,
                                      item.ubicacion_id.Value,
                                      item.ubicacion_id.Value == 3 ? item.local_id.Value : item.sector_id.Value,
                                      (int)item.fecha.Value.DayOfWeek + 1);

                        if (cantidadHoras != null)
                        {
                            if (item.horas_normales == null || item.horas_normales == "")
                                if (cantidadHoras.horas_normales != null) item.horas_normales = cantidadHoras.horas_normales.Trim();

                            if (item.horas_50 == null || item.horas_50 == "")
                                if (cantidadHoras.horas_50 != null) item.horas_50 = cantidadHoras.horas_50.Trim();

                            if (item.horas_100 == null || item.horas_100 == "")
                                if (cantidadHoras.horas_100 != null) item.horas_100 = cantidadHoras.horas_100.Trim();
                        }

                        if (item.horas_normales == "" && item.horas_50 == "" && item.horas_100 == "")
                        {
                            DateTime entrada1 = DateTime.Parse(item.lec1);
                            DateTime salida1 = DateTime.Parse(item.lec2);

                            TimeSpan span1 = salida1.Subtract(entrada1);

                            DateTime entrada2 = DateTime.Parse(item.lec3);
                            DateTime salida2 = DateTime.Parse(item.lec4);

                            TimeSpan span2 = salida2.Subtract(entrada2);

                            DateTime entrada3 = DateTime.Parse(item.lec5);
                            DateTime salida3 = DateTime.Parse(item.lec6);

                            TimeSpan span3 = salida3.Subtract(entrada3);



                            span1 += span2;
                            span1 += span3;

                            item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');
                       

                        }
                        else
                        {
                            TimeSpan spanHs = TimeSpan.Parse("00:00");
                            TimeSpan spanHs50 = TimeSpan.Parse("00:00");
                            TimeSpan spanHs100 = TimeSpan.Parse("00:00");


                            if (item.horas_normales != null && item.horas_normales.Trim() != "")
                            {
                                spanHs = TimeSpan.Parse(item.horas_normales);
                            }
                            if (item.horas_50 != null  & item.horas_50.Trim() != "")
                            {
                                spanHs50 = TimeSpan.Parse(item.horas_50);
                            }
                            if (item.horas_100 != null && item.horas_100.Trim() != "")
                            {
                                spanHs100 = TimeSpan.Parse(item.horas_100);
                            }

                            spanHs += spanHs50;
                            spanHs += spanHs100;
                            item.cantidad_horas = spanHs.Hours.ToString() + ":" + spanHs.Minutes.ToString().PadLeft(2, '0');

                        }


                        //if (cantidadHoras != null)
                        //{
                        //    if (cantidadHoras.horas_normales != null && cantidadHoras.horas_normales.Trim() != "")
                        //        minutos_normal += (int)TimeSpan.Parse(cantidadHoras.horas_normales).TotalMinutes;
                        //    if (cantidadHoras.horas_50 != null && cantidadHoras.horas_50.Trim() != "")
                        //        minutos_50 += (int)TimeSpan.Parse(cantidadHoras.horas_50).TotalMinutes;
                        //    if (cantidadHoras.horas_100 != null && cantidadHoras.horas_100.Trim() != "")
                        //        minutos_100 += (int)TimeSpan.Parse(cantidadHoras.horas_100).TotalMinutes;
                        //}


                    }




                }

                horas_normal = ((int) minutos_normal/60).ToString() +":" + (minutos_normal- ((int)minutos_normal / 60)*60).ToString();
                horas_50 = ((int)minutos_50 / 60).ToString() + ":" + (minutos_50 - ((int)minutos_50 / 60)*60).ToString();
                horas_100 = ((int)minutos_100 / 60).ToString() + ":" + (minutos_100 - ((int)minutos_100 / 60)*60).ToString();


                return lFichadas;
                
            }

        }

*/


        public IEnumerable<Fichada> ObtenerTodos(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, int ubicacion_id, int sector_id, int lectora_id, int tipo_listado)
        {

            try
            {
                using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                string horas_normal = "";
                string horas_50 = "";
                string horas_100 = "";

                int minutos_normal = 0;
                int minutos_50 = 0;
                int minutos_100 = 0;

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
                parameter.Add("@lectora_id", lectora_id);



                IEnumerable<Fichada> lFichadas;
                lFichadas = con.Query<Fichada>("spFichadaAgrupadaObtener", parameter, commandType: CommandType.StoredProcedure, commandTimeout: 120).ToList();

                foreach (Fichada item in lFichadas)
                {


                    ILectoraRepo iLectoraRepo;
                    iLectoraRepo = new LectoraRepo();

                    item.lec1 = CalcularHora(item.lec1, item.delta.Value);
                    item.lec2 = CalcularHora(item.lec2, item.delta.Value);
                    item.lec3 = CalcularHora(item.lec3, item.delta.Value);
                    item.lec4 = CalcularHora(item.lec4, item.delta.Value);
                    item.lec5 = CalcularHora(item.lec5, item.delta.Value);
                    item.lec6 = CalcularHora(item.lec6, item.delta.Value);
                    item.lec7 = CalcularHora(item.lec7, item.delta.Value);
                    item.lec8 = CalcularHora(item.lec8, item.delta.Value);

                    item.tipo1 = item.tipo1 == "" ? null : item.tipo1;
                    item.tipo2 = item.tipo2 == "" ? null : item.tipo2;
                    item.tipo3 = item.tipo3 == "" ? null : item.tipo3;
                    item.tipo4 = item.tipo4 == "" ? null : item.tipo4;
                    item.tipo5 = item.tipo5 == "" ? null : item.tipo5;
                    item.tipo6 = item.tipo6 == "" ? null : item.tipo6;
                    item.tipo7 = item.tipo7 == "" ? null : item.tipo7;
                    item.tipo8 = item.tipo8 == "" ? null : item.tipo8;

                    if (item.tipo1 == null)
                    {
                        if (item.justificacion == "")
                            item.estado = "NO";
                        else
                            item.estado = "JUS";
                    }
                    else
                        item.estado = "OK";


                    if (
                        item.tipo1 == null && item.tipo2 == null && item.tipo3 == null && item.tipo4 == null && item.tipo5 == null && item.tipo6 == null && item.tipo7 == null && item.tipo8 == null ||
                        item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null && item.tipo5 != null && item.tipo6 != null && item.tipo7 != null && item.tipo8 != null ||
                        item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null && item.tipo5 != null && item.tipo6 != null && item.tipo7 == null && item.tipo8 == null ||
                        item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4!=null && item.tipo5 == null && item.tipo6 == null && item.tipo7 == null && item.tipo8 == null ||
                        item.tipo1 != null && item.tipo2 != null && item.tipo3 == null && item.tipo4 == null && item.tipo5 == null && item.tipo6 == null && item.tipo7 == null && item.tipo8 == null
                        )
                    
                    {



                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;

                        if (item.tipo3 != null)
                        {
                            item.hora_entrada_2 = item.lec3;
                            item.hora_salida_2 = item.lec4;
                        }

                        if (item.tipo5 != null)
                        {
                            item.hora_entrada_3 = item.lec5;
                            item.hora_salida_3 = item.lec6;
                        }

                        if (item.tipo7 != null)
                        {
                            item.hora_entrada_4 = item.lec7;
                            item.hora_salida_4 = item.lec8;
                        }

                        CantidadHoras cantidadHoras = 
                           ObtenerCantidadHoras(item.hora_entrada_1,
                                                item.hora_salida_1,
                                                item.hora_entrada_2,
                                                item.hora_salida_2,
                                                item.hora_entrada_3,
                                                item.hora_salida_3,
                                                item.hora_entrada_4,
                                                item.hora_salida_4,
                                                item.ubicacion_id.Value,
                                                item.ubicacion_id.Value == 3 ? item.local_id.Value : item.sector_id.Value,
                                                (int)item.fecha.Value.DayOfWeek + 1,
                                                item.legajo_id.Value,
                                                item.fecha.Value);

                          if (cantidadHoras != null)
                          {
                                if (item.horas_normales == null || item.horas_normales == "")
                                    if (cantidadHoras.horas_normales != null) item.horas_normales = cantidadHoras.horas_normales.Trim();

                                if (item.horas_50 == null || item.horas_50 == "")
                                    if (cantidadHoras.horas_50 != null) item.horas_50 = cantidadHoras.horas_50.Trim();

                                if (item.horas_100 == null || item.horas_100 == "")
                                    if (cantidadHoras.horas_100 != null) item.horas_100 = cantidadHoras.horas_100.Trim();

                                if (item.horas_50_fds == null || item.horas_50_fds == "")
                                    if (cantidadHoras.horas_50_fds != null) item.horas_50_fds = cantidadHoras.horas_50_fds.Trim();

                                if (item.horas_feriado == null || item.horas_feriado == "")
                                    if (cantidadHoras.horas_feriado != null) item.horas_feriado = cantidadHoras.horas_feriado.Trim();


                                if(item.descuento_str == null || item.descuento_str == "") {
                                    if (cantidadHoras.descuento > 0)
                                    {
                                        item.descuento = cantidadHoras.descuento;
                                        item.descuento_str = ((int)(item.descuento / 60)).ToString().PadLeft(2, '0') + ':' + (item.descuento - (int)(item.descuento / 60) * 60).ToString().PadLeft(2, '0');

                                    }
                                }

                                /*
                                item.descuento = cantidadHoras.descuento;
                                item.descuento_str = ((int)(item.descuento / 60)).ToString().PadLeft(2,'0') + ':' + (item.descuento - (int)(item.descuento / 60) * 60).ToString().PadLeft(2, '0');
                                */

                                item.feriado = cantidadHoras.feriado;

                            }

                            if (1==1 || item.horas_normales == "" && item.horas_50 == "" && item.horas_100 == "")
                            {
                            TimeSpan span1= TimeSpan.Zero;

                            if (item.tipo1 != null)
                            {
                                DateTime entrada1 = DateTime.Parse(item.lec1);
                                DateTime salida1 = DateTime.Parse(item.lec2);

                                 span1 = salida1.Subtract(entrada1);
                            }

                              if (item.tipo3 != null)
                              {
                                DateTime entrada2 = DateTime.Parse(item.lec3);
                                DateTime salida2 = DateTime.Parse(item.lec4);
                                TimeSpan span2 = salida2.Subtract(entrada2);
                                span1 += span2;
                              }

                              if (item.tipo5 != null)
                              {

                                DateTime entrada3 = DateTime.Parse(item.lec5);
                                DateTime salida3 = DateTime.Parse(item.lec6);

                                TimeSpan span3 = salida3.Subtract(entrada3);
                                span1 += span3;
                              }

                            if (item.tipo7 != null)
                            {

                                DateTime entrada4 = DateTime.Parse(item.lec7);
                                DateTime salida4 = DateTime.Parse(item.lec8);

                                TimeSpan span4 = salida4.Subtract(entrada4);
                                span1 += span4;
                            }

                            item.cantidad_horas = span1.Hours.ToString().PadLeft(2, '0') + ":" + span1.Minutes.ToString().PadLeft(2, '0');


                            }
                            else
                            {
                                TimeSpan spanHs = TimeSpan.Parse("00:00");
                                TimeSpan spanHs50 = TimeSpan.Parse("00:00");
                                TimeSpan spanHs100 = TimeSpan.Parse("00:00");


                                if (item.horas_normales != null && item.horas_normales.Trim() != "")
                                {
                                    spanHs = TimeSpan.Parse(item.horas_normales);
                                }
                                if (item.horas_50 != null && item.horas_50.Trim() != "")
                                {
                                    spanHs50 = TimeSpan.Parse(item.horas_50);
                                }
                                if (item.horas_100 != null && item.horas_100.Trim() != "")
                                {
                                    spanHs100 = TimeSpan.Parse(item.horas_100);
                                }

                                spanHs += spanHs50;
                                spanHs += spanHs100;
                                item.cantidad_horas = spanHs.Hours.ToString() + ":" + spanHs.Minutes.ToString().PadLeft(2, '0');

                            }

                            if (cantidadHoras != null)
                            {
                                if (cantidadHoras.horas_normales != null && cantidadHoras.horas_normales.Trim() != "")
                                    minutos_normal += (int)TimeSpan.Parse(cantidadHoras.horas_normales).TotalMinutes;
                                if (cantidadHoras.horas_50 != null && cantidadHoras.horas_50.Trim() != "")
                                    minutos_50 += (int)TimeSpan.Parse(cantidadHoras.horas_50).TotalMinutes;
                                if (cantidadHoras.horas_100 != null && cantidadHoras.horas_100.Trim() != "")
                                    minutos_100 += (int)TimeSpan.Parse(cantidadHoras.horas_100).TotalMinutes;
                            }
                        
                    }
                    else if (item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 == null ||
                             item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null && item.tipo5 == null ||
                             item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null && item.tipo5 != null && item.tipo6 == null ||
                             item.tipo1 != null && item.tipo2 != null && item.tipo3 != null && item.tipo4 != null && item.tipo5 != null && item.tipo6 != null && item.tipo7 != null && item.tipo8 == null
                            )
                    {
                        item.hora_entrada_1 = item.lec1;
                        item.hora_salida_1 = item.lec2;


                        if (item.tipo3 != null)
                        {
                            item.hora_entrada_2 = item.lec3;
                        }

                        if (item.tipo4 != null)
                        {
                            item.hora_salida_2 = item.lec4;
                        }


                        if (item.tipo5 != null)
                        {
                            item.hora_entrada_3 = item.lec5;
                        }

                        if (item.tipo6 != null)
                        {
                            item.hora_salida_3 = item.lec6;
                        }

                        if (item.tipo7 != null)
                        {
                            item.hora_entrada_4 = item.lec7;
                        }

                        if (item.tipo8 != null)
                        {
                            item.hora_salida_4 = item.lec8;
                        }


                        //CantidadHoras cantidadHoras =
                        //    ObtenerCantidadHoras(item.hora_entrada_1,
                        //                         item.hora_salida_1,
                        //                         item.hora_entrada_2,
                        //                         item.hora_salida_2,
                        //                         item.hora_entrada_3,
                        //                         item.hora_salida_3,
                        //                         item.ubicacion_id.Value,
                        //                         item.ubicacion_id.Value == 3 ? item.local_id.Value : item.sector_id.Value,
                        //                         (int)item.fecha.Value.DayOfWeek + 1);

                        //if (cantidadHoras != null)
                        //{
                        //    if (item.horas_normales == null || item.horas_normales == "")
                        //        if (cantidadHoras.horas_normales != null) item.horas_normales = cantidadHoras.horas_normales.Trim();

                        //    if (item.horas_50 == null || item.horas_50 == "")
                        //        if (cantidadHoras.horas_50 != null) item.horas_50 = cantidadHoras.horas_50.Trim();

                        //    if (item.horas_100 == null || item.horas_100 == "")
                        //        if (cantidadHoras.horas_100 != null) item.horas_100 = cantidadHoras.horas_100.Trim();
                        //}

                        //if (item.horas_normales == "" && item.horas_50 == "" && item.horas_100 == "")
                        //{


                        //    DateTime entrada1 = DateTime.Parse(item.lec1);
                        //    DateTime salida1 = DateTime.Parse(item.lec2);

                        //    TimeSpan span1 = salida1.Subtract(entrada1);

                        //    if (item.tipo3 != null && item.tipo4 != null)
                        //    {
                        //        DateTime entrada2 = DateTime.Parse(item.lec3);
                        //        DateTime salida2 = DateTime.Parse(item.lec4);
                        //        TimeSpan span2 = salida2.Subtract(entrada2);
                        //        span1 += span2;
                        //    }

                        //    if (item.tipo5 != null && item.tipo6 != null)
                        //    {

                        //        DateTime entrada3 = DateTime.Parse(item.lec5);
                        //        DateTime salida3 = DateTime.Parse(item.lec6);

                        //        TimeSpan span3 = salida3.Subtract(entrada3);
                        //        span1 += span3;
                        //    }

                        //    item.cantidad_horas = span1.Hours.ToString() + ":" + span1.Minutes.ToString().PadLeft(2, '0');


                        //}
                        //else
                        //{
                        //    TimeSpan spanHs = TimeSpan.Parse("00:00");
                        //    TimeSpan spanHs50 = TimeSpan.Parse("00:00");
                        //    TimeSpan spanHs100 = TimeSpan.Parse("00:00");


                        //    if (item.horas_normales != null && item.horas_normales.Trim() != "")
                        //    {
                        //        spanHs = TimeSpan.Parse(item.horas_normales);
                        //    }
                        //    if (item.horas_50 != null && item.horas_50.Trim() != "")
                        //    {
                        //        spanHs50 = TimeSpan.Parse(item.horas_50);
                        //    }
                        //    if (item.horas_100 != null && item.horas_100.Trim() != "")
                        //    {
                        //        spanHs100 = TimeSpan.Parse(item.horas_100);
                        //    }

                        //    spanHs += spanHs50;
                        //    spanHs += spanHs100;
                        //    item.cantidad_horas = spanHs.Hours.ToString() + ":" + spanHs.Minutes.ToString().PadLeft(2, '0');

                        //}

                        //if (cantidadHoras != null)
                        //{
                        //    if (cantidadHoras.horas_normales != null && cantidadHoras.horas_normales.Trim() != "")
                        //        minutos_normal += (int)TimeSpan.Parse(cantidadHoras.horas_normales).TotalMinutes;
                        //    if (cantidadHoras.horas_50 != null && cantidadHoras.horas_50.Trim() != "")
                        //        minutos_50 += (int)TimeSpan.Parse(cantidadHoras.horas_50).TotalMinutes;
                        //    if (cantidadHoras.horas_100 != null && cantidadHoras.horas_100.Trim() != "")
                        //        minutos_100 += (int)TimeSpan.Parse(cantidadHoras.horas_100).TotalMinutes;
                        //}






                        item.estado = "ERR";

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

                        if (item.tipo1 != null)
                        {
                            item.hora_entrada_1 = item.lec1;
                        }

                        if (item.tipo2 != null)
                        {
                            item.hora_salida_1 = item.lec2;
                        }

                        if (item.tipo3 != null)
                        {
                            item.hora_entrada_2 = item.lec3;
                        }

                        if (item.tipo4 != null)
                        {
                            item.hora_salida_2 = item.lec4;
                        }

                        if (item.tipo5 != null)
                        {
                            item.hora_entrada_3 = item.lec5;
                        }

                        if (item.tipo6 != null)
                        {
                            item.hora_salida_3 = item.lec6;
                        }

                        if (item.tipo7 != null)
                        {
                            item.hora_entrada_4 = item.lec7;
                        }

                        if (item.tipo8 != null)
                        {
                            item.hora_entrada_4 = item.lec8;
                        }

                        if (item.estado != "NO" && item.estado != "JUS")
                            item.estado = "ERR";
                    }


                }

                horas_normal = ((int)minutos_normal / 60).ToString() + ":" + (minutos_normal - ((int)minutos_normal / 60) * 60).ToString();
                horas_50 = ((int)minutos_50 / 60).ToString() + ":" + (minutos_50 - ((int)minutos_50 / 60) * 60).ToString();
                horas_100 = ((int)minutos_100 / 60).ToString() + ":" + (minutos_100 - ((int)minutos_100 / 60) * 60).ToString();


                return lFichadas;

            }

            }
            catch (SqlException e)
            {
                string a = e.Message;

                return Enumerable.Empty<Fichada>();
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


        public CantidadHoras ObtenerCantidadHoras(string entrada1, string salida1, string entrada2, string salida2, string entrada3, string salida3, string entrada4, string salida4, int ubicacion_id, int sector_id, int dia_semana, int legajo_id ,  DateTime fecha)
        {

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameter = new DynamicParameters();
                parameter.Add("@entrada1", entrada1);
                parameter.Add("@salida1", salida1);
                parameter.Add("@entrada2", entrada2);
                parameter.Add("@salida2", salida2);
                parameter.Add("@entrada3", entrada3);
                parameter.Add("@salida3", salida3);
                parameter.Add("@entrada4", entrada4);
                parameter.Add("@salida4", salida4);
                parameter.Add("@ubicacion_id", ubicacion_id);
                parameter.Add("@sector_id", sector_id);
                parameter.Add("@dia_semana", dia_semana);
                parameter.Add("@legajo_id", legajo_id);
                parameter.Add("@fecha", fecha);

                return con.QuerySingle<CantidadHoras>("spCantidadHorasObtenerDesglose", parameter, commandType: CommandType.StoredProcedure);
            }

        }


        public string InsertarExportacionFichada(int nro_lectora, int nro_legajo, DateTime fecha, string hora,string tipo, int completo)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@lectora_nro", nro_lectora);
                parameters.Add("@nro_legajo", nro_legajo);
                parameters.Add("@fecha", fecha);
                parameters.Add("@hora", hora);
                parameters.Add("@tipo", tipo);
                parameters.Add("@completo", completo);


                icantFilas = con.Execute("spFichadaExportacionInsertar", parameters, commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string ExcluirFichadas()
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();



                icantFilas = con.Execute("spFichadaExcluir", commandType: CommandType.StoredProcedure);


            }
            return "";
        }

        public string GenerarFichadas(int alta_legajo)
        {
            int icantFilas;
            using (var con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@alta_legajo", alta_legajo);

                icantFilas = con.Execute("spFichadaGenerar", commandType: CommandType.StoredProcedure);


            }
            return "";
        }


        public IEnumerable<FichadaOriginal> ObtenerFichadasOriginales(int legajo_id, int lectora_id, string fecha, int sin_excluidos)
        {

       
                using (IDbConnection con = new SqlConnection(strConnectionString))
                {
                    if (con.State == ConnectionState.Closed)
                        con.Open();


                    DynamicParameters parameter = new DynamicParameters();
                    parameter.Add("@legajo_id", legajo_id);
                    parameter.Add("@lectora_id", lectora_id);
                    parameter.Add("@fecha", fecha);
                    parameter.Add("@sin_exluidos", sin_excluidos);

                return con.Query<FichadaOriginal>("spFichadaOriginalObtenerTodos", parameter, commandType: CommandType.StoredProcedure).ToList();



                }
           
            

        }



    }
}
