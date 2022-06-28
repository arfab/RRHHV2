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
    public class LegajoController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        static readonly int cantPag = int.Parse(Tools.GetPaginacionLegajo());


        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LegajoController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Reset()
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");




            if (perfil_id > 0)
            {

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                ViewData["APELLIDO"] = "" ;
                ViewData["NRO_LEGAJO"] = "";
                ViewData["EMPRESA_ID"] = -1;

                ViewData["UBICACION_ID"] = -1;
                ViewData["SECTOR_ID"] = -1;

                ViewData["EmpleadoActual"] = -1;
                ViewData["FiltroActual"] = "";
                ViewData["ActivoActual"] = -1;

                HttpContext.Session.SetString("EMPRESA_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("LEGAJO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("APELLIDO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("UBICACION_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("SECTOR_ACTUAL_LEGAJO", "");

                HttpContext.Session.SetString("EMPLEADO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("FILTRO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("ACTIVO_ACTUAL_LEGAJO", "");

                HttpContext.Session.SetInt32("PAG_LEGAJO", 1);

                int cant = legajoRepo.ObtenerCantidad( -1, -1,-1,-1, "" , -1);
                ViewData["TOTAL_LEGAJOS"] = cant;

                HttpContext.Session.SetInt32("TOT_PAG_LEGAJO", cant % cantPag == 0 ? cant / cantPag : cant / cantPag + 1);

                return View("Index", legajoRepo.ObtenerPagina(1,-1, -1,-1, -1, "", -1));

            }

            return View("Index");


        }

        [HttpGet]
        public IActionResult Index(int empresa_id, int nro_legajo, int ubicacion_id, int sector_id, string apellido, int empleado_id, string filtro, int activo, int modo, string desde="") 
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");


            //if (HttpContext.Session.GetInt32("EMPRESA_ACTUAL_LEGAJO") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_ACTUAL_LEGAJO");
            //if (HttpContext.Session.GetInt32("LEGAJO_ACTUAL_LEGAJO") != null) nro_legajo = (int)HttpContext.Session.GetInt32("LEGAJO_ACTUAL_LEGAJO");
          
            if (HttpContext.Session.GetString("APELLIDO_ACTUAL_LEGAJO") != null) apellido = HttpContext.Session.GetString("APELLIDO_ACTUAL_LEGAJO");

            if (HttpContext.Session.GetInt32("UBICACION_ACTUAL_LEGAJO") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_ACTUAL_LEGAJO");

            if (HttpContext.Session.GetInt32("SECTOR_ACTUAL_LEGAJO") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_ACTUAL_LEGAJO");

            if (HttpContext.Session.GetInt32("EMPLEADO_ACTUAL_LEGAJO") != null) empleado_id = (int)HttpContext.Session.GetInt32("EMPLEADO_ACTUAL_LEGAJO");
            if (HttpContext.Session.GetString("FILTRO_ACTUAL_LEGAJO") != null) filtro = HttpContext.Session.GetString("FILTRO_ACTUAL_LEGAJO");

            if (HttpContext.Session.GetInt32("ACTIVO_ACTUAL_LEGAJO") != null) activo = (int)HttpContext.Session.GetInt32("ACTIVO_ACTUAL_LEGAJO");


            if (perfil_id > 0 && perfil_id <= 3)
            {
                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                IEnumerable<Legajo> legajos;

                ViewData["APELLIDO"] = apellido;
                //ViewData["NRO_LEGAJO"] = nro_legajo;
                //ViewData["EMPRESA_ID"] = empresa_id;

                ViewData["UBICACION_ID"] = ubicacion_id;
                ViewData["SECTOR_ID"] = sector_id;


                ViewData["EmpleadoActual"] = empleado_id;
                ViewData["FiltroActual"] = filtro;
                ViewData["ActivoActual"] = activo;

                Legajo legajo = new Legajo();
                legajo = legajoRepo.Obtener(empleado_id);

                if (legajo != null)
                {
                    ViewData["APELLIDO"] = legajo.apellido;
                    //ViewData["NRO_LEGAJO"] = legajo.nro_legajo.Value;
                    //ViewData["EMPRESA_ID"]  = legajo.empresa_id.Value;
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;
                    apellido = legajo.apellido;
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
                        Legajo legajo2 = new Legajo();
                        legajo2 = legajoRepo.ObtenerPorNro(empresa_id, nro_legajo);

                        if (legajo2 == null)
                        {
                            ViewBag.Message = "No existe el legajo para esa empresa";
                            return View();
                        }
                    }


                }

               if (desde == "busqueda") { 
                    HttpContext.Session.SetInt32("PAG_LEGAJO", 1);
                    HttpContext.Session.SetInt32("TOT_PAG_LEGAJO", 1);
               }

                int? pag_legajo = HttpContext.Session.GetInt32("PAG_LEGAJO");

                if (pag_legajo == null)
                {
                    pag_legajo = 1;
                    HttpContext.Session.SetInt32("PAG_LEGAJO", 1);
                }

                int cant = legajoRepo.ObtenerCantidad((empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (apellido == null) ? "" : apellido,activo);
                ViewData["TOTAL_LEGAJOS"] = cant;

                HttpContext.Session.SetInt32("TOT_PAG_LEGAJO", cant % cantPag == 0 ? cant / cantPag : cant / cantPag + 1);

                legajos = legajoRepo.ObtenerPagina(pag_legajo.Value,(empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (apellido == null) ? "" : apellido, activo);

                if (desde == "busqueda")
                {
                    if (legajos.Count() == 0)
                    {
                        ViewBag.Message = "No existen legajos para el criterio seleccionado";
                        return View();
                    }
                }

                return View(legajos);

            }

            return RedirectToAction("Login", "Usuario");


        }

        [HttpPost]
        public IActionResult Index(int empresa_id, int nro_legajo, int ubicacion_id, int sector_id, string apellido, int empleado_id, string filtro, int activo)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id >0 && perfil_id <=3)
            {
                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                IEnumerable<Legajo> legajos;

                ViewData["APELLIDO"] = apellido;
                //ViewData["NRO_LEGAJO"] = nro_legajo;
                //ViewData["EMPRESA_ID"] = empresa_id;


                ViewData["UBICACION_ID"] = ubicacion_id;
                ViewData["SECTOR_ID"] = sector_id;

                ViewData["EmpleadoActual"] = empleado_id;
                ViewData["FiltroActual"] = filtro;
                ViewData["ActivoActual"] = activo;

                Legajo legajo = new Legajo();
                legajo = legajoRepo.Obtener(empleado_id);

                if (legajo != null)
                {
                    ViewData["APELLIDO"] = legajo.apellido;
                    //ViewData["NRO_LEGAJO"] = legajo.nro_legajo.Value;
                    //ViewData["EMPRESA_ID"] = legajo.empresa_id.Value;
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;
                    apellido = legajo.apellido;
                }


                //HttpContext.Session.SetInt32("EMPRESA_ACTUAL_LEGAJO", empresa_id);
                //HttpContext.Session.SetInt32("LEGAJO_ACTUAL_LEGAJO", nro_legajo);
                HttpContext.Session.SetString("APELLIDO_ACTUAL_LEGAJO", (apellido==null)?"":apellido);

                HttpContext.Session.SetInt32("UBICACION_ACTUAL_LEGAJO", ubicacion_id);

                HttpContext.Session.SetInt32("SECTOR_ACTUAL_LEGAJO", sector_id);

                HttpContext.Session.SetInt32("EMPLEADO_ACTUAL_LEGAJO", empleado_id);
                HttpContext.Session.SetString("FILTRO_ACTUAL_LEGAJO", (filtro == null) ? "" : filtro);
                HttpContext.Session.SetInt32("ACTIVO_ACTUAL_LEGAJO", activo);



                if (nro_legajo > 0)
                {
                    if (empresa_id <= 0)
                    {
                        ViewBag.Message = "Debe seleccionar la empresa";
                        return View();
                    }
                    else
                    {
                        Legajo legajo2 = new Legajo();
                        legajo2 = legajoRepo.ObtenerPorNro(empresa_id, nro_legajo);

                        if (legajo2 == null)
                        {
                            ViewBag.Message = "No existe el legajo para esa empresa";
                            return View();
                        }
                    }


                }

                HttpContext.Session.SetInt32("PAG_LEGAJO", 1);

                int? pag_legajo = HttpContext.Session.GetInt32("PAG_LEGAJO");

                //if (pag_legajo == null)
                //{
                //    pag_legajo = 1;
                //    HttpContext.Session.SetInt32("PAG_LEGAJO", 1);
                //}

                int cant = legajoRepo.ObtenerCantidad((empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (apellido == null) ? "" : apellido, activo);
                ViewData["TOTAL_LEGAJOS"] = cant;

                HttpContext.Session.SetInt32("TOT_PAG_LEGAJO", cant % cantPag == 0 ? cant / cantPag : cant / cantPag + 1);

                legajos = legajoRepo.ObtenerPagina(pag_legajo.Value, (empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (apellido == null) ? "" : apellido, activo);


               // legajos = legajoRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (apellido == null) ? "" : apellido);

                if (legajos.Count() == 0)
                {
                    ViewBag.Message = "No existen legajos para el criterio seleccionado";
                    return View();
                }



                return View(legajos);
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpPost]
        public IActionResult Buscar(int empresa_id, int nro_legajo, int ubicacion_id, int sector_id, string apellido, int empleado_id, string filtro, int activo)
        {

            HttpContext.Session.SetString("APELLIDO_ACTUAL_LEGAJO", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("UBICACION_ACTUAL_LEGAJO", ubicacion_id);

            HttpContext.Session.SetInt32("SECTOR_ACTUAL_LEGAJO", sector_id);

            HttpContext.Session.SetInt32("EMPLEADO_ACTUAL_LEGAJO", empleado_id);
            HttpContext.Session.SetString("FILTRO_ACTUAL_LEGAJO", (filtro == null) ? "" : filtro);
            HttpContext.Session.SetInt32("ACTIVO_ACTUAL_LEGAJO", activo);

            return RedirectToAction("Index", "Legajo", new { desde = "busqueda" });

        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {

            HttpContext.Session.SetString("EMPRESA_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("LEGAJO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("APELLIDO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("UBICACION_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("SECTOR_ACTUAL_LEGAJO", "");

            HttpContext.Session.SetString("EMPLEADO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("FILTRO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetInt32("ACTIVO_ACTUAL_LEGAJO", -1);

            HttpContext.Session.SetInt32("PAG_LEGAJO", 1);


            return RedirectToAction("Index", "Legajo");


            }



            [HttpGet]
        public IActionResult Siguiente()
        {
            int pag_legajo = HttpContext.Session.GetInt32("PAG_LEGAJO").GetValueOrDefault();

            HttpContext.Session.SetInt32("PAG_LEGAJO", pag_legajo + 1);

            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult Anterior()
        {
            int pag_legajo = HttpContext.Session.GetInt32("PAG_LEGAJO").GetValueOrDefault();

            HttpContext.Session.SetInt32("PAG_LEGAJO", pag_legajo - 1);

            return RedirectToAction("Index");
        }



        [HttpGet]
        public IActionResult Edit(int? id, string modo)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            Legajo legajo = new Legajo();

            if (id != null)
            {
                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(id.Value);

                //ViewData["ID"] = nro_legajo.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                ViewData["APELLIDO"] = legajo.apellido;
                ViewData["NRO_LEGAJO"] = legajo.nro_legajo;
                ViewData["EMPRESA_ID"] = legajo.empresa_id;

                return View(legajo);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";
                return View(legajo);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, Legajo legajo)
        {

            string sret;
            ILegajoRepo legajoRepo;

            ViewData["MODO"] = modo;

            ViewData["APELLIDO"] = legajo.apellido;
            ViewData["NRO_LEGAJO"] = legajo.nro_legajo;
            ViewData["EMPRESA_ID"] = legajo.empresa_id;

            if (valida(legajo, modo))
            {

                legajoRepo = new LegajoRepo();

                if (modo == "E")
                    sret = legajoRepo.Modificar(legajo);
                else
                    sret = legajoRepo.Insertar(legajo);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Legajo");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }
            return View(legajo);
        }


        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            legajoRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }



        [HttpPost]
        public ActionResult Importar(IFormFile file)
        {

            string wwwPath = this.Environment.WebRootPath;
            string contentPath = this.Environment.ContentRootPath;
            string path = Path.Combine(this.Environment.WebRootPath, "Uploads");
            string guid = Guid.NewGuid().ToString();

            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            DataTable dt = new DataTable();
            //Checking file content length and Extension must be .xlsx  
            if (file != null && System.IO.Path.GetExtension(file.FileName).ToLower() == ".xlsm")
            {

                //string fileName = Path.GetFileName(file.FileName);

                string fileName = Path.GetFileNameWithoutExtension(file.FileName) + "_" + guid + System.IO.Path.GetExtension(file.FileName).ToLower();

                using (FileStream stream = new FileStream(Path.Combine(path, fileName ), FileMode.Create))
                {
                    file.CopyTo(stream);
                }
                //path = Path.Combine(path, Path.GetFileName(file.FileName));
                //string path = Path.Combine(Server.MapPath("~/UploadFile"), Path.GetFileName(file.FileName));
                ////Saving the file  
                //file.SaveAs(path);
                ////Started reading the Excel file.  
                using (XLWorkbook workbook = new XLWorkbook(Path.Combine(path, fileName)))
                {
                    IXLWorksheet worksheet = workbook.Worksheet(1);
                    bool FirstRow = true;
                    //Range for reading the cells based on the last cell used.  
                    string readRange = "1:1";
                    foreach (IXLRow row in worksheet.RowsUsed())
                    {
                        //If Reading the First Row (used) then add them as column name  
                        if (FirstRow)
                        {
                            //Checking the Last cellused for column generation in datatable  
                            readRange = string.Format("{0}:{1}", 1, row.LastCellUsed().Address.ColumnNumber);
                            foreach (IXLCell cell in row.Cells(readRange))
                            {
                                dt.Columns.Add(cell.Value.ToString());
                            }
                            FirstRow = false;
                        }
                        else
                        {
                            
                            //Adding a Row in datatable  
                            dt.Rows.Add();
                            int cellIndex = 0;
                            //Updating the values of datatable  
                            foreach (IXLCell cell in row.Cells(readRange))
                            {
                                dt.Rows[dt.Rows.Count - 1][cellIndex] = cell.Value.ToString();
                                cellIndex++;
                            }


                        }
                    }
                    //If no data in Excel file  
                    if (FirstRow)
                    {
                        ViewBag.Message = "Empty Excel File!";
                    }

                    int errores = 0;
                    int fila = 1;
                    foreach (DataRow dr in dt.Rows)
                    {
                        fila ++;
                        LegajoRepo legajoRepo = new LegajoRepo();
                        Legajo legajo = new Legajo();

                        int iUbicacion = -1;

                        string fecha_alta;

                        try
                        {
                            DateTime f = DateTime.Parse(dr[5].ToString());
                            fecha_alta = f.Year + "-" + f.Month.ToString().PadLeft(2, '0') + "-" + f.Day.ToString().PadLeft(2, '0');
                        }
                        catch (Exception)
                        {
                            fecha_alta = "ERR";
                        }

                        string fecha_baja="";

                        if (dr[6].ToString() != "")
                        {
                            try
                            {
                                DateTime f = DateTime.Parse(dr[6].ToString());
                                fecha_baja = f.Year + "-" + f.Month.ToString().PadLeft(2, '0') + "-" + f.Day.ToString().PadLeft(2, '0');
                            }
                            catch (Exception)
                            {
                                fecha_baja = "ERR";
                            }
                        }

                        //string fecha_alta = dr[5].ToString();
                        //string dia_alta = "";
                        //string mes_alta = "";
                        //string anio_alta = "";
                        //if (fecha_alta!="")
                        //{
                        //    dia_alta = fecha_alta.Substring(0, fecha_alta.IndexOf("/")).PadLeft(2, '0');
                        //    mes_alta = fecha_alta.Substring(fecha_alta.IndexOf("/") + 1, fecha_alta.LastIndexOf("/") - fecha_alta.IndexOf("/") - 1).PadLeft(2, '0');
                        //    anio_alta = fecha_alta.Substring(fecha_alta.LastIndexOf("/") + 1, 4);
                        //    fecha_alta = anio_alta + "-" + mes_alta + "-" + dia_alta;
                        //}

                        //string fecha_baja = dr[6].ToString();
                        //string dia_baja = "";
                        //string mes_baja = "";
                        //string anio_baja = "";
                        //if (fecha_baja != "")
                        //{
                        //    dia_baja = fecha_baja.Substring(0, fecha_baja.IndexOf("/")).PadLeft(2, '0');
                        //    mes_baja = fecha_baja.Substring(fecha_baja.IndexOf("/") + 1, fecha_baja.LastIndexOf("/") - fecha_baja.IndexOf("/") - 1).PadLeft(2, '0');
                        //    anio_baja = fecha_baja.Substring(fecha_baja.LastIndexOf("/") + 1, 4);
                        //    fecha_baja = anio_baja + "-" + mes_baja + "-" + dia_baja;
                        //}

                        switch (dr[7].ToString().ToUpper())
                        {
                            case "FABRICA":
                                iUbicacion = 1;
                                break;
                            case "EDIFICIO":
                                iUbicacion = 2;
                                break;
                            case "LOCAL":
                                iUbicacion = 3;
                                break;
                            default:
                                iUbicacion = -1;
                                break;
                        }

                        if (iUbicacion == -1)
                        {
                            worksheet.Cell(fila, "M").Value = "Ubicación inválida";
                            errores++;
                        }
                        else if (fecha_alta == "ERR" || fecha_alta == "")
                        {
                            worksheet.Cell(fila, "M").Value = "Fecha alta inválida";
                            errores++;
                        }
                        else if (fecha_baja == "ERR")
                        {
                            worksheet.Cell(fila, "M").Value = "Fecha baja inválida";
                            errores++;
                        }
                        else
                        {
                            string sError = "";
                            int ret = legajoRepo.ObtenerDeImportacion(
                                      dr[1].ToString(),
                                      dr[2].ToString(),
                                      dr[3].ToString(),
                                      dr[0].ToString(),
                                      dr[8].ToString(),
                                      dr[9].ToString(),
                                      dr[10].ToString(),
                                      fecha_alta,
                                      fecha_baja,
                                      dr[4].ToString(),
                                      dr[11].ToString(),
                                      iUbicacion.ToString(),
                                      ref legajo
                                      );

                            if (ret < 0)
                            {
                                errores++;
                                switch (ret)
                                {
                                    case -1:
                                        sError = "El legajo ya existe";
                                        break;

                                    case -2:
                                        sError = "Empresa inválida";
                                        break;

                                    case -3:
                                        sError = "Sector/Local inválido";
                                        break;


                                    case -4:
                                        sError = "Categoría inválida";
                                        break;


                                    case -5:
                                        sError = "Tarea inválida";
                                        break;


                                    case -6:
                                        sError = "Género inválido";
                                        break;

                                    default:
                                        sError = "Error";
                                        break;
                                }

                                // ViewBag.Message = "ERROR";
                                worksheet.Cell(fila, "M").Value = sError;
                            }
                            else
                            {
                                if (legajoRepo.Insertar(legajo) == "")
                                {
                                    // ViewBag.Message = "OK";
                                    worksheet.Cell(fila, "M").Value = "OK";
                                }
                                else
                                {
                                    ViewBag.Message = "ERROR";
                                    worksheet.Cell(fila, "M").Value = "ERROR";
                                }
                            }
                        }
                    }

                    workbook.Save();

                    Importacion imp = new Importacion();
                    IImportacionRepo importacionRepo;

                    importacionRepo = new ImportacionRepo();

                    imp.tipo = "L";
                    imp.nombre_archivo = Path.Combine("\\Uploads", fileName);
                    imp.cantidad = fila - 1;
                    imp.errores = errores;

                    importacionRepo.Insertar(imp);

                    //workbook.SaveAs(Path.Combine(path, "Salida.xlsm"));
                }
            }
            else
            {
                //If file extension of the uploaded file is different then .xlsx  
                ViewBag.Message = "Please select file with .xlsx extension!";
            }

            return RedirectToAction("Index");
            // return View(dt);
        }


        [HttpPost]
        public void ExportarExcel(int empresa_id, int nro_legajo, int ubicacion_id, int sector_id, string apellido, int empleado_id, string filtro, int activo)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            Legajo legajo = new Legajo();
            ILegajoRepo legajoRepo;
            legajoRepo = new LegajoRepo();
            legajo = legajoRepo.Obtener(empleado_id);

            if (perfil_id > 0)
            {

      

                if (legajo != null)
                {
                    nro_legajo = legajo.nro_legajo.Value;
                    empresa_id = legajo.empresa_id.Value;
                    apellido = legajo.apellido;
                }




                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("Legajos");

                    IEnumerable<Legajo> l = legajoRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (apellido == null) ? "" : apellido, activo);


                    var currentRow = 1;
                    //worksheet.Cell(currentRow, 1).Value = "Sanciones";
                    //worksheet.Cell(currentRow, 1).Style.Font.SetBold();
                    //currentRow += 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(currentRow, i).Style.Font.SetBold();
                    }
                    worksheet.Cell(currentRow, 1).Value = "Empresa";
                    worksheet.Cell(currentRow, 2).Value = "Nro. Legajo";
                    worksheet.Cell(currentRow, 3).Value = "Nombre";
                    worksheet.Cell(currentRow, 4).Value = "Apellido";
                    worksheet.Cell(currentRow, 5).Value = "Ubicacion    ";
                    worksheet.Cell(currentRow, 6).Value = "Sector/Local";
                    worksheet.Cell(currentRow, 7).Value = "Categoria";
                    worksheet.Cell(currentRow, 8).Value = "F. Ingreso";
                    worksheet.Cell(currentRow, 9).Value = "F. Baja";


                    foreach (var item in l)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.empresa;
                        worksheet.Cell(currentRow, 2).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 3).Value = item.nombre;
                        worksheet.Cell(currentRow, 4).Value = item.apellido;
                        worksheet.Cell(currentRow, 5).Value = item.ubicacion;
                        worksheet.Cell(currentRow, 6).Value = (item.ubicacion_id==3)?item.local:item.sector;
                        worksheet.Cell(currentRow, 7).Value = item.categoria;
                        worksheet.Cell(currentRow, 8).Value = item.fecha_alta;
                        worksheet.Cell(currentRow, 9).Value = item.fecha_baja;



                    }



                    worksheet.Columns().AdjustToContents();

                    using var stream = new MemoryStream();
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    Response.Clear();
                    Response.Headers.Add("content-disposition", "attachment;filename=Legajos.xls");
                    Response.ContentType = "application/xls";
                    Response.Body.WriteAsync(content);
                    Response.Body.Flush();
                }
            }


            return;
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


            l.Insert(0, new Models.Sector(-1, "-- Seleccione el sector --",-1,""));

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
        public JsonResult ObtenerCategorias()
        {
            List<Models.Categoria> l = new List<Models.Categoria>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Categoria>("select * from categoria order by id", parameters).ToList();
            }


            l.Insert(0, new Models.Categoria(-1, "-- Seleccione la categoría --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerEmpresas()
        {
            List<Models.Empresa> l = new List<Models.Empresa>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Empresa>("spEmpresaObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Empresa(-1, "-- Seleccione la empresa --",""));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerGeneros()
        {
            List<Models.Genero> l = new List<Models.Genero>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Genero>("spGeneroObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Genero(-1, "-- Seleccione el género --"));

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
        public JsonResult ObtenerFunciones()
        {
            List<Models.Funcion> l = new List<Models.Funcion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Funcion>("spFuncionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Funcion(-1, "-- Seleccione la función --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerEmpleados(string filtro)
        {
            List<Models.Empleado> l = new List<Models.Empleado>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@filtro", filtro);

                l = con.Query<Models.Empleado>("spLegajoObtenerPorFiltro", parameters, commandType: CommandType.StoredProcedure).ToList();
            }
            
            if (l.Count == 0)
                l.Insert(0, new Models.Empleado(-1, "No hay empleados con ese legajo/apellido"));
            else
              if (l.Count > 1)
                l.Insert(0, new Models.Empleado(-1, "-- Seleccione el empleado --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


        [HttpGet]
        public JsonResult ObtenerLegajoPorID(int id)
        {
            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            Legajo legajo = new Legajo();

            legajo = legajoRepo.Obtener(id);

            if (legajo == null)
            {
                legajo = new Legajo();
                legajo.apellido = "";
                legajo.nombre = "";
            }

            return Json(legajo);
        }


        public Boolean valida(Legajo legajo, string modo)
        {

            if (legajo.nro_legajo == null) return false;

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            if (modo == "A")
            {
                if (legajoRepo.ObtenerPorNro(legajo.empresa_id.Value, legajo.nro_legajo.Value) != null)
                    return false;
            }
            else
            {
                if (legajoRepo.Obtener(legajo.id.Value) == null) 
                    return false;
            }

            if (legajo.empresa_id <= 0) return false;

            if (legajo.apellido == null) return false;
            if (legajo.apellido.Trim() == "") return false;

            if (legajo.nombre == null) return false;
            if (legajo.nombre.Trim() == "") return false;

            if (legajo.categoria_id <= 0) return false;

            if ((legajo.ubicacion_id==1 || legajo.ubicacion_id==2) && legajo.sector_id <= 0) return false;

            if (legajo.ubicacion_id == 3 && legajo.local_id <= 0) return false;

            return true;

        }

        [AcceptVerbs("GET", "POST")]
        public IActionResult LegajoNoExiste(int nro_legajo)
        {
            bool result;

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            if (legajoRepo.Obtener(nro_legajo) == null)
                result = true;
            else
                result = false;

            return Json(result);
        }


    }
}
