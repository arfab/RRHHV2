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

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ILiquidacionRepo liqRepo;

                liqRepo = new LiquidacionRepo();

                return View(liqRepo.ObtenerTodos());
            }

            return RedirectToAction("Login", "Usuario");
        }
    }
}
