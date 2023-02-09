using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class TurnoDetalleController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public TurnoDetalleController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
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
                ITurnoDetalleRepo turnoDetalleRepo;

                turnoDetalleRepo = new TurnoDetalleRepo();

                ITurnoRepo turnoRepo;

                turnoRepo = new TurnoRepo();

                Turno turno = new Turno();

                turno = turnoRepo.Obtener(turno_id);


                ViewData["TurnoActual"] = turno_id;
                ViewData["Turno"] = turno.descripcion;
                ViewData["Ubicacion"] = turno.ubicacion;


                IEnumerable<TurnoDetalle> detalle;

                detalle = turnoDetalleRepo.ObtenerTodos(turno_id);



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


            TurnoDetalle turnoDetalle = new TurnoDetalle();



            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["TurnoActual"] = turno_id;

            if (id != null)
            {
                ITurnoDetalleRepo turnoDetalleRepo;

                turnoDetalleRepo = new TurnoDetalleRepo();

                turnoDetalle = turnoDetalleRepo.Obtener(id.Value);

                if (turnoDetalle == null) return RedirectToAction("Index", "TurnoDetalle");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

               


                ViewData["TIPO_HORA_ID"] = turnoDetalle.tipo_hora_id;
                ViewData["TIPO_DIA_ID"] = turnoDetalle.tipo_dia_semana_id;

                ViewData["Turno"] = turnoDetalle.turno;
                ViewData["Ubicacion"] = turnoDetalle.ubicacion;


                return View(turnoDetalle);
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
               

                return View(turnoDetalle);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, int turno_id,  TurnoDetalle turnoDetalle, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ITurnoDetalleRepo turnoDetalleRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["TurnoActual"] = turno_id;

            ViewData["Turno"] = turnoDetalle.turno;
            ViewData["Ubicacion"] = turnoDetalle.ubicacion;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            string mensaje = "";
            if (valida(turnoDetalle, ref mensaje))
            {

               

                turnoDetalleRepo = new TurnoDetalleRepo();

                if (modo == "E" || modo == null)
                    sret = turnoDetalleRepo.Modificar(turnoDetalle);
                else
                {
                     sret = turnoDetalleRepo.Insertar(turno_id, turnoDetalle);                  
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "TurnoDetalle", new { turno_id = turno_id });
                    else
                        return RedirectToAction("Index", "TurnoDetalle", new { turno_id = turno_id });

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }


            return View(turnoDetalle);
        }

        

        public IActionResult Delete(int hfID, string origen, int nro_item, int turno_id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ITurnoDetalleRepo turnoDetalleRepo;

            turnoDetalleRepo = new TurnoDetalleRepo();

            turnoDetalleRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "TurnoDetalle", new { turno_id = turno_id });
            else
                return RedirectToAction("Index", "TurnoDetalle", new { turno_id = turno_id });

        }



        public Boolean valida(TurnoDetalle turnoDetalle, ref string mensaje)
        {


            if (turnoDetalle.tipo_dia_semana_id <= 0) return false;



            return true;

        }


       

    }
}
