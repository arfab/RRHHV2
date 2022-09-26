using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class FichadaOriginalController : Controller
    {
        public IActionResult Index(int legajo_id, string fecha)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IFichadaRepo fichadaRepo;

                fichadaRepo = new FichadaRepo();

                return View(fichadaRepo.ObtenerFichadasOriginales(legajo_id, fecha));
            }

            return RedirectToAction("Login", "Usuario");


        }

    }
}
