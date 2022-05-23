using Microsoft.AspNetCore.Mvc;

namespace RRHH.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            return View();
        }
    }
}
