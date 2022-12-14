using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;
using ClosedXML.Excel;
using SelectPdf;

namespace RRHH.Controllers
{
    public class RemotoExcepcionController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public RemotoExcepcionController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;

        }

        [HttpPost]
        public IActionResult Limpiar(int empresa_id, int legajo_id, string apellido, int ubicacion_id, int sector_id, int local_id)
        {


            HttpContext.Session.SetString("EMPRESA_REMOTOEX_ACTUAL", "");
            HttpContext.Session.SetString("EMPLEADO_REMOTOEX_ACTUAL", "");
            HttpContext.Session.SetString("APELLIDO_REMOTOEX_ACTUAL", "");

            HttpContext.Session.SetString("FILTRO_REMOTOEX_ACTUAL", "");

            HttpContext.Session.SetString("UBICACION_REMOTOEX_ACTUAL", "");
            HttpContext.Session.SetString("SECTOR_REMOTOEX_ACTUAL", "");


            return RedirectToAction("Index", "Remoto");

        }

        public IActionResult Index(int empresa_id, int legajo_id, string apellido, int ubicacion_id, int sector_id, int local_id, int dia_semana, string filtro, int nro_item)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;


            if (apellido != null) HttpContext.Session.SetString("APELLIDO_REMOTO_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_REMOTOEX_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_REMOTOEX_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_REMOTOEX_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_REMOTOEX_ACTUAL");

            if (HttpContext.Session.GetString("FILTRO_REMOTOEX_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_REMOTOEX_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPRESA_REMOTOEX_ACTUAL") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_REMOTOEX_ACTUAL");

            if (HttpContext.Session.GetInt32("UBICACION_REMOTOEX_ACTUAL") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_REMOTOEX_ACTUAL");

            if (HttpContext.Session.GetInt32("SECTOR_REMOTOEX_ACTUAL") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_REMOTOEX_ACTUAL");



            if (perfil_id > 0)
            {
                IRemotoExcepcionRepo remotoRepo;

                remotoRepo = new RemotoExcepcionRepo();


                ViewData["EmpresaActual"] = empresa_id;

                ViewData["UbicacionActual"] = ubicacion_id;
                ViewData["SectorActual"] = sector_id;
                ViewData["LocalActual"] = local_id;
                ViewData["ApellidoActual"] = apellido;
                ViewData["EmpleadoActual"] = legajo_id;

                ViewData["FiltroActual"] = filtro;



                IEnumerable<Remoto> remotos;


                remotos = remotoRepo.ObtenerTodos((empresa_id == 0) ? -1 : empresa_id, (legajo_id == 0) ? -1 : legajo_id, DateTime.Now, DateTime.Now, "");



                return View(remotos);

            }



            return View();


        }


        [HttpPost]
        public IActionResult Buscar(int empresa_id, int legajo_id, string apellido, int ubicacion_id, int sector_id, int local_id, int dia_semana, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_REMOTOEX_ACTUAL", empresa_id);
            HttpContext.Session.SetInt32("LEGAJO_REMOTOEX_ACTUAL", legajo_id);
            HttpContext.Session.SetString("APELLIDO_REMOTOEX_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_REMOTOEX_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_REMOTOEX_ACTUAL", (filtro == null) ? "" : filtro);

            HttpContext.Session.SetInt32("UBICACION_REMOTOEX_ACTUAL", ubicacion_id);
            HttpContext.Session.SetInt32("SECTOR_REMOTOEX_ACTUAL", sector_id);

            return RedirectToAction("Index", "Remoto", new { desde = "busqueda" });

        }






        [HttpGet]
        public IActionResult Edit(int? id, int? nro_legajo, int? empresa_id, int? ubicacion_id, int? sector_id, int? local_id, string origen, int? legajo_id, string modo, string fecha, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            Remoto remoto = new Remoto();

            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            if (id != null)
            {
                IRemotoExcepcionRepo remotoRepo;

                remotoRepo = new RemotoExcepcionRepo();

                remoto = remotoRepo.Obtener(id.Value);

                if (remoto == null) return RedirectToAction("Index", "Remoto");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                if (remoto.legajo_id != null)
                {
                    Legajo legajo = new Legajo();
                    ILegajoRepo legajoRepo;
                    legajoRepo = new LegajoRepo();
                    legajo = legajoRepo.Obtener(remoto.legajo_id.Value);

                    if (perfil_id == 4 && legajo.ubicacion_id != 3) return RedirectToAction("Index", "TipoHorario");

                    remoto.empresa_id = legajo.empresa_id;
                    remoto.nro_legajo = legajo.nro_legajo;

                }

                ViewData["EMPRESA_ID"] = remoto.empresa_id;
                ViewData["UBICACION_ID"] = remoto.ubicacion_id;
                ViewData["SECTOR_ID"] = remoto.sector_id;
                ViewData["NRO_LEGAJO"] = remoto.nro_legajo;

                ViewData["TIPO_DIA_ID"] = remoto.dia_semana;

                ViewData["FiltroActual"] = remoto.nro_legajo;
                ViewData["EmpleadoActual"] = remoto.legajo_id;
                ViewData["Legajos"] = remoto.legajos;

                return View(remoto);
            }
            else
            {
                //ViewData["ID"] = 0;
                ViewData["MODO"] = "A";

                if (fecha != null)
                {
                    remoto.fecha_desde = DateTime.Parse(fecha);
                    remoto.fecha_hasta = DateTime.Parse(fecha);
                }
                if (nro_legajo != null) remoto.nro_legajo = nro_legajo.Value;
                if (empresa_id != null) remoto.empresa_id = empresa_id.Value;
                if (ubicacion_id != null) remoto.ubicacion_id = ubicacion_id.Value;
                if (sector_id != null) remoto.sector_id = sector_id.Value;
                if (local_id != null) remoto.local_id = local_id.Value;
                if (legajo_id != null) remoto.legajo_id = legajo_id.Value;


                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;

                if (remoto.legajo_id != null)
                {
                    legajoRepo = new LegajoRepo();
                    legajo = legajoRepo.Obtener(legajo_id.Value);
                    if (legajo != null)
                    {
                        remoto.nro_legajo = legajo.nro_legajo.Value;
                        remoto.empresa_id = legajo.empresa_id.Value;

                    }
                }


                ViewData["EMPRESA_ID"] = remoto.empresa_id;
                ViewData["NRO_LEGAJO"] = remoto.nro_legajo;
                ViewData["FiltroActual"] = remoto.nro_legajo;
                ViewData["EmpleadoActual"] = remoto.legajo_id;
                ViewData["Legajos"] = remoto.legajos;


                return View(remoto);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, string legajos, Remoto vremoto, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            IRemotoExcepcionRepo remotoRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            ViewData["UBICACION_ID"] = vremoto.ubicacion_id;
            ViewData["SECTOR_ID"] = vremoto.sector_id;


            string mensaje = "";
            if (valida(vremoto, ref mensaje))
            {

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;

                if (vremoto.legajo_id != null)
                {
                    legajoRepo = new LegajoRepo();
                    legajo = legajoRepo.Obtener(vremoto.legajo_id.Value);
                    if (legajo != null)
                    {
                        vremoto.ubicacion_id = legajo.ubicacion_id.Value;

                    }
                }


                remotoRepo = new RemotoExcepcionRepo();

                if (modo == "E" || modo == null)
                    sret = remotoRepo.Modificar(vremoto);
                else
                {
                    if (legajos == null || legajos == "")
                        sret = remotoRepo.Insertar(vremoto);
                    else
                    {
                        string[] legajos_id = legajos.Split(',');

                        foreach (string s in legajos_id)
                        {
                            vremoto.legajo_id = Int32.Parse(s);
                            sret = remotoRepo.Insertar(vremoto);
                            if (sret != "")
                            {

                                ViewBag.Message = sret;
                            }
                        }
                    }
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "RemotoExcepcion");
                    else
                        return RedirectToAction("Index", "RemotoExcepcion");

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }

            ViewData["EMPRESA_ID"] = vremoto.empresa_id;
            ViewData["NRO_LEGAJO"] = vremoto.nro_legajo;
            ViewData["FiltroActual"] = vremoto.nro_legajo;
            ViewData["EmpleadoActual"] = vremoto.legajo_id;
            ViewData["Legajos"] = vremoto.legajos;
            ViewData["LegajoActual"] = vremoto.nro_legajo;

            return View(vremoto);
        }



        public IActionResult Delete(int hfID, string origen, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            IRemotoExcepcionRepo remotoRepo;

            remotoRepo = new RemotoExcepcionRepo();

            remotoRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "RemotoExcepcion");
            else
                return RedirectToAction("Index", "RemotoExcepcion");

        }



        public Boolean valida(Remoto vremoto, ref string mensaje)
        {



            return true;

        }



    }
}
