using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;
using ClosedXML.Excel;
using System;
using System.IO;

namespace RRHH.Controllers
{
    public class FichadaController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public FichadaController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int lectora_id, int local_id)
        {

            HttpContext.Session.SetString("EMPRESA_ACTUAL_FICHADA", "");

            HttpContext.Session.SetString("APELLIDO_ACTUAL_FICHADA", "");
            HttpContext.Session.SetString("UBICACION_ACTUAL_FICHADA", "");
            HttpContext.Session.SetString("SECTOR_ACTUAL_FICHADA", "");
            HttpContext.Session.SetString("LECTORA_ACTUAL_FICHADA", "");

            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

            HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetInt32("TIPO_LISTADO_ACTUAL", 0);


            return RedirectToAction("Index", "Fichada");


        }


        public IActionResult Index(int nro_legajo,  int legajo_id, string filtro, string desde, int empresa_id, int ubicacion_id, int sector_id, int lectora_id, string apellido, int tipo_listado, int? item_actual)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            DateTime? fecha_desde = null;
            DateTime? fecha_hasta = null;

            if (HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != null && HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_DESDE"));
            else
                fecha_desde = DateTime.Now.Date;

            if (HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != null && HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_HASTA"));
            else
                fecha_hasta = DateTime.Now.Date;

            if (HttpContext.Session.GetInt32("EMPRESA_ACTUAL_FICHADA") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_ACTUAL_FICHADA");

            if (HttpContext.Session.GetString("APELLIDO_ACTUAL_FICHADA") != null) apellido = HttpContext.Session.GetString("APELLIDO_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("UBICACION_ACTUAL_FICHADA") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("SECTOR_ACTUAL_FICHADA") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("LECTORA_ACTUAL_FICHADA") != null) lectora_id = (int)HttpContext.Session.GetInt32("LECTORA_ACTUAL_FICHADA");


            if (HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL");

            if (HttpContext.Session.GetInt32("TIPO_LISTADO_ACTUAL") != null)
                tipo_listado = (int)HttpContext.Session.GetInt32("TIPO_LISTADO_ACTUAL");
    



            if (perfil_id > 0)
            {
                IFichadaRepo fichadaRepo;

                fichadaRepo = new FichadaRepo();


                DateTime fechaDesde = new DateTime();
                DateTime fechaHasta = new DateTime();

                if (fecha_desde != null)
                    if (fecha_desde.Value.Year > 2002)
                        fechaDesde = fecha_desde.Value;
                    else
                          if (fecha_desde.Value.Year != 1)
                        fechaDesde = new DateTime(1, 1, 1);

                if (fecha_hasta != null)
                    if (fecha_hasta.Value.Year > 2002)
                        fechaHasta = fecha_hasta.Value;
                    else
                          if (fecha_hasta.Value.Year != 1)
                        fechaHasta = new DateTime(1, 1, 1);


                int? pag_novedad = HttpContext.Session.GetInt32("PAG_FICHADA");

                if (pag_novedad == null)
                {
                    pag_novedad = 1;
                    HttpContext.Session.SetInt32("PAG_FICHADA", 1);
                }

                ViewData["APELLIDO"] = apellido;
                ViewData["EMPRESA_ID"] = empresa_id;

                ViewData["UBICACION_ID"] = ubicacion_id;
                ViewData["SECTOR_ID"] = sector_id;
                ViewData["LECTORA_ID"] = lectora_id;

                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["FiltroActual"] = filtro;
                ViewData["TipoListadoActual"] = tipo_listado;

                ViewData["ITEM_ACTUAL"] = item_actual == null?0:item_actual.Value ;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(legajo_id);


                if (legajo != null)
                {
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;
                    ViewData["LegajoActual"] = legajo.nro_legajo;
                    ViewData["Legajo"] = legajo;
                }

                if (nro_legajo > 0)
                {
                    

                        if (legajo == null)
                        {
                            ViewBag.Message = "No existe el legajo para esa empresa";
                            return View();
                        }


                }



                if (fechaDesde.Year < 2002)
                {
                    fechaDesde = new DateTime(1, 1, 1);

                    ViewData["FechaDesdeActual"] = "";
                }
                else
                {
                    ViewData["FechaDesdeActual"] = fechaDesde.Day.ToString().PadLeft(2, '0') + "/" + fechaDesde.Month.ToString().PadLeft(2, '0') + "/" + fechaDesde.Year;

                }

                if (fechaHasta.Year < 2002)
                {
                    fechaHasta = new DateTime(1, 1, 1);

                    ViewData["FechaHastaActual"] = "";
                }
                else
                {
                    ViewData["FechaHastaActual"] = fechaHasta.Day.ToString().PadLeft(2, '0') + "/" + fechaHasta.Month.ToString().PadLeft(2, '0') + "/" + fechaHasta.Year;

                }



                //if (desde == "busqueda")
                //{
                //    if (nro_legajo <= 0)
                //    {
                //        ViewBag.Message = "Debe especificar un legajo";
                //        return View();
                //    }
                //}

                ViewData["TIPO_LISTADO"] = tipo_listado;

                IEnumerable<Fichada> fichadas;

                TimeSpan span1 = fechaHasta.Subtract(fechaDesde);
                
                if (nro_legajo <=0 && span1.Days>31)
                {
                    ViewBag.Message = "El rango de fechas debe ser 31 dias como maximo";
                    return View();
                }


              
                if (desde == "busqueda")
                {
                    if (empresa_id <= 0 && ubicacion_id <= 0 && sector_id <= 0)
                    {
                        if (fechaDesde.Year < 2000 || fechaHasta.Year < 2000 || fechaDesde != fechaHasta)
                        {
                            ViewBag.Message = "El rango de fechas debe ser de un dia si no se especifica la empresa, ubicacion ni sector/local";
                            return View();
                        }
                    }

                }

                if (desde != "busqueda") return View();

                fichadas = fichadaRepo.ObtenerTodos(
                     (nro_legajo == 0) ? -1 : nro_legajo, 
                     fechaDesde, 
                     fechaHasta, 
                     (empresa_id == 0) ? -1 : empresa_id, 
                     (ubicacion_id == 0) ? -1 : ubicacion_id, 
                     (sector_id == 0) ? -1 : sector_id,
                     (lectora_id == 0) ? -1 : lectora_id,
                     tipo_listado);


                if (desde == "busqueda")
                {
                    //if (empresa_id <= 0 && ubicacion_id<=0 && sector_id<=0)
                    //{
                    //    if (fechaDesde.Year < 2000 || fechaHasta.Year < 2000 || fechaDesde != fechaHasta)
                    //    {
                    //        ViewBag.Message = "El rango de fechas debe ser de un dia si no se especifica la empresa, ubicacion ni sector/local";
                    //        return View();
                    //    }
                    //}

                    //if (fichadas.Count()>1000)
                    //{
                    //    ExportarExcel(nro_legajo, legajo_id, filtro, desde, empresa_id, ubicacion_id, sector_id, apellido, tipo_listado);
                    //    return View();
                    //}

                    if (fichadas.Count() == 0 )
                    {
                        ViewBag.Message = "No existen datos para el criterio seleccionado";
                        return View();
                    }
                }

              
                return View(fichadas);

            }



            return View();


        }

        [HttpPost]
        public IActionResult Buscar(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int legajo_id, string filtro, int empresa_id,int ubicacion_id, int sector_id, int lectora_id, string apellido, int tipo_listado)
        {

            HttpContext.Session.SetString("APELLIDO_ACTUAL_FICHADA", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPRESA_ACTUAL_FICHADA", empresa_id);


            HttpContext.Session.SetInt32("UBICACION_ACTUAL_FICHADA", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_ACTUAL_FICHADA", sector_id);

            HttpContext.Session.SetInt32("LECTORA_ACTUAL_FICHADA", lectora_id);


            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

           // HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetInt32("LEGAJO_FICHADA_ACTUAL", nro_legajo);

            HttpContext.Session.SetInt32("EMPLEADO_FICHADA_ACTUAL", legajo_id);

            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year);
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year);

            HttpContext.Session.SetInt32("TIPO_LISTADO_ACTUAL", tipo_listado);


            return RedirectToAction("Index", "Fichada", new { desde = "busqueda" });

        }


        [HttpPost]
        public void ExportarExcel(int nro_legajo, int legajo_id, DateTime? fecha_desde, DateTime? fecha_hasta, string filtro, string desde, int empresa_id, int ubicacion_id, int sector_id, int lectora_id, string apellido, int tipo_listado)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return ;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            //DateTime? fecha_desde = null;
            //DateTime? fecha_hasta = null;

            HttpContext.Session.SetString("APELLIDO_ACTUAL_FICHADA", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPRESA_ACTUAL_FICHADA", empresa_id);


            HttpContext.Session.SetInt32("UBICACION_ACTUAL_FICHADA", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_ACTUAL_FICHADA", sector_id);

            HttpContext.Session.SetInt32("LECTORA_ACTUAL_FICHADA", lectora_id);


            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

            // HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetInt32("LEGAJO_FICHADA_ACTUAL", nro_legajo);

            HttpContext.Session.SetInt32("EMPLEADO_FICHADA_ACTUAL", legajo_id);

            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", fecha_desde.Value.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Value.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Value.Year);
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", fecha_hasta.Value.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Value.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Value.Year);

            HttpContext.Session.SetInt32("TIPO_LISTADO_ACTUAL", tipo_listado);

            if (HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != null && HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_DESDE"));
            else
                fecha_desde = DateTime.Now.Date;

            if (HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != null && HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_HASTA"));
            else
                fecha_hasta = DateTime.Now.Date;

            if (HttpContext.Session.GetInt32("EMPRESA_ACTUAL_FICHADA") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_ACTUAL_FICHADA");

            if (HttpContext.Session.GetString("APELLIDO_ACTUAL_FICHADA") != null) apellido = HttpContext.Session.GetString("APELLIDO_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("UBICACION_ACTUAL_FICHADA") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("SECTOR_ACTUAL_FICHADA") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("LECTORA_ACTUAL_FICHADA") != null) lectora_id = (int)HttpContext.Session.GetInt32("LECTORA_ACTUAL_FICHADA");


            if (HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL");

            if (HttpContext.Session.GetInt32("TIPO_LISTADO_ACTUAL") != null)
                tipo_listado = (int)HttpContext.Session.GetInt32("TIPO_LISTADO_ACTUAL");
            else
                tipo_listado = 1;



            if (perfil_id > 0)
            {

                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("Legajos");

                    Legajo legajo = new Legajo();
                    ILegajoRepo legajoRepo;
                    legajoRepo = new LegajoRepo();

                    legajo = legajoRepo.Obtener(legajo_id);


                    if (legajo != null)
                    {
                        nro_legajo = legajo.nro_legajo.Value;
                        empresa_id = legajo.empresa_id.Value;
                    }


                    IEnumerable<Fichada> fichadas;
                    IFichadaRepo fichadaRepo;

                    fichadaRepo = new FichadaRepo();

                    DateTime fechaDesde = new DateTime();
                    DateTime fechaHasta = new DateTime();

                    if (fecha_desde != null)
                        if (fecha_desde.Value.Year > 2002)
                            fechaDesde = fecha_desde.Value;
                        else
                              if (fecha_desde.Value.Year != 1)
                            fechaDesde = new DateTime(1, 1, 1);

                    if (fecha_hasta != null)
                        if (fecha_hasta.Value.Year > 2002)
                            fechaHasta = fecha_hasta.Value;
                        else
                              if (fecha_hasta.Value.Year != 1)
                            fechaHasta = new DateTime(1, 1, 1);



                    fichadas = fichadaRepo.ObtenerTodos(
                  (nro_legajo == 0) ? -1 : nro_legajo,
                  fechaDesde,
                  fechaHasta,
                  (empresa_id == 0) ? -1 : empresa_id,
                  (ubicacion_id == 0) ? -1 : ubicacion_id,
                  (sector_id == 0) ? -1 : sector_id,
                  (lectora_id == 0) ? -1 : lectora_id,
                  tipo_listado);

                 

                    var currentRow = 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(currentRow, i).Style.Font.SetBold();
                    }
                    worksheet.Cell(currentRow, 1).Value = "Legajo";
                    worksheet.Cell(currentRow, 2).Value = "Empleado";
                    worksheet.Cell(currentRow, 3).Value = "Empresa";
                    worksheet.Cell(currentRow, 4).Value = "Lectora";
                    worksheet.Cell(currentRow, 5).Value = "Día";
                    worksheet.Cell(currentRow, 6).Value = "Fecha";
                    worksheet.Cell(currentRow, 7).Value = "Hora Entrada";
                    worksheet.Cell(currentRow, 8).Value = "Hora Salida";
                    worksheet.Cell(currentRow, 9).Value = "Hora Entrada";
                    worksheet.Cell(currentRow, 10).Value = "Hora Salida";
                    worksheet.Cell(currentRow, 11).Value = "Hora Entrada";
                    worksheet.Cell(currentRow, 12).Value = "Hora Salida";
                    worksheet.Cell(currentRow, 13).Value = "Hora Entrada";
                    worksheet.Cell(currentRow, 14).Value = "Hora Salida";
                    worksheet.Cell(currentRow, 15).Value = "Cant Hs.";
                    worksheet.Cell(currentRow, 16).Value = "Justificación";


                    foreach (var item in fichadas)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 2).Value = item.apellido + ", " + item.nombre;
                        worksheet.Cell(currentRow, 3).Value = item.empresa;
                        worksheet.Cell(currentRow, 4).Value = item.lectora;
                        worksheet.Cell(currentRow, 5).Value = item.DiaSemana();
                        worksheet.Cell(currentRow, 6).Value = Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy");
                        worksheet.Cell(currentRow, 7).Value = item.hora_entrada_1;
                        worksheet.Cell(currentRow, 8).Value = item.hora_salida_1;
                        worksheet.Cell(currentRow, 9).Value = item.hora_entrada_2;
                        worksheet.Cell(currentRow, 10).Value = item.hora_salida_2;
                        worksheet.Cell(currentRow, 11).Value = item.hora_entrada_3;
                        worksheet.Cell(currentRow, 12).Value = item.hora_salida_3;
                        worksheet.Cell(currentRow, 13).Value = item.hora_entrada_4;
                        worksheet.Cell(currentRow, 14).Value = item.hora_salida_4;
                        worksheet.Cell(currentRow, 15).Value = item.cantidad_horas;
                        worksheet.Cell(currentRow, 16).Value = item.justificacion;



                    }



                    worksheet.Columns().AdjustToContents();

                    using var stream = new MemoryStream();
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=Fichadas.xls");
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


            return;
        }




        [HttpPost]
        public void ExportarCSV(int nro_legajo, int legajo_id, DateTime? fecha_desde, DateTime? fecha_hasta, string filtro, string desde, int empresa_id, int ubicacion_id, int sector_id, int lectora_id, string apellido, int tipo_listado, int completo)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            //DateTime? fecha_desde = null;
            //DateTime? fecha_hasta = null;

            HttpContext.Session.SetString("APELLIDO_ACTUAL_FICHADA", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPRESA_ACTUAL_FICHADA", empresa_id);


            HttpContext.Session.SetInt32("UBICACION_ACTUAL_FICHADA", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_ACTUAL_FICHADA", sector_id);

            HttpContext.Session.SetInt32("LECTORA_ACTUAL_FICHADA", lectora_id);


            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

            // HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetInt32("LEGAJO_FICHADA_ACTUAL", nro_legajo);

            HttpContext.Session.SetInt32("EMPLEADO_FICHADA_ACTUAL", legajo_id);

            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", fecha_desde.Value.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Value.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Value.Year);
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", fecha_hasta.Value.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Value.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Value.Year);

            HttpContext.Session.SetInt32("TIPO_LISTADO_ACTUAL", tipo_listado);

            if (HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != null && HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_DESDE"));
            else
                fecha_desde = DateTime.Now.Date;

            if (HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != null && HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_HASTA"));
            else
                fecha_hasta = DateTime.Now.Date;

            if (HttpContext.Session.GetInt32("EMPRESA_ACTUAL_FICHADA") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_ACTUAL_FICHADA");

            if (HttpContext.Session.GetString("APELLIDO_ACTUAL_FICHADA") != null) apellido = HttpContext.Session.GetString("APELLIDO_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("UBICACION_ACTUAL_FICHADA") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("SECTOR_ACTUAL_FICHADA") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_ACTUAL_FICHADA");

            if (HttpContext.Session.GetInt32("LECTORA_ACTUAL_FICHADA") != null) lectora_id = (int)HttpContext.Session.GetInt32("LECTORA_ACTUAL_FICHADA");



            if (HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL");

            if (HttpContext.Session.GetInt32("TIPO_LISTADO_ACTUAL") != null)
                tipo_listado = (int)HttpContext.Session.GetInt32("TIPO_LISTADO_ACTUAL");
            else
                tipo_listado = 1;



            if (perfil_id > 0)
            {

                MemoryStream mr = new MemoryStream();

                using (TextWriter tw = new StreamWriter(mr))
                {
                   

                    Legajo legajo = new Legajo();
                    ILegajoRepo legajoRepo;
                    legajoRepo = new LegajoRepo();

                    legajo = legajoRepo.Obtener(legajo_id);


                    if (legajo != null)
                    {
                        nro_legajo = legajo.nro_legajo.Value;
                        empresa_id = legajo.empresa_id.Value;
                    }


                    IEnumerable<Fichada> fichadas;
                    IFichadaRepo fichadaRepo;

                    fichadaRepo = new FichadaRepo();

                    DateTime fechaDesde = new DateTime();
                    DateTime fechaHasta = new DateTime();

                    if (fecha_desde != null)
                        if (fecha_desde.Value.Year > 2002)
                            fechaDesde = fecha_desde.Value;
                        else
                              if (fecha_desde.Value.Year != 1)
                            fechaDesde = new DateTime(1, 1, 1);

                    if (fecha_hasta != null)
                        if (fecha_hasta.Value.Year > 2002)
                            fechaHasta = fecha_hasta.Value;
                        else
                              if (fecha_hasta.Value.Year != 1)
                            fechaHasta = new DateTime(1, 1, 1);



                    fichadas = fichadaRepo.ObtenerTodos(
                  (nro_legajo == 0) ? -1 : nro_legajo,
                  fechaDesde,
                  fechaHasta,
                  (empresa_id == 0) ? -1 : empresa_id,
                  (ubicacion_id == 0) ? -1 : ubicacion_id,
                  (sector_id == 0) ? -1 : sector_id,
                  (lectora_id == 0) ? -1 : lectora_id,
                  tipo_listado);




                    //worksheet.Cell(currentRow, 1).Value = "Legajo";
                    //worksheet.Cell(currentRow, 2).Value = "Empleado";
                    //worksheet.Cell(currentRow, 3).Value = "Empresa";
                    //worksheet.Cell(currentRow, 4).Value = "Lectora";
                    //worksheet.Cell(currentRow, 5).Value = "Día";
                    //worksheet.Cell(currentRow, 6).Value = "Fecha";
                    //worksheet.Cell(currentRow, 7).Value = "Hora Entrada";
                    //worksheet.Cell(currentRow, 8).Value = "Hora Salida";
                    //worksheet.Cell(currentRow, 9).Value = "Hora Entrada";
                    //worksheet.Cell(currentRow, 10).Value = "Hora Salida";
                    //worksheet.Cell(currentRow, 11).Value = "Cant Hs.";
                    //worksheet.Cell(currentRow, 12).Value = "Justificación";

                    var currentRow = 1;
                    foreach (var item in fichadas)
                    {
                        currentRow++;
                        if (item.hora_entrada_1!=null)
                        {
                            try
                            {
                                fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_entrada_1, "E", completo);

                                tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                tw.Write(item.hora_entrada_1 + ",");
                                tw.Write("E,");
                                tw.Write(item.lectora_nro + ",");
                                tw.WriteLine(item.nro_legajo);

                            }
                            catch (SqlException ex)
                            {
                                if (ex.Number == 2601 || ex.Number == 2627)
                                {
                                    // Violation in one on both...
                                }
                            }

                           

                        }
                        if (item.hora_salida_1 != null)
                        {

                            try
                            {
                                fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_salida_1, "S", completo);


                                tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                tw.Write(item.hora_salida_1 + ",");
                                tw.Write("S,");
                                tw.Write(item.lectora_nro + ",");
                                tw.WriteLine(item.nro_legajo);


                            }
                            catch (SqlException ex)
                            {
                                if (ex.Number == 2601 || ex.Number == 2627)
                                {
                                    // Violation in one on both...
                                }
                            }


                        }
                        if (item.hora_entrada_2 != null)
                        {

                            try
                            {
                                fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_entrada_2, "E", completo);

                                tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                tw.Write(item.hora_entrada_2 + ",");
                                tw.Write("E,");
                                tw.Write(item.lectora_nro + ",");
                                tw.WriteLine(item.nro_legajo);


                            }
                            catch (SqlException ex)
                            {
                                if (ex.Number == 2601 || ex.Number == 2627)
                                {
                                    // Violation in one on both...
                                }
                            }

                           

                        }
                        if (item.hora_salida_2 != null)
                        {

                            try
                            {
                                fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_salida_2, "E", completo);

                                tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                tw.Write(item.hora_salida_2 + ",");
                                tw.Write("S,");
                                tw.Write(item.lectora_nro + ",");
                                tw.WriteLine(item.nro_legajo);


                            }
                            catch (SqlException ex)
                            {
                                if (ex.Number == 2601 || ex.Number == 2627)
                                {
                                    // Violation in one on both...
                                }
                            }                           


                        }


                        if (item.hora_entrada_3 != null)
                        {

                            try
                            {
                                fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_entrada_3, "E", completo);

                                tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                tw.Write(item.hora_entrada_3 + ",");
                                tw.Write("E,");
                                tw.Write(item.lectora_nro + ",");
                                tw.WriteLine(item.nro_legajo);


                            }
                            catch (SqlException ex)
                            {
                                if (ex.Number == 2601 || ex.Number == 2627)
                                {
                                    // Violation in one on both...
                                }
                            }



                        }
                        if (item.hora_salida_3 != null)
                        {

                            try
                            {
                                fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_salida_3, "E", completo);

                                tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                tw.Write(item.hora_salida_3 + ",");
                                tw.Write("S,");
                                tw.Write(item.lectora_nro + ",");
                                tw.WriteLine(item.nro_legajo);


                            }
                            catch (SqlException ex)
                            {
                                if (ex.Number == 2601 || ex.Number == 2627)
                                {
                                    // Violation in one on both...
                                }
                            }

                        }


                            if (item.hora_entrada_4 != null)
                            {

                                try
                                {
                                    fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_entrada_4, "E", completo);

                                    tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                    tw.Write(item.hora_entrada_4 + ",");
                                    tw.Write("E,");
                                    tw.Write(item.lectora_nro + ",");
                                    tw.WriteLine(item.nro_legajo);


                                }
                                catch (SqlException ex)
                                {
                                    if (ex.Number == 2601 || ex.Number == 2627)
                                    {
                                        // Violation in one on both...
                                    }
                                }



                            }
                            if (item.hora_salida_4 != null)
                            {

                                try
                                {
                                    fichadaRepo.InsertarExportacionFichada(item.nro_legajo.Value, item.lectora_nro.Value, item.fecha.Value, item.hora_salida_4, "E", completo);

                                    tw.Write(Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy") + ",");
                                    tw.Write(item.hora_salida_4 + ",");
                                    tw.Write("S,");
                                    tw.Write(item.lectora_nro + ",");
                                    tw.WriteLine(item.nro_legajo);


                                }
                                catch (SqlException ex)
                                {
                                    if (ex.Number == 2601 || ex.Number == 2627)
                                    {
                                        // Violation in one on both...
                                    }
                                }

                            }

                        //worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
                        //worksheet.Cell(currentRow, 2).Value = item.apellido + ", " + item.nombre;
                        //worksheet.Cell(currentRow, 3).Value = item.empresa;
                        //worksheet.Cell(currentRow, 4).Value = item.lectora;
                        //worksheet.Cell(currentRow, 5).Value = item.DiaSemana();
                        //worksheet.Cell(currentRow, 6).Value = Convert.ToDateTime(item.fecha).ToString("dd/MM/yyyy");
                        //worksheet.Cell(currentRow, 7).Value = item.hora_entrada_1;
                        //worksheet.Cell(currentRow, 8).Value = item.hora_salida_1;
                        //worksheet.Cell(currentRow, 9).Value = item.hora_entrada_2;
                        //worksheet.Cell(currentRow, 10).Value = item.hora_salida_2;
                        //worksheet.Cell(currentRow, 11).Value = item.cantidad_horas;
                        //worksheet.Cell(currentRow, 12).Value = item.justificacion;



                    }



                    tw.Flush();

                    //using var stream = new MemoryStream();
                    //workbook.SaveAs(stream);
                    string nomarch = "Fichadas_" + Convert.ToDateTime(DateTime.Now.Date).ToString("dd/MM/yyyy") + "_" + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + ".txt";
                    var content = mr.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=" + nomarch);
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


            return;
        }



        [HttpGet]
        public JsonResult ObtenerLocales(int empresa_id)
        {
            List<Models.Local> l = new List<Models.Local>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@empresa_id", empresa_id);

                l = con.Query<Models.Local>("spLocalLegajoObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Local(-1, "-- Seleccione el local --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }

        [HttpGet]
        public JsonResult ObtenerSectores(int ubicacion_id, int empresa_id)
        {
            List<Models.Sector> l = new List<Models.Sector>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@ubicacion_id", ubicacion_id);
                parameters.Add("@empresa_id", empresa_id);

                l = con.Query<Models.Sector>("spSectorLegajoObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Sector(-1, "-- Seleccione el sector --", -1, ""));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerUbicaciones(int empresa_id)
        {
            List<Models.Ubicacion> l = new List<Models.Ubicacion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@empresa_id", empresa_id==0?-1:empresa_id);

                // l = con.Query<Models.Ubicacion>("select * from ubicacion order by descripcion", parameters).ToList();
                l = con.Query<Models.Ubicacion>("spUbicacionLegajoObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Ubicacion(-1, "-- Seleccione la ubicación --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }


        [HttpGet]
        public JsonResult ObtenerLectoras(int ubicacion_id, int empresa_id, string? fecha)
        {
            List<Models.Lectora> l = new List<Models.Lectora>();

            if (fecha!= null)
                fecha = fecha.Substring(6, 4) + "-" + fecha.Substring(3, 2) + "-" + fecha.Substring(0, 2);

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@ubicacion_id", ubicacion_id == 0 ? -1 : ubicacion_id);
                parameters.Add("@empresa_id", empresa_id == 0 ? -1 : empresa_id);
                parameters.Add("@fecha", fecha);

                l = con.Query<Models.Lectora>("spLectoraObtenerPorFiltro", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Lectora(-1, "-- Seleccione la lectora --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }

    }
}
