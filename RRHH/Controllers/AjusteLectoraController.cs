using Microsoft.AspNetCore.Mvc;
using System.Data;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class AjusteLectoraController : Controller
    {
        public IActionResult Index(string fecha, int lectora_id)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ILectoraRepo lectoraRepo;

                lectoraRepo = new LectoraRepo();

                return View(lectoraRepo.ObtenerAjustes(fecha, lectora_id));
            }

            return RedirectToAction("Login", "Usuario");
        }
    }
}
