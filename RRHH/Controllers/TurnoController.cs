using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class TurnoController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();


        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public TurnoController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ITurnoRepo turnoRepo;

                turnoRepo = new TurnoRepo();

                ViewData["UBICACION_ID"] = -1;


                return View(turnoRepo.ObtenerTodos(-1));
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpPost]
        public IActionResult Buscar(int ubicacion_id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ITurnoRepo turnoRepo;

                turnoRepo = new TurnoRepo();

                ViewData["UBICACION_ID"] = ubicacion_id;


                return View("Index", turnoRepo.ObtenerTodos(ubicacion_id));
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            Turno turno = new Turno();

            if (id != null)
            {
                ITurnoRepo turnoRepo;

                turnoRepo = new TurnoRepo();

              
                turno = turnoRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(turno);
            }
            else
            {
                ViewData["ID"] = 0;
                return View(turno);
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, Turno turno)
        {

            string sret;
            ITurnoRepo turnoRepo;

            //if (ModelState.IsValid)
            //{

            turnoRepo = new TurnoRepo();

            if (id != null)
                sret = turnoRepo.Modificar(turno);
            else
                sret = turnoRepo.Insertar(turno);

            if (sret == "")
            {

                return RedirectToAction("Index", "Turno");
            }
            else
            {
                ViewBag.Message = sret;
            }

            // }

            return View(turno);
        }

        public IActionResult Delete(int hfID)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ITurnoRepo turnoRepo;

            turnoRepo = new TurnoRepo();

            sret = turnoRepo.Eliminar(hfID);


            if (sret == "")
            {

                return RedirectToAction("Index");
            }
            else
            {
                ViewBag.Message = sret;
            }

            return RedirectToAction("Index");

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
                parameters.Add("@empresa_id", -1);

                l = con.Query<Models.Ubicacion>("spUbicacionesObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Ubicacion(-1, "-- Seleccione el año --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }

        [HttpGet]
        public JsonResult ObtenerTipos()
        {
            List<Models.TipoFeriado> l = new List<Models.TipoFeriado>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.TipoFeriado>("spTipoFeriadoObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.TipoFeriado("TODOS", "-- Seleccione el tipo --", 1));

            return Json(new SelectList(l, "codigo", "descripcion"));


        }


        [HttpGet]
        public JsonResult ObtenerCantidadHoras(int turno_id)
        {
            List<Models.TipoCantidadHoras> l = new List<Models.TipoCantidadHoras> ();


            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@turno_id", turno_id);

                l = con.Query<Models.TipoCantidadHoras>("spTurnoObtenerCantidadHoras", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.TipoCantidadHoras(-1, "-- Seleccione la cantidad de horas --"));

            return Json(new SelectList(l, "id", "descripcion"));


        }


    }
}
