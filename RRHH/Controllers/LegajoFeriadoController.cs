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
    public class LegajoFeriadoController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        //static readonly int cantPag = int.Parse(Tools.GetPaginacionNovedad());

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LegajoFeriadoController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Index(int feriado_id)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ILegajoFeriadoRepo legajoFeriadoRepo;

                legajoFeriadoRepo = new LegajoFeriadoRepo();

                ViewData["FERIADO_ID"] = feriado_id;

                return View(legajoFeriadoRepo.ObtenerTodos(feriado_id));
            }

            return RedirectToAction("Login", "Usuario");


        }




        [HttpGet]
        public IActionResult Edit(int? id, int? nro_legajo, int? empresa_id, int? ubicacion_id, int? sector_id, int? local_id, string origen, int? legajo_id, string modo, int feriado_id, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            LegajoFeriado legajoFeriado = new LegajoFeriado();

            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["MODO"] = "A";

            ViewData["FERIADO_ID"] = feriado_id;


            return View(null);
           


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, string legajos, LegajoFeriado legajoFeriado, string origen, int feriado_id, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ILegajoFeriadoRepo legajoFeriadoRepo;

            legajoFeriadoRepo = new LegajoFeriadoRepo();

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;


            ViewData["MODO"] = (modo == null) ? "E" : modo;

            ViewData["UBICACION_ID"] = legajoFeriado.ubicacion_id;
            ViewData["SECTOR_ID"] = legajoFeriado.sector_id;
            ViewData["FERIADO_ID"] = feriado_id;

            string mensaje = "";

            if (legajoFeriado.legajo_id != null && (legajos == null || legajos == ""))
            {
                legajoFeriado.feriado_id = feriado_id;
                sret = legajoFeriadoRepo.Insertar(legajoFeriado);
            }
            else
            {
                string[] legajos_id = legajos.Split(',');

                foreach (string s in legajos_id)
                {
                    legajoFeriado.legajo_id = Int32.Parse(s);
                    legajoFeriado.feriado_id = feriado_id;

                    sret = legajoFeriadoRepo.Insertar(legajoFeriado);
                    if (sret != "")
                    {

                        ViewBag.Message = sret;
                    }
                }
            }



            if (sret == "")
            {

                return RedirectToAction("Index", "LegajoFeriado", new { item_actual = ViewData["ITEM_ACTUAL"], feriado_id = ViewData["FERIADO_ID"] });


            }
            else
            {
                ViewBag.Message = mensaje;
            }

            ViewData["EMPRESA_ID"] = legajoFeriado.empresa_id;
            ViewData["NRO_LEGAJO"] = legajoFeriado.nro_legajo;
            ViewData["FiltroLegajoFeriadoActual"] = legajoFeriado.nro_legajo;
            ViewData["EmpleadoActual"] = legajoFeriado.legajo_id;
            ViewData["Legajos"] = legajoFeriado.legajos;
            ViewData["LegajoActual"] = legajoFeriado.nro_legajo;

            return View(legajoFeriado);
        }




        [HttpPost]
        public IActionResult Delete(int hfID, int feriado_id)
        {

            string sret;

            //ViewData["ITEM_ACTUAL"] = nro_item;

            ILegajoFeriadoRepo legajoFeriadoRepo;
            legajoFeriadoRepo = new LegajoFeriadoRepo();




            sret = legajoFeriadoRepo.Eliminar(hfID);

            if (sret == "")
            {

                return RedirectToAction("Index", "LegajoFeriado", new { feriado_id = feriado_id });
            }
            else
            {
                ViewBag.Message = sret;
            }

            return View();
        }



    }
}
