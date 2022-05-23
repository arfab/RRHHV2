using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LegajoController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                return View(legajoRepo.ObtenerTodos());
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? nro_legajo)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            Legajo legajo = new Legajo();

            if (nro_legajo != null)
            {
                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                legajo = legajoRepo.Obtener(nro_legajo.Value);

                //ViewData["ID"] = nro_legajo.Value;

                ViewData["MODO"] = "E";

                return View(legajo);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";
                return View(legajo);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? nro_legajo, Legajo legajo)
        {

            string sret;
            ILegajoRepo legajoRepo;

            ViewData["MODO"] = modo;

            if (ModelState.IsValid)
            {


                legajoRepo = new LegajoRepo();

                if (modo == "E")
                    sret = legajoRepo.Modificar(legajo);
                else
                    sret = legajoRepo.Insertar(legajo);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Legajo");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }
            return View(legajo);
        }


        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ILegajoRepo legajoRepo;

            legajoRepo = new LegajoRepo();

            legajoRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }



        [HttpGet]
        public JsonResult ObtenerSectores()
        {
            List<Models.Sector> l = new List<Models.Sector>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Sector>("select * from sector order by id", parameters).ToList();
            }


            l.Insert(0, new Models.Sector(-1, "-- Seleccione el sector --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public JsonResult ObtenerCategorias()
        {
            List<Models.Categoria> l = new List<Models.Categoria>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Categoria>("select * from categoria order by id", parameters).ToList();
            }


            l.Insert(0, new Models.Categoria(-1, "-- Seleccione la categoría --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }



    }
}
