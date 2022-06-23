using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class TipoResolucionController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ITipoResolucionRepo tipoResolucionRepo;

                tipoResolucionRepo = new TipoResolucionRepo();

                return View(tipoResolucionRepo.ObtenerTodos());
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
                ITipoResolucionRepo tipoResolucionRepo;

                tipoResolucionRepo = new TipoResolucionRepo();

                TipoResolucion tipo = new TipoResolucion();

                tipo = tipoResolucionRepo.Obtener(id.Value);

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
        public IActionResult Edit(int? id, TipoResolucion tipoResolucion)
        {

            string sret;
            ITipoResolucionRepo tipoResolucionRepo;

            if (ModelState.IsValid)
            {

                tipoResolucionRepo = new TipoResolucionRepo();

                if (id != null)
                    sret = tipoResolucionRepo.Modificar(tipoResolucion);
                else
                    sret = tipoResolucionRepo.Insertar(tipoResolucion);

                if (sret == "")
                {

                    return RedirectToAction("Index", "TipoResolucion");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(tipoResolucion);
        }

        public IActionResult Delete(int hfID)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ITipoResolucionRepo tipoResolucionRepo;

            tipoResolucionRepo = new TipoResolucionRepo();

            sret = tipoResolucionRepo.Eliminar(hfID);


            if (sret == "")
            {

                return RedirectToAction("Index");
            }
            else
            {
                ViewBag.Message = sret;
            }

            return RedirectToAction("Index");

        }

    }
}
