using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LiquidacionController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LiquidacionController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }

        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (usuario_id == null || perfil_id == 5 || perfil_id == 6) return RedirectToAction("Login", "Usuario");


            if (perfil_id == 1 || perfil_id == 2)
            {
                ILiquidacionRepo liqRepo;

                liqRepo = new LiquidacionRepo();

                return View(liqRepo.ObtenerTodos());
            }

            return RedirectToAction("Login", "Usuario");
        }

        public IActionResult Cerrar()
        {

            string sret;

            ILiquidacionRepo liqRepo;
            liqRepo = new LiquidacionRepo();

            sret = liqRepo.Cerrar(-1);


            if (sret == "")
            {

                return RedirectToAction("Index", "Liquidacion");
            }
            else
            {
                TempData["Message"] = sret;
                return RedirectToAction("Index", "Liquidacion");
            }

        }



        [HttpGet]
        public IActionResult Edit(Int64 id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (id > 0)
            {
                ILiquidacionRepo liqRepo;

                liqRepo = new LiquidacionRepo();

                Liquidacion liq = new Liquidacion();

                liq = liqRepo.Obtener(id);

                ViewData["ID"] = id;

                return View(liq);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(Int64 id, Liquidacion liq)
        {

            string sret;

            ILiquidacionRepo liqRepo;

            //if (ModelState.IsValid)
            //{

            liqRepo = new LiquidacionRepo();

           
            sret = liqRepo.Modificar(liq);

            if (sret == "")
            {

                return RedirectToAction("Index", "Liquidacion");
            }
            else
            {
                ViewBag.Message = sret;
            }

            // }

            return View(liq);
        }




    }
}
