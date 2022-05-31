using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;
using ClosedXML.Excel;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace RRHH.Controllers
{
    public class NovedadController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private readonly IWebHostEnvironment _webHostEnvironment;

        public NovedadController(IWebHostEnvironment webHostEnvironment)
        {
            _webHostEnvironment = webHostEnvironment;
        }


        public IActionResult Index(int nro_legajo)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                DateTime fechaDesde = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1); 
                DateTime fechaHasta = DateTime.Now;

                ViewData["CategoriaNovedadActual"] = -1;
                ViewData["TipoNovedadActual"] = -1;
                ViewData["TipoResolucionActual"] = -1;
                ViewData["LegajoActual"] = nro_legajo;
                ViewData["FechaNovedadDesdeActual"] = fechaDesde.Day.ToString().PadLeft(2,'0') + "/" + fechaDesde.Month.ToString().PadLeft(2, '0') + "/" + fechaDesde.Year;
                ViewData["FechaNovedadHastaActual"] = fechaHasta.Day.ToString().PadLeft(2, '0') + "/" + fechaHasta.Month.ToString().PadLeft(2, '0') + "/" + fechaHasta.Year;

                return View(novedadRepo.ObtenerTodos(-1 , -1, -1 ,(nro_legajo==0)?-1:nro_legajo,fechaDesde ,fechaHasta));
            }

            return View();


        }

        [HttpPost]
        public IActionResult Index(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                ViewData["CategoriaNovedadActual"] = categoria_novedad_id;
                ViewData["TipoNovedadActual"] = tipo_novedad_id;
                ViewData["TipoResolucionActual"] = tipo_resolucion_id;
                ViewData["LegajoActual"] = nro_legajo;
                ViewData["FechaNovedadDesdeActual"] = fecha_novedad_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Year;
                ViewData["FechaNovedadHastaActual"] = fecha_novedad_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Year; 

                return View(novedadRepo.ObtenerTodos((categoria_novedad_id==0)?-1:categoria_novedad_id, (tipo_novedad_id == 0)?-1:tipo_novedad_id, (tipo_resolucion_id == 0)?-1:tipo_resolucion_id, (nro_legajo == 0)?-1:nro_legajo,fecha_novedad_desde,fecha_novedad_hasta));
            }

            return View();


        }

        [HttpPost]
        public void  ExportarExcel(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return ;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

               
                IEnumerable <Novedad> l= novedadRepo.ObtenerTodos((categoria_novedad_id == 0) ? -1 : categoria_novedad_id, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta);
                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("Novedades");
                    
                    var currentRow = 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(1, i).Style.Font.SetBold();
                    }
                    worksheet.Cell(currentRow, 1).Value = "Legajo";
                    worksheet.Cell(currentRow, 2).Value = "Apellido";
                    worksheet.Cell(currentRow, 3).Value = "Nombre";
                    worksheet.Cell(currentRow, 4).Value = "Ubicacion";
                    worksheet.Cell(currentRow, 5).Value = "Responsable";
                    worksheet.Cell(currentRow, 6).Value = "Fecha Novedad";
                    worksheet.Cell(currentRow, 7).Value = "Categoría Novedad";
                    worksheet.Cell(currentRow, 8).Value = "Tipo Novedad";
                    worksheet.Cell(currentRow, 9).Value = "Fecha Resolución";
                    worksheet.Cell(currentRow, 10).Value = "Tipo Resolución";
                    worksheet.Cell(currentRow, 11).Value = "Observaciones";

                    foreach (var item in l)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 2).Value = item.apellido;
                        worksheet.Cell(currentRow, 3).Value = item.nombre;
                        worksheet.Cell(currentRow, 4).Value = item.ubicacion;
                        worksheet.Cell(currentRow, 5).Value = item.responsable;
                        worksheet.Cell(currentRow, 6).Value = item.fecha_novedad;
                        worksheet.Cell(currentRow, 7).Value = item.categoria_novedad;
                        worksheet.Cell(currentRow, 8).Value = item.tipo_novedad;
                        worksheet.Cell(currentRow, 9).Value = item.fecha_resolucion;
                        worksheet.Cell(currentRow, 10).Value = item.tipo_resolucion;
                        worksheet.Cell(currentRow, 11).Value = item.observacion;

                    }

                    worksheet.Columns().AdjustToContents();

                    using var stream = new MemoryStream();
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=Novedades.xls");
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


                  return;
            }

       

        [HttpPost]
        public void ExportarPDF(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            string webRootPath = _webHostEnvironment.WebRootPath;
            string contentRootPath = _webHostEnvironment.ContentRootPath;


            if (perfil_id == 1)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                int pdfRowIndex = 1;
                string filename = "Novedades-" + DateTime.Now.ToString("dd-MM-yyyy");
                string filepath = Path.Combine(webRootPath, "data") + "\\" + filename + ".pdf";
                Document document = new iTextSharp.text.Document(PageSize.A4, 5f, 5f, 10f, 10f);
                FileStream fs = new FileStream(filepath, FileMode.Create);

                PdfWriter writer = PdfWriter.GetInstance(document, fs);
                document.Open();

                Font font1 = FontFactory.GetFont(FontFactory.COURIER_BOLD, 10);
                Font font2 = FontFactory.GetFont(FontFactory.COURIER, 8);

                float[] columnDefinitionSize = { 2F, 5F, 2F, 5F };
                PdfPTable table;
                PdfPCell cell;

                table = new PdfPTable(columnDefinitionSize)
                {
                    WidthPercentage = 100
                };

                cell = new PdfPCell
                {
                    BackgroundColor = new BaseColor(0xC0, 0xC0, 0xC0)
                };

                IEnumerable<Novedad> l = novedadRepo.ObtenerTodos((categoria_novedad_id == 0) ? -1 : categoria_novedad_id, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta);


                table.AddCell(new Phrase("Legajo", font1));
                table.AddCell(new Phrase("Apellido", font1));
                table.AddCell(new Phrase("Nombre", font1));
                table.AddCell(new Phrase("Ubicacion", font1));
                table.AddCell(new Phrase("Responsable", font1));
                table.AddCell(new Phrase("Fecha Novedad", font1));
                table.AddCell(new Phrase("Categoría Novedad", font1));
                table.AddCell(new Phrase("Tipo Novedad", font1));
                table.AddCell(new Phrase("Fecha Resolución", font1));
                table.AddCell(new Phrase("Tipo Resolución", font1));
                table.AddCell(new Phrase("Observaciones", font1));
                table.HeaderRows = 1;

                foreach (var item in l)
                {
                    table.AddCell(new Phrase(item.nro_legajo.ToString(), font2));
                    table.AddCell(new Phrase(item.apellido, font2));
                    table.AddCell(new Phrase(item.nombre, font2));
                    table.AddCell(new Phrase(item.ubicacion, font2));
                    table.AddCell(new Phrase(item.responsable, font2));
                    table.AddCell(new Phrase(item.fecha_novedad.ToString(), font2));
                    table.AddCell(new Phrase(item.categoria_novedad, font2));
                    table.AddCell(new Phrase(item.tipo_novedad, font2));
                    table.AddCell(new Phrase(item.fecha_resolucion.ToString(), font2));
                    table.AddCell(new Phrase(item.tipo_resolucion, font2));
                    table.AddCell(new Phrase(item.observacion, font2));

                    pdfRowIndex++;

                }

                document.Add(table);
                document.Close();
                document.CloseDocument();
                document.Dispose();
                writer.Close();
                writer.Dispose();
                fs.Close();
                fs.Dispose();

                FileStream sourceFile = new FileStream(filepath, FileMode.Open);
                float fileSize = 0;
                fileSize = sourceFile.Length;
                byte[] getContent = new byte[Convert.ToInt32(Math.Truncate(fileSize))];
                sourceFile.Read(getContent, 0, Convert.ToInt32(sourceFile.Length));
                sourceFile.Close();
                Response.Clear();
                Response.Headers.Clear();
                Response.ContentType = "application/pdf";
                Response.Headers.Add("Content-Length", getContent.Length.ToString());
                Response.Headers.Add("Content-Disposition", "attachment; filename=" + filename + ".pdf;");
                Response.Body.WriteAsync(getContent);
                Response.Body.Flush();


            }


            return;
        }

        [HttpGet]
        public IActionResult Edit(int? id, int? nro_legajo)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            Novedad novedad = new Novedad();

            if (id != null)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                novedad = novedadRepo.Obtener(id.Value);

                //ViewData["ID"] = nro_legajo.Value;

                ViewData["MODO"] = "E";

                return View(novedad);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";

                if (nro_legajo != null) novedad.nro_legajo = nro_legajo.Value;

                return View(novedad);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, Novedad novedad)
        {

            string sret;
            INovedadRepo novedadRepo;

            ViewData["MODO"] = modo;

            if (valida(novedad))
            {


                novedadRepo = new NovedadRepo();

                if (modo == "E")
                    sret = novedadRepo.Modificar(novedad);
                else
                    sret = novedadRepo.Insertar(novedad);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Novedad");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }
            return View(novedad);
        }


        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            INovedadRepo novedadRepo;

            novedadRepo = new NovedadRepo();

            novedadRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }


        [HttpGet]
        public JsonResult ObtenerCategoriasNovedad()
        {
            List<Models.CategoriaNovedad> l = new List<Models.CategoriaNovedad>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.CategoriaNovedad>("select * from categoria_novedad order by id", parameters).ToList();
            }


            l.Insert(0, new Models.CategoriaNovedad(-1, "-- Seleccione la categoría --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


        [HttpGet]
        public JsonResult ObtenerTiposNovedad()
        {
            List<Models.TipoNovedad> l = new List<Models.TipoNovedad>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.TipoNovedad>("select * from tipo_novedad order by id", parameters).ToList();
            }


            l.Insert(0, new Models.TipoNovedad(-1, "-- Seleccione el tipo de novedad --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


        [HttpGet]
        public JsonResult ObtenerTiposResolucion()
        {
            List<Models.TipoResolucion> l = new List<Models.TipoResolucion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.TipoResolucion>("select * from tipo_resolucion order by id", parameters).ToList();
            }


            l.Insert(0, new Models.TipoResolucion(-1, "-- Seleccione el tipo de resolución --"));

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

            return Json(new SelectList(l, "codigo", "descripcion"));


        }

        [HttpGet]
        public JsonResult ObtenerResponsables()
        {
            List<Models.Responsable> l = new List<Models.Responsable>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Responsable>("spResponsableObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Responsable(-1, "-- Seleccione el responsable --", ""));

            return Json(new SelectList(l, "id", "apellido"));
        }

        [HttpGet]
        public JsonResult ObtenerLegajo(int nro_legajo)
        {
            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            Legajo legajo = new Legajo();

            legajo= legajoRepo.Obtener(nro_legajo);

            if (legajo==null)
            {
                legajo = new Legajo();
                legajo.apellido = "";
                legajo.nombre = "";
            }

            return Json(legajo);
        }


        public Boolean valida(Novedad novedad)
        {

            if (novedad.nro_legajo == null) return false;

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            if(legajoRepo.Obtener(novedad.nro_legajo.Value)==null) return false;
            if (novedad.categoria_novedad_id <= 0) return false;

            if (novedad.tipo_novedad_id <= 0) return false;
            if (novedad.observacion == null) return false;
            if (novedad.observacion.Trim()=="") return false;
            if (novedad.responsable_id <= 0) return false;
            if (novedad.ubicacion_id < 0) return false;

            return true;

        }

    }
}
