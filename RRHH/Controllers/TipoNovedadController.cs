using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class TipoNovedadController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ITipoNovedadRepo tipoNovedadRepo;

                tipoNovedadRepo = new TipoNovedadRepo();

                return View(tipoNovedadRepo.ObtenerTodos());
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
                ITipoNovedadRepo tipoNovedadRepo;

                tipoNovedadRepo = new TipoNovedadRepo();

                TipoNovedad tipo = new TipoNovedad();

                tipo = tipoNovedadRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(tipo);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, TipoNovedad tipoNovedad)
        {

            string sret;
            ITipoNovedadRepo tipoNovedadRepo;

            if (ModelState.IsValid)
            {

                tipoNovedadRepo = new TipoNovedadRepo();

                if (id != null)
                    sret = tipoNovedadRepo.Modificar(tipoNovedad);
                else
                    sret = tipoNovedadRepo.Insertar(tipoNovedad);

                if (sret == "")
                {

                    return RedirectToAction("Index", "TipoNovedad");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(tipoNovedad);
        }
    }
}
