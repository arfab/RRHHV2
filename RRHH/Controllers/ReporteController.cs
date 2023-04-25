using Microsoft.AspNetCore.Mvc;
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
    public class ReporteController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public ReporteController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        public IActionResult Viaticos(int empresa_id, int legajo_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro, string desde)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

        

            if (HttpContext.Session.GetInt32("EMPRESA_VIATICOS_ACTUAL") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_VIATICOS_ACTUAL");
            if (HttpContext.Session.GetInt32("UBICACION_VIATICOS_ACTUAL") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_VIATICOS_ACTUAL");
            if (HttpContext.Session.GetInt32("SECTOR_VIATICOS_ACTUAL") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_VIATICOS_ACTUAL");



            if (HttpContext.Session.GetString("FECHA_VIATICOS_DESDE") != null && HttpContext.Session.GetString("FECHA_VIATICOS_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_VIATICOS_DESDE"));

            if (HttpContext.Session.GetString("FECHA_VIATICOS_HASTA") != null && HttpContext.Session.GetString("FECHA_VIATICOS_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_VIATICOS_HASTA"));


            if (apellido != null) HttpContext.Session.SetString("APELLIDO_VIATICOS_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_VIATICOS_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_VIATICOS_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_VIATICOS_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_VIATICOS_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_VIATICOS_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_VIATICOS_ACTUAL");

            if (HttpContext.Session.GetString("VIATICOS_DESDE") != null) desde = HttpContext.Session.GetString("VIATICOS_DESDE");

            if (perfil_id > 0)
            {



                ViewData["EMPRESA_ID"] = empresa_id;

                ViewData["UBICACION_ID"] = ubicacion_id;
                ViewData["SECTOR_ID"] = sector_id;
                ViewData["LocalActual"] = local_id;
                ViewData["ApellidoActual"] = apellido;
                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["FiltroActual"] = filtro;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(legajo_id);


                if (legajo != null)
                {
                    ViewData["UBICACION_ID"] = ubicacion_id;
                    ViewData["SECTOR_ID"] = sector_id;
                    ViewData["LocalActual"] = legajo.local_id;
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;

                    ViewData["EMPRESA_ID"] = legajo.empresa_id;
                    ViewData["LegajoActual"] = legajo.nro_legajo;
                    ViewData["Legajo"] = legajo;
                }

                if (fecha_desde.Year<1000)
                {
                    fecha_desde = DateTime.Now.Date;
                }

                if (fecha_hasta.Year < 1000)
                { 
                    fecha_hasta = DateTime.Now.Date;
                }


                ViewData["FechaDesdeActual"] = fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year;

                ViewData["FechaHastaActual"] = fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year;


                if (desde != "busqueda") return View();

                IReporteRepo reporteRepo;

                reporteRepo = new ReporteRepo();

                IEnumerable<Viatico> viaticos;

                viaticos = reporteRepo.ReporteViaticos((empresa_id == 0) ? -1 : empresa_id, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (legajo_id == 0) ? -1 : legajo_id, fecha_desde, fecha_hasta);

                return View(viaticos);
            }

            

            return View();
        }

        public IActionResult BuscarViaticos(int empresa_id, int legajo_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido, int ubicacion_id, int sector_id, int local_id,  string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_VIATICOS_ACTUAL", empresa_id);

            HttpContext.Session.SetInt32("UBICACION_VIATICOS_ACTUAL", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_VIATICOS_ACTUAL", sector_id);

            HttpContext.Session.SetInt32("LEGAJO_VIATICOS_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_VIATICOS_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_VIATICOS_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_VIATICOS_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("FECHA_VIATICOS_DESDE", fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year);
            HttpContext.Session.SetString("FECHA_VIATICOS_HASTA", fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year);

            HttpContext.Session.SetString("VIATICOS_DESDE", "busqueda");

            return RedirectToAction("Viaticos", "Reporte", new { desde = "busqueda" });

        }


        [HttpPost]
        public IActionResult LimpiarViaticos(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {
            HttpContext.Session.SetString("EMPRESA_VIATICOS_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_VIATICOS_ACTUAL", "");

            HttpContext.Session.SetString("SECTOR_VIATICOS_ACTUAL", "");

            HttpContext.Session.SetString("LEGAJO_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_VIATICOS_ACTUAL", "");

            HttpContext.Session.SetString("EMPLEADO_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_VIATICOS_ACTUAL", "");


            HttpContext.Session.SetString("FECHA_VIATICOS_DESDE", "");
            HttpContext.Session.SetString("FECHA_VIATICOS_HASTA", "");

            HttpContext.Session.SetString("VIATICOS_DESDE", "");


            return RedirectToAction("Viaticos", "Reporte");


        }


        [HttpPost]
        public void ExportarViaticos(int empresa_id, int ubicacion_id, int sector_id,  int legajo_id, DateTime fecha_desde, DateTime fecha_hasta)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

           

            if (perfil_id > 0)
            {

                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("ReporteViaticos");

                    IReporteRepo reporteRepo;

                    reporteRepo = new ReporteRepo();

                    IEnumerable<Viatico> viaticos;

                    viaticos = reporteRepo.ReporteViaticos((empresa_id == 0) ? -1 : empresa_id, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (legajo_id == 0) ? -1 : legajo_id, fecha_desde, fecha_hasta);



                    var currentRow = 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(currentRow, i).Style.Font.SetBold();
                    }
                    worksheet.Cell(currentRow, 1).Value = "Empresa";
                    worksheet.Cell(currentRow, 2).Value = "Legajo";
                    worksheet.Cell(currentRow, 3).Value = "Apellido";
                    worksheet.Cell(currentRow, 4).Value = "Nombre";
                    worksheet.Cell(currentRow, 5).Value = "Cantidad";


                    foreach (var item in viaticos)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.empresa;
                        worksheet.Cell(currentRow, 2).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 3).Value = item.apellido;
                        worksheet.Cell(currentRow, 4).Value = item.nombre;
                        worksheet.Cell(currentRow, 5).Value = item.cantidad;

                    }



                    worksheet.Columns().AdjustToContents();

                    using var stream = new MemoryStream();
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=ReporteViaticos.xls");
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


            return;
        }






        public IActionResult Verificacion(int empresa_id, int legajo_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro, string desde)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            if (HttpContext.Session.GetInt32("EMPRESA_VERIFICACION_ACTUAL") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_VERIFICACION_ACTUAL");
            if (HttpContext.Session.GetInt32("UBICACION_VERIFICACION_ACTUAL") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_VERIFICACION_ACTUAL");
            if (HttpContext.Session.GetInt32("SECTOR_VERIFICACION_ACTUAL") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_VERIFICACION_ACTUAL");



            if (HttpContext.Session.GetString("FECHA_VERIFICACION_DESDE") != null && HttpContext.Session.GetString("FECHA_VERIFICACION_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_VERIFICACION_DESDE"));

            if (HttpContext.Session.GetString("FECHA_VERIFICACION_HASTA") != null && HttpContext.Session.GetString("FECHA_VERIFICACION_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_VERIFICACION_HASTA"));


            if (apellido != null) HttpContext.Session.SetString("APELLIDO_VERIFICACION_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_VIATICOS_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_VIATICOS_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_VERIFICACION_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_VERIFICACION_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_VERIFICACION_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_VERIFICACION_ACTUAL");

            if (HttpContext.Session.GetString("VERIFICACION_DESDE") != null) desde = HttpContext.Session.GetString("VERIFICACION_DESDE");


            if (perfil_id > 0)
            {



                ViewData["EMPRESA_ID"] = empresa_id;

                ViewData["UBICACION_ID"] = ubicacion_id;
                ViewData["SECTOR_ID"] = sector_id;
                ViewData["LocalActual"] = local_id;
                ViewData["ApellidoActual"] = apellido;
                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["FiltroActual"] = filtro;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(legajo_id);


                if (legajo != null)
                {
                    ViewData["UBICACION_ID"] = ubicacion_id;
                    ViewData["SECTOR_ID"] = sector_id;
                    ViewData["LocalActual"] = legajo.local_id;
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;

                    ViewData["EMPRESA_ID"] = legajo.empresa_id;
                    ViewData["LegajoActual"] = legajo.nro_legajo;
                    ViewData["Legajo"] = legajo;
                }

                if (fecha_desde.Year < 1000)
                {
                    fecha_desde = DateTime.Now;
                }

                if (fecha_hasta.Year < 1000)
                {
                    fecha_hasta = DateTime.Now;
                }


                ViewData["FechaDesdeActual"] = fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year;

                ViewData["FechaHastaActual"] = fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year;

                if (desde != "busqueda") return View();

                IReporteRepo reporteRepo;

                reporteRepo = new ReporteRepo();

                IEnumerable<Verificacion> verificacion;

                verificacion = reporteRepo.ReporteVerificacion((empresa_id == 0) ? -1 : empresa_id, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (legajo_id == 0) ? -1 : legajo_id, fecha_desde, fecha_hasta);

                return View(verificacion);
            }



            return View();
        }

        public IActionResult BuscarVerificacion(int empresa_id, int legajo_id, int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_VERIFICACION_ACTUAL", empresa_id);

            HttpContext.Session.SetInt32("UBICACION_VERIFICACION_ACTUAL", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_VERIFICACION_ACTUAL", sector_id);

            HttpContext.Session.SetInt32("LEGAJO_VERIFICACION_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_VERIFICACION_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_VERIFICACION_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_VERIFICACION_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("FECHA_VERIFICACION_DESDE", fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year);
            HttpContext.Session.SetString("FECHA_VERIFICACION_HASTA", fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year);

            HttpContext.Session.SetString("VERIFICACION_DESDE", "busqueda");


            return RedirectToAction("Verificacion", "Reporte", new { desde = "busqueda" });

        }


        [HttpPost]
        public IActionResult LimpiarVerificacion(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {
            HttpContext.Session.SetString("EMPRESA_VERIFICACION_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_VERIFICACION_ACTUAL", "");

            HttpContext.Session.SetString("SECTOR_VERIFICACION_ACTUAL", "");

            HttpContext.Session.SetString("LEGAJO_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_VERIFICACION_ACTUAL", "");

            HttpContext.Session.SetString("EMPLEADO_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_VERIFICACION_ACTUAL", "");


            HttpContext.Session.SetString("FECHA_VERIFICACION_DESDE", "");
            HttpContext.Session.SetString("FECHA_VERIFICACION_HASTA", "");

            HttpContext.Session.SetString("VERIFICACION_DESDE", "");

            return RedirectToAction("Verificacion", "Reporte");


        }


        [HttpPost]
        public void ExportarVerificacion(int empresa_id, int ubicacion_id, int sector_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            if (perfil_id > 0)
            {

                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("ReporteVerificacion");

                    IReporteRepo reporteRepo;

                    reporteRepo = new ReporteRepo();

                    IEnumerable<Verificacion> verificacion;

                    verificacion = reporteRepo.ReporteVerificacion((empresa_id == 0) ? -1 : empresa_id, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (legajo_id == 0) ? -1 : legajo_id, fecha_desde, fecha_hasta);



                    var currentRow = 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(currentRow, i).Style.Font.SetBold();
                    }
                    worksheet.Cell(currentRow, 1).Value = "Legajo";
                    worksheet.Cell(currentRow, 2).Value = "Apellido";
                    worksheet.Cell(currentRow, 3).Value = "Nombre";
                    worksheet.Cell(currentRow, 4).Value = "Sin Fichar";
                    worksheet.Cell(currentRow, 5).Value = "Justificacas";


                    foreach (var item in verificacion)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 2).Value = item.apellido;
                        worksheet.Cell(currentRow, 3).Value = item.nombre;
                        worksheet.Cell(currentRow, 4).Value = item.no_fichadas;
                        worksheet.Cell(currentRow, 5).Value = item.justificadas;

                    }



                    worksheet.Columns().AdjustToContents();

                    using var stream = new MemoryStream();
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=ReporteVerificacion.xls");
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


            return;
        }





    }
}
