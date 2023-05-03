using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class TurnoDesgloseHorasController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public TurnoDesgloseHorasController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
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
                ITurnoDesgloseHorasRepo turnoDesgloseHorasRepo;

                turnoDesgloseHorasRepo = new TurnoDesgloseHorasRepo();

                ITurnoRepo turnoRepo;

                turnoRepo = new TurnoRepo();

                Turno turno = new Turno();

                turno = turnoRepo.Obtener(turno_id);


                ViewData["TurnoActual"] = turno_id;
                ViewData["Turno"] = turno.descripcion;
                ViewData["Ubicacion"] = turno.ubicacion;


                IEnumerable<TurnoDesgloseHoras> detalle;

                detalle = turnoDesgloseHorasRepo.ObtenerTodos(turno_id);



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


            TurnoDesgloseHoras turnoDesgloseHoras = new TurnoDesgloseHoras();



            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["TurnoActual"] = turno_id;

            if (id != null)
            {
                ITurnoDesgloseHorasRepo turnoDesgloseHorasRepo;

                turnoDesgloseHorasRepo = new TurnoDesgloseHorasRepo();

                turnoDesgloseHoras = turnoDesgloseHorasRepo.Obtener(id.Value);

                if (turnoDesgloseHoras == null) return RedirectToAction("Index", "TurnoDesgloseHoras");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;


                ViewData["Turno"] = turnoDesgloseHoras.turno;
                ViewData["Ubicacion"] = turnoDesgloseHoras.ubicacion;


                return View(turnoDesgloseHoras);
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


                return View(turnoDesgloseHoras);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, int turno_id, TurnoDesgloseHoras turnoDesgloseHoras, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ITurnoDesgloseHorasRepo turnoDesgloseHorasRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["TurnoActual"] = turno_id;

            ViewData["Turno"] = turnoDesgloseHoras.turno;
            ViewData["Ubicacion"] = turnoDesgloseHoras.ubicacion;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            string mensaje = "";
            if (valida(turnoDesgloseHoras, ref mensaje))
            {



                turnoDesgloseHorasRepo = new TurnoDesgloseHorasRepo();

                if (modo == "E" || modo == null)
                    sret = turnoDesgloseHorasRepo.Modificar(turnoDesgloseHoras);
                else
                {
                    sret = turnoDesgloseHorasRepo.Insertar(turno_id, turnoDesgloseHoras);
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "TurnoDesgloseHoras", new { turno_id = turno_id });
                    else
                        return RedirectToAction("Index", "TurnoDesgloseHoras", new { turno_id = turno_id });

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }


            return View(turnoDesgloseHoras);
        }



        public IActionResult Delete(int hfID, string origen, int turno_id, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ITurnoDesgloseHorasRepo turnoDesgloseHorasRepo;

            turnoDesgloseHorasRepo = new TurnoDesgloseHorasRepo();

            turnoDesgloseHorasRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "TurnoDesgloseHoras", new { turno_id = turno_id });
            else
                return RedirectToAction("Index", "TurnoDesgloseHoras", new { turno_id = turno_id });

        }



        public Boolean valida(TurnoDesgloseHoras turnoDesgloseHoras, ref string mensaje)
        {


          



            return true;

        }
    }
}
