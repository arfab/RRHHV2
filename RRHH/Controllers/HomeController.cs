using Microsoft.AspNetCore.Mvc;
using RRHH.Models;
using RRHH.Repository;

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

        public IActionResult Menu()
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            IEnumerable<Web> webs;

            webs = (IEnumerable<Web>)usuarioRepo.ObtenerWebs(usuario_id);

            return View(webs);
        }
    }
}
