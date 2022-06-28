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
    public class FichadaController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public FichadaController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

            HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", "");

            return RedirectToAction("Index", "Fichada");


        }


        public IActionResult Index(int nro_legajo,  int legajo_id, string filtro, string desde)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            DateTime? fecha_desde = null;
            DateTime? fecha_hasta = null;

            if (HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != null && HttpContext.Session.GetString("FECHA_FICHADA_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_DESDE"));

            if (HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != null && HttpContext.Session.GetString("FECHA_FICHADA_HASTA") != "")
                fecha_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_FICHADA_HASTA"));

        
            if (HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_FICHADA_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_FICHADA_ACTUAL");



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


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["FiltroActual"] = filtro;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(legajo_id);


                if (legajo != null)
                {
                    nro_legajo = legajo.nro_legajo.Value;

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


             

                IEnumerable<Fichada> fichadas;

                fichadas = fichadaRepo.ObtenerTodos((nro_legajo == 0) ? -2 : nro_legajo, fechaDesde, fechaHasta);


                if (desde == "busqueda")
                {
                    if (nro_legajo <= 0)
                    {
                        ViewBag.Message = "Debe especificar un legajo";
                        return View();
                    }


                    if (fichadas.Count() == 0 )
                    {
                        ViewBag.Message = "No existen novedades para el criterio seleccionado";
                        return View();
                    }
                }

              
                return View(fichadas);

            }



            return View();


        }

        [HttpPost]
        public IActionResult Buscar(int nro_legajo, DateTime fecha_desde, DateTime fecha_hasta, int legajo_id, string filtro)
        {

            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

            HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetInt32("LEGAJO_FICHADA_ACTUAL", nro_legajo);

            HttpContext.Session.SetInt32("EMPLEADO_FICHADA_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year);
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", fecha_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_hasta.Year);

            return RedirectToAction("Index", "Fichada", new { desde = "busqueda" });

        }

    }
}
