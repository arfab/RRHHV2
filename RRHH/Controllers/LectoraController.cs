using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LectoraController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ILectoraRepo lectoraRepo;

                lectoraRepo = new LectoraRepo();

                return View(lectoraRepo.ObtenerTodos());
            }

            return RedirectToAction("Login", "Usuario");


        }
    }
}
