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
    public class TipoHorarioController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public TipoHorarioController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


            HttpContext.Session.SetString("EMPRESA_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_HORARIO_ACTUAL", "");

            HttpContext.Session.SetString("FILTRO_HORARIO_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("TIPO_HORA_ACTUAL", "");

            return RedirectToAction("Index", "TipoHorario");


        }

        public IActionResult Index( int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, int tipo_hora_id, int legajo_id, string filtro, int nro_item)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;


            if (apellido != null) HttpContext.Session.SetString("APELLIDO_HORARIO_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_HORARIO_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_HORARIO_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_HORARIO_ACTUAL");
            
            if (HttpContext.Session.GetString("FILTRO_HORARIO_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPRESA_HORARIO_ACTUAL") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("UBICACION_HORARIO_ACTUAL") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("SECTOR_HORARIO_ACTUAL") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("TIPO_HORA_ACTUAL") != null) tipo_hora_id = (int)HttpContext.Session.GetInt32("TIPO_HORA_ACTUAL");



            if (perfil_id > 0)
            {
                ITipoHorarioRepo tipoHorarioRepo;

                tipoHorarioRepo = new TipoHorarioRepo();


                ViewData["EmpresaActual"] = empresa_id;

                ViewData["UbicacionActual"] = ubicacion_id;
                ViewData["SectorActual"] = sector_id;
                ViewData["LocalActual"] = local_id;
                ViewData["ApellidoActual"] = apellido;
                ViewData["TipoHoraActual"] = tipo_hora_id;
                ViewData["EmpleadoActual"] = legajo_id;

                ViewData["FiltroJustificacionActual"] = filtro;
                
                /*
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
               */




                IEnumerable<TipoHorario> horarios;

                horarios = tipoHorarioRepo.ObtenerTodos((ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (legajo_id == 0) ? -1 : legajo_id, (tipo_hora_id == 0) ? -1 : tipo_hora_id);


              
                return View(horarios);

            }



            return View();


        }


        [HttpPost]
        public IActionResult Buscar( int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, int tipo_hora_id, int legajo_id, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_HORARIO_ACTUAL", empresa_id);
            HttpContext.Session.SetInt32("LEGAJO_HORARIO_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_HORARIO_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_HORARIO_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_HORARIO_ACTUAL", (filtro == null) ? "" : filtro);

            HttpContext.Session.SetInt32("UBICACION_HORARIO_ACTUAL", ubicacion_id);
            HttpContext.Session.SetInt32("SECTOR_HORARIO_ACTUAL", sector_id);
            HttpContext.Session.SetInt32("TIPO_HORA_ACTUAL", tipo_hora_id);


            return RedirectToAction("Index", "TipoHorario", new { desde = "busqueda" });

        }


        [HttpGet]
        public IActionResult Edit(int? id, int? nro_legajo, int? empresa_id, int? ubicacion_id, int? sector_id, int? local_id, string origen, int? legajo_id, string modo, string fecha, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            TipoHorario tipoHorario = new TipoHorario();

            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            if (id != null)
            {
                ITipoHorarioRepo tipoHorarioRepo;

                tipoHorarioRepo = new TipoHorarioRepo();

                tipoHorario = tipoHorarioRepo.Obtener(id.Value);

                if (tipoHorario == null) return RedirectToAction("Index", "TipoHorario");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                if (tipoHorario.legajo_id != null)
                {
                    Legajo legajo = new Legajo();
                    ILegajoRepo legajoRepo;
                    legajoRepo = new LegajoRepo();
                    legajo = legajoRepo.Obtener(tipoHorario.legajo_id.Value);

                    if (perfil_id == 4 && legajo.ubicacion_id != 3) return RedirectToAction("Index", "TipoHorario");

                    tipoHorario.empresa_id = legajo.empresa_id;
                    tipoHorario.nro_legajo = legajo.nro_legajo;

                }

                ViewData["EMPRESA_ID"] = tipoHorario.empresa_id;
                ViewData["UBICACION_ID"] = tipoHorario.ubicacion_id;
                ViewData["SECTOR_ID"] = tipoHorario.sector_id;
                ViewData["NRO_LEGAJO"] = tipoHorario.nro_legajo;

                ViewData["TIPO_HORA_ID"] = tipoHorario.tipo_hora_id;
                ViewData["TIPO_DIA_ID"] = tipoHorario.tipo_dia_semana_id;

                ViewData["FiltroJustificacionActual"] = tipoHorario.nro_legajo;
                ViewData["EmpleadoActual"] = tipoHorario.legajo_id;
                ViewData["Legajos"] = tipoHorario.legajos;

                return View(tipoHorario);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";

                if (fecha != null)
                {
                    tipoHorario.fecha_desde = DateTime.Parse(fecha);
                    tipoHorario.fecha_hasta = DateTime.Parse(fecha);
                }
                if (nro_legajo != null) tipoHorario.nro_legajo = nro_legajo.Value;
                if (empresa_id != null) tipoHorario.empresa_id = empresa_id.Value;
                if (ubicacion_id != null) tipoHorario.ubicacion_id = ubicacion_id.Value;
                if (sector_id != null) tipoHorario.sector_id = sector_id.Value;
                if (local_id != null) tipoHorario.local_id = local_id.Value;
                if (legajo_id != null) tipoHorario.legajo_id = legajo_id.Value;

               
                 Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;

                if (tipoHorario.legajo_id != null)
                {
                    legajoRepo = new LegajoRepo();
                    legajo = legajoRepo.Obtener(legajo_id.Value);
                    if (legajo != null)
                    {
                        tipoHorario.nro_legajo = legajo.nro_legajo.Value;
                        tipoHorario.empresa_id = legajo.empresa_id.Value;

                    }
                }

               
                    ViewData["EMPRESA_ID"] = tipoHorario.empresa_id;
                    ViewData["NRO_LEGAJO"] = tipoHorario.nro_legajo;
                    ViewData["FiltroJustificacionActual"] = tipoHorario.nro_legajo;
                    ViewData["EmpleadoActual"] = tipoHorario.legajo_id;
                    ViewData["Legajos"] = tipoHorario.legajos;
   

                return View(tipoHorario);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, string legajos, TipoHorario tipoHorario, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ITipoHorarioRepo tipoHorarioRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            ViewData["UBICACION_ID"] = tipoHorario.ubicacion_id;
            ViewData["SECTOR_ID"] = tipoHorario.sector_id;


            string mensaje = "";
            if (valida(tipoHorario, ref mensaje))
            {


                tipoHorarioRepo = new TipoHorarioRepo();

                if (modo == "E" || modo == null)
                    sret = tipoHorarioRepo.Modificar(tipoHorario);
                else
                {
                    if (legajos == null || legajos == "")
                        sret = tipoHorarioRepo.Insertar(tipoHorario);
                    else
                    {
                        string[] legajos_id = legajos.Split(',');

                        foreach (string s in legajos_id)
                        {
                            tipoHorario.legajo_id = Int32.Parse(s);
                            sret = tipoHorarioRepo.Insertar(tipoHorario);
                            if (sret != "")
                            {

                                ViewBag.Message = sret;
                            }
                        }
                    }
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "TipoHorario");
                    else
                        return RedirectToAction("Index", "TipoHorario");

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }

            ViewData["EMPRESA_ID"] = tipoHorario.empresa_id;
            ViewData["NRO_LEGAJO"] = tipoHorario.nro_legajo;
            ViewData["FiltroJustificacionActual"] = tipoHorario.nro_legajo;
            ViewData["EmpleadoActual"] = tipoHorario.legajo_id;
            ViewData["Legajos"] = tipoHorario.legajos;
            ViewData["LegajoActual"] = tipoHorario.nro_legajo;

            return View(tipoHorario);
        }



        public IActionResult Delete(int hfID, string origen, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ITipoHorarioRepo tipoHorarioRepo;

            tipoHorarioRepo = new TipoHorarioRepo();

            tipoHorarioRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "TipoHorario");
            else
                return RedirectToAction("Index", "TipoHorario");

        }



        public Boolean valida(TipoHorario tipoHorario, ref string mensaje)
        {

          
            if (tipoHorario.tipo_dia_semana_id <= 0) return false;



            return true;

        }


        [HttpGet]
        public JsonResult ObtenerTiposHora()
        {
            List<Models.TipoHora> l = new List<Models.TipoHora>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                l = con.Query<Models.TipoHora>("spTipoHoraObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.TipoHora(-1, "-- Seleccione el tipo de hora --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }


        [HttpGet]
        public JsonResult ObtenerTiposDiaSemana()
        {
            List<Models.TipoDiaSemana> l = new List<Models.TipoDiaSemana>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                l = con.Query<Models.TipoDiaSemana>("spTipoDiaSemanaObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.TipoDiaSemana(-1, "-- Seleccione el tipo de día de semana --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }

    }
}
