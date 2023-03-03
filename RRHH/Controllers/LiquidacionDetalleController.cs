using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;
using ClosedXML.Excel;

namespace RRHH.Controllers
{
    public class LiquidacionDetalleController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LiquidacionDetalleController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        public IActionResult Index(int liquidacion_id, int empresa_id, int legajo_id, int nro_legajo, int nro_item, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro, string desde)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;


            if (HttpContext.Session.GetInt32("EMPRESA_LIQUIDACION_ACTUAL") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_LIQUIDACION_ACTUAL");
            if (HttpContext.Session.GetInt32("UBICACION_LIQUIDACION_ACTUAL") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_LIQUIDACION_ACTUAL");
            if (HttpContext.Session.GetInt32("SECTOR_LIQUIDACION_ACTUAL") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_LIQUIDACION_ACTUAL");

            if (apellido != null) HttpContext.Session.SetString("APELLIDO_LIQUIDACION_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_LIQUIDACION_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_LIQUIDACION_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_LIQUIDACION_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_LIQUIDACION_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_LIQUIDACION_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_LIQUIDACION_ACTUAL");

            if (HttpContext.Session.GetString("LIQUIDACION_DESDE") != null) desde = HttpContext.Session.GetString("LIQUIDACION_DESDE");



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

                ILiquidacionRepo liqRepo;

                liqRepo = new LiquidacionRepo();

                Liquidacion liq = new Liquidacion();

                liq = liqRepo.Obtener(liquidacion_id);


                ViewData["LiquidacionActual"] = liquidacion_id;
                ViewData["Anio"] = liq.anio;
                ViewData["Mes"] = liq.mes;


                IEnumerable<LiquidacionDetalle> detalle;

                if (desde != "busqueda") return View();

                detalle = liqRepo.ObtenerDetalle(liq.anio,liq.mes,empresa_id,ubicacion_id,sector_id,legajo_id,DateTime.Now,DateTime.Now);



                return View(detalle);

            }



            return View();
        }



        public IActionResult Buscar(int liquidacion_id , int empresa_id, int legajo_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_LIQUIDACION_ACTUAL", empresa_id);

            HttpContext.Session.SetInt32("UBICACION_LIQUIDACION_ACTUAL", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_LIQUIDACION_ACTUAL", sector_id);

            HttpContext.Session.SetInt32("LEGAJO_LIQUIDACION_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_LIQUIDACION_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_LIQUIDACION_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_LIQUIDACION_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("LIQUIDACION_DESDE", "busqueda");

            return RedirectToAction("Index", "LiquidacionDetalle", new { desde = "busqueda", liquidacion_id = liquidacion_id });

        }


        [HttpPost]
        public IActionResult Limpiar(int liquidacion_id, int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {
            HttpContext.Session.SetString("EMPRESA_LIQUIDACION_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_LIQUIDACION_ACTUAL", "");

            HttpContext.Session.SetString("SECTOR_LIQUIDACION_ACTUAL", "");

            HttpContext.Session.SetString("LEGAJO_LIQUIDACION_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_LIQUIDACION_ACTUAL", "");

            HttpContext.Session.SetString("EMPLEADO_LIQUIDACION_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_LIQUIDACION_ACTUAL", "");

            HttpContext.Session.SetString("LIQUIDACION_DESDE", "");


            return RedirectToAction("Index", "LiquidacionDetalle", new { liquidacion_id = liquidacion_id });


        }


        [HttpPost]
        public IActionResult Generar(int liquidacion_id, int empresa_id, int legajo_id, int nro_legajo, int nro_item, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro, string desde)
        {

            string sret;
 
            ILiquidacionRepo liqRepo;
            liqRepo = new LiquidacionRepo();

            sret = liqRepo.Generar(empresa_id, ubicacion_id, sector_id, legajo_id, -1);
 

                if (sret == "")
                {

                  return RedirectToAction("Index", "LiquidacionDetalle", new { liquidacion_id = liquidacion_id });
                }
                else
                {
                    ViewBag.Message = sret;
                    return RedirectToAction("Index", "LiquidacionDetalle", new { liquidacion_id = liquidacion_id });
                }

        }
          




        [HttpPost]
        public void ExportarExcel(int liquidacion_id, int empresa_id, int legajo_id, int nro_legajo, int nro_item, string apellido, int ubicacion_id, int sector_id, int local_id, string filtro, string desde)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 0)
            {

                ILiquidacionRepo liqRepo;

                liqRepo = new LiquidacionRepo();

                Liquidacion liq = new Liquidacion();

                liq = liqRepo.Obtener(liquidacion_id);


                ViewData["LiquidacionActual"] = liquidacion_id;
                ViewData["Anio"] = liq.anio;
                ViewData["Mes"] = liq.mes;


                IEnumerable<LiquidacionDetalle> detalle;


                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("Liquidacion");

                    detalle = liqRepo.ObtenerDetalle(liq.anio, liq.mes, empresa_id, ubicacion_id, sector_id, legajo_id, DateTime.Now, DateTime.Now);


                    var currentRow = 1;
                  
                    worksheet.Cell(currentRow, 1).Value = "Legajo";
                    worksheet.Cell(currentRow, 2).Value = "Apellido";
                    worksheet.Cell(currentRow, 3).Value = "Nombre";
                    worksheet.Cell(currentRow, 4).Value = "Hs. 50";
                    worksheet.Cell(currentRow, 5).Value = "Hs. 50 Fds";
                    worksheet.Cell(currentRow, 6).Value = "Hs. 100";
                    worksheet.Cell(currentRow, 7).Value = "Hs. Fer";
                    worksheet.Cell(currentRow, 8).Value = "Enfer";
                    worksheet.Cell(currentRow, 9).Value = "Accid";
                    worksheet.Cell(currentRow, 10).Value = "Dias Susp";
                    worksheet.Cell(currentRow, 11).Value = "Dias Desc";
                    worksheet.Cell(currentRow, 12).Value = "Dias Vac";
                    worksheet.Cell(currentRow, 13).Value = "Desc Hs.";
                    worksheet.Cell(currentRow, 14).Value = "Pr. Pre";
                    worksheet.Cell(currentRow, 15).Value = "Pr. Asi";
                    worksheet.Cell(currentRow, 16).Value = "Pr. Hor";

                    foreach (var item in detalle)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 2).Value = item.apellido;
                        worksheet.Cell(currentRow, 3).Value = item.nombre;
                        worksheet.Cell(currentRow, 4).Value = item.hs_50;
                        worksheet.Cell(currentRow, 5).Value = item.hs_50_fds;
                        worksheet.Cell(currentRow, 6).Value = item.hs_100;
                        worksheet.Cell(currentRow, 7).Value = item.hs_feriado;
                        worksheet.Cell(currentRow, 8).Value = item.enfermedad;
                        worksheet.Cell(currentRow, 9).Value = item.accidente;
                        worksheet.Cell(currentRow, 10).Value = item.dias_suspension;
                        worksheet.Cell(currentRow, 11).Value = item.dias_descuento;
                        worksheet.Cell(currentRow, 12).Value = item.dias_vacaciones;
                        worksheet.Cell(currentRow, 13).Value = item.descuento_horas;
                        worksheet.Cell(currentRow, 14).Value = item.premio_presentismo;
                        worksheet.Cell(currentRow, 15).Value = item.premio_puntualidad;
                        worksheet.Cell(currentRow, 16).Value = item.premio_horas;


                    }

                    

                    worksheet.Columns().AdjustToContents();

                    using var stream = new MemoryStream();
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=Liquidacion.xls");
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


            return;
        }



    }
}
