using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Models;
using RRHH.Repository;
using System.Data;
using System.Data.SqlClient;

namespace RRHH.Controllers
{
    public class UsuarioController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        private readonly IHttpContextAccessor _httpContextAccessor;

        public UsuarioController(IHttpContextAccessor httpContextAccessor)
        {
            this._httpContextAccessor = httpContextAccessor;
        }

        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IUsuarioRepo usuarioRepo;

                usuarioRepo = new UsuarioRepo();

                return View(usuarioRepo.ObtenerUsuarios(perfil_id.Value));
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpGet]
        public IActionResult Logout()
        {

            HttpContext.Session.SetString("UID", "");
            HttpContext.Session.SetString("USUARIO_ID", "");
            HttpContext.Session.SetString("APELLIDO", "");
            HttpContext.Session.SetString("NOMBRE", "");
            HttpContext.Session.SetString("PERFIL_ID", "");
            HttpContext.Session.SetString("ID", "");

            HttpContext.Session.SetString("EMPRESA_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_ACTUAL", "");

            HttpContext.Session.SetString("CATEGORIA_NOVEDAD_ACTUAL", "");
            HttpContext.Session.SetString("TIPO_NOVEDAD_ACTUAL", "");
            HttpContext.Session.SetString("TIPO_RESOLUCION_ACTUAL", "");


            HttpContext.Session.SetString("EMPLEADO_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_ACTUAL", "");


            HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE", "");
            HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA", "");

            HttpContext.Session.SetString("EMPRESA_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("LEGAJO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("APELLIDO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("UBICACION_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("SECTOR_ACTUAL_LEGAJO", "");

            HttpContext.Session.SetString("EMPLEADO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetString("FILTRO_ACTUAL_LEGAJO", "");
            HttpContext.Session.SetInt32("ACTIVO_ACTUAL_LEGAJO", -1);

            HttpContext.Session.SetInt32("PAG_LEGAJO", 1);

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


            


                HttpContext.Session.SetInt32("UID", usuario.id);

                HttpContext.Session.SetString("USUARIO_ID", usuario.UsuarioID);
                HttpContext.Session.SetString("APELLIDO", (string.IsNullOrEmpty(usuario.Apellido)) ? "" : usuario.Apellido);
                HttpContext.Session.SetString("NOMBRE", (string.IsNullOrEmpty(usuario.Nombre)) ? "" : usuario.Nombre);
                HttpContext.Session.SetInt32("PERFIL_ID", usuario.perfil_id);
                HttpContext.Session.SetString("PERFIL", usuario.perfil_descripcion);
                HttpContext.Session.SetInt32("ACTIVO_ACTUAL_LEGAJO", -1);

                HttpContext.Session.SetString("EMPRESA_ACTUAL", "");
                HttpContext.Session.SetString("LEGAJO_ACTUAL", "");
                HttpContext.Session.SetString("APELLIDO_ACTUAL", "");

                HttpContext.Session.SetString("CATEGORIA_NOVEDAD_ACTUAL", "");
                HttpContext.Session.SetString("TIPO_NOVEDAD_ACTUAL", "");
                HttpContext.Session.SetString("TIPO_RESOLUCION_ACTUAL", "");

                HttpContext.Session.SetString("FECHA_NOVEDAD_DESDE", "");
                HttpContext.Session.SetString("FECHA_NOVEDAD_HASTA", "");

                HttpContext.Session.SetString("EMPLEADO_ACTUAL", "");
                HttpContext.Session.SetString("FILTRO_ACTUAL", "");

                HttpContext.Session.SetString("EMPRESA_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("LEGAJO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("APELLIDO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("UBICACION_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("SECTOR_ACTUAL_LEGAJO", "");

                HttpContext.Session.SetString("EMPLEADO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetString("FILTRO_ACTUAL_LEGAJO", "");
                HttpContext.Session.SetInt32("ACTIVO_ACTUAL_LEGAJO", -1);

                HttpContext.Session.SetInt32("PAG_LEGAJO", 1);



                return RedirectToAction("Menu", "Home");
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

            ModelState.Remove("id");

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
            ModelState.Remove("id");

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
            ModelState.Remove("id");

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
            ModelState.Remove("id");

            if (ModelState.IsValid)
            {



                usuarioRepo = new UsuarioRepo();


                sret = usuarioRepo.CambiarClave(usuario);

                if (sret == "")
                {

                    return RedirectToAction("Login", "Usuario");
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


        [HttpGet]
        public JsonResult ObtenerPerfiles()
        {

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            List<Models.Perfil> l = new List<Models.Perfil>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();

                l = con.Query<Models.Perfil>("spPerfilObtenerTodos", commandType: CommandType.StoredProcedure).ToList();
            }

            if (perfil_id == 1)
            {
                l.Insert(0, new Models.Perfil(99, "Sin perfil en RRHH"));
            }

            l.Insert(0, new Models.Perfil(-1, "-- Seleccione el perfil --"));


            
                return Json(new SelectList(l, "id", "descripcion"));
        }

        [HttpGet]
        public IActionResult Webs(string usuario_id)
        {

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IUsuarioRepo usuarioRepo;

                usuarioRepo = new UsuarioRepo();

                return View(usuarioRepo.ObtenerWebs(usuario_id));
            }

            return RedirectToAction("Login", "Usuario");


        }



        public string Get(string key)
        {
            return Request.Cookies[key];
        }
        /// <summary>  
        /// set the cookie  
        /// </summary>  
        /// <param name="key">key (unique indentifier)</param>  
        /// <param name="value">value to store in cookie object</param>  
        /// <param name="expireTime">expiration time</param>  
        public void Set(string key, string value, int? expireTime)
        {
            CookieOptions option = new CookieOptions();
            if (expireTime.HasValue)
                option.Expires = DateTime.Now.AddMinutes(expireTime.Value);
            else
                option.Expires = DateTime.Now.AddMilliseconds(10);
            Response.Cookies.Append(key, value, option);
        }
        /// <summary>  
        /// Delete the key  
        /// </summary>  
        /// <param name="key">Key</param>  
        public void Remove(string key)
        {
            Response.Cookies.Delete(key);
        }


     


        public IActionResult IrASitio(string nombre, string url, string home)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id != null)
            {
                IUsuarioRepo usuarioRepo;
                usuarioRepo = new UsuarioRepo();

                string sGuid = Guid.NewGuid().ToString();

                Set("CGUID", sGuid, 10);


                usuarioRepo.ActalizarGUID(usuario_id, nombre, sGuid);

                return Redirect(url+home);
            }
            else
                return RedirectToAction("Login", "Usuario");

        }

        [HttpGet]
        public JsonResult ObtenerWebs()
        {
            List<Models.Web> l = new List<Models.Web>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                l = con.Query<Models.Web>("select nombre as id, nombre as descripcion from web").ToList();
            }


            return Json(new SelectList(l, "id", "descripcion"));


        }


        [HttpGet]
        public JsonResult ObtenerPerfilesWeb(string web)
        {
            List<Models.PerfilWeb> l = new List<Models.PerfilWeb>();

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();

                DynamicParameters parameters = new DynamicParameters();
                parameters.Add("@web", web);

                l = con.Query<Models.PerfilWeb>("spPerfilWebObtenerTodos", parameters, commandType: CommandType.StoredProcedure).ToList();
            }


            l.Insert(0, new Models.PerfilWeb(-1, "-- Seleccione el perfil --"));

            return Json(new SelectList(l, "id", "descripcion"));
        }


    }
}
