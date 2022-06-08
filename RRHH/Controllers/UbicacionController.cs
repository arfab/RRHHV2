using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class UbicacionController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                IUbicacionRepo ubicacionRepo;

                ubicacionRepo = new UbicacionRepo();

                return View(ubicacionRepo.ObtenerTodos());
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
                IUbicacionRepo ubicacionRepo;

                ubicacionRepo = new UbicacionRepo();

                Ubicacion ubi = new Ubicacion();

                ubi = ubicacionRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(ubi);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



       

    }
}
