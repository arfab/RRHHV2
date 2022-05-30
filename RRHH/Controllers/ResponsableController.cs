using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class ResponsableController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                IResponsableRepo responsableRepo;

                responsableRepo = new ResponsableRepo();

                return View(responsableRepo.ObtenerTodos());
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (id != null)
            {
                IResponsableRepo responsableRepo;

                responsableRepo = new ResponsableRepo();

                Responsable res = new Responsable();

                res = responsableRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(res);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }

    }
}
