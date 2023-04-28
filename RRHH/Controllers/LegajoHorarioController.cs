using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LegajoHorarioController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LegajoHorarioController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Index(int legajo_id, int nro_item, int? mostrarAlta, string? mensaje)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            DateTime fecha_desde;

            if (HttpContext.Session.GetString("FECHA_HORARIO_DESDE") != null && HttpContext.Session.GetString("FECHA_HORARIO_DESDE") != "")
                fecha_desde = Convert.ToDateTime(HttpContext.Session.GetString("FECHA_HORARIO_DESDE"));
            else
                fecha_desde = DateTime.Now.Date;


            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["MOSTRAR_ALTA"] = (mostrarAlta==null||mostrarAlta==0?0:1);

            ViewData["FechaDesdeActual"] = fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year;

          

            if (perfil_id > 0)
            {
                ILegajoHorarioRepo legajoHorarioRepo;

                legajoHorarioRepo = new LegajoHorarioRepo();

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                Legajo legajo = new Legajo();

                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;
                ViewData["NroLegajoActual"] = legajo.nro_legajo;

                ViewData["Semana"] = legajoHorarioRepo.Semana(fecha_desde);

                IEnumerable <LegajoHorario> detalle;

                detalle = legajoHorarioRepo.ObtenerPorLegajo(legajo_id, fecha_desde);

                ViewBag.Message =  mensaje;

                return View(detalle);

            }

           

            return View();


        }

        [HttpPost]
        public IActionResult Buscar(int legajo_id, DateTime fecha_desde)
        {


            HttpContext.Session.SetString("FECHA_HORARIO_DESDE", "");

            HttpContext.Session.SetString("FECHA_HORARIO_DESDE", fecha_desde.Day.ToString().PadLeft(2, '0') + "/" + fecha_desde.Month.ToString().PadLeft(2, '0') + "/" + fecha_desde.Year);


            return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id, desde = "busqueda" }); 

        }

        [HttpPost]
        public IActionResult Grabar(int legajo_id, int concepto, DateTime fecha, string desde, string hasta, int estado, int mostrarAlta)
        {

            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ILegajoHorarioRepo legajoHorarioRepo;
            legajoHorarioRepo = new LegajoHorarioRepo();
            LegajoHorario legajoHorario = new LegajoHorario();

            legajoHorario.legajo_id = legajo_id;
            legajoHorario.concepto = concepto;
            legajoHorario.fecha = fecha;
            legajoHorario.desde = desde;
            legajoHorario.hasta = hasta;
            legajoHorario.estado = estado;
            legajoHorario.usuario_id = usuario_id;


            string mensaje = "";
            if (valida(legajoHorario, ref mensaje))
            {


                sret = legajoHorarioRepo.Insertar(legajo_id, legajoHorario);


                if (sret == "")
                {
                        return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id, mostrarAlta= mostrarAlta });
                }
                else
                {
                   mensaje = sret;
                }

            }
            else
            {
                ViewBag.Message = mensaje;
            }

            return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id, mostrarAlta = mostrarAlta, mensaje=mensaje});

         //  return View(legajoHorario);

        }

        [HttpGet]
        public IActionResult Edit(int? id, int legajo_id, string origen, string modo, int nro_item, string fecha)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && perfil_id != 5 && perfil_id != 6 && modo != "V") return RedirectToAction("Login", "Usuario");




            LegajoHorario legajoHorario = new LegajoHorario();



            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["EmpleadoActual"] = legajo_id;

            if (id != null)
            {
                ILegajoHorarioRepo legajoHorarioRepo;

                legajoHorarioRepo = new LegajoHorarioRepo();

                legajoHorario = legajoHorarioRepo.Obtener(id.Value);

                if (legajoHorario == null) return RedirectToAction("Index", "LegajoHorario");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                Legajo legajo = new Legajo();

                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;



                return View(legajoHorario);
            }
            else
            {

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();
                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;

                ViewData["MODO"] = "A";


                return View(legajoHorario);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, int legajo_id, LegajoHorario legajoHorario, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ILegajoHorarioRepo legajoHorarioRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["EmpleadoActual"] = legajo_id;
            ViewData["ApellidoActual"] = legajoHorario.apellido;
            ViewData["NombreActual"] = legajoHorario.nombre;

            legajoHorario.usuario_id = usuario_id;

            ViewData["MODO"] = (modo == null) ? "E" : modo;

            string mensaje = "";
            if (valida(legajoHorario, ref mensaje))
            {



                legajoHorarioRepo = new LegajoHorarioRepo();

                if (modo == "E" || modo == null)
                    sret = legajoHorarioRepo.Modificar(legajoHorario);
                else
                {
                    sret = legajoHorarioRepo.Insertar(legajo_id, legajoHorario);
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id });
                    else
                        return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id });

                }
                else
                {
                    ViewBag.Message = sret;
                }

            }
            else
            {
                ViewBag.Message = mensaje;
            }


            return View(legajoHorario);
        }



        public IActionResult Delete(int hfID, string origen, int legajo_id, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ILegajoHorarioRepo legajoHorarioRepo;

            legajoHorarioRepo = new LegajoHorarioRepo();

            legajoHorarioRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id });
            else
                return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id });

        }

        [HttpPost]
        public IActionResult CopiarSemana(int legajo_id, DateTime fecha_desde)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ILegajoHorarioRepo legajoHorarioRepo;

            legajoHorarioRepo = new LegajoHorarioRepo();

            legajoHorarioRepo.CopiarSemana(legajo_id, fecha_desde);


            return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id });


        }

        [HttpPost]
        public IActionResult ValidarSemana(int legajo_id, DateTime fecha_desde)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ILegajoHorarioRepo legajoHorarioRepo;

            legajoHorarioRepo = new LegajoHorarioRepo();

            legajoHorarioRepo.ValidarSemana(legajo_id, fecha_desde);


            return RedirectToAction("Index", "LegajoHorario", new { legajo_id = legajo_id });


        }


        public Boolean valida(LegajoHorario legajoHorario, ref string mensaje)
        {


            if (legajoHorario.desde == "" || legajoHorario.hasta == "") return false;



            return true;

        }

    }
}
