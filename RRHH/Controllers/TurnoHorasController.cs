using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class TurnoHorasController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public TurnoHorasController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Index(int turno_id, int nro_item)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;




            if (perfil_id > 0)
            {
                ITurnoHorasRepo turnoHorasRepo;

                turnoHorasRepo = new TurnoHorasRepo();

                ITurnoRepo turnoRepo;

                turnoRepo = new TurnoRepo();

                Turno turno = new Turno();

                turno = turnoRepo.Obtener(turno_id);


                ViewData["TurnoActual"] = turno_id;
                ViewData["Turno"] = turno.descripcion;
                ViewData["Ubicacion"] = turno.ubicacion;


                IEnumerable<TurnoHoras> detalle;

                detalle = turnoHorasRepo.ObtenerTodos(turno_id);



                return View(detalle);

            }



            return View();


        }



        [HttpGet]
        public IActionResult Edit(int? id, int turno_id, string origen, string modo, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            TurnoHoras turnoHoras = new TurnoHoras();



            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["TurnoActual"] = turno_id;

            if (id != null)
            {
                ITurnoHorasRepo turnoHorasRepo;

                turnoHorasRepo = new TurnoHorasRepo();

                turnoHoras = turnoHorasRepo.Obtener(id.Value);

                if (turnoHoras == null) return RedirectToAction("Index", "TurnoHoras");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

  
                ViewData["Turno"] = turnoHoras.turno;
                ViewData["Ubicacion"] = turnoHoras.ubicacion;


                return View(turnoHoras);
            }
            else
            {

                Turno turno = new Turno();
                ITurnoRepo turnoRepo;
                turnoRepo = new TurnoRepo();
                turno = turnoRepo.Obtener(turno_id);


                ViewData["TurnoActual"] = turno_id;
                ViewData["Turno"] = turno.descripcion;
                ViewData["Ubicacion"] = turno.ubicacion;

                ViewData["MODO"] = "A";


                return View(turnoHoras);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, int turno_id, TurnoHoras turnoHoras, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ITurnoHorasRepo turnoHorasRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["TurnoActual"] = turno_id;

            ViewData["Turno"] = turnoHoras.turno;
            ViewData["Ubicacion"] = turnoHoras.ubicacion;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            string mensaje = "";
            if (valida(turnoHoras, ref mensaje))
            {



                turnoHorasRepo = new TurnoHorasRepo();

                if (modo == "E" || modo == null)
                    sret = turnoHorasRepo.Modificar(turnoHoras);
                else
                {
                    sret = turnoHorasRepo.Insertar(turno_id, turnoHoras);
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "TurnoHoras", new { turno_id = turno_id });
                    else
                        return RedirectToAction("Index", "TurnoHoras", new { turno_id = turno_id });

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }


            return View(turnoHoras);
        }



        public IActionResult Delete(int hfID, string origen, int turno_id, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ITurnoHorasRepo turnoHorasRepo;

            turnoHorasRepo = new TurnoHorasRepo();

            turnoHorasRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "TurnoHoras", new { turno_id = turno_id });
            else
                return RedirectToAction("Index", "TurnoHoras", new { turno_id = turno_id });

        }



        public Boolean valida(TurnoHoras turnoHoras, ref string mensaje)
        {


            if (turnoHoras.tipo =="") return false;



            return true;

        }



    }
}
