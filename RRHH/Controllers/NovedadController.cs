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
    public class NovedadController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        static readonly int cantPag = int.Parse(Tools.GetPaginacionNovedad());

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public NovedadController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }



        public IActionResult Reset(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            IEnumerable<Models.Novedad> lFelicitaciones;


            if (perfil_id > 0)
            {

                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                //DateTime fechaDesde = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1); 
                //DateTime fechaHasta = DateTime.Now;


                DateTime fechaDesde = new DateTime();
                DateTime fechaHasta = new DateTime();


                ViewData["EmpresaActual"] = -1;
                ViewData["CategoriaNovedadActual"] = -1;
                ViewData["TipoNovedadActual"] = -1;
                ViewData["TipoResolucionActual"] = -1;
   
                ViewData["LegajoActual"] = "";
                ViewData["UbicacionActual"] = -1;
                ViewData["SectorActual"] = -1;
                ViewData["LocalActual"] = -1;
                ViewData["ApellidoActual"] = "";


                ViewData["FechaNovedadDesdeActual"] = "";
                ViewData["FechaNovedadHastaActual"] = "";

                //ViewData["FechaNovedadDesdeActual"] = fechaDesde.Day.ToString().PadLeft(2, '0') + "/" + fechaDesde.Month.ToString().PadLeft(2, '0') + "/" + fechaDesde.Year;
                //ViewData["FechaNovedadHastaActual"] = fechaHasta.Day.ToString().PadLeft(2, '0') + "/" + fechaHasta.Month.ToString().PadLeft(2, '0') + "/" + fechaHasta.Year;

                ViewData["EmpleadoActual"] = -1;
                ViewData["FiltroActual"] = "";

                HttpContext.Session.SetString("EMPRESA_ACTUAL","");
                HttpContext.Session.SetString("LEGAJO_ACTUAL", "");
                HttpContext.Session.SetString("APELLIDO_ACTUAL", "");

                HttpContext.Session.SetString("CATEGORIA_NOVEDAD_ACTUAL", "");
                HttpContext.Session.SetString("TIPO_NOVEDAD_ACTUAL", "");
                HttpContext.Session.SetString("TIPO_RESOLUCION_ACTUAL", "");

                HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE","");
                HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA","");


                //HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE", fechaDesde.Day.ToString().PadLeft(2, '0') + "/" + fechaDesde.Month.ToString().PadLeft(2, '0') + "/" + fechaDesde.Year);
                //HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA", fechaHasta.Day.ToString().PadLeft(2, '0') + "/" + fechaHasta.Month.ToString().PadLeft(2, '0') + "/" + fechaHasta.Year);

                HttpContext.Session.SetString("EMPLEADO_ACTUAL", "");
                HttpContext.Session.SetString("FILTRO_ACTUAL", "");



                HttpContext.Session.SetInt32("PAG_NOVEDAD", 1);

                //if (nro_legajo > 0 && empresa_id > 0)
                //    return View("Index",novedadRepo.ObtenerTodos(-1, -1, -1, -1,  -1, fechaDesde, fechaHasta, ""));
                //else


                int cant = novedadRepo.ObtenerCantidad(-1, 1, -1, -1,  -2, fechaDesde, fechaHasta,  "" );
                ViewData["TOTAL_NOVEDADES"] = cant;

                int cantFelicitaciones = novedadRepo.ObtenerCantidad(-1, 2, -1, -1, -2, fechaDesde, fechaHasta, "");
                ViewData["TOTAL_FELICITACIONES"] = cantFelicitaciones;

                HttpContext.Session.SetInt32("TOT_PAG_NOVEDAD", cant % cantPag == 0 ? cant / cantPag : cant / cantPag + 1);

                lFelicitaciones = novedadRepo.ObtenerPagina(1, -1, 2, -1, -1, -2, fechaDesde, fechaHasta, "");
                ViewData["FELICITACIONES"] = lFelicitaciones;

                return View("Index",novedadRepo.ObtenerPagina(1, -1, 1, -1, -1, -2 , fechaDesde, fechaHasta,  ""));
            }

            return View("Index");


        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


                HttpContext.Session.SetString("EMPRESA_ACTUAL", "");
                HttpContext.Session.SetString("LEGAJO_ACTUAL", "");
                HttpContext.Session.SetString("APELLIDO_ACTUAL", "");

                HttpContext.Session.SetString("CATEGORIA_NOVEDAD_ACTUAL", "");
                HttpContext.Session.SetString("TIPO_NOVEDAD_ACTUAL", "");
                HttpContext.Session.SetString("TIPO_RESOLUCION_ACTUAL", "");

                HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE", "");
                HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA", "");

                HttpContext.Session.SetString("EMPLEADO_ACTUAL", "");
                HttpContext.Session.SetString("FILTRO_ACTUAL", "");

                return RedirectToAction("Index", "Novedad");


        }


        public IActionResult Index(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, int legajo_id, string filtro, string desde)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            IEnumerable<Models.Novedad> lFelicitaciones;

            DateTime? fecha_novedad_desde=null;
            DateTime? fecha_novedad_hasta=null;

            if (HttpContext.Session.GetString("FECHA_NOVEDAD_DESDE")!=null && HttpContext.Session.GetString("FECHA_NOVEDAD_DESDE")!="")
                fecha_novedad_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_NOVEDAD_DESDE"));
            
            if (HttpContext.Session.GetString("FECHA_NOVEDAD_HASTA") != null && HttpContext.Session.GetString("FECHA_NOVEDAD_HASTA") != "")
                fecha_novedad_hasta = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_NOVEDAD_HASTA"));

            //if (empresa_id > 0) HttpContext.Session.SetInt32("EMPRESA_ACTUAL", empresa_id);
            //if (nro_legajo > 0) HttpContext.Session.SetInt32("LEGAJO_ACTUAL", nro_legajo);

            if (apellido != null) HttpContext.Session.SetString("APELLIDO_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_ACTUAL");
            if (HttpContext.Session.GetString("FILTRO_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_ACTUAL");


            if (HttpContext.Session.GetInt32("CATEGORIA_NOVEDAD_ACTUAL") != null) categoria_novedad_id = (int)HttpContext.Session.GetInt32("CATEGORIA_NOVEDAD_ACTUAL");
            if (HttpContext.Session.GetInt32("TIPO_NOVEDAD_ACTUAL") != null) tipo_novedad_id = (int)HttpContext.Session.GetInt32("TIPO_NOVEDAD_ACTUAL");
            if (HttpContext.Session.GetInt32("TIPO_RESOLUCION_ACTUAL") != null) tipo_resolucion_id = (int)HttpContext.Session.GetInt32("TIPO_RESOLUCION_ACTUAL");




            if (perfil_id >0)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();


                DateTime fechaDesde = new DateTime();
                DateTime fechaHasta = new DateTime();

                if (fecha_novedad_desde != null)
                  if(fecha_novedad_desde.Value.Year > 2002)
                        fechaDesde = fecha_novedad_desde.Value;
                  else
                        if(fecha_novedad_desde.Value.Year!=1)
                          fechaDesde = new DateTime(1, 1, 1);

                if (fecha_novedad_hasta != null)
                    if (fecha_novedad_hasta.Value.Year > 2002)
                        fechaHasta = fecha_novedad_hasta.Value;
                    else
                          if (fecha_novedad_hasta.Value.Year != 1)
                        fechaHasta = new DateTime(1, 1, 1);


                int? pag_novedad = HttpContext.Session.GetInt32("PAG_NOVEDAD");

                if (pag_novedad == null)
                {
                    pag_novedad = 1;
                    HttpContext.Session.SetInt32("PAG_NOVEDAD", 1);
                }

            

                ViewData["EmpresaActual"] = empresa_id;
                ViewData["CategoriaNovedadActual"] = categoria_novedad_id;
                ViewData["TipoNovedadActual"] = tipo_novedad_id;
                ViewData["TipoResolucionActual"] = tipo_resolucion_id;

                ViewData["UbicacionActual"] = ubicacion_id;
                ViewData["SectorActual"] = sector_id;
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



                if (fechaDesde.Year<2002) {
                        fechaDesde = new DateTime(1, 1, 1);

                        ViewData["FechaNovedadDesdeActual"] = "";
                    }
                    else
                    {
                        ViewData["FechaNovedadDesdeActual"] = fechaDesde.Day.ToString().PadLeft(2, '0') + "/" + fechaDesde.Month.ToString().PadLeft(2, '0') + "/" + fechaDesde.Year;

                    }

                    if (fechaHasta.Year < 2002)
                    {
                        fechaHasta = new DateTime(1, 1, 1);

                        ViewData["FechaNovedadHastaActual"] = "";
                    }
                    else
                    {
                        ViewData["FechaNovedadHastaActual"] = fechaHasta.Day.ToString().PadLeft(2, '0') + "/" + fechaHasta.Month.ToString().PadLeft(2, '0') + "/" + fechaHasta.Year;

                    }



                int cant = novedadRepo.ObtenerCantidad((empresa_id == 0) ? -1 : empresa_id, 1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fechaDesde, fechaHasta, (apellido == null) ? "" : apellido);
                ViewData["TOTAL_NOVEDADES"] = cant;

                int cantFelicitaciones = novedadRepo.ObtenerCantidad((empresa_id == 0) ? -1 : empresa_id, 2, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fechaDesde, fechaHasta, (apellido == null) ? "" : apellido);
                ViewData["TOTAL_FELICITACIONES"] = cantFelicitaciones;


                HttpContext.Session.SetInt32("TOT_PAG_NOVEDAD", cant % cantPag == 0 ? cant / cantPag : cant / cantPag + 1);

                lFelicitaciones = novedadRepo.ObtenerPagina(pag_novedad.Value, (empresa_id == 0) ? -1 : empresa_id, 2, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fechaDesde, fechaHasta, (apellido == null) ? "" : apellido);
                ViewData["FELICITACIONES"] = lFelicitaciones;

                IEnumerable<Novedad> novedades;

                novedades = novedadRepo.ObtenerPagina(pag_novedad.Value, (empresa_id == 0) ? -1 : empresa_id, 1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fechaDesde, fechaHasta, (apellido == null) ? "" : apellido);


                if (desde == "busqueda")
                {
                    if (nro_legajo <= 0)
                    {
                        ViewBag.Message = "Debe especificar un legajo";
                        return View();
                    }


                    if (novedades.Count() == 0 && cantFelicitaciones == 0)
                    {
                        ViewBag.Message = "No existen novedades para el criterio seleccionado";
                        return View();
                    }
                }

                // return View(novedadRepo.ObtenerPagina(pag_novedad.Value, (empresa_id == 0) ? -1 : empresa_id, 1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fechaDesde, fechaHasta, (apellido == null) ? "" : apellido));

                return View(novedades);

            }

           

           return View();


        }

        //[HttpPost]
        //public IActionResult Index(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, int empresa_id, string apellido, int ubicacion_id, int sector_id, int local_id, int legajo_id, string filtro)
        //{
        //    string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

        //    if (usuario_id == null) return RedirectToAction("Login", "Usuario");

        //    int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

        //    if (perfil_id>0)
        //    {
        //        INovedadRepo novedadRepo;

        //        novedadRepo = new NovedadRepo();

        //        IEnumerable<Novedad> novedades;

        //        IEnumerable<Models.Novedad> lFelicitaciones;

        //        //ViewData["EmpresaActual"] = empresa_id;
        //        ViewData["CategoriaNovedadActual"] = categoria_novedad_id;
        //        ViewData["TipoNovedadActual"] = tipo_novedad_id;
        //        ViewData["TipoResolucionActual"] = tipo_resolucion_id;
        //        //ViewData["LegajoActual"] = nro_legajo;                
        //        ViewData["ApellidoActual"] = apellido;
        //        ViewData["EmpleadoActual"] = legajo_id;
        //        ViewData["FiltroActual"] = filtro;

        //        Legajo legajo = new Legajo();
        //        ILegajoRepo legajoRepo;
        //        legajoRepo = new LegajoRepo();
        //       // legajo = legajoRepo.ObtenerPorNro(empresa_id, nro_legajo);

        //        legajo = legajoRepo.Obtener(legajo_id);


        //        if (legajo != null)
        //        {
        //            ViewData["UbicacionActual"] = legajo.ubicacion_id;
        //            ViewData["SectorActual"] = legajo.sector_id;
        //            ViewData["LocalActual"] = legajo.local_id;

        //            ViewData["EmpresaActual"] = legajo.empresa_id;
        //            ViewData["LegajoActual"] = legajo.nro_legajo;

        //            nro_legajo = legajo.nro_legajo.Value;
        //            empresa_id = legajo.empresa_id.Value;

        //            ViewData["Legajo"] = legajo;
        //        }
                

        //        if (fecha_novedad_desde.Year < 2002)
        //        {
        //            ViewData["FechaNovedadDesdeActual"] = "";
        //        }
        //        else
        //        {
        //            ViewData["FechaNovedadDesdeActual"] = fecha_novedad_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Year;

        //        }

        //        if (fecha_novedad_hasta.Year < 2002)
        //        {
        //            ViewData["FechaNovedadHastaActual"] = "";
        //        }
        //        else
        //        {
        //            ViewData["FechaNovedadHastaActual"] = fecha_novedad_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Year;

        //        }

        //        //ViewData["FechaNovedadDesdeActual"] = fecha_novedad_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Year;
        //        //ViewData["FechaNovedadHastaActual"] = fecha_novedad_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Year;


   
        //        HttpContext.Session.SetInt32("EMPRESA_ACTUAL", empresa_id);
        //        HttpContext.Session.SetInt32("LEGAJO_ACTUAL", nro_legajo);
        //        HttpContext.Session.SetString("APELLIDO_ACTUAL", (apellido==null)?"":apellido);

        //        HttpContext.Session.SetInt32("EMPLEADO_ACTUAL", legajo_id);
        //        HttpContext.Session.SetString("FILTRO_ACTUAL", (filtro == null) ? "" : filtro);


        //        HttpContext.Session.SetInt32("CATEGORIA_NOVEDAD_ACTUAL", categoria_novedad_id);
        //        HttpContext.Session.SetInt32("TIPO_NOVEDAD_ACTUAL", tipo_novedad_id);
        //        HttpContext.Session.SetInt32("TIPO_RESOLUCION_ACTUAL", tipo_resolucion_id);

        //        HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE", fecha_novedad_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Year);
        //        HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA", fecha_novedad_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Year);

        //        if (nro_legajo >0)
        //        {
        //            if (empresa_id <= 0)
        //            {
        //                ViewBag.Message = "Debe seleccionar la empresa";
        //                return View();
        //            }
        //            else
        //            {

        //                if (legajo == null)
        //                {
        //                    ViewBag.Message = "No existe el legajo para esa empresa";
        //                    return View();
        //                }
        //            }


        //        }

        //        int? pag_novedad = HttpContext.Session.GetInt32("PAG_NOVEDAD");

        //        if (pag_novedad == null)
        //        {
        //            pag_novedad = 1;
        //            HttpContext.Session.SetInt32("PAG_NOVEDAD", 1);
        //        }

        //        int cant = novedadRepo.ObtenerCantidad((empresa_id == 0) ? -1 : empresa_id, 1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);
        //        ViewData["TOTAL_NOVEDADES"] = cant;


        //        int cantFelicitaciones = novedadRepo.ObtenerCantidad((empresa_id == 0) ? -1 : empresa_id,2, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);
        //        ViewData["TOTAL_FELICITACIONES"] = cantFelicitaciones;

        //        HttpContext.Session.SetInt32("TOT_PAG_NOVEDAD", cant % cantPag == 0 ? cant / cantPag : cant / cantPag + 1);


        //        lFelicitaciones = novedadRepo.ObtenerPagina(pag_novedad.Value, (empresa_id == 0) ? -1 : empresa_id, 2, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);
        //        ViewData["FELICITACIONES"] = lFelicitaciones;



        //        novedades = novedadRepo.ObtenerPagina(pag_novedad.Value,(empresa_id == 0) ? -1 : empresa_id,1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -2 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);

        //        if (nro_legajo<=0)
        //        {
        //            ViewBag.Message = "Debe especificar un legajo";
        //            return View();
        //        }


        //        if (novedades.Count() == 0 && cantFelicitaciones==0)
        //        {
        //            ViewBag.Message = "No existen novedades para el criterio seleccionado";
        //            return View();
        //        }


        //        return View(novedades);
        //    }

        //    return View();


        //}


        [HttpPost]
        public IActionResult Buscar(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, int empresa_id, string apellido, int ubicacion_id, int sector_id, int local_id, int legajo_id, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_ACTUAL", empresa_id);
            HttpContext.Session.SetInt32("LEGAJO_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_ACTUAL", (filtro == null) ? "" : filtro);


            HttpContext.Session.SetInt32("CATEGORIA_NOVEDAD_ACTUAL", categoria_novedad_id);
            HttpContext.Session.SetInt32("TIPO_NOVEDAD_ACTUAL", tipo_novedad_id);
            HttpContext.Session.SetInt32("TIPO_RESOLUCION_ACTUAL", tipo_resolucion_id);

            HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE", fecha_novedad_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_desde.Year);
            HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA", fecha_novedad_hasta.Day.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Month.ToString().PadLeft(2, '0') + "/" + fecha_novedad_hasta.Year);
          
            return RedirectToAction("Index", "Novedad", new {desde="busqueda"});

        }


        [HttpGet]
        public IActionResult Siguiente()
        {
            int pag_novedad = HttpContext.Session.GetInt32("PAG_NOVEDAD").GetValueOrDefault();

            HttpContext.Session.SetInt32("PAG_NOVEDAD", pag_novedad + 1);

            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult Anterior()
        {
            int pag_novedad = HttpContext.Session.GetInt32("PAG_NOVEDAD").GetValueOrDefault();

            HttpContext.Session.SetInt32("PAG_NOVEDAD", pag_novedad - 1);

            return RedirectToAction("Index");
        }



        [HttpPost]
        public void  ExportarExcel(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido, int legajo_id)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return ;

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id >0)
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

                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

               
                using (var workbook = new XLWorkbook())
                {
                    var worksheet = workbook.Worksheets.Add("Novedades");

                    IEnumerable<Novedad> l = novedadRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, 1, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);


                    var currentRow = 1;
                    worksheet.Cell(currentRow, 1).Value = "Sanciones";
                    worksheet.Cell(currentRow, 1).Style.Font.SetBold();
                    currentRow += 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(currentRow, i).Style.Font.SetBold();
                    }
                    worksheet.Cell(currentRow, 1).Value = "Legajo";
                    worksheet.Cell(currentRow, 2).Value = "Apellido";
                    worksheet.Cell(currentRow, 3).Value = "Nombre";
                    worksheet.Cell(currentRow, 4).Value = "Ubicacion";
                    worksheet.Cell(currentRow, 5).Value = "Sector";
                    worksheet.Cell(currentRow, 6).Value = "Responsable";
                    worksheet.Cell(currentRow, 7).Value = "Fecha Novedad";
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
                        worksheet.Cell(currentRow, 5).Value = item.sector;
                        worksheet.Cell(currentRow, 6).Value = item.responsable;
                        worksheet.Cell(currentRow, 7).Value = item.fecha_novedad;
                        worksheet.Cell(currentRow, 8).Value = item.tipo_novedad;
                        worksheet.Cell(currentRow, 9).Value = item.fecha_resolucion;
                        worksheet.Cell(currentRow, 10).Value = item.tipo_resolucion;
                        worksheet.Cell(currentRow, 11).Value = item.observacion;


                    }

                    l = novedadRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, 2, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);

                    currentRow += 2;
                    worksheet.Cell(currentRow, 1).Value = "Felicitaciones";
                    worksheet.Cell(currentRow, 1).Style.Font.SetBold();
                    currentRow += 1;
                    for (int i = 1; i <= 11; i++)
                    {
                        worksheet.Cell(currentRow, i).Style.Font.SetBold();
                    }
                   
                    worksheet.Cell(currentRow, 1).Value = "Legajo";
                    worksheet.Cell(currentRow, 2).Value = "Apellido";
                    worksheet.Cell(currentRow, 3).Value = "Nombre";
                    worksheet.Cell(currentRow, 4).Value = "Ubicacion";
                    worksheet.Cell(currentRow, 5).Value = "Sector";
                    worksheet.Cell(currentRow, 6).Value = "Responsable";
                    worksheet.Cell(currentRow, 7).Value = "Fecha Novedad";
                    worksheet.Cell(currentRow, 8).Value = "Tipo Novedad";
                    worksheet.Cell(currentRow, 9).Value = "Observaciones";
                    currentRow += 1;
                    foreach (var item in l)
                    {
                        currentRow++;
                        worksheet.Cell(currentRow, 1).Value = item.nro_legajo;
                        worksheet.Cell(currentRow, 2).Value = item.apellido;
                        worksheet.Cell(currentRow, 3).Value = item.nombre;
                        worksheet.Cell(currentRow, 4).Value = item.ubicacion;
                        worksheet.Cell(currentRow, 5).Value = item.sector;
                        worksheet.Cell(currentRow, 6).Value = item.responsable;
                        worksheet.Cell(currentRow, 7).Value = item.fecha_novedad;
                        worksheet.Cell(currentRow, 8).Value = item.tipo_novedad;
                        worksheet.Cell(currentRow, 9).Value = item.observacion;

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
        public IActionResult ExportarPDF(int empresa_id, int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo, DateTime fecha_novedad_desde, DateTime fecha_novedad_hasta, string apellido)
        {

            string html = @"<html>
                               <body>
                                 <table>
                                  <thead>
                                     <tr>
                                       <th>Nro. Legajo</th>
                                       <th>Apellido</th>
                                       <th>Nombre</th>
                                       <th>Ubicacion</th>
                                       <th>Sector</th>
                                       <th>Responsable</th>
                                       <th>Fecha Novedad</th>
                                       <th>Categoría Novedad</th>
                                       <th>Tipo Novedad</th>
                                       <th>Fecha Resolución</th>
                                       <th>Tipo Resolución</th>
                                       <th>Observaciones</th>
                                     </tr>
                                   </thead> ";
                              

            //string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            //if (usuario_id == null) return;

            //int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

       

            //if (perfil_id == 1)
            //{
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                IEnumerable<Novedad> l = novedadRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, (categoria_novedad_id == 0) ? -1 : categoria_novedad_id, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo, fecha_novedad_desde, fecha_novedad_hasta, (apellido == null) ? "" : apellido);


               
                foreach (var item in l)
                {
                    html += "<tr>";
                    html += "<td>" + item.nro_legajo.ToString() + "</td>";
                    html += "<td>" + item.apellido + "</td>";
                    html += "<td>" + item.nombre + "</td>";
                    html += "<td>" + item.ubicacion + "</td>";
                    html += "<td>" + item.sector + "</td>";
                    html += "<td>" + item.responsable + "</td>";
                    html += "<td>" + item.fecha_novedad.ToString() + "</td>";
                    html += "<td>" + item.categoria_novedad + "</td>";
                    html += "<td>" + item.tipo_novedad + "</td>";
                    html += "<td>" + item.fecha_resolucion.ToString() + "</td>";
                    html += "<td>" + item.tipo_resolucion + "</td>";
                    html += "<td>" + item.observacion + "</td>";


                    html += "</tr>";


                }

                html += "  </table> </body> </html>";

                string pdf_page_size = "A4";
                PdfPageSize pageSize = (PdfPageSize)Enum.Parse(typeof(PdfPageSize),
                    pdf_page_size, true);

                string pdf_orientation = "Portrait";
                PdfPageOrientation pdfOrientation =
                    (PdfPageOrientation)Enum.Parse(typeof(PdfPageOrientation),
                    pdf_orientation, true);

                int webPageWidth = 1024;
                try
                {
                    webPageWidth = Convert.ToInt32("1024");
                }
                catch { }

                int webPageHeight = 0;
                try
                {
                    webPageHeight = Convert.ToInt32("0");
                }
                catch { }

                // instantiate a html to pdf converter object
                HtmlToPdf converter = new HtmlToPdf();

                // set converter options
                converter.Options.PdfPageSize = pageSize;
                converter.Options.PdfPageOrientation = pdfOrientation;
                converter.Options.WebPageWidth = webPageWidth;
                converter.Options.WebPageHeight = webPageHeight;

                // create a new pdf document converting an url
                PdfDocument doc = converter.ConvertHtmlString(html, "");
               
                // save pdf document
                doc.Save("c://rrhh/Novedades_" + DateTime.Now.ToString("dd-MM-yyyy HH.mm.ss") + ".pdf");
                

            // close pdf document
            doc.Close();

            


           


            return View("Index",l);

        }

        [HttpGet]
        public IActionResult Edit(int? id, int? nro_legajo, int? empresa_id,  int? ubicacion_id, int? sector_id, int? local_id, string origen, int? legajo_id, string modo)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id>3 && modo!="V") return RedirectToAction("Login", "Usuario");



            Novedad novedad = new Novedad();

            ViewData["ORIGEN"] = origen;

            if (id != null)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                novedad = novedadRepo.Obtener(id.Value);

                //ViewData["ID"] = nro_legajo.Value;

                ViewData["MODO"] = (modo==null)?"E":modo;

                ViewData["EMPRESA_ID"] = novedad.empresa_id;
                ViewData["NRO_LEGAJO"] = novedad.nro_legajo;
                ViewData["FiltroActual"] = novedad.nro_legajo;
                ViewData["EmpleadoActual"] = novedad.legajo_id;

                return View(novedad);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";

                if (nro_legajo != null) novedad.nro_legajo = nro_legajo.Value;
                if (empresa_id != null) novedad.empresa_id = empresa_id.Value;
                if (ubicacion_id != null) novedad.ubicacion_id = ubicacion_id.Value;
                if (sector_id != null) novedad.sector_id = sector_id.Value;
                if (local_id != null) novedad.local_id = local_id.Value;
                if (legajo_id != null) novedad.legajo_id = legajo_id.Value;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();
                legajo = legajoRepo.Obtener(legajo_id.Value);


                if (legajo != null)
                {
                    novedad.nro_legajo = legajo.nro_legajo.Value;
                    novedad.empresa_id = legajo.empresa_id.Value;

                    ViewData["EMPRESA_ID"] = novedad.empresa_id;
                    ViewData["NRO_LEGAJO"] = novedad.nro_legajo;
                    ViewData["FiltroActual"] = novedad.nro_legajo;
                    ViewData["EmpleadoActual"] = novedad.legajo_id;
                }

                return View(novedad);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo,  int? id,  Novedad novedad)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret;

            INovedadRepo novedadRepo;

            ViewData["MODO"] = modo;
            
            //Legajo legajo = new Legajo();
            //ILegajoRepo legajoRepo;
            //legajoRepo = new LegajoRepo();
            //legajo = legajoRepo.ObtenerPorNro(novedad.empresa_id.Value, novedad.nro_legajo.Value);
            //novedad.legajo_id = legajo.id;

            //if (modo=="S")
            //    return RedirectToAction("Index", "Novedad", new { empresa_id = novedad.empresa_id, nro_legajo = novedad.nro_legajo, ubicacion_id = novedad.ubicacion_id, sectori_id = novedad.sector_id, local_id = novedad.local_id });


            if (valida(novedad))
            {


                novedadRepo = new NovedadRepo();

                if (modo == "E" || modo == null)
                    sret = novedadRepo.Modificar(novedad, usuario_id.Value);
                else
                    sret = novedadRepo.Insertar(novedad, usuario_id.Value);

                if (sret == "")
                {
                    return RedirectToAction("Index", "Novedad");

                   // return RedirectToAction("Reset", "Novedad", new { empresa_id = novedad.empresa_id, nro_legajo= novedad.nro_legajo, ubicacion_id = novedad.ubicacion_id, sectori_id = novedad.sector_id, local_id = novedad.local_id });
                   

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

                l = con.Query<Models.CategoriaNovedad>("spCategoriaNovedadObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
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

                l = con.Query<Models.TipoNovedad>("spTipoNovedadObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
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

                l = con.Query<Models.TipoResolucion>("spTipoResolucionObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
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
        public JsonResult ObtenerLegajo(int empresa_id, int nro_legajo)
        {
            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            Legajo legajo = new Legajo();

            legajo= legajoRepo.ObtenerPorNro(empresa_id, nro_legajo);

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

        //    if (novedad.nro_legajo == null) return false;

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            if(legajoRepo.Obtener(novedad.legajo_id.Value)==null) return false;
            if (novedad.categoria_novedad_id <= 0) return false;

            if (novedad.tipo_novedad_id <= 0) return false;
            if (novedad.descripcion == null) return false;
            if (novedad.descripcion.Trim()=="") return false;
            //if (novedad.responsable_id <= 0) return false;
            if (novedad.ubicacion_id < 0) return false;

          
            return true;

        }

        [AcceptVerbs("GET", "POST")]
        public IActionResult LegajoExiste(int nro_legajo, int empresa_id)
        {
            bool result;

            LegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            if( legajoRepo.ObtenerPorNro(empresa_id, nro_legajo)==null)
                result = false;
            else
                result = true;

            return Json(result);
        }



        [HttpPost]
        public ActionResult Importar(IFormFile file)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

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
            if (file != null && System.IO.Path.GetExtension(file.FileName).ToLower() == ".xlsx")
            {

                //string fileName = Path.GetFileName(file.FileName);

                string fileName = Path.GetFileNameWithoutExtension(file.FileName) + "_" + guid + System.IO.Path.GetExtension(file.FileName).ToLower();

                using (FileStream stream = new FileStream(Path.Combine(path, fileName), FileMode.Create))
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
                        fila++;
                        NovedadRepo novedadRepo = new NovedadRepo();
                        Novedad novedad = new Novedad();

                        string nro_legajo= dr[2].ToString();
                        try
                        {
                            int nleg = Int32.Parse(nro_legajo);

                        }
                        catch (Exception)
                        {
                            nro_legajo = "ERR";
                        }


                        int iUbicacion = -1;
                        int iCategoriaNovedad = -1;

                        string fecha_novedad;
                        try
                        {
                            DateTime f = DateTime.Parse(dr[7].ToString());
                            fecha_novedad = f.Year + "-" + f.Month.ToString().PadLeft(2, '0') + "-" + f.Day.ToString().PadLeft(2, '0');
                        }
                        catch (Exception)
                        {
                            fecha_novedad = "ERR";
                        }

                        string fecha_resolucion="";

                        if (dr[9].ToString() != "" ) {
                            try
                            {
                                DateTime f = DateTime.Parse(dr[9].ToString());
                                fecha_resolucion = f.Year + "-" + f.Month.ToString().PadLeft(2, '0') + "-" + f.Day.ToString().PadLeft(2, '0');
                            }
                            catch (Exception)
                            {
                                fecha_resolucion = "ERR";
                            }
                        }


                        switch (dr[0].ToString().ToUpper())
                        {
                            case "SANCION":
                                iCategoriaNovedad = 1;
                                break;
                            case "FELICITACION":
                                iCategoriaNovedad = 2;
                                break;
                            default:
                                iCategoriaNovedad = -1;
                                break;
                        }

                        switch (dr[3].ToString().ToUpper())
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
                            case "DEPOSITO":
                                iUbicacion = 4;
                                break;
                            default:
                                iUbicacion = -1;
                                break;
                        }



                        if (iUbicacion==-1)
                        {
                            worksheet.Cell(fila, "Z").Value = "Ubicación inválida";
                            errores++;
                        }
                        else if(iCategoriaNovedad == -1)
                        {
                            worksheet.Cell(fila, "Z").Value = "Categoría novedad inválida";
                            errores++;
                        }
                        else if (nro_legajo == "ERR")
                        {
                            worksheet.Cell(fila, "Z").Value = "Nro. de legajo inválido";
                            errores++;
                        }
                        else if (fecha_novedad == "ERR" || fecha_novedad == "")
                        {
                            worksheet.Cell(fila, "Z").Value = "Fecha novedad inválida";
                            errores++;
                        }
                        else if (fecha_resolucion == "ERR")
                        {
                            worksheet.Cell(fila, "Z").Value = "Fecha resolución inválida";
                            errores++;
                        }

                        else
                        {
                            string sError = "";
                            int ret = novedadRepo.ObtenerDeImportacion(
                                      dr[1].ToString(),
                                      dr[2].ToString(),
                                      iUbicacion.ToString(),
                                      dr[4].ToString(),
                                      dr[5].ToString(),
                                      dr[6].ToString(),
                                      iCategoriaNovedad.ToString(),
                                      dr[8].ToString(),
                                      fecha_novedad,
                                      dr[10].ToString(),
                                      fecha_resolucion,
                                      dr[11].ToString(),
                                      dr[12].ToString(),
                                      dr[14].ToString(),
                                      dr[13].ToString(),
                                      ref novedad
                                      );


                            if (ret < 0)
                            {
                                errores++;
                                switch (ret)
                                {
                                    case -1:
                                        sError = "El legajo no existe";
                                        break;

                                    case -2:
                                        sError = "Empresa inválida";
                                        break;

                                    case -3:
                                        sError = "Sector/Local inválido";
                                        break;


                                    case -4:
                                        sError = "Responsable inválido";
                                        break;


                                    case -5:
                                        sError = "Tipo de novedad inválido";
                                        break;


                                    case -6:
                                        sError = "Tipo de resolución inválido";
                                        break;


                                    case -7:
                                        sError = "Error en tipo/fecha resolución";
                                        break;

                                    default:
                                        sError = "Error";
                                        break;
                                }

                                // ViewBag.Message = "ERROR";
                                worksheet.Cell(fila, "Z").Value = sError;
                            }
                            else
                            {
                                if (novedadRepo.Insertar(novedad, usuario_id.Value) == "")
                                {
                                    // ViewBag.Message = "OK";
                                    worksheet.Cell(fila, "Z").Value = "OK";
                                }
                                else
                                {
                                    ViewBag.Message = "ERROR";
                                    worksheet.Cell(fila, "Z").Value = "ERROR";
                                }
                            }
                        }
                       

                       
                    }

                    workbook.Save();

                    Importacion imp = new Importacion();
                    IImportacionRepo importacionRepo;

                    importacionRepo = new ImportacionRepo();

                    imp.tipo = "N";
                    imp.nombre_archivo = Path.Combine("\\Uploads", fileName);
                    imp.cantidad = fila - 1;
                    imp.errores = errores;

                    importacionRepo.Insertar(imp);

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



    }
}
