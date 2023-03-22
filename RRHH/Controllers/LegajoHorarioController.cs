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


        public IActionResult Index(int legajo_id, int nro_item)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;




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


                IEnumerable<LegajoHorario> detalle;

                detalle = legajoHorarioRepo.ObtenerPorLegajo(legajo_id);



                return View(detalle);

            }



            return View();


        }



        [HttpGet]
        public IActionResult Edit(int? id, int legajo_id, string origen, string modo, int nro_item)
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



        public Boolean valida(LegajoHorario legajoHorario, ref string mensaje)
        {


            if (legajoHorario.desde == "" || legajoHorario.hasta == "") return false;



            return true;

        }

    }
}
