using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class NovedadController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        public IActionResult Index(int categoria_novedad_id, int tipo_novedad_id, int tipo_resolucion_id, int nro_legajo)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                ViewData["CategoriaNovedadActual"] = categoria_novedad_id;
                ViewData["TipoNovedadActual"] = tipo_novedad_id;
                ViewData["TipoResolucionActual"] = tipo_resolucion_id;
                ViewData["LegajoActual"] = nro_legajo;

                return View(novedadRepo.ObtenerTodos((categoria_novedad_id==0)?-1:categoria_novedad_id, (tipo_novedad_id == 0) ? -1 : tipo_novedad_id, (tipo_resolucion_id == 0) ? -1 : tipo_resolucion_id, (nro_legajo == 0) ? -1 : nro_legajo));
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            Novedad novedad = new Novedad();

            if (id != null)
            {
                INovedadRepo novedadRepo;

                novedadRepo = new NovedadRepo();

                novedad = novedadRepo.Obtener(id.Value);

                //ViewData["ID"] = nro_legajo.Value;

                ViewData["MODO"] = "E";

                return View(novedad);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";
                return View(novedad);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, Novedad novedad)
        {

            string sret;
            INovedadRepo novedadRepo;

            ViewData["MODO"] = modo;

            //if (ModelState.IsValid)
            //{


                novedadRepo = new NovedadRepo();

                if (modo == "E")
                    sret = novedadRepo.Modificar(novedad);
                else
                    sret = novedadRepo.Insertar(novedad);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Novedad");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            //}
            return View(novedad);
        }


        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            INovedadRepo novedadRepo;

            novedadRepo = new NovedadRepo();

            novedadRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }


        [HttpGet]
        public JsonResult ObtenerCategoriasNovedad()
        {
            List<Models.CategoriaNovedad> l = new List<Models.CategoriaNovedad>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.CategoriaNovedad>("select * from categoria_novedad order by id", parameters).ToList();
            }


            l.Insert(0, new Models.CategoriaNovedad(-1, "-- Seleccione la categoría --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


        [HttpGet]
        public JsonResult ObtenerTiposNovedad()
        {
            List<Models.TipoNovedad> l = new List<Models.TipoNovedad>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.TipoNovedad>("select * from tipo_novedad order by id", parameters).ToList();
            }


            l.Insert(0, new Models.TipoNovedad(-1, "-- Seleccione el tipo de novedad --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


        [HttpGet]
        public JsonResult ObtenerTiposResolucion()
        {
            List<Models.TipoResolucion> l = new List<Models.TipoResolucion>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.TipoResolucion>("select * from tipo_resolucion order by id", parameters).ToList();
            }


            l.Insert(0, new Models.TipoResolucion(-1, "-- Seleccione el tipo de resolución --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


    }
}
