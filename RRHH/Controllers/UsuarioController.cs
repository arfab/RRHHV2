using Microsoft.AspNetCore.Mvc;
using RRHH.Models;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class UsuarioController : Controller
    {


        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                IUsuarioRepo usuarioRepo;

                usuarioRepo = new UsuarioRepo();

                return View(usuarioRepo.ObtenerUsuarios());
            }

            return RedirectToAction("Index", "RRHH");


        }


        [HttpGet]
        public IActionResult Logout()
        {

            HttpContext.Session.SetString("USUARIO_ID", "");
            HttpContext.Session.SetString("APELLIDO", "");
            HttpContext.Session.SetString("NOMBRE", "");
            HttpContext.Session.SetString("PERFIL_ID", "");
            //HttpContext.Session.SetString("EMAIL", "");
            //HttpContext.Session.SetString("ID_ROL", "");
            //HttpContext.Session.SetString("ROL_CODIGO", "");
            //HttpContext.Session.SetString("ROL_DESCRIPCION", "");
            return RedirectToAction("Login", "Usuario");
        }


        [HttpGet]
        public IActionResult Login()
        {
            Usuario usuario = new Usuario();
            return View(usuario);
        }


        [HttpPost]
        public IActionResult Login([Bind] Usuario u)
        {

            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            Usuario usuario = new Usuario();

            usuario = usuarioRepo.Login(u.UsuarioID, u.clave);

            if (usuario != null)
            {
                HttpContext.Session.SetString("USUARIO_ID", usuario.UsuarioID);
                HttpContext.Session.SetString("APELLIDO", (string.IsNullOrEmpty(usuario.Apellido)) ? "" : usuario.Apellido);
                HttpContext.Session.SetString("NOMBRE", (string.IsNullOrEmpty(usuario.Nombre)) ? "" : usuario.Nombre);
                HttpContext.Session.SetInt32("PERFIL_ID", usuario.perfil_id);
                /*HttpContext.Session.SetInt32("ID_ROL", usuario.perfil_id);
                HttpContext.Session.SetString("ROL_CODIGO", (string.IsNullOrEmpty(usuario.rol_codigo)) ? "" : usuario.rol_codigo);
                HttpContext.Session.SetString("ROL_DESCRIPCION", (string.IsNullOrEmpty(usuario.rol_descripcion)) ? "" : usuario.rol_descripcion);*/


                return RedirectToAction("Index", "RRHH");
            }
            else
            {
                ViewBag.Message = "Error en Login";

                return View();
            }


        }



        [HttpGet]
        public IActionResult Registro()
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {

                var model = new Usuario();

                return View(model);
            }
            else
                return RedirectToAction("Login", "Usuario");

        }

        [HttpPost]
        public IActionResult Registro([Bind] Usuario usuario)
        {

            string sret;
            IUsuarioRepo usuarioRepo;

            if (ModelState.IsValid)
            {



                usuarioRepo = new UsuarioRepo();


                sret = usuarioRepo.Insertar(usuario);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Usuario");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(usuario);
        }


        [HttpGet]
        public IActionResult Edit(string UsuarioId)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            IUsuarioRepo usuarioRepo;
            usuarioRepo = new UsuarioRepo();

            Usuario usuario = new Usuario();

            usuario = usuarioRepo.ObtenerUsuario(UsuarioId);


            return View(usuario);
        }

        [HttpPost]
        public IActionResult Edit([Bind] Usuario usuario)
        {

            string sret;
            IUsuarioRepo usuarioRepo;

            ModelState.Remove("UsuarioID");
            ModelState.Remove("clave");

            if (ModelState.IsValid)
            {



                usuarioRepo = new UsuarioRepo();


                sret = usuarioRepo.Modificar(usuario);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Usuario");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(usuario);
        }


        [HttpGet]
        public IActionResult CambiarClave(string UsuarioId)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            IUsuarioRepo usuarioRepo;
            usuarioRepo = new UsuarioRepo();

            Usuario usuario = new Usuario();

            usuario = usuarioRepo.ObtenerUsuario(UsuarioId);

            usuario.clave = "";

            return View(usuario);
        }

        [HttpPost]
        public IActionResult CambiarClave([Bind] Usuario usuario)
        {

            string sret;
            IUsuarioRepo usuarioRepo;

            ModelState.Remove("UsuarioID");
            ModelState.Remove("perfil_id");

            if (ModelState.IsValid)
            {



                usuarioRepo = new UsuarioRepo();


                sret = usuarioRepo.CambiarClave(usuario);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Usuario");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(usuario);
        }


        [HttpGet]
        public IActionResult CambiarClavePersonal()
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            IUsuarioRepo usuarioRepo;
            usuarioRepo = new UsuarioRepo();

            Usuario usuario = new Usuario();

            usuario = usuarioRepo.ObtenerUsuario(usuario_id);

            usuario.clave = "";

            return View("CambiarClave", usuario);
        }

        [HttpPost]
        public IActionResult CambiarClavePersonal([Bind] Usuario usuario)
        {

            string sret;
            IUsuarioRepo usuarioRepo;

            ModelState.Remove("UsuarioID");
            ModelState.Remove("perfil_id");

            if (ModelState.IsValid)
            {



                usuarioRepo = new UsuarioRepo();


                sret = usuarioRepo.CambiarClave(usuario);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Dashboard");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View("CambiarClave", usuario);
        }

        public IActionResult Delete(string hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            usuarioRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }


    }
}
