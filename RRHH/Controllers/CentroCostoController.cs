using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class CentroCostoController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ICentroCostoRepo centroCostoRepo;

                centroCostoRepo = new CentroCostoRepo();

                return View(centroCostoRepo.ObtenerTodos());
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
                ICentroCostoRepo centroCostoRepo;

                centroCostoRepo = new CentroCostoRepo();

                CentroCosto ccosto = new CentroCosto();

                ccosto = centroCostoRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(ccosto);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, CentroCosto centroCosto)
        {

            string sret;
            ICentroCostoRepo centroCostoRepo;

            if (ModelState.IsValid)
            {

                centroCostoRepo = new CentroCostoRepo();

                if (id != null)
                    sret = centroCostoRepo.Modificar(centroCosto);
                else
                    sret = centroCostoRepo.Insertar(centroCosto);

                if (sret == "")
                {

                    return RedirectToAction("Index", "CentroCosto");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(centroCosto);
        }

        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ICentroCostoRepo centroCostoRepo;

            centroCostoRepo = new CentroCostoRepo();

            centroCostoRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }
    }
}
