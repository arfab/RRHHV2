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

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LegajoController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        [HttpGet]
        public IActionResult Index(int empresa_id, int nro_legajo, string apellido, int modo) 
        {

            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            IEnumerable<Legajo> legajos;

            ViewData["APELLIDO"] = apellido;
            ViewData["NRO_LEGAJO"] = nro_legajo;
            ViewData["EMPRESA_ID"] = empresa_id;


            if (nro_legajo > 0 && empresa_id > 0 || apellido != null)
            {
                legajos = legajoRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (apellido == null) ? "" : apellido);
                return View(legajos);
            }
            else
                return View();

        }

        [HttpPost]
        public IActionResult Index(int empresa_id, int nro_legajo, string apellido)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id >0)
            {
                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                IEnumerable<Legajo> legajos;

                ViewData["APELLIDO"] = apellido;
                ViewData["NRO_LEGAJO"] = nro_legajo;
                ViewData["EMPRESA_ID"] = empresa_id;

                if (nro_legajo > 0)
                {
                    if (empresa_id <= 0)
                    {
                        ViewBag.Message = "Debe seleccionar la empresa";
                        return View();
                    }
                    else
                    {
                        Legajo legajo = new Legajo();
                        legajo = legajoRepo.ObtenerPorNro(empresa_id, nro_legajo);

                        if (legajo == null)
                        {
                            ViewBag.Message = "No existe el legajo para esa empresa";
                            return View();
                        }
                    }


                }

                legajos = legajoRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, (nro_legajo == 0) ? -1 : nro_legajo, (apellido == null) ? "" : apellido);

                if (legajos.Count() == 0)
                {
                    ViewBag.Message = "No existen legajos para el criterio seleccionado";
                    return View();
                }



                return View(legajos);
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? id)
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

                ViewData["MODO"] = "E";

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
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }

            DataTable dt = new DataTable();
            //Checking file content length and Extension must be .xlsx  
            if (file != null && System.IO.Path.GetExtension(file.FileName).ToLower() == ".xlsx")
            {

                string fileName = Path.GetFileName(file.FileName);
              

                using (FileStream stream = new FileStream(Path.Combine(path, fileName), FileMode.Create))
                {
                    file.CopyTo(stream);
                }
                //path = Path.Combine(path, Path.GetFileName(file.FileName));
                //string path = Path.Combine(Server.MapPath("~/UploadFile"), Path.GetFileName(file.FileName));
                ////Saving the file  
                //file.SaveAs(path);
                ////Started reading the Excel file.  
                using (XLWorkbook workbook = new XLWorkbook(Path.Combine(path, file.FileName)))
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



                    foreach (DataRow dr in dt.Rows)
                    {
                        LegajoRepo legajoRepo = new LegajoRepo();
                        Legajo legajo = new Legajo();

                        string fecha_alta = dr[4].ToString();
                        string dia_alta = "";
                        string mes_alta = "";
                        string anio_alta = "";
                        if (fecha_alta!="")
                        {
                            dia_alta = fecha_alta.Substring(0, fecha_alta.IndexOf("/")).PadLeft(2, '0');
                            mes_alta = fecha_alta.Substring(fecha_alta.IndexOf("/") + 1, fecha_alta.LastIndexOf("/") - fecha_alta.IndexOf("/") - 1).PadLeft(2, '0');
                            anio_alta = fecha_alta.Substring(fecha_alta.LastIndexOf("/") + 1, 4);
                            fecha_alta = anio_alta + "-" + mes_alta + "-" + dia_alta;
                        }

                        string fecha_baja = dr[5].ToString();
                        string dia_baja = "";
                        string mes_baja = "";
                        string anio_baja = "";
                        if (fecha_baja != "")
                        {
                            dia_baja = fecha_baja.Substring(0, fecha_baja.IndexOf("/")).PadLeft(2, '0');
                            mes_baja = fecha_baja.Substring(fecha_baja.IndexOf("/") + 1, fecha_baja.LastIndexOf("/") - fecha_baja.IndexOf("/") - 1).PadLeft(2, '0');
                            anio_baja = fecha_baja.Substring(fecha_baja.LastIndexOf("/") + 1, 4);
                            fecha_baja = anio_baja + "-" + mes_baja + "-" + dia_baja;
                        }

                        legajo = legajoRepo.ObtenerDeImportacion(
                                  dr[1].ToString(), 
                                  dr[2].ToString(), 
                                  dr[3].ToString(), 
                                  dr[0].ToString(), 
                                  dr[6].ToString(), 
                                  dr[7].ToString(), 
                                  dr[8].ToString(),
                                  fecha_alta,
                                  fecha_baja,
                                  dr[10].ToString(),
                                  dr[9].ToString(),
                                  dr[11].ToString()
                                  );

                        if (legajo == null)
                            ViewBag.Message = "ERROR";
                        else
                        {
                            legajoRepo.Insertar(legajo);
                            ViewBag.Message = "OK";
                        }
                    }

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
