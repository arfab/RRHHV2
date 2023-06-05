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

        public IActionResult Index(int perfil2_id)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            ViewData["PerfilActual"] = perfil2_id;

            if (perfil_id == 1 || perfil_id == 2)
            {
                IUsuarioRepo usuarioRepo;

                usuarioRepo = new UsuarioRepo();

                return View(usuarioRepo.ObtenerUsuarios(perfil_id.Value, perfil2_id));
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
            HttpContext.Session.SetString("USUARIO_LOCAL_ID", "");
            HttpContext.Session.SetString("USUARIO_LEGAJO_ID", "");

            HttpContext.Session.SetString("EMPRESA_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_ACTUAL", "");

            HttpContext.Session.SetString("CATEGORIA_NOVEDAD_ACTUAL", "");
            HttpContext.Session.SetString("TIPO_NOVEDAD_ACTUAL", "");
            HttpContext.Session.SetString("TIPO_RESOLUCION_ACTUAL", "");
            HttpContext.Session.SetString("CENTRO_COSTO_ACTUAL", "");
            HttpContext.Session.SetString("CENTROS_COSTO", "");

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

            HttpContext.Session.SetInt32("USUARIO_LOCAL_ID", -1);
 


            HttpContext.Session.SetInt32("PAG_LEGAJO", 1);

            HttpContext.Session.SetString("EMPRESA_ACTUAL_FICHADA", "");

            HttpContext.Session.SetString("APELLIDO_ACTUAL_FICHADA", "");
            HttpContext.Session.SetString("UBICACION_ACTUAL_FICHADA", "");
            HttpContext.Session.SetString("SECTOR_ACTUAL_FICHADA", "");
            HttpContext.Session.SetString("LECTORA_ACTUAL_FICHADA", "");

            HttpContext.Session.SetString("LEGAJO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetString("FECHA_FICHADA_DESDE", "");
            HttpContext.Session.SetString("FECHA_FICHADA_HASTA", "");

            HttpContext.Session.SetString("EMPLEADO_FICHADA_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_FICHADA_ACTUAL", "");

            HttpContext.Session.SetInt32("TIPO_LISTADO_ACTUAL", 0);


            HttpContext.Session.SetString("EMPRESA_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_HORARIO_ACTUAL", "");

            HttpContext.Session.SetString("FILTRO_HORARIO_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_HORARIO_ACTUAL", "");
            HttpContext.Session.SetString("TIPO_HORA_ACTUAL", "");

            HttpContext.Session.SetString("EMPRESA_REMOTO_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_REMOTO_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_REMOTO_ACTUAL", "");

            HttpContext.Session.SetString("FILTRO_REMOTO_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_REMOTO_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_REMOTO_ACTUAL", "");

            HttpContext.Session.SetString("EMPRESA_REMOTOEX_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_REMOTOEX_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_REMOTOEX_ACTUAL", "");

            HttpContext.Session.SetString("FILTRO_REMOTOEX_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_REMOTOEX_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_REMOTOEX_ACTUAL", "");

            HttpContext.Session.SetString("EMPRESA_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("UBICACION_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_TARDE_ACTUAL", "");
            HttpContext.Session.SetString("FECHA_TARDE_DESDE", "");
            HttpContext.Session.SetString("FECHA_TARDE_HASTA", "");
            HttpContext.Session.SetString("TARDE_DESDE", "");

            HttpContext.Session.SetString("EMPRESA_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("UBICACION_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_VERIFICACION_ACTUAL", "");
            HttpContext.Session.SetString("FECHA_VERIFICACION_DESDE", "");
            HttpContext.Session.SetString("FECHA_VERIFICACION_HASTA", "");
            HttpContext.Session.SetString("VERIFICACION_DESDE", "");

            HttpContext.Session.SetString("EMPRESA_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("UBICACION_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_VIATICOS_ACTUAL", "");
            HttpContext.Session.SetString("FECHA_VIATICOS_DESDE", "");
            HttpContext.Session.SetString("FECHA_VIATICOS_HASTA", "");
            HttpContext.Session.SetString("VIATICOS_DESDE", "");

            HttpContext.Session.SetString("EMPRESA_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("UBICACION_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_HSNOAUT_ACTUAL", "");
            HttpContext.Session.SetString("FECHA_HSNOAUT_DESDE", "");
            HttpContext.Session.SetString("FECHA_HSNOAUT_HASTA", "");

            HttpContext.Session.SetString("HSNOAUT_DESDE", "");
            HttpContext.Session.SetString("EMPRESA_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("UBICACION_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("LEGAJO_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("FILTRO_HFALTANTE_ACTUAL", "");
            HttpContext.Session.SetString("FECHA_HFALTANTE_DESDE", "");
            HttpContext.Session.SetString("FECHA_HFALTANTE_HASTA", "");
            HttpContext.Session.SetString("HFALTANTE_DESDE", "");

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
                HttpContext.Session.SetInt32("USUARIO_LOCAL_ID", usuario.local_id.Value);
                HttpContext.Session.SetInt32("USUARIO_LEGAJO_ID", usuario.legajo_id.Value);
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

                //if (usuario.perfil_id<=3)
                //{
                //    IFichadaRepo fichadaRepo;

                //    fichadaRepo = new FichadaRepo();

                //   // fichadaRepo.GenerarFichadas(1);

                //}

                if (usuario.perfil_id == 7)
                    return RedirectToAction("Fichar", "Usuario");
                else 
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
            ViewData["EmpleadoActual"] = usuario.legajo_id;

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
        public IActionResult Fichar()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? legajo_id = HttpContext.Session.GetInt32("USUARIO_LEGAJO_ID");
            if (legajo_id == 0) return RedirectToAction("Login", "Usuario");

            //DateTime? dEntrada;
            //DateTime? dSalida;

            int cantidadEntradas;
            int cantidadSalidas;

            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            //dEntrada = usuarioRepo.HomeOfficeObtenerEntrada(legajo_id.Value);
            //dSalida = usuarioRepo.HomeOfficeObtenerSalida(legajo_id.Value);

            cantidadEntradas = usuarioRepo.HomeOfficeObtenerCantidadEntradas(legajo_id.Value);
            cantidadSalidas = usuarioRepo.HomeOfficeObtenerCantidadSalidas(legajo_id.Value);

            //if (dEntrada != null && dEntrada.Value.Year!=1)
            //    ViewData["FechaEntrada"] = dEntrada.Value.ToString("HH:mm");
            //else
            //    ViewData["FechaEntrada"] = "";

            //if (dSalida != null && dSalida.Value.Year != 1)
            //    ViewData["FechaSalida"] = dSalida.Value.ToString("HH:mm");
            //else
            //    ViewData["FechaSalida"] = "";

            ViewData["legajo_id"] = legajo_id;
            ViewData["fecha"] = DateTime.Now.Date.Year.ToString() + '-' + DateTime.Now.Date.Month.ToString().PadLeft(2, '0') + '-' + DateTime.Now.Date.Day.ToString().PadLeft(2, '0');
            if (cantidadEntradas <= cantidadSalidas)
                ViewData["turno"] = "E";
            else
                ViewData["turno"] = "S";
            return View();
        }

        [HttpGet]
        public IActionResult FicharEntrada()
        {

            string sret;

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? legajo_id = HttpContext.Session.GetInt32("USUARIO_LEGAJO_ID");
            if (legajo_id == 0) return RedirectToAction("Login", "Usuario");


            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            sret = usuarioRepo.HomeOfficeFichar(legajo_id.Value, "E");

            if (sret == "")
            {

                return RedirectToAction("Fichar", "Usuario");
            }
            else
            {
                ViewBag.Message = sret;
            }


            return View();
        }


        [HttpGet]
        public IActionResult FicharSalida()
        {

            string sret;

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? legajo_id = HttpContext.Session.GetInt32("USUARIO_LEGAJO_ID");
            if (legajo_id == 0) return RedirectToAction("Login", "Usuario");

            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            sret = usuarioRepo.HomeOfficeFichar(legajo_id.Value, "S");

            if (sret == "")
            {

                return RedirectToAction("Fichar", "Usuario");
            }
            else
            {
                ViewBag.Message = sret;
            }


            return View();
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

                ViewData["UsuarioID"] = usuario_id;

                return View(usuarioRepo.ObtenerWebs(usuario_id));
            }

            return RedirectToAction("Login", "Usuario");


        }


        [HttpPost]
        public IActionResult InsertarWeb(string UsuarioID, string web_id, int perfil_id )
        {
            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            if (web_id != "-1" && perfil_id >0 )   usuarioRepo.InsertarWeb(UsuarioID, web_id, perfil_id);


            return RedirectToAction("Webs", "Usuario", new { usuario_id = UsuarioID });
        }

        //[HttpPost]
        //public IActionResult EliminarWeb(string UsuarioID, string web)
        //{
        //    IUsuarioRepo usuarioRepo;

        //    usuarioRepo = new UsuarioRepo();

        //    usuarioRepo.EliminarWeb(UsuarioID, web);


        //    return RedirectToAction("Webs", "Usuario", new { usuario_id = UsuarioID });
        //}

        [HttpPost]
        public IActionResult EliminarWeb(string hfUID, string hfWEB)
        {

            IUsuarioRepo usuarioRepo;

            usuarioRepo = new UsuarioRepo();

            usuarioRepo.EliminarWeb(hfUID, hfWEB);


            return RedirectToAction("Webs", "Usuario", new { usuario_id = hfUID });

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

            l.Insert(0, new Models.Web("-1", "-- Seleccione el sitio --"));

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

            return Json(new SelectList(l, "perfil_id", "descripcion"));
        }



        [HttpGet]
        public JsonResult HoraServidor()
        {
            DateTime d;

            using (IDbConnection con = new SqlConnection(strConnectionString))
            {
                if (con.State == ConnectionState.Closed)
                    con.Open();


                d = con.QuerySingle<DateTime>("select getdate()");
            }


            return Json(d.ToString());
        }

    }
}
