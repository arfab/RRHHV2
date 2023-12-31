﻿using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;
using ClosedXML.Excel;
using SelectPdf;

namespace RRHH.Controllers
{
    public class JustificacionController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        //static readonly int cantPag = int.Parse(Tools.GetPaginacionNovedad());

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public JustificacionController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }



        public IActionResult Reset(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            if (perfil_id > 0)
            {

                IJustificacionRepo justificacionRepo;

                justificacionRepo = new JustificacionRepo();


                DateTime fechaDesde = new DateTime();
                DateTime fechaHasta = new DateTime();


                ViewData["EmpresaActual"] = -1;
                ViewData["CategoriaJustificionActual"] = -1;
                ViewData["MomentoJustificionActual"] = -1;

                ViewData["LegajoActual"] = "";
                ViewData["UbicacionActual"] = -1;
                ViewData["SectorActual"] = -1;
                ViewData["LocalActual"] = -1;
                ViewData["ApellidoActual"] = "";


                ViewData["FechaJustificacionDesdeActual"] = "";
                ViewData["FechaJustificacionHastaActual"] = "";

                ViewData["EmpleadoActual"] = -1;
                ViewData["Legajos"] = new string[] { };
                ViewData["FiltroJustificacionActual"] = "";

                HttpContext.Session.SetString("EMPRESA_JUSTIFICACION_ACTUAL", "");
                HttpContext.Session.SetString("LEGAJO_JUSTIFICACION_ACTUAL", "");
                HttpContext.Session.SetString("APELLIDO_JUSTIFICACION_ACTUAL", "");

                HttpContext.Session.SetString("CATEGORIA_JUSTIFICACION_ACTUAL", "");
                HttpContext.Session.SetString("MOMENTO_JUSTIFICACION_ACTUAL", "");


                HttpContext.Session.SetString("FECHA_JUSTIFICACION_DESDE", "");
                HttpContext.Session.SetString("FECHA_JUSTIFICACION_HASTA", "");

                HttpContext.Session.SetString("EMPLEADO_JUSTIFICACION_ACTUAL", "");
                HttpContext.Session.SetString("FILTRO_JUSTIFICACION_ACTUAL", "");

                HttpContext.Session.SetInt32("PAG_NOVEDAD", 1);
        
                return View("Index", justificacionRepo.ObtenerTodos(-1, -1, -1, fechaDesde, fechaHasta, ""));

            }

            return View("Index");


        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


            HttpContext.Session.SetString("EMPRESA_JUSTIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_JUSTIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_JUSTIFICACION_ACTUAL", "");

            HttpContext.Session.SetString("CATEGORIA_JUSTIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("MOMENTO_JUSTIFICACION_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_JUSTIFICACION_DESDE", "");
            HttpContext.Session.SetString("FECHA_JUSTIFICACION_HASTA", "");

            HttpContext.Session.SetString("EMPLEADO_JUSTIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_JUSTIFICACION_ACTUAL", "");

            return RedirectToAction("Index", "Justificacion");


        }


        public IActionResult Index(int categoria_id, int momento_id,  int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, int legajo_id, string filtro, string desde, string fecha, string origen, int nro_item, string[] legajos)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (usuario_id == null || perfil_id == 5 || perfil_id == 6) return RedirectToAction("Login", "Usuario");


            DateTime? fecha_desde = null;
            DateTime? fecha_hasta = null;


            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            if (HttpContext.Session.GetString("FECHA_JUSTIFICACION_DESDE") != null && HttpContext.Session.GetString("FECHA_JUSTIFICACION_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_JUSTIFICACION_DESDE"));

            if (HttpContext.Session.GetString("FECHA_JUSTIFICACION_HASTA") != null && HttpContext.Session.GetString("FECHA_JUSTIFICACION_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_JUSTIFICACION_HASTA"));


            if (apellido != null) HttpContext.Session.SetString("APELLIDO_JUSTIFICACION_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_JUSTIFICACION_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_JUSTIFICACION_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_JUSTIFICACION_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_JUSTIFICACION_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_JUSTIFICACION_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_JUSTIFICACION_ACTUAL");


            if (HttpContext.Session.GetInt32("CATEGORIA_JUSTIFICACION_ACTUAL") != null) categoria_id = (int)HttpContext.Session.GetInt32("CATEGORIA_JUSTIFICACION_ACTUAL");
            if (HttpContext.Session.GetInt32("MOMENTO_JUSTIFICACION_ACTUAL") != null) momento_id = (int)HttpContext.Session.GetInt32("MOMENTO_JUSTIFICACION_ACTUAL");


            if (perfil_id > 0)
            {
                IJustificacionRepo justificacionRepo;

                justificacionRepo = new JustificacionRepo();


                DateTime fechaDesde = new DateTime();
                DateTime fechaHasta = new DateTime();

                if (fecha != null)
                {

                    fecha_desde = Convert.ToDateTime(fecha);
                    fecha_hasta = Convert.ToDateTime(fecha);
                }
                 
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



                ViewData["EmpresaActual"] = empresa_id;
                ViewData["CategoriaJustificacionActual"] = categoria_id;
                ViewData["MomentoJustificacionActual"] = momento_id;

                ViewData["UbicacionActual"] = ubicacion_id;
                ViewData["SectorActual"] = sector_id;
                ViewData["LocalActual"] = local_id;
                ViewData["ApellidoActual"] = apellido;

                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["Legajos"] = legajos;

                ViewData["FiltroJustificacionActual"] = filtro;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(legajo_id);


                if (legajo != null)
                {
                    ViewData["UbicacionActual"] = legajo.ubicacion_id;
                    ViewData["SectorActual"] = legajo.sector_id;
                    ViewData["LocalActual"] = legajo.local_id;
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;

                    ViewData["EmpresaActual"] = legajo.empresa_id;
                    ViewData["LegajoActual"] = legajo.nro_legajo;
                    ViewData["Legajo"] = legajo;
                }

                if (nro_legajo > 0)
                {
                    if (empresa_id <= 0)
                    {
                        ViewBag.Message = "Debe seleccionar la empresa";
                        return View();
                    }
                    else
                    {

                        if (legajo == null)
                        {
                            ViewBag.Message = "No existe el legajo para esa empresa";
                            return View();
                        }
                    }


                }



                if (fechaDesde.Year < 2002)
                {
                    fechaDesde = new DateTime(1, 1, 1);

                    ViewData["FechaJustificacionDesdeActual"] = "";
                }
                else
                {
                    ViewData["FechaJustificacionDesdeActual"] = fechaDesde.Day.ToString().PadLeft(2, '0') + "/" + fechaDesde.Month.ToString().PadLeft(2, '0') + "/" + fechaDesde.Year;

                }

                if (fechaHasta.Year < 2002)
                {
                    fechaHasta = new DateTime(1, 1, 1);

                    ViewData["FechaJustificacionHastaActual"] = "";
                }
                else
                {
                    ViewData["FechaJustificacionHastaActual"] = fechaHasta.Day.ToString().PadLeft(2, '0') + "/" + fechaHasta.Month.ToString().PadLeft(2, '0') + "/" + fechaHasta.Year;

                }

                if (nro_legajo == 0)
                    if (ViewData["FechaJustificacionDesdeActual"] == "" && ViewData["FechaJustificacionHastaActual"] == "")
                        nro_legajo = -2;
                    else
                        nro_legajo = -1;

             
                IEnumerable<Justificacion> justificaciones;

                justificaciones = justificacionRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id,  (categoria_id == 0) ? -1 : categoria_id,  (nro_legajo == 0) ? -1 : nro_legajo, fechaDesde, fechaHasta, (apellido == null) ? "" : apellido);


                if (desde == "busqueda")
                {

                    if (justificaciones.Count() == 0 )
                    {
                        ViewBag.Message = "No existen justificaciones para el criterio seleccionado";
                        return View();
                    }
                }

                return View(justificaciones);

            }



            return View();


        }

      

        [HttpPost]
        public IActionResult Buscar(int categoria_id, int momento_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int empresa_id, string apellido, int ubicacion_id, int sector_id, int local_id, int legajo_id, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_JUSTIFICACION_ACTUAL", empresa_id);
            HttpContext.Session.SetInt32("LEGAJO_JUSTIFICACION_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_JUSTIFICACION_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_JUSTIFICACION_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_JUSTIFICACION_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetInt32("CATEGORIA_JUSTIFICACION_ACTUAL", categoria_id);
            HttpContext.Session.SetInt32("MOMENTO_JUSTIFICACION_ACTUAL", momento_id);


            HttpContext.Session.SetString("FECHA_JUSTIFICACION_DESDE", fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year);
            HttpContext.Session.SetString("FECHA_JUSTIFICACION_HASTA", fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year);

            return RedirectToAction("Index", "Justificacion", new { desde = "busqueda" });

        }


       

        //[HttpPost]
        //public void ExportarExcel(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido, int legajo_id)
        //{
        //    string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

        //    if (usuario_id == null) return;

        //    int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

        //    if (perfil_id > 0)
        //    {

        //        Legajo legajo = new Legajo();
        //        ILegajoRepo legajoRepo;
        //        legajoRepo = new LegajoRepo();
        //        legajo = legajoRepo.Obtener(legajo_id);
        //        if (legajo != null)
        //        {
        //            nro_legajo = legajo.nro_legajo.Value;
        //            empresa_id = legajo.empresa_id.Value;
        //        }

        //        INovedadRepo novedadRepo;

        //        novedadRepo = new NovedadRepo();


        //        using (var workbook = new XLWorkbook())
        //        {
        //            var worksheet = workbook.Worksheets.Add("Novedades");

        //            IEnumerable<Novedad> l = novedadRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, 1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido, perfil_id.Value);


        //            var currentRow = 1;
        //            worksheet.Cell(currentRow, 1).Value = "Sanciones";
        //            worksheet.Cell(currentRow, 1).Style.Font.SetBold();
        //            currentRow += 1;
        //            for (int i = 1; i <= 15; i++)
        //            {
        //                worksheet.Cell(currentRow, i).Style.Font.SetBold();
        //            }
        //            worksheet.Cell(currentRow, 1).Value = "Empresa";
        //            worksheet.Cell(currentRow, 2).Value = "Legajo";
        //            worksheet.Cell(currentRow, 3).Value = "Apellido";
        //            worksheet.Cell(currentRow, 4).Value = "Nombre";
        //            worksheet.Cell(currentRow, 5).Value = "Ubicacion";
        //            worksheet.Cell(currentRow, 6).Value = "Sector";
        //            worksheet.Cell(currentRow, 7).Value = "Responsable";
        //            worksheet.Cell(currentRow, 8).Value = "Fecha Novedad";
        //            worksheet.Cell(currentRow, 9).Value = "Tipo Novedad";
        //            worksheet.Cell(currentRow, 10).Value = "Fecha Resolución";
        //            worksheet.Cell(currentRow, 11).Value = "Tipo Resolución";
        //            worksheet.Cell(currentRow, 12).Value = "Días";
        //            worksheet.Cell(currentRow, 13).Value = "Descripción";
        //            worksheet.Cell(currentRow, 14).Value = "Observación";
        //            worksheet.Cell(currentRow, 15).Value = "Estado";

        //            foreach (var item in l)
        //            {
        //                currentRow++;
        //                worksheet.Cell(currentRow, 1).Value = item.empresa;
        //                worksheet.Cell(currentRow, 2).Value = item.nro_legajo;
        //                worksheet.Cell(currentRow, 3).Value = item.apellido;
        //                worksheet.Cell(currentRow, 4).Value = item.nombre;
        //                worksheet.Cell(currentRow, 5).Value = item.ubicacion;
        //                worksheet.Cell(currentRow, 6).Value = item.sector;
        //                worksheet.Cell(currentRow, 7).Value = item.responsable;
        //                worksheet.Cell(currentRow, 8).Value = item.fecha_novedad;
        //                worksheet.Cell(currentRow, 9).Value = item.tipo_novedad;
        //                worksheet.Cell(currentRow, 10).Value = item.fecha_resolucion;
        //                worksheet.Cell(currentRow, 11).Value = item.tipo_resolucion;
        //                worksheet.Cell(currentRow, 12).Value = item.dias;
        //                worksheet.Cell(currentRow, 13).Value = item.descripcion;
        //                worksheet.Cell(currentRow, 14).Value = item.observacion;
        //                worksheet.Cell(currentRow, 15).Value = item.estado;


        //            }

        //            if (nro_legajo > 0)
        //            {

        //                l = novedadRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, 2, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido, perfil_id.Value);

        //                currentRow += 2;
        //                worksheet.Cell(currentRow, 1).Value = "Felicitaciones";
        //                worksheet.Cell(currentRow, 1).Style.Font.SetBold();
        //                currentRow += 1;
        //                for (int i = 1; i <= 11; i++)
        //                {
        //                    worksheet.Cell(currentRow, i).Style.Font.SetBold();
        //                }

        //                worksheet.Cell(currentRow, 1).Value = "Legajo";
        //                worksheet.Cell(currentRow, 2).Value = "Apellido";
        //                worksheet.Cell(currentRow, 3).Value = "Nombre";
        //                worksheet.Cell(currentRow, 4).Value = "Ubicacion";
        //                worksheet.Cell(currentRow, 5).Value = "Sector";
        //                worksheet.Cell(currentRow, 6).Value = "Responsable";
        //                worksheet.Cell(currentRow, 7).Value = "Fecha Novedad";
        //                worksheet.Cell(currentRow, 8).Value = "Tipo Novedad";
        //                worksheet.Cell(currentRow, 9).Value = "Descripción";
        //                worksheet.Cell(currentRow, 10).Value = "Observación";
        //                worksheet.Cell(currentRow, 11).Value = "Estado";
        //                currentRow += 1;
        //                foreach (var item in l)
        //                {
        //                    currentRow++;
        //                    worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
        //                    worksheet.Cell(currentRow, 2).Value = item.apellido;
        //                    worksheet.Cell(currentRow, 3).Value = item.nombre;
        //                    worksheet.Cell(currentRow, 4).Value = item.ubicacion;
        //                    worksheet.Cell(currentRow, 5).Value = item.sector;
        //                    worksheet.Cell(currentRow, 6).Value = item.responsable;
        //                    worksheet.Cell(currentRow, 7).Value = item.fecha_novedad;
        //                    worksheet.Cell(currentRow, 8).Value = item.tipo_novedad;
        //                    worksheet.Cell(currentRow, 9).Value = item.descripcion;
        //                    worksheet.Cell(currentRow, 10).Value = item.observacion;
        //                    worksheet.Cell(currentRow, 11).Value = item.estado;

        //                }
        //            }

        //            worksheet.Columns().AdjustToContents();

        //            using var stream = new MemoryStream();
        //            workbook.SaveAs(stream);
        //            var content = stream.ToArray();
        //            Response.Clear();
        //            Response.Headers.Add("content-disposition", "attachment;filename=Novedades.xls");
        //            Response.ContentType = "application/xls";
        //            Response.Body.WriteAsync(content);
        //            Response.Body.Flush();
        //        }
        //    }


        //    return;
        //}



        [HttpGet]
        public IActionResult Edit(int? id, int? nro_legajo, int? empresa_id, int? ubicacion_id, int? sector_id, int? local_id, string origen, int? legajo_id, string modo, string fecha, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            Justificacion justificacion = new Justificacion();

            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            if (id != null)
            {
                IJustificacionRepo justificacionRepo;

                justificacionRepo = new JustificacionRepo();

                justificacion = justificacionRepo.Obtener(id.Value);

                if (justificacion == null) return RedirectToAction("Index", "Justificacion");

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();
                legajo = legajoRepo.Obtener(justificacion.legajo_id.Value);

                if (perfil_id == 4 && legajo.ubicacion_id != 3) return RedirectToAction("Index", "Justificacion");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                justificacion.empresa_id = legajo.empresa_id;
                justificacion.nro_legajo = legajo.nro_legajo;


                ViewData["EMPRESA_ID"] = justificacion.empresa_id;
                ViewData["NRO_LEGAJO"] = justificacion.nro_legajo;
                ViewData["FiltroJustificacionActual"] = justificacion.nro_legajo;
                ViewData["EmpleadoActual"] = justificacion.legajo_id;
                ViewData["Legajos"] = justificacion.legajos;

                return View(justificacion);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";

                if (fecha != null)
                {
                    justificacion.fecha_desde = DateTime.Parse(fecha);
                    justificacion.fecha_hasta = DateTime.Parse(fecha);
                }
                if (nro_legajo != null) justificacion.nro_legajo = nro_legajo.Value;
                if (empresa_id != null) justificacion.empresa_id = empresa_id.Value;
                if (ubicacion_id != null) justificacion.ubicacion_id = ubicacion_id.Value;
                if (sector_id != null) justificacion.sector_id = sector_id.Value;
                if (local_id != null) justificacion.local_id = local_id.Value;
                if (legajo_id != null) justificacion.legajo_id = legajo_id.Value;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();
                legajo = legajoRepo.Obtener(legajo_id.Value);


                if (legajo != null)
                {
                    justificacion.nro_legajo = legajo.nro_legajo.Value;
                    justificacion.empresa_id = legajo.empresa_id.Value;

                    ViewData["EMPRESA_ID"] = justificacion.empresa_id;
                    ViewData["NRO_LEGAJO"] = justificacion.nro_legajo;
                    ViewData["FiltroJustificacionActual"] = justificacion.nro_legajo;
                    ViewData["EmpleadoActual"] = justificacion.legajo_id;
                    ViewData["Legajos"] = justificacion.legajos;
                }

                return View(justificacion);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, string legajos, Justificacion justificacion, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret="";

            IJustificacionRepo justificacionRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            ViewData["UBICACION_ID"] = justificacion.ubicacion_id;
            ViewData["SECTOR_ID"] = justificacion.sector_id;


            string mensaje = "";
            if (valida(justificacion,ref mensaje))
            {


                justificacionRepo = new JustificacionRepo();

                if (modo == "E" || modo == null)
                    sret = justificacionRepo.Modificar(justificacion, usuario_id.Value);
                else
                {
                    if (justificacion.legajo_id != null && (legajos == null || legajos == ""))
                        sret = justificacionRepo.Insertar(justificacion, usuario_id.Value);
                    else
                    {
                        string[] legajos_id = legajos.Split(',');

                        foreach (string s in legajos_id)
                        {
                            justificacion.legajo_id = Int32.Parse(s);
                            sret = justificacionRepo.Insertar(justificacion, usuario_id.Value);
                            if (sret != "")
                            {

                                ViewBag.Message = sret;
                            }
                        }
                    }
                }


                if (sret == "")
                {
                    if (origen=="F")
                       return RedirectToAction("Index", "Fichada", new { item_actual = ViewData["ITEM_ACTUAL"], desde="busqueda" });
                    else
                       return RedirectToAction("Index", "Justificacion");

                }
               

            }
            else
            {
                ViewBag.Message = mensaje;
            }

            ViewData["EMPRESA_ID"] = justificacion.empresa_id;
            ViewData["NRO_LEGAJO"] = justificacion.nro_legajo;
            ViewData["FiltroJustificacionActual"] = justificacion.nro_legajo;
            ViewData["EmpleadoActual"] = justificacion.legajo_id;
            ViewData["Legajos"] = justificacion.legajos;
            ViewData["LegajoActual"] = justificacion.nro_legajo;

            return View(justificacion);
        }



        public IActionResult Delete(int hfID, string origen, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            IJustificacionRepo justificacionRepo;

            justificacionRepo = new JustificacionRepo();

            justificacionRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "Fichada", new { item_actual = ViewData["ITEM_ACTUAL"], desde="busqueda" });
            else
                return RedirectToAction("Index", "Justificacion");

        }


        [HttpGet]
        public JsonResult ObtenerCategorias()
        {
            List<Models.CategoriaJustificacion> l = new List<Models.CategoriaJustificacion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.CategoriaJustificacion>("spCategoriaJustificacionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.CategoriaJustificacion(-1, "-- Seleccione la categoría --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerMomentos()
        {
            List<Models.MomentoJustificacion> l = new List<Models.MomentoJustificacion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.MomentoJustificacion>("spMomentoJustificacionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


          //  l.Insert(0, new Models.MomentoJustificacion(-1, "-- Seleccione el momento --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


        [HttpGet]
        public JsonResult ObtenerUbicaciones()
        {
            List<Models.Ubicacion> l = new List<Models.Ubicacion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                // l = con.Query<Models.Ubicacion>("select * from ubicacion order by descripcion", parameters).ToList();
                l = con.Query<Models.Ubicacion>("spUbicacionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Ubicacion(-1, "-- Seleccione la ubicación --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }


        [HttpGet]
        public JsonResult ObtenerSectores(int ubicacion_id)
        {
            List<Models.Sector> l = new List<Models.Sector>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@ubicacion_id", ubicacion_id);

                l = con.Query<Models.Sector>("spSectorObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Sector(-1, "-- Seleccione el sector --", -1, ""));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerLocales()
        {
            List<Models.Local> l = new List<Models.Local>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                // l = con.Query<Models.Ubicacion>("select * from ubicacion order by descripcion", parameters).ToList();
                l = con.Query<Models.Local>("spLocalObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Local(-1, "-- Seleccione el local --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }

      

        [HttpGet]
        public JsonResult ObtenerLegajo(int empresa_id, int nro_legajo)
        {
            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            Legajo legajo = new Legajo();

            legajo = legajoRepo.ObtenerPorNro(empresa_id, nro_legajo);

            if (legajo == null)
            {
                legajo = new Legajo();
                legajo.apellido = "";
                legajo.nombre = "";
            }

            return Json(legajo);
        }


        public Boolean valida(Justificacion justificacion,ref string mensaje)
        {

            if (justificacion.legajo_id == null && justificacion.legajos==null)
            {
                mensaje = "Debe seleccionar al menos un legajo";
                return false;
            }

            if (justificacion.legajo_id<0)
            {
                mensaje = "Debe seleccionar al menos un legajo";
                return false; 
            }

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            //if (legajoRepo.Obtener(justificacion.legajo_id.Value) == null) return false;
            if (justificacion.categoria_id <= 0) return false;
           
            //if (justificacion.descripcion == null) return false;
            //if (justificacion.descripcion.Trim() == "") return false;

            //if (justificacion.ubicacion_id < 0) return false;


            return true;

        }

        [AcceptVerbs("GET", "POST")]
        public IActionResult LegajoExiste(int nro_legajo, int empresa_id)
        {
            bool result;

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            if (legajoRepo.ObtenerPorNro(empresa_id, nro_legajo) == null)
                result = false;
            else
                result = true;

            return Json(result);
        }



    }
}
