using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LegajoFrancoController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LegajoFrancoController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
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
                ILegajoFrancoRepo legajoFrancoRepo;

                legajoFrancoRepo = new LegajoFrancoRepo();

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                Legajo legajo = new Legajo();

                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;


                IEnumerable<LegajoFranco> detalle;

                detalle = legajoFrancoRepo.ObtenerPorLegajo(legajo_id);



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

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            LegajoFranco legajoFranco = new LegajoFranco();



            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["EmpleadoActual"] = legajo_id;

            if (id != null)
            {
                ILegajoFrancoRepo legajoFrancoRepo;

                legajoFrancoRepo = new LegajoFrancoRepo();

                legajoFranco = legajoFrancoRepo.Obtener(id.Value);

                if (legajoFranco == null) return RedirectToAction("Index", "LegajoFranco");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                Legajo legajo = new Legajo();

                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;



                return View(legajoFranco);
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


                return View(legajoFranco);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, int legajo_id, LegajoFranco legajoFranco, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ILegajoFrancoRepo legajoFrancoRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["EmpleadoActual"] = legajo_id;
            ViewData["ApellidoActual"] = legajoFranco.apellido;
            ViewData["NombreActual"] = legajoFranco.nombre;

            legajoFranco.usuario_id = usuario_id;

            ViewData["MODO"] = (modo == null) ? "E" : modo;

            string mensaje = "";
            if (valida(legajoFranco, ref mensaje))
            {



                legajoFrancoRepo = new LegajoFrancoRepo();

                if (modo == "E" || modo == null)
                    sret = legajoFrancoRepo.Modificar(legajoFranco);
                else
                {
                    sret = legajoFrancoRepo.Insertar(legajo_id, legajoFranco);
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "LegajoFranco", new { legajo_id = legajo_id });
                    else
                        return RedirectToAction("Index", "LegajoFranco", new { legajo_id = legajo_id });

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }


            return View(legajoFranco);
        }



        public IActionResult Delete(int hfID, string origen, int legajo_id, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ILegajoFrancoRepo legajoFrancoRepo;

            legajoFrancoRepo = new LegajoFrancoRepo();

            legajoFrancoRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "LegajoFranco", new { legajo_id = legajo_id });
            else
                return RedirectToAction("Index", "LegajoFranco", new { legajo_id = legajo_id });

        }



        public Boolean valida(LegajoFranco legajoFranco, ref string mensaje)
        {


            if (legajoFranco.completo == -1) return false;



            return true;

        }

    }
}
