using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class FeriadoController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public FeriadoController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
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
                IFeriadoRepo feriadoRepo;

                feriadoRepo = new FeriadoRepo();

                ViewData["ANIO"] = -1;

                ViewData["TIPO"] = "-1";

                return View(feriadoRepo.ObtenerTodos(-1,"TODOS"));
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpPost]
        public IActionResult Buscar(int anio, string tipo)
        {
            if (tipo == null) tipo = "TODOS";

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IFeriadoRepo feriadoRepo;

                feriadoRepo = new FeriadoRepo();

                ViewData["ANIO"] = anio;

                ViewData["TIPO"] = tipo;

                return View("Index",feriadoRepo.ObtenerTodos(anio, tipo));
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (id != null)
            {
                IFeriadoRepo feriadoRepo;

                feriadoRepo = new FeriadoRepo();

                Feriado feriado = new Feriado();

                feriado = feriadoRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(feriado);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, Feriado feriado)
        {

            string sret;
            IFeriadoRepo feriadoRepo;

            string mensaje = "";
            if (valida(feriado, ref mensaje))
            {
                feriadoRepo = new FeriadoRepo();

            if (id != null)
                sret = feriadoRepo.Modificar(feriado);
            else
                sret = feriadoRepo.Insertar(feriado);

            if (sret == "")
            {

                return RedirectToAction("Index", "Feriado");
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

            return View(feriado);
        }

        public IActionResult Delete(int hfID)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            IFeriadoRepo feriadoRepo;

            feriadoRepo = new FeriadoRepo();

            sret = feriadoRepo.Eliminar(hfID);


            if (sret == "")
            {

                return RedirectToAction("Index");
            }
            else
            {
                ViewBag.Message = sret;
                TempData["Message"] = sret;
            }

            
            //return RedirectToAction("Action2");

            return RedirectToAction("Index");

        }



        [HttpGet]
        public JsonResult ObtenerAnios()
        {
            List<Models.Anio> l = new List<Models.Anio>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Anio>("spFeriadoObtenerAnios", commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.Anio(-1, "-- Seleccione el año --"));

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



        public Boolean valida(Feriado feriado, ref string mensaje)
        {


            if (feriado.tipo == "") { mensaje = "El tipo es obligario";  return false; };

            if (feriado.fecha == null) { mensaje = "La fecha es obligaria"; return false; };


            return true;

        }


    }
}
